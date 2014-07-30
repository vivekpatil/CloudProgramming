<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<%@ page import="java.io.*" %>
<%@ page	import ="com.amazonaws.services.s3.AmazonS3" %>
<%@ page	import ="com.amazonaws.services.s3.AmazonS3Client" %>
<%@ page	import ="com.amazonaws.services.s3.model.Bucket" %>
<%@ page	import ="com.amazonaws.services.s3.model.CannedAccessControlList" %>
<%@ page	import ="com.amazonaws.services.s3.model.GeneratePresignedUrlRequest"%>
<%@ page	import ="com.amazonaws.services.s3.model.GetObjectRequest"%>
<%@ page	import ="com.amazonaws.services.s3.model.ObjectListing"%>
<%@ page	import ="com.amazonaws.services.s3.model.ObjectMetadata"%>
<%@ page	import ="com.amazonaws.services.s3.model.S3ObjectSummary"%>
<%@ page	import ="com.amazonaws.ClientConfiguration"%>
<%@ page	import ="com.amazonaws.Protocol"%>
<%@ page	import = "com.amazonaws.auth.BasicAWSCredentials"%>
<%@ page	import = "com.amazonaws.auth.AWSCredentials"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.Statement" %>
<%

	Connection conn = null;
	Statement statement = null;
	PreparedStatement preparedStatement = null;
	ResultSet resultSet = null;
	String strDesc= "";
	//Set the bucket name
	String bucket = "VPATIL";
	AWSCredentials credentials = new BasicAWSCredentials("AKIAI4SS5T4ZRSW6VYXA", "NFHSkdeEDItHgdCMhB/IvjbBBTSoRNQoXheAc74e");
	AmazonS3 client = new AmazonS3Client(credentials); 
	
	//ensure that the specified class is loaded by the current classloader
	Class.forName("com.mysql.jdbc.Driver");

	String host = "jdbc:mysql://vpatil.cq7nx1shjlp8.us-east-1.rds.amazonaws.com:3306/Images";
	conn = DriverManager.getConnection(host,"VPATIL","12345678");
	// statements allow to issue SQL queries to the database
    statement = conn.createStatement();
 // resultSet gets the result of the SQL query
 	resultSet = statement.executeQuery("select * from Images.IMAGE_DETAILS");
 	if(resultSet != null)
 	{
 		out.println("<table border=1 width=400px>");
 		while(resultSet.next())
 		{
 			ObjectListing objects = client.listObjects(bucket);

		    for (S3ObjectSummary objectSummary : objects.getObjectSummaries()) 
		    {
		       	do
		    	{
		        	if((resultSet.getString("PhotoName").toString()).equals(objectSummary.getKey().toString()))
		        	{
		        		strDesc = resultSet.getString("description");		
		       	 		//out.println(objectSummary.getKey() + "<br/>" );
		 	            GeneratePresignedUrlRequest request1 = new GeneratePresignedUrlRequest(bucket,objectSummary.getKey());
		 	            //System.out.println(client.generatePresignedUrl(request1));
		 	            out.println("<tr><td align=\"center\"><img src="+ client.generatePresignedUrl(request1)+"><br>"+strDesc+"<br></td></tr>" );
		 	            break;
		        	}  	
		        	objects = client.listNextBatchOfObjects(objects);
				} while (objects.isTruncated());
		    }
 		}
 		out.println("</table>");
 	}
%>
</body>
</html>