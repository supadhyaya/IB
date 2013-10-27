
<?php
// http://www.9lessons.info/2013/01/mongodb-php-tutorial.html >> resource

echo 'ETL started... get ready for visualization '."\n";
echo 'started at '.date('m/d/Y h:i:s a', time())."\n";

$m = new MongoClient(); // connect
$db = $m->selectDB("socialvoyce");


$user ='';
$password='';
$database ='socialvoyce';

$fileLoc='/opt/database-migration/sourcefiles/';
$srcdir='/opt/database-migration/current/';

// $beginDate = mktime(0,0,0,date("m"),date("d")-2,date("Y"))*1000;
// $endDate = mktime(0,0,0,date("m"),date("d"),date("Y"))*1000;

$beginDate = mktime(0,0,0,date("m"),date("d")-1,date("Y"))*1000;
$endDate = mktime(0,0,0,date("m"),date("d"),date("Y"))*1000;

$fileLoc = mysql_real_escape_string($fileLoc);
$beginDate = mysql_real_escape_string($beginDate);
$endDate = mysql_real_escape_string($endDate);
$srcdir = mysql_real_escape_string($srcdir);

// Define query for importing files
$TagQuery="mongoexport --db socialvoyce --collection tag --out ".$fileLoc."tag.txt -q '{\"createDate\":{\"\$gte\":new Date(".$beginDate."),\"\$lt\":new Date(".$endDate.")}}'";

$commentQuery="mongoexport --db socialvoyce --collection voting --out ".$fileLoc."comment.txt --fields _id,comments -q'{\"\$or\":[{\"createDate\":{\"\$gte\":new Date(".$beginDate."),\"\$lt\":new Date(".$endDate.")}},{\"comments\": { \"\$elemMatch\": { \"createDate\": { \"\$gte\": new Date(".$beginDate."),\"\$lt\": new Date(".$endDate.")}}}}]}'";

$Metricquery="mongoexport --db socialvoyce --collection voting --out ".$fileLoc."metrics.txt --fields _id,description,createDate,questionText,starsRankingValue,totalStars,totalVotes,votingHash,votingType,instance,user -q'{\"\$or\":[{\"createDate\":{\"\$gte\":new Date(".$beginDate."),\"\$lt\":new Date(".$endDate.")}},{\"comments\": { \"\$elemMatch\": { \"createDate\": { \"\$gte\": new Date(".$beginDate."),\"\$lt\": new Date(".$endDate.")}}}}]}'";

$Tag2query="mongoexport --db socialvoyce --collection voting --out ".$fileLoc."votingtag.txt --fields _id,tags  -q '{\"createDate\":{\"\$gte\":new Date(".$beginDate."),\"\$lt\":new Date(".$endDate.")}}'";

$Answerquery="mongoexport --db socialvoyce --collection voting --out ".$fileLoc."answer.txt --fields _id,answers  -q'{\"\$or\":[{\"createDate\":{\"\$gte\":new Date(".$beginDate."),\"\$lt\":new Date(".$endDate.")}},{\"comments\": { \"\$elemMatch\": { \"createDate\": { \"\$gte\": new Date(".$beginDate."),\"\$lt\": new Date(".$endDate.")}}}}]}'";

$Userquery="mongoexport --db socialvoyce --collection voting --out ".$fileLoc."votingUser.txt --fields _id,user,questionText  -q '{\"createDate\":{\"\$gte\":new Date(".$beginDate."),\"\$lt\":new Date(".$endDate.")}}'";



// Importing TagDetail
$output = array();
$ret = null;
echo "Importing Tag"."\n";
exec($TagQuery,
$output, $ret);
var_dump($output, $ret); 



// Importing Comments
$output = array();
$ret = null;
echo "Importing Comments"."\n";
exec($commentQuery,
$output, $ret);
var_dump($output, $ret); 



// Importing Metrics
$output = array();
$ret = null;
echo "Importing Metrics"."\n";
exec($Metricquery,
$output, $ret);
var_dump($output, $ret); 



// Importing Tags
$output = array();
$ret = null;
echo "Importing voting tags"."\n";
exec($Tag2query,
$output, $ret);
var_dump($output, $ret); 



// Importing Answers
$output = array();
$ret = null;
echo "Importing Answers"."\n";
exec($Answerquery,
$output, $ret);
var_dump($output, $ret); 


// Importing Users
$output = array();
$ret = null;
echo "Importing Users"."\n";
exec($Userquery,
$output, $ret);
var_dump($output, $ret); 


try  
{  


$sp="mysql  < ".$srcdir."sp/JSONArraySplitter.sql";
exec($sp,$out,$retval);


// Run the files in sequence
$answer_Extract="mysql < ".$srcdir."extract/answer_Extract.sql";
exec($answer_Extract,$out,$retval);

$tag_Extract="mysql < ".$srcdir."extract/tag_Extract.sql";
exec($tag_Extract,$out,$retval);

$voting_Extract="mysql  < ".$srcdir."extract/votingExtract.sql";
exec($voting_Extract,$out,$retval);


$votingTag="mysql  < ".$srcdir."extract/votingTag_Extract.sql";
exec($votingTag,$out,$retval);


$comment_Extract="mysql  < ".$srcdir."extract/comment_Extract.sql";
exec($comment_Extract,$out,$retval);


$seeder_Extract="mysql  < ".$srcdir."extract/seeder_Extract.sql";
exec($seeder_Extract,$out,$retval);


$user_Trans="mysql  < ".$srcdir."extract/user_Extract.sql";
exec($user_Trans,$out,$retval);



$standardization="mysql < ".$srcdir."standardization/listVotingID.sql";
exec($standardization,$out,$retval);


$answer_Trans="mysql  < ".$srcdir."transformation/answer_Trans.sql";
exec($answer_Trans,$out,$retval);

$comment_Trans="mysql < ".$srcdir."transformation/comment_Trans.sql";
exec($comment_Trans,$out,$retval);

$vote_Trans="mysql  < ".$srcdir."transformation/vote_Trans.sql";
exec($vote_Trans,$out,$retval);

$instance_Trans="mysql  < ".$srcdir."transformation/instance_Trans.sql";
exec($instance_Trans,$out,$retval);

$tag_Trans="mysql  < ".$srcdir."transformation/tag_Trans.sql";
exec($tag_Trans,$out,$retval);

$user_Trans="mysql  < ".$srcdir."transformation/user_Trans.sql";
exec($user_Trans,$out,$retval);

$social_Extract="mysql < ".$srcdir."extract/social_Extract.sql";
exec($social_Extract,$out,$retval);

$seeder_Trans="mysql  < ".$srcdir."reports/seeder.sql";
exec($seeder_Trans,$out,$retval);

echo "ETL completed"."\n";


echo "GA started "."\n";


include("/opt/database-migration/current/googleAnalytics_socialNetworks/index.php");


echo "GA finished "."\n";

$googleAnalytics_Extract_Trans="mysql < ".$srcdir."transformation/googleAnalytics_Extract_Trans.sql";
exec($googleAnalytics_Extract_Trans,$out,$retval);


$social_Trans="mysql  < ".$srcdir."transformation/social_Trans.sql";
exec($social_Trans,$out,$retval);

}  
catch (Exception $e)  
{  
throw new Exception( 'Error in elt_controller , please check inside /scripts and fix the problem', 0, $e);  
}  

echo 'Ended at '.date('m/d/Y h:i:s a', time())."\n";
?>
