#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
set -o noclobber

if ! ip addr show can1 up >/dev/null; then
    ip link add dev can1 type vcan
    ip link set up can1
fi

cannelloni -I can1 -R 172.17.0.4 -l 3000 -r 2000 &
candump -L can1 &
wait
