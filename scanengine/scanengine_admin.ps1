#Scanengine-Client Configuration Powershellscript
#Lese Inhalt von Textdatei in Variable $userp
write-host "rwscanengine Client-Configuration started (admin)"
$userp= Get-Content -path C:\users\public\Downloads\scanenginepfad.txt
$pdarchiv = $userp + "\Desktop\d3Archiv"
$psync =  $userp + "\Desktop\Datensync" 

#Zuerst Verzeichnisse pruefen und ggf. erstellen
If(!(test-path $psync)){New-Item -ItemType Directory -Force -Path $psync}

#Checke ob Bentzer rvi32sync vorhanden ansonsten erstelle ihn
if (& net users | select-string "") {
    write-host " existiert bereits!"
} else {

#Benutzer lokal anlegen
	write-host "Erstelle Benutzer!"
	$Computer = [ADSI]"WinNT://$Env:COMPUTERNAME,Computer"
	$LocalAdmin = $Computer.Create("User", "%user%")
	$LocalAdmin.SetPassword("%password%")
	$LocalAdmin.SetInfo()
	$LocalAdmin.FullName = "%Fullname%"
	$LocalAdmin.SetInfo()
	$LocalAdmin.UserFlags = 64 + 65536 # ADS_UF_PASSWD_CANT_CHANGE + ADS_UF_DONT_EXPIRE_PASSWD
	$LocalAdmin.SetInfo()
}

#Erstelle Freigaben von den benoetigten Ordnern
write-host "Erstelle SMBShare"
$share = Get-WmiObject Win32_Share -List -ComputerName $env:ComputerName
if(!(Get-SMBShare -Name "Daten-Sync" -ea 0)){
	$share.create($psync, "Daten-Sync", 0)
} else {write-host "SMBShare Daten-Sync existiert bereits"}
if (!(Get-SMBShare -Name "d3Archiv" -ea 0)){
	$share.create($pdarchiv, "d3Archiv", 0)
}else {write-host "SMBShare d3Archiv existiert bereits"}


#Setze die Rechte korrekt und fertig
$Ar = New-Object system.security.accesscontrol.filesystemaccessrule("%user%","FullControl","Allow")
$psync = "\\" + $env:ComputerName + "\Daten-Sync"
$Acl = Get-Acl $psync
$Acl.SetAccessRule($Ar)
Set-Acl $psync $Acl
$pdarchiv = "\\" + $env:ComputerName + "\d3Archiv"
$Acla = Get-Acl $pdarchiv
$Acla.SetAccessRule($Ar)
Set-Acl $pdarchiv $Acla

Grant-SmbShareAccess -Force -Name "Daten-Sync" -AccountName ($env:ComputerName + "\%user%") -AccessRight Full
Grant-SmbShareAccess -Force -Name "d3Archiv" -AccountName ($env:ComputerName + "\%user%") -AccessRight Full
