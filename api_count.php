<?php
require_once('db.php');
$DB = new DB;
if (isset($_GET['get'])) {
	if($_GET['get']=="update"){
		$query = "UPDATE tbl_news SET news_views=news_views + 1 WHERE id=".$_GET['id'];
		$DB->query($query) or die("Update Error: ".$DB->error());
	}
}
$row_array['status'] = "success";
header('Content-type:application/json;charset=utf-8');		
echo json_encode($row_array);
?>