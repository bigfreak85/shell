<?php
// camgrab 1.4 von Raffael Willems
function download_image2($image_url){
    $ch = curl_init($image_url);
    curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
    curl_setopt($ch, CURLOPT_TIMEOUT, 40);
    curl_setopt($ch, CURLOPT_USERAGENT, 'Mozilla/5.0');
    curl_setopt($ch, CURLOPT_WRITEFUNCTION, "curl_callback");
    // curl_setopt($ch, CURLOPT_VERBOSE, true);   // Enable this line to see debug prints
    curl_exec($ch);
    curl_close($ch);                          
}

/** callback function for curl */
function curl_callback($ch, $bytes){
    global $fp;
    $len = fwrite($fp, $bytes);
    // if you want, you can use any progress printing here
    return $len;
}

function getHtml($url, $post = null) {
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
    curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
    if(!empty($post)) {
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $post);
    } 
    $result = curl_exec($ch);
    curl_close($ch);
    return $result;
}

//Ende der Funktionsdeklaration jetzt gehts los

echo "\n\n camgrab 1.4 by Raffael Willems runing...\n\n";
//Array mit den Adressen der Kameras welches beliebig erweitert werden kann
$camlist = array();
//Array mit den Pfaden auf dem lokalen Webserver ebenfalls erweiterbar
$pfadlist = array ();

// hole Bild und packe es in das jeweilig passende Verzeichnis...
// Spucke dabei die gebauten URLS sowie die lokalen Speicherpfade aus (siehe journalctl -f)
$i=0;
foreach ($camlist as &$current) {
  $rpfad = getHtml("http://". $current ."/campass.php?pass=");
  echo "Remote_Pfad: " . $rpfad . "\n";
  $lpfad = str_replace("http://". $current,"/home/rvi/".$pfadlist[$i],$rpfad);
  echo "Lokaler_Pfad: " . $lpfad . "\n";
  if(!is_dir(substr($lpfad, 0, -14))) {
      mkdir("/home/rvi/".$pfadlist[$i]."/aufnahmen/" . date('m') . "_" . date('d'), 0777, true);
      echo "Verzeichnis erstellt!\n";
      }
  $fp = fopen ($lpfad, 'w+');              
  download_image2($rpfad);
  fclose($fp);
  echo $rpfad . " erfolgreich geladen! \n\n";
  $i = $i+1;
}
?>
