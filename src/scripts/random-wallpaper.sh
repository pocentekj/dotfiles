#!/bin/bash
while true; do
    WALL=$(find /home/chester/Pictures/Wallpapers/ -type f | shuf -n 1)
    hyprctl hyprpaper wallpaper HDMI-A-2,"$WALL"
    sleep 30
done

