#!/bin/bash

brightness=`xrandr --verbose | grep -m 1 -i "brightness" | cut -f2 -d ' '`
echo $brightness

if [ "$brightness" -lt "1" ] ;
then
	echo "yay"
fi

