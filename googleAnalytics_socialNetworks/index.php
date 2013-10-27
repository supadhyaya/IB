<?php 
	require_once("Model.php");	require_once('Slugifier.php');	require_once('UniDecoder.php');
	require_once('conn.php'); require_once('error_handler.php');
	
	$model = new Model();         
	
///--------------------------This will 'slugify' to get the URLs

$slugifier = new Slugifier();

	$myquery = "SELECT * FROM url_table";
	$doquery = mysql_query($myquery) or die(mysql_error());
	while ($display_res = mysql_fetch_array($doquery)) {
	
       $this_id = $display_res['id'];
       $this_text = $display_res['questionText'];
       $this_votinghash = $display_res['votingHash'];
       $this_uri = $slugifier->slugify($this_text);
       
       //Voycer community is not added yet, you can add it if you want or delete this comment
       if ($display_res['instanceName'] == "sixx-community" ){
       $this_instance = "http://community.sixx.de";
       } else if($display_res['instanceName'] == "fitforfun-community" ){
        $this_instance = "http://community.fitforfun.de";
       } else if($display_res['instanceName'] == "mmi-community" ){
        $this_instance = "http://community.mmi.de";
       } else if($display_res['instanceName'] == "connect-community" ){
        $this_instance = "http://community.connect.de";
       }
       
       $onlyPagePath = mysql_real_escape_string("/" . $this_uri . "/" . "voting-ansehen" . "/" . $this_votinghash);
       $this_url = $this_instance . $onlyPagePath;
       $updatequery = "UPDATE url_table SET shortUrl = '".$onlyPagePath."', fullurl = '".$this_url."' WHERE id = ".$this_id;

	   $doupdate = mysql_query($updatequery) or die(mysql_error());
       
	   }

///-----------------------This is to get the shares
	$model->getShares();
    
//-------------------------Google Analytics for all communities

    // $model->get_analyticsdata();
    // $model->get_analyticsdata_sixx();
    // $model->get_analyticsdata_fitforfun();
    // $model->get_analyticsdata_mmi();
    // $model->get_analyticsdata_connect();

///----------------------------------------End
	   
?>