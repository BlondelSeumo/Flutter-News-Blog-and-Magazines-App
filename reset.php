<?php
session_start();
require_once('db.php');
$DB = new DB;

$query = "UPDATE tbl_user SET password='".md5(trim($_POST['password']))."' WHERE phone='" . $_POST[ 'email' ] . "' AND isActive ='1'";
$DB->query($query) or die("UPDATE Error: ".$DB->error());
$result = $DB->affected();
if ($result>0) {
	$row_array['status'] = "success";
	$row_array['msg'] = "Password has been updated Successfully.";
	echo json_encode($row_array);
	
}else{
	$row_array['status'] = "fail";
	$row_array['msg'] = "User Does not exits! Please Register.";
	echo json_encode($row_array);
}
?>