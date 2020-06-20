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
$_cid=0;
$_catName="";
$_catStatus=1;
$_category_image="";
$_imgDefault="abc.jpg";
$_catSequence='1';
$_isRequired="required";

if (isset($_POST['method']) && $_POST['method']=="Add") {
	
	$imageFileType = strtolower(pathinfo($_FILES['catImage']['name'],PATHINFO_EXTENSION));
	$file_name = strtolower(str_replace(" ","_",$_POST['catName']).".".$imageFileType);
	$file_tmp =$_FILES['catImage']['tmp_name'];
	move_uploaded_file($file_tmp,"images/".$file_name);	
	
	
	$query = "INSERT INTO tbl_category (category_name, category_image, post_count, category_status,category_sequence) VALUES('".trim($_POST['catName'])."', '".$file_name."', '0', '".trim($_POST['categoryStatus'])."', '".trim($_POST['catSequence'])."')" or die("SELECT Error: ".mysql_error());
	$DB->query($query);
	$message='<div class="alert" role="alert" style="color: #ffffff;background-color: #1bcfb4; border-color: #1bcfb4;">
                      <i class="mdi mdi-check-decagram"></i>Sucess! New Category created!</div>';
}

if (isset($_POST['method']) && $_POST['method']=="Edit") {
	$query ="";
	if($_FILES['catImage']['error'] > 0) { 
      $query = "UPDATE tbl_category SET category_name='".trim($_POST['catName'])."', category_status='".trim($_POST['categoryStatus'])."', category_sequence='".trim($_POST['catSequence'])."' WHERE cid=".$_POST['cid'] or die("UPDATE Error: ".mysql_error());
	}else{
		$imageFileType = strtolower(pathinfo($_FILES['catImage']['name'],PATHINFO_EXTENSION));
		$file_name = strtolower(str_replace(" ","_",$_POST['catName']).".".$imageFileType);
		$file_tmp =$_FILES['catImage']['tmp_name'];
		move_uploaded_file($file_tmp,"images/".$file_name);
	
		$query = "UPDATE tbl_category SET category_name='".trim($_POST['catName'])."', category_status='".trim($_POST['categoryStatus'])."', category_image='".$file_name."', category_sequence='".trim($_POST['catSequence'])."' WHERE cid=".$_POST['cid'] or die("UPDATE Error: ".mysql_error());	
	}	
	
	$DB->query($query);
	$message='<div class="alert" role="alert" style="color: #ffffff; background-color: #1bcfb4; border-color: #1bcfb4;">
                      <i class=" mdi mdi-check-decagram"></i>Sucess! Category details updated!</div>';
}

if (isset($_GET['action']) && $_GET['action']=="edit") {
	$_isRequired="";
	$_method="Edit";
	$query = "SELECT * FROM tbl_category WHERE cid ='".trim($_GET['cat'])."'" or die("SELECT Error: ".mysql_error());
	$get_cat = $DB->select($query);
	if(count($get_cat) > 0){
		$_cid= $get_cat[0]['cid'];
		$_catName = $get_cat[0]['category_name'];
		$_catStatus = $get_cat[0]['category_status'];
		$_imgDefault = $get_cat[0]['category_image'];
		$_catSequence = $get_cat[0]['category_sequence'];
		
	}
}

