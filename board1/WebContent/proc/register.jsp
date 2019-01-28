<%@page import="kr.co.board1.service.MemberService"%>
<%@page import="kr.co.board1.config.Sql"%>
<%@page import="kr.co.board1.config.DBConfig"%>
<%@page import="java.sql.PreparedStatement"%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.Statement"%>
<%@ page import="java.sql.ResultSet"%>

<%
	MemberService service = MemberService.getInstance();
	service.register(request);
	response.sendRedirect("../login.jsp?register=success");
%>
