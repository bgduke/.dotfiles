#!/usr/bin/env bash

chosen=$(printf "󰐥 Power Off\n Restart\n Log out\n󰤄 Suspend" \
  | rofi -dmenu -i -l 4 -p "Power")

case "$chosen" in
  "󰐥 Power Off") systemctl poweroff ;;
  " Restart") systemctl reboot ;;
  " Log out") swaymsg exit ;;
  "󰤄 Suspend") systemctl suspend ;;
  *) exit 0 ;;
esac

