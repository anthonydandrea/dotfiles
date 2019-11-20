#!/bin/sh

if [ $1 ]; then
    export MONITOR=$1
    polybar example -q  &
else
	killall -q polybar
	for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    		export MONITOR=$m
    		polybar example -q &
	done
fi
