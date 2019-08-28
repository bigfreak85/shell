#!/bin/bash
#Automatisches Mounten der Shares von den VDs
zaehler=1 
zaehler1=1
while [ $zaehler -lt 23 ] #Anzahl Hosts +1
do
  if [ $zaehler1 -lt 10 ] #Ab 10 keine Null auffüllen
  then
    Host="00$zaehler"

    mdest="/home/bigfreak/mvscan/dest/scan0$zaehler1"
    mdest1="/home/bigfreak/mvdaten/dest/dsource0$zaehler1"
  else
    Host="0$zaehler"
    mdest="/home/bigfreak/mvscan/dest/scan$zaehler1"
    mdest1="/home/bigfreak/mvdaten/dest/dsource$zaehler1"
  fi
  Hostname="RVI-DESKTOP$Host" #baue Hostname...
  if ping -c 1 $Hostname > /dev/nulli; then # Wenn Ping erfolgreich Rechner an und mounten
    printf "\nClient $Hostname erreichbar! \n - checke mount"
    if mount | grep //$Hostname > /dev/null; then
      printf "\n - $Hostname bereits gemountet Dismount -f!"
      umount -f "//$Hostname.rvi.local/d3Archiv"
      umount -f "//$Hostname.rvi.local/Daten-Sync"
      printf "\n------------------------"
    fi
      printf "\n - mounte $Hostname d3-Archiv bitte warten..."
      mount -t cifs -o username=,password=,vers=2.0,domain=$Hostname "//$Hostname.rvi.local/d3Archiv" $mdest
      printf "\n - mounte $Hostname sync-files bitte warten..."
      mount -t cifs -o username=,password=,vers=2.0,domain=$Hostname "//$Hostname.rvi.local/Daten-Sync" $mdest1
      printf "\n------------------------"    
  else
    printf "\n $Hostname nicht erreichbar breche ab..."
    printf "\n----------------------"
  fi
zaehler=$[zaehler +1]
zaehler1=$[zaehler1 +1]
done
printf "\n"
