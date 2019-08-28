#!/bin/bash
#Skript zum automatischen Wechseln des DWM-Tags
#erstellt von r.willems am 20.02.17

anztags=6
counter=1
while [ $counter -lt 100 ]
do
  echo "Tag Nr:$counter"
  xdotool key Alt_L+$counter
  counter=$[counter + 1]
  sleep 6 #wartezeit zwischen dem Sprung
if [ $counter -gt $anztags ]
then
  counter=1
  echo "und nochmal!"
fi
done
