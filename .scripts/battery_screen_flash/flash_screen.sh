#!/usr/bin/env bash


# To disable:
#python3 ~/.scripts/redshift/relative_change.py -r
#exit

CHARGE_STATE=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep state | awk '{printf $2}')
BATTERY=$(upower -i $(upower -e | grep BAT) | grep percentage | awk '{print $2}')

if [ 'discharging' = $CHARGE_STATE ] && [ ${BATTERY::-1} -lt '8' ]; then
  redshift -O 1000
  sleep 1s
  redshift -O 2000
  sleep 1s
  ~/.scripts/battery_screen_flash/flash_screen.sh
else
  python3 ~/.scripts/redshift/relative_change.py -r
  sleep 1m
  ~/.scripts/battery_screen_flash/flash_screen.sh
fi
