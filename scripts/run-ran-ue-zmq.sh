#!/usr/bin/env bash
# Start the 6g-ran gNB + 6g-ue UE linked by ZeroMQ (software radio). Run after scripts/run-core.sh,
# with subscriber imsi-208930000000001 added in the web console.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
sudo ip netns list | grep -q '^ue1' || sudo ip netns add ue1
sudo "$ROOT/build/ran/apps/gnb/gnb" -c "$ROOT/configs/zmq-e2e/gnb_zmq.yml" &
GNB=$!
trap 'sudo kill $GNB 2>/dev/null' EXIT
sleep 3
sudo "$ROOT/build/ue/srsue/src/srsue" "$ROOT/configs/zmq-e2e/ue_zmq.conf"
# In another shell:  sudo ip netns exec ue1 ping -I tun_ue 8.8.8.8
