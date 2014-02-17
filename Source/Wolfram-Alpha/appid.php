<?php
require_once('workflows.php');
$w = new Workflows('tylereich.wolframalpha');
$q = $argv[1];
$id = urlencode($q);
$xml_string = $w->request("http://api.wolframalpha.com/v2/validatequery?input=hello+world&appid=$id");
$xml = simplexml_load_string($xml_string);
if($xml['error']=='false'){
	$w->result(
		'wolfram-appid valid',
		$q,
		"Set AppID to '$q'",
		'This is a valid Wolfram|Alpha AppID',
		'icon.png',
		'yes'
	);
}elseif($xml->error->msg == 'Invalid appid'){
	$w->result(
		'wolfram-appid invalid',
		'open http://products.wolframalpha.com/api/',
		"'$q' is Not a Valid AppID",
		'Action this item to get a valid AppID.',
		'icon.png',
		'yes'
	);
}else{
	$w->result(
		'wolfram-error',
		'open http://products.wolframalpha.com/api/',
		'An Error Occurred!',
		'Wolfram|Alpha could not be reached',
		'icon.png',
		'no'
	);
}
echo $w->toxml();
?>