<?php
 	$mysql = mysql_connect('localhost', 'root', '');
    mysql_select_db( 'webofscience' );
    $Query = "insert into list values (
    '".$_POST['s1']."',
    '".$_POST['s2']."',
    '".$_POST['s3']."',
    '".$_POST['s4']."',
    '".$_POST['s5']."',
    '".$_POST['s6']."',
    '".$_POST['s7']."',
    '".$_POST['s8']."',
    '".$_POST['s9']."',
    '".$_POST['s10']."',
    '".$_POST['s11']."',
    '".$_POST['s12']."',
    '".$_POST['s13']."',
    '".$_POST['s14']."',
    '".$_POST['s15']."',
    '".$_POST['s16']."',
    '".$_POST['s17']."',
    '".$_POST['s18']."',
    '".$_POST['s19']."',
    '".$_POST['s20']."',
    '".$_POST['s21']."',
    '".$_POST['s22']."',
    '".$_POST['s23']."',
    '".$_POST['s24']."',
    '".$_POST['s25']."',
    '".$_POST['s26']."',
    '".$_POST['s27']."',
    '".$_POST['s28']."',
    '".$_POST['s29']."',
    '".$_POST['s30']."',
    '".$_POST['s31']."',
    '".$_POST['s32']."',
    '".$_POST['s33']."',
    '".$_POST['s34']."',
    '".$_POST['s35']."',
    '".$_POST['s36']."',
    '".$_POST['s37']."',
    '".$_POST['s38']."',
    '".$_POST['s39']."',
    '".$_POST['s40']."',
    '".$_POST['s41']."',
    '".$_POST['s42']."',
    '".$_POST['s43']."',
    '".$_POST['s44']."',
    '".$_POST['s45']."',
    '".$_POST['s46']."',
    '".$_POST['s47']."',
    '".$_POST['s48']."',
    '".$_POST['s49']."',
    '".$_POST['s50']."',
    '".$_POST['s51']."')";
    $Result = mysql_query( $Query );
    print("ok");
 ?>
