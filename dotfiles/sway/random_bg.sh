#!/bin/bash

DIR_FONDOS="$HOME/Videos/Wallpapers"

VIDEO_ELEGIDO=$(find "$DIR_FONDOS" -type f \( -name "*.mp4" -o -name "*.webm" \) | shuf -n 1)

if [ -z "$VIDEO_ELEGIDO" ]; then
    echo "No se encontraron videos en $DIR_FONDOS"
    exit 1
fi

killall -q mpvpaper

mpvpaper -p -o "loop --hwdec=auto no-audio" '*' "$VIDEO_ELEGIDO" &
