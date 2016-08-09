#!/bin/bash

Container=$1

HostIP=$(ip a l docker0 | grep 'inet ' | awk '{print $2}' | awk -F'/' '{print $1}')
T_XAUTH=$(xauth list)
XAUTH="${HostIP}:0  $(echo $T_XAUTH | awk '{print $2 "  " $3}')"
PCookie=$(cat ~/.config/pulse/cookie | base64 -w0)

docker run -ti --rm -e DISPLAY=${HostIP}:0 -e HostIP=${HostIP} -e XAUTH="${XAUTH}" -e PCookie=${PCookie} $Container
