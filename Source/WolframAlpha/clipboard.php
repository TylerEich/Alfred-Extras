<?php
$q = $argv[1];
if($q == 'open http://products.wolframalpha.com/api/'){
	`$q`;
	return;
}
include_once('workflows.php');
$w = new Workflows('tylereich.wolframalpha');
$xml_string = $w->read($w->cache().'/wolfram.xml');
$xml = simplexml_load_string($xml_string);
echo $xml->pod[1]->subpod->plaintext;
?>