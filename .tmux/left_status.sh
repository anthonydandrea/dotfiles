#!/bin/bash

function main() {
    # keeps window tabs centered
    os=$(uname)

    battery=''

    if [ "$os" == "Darwin" ]; then
        battery=$(pmset -g batt | egrep "([0-9]+\%).*" -o --colour=auto | cut -f1 -d';' | sed 's/%//')
        if [ -n "$battery" ]; then
            printf "Battery: %s%s       " "$battery" "%"
        else
            printf "                   "
        fi
    else
        battery=''
        # Centering tmux status
        printf "                   "
    fi

}

main
