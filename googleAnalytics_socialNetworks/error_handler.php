<?php

	function error_handler($error_type, $error_message, $error_file, $error_line) {
	switch ($error_type) {
	//fatal error
	case E_ERROR:
	echo "A little error occured while performing the operation. Kindly bear with us.";
	break;

	//notices
	case E_NOTICE:
	//don’t show notice errors
	break;
	}
	}
	//set the error handler to be us
set_error_handler("error_handler");
?>