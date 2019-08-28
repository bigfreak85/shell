#!/bin/bash
#Automatisches Mounten der Shares von den VDs
zaehler=1 
zaehler1=1
while [ $zaehler -lt 29 ] #Anzahl Hosts +1
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
      printf "\n - $Hostname bereits gemountet!"
      printf "\n------------------------"
    else
      printf "\n - mounte $Hostname d3-Archiv bitte warten..."
      mount -t cifs -o username=,password=,vers=2.0,domain=$Hostname "//$Hostname.rvi.local/d3Archiv" $mdest
      printf "\n - mounte SBC0$zaehler sync-files bitte warten..."
      mount -t cifs -o username=,password=,vers=2.0,domain=$Hostname "//$Hostname.rvi.local/Daten-Sync" $mdest1
      printf "\n------------------------"
    fi
  else
    printf "\n $Hostname nicht erreichbar breche ab..."
    printf "\n----------------------"
  fi
zaehler=$[zaehler +1]
zaehler1=$[zaehler1 +1]
done
printf "\nMounten fertig starte Raffis Monitor\n"
/usr/bin/tmux send -t root '/home/bigfreak/mvscan/mvscan.sh' ENTER
/usr/bin/tmux selectp -t root
/usr/bin/tmux split-window -v -p 50 '/home/bigfreak/mvdaten/mvdaten.sh'
/usr/bin/tmux new-window -t root -n "lsscansmb" 'watch -n 10 ls -R /home/bigfreak/mvscan/dest'
/usr/bin/tmux new-window -t root -n "lsdatenssmb" 'watch -n 10 ls -R /home/bigfreak/mvdaten/dest'

#/usr/bin/tmux rename-session -t root monitor
#/usr/bin/tmux rename-window -t bash monitor

#/usr/bin/tmux select-window -t monitor

