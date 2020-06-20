<?php
session_start();
require_once('db.php');
$DB = new DB;

$query = "SELECT * FROM tbl_user WHERE phone='" . $_POST[ 'phone' ] . "'";
$getUser = $DB->check($query);

if ($getUser > 0 ) {
	$row_array['status'] = "success";
	$row_array['msg'] = "User Does exits!";
	echo json_encode($row_array);
	
}else{
	$row_array['status'] = "fail";
	$row_array['msg'] = "User Does not exits! Please Register";
	echo json_encode($row_array);
}
?>