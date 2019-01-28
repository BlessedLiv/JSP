<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.sql.PreparedStatement"%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@ page import = "java.sql.Connection" %>
<%@ page import = "java.sql.DriverManager" %>
<%@ page import = "java.sql.Statement" %>
<%@ page import = "java.sql.ResultSet" %>

<%
	request.setCharacterEncoding("utf-8");
	String hp = request.getParameter("hp");
	final String HOST = "jdbc:mysql://192.168.0.126:3306/kjb";
	final String USER = "kjb";
	final String PASS = "1234";

	Connection conn = null;
	Statement stmt = null;
	ResultSet rs = null;
	
	int count = 0 ;
	try{
		Class.forName("com.mysql.jdbc.Driver");
		conn = DriverManager.getConnection(HOST, USER, PASS);
		stmt = conn.createStatement();
		String sql= "select count(*) from `JSP_MEMBER` where hp ='"+ hp + "';";
		rs = stmt.executeQuery(sql);
		
		if(rs.next()){
			count = rs.getInt(1); // 첫번째 컬럼
		}
		
		
	
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		if(rs != null) try{rs.close();}catch(Exception e){}
		if(conn != null) try{conn.close();}catch(Exception e){}
		if(stmt != null) try{stmt.close();}catch(Exception e){}
	}
	//JSON 데이터 생성
//	String json = "{result:"+count+"}"; //이렇게 만들면 불편하다. 그래서 JSON 라이브러리를 쓴다.
	JSONObject json = new JSONObject();
	json.put("result", count); //MAP 으로 추가 된다.
	out.print(json);
	
%>
