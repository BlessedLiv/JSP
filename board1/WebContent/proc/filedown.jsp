<%@page import="java.io.BufferedOutputStream"%>
<%@page import="java.io.BufferedInputStream"%>
<%@page import="java.io.OutputStream"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.File"%>
<%@page import="kr.co.board1.vo.BoardVO"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="kr.co.board1.config.Sql"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="kr.co.board1.config.DBConfig"%>
<%@page import="java.sql.Connection"%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%
	
	request.setCharacterEncoding("utf-8");
	String newName = request.getParameter("newName"); //20190125.pptx
	String oldName = request.getParameter("oldName"); //Mongodb.pptx
	String seq = request.getParameter("seq");
	//File download counting update

	//Path 
	String path = request.getServletContext().getRealPath("/data");
	File file = new File(path + "/"+newName);
	String name = new String(oldName.getBytes("UTF-8"), "iso-8859-1");
	
	//response preparing
	response.setContentType("application/octet-stream");
	response.setHeader("Content-Disposition", "attachment; filename="+name); //setting name
	response.setHeader("Content-Transfer-Encoding", "binary");
	response.setHeader("Pragma", "no-cache");
	response.setHeader("Cache-Control", "private");

	//connecting stream : file - response object
	BufferedInputStream bis = new BufferedInputStream(new FileInputStream(file));
	BufferedOutputStream bos = new BufferedOutputStream(response.getOutputStream());
	int read = 0;
	byte b[] = new byte[1024]; //buffer size 1KB fixed
	while((read=bis.read(b)) != -1){
		bos.write(b,0,read);
	}
	bos.flush();
	bos.close();
	bis.close();
	
	Connection conn = DBConfig.getConnection();
	PreparedStatement pstmt = conn.prepareStatement(Sql.UPDATE_DOWNLOAD);
	pstmt.setString(1,seq);
	pstmt.executeUpdate();
	pstmt.close();
	conn.close();
	
%>