#!/bin/bash
# Charge percentage for the status line. Prints nothing on a machine with no
# battery (a Mac Mini), so the status line shows only the clock there.
battery=$(pmset -g batt 2>/dev/null | grep -oE '[0-9]+%' | head -1)
if [ -n "$battery" ]; then
    printf '%s' "$battery"
fi
