<?php
require_once('conn.php');
require_once('/opt/database-migration/shared/credentials/config_gapi.php');
require_once('/opt/database-migration/current/googleAnalytics_socialNetworks/gapi.class.php');
 

class Model {

   function getShares() {

  	 $myquery = "SELECT fullurl FROM url_table";
	 $doquery = mysql_query($myquery) or die(mysql_error());
	 $result = "";
	 while ($display_res = mysql_fetch_array($doquery)) {
      $url = $display_res['fullurl'];

      set_time_limit( 900 );
	  $json_string = file_get_contents('http://urls.api.twitter.com/1/urls/count.json?url=' . $url);
	  $json = json_decode($json_string, true);
	  $twitter = intval( $json['count'] );
	
	  $json_string = file_get_contents("http://www.linkedin.com/countserv/count/share?url=$url&format=json");
	  $json = json_decode($json_string, true);
	  $linkedin = intval( $json['count'] );
	
	  $json_string = file_get_contents("http://api.facebook.com/method/fql.query?query=select%20like_count,share_count%20from%20link_stat%20where%20url='".$url."'&format=json");
	  $json_string = preg_replace('/\[|\]/', '', $json_string);
	  $json = json_decode($json_string, true);
	  $facebooklikes = intval( $json['like_count'] );
	  $facebookshares = intval( $json['share_count'] );
	
	  $curl = curl_init();
	  curl_setopt($curl, CURLOPT_URL, "https://clients6.google.com/rpc");
	  curl_setopt($curl, CURLOPT_POST, 1);
	  curl_setopt($curl, CURLOPT_POSTFIELDS, '[{"method":"pos.plusones.get","id":"p","params":{"nolog":true,"id":"' . $url . 		'","source":"widget","userId":"@viewer","groupId":"@self"},"jsonrpc":"2.0","key":"p","apiVersion":"v1"}]');
	  curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
	  curl_setopt($curl, CURLOPT_HTTPHEADER, array('Content-type: application/json'));
	  $curl_results = curl_exec ($curl);
	  curl_close ($curl);
	  $json = json_decode($curl_results, true);
	  $plusone = intval( $json[0]['result']['metadata']['globalCounts']['count'] );

	  $s_url = mysql_real_escape_string($url);
	  $s_twitter = mysql_real_escape_string($twitter);
	  $s_linkedin = mysql_real_escape_string($linkedin);
	  $s_facebookshares = mysql_real_escape_string($facebookshares);
	  $s_facebooklikes = mysql_real_escape_string($facebooklikes);
	  $s_plusone = mysql_real_escape_string($plusone);
	  $mysocialquery = "INSERT INTO scrubSocialLike VALUES ( '$s_url', '$s_twitter',  '$s_linkedin',  '$s_facebooklikes',  '$s_facebookshares',  '$s_plusone')";
	  $dosocialquery = mysql_query($mysocialquery) or die(mysql_error());
      }
	  }


