<%@ page language="java" contentType="text/html; charset=GB18030"
    pageEncoding="GB18030"%>
<%@ page import="helloworldAssignment1.Hello"%>
<%// Author Wenhao Li, 25/02/2014%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head><title>Welcome</title></head>
<body>
<table class="title">
  <tr><th>index.jsp</th></tr>
</table>
<p/>
<fieldset>
<legend>JSP</legend>
<ul>
 <li><%
 		Hello hi=new Hello();
 		out.println(hi.sayHi());
	%>
</li>
</ul>
</fieldset>
<p/>
</body>
</html>