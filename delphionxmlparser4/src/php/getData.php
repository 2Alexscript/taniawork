<?php 
$dataFile = @file("../data2/termsynthbio5.xml", FILE_IGNORE_NEW_LINES);
$printout = "";
foreach ($dataFile as $dataFileLine) {
	$printout .= $dataFileLine;
	
}
print $printout;
?>