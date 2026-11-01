#!/usr/bin/env bash
# Start the simulated gNB + UE against the core (quickest end-to-end check).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
"$ROOT/6g-sim/build/nr-gnb" -c "$ROOT/configs/sim/gnb.yaml" &
GNB=$!
trap 'kill $GNB 2>/dev/null' EXIT
sleep 2
sudo "$ROOT/6g-sim/build/nr-ue" -c "$ROOT/configs/sim/ue.yaml"
# In another shell:  ping -I uesimtun0 8.8.8.8
