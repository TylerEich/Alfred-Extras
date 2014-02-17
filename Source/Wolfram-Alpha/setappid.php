<?php
$q = $argv[1];
if($q == 'open http://products.wolframalpha.com/api/'){
	`$q`;
	return;
}
require_once('workflows.php');
$w = new Workflows('tylereich.wolframalpha');
$id = $argv[1];
$w->set('appid', $id, 'settings.plist');
echo $id;
?>