	function get_analyticsdata(){
	
	
	$gVisits = new gapi(ga_email_voycer,ga_password_voycer);
	$gReferrals = new gapi(ga_email_voycer,ga_password_voycer);
	
	$myquery = "SELECT shortUrl FROM url_table where instanceName='voycer'";
	//$myquery = "SELECT url FROM test";
	$doquery = mysql_query($myquery) or die(mysql_error());
	while ($display_res = mysql_fetch_array($doquery)) {
    $filter = "'ga:pagePath==".$display_res['shortUrl']."'";
	
	$gVisits->requestReportData(ga_profile_id_voycer,array('pagePath','hostname'),array('visits','visitors',
	'newVisits','pageviews','avgTimeOnPage','visitBounceRate'),'-pagePath',$filter);
	$gReferrals->requestReportData(ga_profile_id_voycer,array('pagePath','fullReferrer','deviceCategory','hostname'),array('visits'),'-pagePath',$filter);

	
	foreach($gVisits->getResults() as $result):
	
	$pagepath = mysql_real_escape_string($result->getPagePath());
	$visits = mysql_real_escape_string($result->getVisits());
	$visitors = mysql_real_escape_string($result->getVisitors());
	$newVisits = mysql_real_escape_string($result->getNewVisits());
	$pageviews = mysql_real_escape_string($result->getPageviews());
	$avgTimeOnPage = mysql_real_escape_string($result->getAvgTimeOnPage());
	$visitBounceRate = mysql_real_escape_string($result->getVisitBounceRate());
	$hostname = mysql_real_escape_string($result->getHostname());
	
	$mysocialquery = "INSERT INTO tempVisits VALUES ( '$hostname.$pagepath', '$visits', '$visitors', 
	 '$newVisits', '$pageviews', '$avgTimeOnPage', '$visitBounceRate')";
	$dosocialquery = mysql_query($mysocialquery) or die(mysql_error());
	endforeach;
	  
		
	foreach($gReferrals->getResults() as $result2):
	$pagepath = mysql_real_escape_string($result2->getPagePath());
	$fullReferrer = mysql_real_escape_string($result2->getFullReferrer());
	$deviceCategory = mysql_real_escape_string($result2->getDeviceCategory());
	$hostname = mysql_real_escape_string($result2->getHostname());
	$visits = mysql_real_escape_string($result2->getVisits());	  
	  $mysocialquery2 = "INSERT INTO tempReferrals VALUES ( '$hostname.$pagepath', '$fullReferrer',
	  '$deviceCategory', '$visits')";
	  $dosocialquery2 = mysql_query($mysocialquery2) or die(mysql_error());
	  endforeach;
	}
	}


	function get_analyticsdata_sixx(){
	
	$gVisits = new gapi(ga_email_sixx,ga_password_sixx);
	$gReferrals = new gapi(ga_email_sixx,ga_password_sixx);
	
	
	$myquery = "SELECT shortUrl FROM url_table where instanceName='sixx-community'";
	//$myquery = "SELECT url FROM test";
	$doquery = mysql_query($myquery) or die(mysql_error());
	while ($display_res = mysql_fetch_array($doquery)) {
    $filter = "'ga:pagePath==".$display_res['shortUrl']."'";
	
	$gVisits->requestReportData(ga_profile_id_sixx,array('pagePath','hostname'),array('visits','visitors',
	'newVisits','pageviews','avgTimeOnPage','visitBounceRate'),'-pagePath',$filter);
	$gReferrals->requestReportData(ga_profile_id_sixx,array('pagePath','fullReferrer','deviceCategory','hostname'),array('visits'),'-pagePath',$filter);


	foreach($gVisits->getResults() as $result):
	
	$pagepath = mysql_real_escape_string($result->getPagePath());
	$visits = mysql_real_escape_string($result->getVisits());
	$visitors = mysql_real_escape_string($result->getVisitors());
	$newVisits = mysql_real_escape_string($result->getNewVisits());
	$pageviews = mysql_real_escape_string($result->getPageviews());
	$avgTimeOnPage = mysql_real_escape_string($result->getAvgTimeOnPage());
	$visitBounceRate = mysql_real_escape_string($result->getVisitBounceRate());
	$hostname = mysql_real_escape_string($result->getHostname());
	
	$mysocialquery = "INSERT INTO tempVisits VALUES ($hostname.$pagepath', '$visits', '$visitors', 
	 '$newVisits', '$pageviews', '$avgTimeOnPage', '$visitBounceRate')";
	$dosocialquery = mysql_query($mysocialquery) or die(mysql_error());
	endforeach;
	  
		
	foreach($gReferrals->getResults() as $result2):
	$pagepath = mysql_real_escape_string($result2->getPagePath());
	$fullReferrer = mysql_real_escape_string($result2->getFullReferrer());
	$deviceCategory = mysql_real_escape_string($result2->getDeviceCategory());
	$hostname = mysql_real_escape_string($result2->getHostname());
	$visits = mysql_real_escape_string($result2->getVisits());	  
	  $mysocialquery2 = "INSERT INTO tempReferrals VALUES ($hostname.$pagepath', '$fullReferrer',
	  '$deviceCategory', '$visits')";
	  $dosocialquery2 = mysql_query($mysocialquery2) or die(mysql_error());
	  endforeach;
	}
	}

	function get_analyticsdata_fitforfun(){

	$gVisits = new gapi(ga_email_fitforfun,ga_password_fitforfun);
	$gReferrals = new gapi(ga_email_fitforfun,ga_password_fitforfun);
	
	
	$myquery = "SELECT shortUrl FROM url_table where instanceName='fitforfun-community'";
	//$myquery = "SELECT url FROM test";
	$doquery = mysql_query($myquery) or die(mysql_error());
	while ($display_res = mysql_fetch_array($doquery)) {
    $filter = "'ga:pagePath==".$display_res['shortUrl']."'";
	
	$gVisits->requestReportData(ga_profile_id_fitforfun,array('pagePath','hostname'),array('visits','visitors',
	'newVisits','pageviews','avgTimeOnPage','visitBounceRate'),'-pagePath',$filter);
	$gReferrals->requestReportData(ga_profile_id_fitforfun,array('pagePath','fullReferrer','deviceCategory','hostname'),array('visits'),'-pagePath',$filter);

	
	foreach($gVisits->getResults() as $result):
	
	$pagepath = mysql_real_escape_string($result->getPagePath());
	$visits = mysql_real_escape_string($result->getVisits());
	$visitors = mysql_real_escape_string($result->getVisitors());
	$newVisits = mysql_real_escape_string($result->getNewVisits());
	$pageviews = mysql_real_escape_string($result->getPageviews());
	$avgTimeOnPage = mysql_real_escape_string($result->getAvgTimeOnPage());
	$visitBounceRate = mysql_real_escape_string($result->getVisitBounceRate());
	$hostname = mysql_real_escape_string($result->getHostname());
	
	$mysocialquery = "INSERT INTO tempVisits VALUES ( '$hostname.$pagepath', '$visits', '$visitors', 
	 '$newVisits', '$pageviews', '$avgTimeOnPage', '$visitBounceRate')";
	$dosocialquery = mysql_query($mysocialquery) or die(mysql_error());
	endforeach;
	  
		
	foreach($gReferrals->getResults() as $result2):
	$pagepath = mysql_real_escape_string($result2->getPagePath());
	$fullReferrer = mysql_real_escape_string($result2->getFullReferrer());
	$deviceCategory = mysql_real_escape_string($result2->getDeviceCategory());
	$hostname = mysql_real_escape_string($result2->getHostname());
	$visits = mysql_real_escape_string($result2->getVisits());	  
	  $mysocialquery2 = "INSERT INTO tempReferrals VALUES ( '$hostname.$pagepath', '$fullReferrer',
	  '$deviceCategory', '$visits')";
	  $dosocialquery2 = mysql_query($mysocialquery2) or die(mysql_error());
	  endforeach;
	}
	}

	function get_analyticsdata_mmi(){

	$gVisits = new gapi(ga_email_mmi,ga_password_mmi);
	$gReferrals = new gapi(ga_email_mmi,ga_password_mmi);
	
	
	$myquery = "SELECT shortUrl FROM url_table where instanceName='mmi-community'";
	//$myquery = "SELECT url FROM test";
	$doquery = mysql_query($myquery) or die(mysql_error());
	while ($display_res = mysql_fetch_array($doquery)) {
    $filter = "'ga:pagePath==".$display_res['shortUrl']."'";
	
	$gVisits->requestReportData(ga_profile_id_mmi,array('pagePath','hostname'),array('visits','visitors',
	'newVisits','pageviews','avgTimeOnPage','visitBounceRate'),'-pagePath',$filter);
	$gReferrals->requestReportData(ga_profile_id_mmi,array('pagePath','fullReferrer','deviceCategory','hostname'),array('visits'),'-pagePath',$filter);
	
	foreach($gVisits->getResults() as $result):
	
	$pagepath = mysql_real_escape_string($result->getPagePath());
	$visits = mysql_real_escape_string($result->getVisits());
	$visitors = mysql_real_escape_string($result->getVisitors());
	$newVisits = mysql_real_escape_string($result->getNewVisits());
	$pageviews = mysql_real_escape_string($result->getPageviews());
	$avgTimeOnPage = mysql_real_escape_string($result->getAvgTimeOnPage());
	$visitBounceRate = mysql_real_escape_string($result->getVisitBounceRate());
	$hostname = mysql_real_escape_string($result->getHostname());
	
	$mysocialquery = "INSERT INTO tempVisits VALUES ($hostname.$pagepath', '$visits', '$visitors', 
	 '$newVisits', '$pageviews', '$avgTimeOnPage', '$visitBounceRate')";
	$dosocialquery = mysql_query($mysocialquery) or die(mysql_error());
	endforeach;
	  
		
	foreach($gReferrals->getResults() as $result2):
	$pagepath = mysql_real_escape_string($result2->getPagePath());
	$fullReferrer = mysql_real_escape_string($result2->getFullReferrer());
	$deviceCategory = mysql_real_escape_string($result2->getDeviceCategory());
	$hostname = mysql_real_escape_string($result2->getHostname());
	$visits = mysql_real_escape_string($result2->getVisits());	  
	  $mysocialquery2 = "INSERT INTO tempReferrals VALUES ($hostname.$pagepath', '$fullReferrer',
	  '$deviceCategory', '$visits')";
	  $dosocialquery2 = mysql_query($mysocialquery2) or die(mysql_error());
	  endforeach;
	}
	}

	function get_analyticsdata_connect(){

	$gVisits = new gapi(ga_email_connect,ga_password_connect);
	$gReferrals = new gapi(ga_email_connect,ga_password_connect);
	
	
	$myquery = "SELECT shortUrl FROM url_table where instanceName='connect-community'";
	//$myquery = "SELECT url FROM test";
	$doquery = mysql_query($myquery) or die(mysql_error());
	while ($display_res = mysql_fetch_array($doquery)) {
    $filter = "'ga:pagePath==".$display_res['shortUrl']."'";
	
	$gVisits->requestReportData(ga_profile_id_connect,array('pagePath','hostname'),array('visits','visitors',
	'newVisits','pageviews','avgTimeOnPage','visitBounceRate'),'-pagePath',$filter);
	$gReferrals->requestReportData(ga_profile_id_connect,array('pagePath','fullReferrer','deviceCategory','hostname'),array('visits'),'-pagePath',$filter);

	
	foreach($gVisits->getResults() as $result):
	
	$pagepath = mysql_real_escape_string($result->getPagePath());
	$visits = mysql_real_escape_string($result->getVisits());
	$visitors = mysql_real_escape_string($result->getVisitors());
	$newVisits = mysql_real_escape_string($result->getNewVisits());
	$pageviews = mysql_real_escape_string($result->getPageviews());
	$avgTimeOnPage = mysql_real_escape_string($result->getAvgTimeOnPage());
	$visitBounceRate = mysql_real_escape_string($result->getVisitBounceRate());
	$hostname = mysql_real_escape_string($result->getHostname());
	
	$mysocialquery = "INSERT INTO tempVisits VALUES ($hostname.$pagepath', '$visits', '$visitors', 
	 '$newVisits', '$pageviews', '$avgTimeOnPage', '$visitBounceRate')";
	$dosocialquery = mysql_query($mysocialquery) or die(mysql_error());
	endforeach;
	  
		
	foreach($gReferrals->getResults() as $result2):
	$pagepath = mysql_real_escape_string($result2->getPagePath());
	$fullReferrer = mysql_real_escape_string($result2->getFullReferrer());
	$deviceCategory = mysql_real_escape_string($result2->getDeviceCategory());
	$hostname = mysql_real_escape_string($result2->getHostname());
	$visits = mysql_real_escape_string($result2->getVisits());	  
	  $mysocialquery2 = "INSERT INTO tempReferrals VALUES ($hostname.$pagepath', '$fullReferrer',
	  '$deviceCategory', '$visits')";
	  $dosocialquery2 = mysql_query($mysocialquery2) or die(mysql_error());
	  endforeach;
	}
	}
}

?>
