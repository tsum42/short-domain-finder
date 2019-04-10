#!/usr/bin/env php
<?php
// queries samoanic (ws tld) www service whois that has no limits and no captchas. run from commandline with
// $ php ws.php
// and not from browser/server, you will get a 504 gateway timeout or php sock will kill itself ˘~˘
header("Content-type: text/plain");
$znaki = array("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
"n", "o", "p", "q", "r", "s", "t", "u", "v", "x", "y", "z");
foreach($znaki as $znak1) {
	foreach($znaki as $znak2) {
		$postdata = http_build_query(
			array(
				'userid' => '',
				'xs' => "",
				'notfromwhois' => '',
				'domain' => $znak1.$znak2,
				'tld' => "WS"
			)
		);

		$opts = array('http' =>
			array(
				'method'  => 'POST',
				'header'  => 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8',
				'content' => $postdata
			)
		);

		$context  = stream_context_create($opts);

		$result = file_get_contents('http://samoanic.ws/whois.dhtml', false, $context);
		if (strpos($result, 'Congratulations') !== false) {
			echo $znak1.$znak2.".ws <-- FREE\n";
		} else {
			echo $znak1.$znak2.".ws <-- REGISTERED\n";
		}
	}
}
?>
