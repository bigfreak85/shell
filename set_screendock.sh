#!/bin/sh
#set_screendock.sh written by Raffael Willems 29.06.2017
#Dieses Script wird von udev gestartet wenn Dockingstation erkannt/getrennt wird
#Das Script läuft als ROOT deshalb muss mit sudo gearbeitet werden.

#Interner und Externer Bildschirm in Variable packen
EXTERNAL_OUTPUT="DP3-2-1-2"
INTERNAL_OUTPUT="eDP1"

#Wer besitzt die aktuelle X-Session 
xowner=$(who | grep '(:0)' | awk 'BEGIN { FS = "[ \t\n]+" } { print $1}')

#Checke ob Bildschirm angeschlossen ist an Dock (ansonsten wurde getrennt)
em_test=$(sudo DISPLAY=:0.0 -u $xowner xrandr | grep $EXTERNAL_OUTPUT | grep " connected")

if [ -n "$em_test" ]; then
#intern aus
sudo DISPLAY=:0.0 -u $xowner xrandr --output $INTERNAL_OUTPUT --off
#externe an!
sudo DISPLAY=:0.0 -u $xowner xrandr --output $EXTERNAL_OUTPUT --auto 
sudo DISPLAY=:0.0 -u $xowner xrandr --output DP3-2-2 --auto --right-of DP3-2-1-2
sudo DISPLAY=:0.0 -u $xowner xrandr --output DP3-2-1-1 --auto --left-of DP3-2-1-2
else
#intern an
sudo DISPLAY=:0.0 -u $xowner xrandr --output $INTERNAL_OUTPUT --auto
#externe aus!
sudo DISPLAY=:0.0 -u $xowner xrandr --output $EXTERNAL_OUTPUT --off
sudo DISPLAY=:0.0 -u $xowner xrandr --output DP3-2-2 --off
sudo DISPLAY=:0.0 -u $xowner xrandr --output DP3-2-1-1 --off
fi
#Positionieren
sudo DISPLAY=:0.0 -u $xowner xrandr --output eDP1 --pos 0x0
sudo DISPLAY=:0.0 -u $xowner xrandr --output DP3-2-1-1 --pos 0x0
sudo DISPLAY=:0.0 -u $xowner xrandr --output DP3-2-1-2 --pos 1920x0 --primary
sudo DISPLAY=:0.0 -u $xowner xrandr --output DP3-2-2 --pos 3840x0

logger set_screendock beendet
