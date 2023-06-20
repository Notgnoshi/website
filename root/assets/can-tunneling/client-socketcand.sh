#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
set -o noclobber

if ! ip addr show can1 up >/dev/null; then
    ip link add dev can1 type vcan
    ip link set up can1
fi

# TODO: How to get this IP address reliably? Can it be discovered?
socketcandcl --verbose --server 172.17.0.4 --interfaces can1,can1 "$@"
