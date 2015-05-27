<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link href = "css/bootstrap.min.css" rel = "stylesheet">
<link href = "MyPages/stylesheet.css" rel = "stylesheet">
<title>Create Tab</title>
</head>
<body  style="background-color:#454444">
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
	<script src = "js/bootstrap.js"></script>
	<form:errors path = "tab" />
									<!-- Header part-->
									
	<div class = "navbar navbar-inverse navbar-static-top">
		<div class="container">
			<a href="/createtab" class="navbar-brand"><p style="font-size: 35px; font-family: Casendra"><img src="/MyImages/tabimage.jpg" height="35" width="35" style="padding-right:8px; padding-bottom:10px"><b>Create Tab<b></p></a>
		</div>
		<div class="container">
			<button style="padding-left:5px; padding-bottom:5px" class = " navbar-toggle" data-toggle="collapse" data-target = ".navHeaderCollapse">
				<span class = "icon-bar"></span>
				<span class = "icon-bar"></span>
				<span class = "icon-bar"></span>
			</button>
			<div class = "collapse navbar-collapse navHeaderCollapse">
				<ul class = "nav navbar-nav">
					<li><a href = "/">Inbox</a></li>
					<li><a href="/compose">Compose Mail</a></li>
				</ul>
			</div>
		</div>
	</div>
	
									<!-- Body -->
	<div  class="row"  >
		
		<div class="col-sm-12"  >
			<div id="mail-panel" style="background-color:#f1f2f2; height:540px">
				<form action="/tabcreated" method="post">
					
					<tr><td>${errorMessage}</td></tr>
					<table id="form_table" style="margin-left:20px">
						<tr><td>Tab Name:</td><td><input type="text" class="form-control" name = "tabName"></td></tr>
						<tr><td>Tab Description:</td><td> <textarea name = "tabDescription" class="form-control" cols="50" rows="5"></textarea></td></tr>
						<tr><td></td><td><center><input type="submit" value="Create" style="width:100px">&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp<input type="button" value="Discard" onclick="window.location='/'" style="width:100px"></center></td></tr>
					</table>
				</form>
			</div>
		</div>
	</div>
	
</body>
</html>