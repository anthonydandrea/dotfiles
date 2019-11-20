#!/usr/bin/env bash

CHANGE=$1
VOLUME=$2

if [ "$CHANGE" == "toggle-mute" ]; then
  amixer -D pulse set Master 1+ toggle
else
  for SINK in `pacmd list-sinks | grep 'name:' | cut -b9- | sed 's/.\{1\}$//'`
  do
    pactl set-sink-volume $SINK ${CHANGE}${VOLUME}
  done

  amixer -D pulse set Master 1+ unmute
  amixer sset 'Master' ${VOLUME}${CHANGE}
fi
