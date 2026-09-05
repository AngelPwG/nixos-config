#!/usr/bin/env bash

DIR_FONDOS="$HOME/Videos/Wallpapers"

VIDEO_ELEGIDO=$(find "$DIR_FONDOS" -type f \( -name "*.mp4" -o -name "*.webm" \) | shuf -n 1)

THUMBNAIL_PATH="/tmp/current_video_thumb.jpg"

if [ -z "$VIDEO_ELEGIDO" ]; then
    echo "No se encontraron videos en $DIR_FONDOS"
    exit 1
fi

killall -q mpvpaper

mpvpaper -p -o "loop --hwdec=auto no-audio" '*' "$VIDEO_ELEGIDO" &

ffmpeg -i "$VIDEO_PATH" -ss 00:00:01 -vframes 1 "$THUMBNAIL_PATH" -y -hide_banner -loglevel error

matugen image "$THUMBNAIL_PATH"
