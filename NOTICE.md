# Licenses

Each component folder keeps its own license, which applies to everything inside it. The top-level files
(`configs/`, `scripts/`, `Makefile`, these docs) are Apache-2.0.

| Folder | Copyright | License |
|---|---|---|
| `6g-core/` | free5GC | Apache-2.0 (`6g-core/LICENSE`, `6g-core/THIRD-PARTY-NOTICES.txt`) |
| `6g-ran/` | Software Radio Systems Limited, OCUDU contributors | BSD-3-Clause-Open-MPI (`6g-ran/LICENSE`, `6g-ran/LICENSES/`) |
| `6g-ue/` | Software Radio Systems Limited | AGPL-3.0 (`6g-ue/LICENSE`) |
| `6g-sim/` | Ali Güngör | AGPL-3.0 (`6g-sim/LICENSE`) |

`6g-ue` and `6g-sim` are AGPL-3.0: if you modify them and offer them to others over a network, you must publish
the modified source. Keep the folders separate so the core and RAN stay under their permissive licenses.
