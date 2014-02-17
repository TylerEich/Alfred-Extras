<?php
require_once('workflows.php');
$w = new Workflows('tylereich.wolframalpha');
$id = $w->get('appid','settings.plist');
if(!$id){
	$w->result(
		'wolfram-noappid',
		'open http://products.wolframalpha.com/api/',
		'Please provide your Wolfram|Alpha AppID',
		"Action this item to get an AppID. Set your AppID with the 'appid' keyword.",
		'icon.png',
		'yes'
	);
	echo $w->toxml();
	return;
}
$q = $argv[1];
$qurl = urlencode($q);
$xml_string = $w->request("http://api.wolframalpha.com/v2/query?appid=$id&input=$qurl&format=plaintext");
$xml_string = $xml_string;
$xml = simplexml_load_string($xml_string);
if($xml['error']=='true'){
	$w->result(
		'wolfram-error',
		$q,
		'An Error Occurred!',
		'Wolfram|Alpha did not return any results',
		'icon.png',
		'no'
	);
}elseif($xml->pod[0]->subpod->plaintext && $xml->pod[1]->subpod->plaintext){
	$w->result(
		"wolfram $q",
		$q,
		$xml->pod[1]->subpod->plaintext,
		$xml->pod[0]->subpod->plaintext,
		'icon.png',
		'yes'
	);
}else{
	$w->result(
		'wolfram-noresult',
		$q,
		'No Results Found',
		'Wolfram|Alpha could not find suitable results',
		'icon.png',
		'yes'
	);
}
$cache = $w->cache().'/wolfram.xml';
if(!$w->read($cache)){
	file_put_contents($cache,'');
}
$w->write($xml_string, $cache);
echo $w->toxml();
?>