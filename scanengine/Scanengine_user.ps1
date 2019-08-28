#Scanengine-Client Configuration Powershellscript
#Dieses Script erstellt eine Datei mit dem aktuellen Userprofilepfad und startet dann mit erhoehten Rechten
#das Script zum erstellen der Freigaben und Ordner fuer die Scanengine (RVI-scan)
#erstelle Textdatei mit Inhalt des aktuellen Userprofilpfades. Diese Datei wird dann vom als Admin ausgeführten Script gelesen.
write-host "rwscanengine-Client Configuration started (User)"
Set-Content -Value $env:userprofile -Path C:\users\public\Downloads\scanenginepfad.txt
#starte scanengine_admin.ps1 mit erhoehten Rechten
$username = $env:ComputerName + "\%user%"
$password = "%password%"
$PSS = ConvertTo-SecureString $password -AsPlainText -Force
$cred = new-object system.management.automation.PSCredential $username,$PSS

Start-Process powershell -Credential $cred -ArgumentList "-file scanengine_admin.ps1"
