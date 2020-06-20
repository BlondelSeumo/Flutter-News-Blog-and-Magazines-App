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
$_imgDefault="abc.jpg";
$_newsTitle="";
$_newsDetails="";
$_isFeatured=0;
$_view=0;
$_review=0;


if (isset($_GET['action']) && $_GET['action']=="preview") {
	$query = "SELECT * FROM tbl_news WHERE id ='".trim($_GET['news'])."'" or die("SELECT Error: ".mysql_error());
	$get_cat = $DB->select($query);
	if(count($get_cat) > 0){

		$_newsTitle = $get_cat[0]['news_title'];
		$_newsDetails = $get_cat[0]['news_description'];
		$_imgDefault = $get_cat[0]['news_cover_img'];
		$_isFeatured = $get_cat[0]['featured'];
		$_view = $get_cat[0]['news_views'];
		$_review = $get_cat[0]['total_review'];
		
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
            <li class="nav-item">
              <a class="nav-link" href="news.php">
                <span class="menu-title">Manage News</span>
                <i class="mdi mdi-format-list-bulleted menu-icon"></i>
              </a>
            </li>
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
                  <i class="mdi mdi mdi-television-guide"></i>
                </span> News Preview </h3>
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
                    <h4 class="card-title"><?=$_newsTitle;?></h4>
					  <p><?php 
						  if($_isFeatured){
							  echo '<button type="button" class="btn-sm btn-inverse-success btn-icon-text">
                            <i class="mdi mdi-file-check btn-icon-prepend"></i> Featured </button>';
						  }						  
						  ?>
						  <button type="button" class="btn-sm btn-inverse-info btn-icon-text btn-icon-prepend">
                            <i class="mdi mdi-television-guide"></i> <?=$_view;?> Views </button>
					    <button type="button" class="btn-sm btn-inverse-danger btn-icon-text">
                            <i class="mdi mdi mdi-comment-multiple-outline btn-icon-prepend"></i> <?=$_review;?> Reviews </button>
                    </p>
					  <p><img src="images/<?=$_imgDefault;?>" title="<?=$_newsTitle;?>" width="350">  </p>
               		<?=$_newsDetails;?>                    
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