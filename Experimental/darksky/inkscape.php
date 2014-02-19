<?php
//$names = array("clear-day", "clear-night", "rain", "snow", "sleet", "wind", "fog", "cloudy", "partly-cloudy-day", "partly-cloudy-night");
//$i = 1;
$names = array("alert");
$i = 'bell';
foreach($names as $name){
	`/opt/local/bin/inkscape $i.svg --export-png=$name.png -D -d512`;
	$i++;
}
?>