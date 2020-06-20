<?php
session_start();
	if (isset($_SESSION['userid'])) {
		unset($_SESSION['userid']);
	}

	if (isset($_SESSION['usrFullName'])) {
		unset($_SESSION['usrFullName']);
	}

	if (isset($_SESSION['sessionid'])) {
		unset($_SESSION['sessionid']);
	}

	if (isset($_SESSION['usrEmail'])) {
		unset($_SESSION['usrEmail']);
	}
	
	session_destroy();
?>
<script type="text/javascript"><!--
  window.location = "index.php";
 //-->
</script>