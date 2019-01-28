<%@page import="kr.co.board1.vo.TermsVO"%>
<%@page import="kr.co.board1.service.MemberService"%>
<%@page import="kr.co.board1.config.Sql"%>
<%@page import="kr.co.board1.config.DBConfig"%>
<%@page import="java.sql.PreparedStatement"%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@ page import = "java.sql.Connection" %>
<%@ page import = "java.sql.DriverManager" %>
<%@ page import = "java.sql.Statement" %>
<%@ page import = "java.sql.ResultSet" %>
<%
	request.setCharacterEncoding("utf-8");
	
	MemberService service = MemberService.getInstance();
	TermsVO vo = service.terms();
%>
<html lang="en">
	<head>
		<meta charset="utf-8">
		<title>terms</title>
		<link rel="stylesheet" href="./css/style.css" />	
		
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script> <!-- 이걸 추가 해 줘야 JQUERY 동작한다. -->
		
		<script> <!--JQUERY 는 함수 -->
			$(document).ready(function(){
				
				$('.btnNext').click(function(){
					var rs1 = $('input[name=chk1]:checked').val();
					var rs2 = $('input[name=chk2]').is(':checked');
					if(!rs1){
			            alert('이용약관에 동의해 주세요');
			            return false;
			        } 
					else if(!rs2) {
			            alert('개인정보에 동의해 주세요');
			            return false;
			        }else{
			        	return true;
			        }
				});
			});
		</script>
	</head>

	<body>
		<div id="terms">
			<section>
				<table>
					<caption>사이트 이용약관</caption>
					<tr>
						<td>
							<!-- 데이터 베이스로 약관 가져 올거임  -->
							<textarea readonly>
							<%=vo.getTerms() %>
							</textarea>
							<div>
								<!-- 동의 체크 여부는 자바스크립트로 ~ -->
								<!-- 구글 JQUERY -->
								<label><input type="checkbox" name="chk1" />&nbsp;동의합니다.</label> 
								       
							</div>
						</td>
					</tr>
				</table>
			</section>			
			<section>
				<table>
					<caption>개인정보 취급방침</caption>
					<tr>
						<td>
							<textarea readonly>
								<%=vo.getPrivacy() %>
							
							</textarea>
							<div>
								<label><input type="checkbox" name="chk2" />&nbsp;동의합니다.</label>        
							</div>
						</td>
					</tr>
				</table>
			</section>
			
			<div>
				<a href="./login.jsp" class="btnCancel">취소</a>
				<a href="./register.jsp" class="btnNext">다음</a>
			</div>
			
		</div>
	</body>
</html>











