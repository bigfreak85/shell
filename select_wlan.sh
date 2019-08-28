#!/bin/bash
actions=($(ls -p /etc/netctl | grep -v /))
select_action="$( printf "%s\n" "${actions[@]}" | rofi -dmenu -theme sidebarraffi.rasi -no-config -i -p ' ' -color-normal "#fdf6e3,#002b36,#eee8d5,#586e75,#eee8d5")"

if [[ $select_action ]]; then
  wlanstat=$(cat /sys/class/net/wlan0/operstate)
  if [[ $wlanstat == "up" ]]; then
    gksudo netctl switch-to $select_action
  else
    gksudo netctl start $select_action
  fi
else
  echo "Abbruch!"
fi
