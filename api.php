<?php
require_once('db.php');
$DB = new DB;
$_version = '1.0';
$_encoding = 'UTF-8';
$_catList= array();
$_newsList= array();
$_path="http://renukatechnologies.in/demo/classic_flutter_news/";
$_images=$_path."images/";


if (isset($_GET['get'])) {
	
	//get Top articles
	if($_GET['get']=="top"){
	$query = "SELECT P.id, P.news_title, P.news_cover_img, P.published_on, P.news_views, P.news_description, P.news_cat,(
       select group_concat(C.category_name SEPARATOR ',')
       from tbl_category C
       WHERE (LOCATE(CONCAT(' ',C.cid, ','), P.news_cat) > 0)
) as categories
from tbl_news P WHERE featured=1 and status=1 ORDER BY P.published_on DESC Limit 5 ;" or die("SELECT Error: ".$DB->error());
		
		$query_cat = "SELECT tc.category_name, cid, category_image, COUNT(tn.category_id) AS post_count from tbl_category AS tc INNER JOIN tbl_news_category tn ON tc.cid = tn.category_id WHERE tc.category_status='1' GROUP BY tn.category_id ORDER BY category_sequence" or die("SELECT Error: ".$DB->error());
		
		$news_check = $DB->select($query);
		if ( count( $news_check ) > 0 ) {
			foreach ( $news_check as $key => $get_info ) {
				$_newsList[$key]['id']= $get_info['id'];
				$_newsList[$key]['title']= $get_info['news_title'];
				$_newsList[$key]['coverImage']= $_images.$get_info['news_cover_img'];
				$_newsList[$key]['related']= $_path.'api.php?get=related&id='.substr($get_info['news_cat'], 0, -1);
				$_newsList[$key]['published']= substr($get_info['published_on'],0,10);
				$_newsList[$key]['newsViews']= $get_info['news_views'];
				$_newsList[$key]['category']= $get_info['categories'];
				$_newsList[$key]['summary']= $get_info['news_description'];
				
			}
		}
		
		$cat_check = $DB->select($query_cat);
		
		if ( count( $cat_check ) > 0 ) {
			foreach ( $cat_check as $key => $get_info ) {
				$_catList[$key]['title']= $get_info['category_name'];
				$_catList[$key]['href']= $_path.'api.php?get=cat&id='.$get_info['cid'];
				$_catList[$key]['image']= $get_info['category_image'];
				$_catList[$key]['count']= $get_info['post_count'];
			}
		}
		
		//Print array in JSON format
		$row_feed['link'] = $_catList;
		$row_feed['entry'] = $_newsList;

		$row_array['version'] = $_version;
		$row_array['encoding'] = $_encoding;
		$row_array['feed'] = $row_feed;
		header('Content-type:application/json;charset=utf-8');		
 		echo json_encode($row_array);
	}
	
	//get trends articles
	if($_GET['get']=="trends"){
	$query = "SELECT P.id, P.news_title, P.news_cover_img, P.published_on, P.news_views, P.news_description, P.news_cat, (
       select group_concat(C.category_name SEPARATOR ',')
       from tbl_category C
       WHERE (LOCATE(CONCAT(' ',C.cid, ','), P.news_cat) > 0)
) as categories
from tbl_news P WHERE isTrending=1 and status=1 ORDER BY P.published_on DESC Limit 4;" or die("SELECT Error: ".$DB->error());

		
		$news_check = $DB->select($query);
		if ( count( $news_check ) > 0 ) {
			foreach ( $news_check as $key => $get_info ) {
				$_newsList[$key]['id']= $get_info['id'];
				$_newsList[$key]['title']= $get_info['news_title'];
				$_newsList[$key]['coverImage']= $_images.$get_info['news_cover_img'];
				$_newsList[$key]['related']= $_path.'api.php?get=related&id='.substr($get_info['news_cat'], 0, -1);
				$_newsList[$key]['published']= substr($get_info['published_on'],0,10);
				$_newsList[$key]['newsViews']= $get_info['news_views'];
				$_newsList[$key]['category']= $get_info['categories'];
				$_newsList[$key]['summary']= $get_info['news_description'];
				
			}
		}

		$_catList[0]['title']= 'Short Stories';
		$_catList[0]['href']= 'related.json';
		$_catList[0]['image']= 'skipping.jpg';
		$_catList[0]['count']= '2020';

		
		//Print array in JSON format
		$row_feed['link'] = $_catList;
		$row_feed['entry'] = $_newsList;

		$row_array['version'] = $_version;
		$row_array['encoding'] = $_encoding;
		$row_array['feed'] = $row_feed;
		header('Content-type:application/json;charset=utf-8');		
 		echo json_encode($row_array);
	}
	
	
	//get breaking articles
	if($_GET['get']=="breaking"){
	$query = "SELECT P.id, P.news_title, P.news_cover_img, P.published_on, P.news_views, P.news_description, P.news_cat, (
       select group_concat(C.category_name SEPARATOR ',')
       from tbl_category C
       WHERE (LOCATE(CONCAT(' ',C.cid, ','), P.news_cat) > 0)
) as categories
from tbl_news P WHERE isBreaking=1 and status=1 ORDER BY P.published_on DESC Limit 10;" or die("SELECT Error: ".$DB->error());
		
		$news_check = $DB->select($query);
		if ( count( $news_check ) > 0 ) {
			foreach ( $news_check as $key => $get_info ) {
				$_newsList[$key]['id']= $get_info['id'];
				$_newsList[$key]['title']= $get_info['news_title'];
				$_newsList[$key]['coverImage']= $_images.$get_info['news_cover_img'];
				$_newsList[$key]['related']= $_path.'api.php?get=related&id='.substr($get_info['news_cat'], 0, -1);
				$_newsList[$key]['published']= substr($get_info['published_on'],0,10);
				$_newsList[$key]['newsViews']= $get_info['news_views'];
				$_newsList[$key]['category']= $get_info['categories'];
				$_newsList[$key]['summary']= $get_info['news_description'];
				
			}
		}

		$_catList[0]['title']= 'Short Stories';
		$_catList[0]['href']= 'related.json';
		$_catList[0]['image']= 'skipping.jpg';
		$_catList[0]['count']= '2020';

		
		//Print array in JSON format
		$row_feed['link'] = $_catList;
		$row_feed['entry'] = $_newsList;

		$row_array['version'] = $_version;
		$row_array['encoding'] = $_encoding;
		$row_array['feed'] = $row_feed;
		header('Content-type:application/json;charset=utf-8');		
 		echo json_encode($row_array);
	}
	
	//get Categories articles
	if($_GET['get']=="cat"){
	$_page=" LIMIT 10";
		if (isset($_GET['page'])) {
			$_page=" LIMIT ".(($_GET['page']-1)*10).", 10";
		}
	$query = "SELECT P.id, P.news_title, P.news_cover_img, P.published_on, P.news_views, P.news_description, P.news_cat, (
       	select group_concat(C.category_name SEPARATOR ',')
       	from tbl_category C
       	WHERE (LOCATE(CONCAT(' ',C.cid, ','), P.news_cat) > 0)) as categories
		from tbl_news P 
		INNER JOIN tbl_news_category tnc ON P.id=tnc.news_id
		WHERE tnc.category_id=".$_GET['id']." and status=1 ORDER BY P.published_on DESC ".$_page.";" or die("SELECT Error: ".$DB->error());
		
		$news_check = $DB->select($query);
		if ( count( $news_check ) > 0 ) {
			foreach ( $news_check as $key => $get_info ) {
				$_newsList[$key]['id']= $get_info['id'];
				$_newsList[$key]['title']= $get_info['news_title'];
				$_newsList[$key]['coverImage']= $_images.$get_info['news_cover_img'];
				$_newsList[$key]['related']= $_path.'api.php?get=related&id='.substr($get_info['news_cat'], 0, -1);
				$_newsList[$key]['published']= substr($get_info['published_on'],0,10);
				$_newsList[$key]['newsViews']= $get_info['news_views'];
				$_newsList[$key]['category']= $get_info['categories'];
				$_newsList[$key]['summary']= $get_info['news_description'];
				
			}
		$row_feed['entry'] = $_newsList;
		}

		$_catList[0]['title']= 'Short Stories';
		$_catList[0]['href']= 'related.json';
		$_catList[0]['image']= 'skipping.jpg';
		$_catList[0]['count']= '2020';

		
		//Print array in JSON format
		$row_feed['link'] = $_catList;

		$row_array['version'] = $_version;
		$row_array['encoding'] = $_encoding;
		$row_array['feed'] = $row_feed;
		header('Content-type:application/json;charset=utf-8');		
 		echo json_encode($row_array);
	}
	
	
	//get Related articles
	if($_GET['get']=="related"){
	$query = "SELECT P.id, P.news_title, P.news_cover_img, P.published_on, P.news_views, P.news_description, P.news_cat, (
       select group_concat(C.category_name SEPARATOR ',')
       from tbl_category C
       WHERE (LOCATE(CONCAT(' ',C.cid, ','), P.news_cat) > 0)
) as categories
from tbl_news P 
INNER JOIN tbl_news_category tnc ON P.id=tnc.news_id
WHERE tnc.category_id IN(".$_GET['id'].") and status=1 GROUP BY P.id ORDER BY RAND() LIMIT 5;" or die("SELECT Error: ".$DB->error());
		
		$news_check = $DB->select($query);
		if ( count( $news_check ) > 0 ) {
			foreach ( $news_check as $key => $get_info ) {
				$_newsList[$key]['id']= $get_info['id'];
				$_newsList[$key]['title']= $get_info['news_title'];
				$_newsList[$key]['coverImage']= $_images.$get_info['news_cover_img'];
				$_newsList[$key]['related']= $_path.'api.php?get=related&id='.substr($get_info['news_cat'], 0, -1);
				$_newsList[$key]['published']= substr($get_info['published_on'],0,10);
				$_newsList[$key]['newsViews']= $get_info['news_views'];
				$_newsList[$key]['category']= $get_info['categories'];
				$_newsList[$key]['summary']= $get_info['news_description'];
				
			}
		}

		$_catList[0]['title']= 'Short Stories';
		$_catList[0]['href']= 'related.json';
		$_catList[0]['image']= 'skipping.jpg';
		$_catList[0]['count']= '2020';

		
		//Print array in JSON format
		$row_feed['link'] = $_catList;
		$row_feed['entry'] = $_newsList;

		$row_array['version'] = $_version;
		$row_array['encoding'] = $_encoding;
		$row_array['feed'] = $row_feed;
		header('Content-type:application/json;charset=utf-8');		
 		echo json_encode($row_array);
	}
	
	//get Search articles
	if($_GET['get']=="search"){
	$_page=" LIMIT 10";
		if (isset($_GET['page'])) {
			$_page=" LIMIT ".(($_GET['page']-1)*10).", 10";
		}
	$query = "SELECT P.id, P.news_title, P.news_cover_img, P.published_on, P.news_views, P.news_description, P.news_cat, (
       	select group_concat(C.category_name SEPARATOR ',')
       	from tbl_category C
       	WHERE (LOCATE(CONCAT(' ',C.cid, ','), P.news_cat) > 0)) as categories
		from tbl_news P 
		INNER JOIN tbl_news_category tnc ON P.id=tnc.news_id
		WHERE P.news_title LIKE '%".$_GET['char']."%' and status=1 GROUP BY P.id ORDER BY P.published_on DESC ".$_page.";" or die("SELECT Error: ".$DB->error());
		
		$news_check = $DB->select($query);
		if ( count( $news_check ) > 0 ) {
			foreach ( $news_check as $key => $get_info ) {
				$_newsList[$key]['id']= $get_info['id'];
				$_newsList[$key]['title']= $get_info['news_title'];
				$_newsList[$key]['coverImage']= $_images.$get_info['news_cover_img'];
				$_newsList[$key]['related']= $_path.'api.php?get=related&id='.substr($get_info['news_cat'], 0, -1);
				$_newsList[$key]['published']= substr($get_info['published_on'],0,10);
				$_newsList[$key]['newsViews']= $get_info['news_views'];
				$_newsList[$key]['category']= $get_info['categories'];
				$_newsList[$key]['summary']= $get_info['news_description'];
				
			}
		$row_feed['entry'] = $_newsList;
		}

		$_catList[0]['title']= 'Short Stories';
		$_catList[0]['href']= 'related.json';
		$_catList[0]['image']= 'skipping.jpg';
		$_catList[0]['count']= '2020';

		
		//Print array in JSON format
		$row_feed['link'] = $_catList;

		$row_array['version'] = $_version;
		$row_array['encoding'] = $_encoding;
		$row_array['feed'] = $row_feed;
		header('Content-type:application/json;charset=utf-8');		
 		echo json_encode($row_array);
	}
	
	
	
}else{
	
}
?>