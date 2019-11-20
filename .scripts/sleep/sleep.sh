#!/bin/bash

TMPBG=/tmp/screen.png
LOCK=$HOME/Pictures/lock.png
#RES=1920x1080
RES="$(xdpyinfo | awk '/dimensions/{print $2}')"

ffmpeg -f x11grab -video_size $RES -y -i $DISPLAY -i $LOCK -filter_complex "boxblur=22:1,overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2" -vframes 1 $TMPBG
sudo pm-suspend & i3lock -i $TMPBG
