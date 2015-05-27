<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link href = "css/bootstrap.min.css" rel = "stylesheet">
<link href = "MyPages/stylesheet.css" rel = "stylesheet">
<title>Mail</title>
</head>
<body id="htmlBody" style="background-color:#454444">
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
	<script src = "js/bootstrap.js"></script>
	<form:errors path = "tab" />
									<!-- Header part-->
									
	<div class = "navbar navbar-inverse navbar-static-top">
		<div class="container">
			<a href="#" class="navbar-brand"><p style="font-size: 35px; font-family: Casendra"><img src="/MyImages/mailIcon.jpg" height="35" width="35" style="padding-right:8px; padding-bottom:10px"><b>Mail<b></p></a>
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
    				<li><a href ="/createtab">Create Tab</a><li>
				</ul>
			</div>
		</div>
	</div>
	
									<!-- Body -->
	<div  class="row">
		<div class="col-sm-12">
			<div id="mail_panel" style="background-color:#f1f2f2; height:540px"><br/>
				<div id= "icon_tab" class="container" style="border-radius:10px; border:2px solid #b8b8b8">
					<script type="text/javascript">
					//Go Back
						var goBack = document.createElement("A");
						goBack.setAttribute("class","btn btn-default btn-xs pull-left ");
						goBack.setAttribute("href","/"+${tabIndex});
						var goBackText = document.createTextNode("Go Back");
						goBack.appendChild(goBackText);
						document.getElementById("icon_tab").appendChild(goBack);
						
					
					
					 //Move left
						var moveLeft = document.createElement("A");
					 	if((${mailIndex}-1)>=0){
					 		moveLeft.setAttribute("href","/openmail?tabIndex="+${tabIndex}+"&mailIndex="+(${mailIndex}-1));
					 	}else{
					 		moveLeft.setAttribute("href","#");
					 	}
						var imageLeft = document.createElement("SPAN");
						imageLeft.setAttribute("class","glyphicon glyphicon-chevron-left");
						imageLeft.setAttribute("style","margin-left:390px; margin-right:20px");
						imageLeft.setAttribute("title","Previous Mail");
						moveLeft.appendChild(imageLeft);
					
						document.getElementById("icon_tab").appendChild(moveLeft); 
						
					//star mail
						var starAnchor = document.createElement("A");
						starAnchor.setAttribute("href","/startoggle?tabIndex="+${tabIndex}+"&mailIndex="+${mailIndex}+"&starFlag="+${starFlag});
				
						var starImage = document.createElement("IMG");
						if(${starFlag}==false){
							starImage.setAttribute("src","MyImages/unselectstar2.jpg");
						}else{
							starImage.setAttribute("src","MyImages/selectedstar2.jpg");
						}
						starImage.setAttribute("width","20px");
						starImage.setAttribute("height","20px");
						starImage.setAttribute("style","margin-left:20px; margin-right:20px");
						starImage.setAttribute("title","Star/Unstar Mail");
				
						starAnchor.appendChild(starImage);
						document.getElementById("icon_tab").appendChild(starAnchor);
					
					//delete mail
						var deleteIcon = document.createElement("A");
						deleteIcon.setAttribute("href","/deletemail?tabIndex="+${tabIndex}+"&mailIndex="+${mailIndex});
						
						var deleteImage = document.createElement("IMG");
						deleteImage.setAttribute("src","MyImages/delecteicon.jpg");
						deleteImage.setAttribute("width","20px");
						deleteImage.setAttribute("height","20px");
						deleteImage.setAttribute("style","margin-left:20px; margin-right:20px");
						deleteImage.setAttribute("title","Delete Mail");
						
						deleteIcon.appendChild(deleteImage);
						document.getElementById("icon_tab").appendChild(deleteIcon);
						
					//mark unread
						var unreadIcon = document.createElement("A");
						unreadIcon.setAttribute("href","/markunread?tabIndex="+${tabIndex}+"&mailIndex="+${mailIndex});
						
						var uneadImage = document.createElement("IMG");
						uneadImage.setAttribute("src","MyImages/unread.jpg");
						uneadImage.setAttribute("width","25px");
						uneadImage.setAttribute("height","25px");
						uneadImage.setAttribute("style","margin-left:20px; margin-right:20px");
						uneadImage.setAttribute("title","Mark as Unread");
						
						unreadIcon.appendChild(uneadImage);
						document.getElementById("icon_tab").appendChild(unreadIcon);
						
					//move right
						var moveRight = document.createElement("A");
						if((${mailIndex}+1)<${maxNumberOfMails}){
							moveRight.setAttribute("href","/openmail?tabIndex="+${tabIndex}+"&mailIndex="+(${mailIndex}+1));
					 	}else{
					 		moveRight.setAttribute("href","#");
					 	}
						var imageRight = document.createElement("SPAN");
						imageRight.setAttribute("class","glyphicon glyphicon-chevron-right");
						imageRight.setAttribute("title","Next Mail");
						imageRight.setAttribute("style","margin-left:20px; margin-right:20px");
						moveRight.appendChild(imageRight);
					
						document.getElementById("icon_tab").appendChild(moveRight); 
					
					
					</script>
					<div class="btn-group pull-right" role="group">
   						 <button type="button" class="btn btn-default btn-xs dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
   						 		Move To <span class="caret"></span></button>
   				 		 <ul id="dropList" class="dropdown-menu" role="menu">
      						<script type="text/javascript">
      							var tabNamesList = ${tabNamesList};
      							for(var i=0;i<tabNamesList.length;i++){
      								var list = document.createElement("LI");
      								var anchor = document.createElement("A");
      								anchor.setAttribute("href","/movemail?tabIndex="+${tabIndex}+"&mailIndex="+${mailIndex}+"&moveToTabIndex="+i);
      								
      								var text = document.createTextNode(tabNamesList[i]);
      								anchor.appendChild(text);
      								list.appendChild(anchor);
      								document.getElementById("dropList").appendChild(list);
      							}
      							
      						</script>
    					</ul>
  					</div>
					
				</div>
				<br/>
				<div class="container" style="background-color:#b8b8b8; border-radius:10px">
				<br/>
				<p>From:<span class="badge pull-right">${mailTime}</span></p><div class="well well-sm">${mailFromName}</div>
				<div class="panel panel-default">
					<div class="panel-heading">Subject: ${mailSubject}</div>
					<div class="panel-body">${mailBody }</div>
				</div>
				</div>
 			</div>
		</div>
	</div>
	
</body>
</html>