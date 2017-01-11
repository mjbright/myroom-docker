#!/bin/bash

# NOTE:
#   From https://github.com/jessfraz/dockerfiles/blob/master/spotify/Dockerfile
#
#   See also: https://github.com/jessfraz/dockerfiles/issues/85
#   for sound issues
#
# Run spotify in a container
#
# docker run -d \
#    -v /etc/localtime:/etc/localtime:ro \
#    -v /tmp/.X11-unix:/tmp/.X11-unix \
#    -e DISPLAY=unix$DISPLAY \
#    --device /dev/snd:/dev/snd \
#    -v $HOME/.spotify/config:/home/spotify/.config/spotify \
#    -v $HOME/.spotify/cache:/home/spotify/spotify \
#    --name spotify \
#    jess/spotify

#Container=$1
#Command=$2
Container=mjbright/myroom
Command=""

############################################################
# Config:

SELINUX=0

############################################################
# Functions:

die() {
    echo "$0: die - $*" >&2
    exit 1
}

enableSELinux() {
    echo; echo "-- Reenabling selinux ----"
    getenforce ; sudo setenforce 1; getenforce
}

disableSELinux() {
    echo; echo "-- Temporarily disabling selinux ----"
    getenforce ; sudo setenforce 0; getenforce
}

############################################################
# Args:
while [ ! -z "$1" ];do
    case $1 in
        -perm*) SELINUX=1;;
        -se*)   SELINUX=1;;

        *) die "Unknown option <$1>";;
    esac
    shift
done

############################################################
# Main:

HostIP=$(ip a l docker0 | grep 'inet ' | awk '{print $2}' | awk -F'/' '{print $1}')
## T_XAUTH=$(xauth list)
## XAUTH="$(echo $T_XAUTH | awk '{print $2 "  " $3}')"
PCookie=$(cat ~/.config/pulse/cookie | base64 -w0)

[ $SELINUX -eq 0 ] && disableSELinux
    
uid=$(id -u)
dockerUsername="root"

PULSEAUDIO_OPTS="
  -v $HOME/.config/pulse:/home/$dockerUsername/.config/pulse
  --device /dev/snd
  --group-add $(getent group audio | cut -d: -f3)
   -e PULSE_SERVER=tcp:localhost:4713
   -e PULSE_COOKIE_DATA=`pax11publish -d | grep --color=never -Po '(?<=^Cookie: ).*'` 
"

# mount the X11 socket:
# pass the display:
X11_OPTS="
    -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY
"

HPMYROOM_OPTS="
  -v $HOME/z/bin/Deployed/hpmyroom.sh.conf:/home/user/.config/Hewlett-Packard/MyRoom.conf
"

# See lidel here:
#    https://github.com/jessfraz/dockerfiles/issues/85
# Set up PulseAudio Cookie if missing
if [ x"$(pax11publish -d)" = x ]; then
    echo "start-pulseaudio-x11 ..."
    start-pulseaudio-x11
fi


set -x
    docker run --rm $PULSEAUDIO_OPTS $X11_OPTS $HPMYROOM_OPTS -e HostIP=${HostIP} -e "PCookie=${PCookie}" $Container $Command
set +x

[ $SELINUX -eq 0 ] && enableSELinux


