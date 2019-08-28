#!/bin/sh
Anzahl=`xrandr | grep -c -w "connected"`
if [ "$Anzahl" == "4" ]
then
 exec echo "Docked" &
else
 exec echo "undocked"  &
 exit
fi
