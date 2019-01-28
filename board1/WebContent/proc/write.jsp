<%@page import="java.io.FileOutputStream"%>
<%@page import="java.io.File"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="kr.co.board1.service.BoardService"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="kr.co.board1.vo.MemberVO"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="kr.co.board1.config.Sql"%>
<%@page import="java.sql.Connection"%>
<%@page import="kr.co.board1.config.DBConfig"%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
//	request.setCharacterEncoding("utf-8"); 아래 내용 수정으로 이제 필요 없다.
//	MultipartRequest mr = new MultipartRequest(request, "파일저장경로", "단일파일최대크기", "utf-8", "파일 이름");
	String path = request.getServletContext().getRealPath("/data"); //경로 구하는 방법. 절대 경로 인거 같다.....
	int maxSize = 1024 * 1024 * 10; //10MB
 	MultipartRequest mr = new MultipartRequest(request, path, maxSize, "utf-8", new DefaultFileRenamePolicy());
	
//	String title = request.getParameter("subject");
//	String content = request.getParameter("content");
	String title = mr.getParameter("subject");
	String content = mr.getParameter("content");
	String regip = request.getRemoteAddr();
	String fileName = mr.getFilesystemName("file"); // parameter로 넘어온 name 속성
	
	BoardService service = BoardService.getInstance();
	MemberVO member = (MemberVO)session.getAttribute("member");
	String uid = member.getId();
	
	int file = 0;
	if(fileName != null){
		file = 1;
		//파일명 생성(UUID)
		int idx = fileName.lastIndexOf(".");
		String ext = fileName.substring(idx);
		
		Date date = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyMMddHHmmss_");
		String now = sdf.format(date);
		String newFileName = now+uid+ext; //190124105012_abcd.pptx

		//파일명 변경.
		byte[] buf = new byte[1024];
		File oldFile = new File(path+"/"+fileName); 
		File newFile = new File(path+"/"+newFileName);
		FileInputStream fis = new FileInputStream(oldFile);
		FileOutputStream fos = new FileOutputStream(newFile);
		int read= 0;
		while( (read = fis.read(buf)) != -1 ) {
			fos.write(buf, 0, read);
		}
		
		/*
		while(true){
			read = fis.read(buf); //read = fis.read(buf,0,buf.length)
			if(read == -1){ //더이상 가져올 데이터가 없을 경우
				break;
			}
			fos.write(buf,0,read);  //fos.write(buf,0,length)
		}
		*/
		fos.flush();
		fis.close();
		fos.close();
		
		//oldFile.renameTo(newFile);
		oldFile.delete();
		
		//글 등록
		int seq = service.write(file, title, content, uid, regip);
		
		//파일테이블 Insert
		service.fileInsert(seq, fileName, newFileName);
	}else{
		service.write(file, title, content, uid, regip);	
	}
	
	
			
	response.sendRedirect("../list.jsp");
	
	
%>