<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Your pictures</title>
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
<%
			//Set the bucket name
            String bucket = "VPATIL";
 			AWSCredentials credentials = new BasicAWSCredentials("AKIAI4SS5T4ZRSW6VYXA", "NFHSkdeEDItHgdCMhB/IvjbBBTSoRNQoXheAc74e");
 			AmazonS3 client = new AmazonS3Client(credentials); 
 			ObjectListing objects = client.listObjects(bucket);
 			do {
 				out.println("<table border=1>");
 			        for (S3ObjectSummary objectSummary : objects.getObjectSummaries()) {
 			                //out.println(objectSummary.getKey() + "<br/>" );
 			               GeneratePresignedUrlRequest request1 = new GeneratePresignedUrlRequest(bucket,objectSummary.getKey());
 			              //System.out.println(client.generatePresignedUrl(request1));
 			               out.println("<img src="+ client.generatePresignedUrl(request1)+" <br/>" );
 			               
 			        }
 			       out.println("</table>");
 			        objects = client.listNextBatchOfObjects(objects);
 			} while (objects.isTruncated());
 			
%> 
</body>
</html>