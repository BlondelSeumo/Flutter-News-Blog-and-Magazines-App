<?php
require_once('db.php');
$DB = new DB;

$query = "SELECT * FROM tbl_user WHERE phone='".trim($_POST[ 'email' ])."' AND password='".md5(trim($_POST['password']))."' AND isActive ='1'";
//$getUser = $DB->select($query) or die("Select Error: ".$DB->error()." - query is...".$query);
$user_check = $DB->select($query);

if (count($user_check) > 0 ) {
	$row_array['status'] = "success";
	$row_array['msg'] = "User exits!";
	$row_array['user'] = $user_check[0];
	echo json_encode($row_array);
	
}else{
	$row_array['status'] = "fail";
	$row_array['msg'] = "Please fill Login details correctly.";
	$row_array['user'] = '';
	echo json_encode($row_array);
}
?>