<%@page import="kr.co.board1.vo.MemberVO"%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>


<%
	MemberVO member = (MemberVO)session.getAttribute("member");
	//로그인을 안했으면 ,,, 지금은 구현할 수 없기 때문에 if 에 true 넣는다.
	if(member == null){
		//response.sendRedirect("./login.jsp");
		pageContext.forward("./login.jsp");
	//로그인 했을때
	}else{
		//response.sendRedirect("./list.jsp");
		pageContext.forward("./list.jsp");
	}
	
	
%>