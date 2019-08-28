<?php
$cam2 = "http://192.168.0.10/axis-cgi/operator/dynamicoverlay.cgi?action=settext&text=$argv[1]";
$cam3 = "http://192.168.0.11/axis-cgi/operator/dynamicoverlay.cgi?action=settext&text=$argv[1]";
$cam4 = "http://192.168.0.12/axis-cgi/operator/dynamicoverlay.cgi?action=settext&text=$argv[1]";

$ch = curl_init();    

curl_setopt ($ch, CURLOPT_FOLLOWLOCATION, true);
curl_setopt($ch, CURLOPT_HTTPAUTH, CURLAUTH_ANY);
curl_setopt($ch, CURLOPT_USERPWD, "viewer:online"); 

curl_setopt($ch, CURLOPT_URL, $cam2); 
$result = curl_exec($ch); 
curl_setopt($ch, CURLOPT_URL, $cam3);
$result = curl_exec($ch);
curl_setopt($ch, CURLOPT_URL, $cam4);
$result = curl_exec($ch);

curl_close($ch); 
?>
