<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="javax.jdo.PersistenceManager" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.chmikarate.Greeting" %>
<%@ page import="com.chmikarate.PMF" %>

<html>
	<head>
    <link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
    <script type="text/javascript" charset="UTF-8" src="/js/jquery-1.4.2.min.js"></script>
    <script src="/js/ckeditor.js" type="text/javascript"></script>
    <script type="text/javascript"> 
		 $(function() {
				//alert('hello');
		 });
	 </script>
  </head>
  <body>

<%
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user != null) {
%>
<p>Hello, <%= user.getNickname() %>! (You can
<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>
<%
    } else {
%>
<p>Hello!
<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
to include your name with greetings you post.</p>
<%
    }
%>

<%
    PersistenceManager pm = PMF.get().getPersistenceManager();
    String query = "select from " + Greeting.class.getName();
    List<Greeting> greetings = (List<Greeting>) pm.newQuery(query).execute();
    if (greetings.isEmpty()) {
%>
<p>The guestbook has no messages.</p>
<%
    } else {
        for (Greeting g : greetings) {
            if (g.getAuthor() == null) {
%>
<p>An anonymous person wrote:</p>
<%
            } else {
%>
<p><b><%= g.getAuthor().getNickname() %></b> wrote:</p>
<%
            }
%>
<blockquote><%= g.getContent() %></blockquote>
<%
        }
    }
    pm.close();
%>

    <form action="/sign" method="post">
    <!--   <div><textarea name="content" rows="3" cols="60"></textarea></div> -->
     	<div style="width:300px;"><span id="annContexTip" class="msg rn" style="display:none;"></span><br/></div>
				<div id="ann_ta_div" style="width:600px;">
					<textarea name="content" id="ann_ta" cols="30" rows="5"></textarea>
					<script type="text/javascript">
						CKEDITOR.replace('ann_ta');
						CKEDITOR.config.contentsCss = '/css/yaodian100_news.css';
					</script>
				</div>
      <div><input type="submit" value="Post Greeting" /></div>
    </form>

  </body>
</html>