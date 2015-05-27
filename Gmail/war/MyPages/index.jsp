<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="css/bootstrap.min.css" rel="stylesheet">
<link href="MyPages/stylesheet.css" rel="stylesheet">
<title>Inbox</title>
</head>
<body style="background-color: #454444">
	<script
		src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
	<script src="js/bootstrap.js"></script>

	<!-- Header part-->

	<div class="navbar navbar-inverse navbar-static-top">
		<div class="container">
			<a href="/" class="navbar-brand"><p	style="font-size: 35px; font-family: Casendra">
					<img src="/MyImages/inbox.jpg" height="35" width="35"
						style="padding-right: 8px; padding-bottom: 10px"/><b>Inbox</b>
				</p></a>
			<div class="col-lg-3 pull-right">
				<form action="/search" method="get">
					<div class="input-group " style="margin-top:17px">
					<span class="input-group-btn">
						<input type="text" name ="searchText" class="form-control" placeholder="Search">
						<button type="submit" class="btn btn-default">Go</button>
					</span>
					</div>
				</form>
			</div>
		</div>
		<div class="container">
			<button style="padding-left: 5px; padding-bottom: 5px"
				class=" navbar-toggle" data-toggle="collapse"
				data-target=".navHeaderCollapse">
				<span class="icon-bar"></span> <span class="icon-bar"></span> <span
					class="icon-bar"></span>
			</button>
			<div class="collapse navbar-collapse navHeaderCollapse">
				<ul class="nav navbar-nav">
					<li><a href="/compose">Compose Mail</a></li>
					<li><a href="/createtab">Create Tab</a></li>
					<li class="dropdown">
						<a href="" class="dropdown-toggle" data-toggle="dropdown">Delete Tab<span class="caret"></span></a>
						<ul class = "dropdown-menu"  id="deleteList">
							<script type="text/javascript">
								
								var tabListObject = ${tabListObject};
								if(tabListObject.length!=0){
									for(var i=0;i<tabListObject.length;i++){
										var list = document.createElement("LI");
										var anchor = document.createElement("A");
										if(tabListObject.length!=1){
											anchor.setAttribute("href","/deletetab?tabIndex="+i);
										}else{
											anchor.setAttribute("href","#");
											anchor.setAttribute("onclick","alertMessage()")
										}
										var text = document.createTextNode(tabListObject[i].tabName);
										anchor.appendChild(text);
										list.appendChild(anchor);
										document.getElementById("deleteList").appendChild(list);
										if(i!=(tabListObject.length - 1)){
									 		var listDivider = document.createElement("LI");
											listDivider.setAttribute("class","divider");
											document.getElementById("deleteList").appendChild(listDivider); 
										}
									}
								}
								function alertMessage(){
									alert("One Tab Must Be Maintained");
								}
							</script>
						</ul>
					</li>
				</ul>
			</div>
		</div>
	</div>

	<!-- Body part -->

	<div class="row">
		<div class="col-md-3">
			<div id="left_panel" class="nav nav-pills nav-stacked" style="background-color: #b8b8b8; height: 520px; overflow-y:auto;">
				<!-- <ul id="left_panel" class="nav nav-pills nav-stacked"> -->
					<script type="text/javascript">
  						 var tabListObject = ${tabListObject};
  						  						 
  						 //for Listing tabs in left panel
						 if(tabListObject.length!=0){
							for(var i=0;i<tabListObject.length;i++){
								var list = document.createElement("LI");
								list.setAttribute("role", "presentation");
								list.setAttribute("data-toggle","tooltip");
								list.setAttribute("data-placement","right");
								list.setAttribute("title",tabListObject[i].tabDescription);
								var anchor = document.createElement("A");
								anchor.setAttribute("href","/"+(i+1));
								anchor.setAttribute("style","color:#454444");
					    		var text = document.createTextNode(tabListObject[i].tabName.substring(0,1).toUpperCase()+tabListObject[i].tabName.substring(1));
					    		var span = document.createElement("SPAN");
					    		span.setAttribute("class","badge pull-right");
					    		var number = document.createTextNode(tabListObject[i].tabNumberOfMail);
					    		span.appendChild(number);
					    		anchor.appendChild(text);
					    		anchor.appendChild(span);
					    		list.appendChild(anchor);
								document.getElementById("left_panel").appendChild(list);
							}
						}
									
					</script>
			</div>
		</div>
		<div class="col-md-9" style="background-color: #f1f2f2; height: 520px; overflow-y:auto;">
		<br/>
		
				<div id="mail_header">
					<script type="text/javascript">
					 var tabMailObject = ${tabMailObject};
						 var unreadMailCounter = 0;
						 //number of unread mails
						 
						 for(var i=0;i<tabMailObject.length;i++){
							 if(tabMailObject[i].readStatusFlag=="false")
								unreadMailCounter++;
						 }
					
						var divHead= document.createElement("DIV");
						divHead.setAttribute("class","container");
						var para = document.createElement("P");
						para.setAttribute("style","font-size:20px; font-weight:bold; color:#a8a8a8");
						var tabName = document.createTextNode(${tabName}.substring(0,1).toUpperCase()+${tabName}.substring(1));
						para.appendChild(tabName);
						
						var span= document.createElement("SPAN");
						span.setAttribute("style","font-size:13px");
						var count = document.createTextNode(" ("+unreadMailCounter+")");
						span.appendChild(count)
						para.appendChild(span);
						
						divHead.appendChild(para);
						document.getElementById("mail_header").appendChild(divHead);
					</script>
				</div>
			
				<div id="mail_panel" class="list-group" >
					<script type="text/javascript">
					
						var tabMailObject = ${tabMailObject};
						if(tabMailObject.length!=0){
							for(var i=0;i<tabMailObject.length;i++){
								var anchor = document.createElement("A");
								anchor.setAttribute("href","/openmail?tabIndex="+tabMailObject[i].tabIndex+"&mailIndex="+i);
								if(tabMailObject[i].readStatusFlag == "false"){
									anchor.setAttribute("class","list-group-item");
								}else{
									anchor.setAttribute("class","list-group-item read");
								}
								
								//Star Image
								var starImage = document.createElement("IMG");
								if(tabMailObject[i].readStatusFlag == "false" && tabMailObject[i].starFlag == "false"){
									starImage.setAttribute("src","MyImages/unselectstar.jpg");
								}else if(tabMailObject[i].readStatusFlag == "false" && tabMailObject[i].starFlag == "true"){
									starImage.setAttribute("src","MyImages/selectedstar.jpg");
								}else if(tabMailObject[i].readStatusFlag == "true" && tabMailObject[i].starFlag == "false"){
									starImage.setAttribute("src","MyImages/unselectstar2.jpg");
								}else{
									starImage.setAttribute("src","MyImages/selectedstar2.jpg");
								}
								starImage.setAttribute("width","20px");
								starImage.setAttribute("height","20px");
								starImage.setAttribute("style","margin-right:20px");
								
								var headMailFrom = document.createElement("H4");
								headMailFrom.setAttribute("class","list-group-item-heading");
								
								var mailFrom = document.createTextNode(tabMailObject[i].mailFromName);
															
								//Time
								var span = document.createElement("SPAN");
								span.setAttribute("class","pull-right badge");
								span.setAttribute("style","font-size:12px");
								var mailTime = document.createTextNode(tabMailObject[i].mailTime);
								span.appendChild(mailTime);
								
								headMailFrom.appendChild(starImage);
								headMailFrom.appendChild(mailFrom);
								headMailFrom.appendChild(span);
								
								var paragraphMailBody = document.createElement("P");
								paragraphMailBody.setAttribute("class","list-group-item-text");
								paragraphMailBody.setAttribute("style","margin-left:40px");								
								var mailText;
								if(tabMailObject[i].mailBody.length>20){
									mailText = tabMailObject[i].mailBody.substring(0,19) +"...";
								}else{
									mailText  = tabMailObject[i].mailBody;
								}
								
								var mailContent = document.createTextNode(tabMailObject[i].mailSubject+": "+mailText);
								paragraphMailBody.appendChild(mailContent);
								
								
								anchor.appendChild(headMailFrom);
								anchor.appendChild(paragraphMailBody);
								
								document.getElementById("mail_panel").appendChild(anchor);
							}
						}
				
					</script>
				</div>
			<!-- </div> -->
		</div>
	</div>

</body>
</html>