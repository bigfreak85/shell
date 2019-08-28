#!/bin/sh
#Dieses Script ordnet die Bildschirme der Dockingstation richtig an. für noch nicht vorhandenen Thinkpad t460p Support. Erstellt von Raffael Willems
#Ermitteln welche Bildschirme vorhanden sind mit xrandr
#internes Display wird abgeschaltet, externe Displays (Daisychain) 3x angeschaltet

EXTERNAL_OUTPUT="DP1-2-1-1"
INTERNAL_OUTPUT="eDP1"

xrandr |grep $EXTERNAL_OUTPUT | grep " connected "
if [ $? -eq 0 ]; then
    xrandr --output $INTERNAL_OUTPUT --off --output $EXTERNAL_OUTPUT --auto 
    xrandr --output DP1-2-1-2 --auto --right-of DP1-2-1-1
    xrandr --output DP1-2-2 --auto --left-of DP1-2-1-1
else
    xrandr --output $INTERNAL_OUTPUT --auto --output $EXTERNAL_OUTPUT --off
fi

xrandr --output DP1-2-1-1 --pos 0x0 --mode 1920x1200
xrandr --output DP1-2-1-2 --pos 1920x0 --primary --mode 1920x1200
xrandr --output DP1-2-2 --pos 3840x0 --mode 1920x1200

