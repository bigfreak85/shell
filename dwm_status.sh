#!/bin/bash

# This function parses /proc/net/dev file searching for a line containing $interface data.
# Within that line, the first and ninth numbers after ':' are respectively the received and transmited bytes.
function get_bytes {
  # Find active network interface
  interface=$(ip route get 8.8.8.8 2>/dev/null| awk '{print $5}')
  line=$(grep $interface /proc/net/dev | cut -d ':' -f 2 | awk '{print "received_bytes="$1, "transmitted_bytes="$9}')
  eval $line
  now=$(date +%s%N)
}

function get_velocity {
  value=$1
  old_value=$2
  now=$3

  timediff=$(($now - $old_time))
  velKB=$(echo "1000000000*($value-$old_value)/1024/$timediff" | bc)
  if test "$velKB" -gt 1024
  then
    echo $(echo "scale=2; $velKB/1024" | bc)MB/s
  else
    echo ${velKB}KB/s
  fi
}

# Get initial values
get_bytes
old_received_bytes=$received_bytes
old_transmitted_bytes=$transmitted_bytes
old_time=$now

print_volume() {
	volume="$(amixer get Master | tail -n1 | sed -r 's/.*\[(.*)%\].*/\1/')"
  muted="$(amixer get Master | tail -n1 | awk '{print $6}')"
  #wenn gemuted dann
  if [[ $muted == "[off]" ]]; then
    echo -e "\u23A2\uF026 ${volume}"
  else
	  if test "$volume" -gt 0
	  then
		  echo -e "\u23A2\uF028 ${volume}"
	  else
		  echo -e "\u23A2\uF35A"
	  fi
  fi
}

print_wifi() {
	ip=$(ip route get 8.8.8.8 2>/dev/null|grep -Eo 'src [0-9.]+'|grep -Eo '[0-9.]+')
	if hash iw
	then
		wifi=$(iw wlan0 link | grep SSID | sed 's,.*SSID: ,,')
		connectedto=$(iw wlan0 link | grep Connected | awk '{print $3}' | cut -c 10-)
		signalstr=$(iwconfig wlan0 | grep -o "Link Quality=[0-9][0-9]" | awk -F'[ =]+' '/Link Quality=/ {print $3}')
	fi
  if [[ -n $connectedto ]]; then
	  echo -e "\u23A2${signalstr}\uF405 ${wifi}|$ip"
  else
    if [[ -n $ip ]]; then
	    echo -e "\u23A2\uF30A $ip"
    fi
  fi
}

print_mem(){
	memfree=$(($(grep -m1 'MemAvailable:' /proc/meminfo | awk '{print $2}') / 1024))
	echo -e "\uF3A5 ${memfree}MB"
}

print_temp(){
	test -f /sys/class/thermal/thermal_zone0/temp || return 0
	echo -e "\u23A2\uF3B6 $(head -c 2 /sys/devices/platform/coretemp.0/hwmon/hwmon3/temp4_input)°\uF3B3 $(cat /sys/devices/virtual/hwmon/hwmon1/fan1_input)"
}

print_bat(){
	hash acpi || return 0
	onl="$(grep "on-line" <(acpi -V))"
	charge="$(awk '{ sum += $1 } END { print sum }' /sys/class/power_supply/BAT*/capacity)"
	if test -z "$onl"
	then
		echo -e "\u23A2\uF213 ${charge}"
	else
		echo -e "\u23A2\uF237 ${charge}"
	fi
    if (( $charge < 10 )); then
    notify-send --urgency=critical "Akku-Status" "Achtung ich bin bald leer!"
    fi
}

print_date(){
	date "+%a %d.%m %T"
}

while true
do
	# Get new transmitted, received byte number values and current time
	get_bytes
	# Calculates speeds
	vel_recv=$(get_velocity $received_bytes $old_received_bytes $now)
	vel_trans=$(get_velocity $transmitted_bytes $old_transmitted_bytes $now)

	xsetroot -name "$(print_mem)$(echo -e '\u23A2\uF0DC') $vel_recv $vel_trans$(print_temp)$(print_wifi)$(print_volume)$(print_bat)$(echo -e '\u23A2')$(print_date)"

	# Update old values to perform new calculations
	old_received_bytes=$received_bytes
	old_transmitted_bytes=$transmitted_bytes
	old_time=$now
	sleep 1
done
