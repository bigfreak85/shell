#!/bin/bash
#camgrabber V2.0 von Raffael Willems

camlist=()
pfadlist=()

#printf "\n\n camgrab 2.0 by Raffael Willems runing... \n\n"
for i in "${camlist[@]}"
do
  rpfad=$(wget $i/campass.php?pass= --waitretry=1 --read-timeout=10 --timeout=5 -t 3 -q -O -)
  if [ ! -z "$rpfad" ]; then
    if [[ ! $rpfad == \<\!* ]]; then 
#    printf "\n Remote_Pfad: ${rpfad}"
    lpfad=${rpfad/http:\/\/$i/\/home\/rvi\/${pfadlist[$zaehler]}}
#    printf "\n Lokaler_Pfad: ${lpfad}\n\n"
    if [ ! -d "${lpfad::-14}" ]; then
      mkdir ${lpfad::-14} 
      chmod 755 ${lpfad::-14}
      chown http:http ${lpfad::-14}
      printf "\n Verzeichnis erstellt!\n"
    fi
    wget_output=$(wget -q -nv --waitretry=1 --read-timeout=10 --timeout=5 -t 3 -O "$lpfad" "$rpfad" )
    if [ $? -ne 0 ]; then
      printf "${pfadlist[$zaehler]} DownloadFehler! \n"
    fi
  else
  printf "${pfadlist[$zaehler]} nicht erreichbar! \n"
    fi
  fi
  #zaehler hochsetzen fuer pfadliste
  zaehler=$((zaehler+1))
done
#printf "\n\n camgrab end\n\n"
convert -background black -fill white label:"$(journalctl -u camfetch.service -n 40)" /home/rvi/lokwestcam.rvi.de/result.png

