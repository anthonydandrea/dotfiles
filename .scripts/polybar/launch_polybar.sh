#!/bin/sh

#if [ $1 ]; then
    #export MONITOR=$1
    ##polybar example -q  &
    #polybar top -q  &
#else
	#killall -q polybar
	#for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    		#export MONITOR=$m
    		##polybar example -q &
    		#polybar top -q &
	#done
#fi


if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload top &
  done
else
  polybar --reload top &
fi
