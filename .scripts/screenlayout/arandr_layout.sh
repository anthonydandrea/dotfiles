#!/bin/bash

numScreens="$(xrandr | grep ' connected' | wc -l)"


if [ $numScreens -eq 1 ] 
then
	~/.screenlayout/1monitor.sh
fi


if [ $numScreens -eq 2 ]
then
	~/.screenlayout/2monitors.sh
fi


#sleep 5s
#~/.scripts/polybar/launch_polybar.sh

