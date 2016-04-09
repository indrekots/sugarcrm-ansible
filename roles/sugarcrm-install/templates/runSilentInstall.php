#!/usr/bin/php
<?php
// UPDATE FOR YOUR URL
$siURL = "{{ site_url }}/install.php?goto=SilentInstall&cli=true";
// EXECUTE THROUGH CURL
$ch = curl_init($siURL);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HEADER, false);
curl_setopt($ch, CURLOPT_VERBOSE, true); // OPTIONAL FOR DEBUGGING CURL CALL
$result = curl_exec($ch);
echo "silent install url is {$siURL}" . PHP_EOL;
echo "silent install result is {$result}" . PHP_EOL;
if (strpos($result, 'Database Configuration') != false) {
    $result = curl_exec($ch);
}
else if (strpos($result, 'done') === false) {
    throw new Exception(
        "Failure in silent install -- Attempted URL: {$siURL}\nOutput: ".var_export($result, true)
    );
}
