# RVI-Scanengine


This Scriptcollection represents the RVI-Scanengine. The Scripts works as follows:


mountvdi.sh:

This Script runs at startup via timer or cronjob. The Script pings the desired VDI-Hosts and if they reply it mounts all network-shares from the VDI-Hosts in seperate folders. After that it starts mvscan.sh and mvdaten.sh in a tmux session

mvscan.sh

mvscan.sh watchs for new Files in a given Folder-Structur. If a new PDF-File is created it moves the created file to the Network-share of the corresponding VDI-Host

mvdaten.sh

makes the same like mvscan.sh for any Filetype and move it to Datensync Folder on VDI-Host

neumount.sh

runs every x minutes via timer or cronjob to check if all VDI-Hosts are mounted and eventually mount now responsive VDI-Hosts

startemich.sh

starts the Scanengine manually if no automatic Startup is needed (Debugging)

scanengine_admin.ps1

Powershellscript that creates the needed Folders and Shares on Windows-machines for the Scanengine (Dekstop\D3-Archiv and Desktop\Datensync)


Screenshot:
![Screenshot](/scanengine/screenshot.png?raw=true "Screenshot")
