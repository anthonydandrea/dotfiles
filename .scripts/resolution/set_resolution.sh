#!/bin/sh

if [ "$1" = ":/" ]; 
then
	xrandr --output eDP1 --mode 1920x1080
fi

if [ "$1" = ":D" ]; 
then
	xrandr --output eDP1 --mode 3840x2160
fi
