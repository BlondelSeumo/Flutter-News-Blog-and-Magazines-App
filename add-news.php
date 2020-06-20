<?php
session_start();
	if (!isset($_SESSION['userid'])) {
?>		
	<script type="text/javascript"><!--
		window.location = "index.php";
		//-->
    </script>
<?php
	}
require_once('db.php');
$DB = new DB;
$message = "";
$_method="Add";
$_id=0;
$_imgDefault="abc.jpg";
$_isRequired="required";
$_isFeatured=1;
$_isPublish=1;
$_isTrending=1;
$_isBreaking=1;
$_newsTitle="";
$_newsDetails="";
$_cid="";
$_catSequence="";

if (isset($_POST['method']) && $_POST['method']=="Add") {
	$strCatlist="";
	for($i=0;$i<count($_POST['categories']);$i++){
    //echo $_POST['categories'][$i]."<br>";
		$_cid.=" ".$_POST['categories'][$i].",";
		$strCatlist.="(**,".$_POST['categories'][$i]."),";
  	}
	
	
	//print_r($_FILES);
	$strDummy=addslashes($_POST['summernote']);
	$imageFileType = strtolower(pathinfo($_FILES['catImage']['name'],PATHINFO_EXTENSION));
	$file_name = strtolower(str_replace(" ","_",$_FILES['catImage']['name']));
	$file_tmp =$_FILES['catImage']['tmp_name'];
	move_uploaded_file($file_tmp,"images/".$file_name);	
	$date = date('Y-m-d H:i:s');
	
	$query = "INSERT INTO tbl_news (featured, isBreaking, isTrending, news_title, news_cat, news_description, news_cover_img,published_on, status) VALUES('".trim($_POST['isFeatured'])."','".trim($_POST['isBreaking'])."','".trim($_POST['isTrending'])."','".addslashes(trim($_POST['txtTitle']))."','".$_cid."','".$strDummy."','".$file_name."', now(),'".trim($_POST['isPublish'])."')";
	//echo $query;
	$DB->query($query) or die("Insert Error at line 43: ".$DB->error());
	$_insetId=$DB->insert_id();
	//print_r($_insetId);
	$strCatlist=str_replace('**',$_insetId,$strCatlist);
	$query_catlist="INSERT INTO tbl_news_category (news_id,category_id) VALUES ".substr($strCatlist, 0, -1).";" or die("Category INSERT Error: ".$DB->error());
	$DB->query($query_catlist);
	
	$message='<div class="alert" role="alert" style="color: #ffffff;background-color: #1bcfb4; border-color: #1bcfb4;">
                      <i class="mdi mdi-check-decagram"></i>Sucess! News has been Published!</div>';

}

if (isset($_POST['method']) && $_POST['method']=="Edit") {
	$strCatlist="";
	for($i=0;$i<count($_POST['categories']);$i++){
    //echo $_POST['categories'][$i]."<br>";
		$_cid.=" ".$_POST['categories'][$i].",";
		$strCatlist.="(".$_POST['cid'].",".$_POST['categories'][$i]."),";
  	}
	$query_clear="DELETE FROM tbl_news_category WHERE news_id=".$_POST['cid'];
	$DB->query($query_clear);
	$query_catlist="INSERT INTO tbl_news_category (news_id,category_id) VALUES ".substr($strCatlist, 0, -1);
	//echo($query_catlist);
	$DB->query($query_catlist) or die("Category INSERT Error: ".$DB->error());
	
	$strDummy=addslashes($_POST['summernote']);
	$query ="";
	if($_FILES['catImage']['error'] > 0) { 
      $query = "UPDATE tbl_news SET news_title='".addslashes(trim($_POST['txtTitle']))."', news_cat='".$_cid."', featured='".trim($_POST['isFeatured'])."', isBreaking='".trim($_POST['isBreaking'])."', isTrending='".trim($_POST['isTrending'])."', status='".trim($_POST['isPublish'])."', news_description='".$strDummy."' WHERE id=".$_POST['cid'];
	}else{
		$imageFileType = strtolower(pathinfo($_FILES['catImage']['name'],PATHINFO_EXTENSION));
		$file_name = strtolower(str_replace(" ","_",$_FILES['catImage']['name']));
		$file_tmp =$_FILES['catImage']['tmp_name'];
		move_uploaded_file($file_tmp,"images/".$file_name);	
	
		$query = "UPDATE tbl_news SET news_title='".addslashes(trim($_POST['txtTitle']))."', news_cat='".$_cid."', featured='".trim($_POST['isFeatured'])."', isBreaking='".trim($_POST['isBreaking'])."', isTrending='".trim($_POST['isTrending'])."', status='".trim($_POST['isPublish'])."', news_description='".$strDummy."', news_cover_img='".$file_name."' WHERE id=".$_POST['cid'];	
	}
	//echo $query;die();
	$DB->query($query) or die("UPDATE Error: ".$DB->error());
	$message='<div class="alert" role="alert" style="color: #ffffff; background-color: #1bcfb4; border-color: #1bcfb4;">
                      <i class=" mdi mdi-check-decagram"></i>Sucess! News details updated!</div>';
}

