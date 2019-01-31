<?php
define('SQL_HOST','localhost');
define('SQL_USER','bi'); 

define('SQL_PASS','xyz'); 

define('SQL_DB','socialvoyce'); 

$conn = mysql_connect(SQL_HOST, SQL_USER, SQL_PASS)
or die('Could not connect to the database; ' . mysql_error());
mysql_select_db(SQL_DB, $conn) or die('Could not select database; ' . mysql_error());
?>
