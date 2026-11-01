#!/usr/bin/env bash
# Install build dependencies for all free6G components (Ubuntu 22.04 / 24.04).
set -euo pipefail
GO_VERSION="${GO_VERSION:-1.24.4}"

sudo apt-get update
sudo apt-get install -y \
  build-essential cmake make gcc g++ pkg-config git curl wget \
  libfftw3-dev libmbedtls-dev libsctp-dev lksctp-tools libyaml-cpp-dev libgtest-dev \
  libboost-program-options-dev libconfig++-dev libzmq3-dev \
  iproute2 iptables net-tools \
  linux-headers-"$(uname -r)"

# The core stores subscribers in MongoDB; Ubuntu has no mongodb package, use MongoDB's apt repo.
command -v mongod >/dev/null || echo "WARNING: MongoDB not found - install it from https://www.mongodb.com/docs/manual/administration/install-on-linux/"

if ! command -v go >/dev/null || ! go version | grep -q "go${GO_VERSION%.*}"; then
  wget -q "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" -O /tmp/go.tgz
  sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf /tmp/go.tgz
  echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
  echo "Go installed; run: export PATH=\$PATH:/usr/local/go/bin"
fi

# Node.js + yarn are needed for the core web console
if ! command -v node >/dev/null; then
  curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
  sudo apt-get install -y nodejs && sudo npm install -g yarn
fi
