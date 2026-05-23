# /bin/bash

if pgrep -x waybar > /dev/null; then
	pkill waybar
else
 	pkill waybar; waybar &
 fi
