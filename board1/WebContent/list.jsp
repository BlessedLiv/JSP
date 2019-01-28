<%@page import="kr.co.board1.service.BoardService"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="kr.co.board1.vo.BoardVO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="kr.co.board1.config.Sql"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="kr.co.board1.config.DBConfig"%>
<%@page import="java.sql.Connection"%>
<%@page import="kr.co.board1.vo.MemberVO"%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%
	BoardService service = BoardService.getInstance();
	MemberVO member = (MemberVO)session.getAttribute("member");
	if(member == null){
		pageContext.forward("./login.jsp");
	}
	request.setCharacterEncoding("utf-8");
	String pg = request.getParameter("pg");
	int start = service.getLimitStart(pg);
	
	int total = service.getTotal();//총 글의 수 
	int pageEnd = service.getPageEnd(total); 
	//글 카운터 번호 계산
	int count = service.getPageCountStart(total, start);
	
	//page group calculation
	int[] groupStartEnd = service.getPageGroupStartEnd(pg, pageEnd);
	
	List<BoardVO> list = service.list(start);
	
%>
<html>
	<head>
		<meta charset="UTF-8" />
		<title>글목록</title> 
		<link rel="stylesheet" href="./css/style.css" />
	</head>
	<body>
		<div id="board">
			<h3>글목록</h3>
			<!-- 리스트 -->
			<div class="list">
				<p class="logout"><%=member.getNick() %>님! 반갑습니다. <a href="./proc/logout.jsp">[로그아웃]</a><p>
				<table>
					<tr>
						<td>번호</td>
						<td>제목</td>
						<td>글쓴이</td>
						<td>날짜</td>
						<td>조회</td>
					</tr>
					<%
					for(BoardVO li : list){
					%>
					<tr>
					<td><%=count-- %></td>
					<td><a href="./view.jsp?seq=<%=li.getSeq()%>"><%=li.getTitle() %></a>&nbsp;[<%=li.getComment() %>]
						<%if(li.getFile() == 1) %> <img src="./css/file_ico.png" />
					</td>
					<td><%=li.getNick() %></td>
					<td><%=li.getRdate().substring(2,10) %></td>  <!-- String으로 값이 저장되어 있어서 그런가봄 ㅠㅠ format 형식 안됨 -->
					<td><%=li.getHit() %></td>
					</tr>
					<%} %>
				</table>
			</div>
			<!-- 페이징 -->
			<nav class="paging">
				<span> 
				<%if(groupStartEnd[0] > 1){ %>
					<a href="./list.jsp?pg=<%=groupStartEnd[0]-1 %>" class="prev">이전</a>
				<%} %>
				<%for(int current = groupStartEnd[0] ; current <= groupStartEnd[1] ; current ++){ %> <!-- current는 현재 페이지 번호. pageEnd는 끝번호 -->
					<a href="./list.jsp?pg=<%=current %>" class="num"><%=current %></a>
				<%} %>
				
				<%if(groupStartEnd[1] < pageEnd){ %>
					<a href="./list.jsp?pg=<%=groupStartEnd[1]+1 %>" class="next">다음</a>
				<%} %>
				</span>
			</nav>
			<a href="./write.jsp" class="btnWrite">글쓰기</a>
		</div>
	</body>

</html>


