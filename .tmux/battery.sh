#!/bin/bash
battery=$(pmset -g batt | grep -oE '[0-9]+%' | head -1 | tr -d '%')
if [ -n "$battery" ]; then
    printf "%s%%" "$battery"
else
    printf "N/A"
fi
