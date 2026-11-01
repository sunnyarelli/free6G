# free6G

An open mobile network stack (core, RAN and UE) in one repository, built as a platform for 6G research.
The stack runs end to end today as **3GPP 5G SA (Rel-15 to Rel-17)**; each `6g-*` component is where 6G
(IMT-2030 / Rel-20) features are developed.

| Folder | What it is | Language |
|---|---|---|
| [`6g-core`](6g-core) | Core network: AMF, SMF, UPF, NRF, AUSF, UDM, UDR, PCF, NSSF, NEF, CHF, BSF, SCP, N3IWF, TNGF + web console | Go |
| [`6g-ran`](6g-ran) | gNB (CU/DU, full L1/L2/L3), runs with an SDR (USRP...) or the ZeroMQ virtual radio | C++17 |
| [`6g-ue`](6g-ue) | Software UE (5G SA), runs with an SDR or ZeroMQ | C++ |
| [`6g-sim`](6g-sim) | Simulated gNB + UE (no PHY), the quickest way to test the core | C++ |

Each component keeps its own license; see [NOTICE.md](NOTICE.md).

## Architecture

```
                         ┌────────────────────────── 6g-core ─────────────────────────┐
                         │  NRF  AUSF  UDM  UDR  PCF  NSSF  NEF  CHF  BSF  SCP  (SBI) │
   ┌─────────┐  ZMQ/RF   │  ┌─────┐  N2 (NGAP/SCTP 127.0.0.18:38412)                   │
   │ 6g-ue   │◄────────► │  │ AMF │◄──────────────┐                                    │
   │   UE    │           │  └─────┘               │  ┌─────┐ N4 ┌─────┐               │
   └─────────┘   ┌──────────┐                     │  │ SMF │────│ UPF │──► N6 internet │
                 │ 6g-ran   │─────────────────────┘  └─────┘    └─────┘               │
                 │   gNB    │────── N3 (GTP-U 127.0.0.8:2152) ──────▲                  │
                 └──────────┘                         └────────────────────────────────┘
   6g-sim (simulated gNB + UE) can be used in place of 6g-ran + 6g-ue.
```

## Requirements

Linux host (Ubuntu 22.04 or 24.04, x86_64), 4+ cores, 16 GB RAM, about 10 GB disk. The core's UPF needs the
`gtp5g` kernel module, so WSL2 and most containers will not work for the full data path. No SDR is needed: the
gNB and UE talk over ZeroMQ.

## Quick start

```bash
git clone https://github.com/sunnyarelli/free6G.git && cd free6G
make deps                 # apt packages, Go, Node.js (install MongoDB separately)
make all                  # gtp5g module, core, gNB, UE, simulator
```

1. **Start the core** (terminal 1): `make run-core`
2. **Add the test subscriber**: open `http://<host>:5000` (admin / free5gc), *Subscribers → New*, keep the
   defaults: IMSI `208930000000001`, K `8baf473f2f8fd09487cccbd7097c6862`, OPc `8e27b6af0e692e750f32667a3b14605d`,
   S-NSSAI 1/010203, DNN `internet`.
3. **Start RAN + UE**, choose one:
   - Full PHY over ZeroMQ (terminal 2): `make run-zmq`, then `sudo ip netns exec ue1 ping -I tun_ue 8.8.8.8`
   - Simulated (terminal 2): `make run-sim`, then `ping -I uesimtun0 8.8.8.8`

### Default network settings

| Setting | Value |
|---|---|
| PLMN | MCC 208 / MNC 93 |
| TAC | 1 |
| Slice | SST 1, SD 010203 |
| DNN / UE pool | `internet` / 10.60.0.0/16 |
| AMF N2 | 127.0.0.18:38412 |
| UPF N3 | 127.0.0.8:2152 |
| ZMQ radio (band 3 FDD, 20 MHz, 15 kHz SCS) | gNB TX :2000 → UE RX, UE TX :2001 → gNB RX |

## Repository layout

```
free6G/
├── 6g-core/            core network (NFs/<nf>, webconsole, config/)
├── 6g-ran/             gNB / CU / DU
├── 6g-ue/              UE (6g-ue/srsue)
├── 6g-sim/             simulated gNB + UE
├── configs/
│   ├── zmq-e2e/        gNB + UE configs over ZeroMQ
│   └── sim/            simulator gNB + UE configs
├── scripts/            install-deps, build, run-core, run-ran-ue-zmq, run-sim
├── Makefile
└── NOTICE.md
```

## Where 6G work goes

| 6G topic | Starting point in this repo |
|---|---|
| New numerologies / waveforms | `6g-ran/lib/phy`, `6g-ran/lib/ran` (numerology), `6g-ue/srsue/src/phy/nr` |
| AI/ML air interface (CSI compression, beam prediction) | `6g-ran/lib/scheduler`, `6g-ran/lib/du/du_high`, CSI report handling in `6g-ran/lib/mac` |
| ISAC (sensing) | OFDM grid in `6g-ran/lib/phy/upper`, plus a new sensing NF in `6g-core/NFs` |
| NTN | `6g-ran/configs/ntn_examples`, `6g-ran/lib/ntn` |
| Service-based core evolution / AI-native core | `6g-core/NFs/*` (each NF is a standalone Go module) |
| Ambient IoT / new device types | NAS + registration in `6g-core/NFs/amf`, `6g-ue/srsue/src/stack/upper` |
