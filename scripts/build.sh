#!/usr/bin/env bash
# Build all free6G components. Usage: scripts/build.sh [core|gtp5g|ran|ue|sim|all]
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
JOBS="${JOBS:-$(nproc)}"
export PATH="$PATH:/usr/local/go/bin"

build_gtp5g() {   # GTP-U kernel module required by the 6g-core UPF (fetched at build time)
  [ -d "$ROOT/build/gtp5g" ] || git clone --depth 1 https://github.com/free5gc/gtp5g.git "$ROOT/build/gtp5g"
  make -C "$ROOT/build/gtp5g" && sudo make -C "$ROOT/build/gtp5g" install
}
build_core() { make -C "$ROOT/6g-core" all; }
build_ran()  { cmake -S "$ROOT/6g-ran" -B "$ROOT/build/ran" -DENABLE_ZEROMQ=ON -DCMAKE_BUILD_TYPE=Release
               cmake --build "$ROOT/build/ran" -j"$JOBS" --target gnb; }
build_ue()   { cmake -S "$ROOT/6g-ue" -B "$ROOT/build/ue" -DENABLE_ZEROMQ=ON -DCMAKE_BUILD_TYPE=Release
               cmake --build "$ROOT/build/ue" -j"$JOBS" --target srsue; }
build_sim()  { make -C "$ROOT/6g-sim" -j"$JOBS"; }

case "${1:-all}" in
  core)  build_core ;;
  gtp5g) build_gtp5g ;;
  ran)   build_ran ;;
  ue)    build_ue ;;
  sim)   build_sim ;;
  all)   build_gtp5g; build_core; build_ran; build_ue; build_sim ;;
  *) echo "usage: $0 [core|gtp5g|ran|ue|sim|all]"; exit 1 ;;
esac
