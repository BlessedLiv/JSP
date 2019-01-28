<%@page import="java.util.List"%>
<%@page import="kr.co.board1.vo.MemberVO"%>
<%@page import="kr.co.board1.vo.BoardVO"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="kr.co.board1.config.Sql"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="kr.co.board1.config.DBConfig"%>
<%@page import="java.sql.Connection"%>
<%@page import="kr.co.board1.service.BoardService"%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("utf-8");
	BoardService service = BoardService.getInstance();
	BoardVO vo = service.view(request);
	MemberVO member = service.getMember(session);
	service.updateHit(vo.getSeq());
	
	
%>
<html>
	<head>
		<meta charset="UTF-8" />
		<title>글보기</title> 
		<link rel="stylesheet" href="./css/style.css" />
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
		<script><!-- HTML이 렌더링 되고 나서 구현되는 부분이다. 제일 마지막에  -->
		$(function(){
			var comments = $('.comments');
			var comment= $('.comments > .comment' );
			var empty = $('.comments > .empty');
			var parent = $('#seq').val();
			jQuery.ajax({ //<!-- $ == jQuery -->
				url:'./proc/commentList.jsp?parent='+parent,
				type:'get',
				dataType:'json',
				success: function(result){
					//alert(result); -> 값이 있으면 object Object로 나오고, 아니면 빈칸으로 나온다.
					if(result.length == 0){ //<!-- 여기에 result==0 해도 된다. -->
						comment.remove();
					}else{
						empty.remove();
					}					
					
					for(var i in result){ //<!-- i는 result의 갯수대로 0,1,2,,,,,자체로 result.length -->
						//alert('content: ' + result[i].content);
						var delUrl = "./proc/deleteComment.jsp?seq="+result[i].seq+"&parent="+result[i].parent;
						
						if( i > 0 ){
							var commentCloned = comment.clone();
							commentCloned.find('span > .nick').text(result[i].nick);
							commentCloned.find('span > .date').text(result[i].rdate.substring(2,10));
							commentCloned.find('textarea').text(result[i].content);
							commentCloned.find('.del').attr('href', delUrl);
							comments.append(commentCloned); //<!--comments 안에 <h3>태그 있지만 추가한 목록이 nick, rdate, content 라서 <h3>은 추가가 안되나? -->
							
						}else{
							comment.find('span > .nick').text(result[i].nick);
							comment.find('span > .date').text(result[i].rdate.substring(2,10));
							comment.find('textarea').text(result[i].content);
							comment.find('.del').attr('href', delUrl);
						}
					}
				}
				
			});
			
		});
		</script>
		
	</head>
	<body>
		<div id="board">
			<h3>글보기</h3>
			<div class="view">
				<form action="#" method="post">
					<input type="hidden" id="seq" value="<%=vo.getSeq() %>" />
					<table>
						<tr>
							<td>제목</td>
							<td><input type="text" name="subject" value="<%=vo.getTitle() %>" readonly />
							</td>
						</tr>
						<% if(vo.getFile() == 1){ %>
						<tr>
							<td>첨부파일</td>
							<td>
								<a href="./proc/filedown.jsp?seq=<%=vo.getSeq() %>&newName=<%=vo.getNewName()%>&oldName=<%=vo.getOldName()%>"><%=vo.getOldName() %></a>
								<span><%=vo.getDownload() %>회 다운로드</span>
							</td>
						</tr>
						<% } %>
						<tr>
							<td>내용</td>
							<td>
								<textarea name="content" rows="20" readonly><%=vo.getContent() %></textarea>
							</td>
						</tr>
					</table>
					<div class="btns">
						<a href="./proc/delete.jsp?seq=<%=vo.getSeq() %>" class="cancel del">삭제</a>
						<a href="./modify.jsp?seq=<%=vo.getSeq() %>" class="cancel mod">수정</a>
						<a href="./list.jsp" class="cancel">목록</a>
					</div>
				</form>
			</div><!-- view 끝 -->
			
		 	<!-- 댓글목록 -->
			<section class="comments">
				<h3>댓글목록</h3>
		
				<div class="comment">
					<span>
						<span class="nick">nickname</span>
						<span class="date">date</span>
					</span>
					<textarea>content</textarea>
					<div>
						<a class="del">삭제</a><!--a 태그에 존재하는 href 속성을 다 지워도 위에 Ajax에 설정을 해서 그런지 실행이 된다. -->
						<a href="#" class="mod">수정</a>
					</div>
				</div>  
			
				<p class="empty">
					등록된 댓글이 없습니다.
				</p>
		
			
			</section>
			
			<!-- 댓글쓰기 -->
			<section class="comment_write">
				<h3>댓글쓰기</h3>
				<div>
					<form action="./proc/commentWrite.jsp" method="post">
						<input type="hidden" name="uid" value="<%=member.getId() %>" />  <!-- form 에 심어두기 -->
						<input type="hidden" name="parent" value="<%=vo.getSeq() %>" />
						<textarea name="comment" rows="5"></textarea>
						<div class="btns">
							<a href="#" class="cancel">취소</a>
							<input type="submit" class="submit" value="작성완료" />
						</div>
					</form>
				</div>
			</section>
		</div><!-- board 끝 -->
	</body>

</html>










