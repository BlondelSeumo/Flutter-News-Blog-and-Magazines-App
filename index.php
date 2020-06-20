<?php
session_start();
require_once('db.php');
$DB = new DB;
$message = "";
if (isset($_POST['_login'])) {
		$query = "SELECT * FROM tbl_admin WHERE usrEmail ='".trim($_POST['email'])."' AND usrPwd ='".md5(trim($_POST['password']))."' AND usrStatus ='1'" or die("SELECT Error: ".mysql_error());
		//echo $query;
		$sql_check = $DB->select($query);
		//print_r($sql_check);
		if((count($sql_check) > 0)){
			$_SESSION['userid'] = $sql_check[0]['id'];
			$_SESSION['usrFullName'] = $sql_check[0]['usrFullName'];
			$_SESSION['usrEmail'] = $sql_check[0]['usrEmail'];
			$_SESSION['sessionid'] = md5(uniqid(rand()));
			$query_update="UPDATE tbl_admin SET UserSession='".$_SESSION["sessionid"]."' WHERE usrEmail ='".$_SESSION["usrEmail"]."' AND id =".$_SESSION["userid"]."" or die("Update Error: ".mysql_error());
			$result = $DB->query($query_update);
			?>
			<script type="text/javascript"><!--
				window.location = "admin-dash.php";
			//-->
			</script>
			<?php
			}else{
			$message = '<div class="alert" role="alert" style="color: #ffffff;background-color: #fe7c96;border-color: #fe7c96;">
                      <i class="mdi mdi-bug"></i> Oh snap! Change a few things up and try submitting again.</div>';
		}
		}
?>
<!DOCTYPE html>
<html lang="en">
  <head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Classic Flutter News - Admin Panel</title>
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
    <!-- End layout styles -->
    <link rel="shortcut icon" href="assets/images/favicon.png" />
  </head>
  <body>
    <div class="container-scroller">
      <div class="container-fluid page-body-wrapper full-page-wrapper">
        <div class="content-wrapper d-flex align-items-center auth">
          <div class="row flex-grow">
            <div class="col-lg-4 mx-auto">
              <div class="auth-form-light text-left p-5">
                <div class="brand-logo">
                  <img src="assets/images/logo.png">
                </div>
                <h4>Hello! let's get started</h4>
                <h6 class="font-weight-light">Sign in to continue.</h6>
                <form class="pt-3" method="post" action="index.php">
					<?=$message;?>
                  <div class="form-group">
                    <input type="email" class="form-control form-control-lg" name="email" id="email" placeholder="Username">
                  </div>
                  <div class="form-group">
                    <input type="password" class="form-control form-control-lg" name="password" id="password" placeholder="Password">
                  </div>
                  <div class="mt-3">
					<input name="_login" type="hidden">
                    <input type="submit" class="btn btn-block btn-gradient-primary btn-lg font-weight-medium auth-form-btn" value="LogIn">
                  </div>
                </form>
              </div>
            </div>
          </div>
        </div>
        <!-- content-wrapper ends -->
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
  </body>
</html>