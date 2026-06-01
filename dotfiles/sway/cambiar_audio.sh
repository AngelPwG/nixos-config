#!/usr/bin/env bash

SINKS=$(pactl list short sinks | awk '{print $2}')
CURRENT_SINK=$(pactl get-default-sink)

for SINK in $SINKS; do 
  if [ "$SINK" != "$CURRENT_SINK" ]; then
    pactl set-default-sink "$SINK"

    pactl list short sink-inputs | while read stream; do 
      streamId=$(echo $stream | cut -d ' ' -f1)
      pactl move-sink-input "$streamId" "$SINK"
    done

    notify-send "Cambiado a: $SINK" " " -i audio-speakers
    exit
  fi
done
