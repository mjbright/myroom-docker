#!/bin/bash

Container=mjbright/myroom
Command=""

#Container=$1
#Command=$2

SELINUX=0
[ "$1" = "-perm" ] && {
    SELINUX=1
}

#CMD="/home/mjb/src/git/nakato.hpe-myroom-docker/start.sh $CONTAINER"
#echo $CMD
#$CMD

HostIP=$(ip a l docker0 | grep 'inet ' | awk '{print $2}' | awk -F'/' '{print $1}')
T_XAUTH=$(xauth list)
XAUTH="$(echo $T_XAUTH | awk '{print $2 "  " $3}')"
PCookie=$(cat ~/.config/pulse/cookie | base64 -w0)

[ $SELINUX -eq 0 ] && {
    echo; echo "-- Temporarily disabling selinux ----"
    getenforce ; sudo setenforce 0; getenforce
}

# Based on http://stackoverflow.com/questions/28985714/run-apps-using-audio-in-a-docker-container
uid=$(id -u)
dockerUsername="root"

PULSEAUDIO_OPTS=""
#/home/mjb/.config/pulse
#/home/mjb/.config/gconf/system/pulseaudio

PULSEAUDIO_OPTS="
  -v /dev/shm:/dev/shm \
  -v /etc/machine-id:/etc/machine-id \
  -v /run/user/$uid/pulse:/run/user/$uid/pulse \
  -v /var/lib/dbus:/var/lib/dbus \
  -v $HOME/.config/pulse:/home/$dockerUsername/.config/pulse
  -v $HOME/z/bin/Deployed/hpmyroom.sh.conf:/home/user/.config/Hewlett-Packard/MyRoom.conf
"
## docker run -ti --rm \
##     -v /dev/shm:/dev/shm \
##     -v /etc/machine-id:/etc/machine-id \
##     -v /run/user/$uid/pulse:/run/user/$uid/pulse \
##     -v /var/lib/dbus:/var/lib/dbus \
##     -v ~/.pulse:/home/$dockerUsername/.pulse \
##     myContainer sh -c "echo run something"


#### #CMD="docker run -ti --rm -e DISPLAY=:0 -e HostIP=${HostIP} -e XAUTH="${XAUTH}" -e PCookie=${PCookie} -v /tmp/.X11-unix:/tmp/.X11-unix $Container $Command"
#### CMD="docker run --rm -e DISPLAY=:0 -e HostIP=${HostIP} -e XAUTH="${XAUTH}" -e PCookie=${PCookie} -v /tmp/.X11-unix:/tmp/.X11-unix $Container $Command"
#### echo $CMD
#### $CMD &

docker run --rm $PULSEAUDIO_OPTS -e DISPLAY=:0 -e HostIP=${HostIP} -e XAUTH="${XAUTH}" -e PCookie=${PCookie} -v /tmp/.X11-unix:/tmp/.X11-unix $Container $Command

[ $SELINUX -eq 0 ] && {
    echo; echo "-- Reenabling selinux ----"
    getenforce ; sudo setenforce 1; getenforce
}
