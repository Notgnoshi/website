#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
set -o noclobber

if ! ip addr show can1 up >/dev/null; then
    ip link add dev can1 type vcan
    ip link set up can1
fi
socketcand --verbose --interface can1 "$@" &
candump -L can1 &
wait
