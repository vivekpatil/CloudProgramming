<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<form enctype="multipart/form-data" method=post>
<h2>Please upload the picture below</h2>
<table><tr><td>Choose the file To Upload:</td><td><input name="file" type="file"></td></tr>
		<tr><td>Description</td><td><input type="text" id="txtDescription" name="txtDescription" maxlength="100"></td><tr>
		<tr><td></td><td><input type="submit" id="btnSubmit" value="Upload"></td></tr></table>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="Methods.*" %>
<%
	Connection conn = null;
	Statement statement = null;
	PreparedStatement preparedStatement = null;
	ResultSet resultSet = null;
	//String to capture filename to be uploaded
	String saveFile = "";
	//Getting the content type of file uploaded
	String contentType = request.getContentType(); 
	//Check if content type exist
	if ((contentType != null) && (contentType.indexOf("multipart/form-data") >= 0)) 
	{
		try 
		{
			//out.print("Photo desc is:"+strDescription.toString());
			Actions action = new Actions();
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
            String strDescription = file.substring(file.indexOf("txtDescription")+16,file.indexOf("-------",file.indexOf("txtDescription")+16));
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
     
			if(action.fnUploadFile(saveFile, dataBytes, endPos, startPos))
			{
				//ensure that the specified class is loaded by the current classloader
				Class.forName("com.mysql.jdbc.Driver");
				//out.println("Driver loaded");
				String host = "jdbc:mysql://vpatil.cq7nx1shjlp8.us-east-1.rds.amazonaws.com:3306/Images";
		    	conn = DriverManager.getConnection(host,"VPATIL","12345678");
		    	//out.println("Connection received");
		    	// statements allow to issue SQL queries to the database
		        statement = conn.createStatement();
		    	
		        // preparedStatements can use variables and are more efficient
		        preparedStatement = conn.prepareStatement("insert into  Images.IMAGE_DETAILS values (?, ?)");
		        // "myuser, webpage, datum, summary, COMMENTS from FEEDBACK.COMMENTS");
		        // parameters start with 1
		        preparedStatement.setString(1, saveFile);
		        preparedStatement.setString(2, strDescription);
		        int RowsInserted = preparedStatement.executeUpdate();
		       	if(RowsInserted > 0)
			       {
			    	   out.println("Image and description saved successfully! <a href=\"Display_Photos.jsp\"> Click here </a> to view the images");
			       }
			       else
			       {
			    	   out.println("Shit, fix it");
			       }
		       }
		}
		catch (SQLException ex) {
		    // handle any errors
		    out.println("SQLException: " + ex.getMessage());
		    out.println("SQLState: " + ex.getSQLState());
		    out.println("VendorError: " + ex.getErrorCode());
		}
	}
%>
</form>
</body>
</html>