if (isset($_GET['action']) && $_GET['action']=="edit") {
	$_isRequired="";
	$_method="Edit";
	$query = "SELECT * FROM tbl_news WHERE id ='".trim($_GET['news'])."'";
	$get_cat = $DB->select($query) or die("SELECT Error: ".$DB->error());
	if(count($get_cat) > 0){
		$_id= $get_cat[0]['id'];
		$_newsTitle = $get_cat[0]['news_title'];
		$_newsDetails = $get_cat[0]['news_description'];
		$_imgDefault = $get_cat[0]['news_cover_img'];
		$_isFeatured = $get_cat[0]['featured'];
		$_isTrending = $get_cat[0]['isTrending'];
		$_isBreaking = $get_cat[0]['isBreaking'];
		$_isPublish = $get_cat[0]['status'];
		$_catSequence = "$('#example-checkbox-list').multiselect('select', [".rtrim($get_cat[0]['news_cat'], ',')."]);";
		
		
	}
}
?>
<!DOCTYPE html>
<html lang="en">
  <head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Purple Admin</title>
    <!-- plugins:css -->
    <link rel="stylesheet" href="assets/vendors/mdi/css/materialdesignicons.min.css">
    <link rel="stylesheet" href="assets/vendors/css/vendor.bundle.base.css">
    <!-- endinject -->
    <!-- Plugin css for this page -->
	<link href="https://cdn.jsdelivr.net/npm/summernote@0.8.16/dist/summernote.min.css" rel="stylesheet">
    <!-- End plugin css for this page -->
    <!-- inject:css -->
    <!-- endinject -->
    <!-- Layout styles -->
    <link rel="stylesheet" href="assets/css/style.css">
	<link rel="stylesheet" href="assets/vendors/multiselect/css/bootstrap-multiselect.css">
	<link rel="stylesheet" href="assets/vendors/dropify/css/dropify.min.css">
	  <style type="text/css">
		  #example-checkbox-list-container{
			  position: relative;
		  }
 
    #example-checkbox-list-container .checkbox-list > li > a {
        display: block;
        padding: 3px 0;
        clear: both;
        font-weight: normal;
        line-height: 1.42857143;
        color: #333;
        white-space: nowrap;
    }
 
    #example-checkbox-list-container .checkbox-list > li > a:hover,
    #example-checkbox-list-container .checkbox-list > li > a:focus {
        color: #333;
        text-decoration: none;
        background-color: transparent;
    }
 
    #example-checkbox-list-container .checkbox-list > .active > a,
    #example-checkbox-list-container .checkbox-list > .active > a:hover,
    #example-checkbox-list-container .checkbox-list > .active > a:focus {
        color: #333;
        text-decoration: none;
        background-color: transparent;
        outline: 0;
    }
 
    #example-checkbox-list-container .checkbox-list > .disabled > a,
    #example-checkbox-list-container .checkbox-list > .disabled > a:hover,
    #example-checkbox-list-container .checkbox-list > .disabled > a:focus {
        color: #777;
    }
 
    #example-checkbox-list-container .checkbox-list > .disabled > a:hover,
    #example-checkbox-list-container .checkbox-list > .disabled > a:focus {
        text-decoration: none;
        cursor: unset;
        background-color: transparent;
        background-image: none;
        filter: progid:DXImageTransform.Microsoft.gradient(enabled = false);
    }
 
    #example-checkbox-list-container .checkbox-list > li > a > label {
        padding: 3px 0 3px 20px;
    }
 
    @media (min-width: 768px) {
        #example-checkbox-list-container .checkbox-list > li {
            float: left;
            width: 33%;
        }
        #example-checkbox-list-container .checkbox-list-vertical > li {
            float: none;
            width: 100%;
        }
    }
 
    #example-checkbox-list-container .multiselect-container.checkbox-list {
        position: static;
    }
 
