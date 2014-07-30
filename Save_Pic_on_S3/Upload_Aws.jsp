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
            	try 
            	{
	            	AWSCredentials credentials = new BasicAWSCredentials("AKIAI4SS5T4ZRSW6VYXA", "NFHSkdeEDItHgdCMhB/IvjbBBTSoRNQoXheAc74e");
	                AmazonS3 client = new AmazonS3Client(credentials); 
	                InputStream stream = new ByteArrayInputStream(dataBytes);
	                ObjectMetadata meta = new ObjectMetadata();
	                meta.setContentLength(dataBytes.length);
	                meta.setContentType("multipart/form-data");
	                client.putObject(bucket, saveFile, stream, meta);
	                client.setObjectAcl(bucket, saveFile,CannedAccessControlList.PublicRead);
	                out.println("File uploaded successfully");
            	} 
            	catch (Exception ex) 
            	{
                	System.out.println(ex);
            	}
			}
            
            
   %>          
</body>
</html>