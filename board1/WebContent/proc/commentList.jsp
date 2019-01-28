<%@page import="com.google.gson.Gson"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="kr.co.board1.vo.BoardVO"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.board1.config.Sql"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="kr.co.board1.config.DBConfig"%>
<%@page import="java.sql.Connection"%>
<%@page import="kr.co.board1.service.BoardService"%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("utf-8");
	BoardService service = BoardService.getInstance();
	//댓글 가져오기
	String parent = request.getParameter("parent");
	List<BoardVO> list = service.listComment(parent);
	
	Gson gson = new Gson();
	String json = gson.toJson(list); //gson을 json으로 바꾸면 String 객체로 나옴
	
	out.print(json); //결과 값 넘기는 것이다. 분명 String인데 object로 넘어가네 ??
%>