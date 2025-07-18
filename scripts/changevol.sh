#!/usr/bin/env sh
set -e

#wpctl set-volume @DEFAULT_SINK@ "$1"
pactl set-sink-volume @DEFAULT_SINK@ "$1"
#AUDIO_USER=$(whoami)
#systemd-run --uid="$AUDIO_USER" --gid="$AUDIO_USER" --no-block --quiet \
#    pactl set-sink-volume @DEFAULT_SINK@ "$1"
#volume=$(wpctl get-volume @DEFAULT_SINK@ | awk '{print int($2 * 100)}')

volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -n1 | sed 's/%//')

notify-send \
    -a "changevolume" \
    -u low \
    -r "9993" \
    -h int:value:"$volume" \
    -i "volume-$1" "Volume: ${volume}%" \
    -t 2000
