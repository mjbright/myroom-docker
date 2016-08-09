#!/bin/bash

echo "HostIP: ${HostIP}"
echo "PCookie: ${PULSE_COOKIE}"

touch /home/user/.Xauthority
XAUTH=":0  ${XAUTH}"
echo "XAUTH: ${XAUTH}"
xauth add $XAUTH

echo $PCookie | base64 -d > $PULSE_COOKIE
export PULSE_SERVER="tcp:${HostIP}:4713"
export QT_XKB_CONFIG_ROOT=/usr/share/X11/xkb

/usr/bin/hpmyroom
