#!/bin/bash
# Created by R.Willems@RVI GmbH
# Dieses Script erstellt Zeitraffer Videos von vorhandenen Bildern.
startdatum="2018-01-01"
#startdatum="2017-01-01"
enddatum="2018-12-31"
jahr="2018"
bilderps="10"
quelle="/media/wd/RVI-CAMS/zeitlok/aufnahmen/2018"
Ziel="/media/wd/RVI-CAMS/zeitlok/2018"
xbild=3 #60 #hole jedes xte Bild aus Ordner
startbild=561 #441 #07:00 mit welchem Bild soll im Ordner gestartet werden
endbild=563 #1137  #18:55 Letztes Bild im Ordner welches kopiert wird

yellow=$(tput setaf 1)
green=$(tput setaf 2)
normal=$(tput sgr0)
printf "\n\n${yellow}-------------------------------------------------------------------${normal}\n\n"
printf "\n Raffis Jahresvideo wurde gestartet am:"
date
Oarray=() #Array welches die vom Script generierten Ordnerpfade enthaelt
Darray=() #Array welches die vom Script generierten Pfade+Dateinamen enthaelt

function nullauf()
{
  if [ $1 -lt 10 ];then
    aznull="0000"
  else
    if [ $1 -lt 100 ]; then
      aznull="000"
    else
      if [ $1 -lt 1000 ]; then
        aznull="00"
      else
        if [ $1 -lt 10000 ]; then
          aznull="0"
        fi
      fi
    fi
  fi
#echo "Index ist $i und aznull $aznull"
}  

#Erstelle Array mit allen moeglichen Ordnernamen eines Jahres
until [[ $startdatum > $enddatum ]]; do
    mod=${startdatum//[-]/_}
    Oarray+=(${mod#${jahr}_})
    startdatum=$(date -I -d "$startdatum + 1 day")
done
printf "\n Ordnerarray:${green}erfolgreich erstellt${normal}"

#Erstelle Array mit vorhandenen Bildern (Pfad+Bildname)
for i in ${!Oarray[@]}; do
  for ((p=$startbild; p<=$endbild; p+=$xbild)); do
    nullauf $p
    datei="${quelle}/${Oarray[$i]}/image${aznull}${p}.jpg"
    if [ -e $datei ];then
      Darray+=($datei)
    fi
  done
done
printf "\n Dateiarray:${green}erfolgreich erstellt${normal}"

#Aufbau der Arrays fertig nun wird kopiert und erstellt!
for i in ${!Darray[@]}; do
 nullauf $i
 cp ${Darray[$i]} ${Ziel}/image${aznull}${i}.jpg
done
printf "\n ${green}${i}${normal} Dateien erfolgreich kopiert\n starte ffmpeg und erstelle Video\n\n Raffis Jahresvideo endete um:"
date
printf "\n\n${yellow}-------------------------------------------------------------------${normal}\n\n"

sleep 2
#ffmpeg aufrufen und Video anhand von kopierten Bildern erstellen
/usr/bin/ffmpeg -r $bilderps -f image2 -s 1280x960 -i $Ziel/image%05d.jpg -vcodec libx264 -q 0 $Ziel/$jahr.mp4

#Aufraeumen
rm $Ziel/*.jpg

#declare -p Darray 
