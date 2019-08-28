#!/bin/bash
#************************************************************
#* Dateierstellungsmonitor V2.4 by Raffael Willems@RVI GmbH *
#************************************************************
counter=0
echo $$ > /var/run/changemon.pid
yellow=$(tput setaf 1)
green=$(tput setaf 2)
normal=$(tput sgr0)
echo "Raffis mvscan gestartet! warte auf Jobs"
inotifywait -mrq --exclude '(.dat|.swp|.swx|.part|.tmp|\~\$.*)' -e close_write,moved_to /home/bigfreak/mvscan/source/ | while read line;
do
        RES=$(awk -F'CLOSE_WRITE,CLOSE | MOVED_TO ' '{if($0~"CLOSE_WRITE,CLOSE") myFS="erstellt";if($0~"MOVED_TO") myFS="bewegt";print $1"@"myFS"@"$2}' <<< "$line")
#       printf "Ergebnis: $RES\n\n"
        action="$(awk -F@ '{print $2}' <<< "$RES")" #Setze Action auf bewegt oder erstellt

        if [[ $action == *"bewegt"* ]]; then # Wenn Action bewegt dann kein Leerzeichen entfernen
          path="$(awk -F@ '{print $1}' <<< "$RES")"
          file="$(awk -F@ '{print $3}' <<< "$RES")"
        fi
        if [[ $action == *"erstellt"* ]]; then # Wenn Action erstellt Leerzeichen entfernen
          path="$(awk -F@ '{print substr($1, 0, length($1) - 1)}' <<< "$RES")"
          file="$(awk -F@ '{print substr($3,1)}' <<< "$RES")"
        fi
        if [[ $file != *"~"* ]]; then 
          if [[ $file == *".pdf"* ]]; then
            counter=$[counter + 1]
            zielordner=$(basename $path)
            quelle="${path}${file}"        
            tput cup 2 0
            tput ed
            printf "\n${yellow}neuer Job-${counter}${lines}\n${normal}"
            printf "Die Datei $file Im Verzeichnis ${path} wurde um $(date +'%T') $action!\n" #>>$logziel
            printf "bewege(cp): \n"
            cp -v "${quelle}" "/home/bigfreak/mvscan/dest/$zielordner"
            rm "${quelle}"
            echo "${green}Job ist fertig!${normal}"
         fi
       fi
done
echo "BEENDET "
