#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
set -o noclobber

if ! ip addr show can1 up >/dev/null; then
    ip link add dev can1 type vcan
    ip link set up can1
fi

cannelloni -I can1 -R 172.17.0.1 -l 2000 -r 3000 &
candump -L can1 &
wait
