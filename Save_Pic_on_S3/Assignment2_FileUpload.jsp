<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Web Album</title>
</head>
<body>
<form enctype="multipart/form-data" method=post>
<h1>Welcome to Vivek's Web Album</h1>
<h2>Please upload the picture below</h2>
<table><tr><td>Choose the file To Upload:</td><td><input name="file" type="file"></td>
		<td></td><td><input type="submit" id="btnSubmit" value="Upload"></td></tr></table>
 <br/>
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
			//String to capture filename to be uploaded
			String saveFile = "";
			//Getting the content type of file uploaded
			String contentType = request.getContentType(); 
			//Check if content type exist
			if ((contentType != null) && (contentType.indexOf("multipart/form-data") >= 0)) 
			{
				//Convert the file to input stream
				DataInputStream in = new DataInputStream(request.getInputStream());
				//get content length
	            int formDataLength = request.getContentLength();
				//initialize the array with content length
	            byte dataBytes[] = new byte[formDataLength];
	            int byteRead = 0;
	            int totalBytesRead = 0;
	            while (totalBytesRead < formDataLength) 
	            {
	                  byteRead = in.read(dataBytes, totalBytesRead, formDataLength);
	                  totalBytesRead += byteRead;
	            }
	            String file = new String(dataBytes);
	            saveFile = file.substring(file.indexOf("filename=\"") + 10);
	            saveFile = saveFile.substring(0, saveFile.indexOf("\n"));
	            saveFile = saveFile.substring(saveFile.lastIndexOf("\\") + 1, saveFile.indexOf("\""));
	            int lastIndex = contentType.lastIndexOf("=");
	            String boundary = contentType.substring(lastIndex + 1, contentType.length());
	            int pos;
	            pos = file.indexOf("filename=\"");
	            pos = file.indexOf("\n", pos) + 1;
	            pos = file.indexOf("\n", pos) + 1;
	            pos = file.indexOf("\n", pos) + 1;
	            int boundaryLocation = file.indexOf(boundary, pos) - 4;
	            int startPos = ((file.substring(0, pos)).getBytes()).length;
	            int endPos = ((file.substring(0, boundaryLocation)).getBytes()).length;
	            
            	try 
            	{
	            	AWSCredentials credentials = new BasicAWSCredentials("AKIAI4SS5T4ZRSW6VYXA", "NFHSkdeEDItHgdCMhB/IvjbBBTSoRNQoXheAc74e");
	                AmazonS3 client = new AmazonS3Client(credentials);    
	                ByteArrayInputStream stream = new ByteArrayInputStream(dataBytes, startPos, (endPos - startPos));
	                
	                ObjectMetadata meta = new ObjectMetadata();
	                meta.setContentLength(endPos - startPos);
	                meta.setContentType("image/png");
	                client.putObject(bucket, saveFile, stream, meta);
	                
	                client.setObjectAcl(bucket, saveFile,CannedAccessControlList.PublicRead);
	                out.println("File uploaded successfully, <a href=\"Display_Album.jsp\"> Click here </a> to view the images");
	            
            	} 
            	catch (Exception ex) 
            	{
                	System.out.println(ex);
            	}
			}
            
            
   %>         
</form>
</body>
</html>