$query = "SELECT tc.*, (SELECT COUNT(category_id) FROM tbl_news_category WHERE category_id =tc.cid) AS cat_post FROM tbl_category AS tc" or die("SELECT Error: ".$DB->error());
$category_check = $DB->select($query);
  
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
    <!-- End plugin css for this page -->
    <!-- inject:css -->
    <!-- endinject -->
    <!-- Layout styles -->
    <link rel="stylesheet" href="assets/css/style.css">
	<link rel="stylesheet" href="assets/vendors/dropify/css/dropify.min.css">
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
                  <i class="mdi mdi-bookmark-outline"></i>
                </span> Categories </h3>
              <nav aria-label="breadcrumb">
                <ul class="breadcrumb">
                  <li class="breadcrumb-item active" aria-current="page">
                    <span></span>Overview <i class="mdi mdi-alert-circle-outline icon-sm text-primary align-middle"></i>
                  </li>
                </ul>
              </nav>
            </div>
			   <div class="row">
              <div class="col-lg-6 grid-margin stretch-card">
                <div class="card">
                  <div class="card-body">
                    <h4 class="card-title">Categories</h4>
                    <p class="card-description">Your Categories are</p>
					  <div class="table-responsive-sm">
                    <table class="table" id="catTable">
                      <thead>
                        <tr>
                          <th>#</th>
                          <th>Image</th>
                          <th>Category</th>
                          <th>#Sq</th>
                          <th>Posts</th>
                          <th>Status</th>
                          <th>Action</th>
                        </tr>
                      </thead>
                      <tbody>
						  <?php if(count($category_check) > 0){
						  foreach ($category_check as $get_info) { ?>
						  
                        <tr>
                          <td><?=$get_info['cid'];?></td>
                          <td><div class="d-flex flex-row flex-wrap">
                      			<img src="images/<?=$get_info['category_image'];?>" class="img-lg rounded" alt="category image">
                    		</div>
						  </td>
                          <td><div style="text-overflow: ellipsis; overflow:hidden; white-space:nowrap; max-width: 80px;"><?=$get_info['category_name'];?></div></td>
                          <td><?=$get_info['category_sequence'];?></td>
						  <td><?=$get_info['cat_post'];?></td>
                          <td><?php if($get_info['category_status']=='1'){ echo'<i class="mdi mdi-toggle-switch text-success icon-md">';} else { echo'<i class="mdi mdi-toggle-switch-off text-danger icon-md">';}?></td>
                          <td><a href="categories.php?action=edit&cat=<?=$get_info['cid'];?>"><i class="mdi mdi-lead-pencil text-primary icon-md"></i></a></td>
                        </tr>
						  
						  <?php } 
							}else{   ?>
                        <tr>
                          <td colspan="5"><div class="alert" role="alert" style="color: #ffffff;background-color: #fe7c96;border-color: #fe7c96;">
                      <i class="mdi mdi-bug"></i> Oh snap! You don't have any Category yet!.</div></td>
                        </tr>
						  <?php }   ?>
                      </tbody>
                    </table>
					  </div>
                  </div>
                </div>
              </div>
              <div class="col-md-6 grid-margin stretch-card">
                <div class="card">
                  <div class="card-body">
                    <h4 class="card-title"><?=$_method?> Category</h4>
                    <p class="card-description">Manage your Categories here</p><?=$message;?>
                    <form class="forms-sample" action="categories.php" id="categoryForm" method="post" enctype="multipart/form-data">
                      <div class="form-group row">
                        <label for="catName" class="col-sm-3 col-form-label">Category</label>
                        <div class="col-sm-9">
                          <input type="text" class="form-control" id="catName" name="catName" placeholder="Category Name" value="<?=$_catName?>" required>
                        </div>
                      </div>
					  <div class="form-group row">
                        <label class="col-sm-3 col-form-label">Image</label>
                        <div class="col-sm-9">
                        <input type="file" name="catImage" class="dropify" data-max-file-size="5M" data-allowed-file-extensions="jpg png jpeg" data-default-file="images/<?=$_imgDefault?>" value="images/<?=$_imgDefault?>" <?=$_isRequired?> >
						  </div>
                      </div>
						<div class="form-group row">
                        <label for="catSequence" class="col-sm-3 col-form-label">Sequence</label>
                        <div class="col-sm-9">
                          <input type="text" class="form-control" id="catSequence" name="catSequence" placeholder="Category Sequence" value="<?=$_catSequence?>" required>
                        </div>
                      </div>
                      <div class="form-group row">
                        <label for="categoryStatus" class="col-sm-3 col-form-label">Status</label>
                        <div class="col-sm-4">
                              <div class="form-check">
                                <label class="form-check-label">
                                  <input type="radio" class="form-check-input" name="categoryStatus" id="categoryStatus1" value="1" <?php if($_catStatus=='1'){echo'checked';}?>> Active </label>
                              </div>
                            </div>
                            <div class="col-sm-5">
                              <div class="form-check">
                                <label class="form-check-label">
                                  <input type="radio" class="form-check-input" name="categoryStatus" id="categoryStatus2" value="0" <?php if($_catStatus=='0'){echo'checked';}?>> Disable </label>
                              </div>
                            </div>
                      </div>
					  <input name="cid" id="cid" type="hidden" value="<?=$_cid?>">
					  <input name="method" id="method" type="hidden" value="<?=$_method?>">
                      <button type="submit" class="btn btn-gradient-primary mr-2"><?=$_method?></button>
                    </form>
                  </div>
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
    <!-- End plugin js for this page -->
    <!-- inject:js -->
    <script src="assets/js/off-canvas.js"></script>
    <script src="assets/js/hoverable-collapse.js"></script>
    <script src="assets/js/misc.js"></script>
    <!-- endinject -->
    <!-- Custom js for this page -->
	  <script src="assets/vendors/dropify/js/dropify.min.js"></script>
	  <script src="assets/js/dropify.js"></script>
  </body>
</html>