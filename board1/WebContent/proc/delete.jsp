<%@page import="kr.co.board1.vo.BoardVO"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="kr.co.board1.config.Sql"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="kr.co.board1.config.DBConfig"%>
<%@page import="java.sql.Connection"%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%

	request.setCharacterEncoding("utf-8");
	String seq = request.getParameter("seq");
	
	
	Connection conn = DBConfig.getConnection();
	PreparedStatement pstmt = conn.prepareStatement(Sql.DELETE_LIST);
	pstmt.setString(1,seq);
	pstmt.executeUpdate();
	
	pstmt = conn.prepareStatement(Sql.DELETE_FILE);
	pstmt.setString(1,seq);
	pstmt.executeUpdate();
	
	pstmt.close();
	conn.close();
	
	response.sendRedirect("../list.jsp");
	
%>