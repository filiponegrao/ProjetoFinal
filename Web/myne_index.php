<!DOCTYPE html>
<html>

	<?php

	 //Conectando com o banco de dados:

	 //ESSENCIAIS
	$form = $_POST["form"];
	$email = $_POST["email"];

	if($form == true)
	{
		$con_string = "host=139.82.24.237 port=5432 dbname=myne user=myne password=vfefrioenlircianmpoanotnenzduemaagcraarovalho";
		$query = "INSERT INTO testflight VALUES ('".$email."')";

		$conn = pg_connect($con_string);
		$result = pg_query($conn, $query);

		$modif = pg_affected_rows($result);

		pg_close();

		$form = false;
	}

	?>

	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
		<title>Myne</title>

		<!-- Bootstrap -->
		<link href="bootstrap/css/bootstrap.min.css" rel="stylesheet">

		<!-- CSS -->
		<link rel="stylesheet" type="text/css" href="css/myne_master.css">


		<!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
		<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
		<!--[if lt IE 9]>
		<script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
		<script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
	  <![endif]-->


	</head>

	<body>
		<img src="assets/images/ContactBackground.jpg" class="myne-body">


		<div class="container-fluid">
			<div class="row navbar-fixed-top header">
				<div class="col-xs-12 col-sm-4 logo">
					<img src="assets/images/logo_oficial.png" height="50px" alt="Myne logo">
				</div>

				<div class="hidden-xs col-sm-8">
					<ul class="nav navbar-nav items">
						<li class="active"><a href="#home">Home</a></li>
						<li><a href="#features">Features</a></li>
						<li><a href="#testflight">Testflight</a></li>
						<li><a href="#team">Team</a></li>
					</ul>
				</div>

			</div><!-- row header -->


			<div class="content">

				<div class="row home" id="home">
						<div class="col-xs-12 col-sm-6">
							OLAR
						</div>
						<div class="col-xs-12 col-sm-6">
							<!-- 16:9 aspect ratio -->
							<div class="embed-responsive embed-responsive-16by9 myne-teaser">
								<iframe src="https://www.youtube.com/embed/a9EiPWPxV8k" width="100%"></iframe>
							</div>
						</div>
				</div>

				<div class="row features" id="features">
						<div class="col-xs-12">
							<p>
								Features
							</p>
						</div>
				</div>

				<div class="row testflight" id="testflight">
						<div class="col-xs-12">

							<div class="form-text">
								<div class="row">
									<h1>Testflight</h1>
								</div>

								<div class="row">
									<p>If you'd like to test our app,<br>submit your e-mail and we'll send you an invite!
									</p>
								</div>

								<!--  config do form de email -->
								<div class="row">
									<form name="register" method="post" action="myne_index.php">
										<div class="input-group test-form">
		    							<input class="form-control" placeholder="e-mail" aria-describedby="basic-addon2" type="text" name="email">
		    							<input class="btn" type="submit" value="ok" name="submit">
		    							<input type="hidden" name="form" value=true>
										</div>
									</form>
								</div>

							</div>

						</div>
				</div>


				<div class="row team" id="team">
						<div class="col-xs-12">
							<p>
								Team
							</p>
						</div>
				</div>

			</div> <!-- content-->

				<div class="row navbar-fixed-bottom myne-footer">
					<div class="col-xs-12 col-sm-4 disclaimer">
						<p>
							All rights reserved @ Myne Team (2015)
						</p>
					</div>

					<div class="col-xs-12 col-sm-8 footer-links">
						<ul class="navbar-nav items-footer">
							<li class=""><a href="#">Privacy Policies</a></li>
							<li><a href="#">Terms of Use</a></li>
							<li><a href="#">Contact Us</a></li>
						</ul>
					</div>

				</div><!-- row footer -->



		</div><!-- container-fluid -->










	<!-- Bootstrap core JavaScript ================================================== -->
	<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
	<!-- Placed at the end of the document so the pages load faster -->

	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
	<!-- Include all compiled plugins (below), or include individual files as needed -->
	<script src="bootstrap/js/bootstrap.min.js"></script>
	<script src="myne.js"></script>

	</body>
</html>
