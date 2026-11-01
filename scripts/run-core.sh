#!/usr/bin/env bash
# Start the 6G core (all NFs) and the web console (http://<host>:5000, admin/free5gc).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
sudo sysctl -w net.ipv4.ip_forward=1 >/dev/null
sudo iptables -t nat -C POSTROUTING -s 10.60.0.0/16 -j MASQUERADE 2>/dev/null \
  || sudo iptables -t nat -A POSTROUTING -s 10.60.0.0/16 -j MASQUERADE
cd "$ROOT/6g-core"
(cd webconsole && ./bin/webconsole >/tmp/free6g_webconsole.log 2>&1 &)
exec ./run.sh
