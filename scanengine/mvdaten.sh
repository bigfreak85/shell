#!/bin/bash
#**********************************************************
#* Dateierstellungsmonitor V1.9 by Raffael Willems@RVI GmbH *
#**********************************************************
counter=0
echo $$ > /var/run/changemon1.pid
logziel="/tmp/changemon.log"
yellow=$(tput setaf 1)
green=$(tput setaf 2)
normal=$(tput sgr0)
echo "mvdaten Monitor gestartet"
inotifywait -mrq --exclude '(.swp|.swx|.part|.tmp|\~\$.*)' -e close_write /home/bigfreak/mvdaten/source/ | while read line;
do
        RES=$(awk -F'CLOSE_WRITE,CLOSE' '{if($0~"CLOSE_WRITE,CLOSE") myFS="erstellt";print $1"@"myFS"@"$2}' <<< "$line")
        counter=$[counter + 1]
        path="$(awk -F@ '{print substr($1, 0, length($1) - 1)}' <<< "$RES")"
        action="$(awk -F@ '{print $2}' <<< "$RES")"
        file="$(awk -F@ '{print substr($3,2)}' <<< "$RES")"
        zielordner=$(basename $path)
        quelle="${path}${file}"
        tput cup 2 0
        tput ed
        printf "\n${yellow}neuer Job-${counter}${lines}\n${normal}"
        printf "Die Datei $file Im Verzeichnis ${path} wurde um $(date +'%T') $action!\n" #>>$logziel
        printf "bewege(cp): "
        cp -v "${quelle}" "/home/bigfreak/mvdaten/dest/$zielordner"
        rm "${quelle}"
        echo "${green}Job ist fertig!${normal}"
#       if [[ $action == *"gelöscht"* ]]; then printf "geloescht:\t $path$file um $(date +'%H:%M') \n" ; fi
done

echo "BEENDET "
