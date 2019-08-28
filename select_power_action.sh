#!/bin/bash
actions=(
  'screen'
  'suspend'
  'reboot'
  'poweroff'
  'hibernate'
)

select_action() {
  case $1 in
    screen )
      sleep 1 && xset dpms force off ;;
    suspend )
      #/home/bigfreak/git/i3lock-fancy/lock
      systemctl suspend ;;
    reboot|restart )
      systemctl reboot ;;
    shutdown|poweroff )
      systemctl poweroff ;;
    hibernate )
      systemctl hibernate ;;
  esac
}

if [[ $1 ]]; then
  select_action "$1"
else
  select_action "$( printf "%s\n" "${actions[@]}" | rofi -no-config -dmenu -theme lbraffi.rasi -i -p '' -hlbg '#4F5A0B' -bc '#4F5A0B' )"
fi