</style>
    <!-- End layout styles -->
    <link rel="shortcut icon" href="assets/images/favicon.png" />
  </head>
  <body>
    <div class="container-scroller">
      <!-- partial:../../partials/_navbar.html -->
      <nav class="navbar default-layout-navbar col-lg-12 col-12 p-0 fixed-top d-flex flex-row">
        <div class="text-center navbar-brand-wrapper d-flex align-items-center justify-content-center">
          <a class="navbar-brand brand-logo" href="admin-dash.php"><img src="assets/images/logo.png" alt="logo" /></a>
          <a class="navbar-brand brand-logo-mini" href="admin-dash.php"><img src="assets/images/logo-mini.png" alt="logo" /></a>
        </div>
        <div class="navbar-menu-wrapper d-flex align-items-stretch">
          <button class="navbar-toggler navbar-toggler align-self-center" type="button" data-toggle="minimize">
            <span class="mdi mdi-menu"></span>
          </button>
          <ul class="navbar-nav navbar-nav-right">
            <li class="nav-item nav-profile dropdown">
              <a class="nav-link dropdown-toggle" id="profileDropdown" href="#" data-toggle="dropdown" aria-expanded="false">
                <div class="nav-profile-img">
                  <img src="assets/images/faces/face1.jpg" alt="image">
                  <span class="availability-status online"></span>
                </div>
                <div class="nav-profile-text">
                  <p class="mb-1 text-black"><?=$_SESSION['usrFullName']?></p>
                </div>
              </a>
              <div class="dropdown-menu navbar-dropdown" aria-labelledby="profileDropdown">
                <a class="dropdown-item" href="#">
                  <i class="mdi mdi-cached mr-2 text-success"></i> Activity Log </a>
                <div class="dropdown-divider"></div>
                <a class="dropdown-item" href="logout.php">
                  <i class="mdi mdi-logout mr-2 text-primary"></i> Signout </a>
              </div>
            </li>
            <li class="nav-item d-none d-lg-block full-screen-link">
              <a class="nav-link">
                <i class="mdi mdi-fullscreen" id="fullscreen-button"></i>
              </a>
            </li>
            <li class="nav-item nav-logout d-none d-lg-block">
              <a class="nav-link" href="logout.php">
                <i class="mdi mdi-power"></i>
              </a>
            </li>
          </ul>
          <button class="navbar-toggler navbar-toggler-right d-lg-none align-self-center" type="button" data-toggle="offcanvas">
            <span class="mdi mdi-menu"></span>
          </button>
        </div>
      </nav>
      <!-- partial -->
      <div class="container-fluid page-body-wrapper">
        <!-- partial:../../partials/_sidebar.html -->
        <nav class="sidebar sidebar-offcanvas" id="sidebar">
          <ul class="nav">
            <li class="nav-item nav-profile">
              <a href="#" class="nav-link">
                <div class="nav-profile-image">
                  <img src="assets/images/faces/face1.jpg" alt="profile">
                  <span class="login-status online"></span>
                  <!--change to offline or busy as needed-->
                </div>
                <div class="nav-profile-text d-flex flex-column">
                  <span class="font-weight-bold mb-2"><?=$_SESSION['usrFullName']?></span>
                  <span class="text-secondary text-small">Project Manager</span>
                </div>
                <i class="mdi mdi-bookmark-check text-success nav-profile-badge"></i>
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="admin-dash.php">
                <span class="menu-title">Dashboard</span>
                <i class="mdi mdi-home menu-icon"></i>
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="news.php">
                <span class="menu-title">Manage News</span>
                <i class="mdi mdi-format-list-bulleted menu-icon"></i>
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="categories.php">
                <span class="menu-title">Manage Categories</span>
                <i class="mdi mdi-bookmark-outline menu-icon"></i>
              </a>
            </li>
            <li class="nav-item sidebar-actions">
              <span class="nav-link">
                <div class="border-bottom">
                  <h6 class="font-weight-normal mb-3">Projects</h6>
                </div>
                <a class="btn btn-block btn-lg btn-gradient-primary mt-4" style="color: #fff" href="add-news.php">+ Add a News</a>
              </span>
            </li>
          </ul>
        </nav>
        <!-- partial -->
        <div class="main-panel">
          <div class="content-wrapper">
			              <div class="page-header">
              <h3 class="page-title">
                <span class="page-title-icon bg-gradient-primary text-white mr-2">
                  <i class="mdi mdi-format-list-bulleted"></i>
                </span> Add News </h3>
              <nav aria-label="breadcrumb">
                <ul class="breadcrumb">
                  <li class="breadcrumb-item active" aria-current="page">
                    <span></span>Overview <i class="mdi mdi-alert-circle-outline icon-sm text-primary align-middle"></i>
                  </li>
                </ul>
              </nav>
            </div>
			    <div class="col-12 grid-margin stretch-card">
                <div class="card">
                  <div class="card-body">
                    <h4 class="card-title">Enter News Details</h4>
               		<?=$message?>
                    <form class="forms-sample" method="post" action="add-news.php" enctype="multipart/form-data">
                      <div class="form-group">
                        <label for="txtTitle"><strong>News Title</strong></label>
                        <input type="text" class="form-control" id="txtTitle" name="txtTitle" placeholder="News Title" value="<?=$_newsTitle;?>" required>
                      </div>
					  <div class="form-group">
						<label for="isFeatured"><strong>Is Featured?</strong></label><p class="alert alert-danger"> *If selected News will be placed on <strong>Featured</strong> Section of App Home screen of News App.</p>
                        <div class="row" style="margin-left: 5px;">
							<div class="form-check col-1">
                                <label class="form-check-label">
                                  <input type="radio" class="form-check-input" name="isFeatured" id="isFeatured1" value="1" <?php if($_isFeatured=='1'){echo'checked';}?>> Yes </label>
                              </div>
                            
                              <div class="form-check">
                                <label class="form-check-label">
                                  <input type="radio" class="form-check-input" name="isFeatured" id="isFeatured2" value="0" <?php if($_isFeatured=='0'){echo'checked';}?>> No </label>
                              </div></div>
                              
						  
						</div>
						<div class="form-group">
						<label for="isTrending"><strong>Is Trending?</strong></label>
						<p class="alert alert-danger"> *If selected News will be placed on <strong>Treading</strong> Section of App Home screen of News App.</p>
                        <div class="row" style="margin-left: 5px;">
							<div class="form-check col-1">
                                <label class="form-check-label">
                                  <input type="radio" class="form-check-input" name="isTrending" id="isTrending1" value="1" <?php if($_isTrending=='1'){echo'checked';}?>> Yes </label>
                              </div>
                            
                              <div class="form-check">
                                <label class="form-check-label">
                                  <input type="radio" class="form-check-input" name="isTrending" id="isTrending2" value="0" <?php if($_isTrending=='0'){echo'checked';}?>> No </label>
                              </div></div>
                              
						  
						</div>
						
						<div class="form-group">
						<label for="isBreaking"><strong>Is Breaking?</strong></label>
						<p class="alert alert-danger"> *If selected News will be placed on <strong>Breaking</strong> Section of App Home screen of News App.</p>
                        <div class="row" style="margin-left: 5px;">
							<div class="form-check col-1">
                                <label class="form-check-label">
                                  <input type="radio" class="form-check-input" name="isBreaking" id="isBreaking1" value="1" <?php if($_isBreaking=='1'){echo'checked';}?>> Yes </label>
                              </div>
                            
                              <div class="form-check">
                                <label class="form-check-label">
                                  <input type="radio" class="form-check-input" name="isBreaking" id="isBreaking2" value="0" <?php if($_isBreaking=='0'){echo'checked';}?>> No </label>
                              </div></div>
                              
						  
						</div>
						<div class="form-group">
						<label for="isPublish"><strong>Status?</strong></label><p class="alert alert-danger"> *Only published News shown on News App.</p>
                        <div class="row" style="margin-left: 5px;">
							<div class="form-check col-2">
                                <label class="form-check-label">
                                  <input type="radio" class="form-check-input" name="isPublish" id="isPublish1" value="1" <?php if($_isPublish=='1'){echo'checked';}?>> Publish </label>
                              </div>
                            
                              <div class="form-check">
                                <label class="form-check-label">
                                  <input type="radio" class="form-check-input" name="isPublish" id="isPublish2" value="0" <?php if($_isPublish=='0'){echo'checked';}?>> UnPublish </label>
                              </div></div>
                              
						  
						</div>
                      <div class="form-group">
                        <label for="example-checkbox-list"><strong>News Categories</strong></label>
						<!-- Build your select: -->
						<select id="example-checkbox-list" name="categories[]" class="form-control" multiple="multiple" required>
							<?php 
				$query = "SELECT cid, category_name FROM tbl_category" or die("SELECT Error: ".mysql_error());
				$get_cat = $DB->select($query);
					foreach ($get_cat as $get_info) { 
						echo '<option value="'.$get_info['cid'].'">'.$get_info['category_name'].'</option>';
					}
				?></select>
                      </div>
                      <div class="form-group" style="clear: both;">
                        <label for="catImage" style="margin-top: 15px"><strong>Featured Images</strong></label><p class="alert alert-danger"> *For Best Presentation use featured Images size 600*300.</p>
                        <input type="file" name="catImage" id="catImage" class="dropify" data-max-file-size="5M" data-allowed-file-extensions="jpg png jpeg" data-default-file="images/<?=$_imgDefault?>" value="images/<?=$_imgDefault?>" <?=$_isRequired?> >
                      </div>
                      
                      <div class="form-group">
                        <label for="summernote"><strong>News Details</strong></label><p class="alert alert-danger"> *For Best Presentation use H3, H4 insted of H1, H2 and provide absolute path for Images, do not upload then through editor.</p>
                        <textarea class="form-control" id="summernote" name="summernote" rows="4"><?=$_newsDetails;?></textarea>
						</div>
					  <input name="cid" id="cid" type="hidden" value="<?=$_id?>">
					  <input name="method" id="method" type="hidden" value="<?=$_method?>">
                      <button type="submit" class="btn btn-gradient-primary mr-2"><?=$_method?></button>
                    </form>
                  </div>
                </div>
              </div>
			</div>
          <!-- content-wrapper ends -->
          <!-- partial:../../partials/_footer.html -->
          <footer class="footer">
            <div class="d-sm-flex justify-content-center justify-content-sm-between">
              <span class="text-muted text-center text-sm-left d-block d-sm-inline-block">Copyright © 2017 <a href="https://www.bootstrapdash.com/" target="_blank">BootstrapDash</a>. All rights reserved.</span>
              <span class="float-none float-sm-right d-block mt-1 mt-sm-0 text-center">Hand-crafted & made with <i class="mdi mdi-heart text-danger"></i></span>
            </div>
          </footer>
          <!-- partial -->
        </div>
        <!-- main-panel ends -->
      </div>
      <!-- page-body-wrapper ends -->
    </div>
    <!-- container-scroller -->
    <!-- plugins:js -->
    <script src="assets/vendors/js/vendor.bundle.base.js"></script>
    <!-- endinject -->
    <!-- Plugin js for this page -->
	<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.16/dist/summernote.min.js"></script>
	<script src="assets/vendors/multiselect/js/bootstrap-multiselect.js"></script>	
  	<script src="assets/vendors/dropify/js/dropify.min.js"></script>
  	<script src="assets/js/dropify.js"></script>
    <!-- End plugin js for this page -->
    <!-- inject:js -->
    <script src="assets/js/off-canvas.js"></script>
    <script src="assets/js/hoverable-collapse.js"></script>
    <script src="assets/js/misc.js"></script>
    <!-- endinject -->
    <!-- Custom js for this page -->
	  <script type="text/javascript">
	  $(document).ready(function() {
		  $('#summernote').summernote({
			  height: 350   //set editable area's height
		  });
		  $('#example-checkbox-list').multiselect({
            buttonContainer: '<div id="example-checkbox-list-container"></div>',
            buttonClass: '',
            templates: {
                button: '',
                ul: '<ul class="multiselect-container checkbox-list"></ul>',
            }
        });
		<?=$_catSequence;?>
		});
	  </script>
    <!-- End custom js for this page -->
  </body>
</html>