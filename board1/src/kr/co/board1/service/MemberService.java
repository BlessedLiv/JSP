package kr.co.board1.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.co.board1.config.DBConfig;
import kr.co.board1.config.Sql;
import kr.co.board1.vo.MemberVO;
import kr.co.board1.vo.TermsVO;

public class MemberService {
	
	private static MemberService service = new MemberService();
	
	public static MemberService getInstance() {
		return service;
	}
	private MemberService() {}
	
	public String login(HttpServletRequest request, HttpSession session) throws Exception{
		request.setCharacterEncoding("utf-8");
		String uid = request.getParameter("uid");
		String pass = request.getParameter("pass");


		Connection conn = DBConfig.getConnection(); //자바빈에서 받아온 것.
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String redirectUrl = null;

		try{
			String sql = Sql.SELECT_LOGIN;
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1,uid);
			pstmt.setString(2,pass);
			rs = pstmt.executeQuery();
			//세션저장
			if(rs.next()){
				MemberVO vo = new MemberVO();
				vo.setSeq(rs.getInt(1));
				vo.setId(rs.getString(2));
				vo.setPw(rs.getString(3));
				vo.setName(rs.getString(4));
				vo.setNick(rs.getString(5));
				vo.setEmail(rs.getString(6));
				vo.setHp(rs.getString(7));
				vo.setGrade(rs.getInt(8));
				vo.setZip(rs.getString(9));
				vo.setAddr1(rs.getString(10));
				vo.setAddr2(rs.getString(11));
				vo.setRegip(rs.getString(12));
				vo.setRdate(rs.getString(13));
				
				session.setAttribute("member",vo);
				redirectUrl = "../list.jsp";
			}
			else {
				redirectUrl ="../login.jsp?result=fail";
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			if(rs != null) try{rs.close();}catch(Exception e){}
			if(conn != null) try{conn.close();}catch(Exception e){}
			if(pstmt != null) try{pstmt.close();}catch(Exception e){}
		}
		
		return redirectUrl;
			
	}

	public void logout(HttpSession session, HttpServletResponse response) throws Exception{
		session.invalidate();
		response.sendRedirect("../login.jsp");
	}

	public TermsVO terms() throws Exception {

		Connection conn = DBConfig.getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		
		TermsVO vo = new TermsVO();
		
		try {

			stmt = conn.createStatement();
			String sql = Sql.SELECT_TERMS;
			rs = stmt.executeQuery(sql);

			if (rs.next()) {
				vo.setTerms(rs.getString(1));
				vo.setPrivacy(rs.getString(2));
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (rs != null)
				try {
					rs.close();
				} catch (Exception e) {
				}
			if (conn != null)
				try {
					conn.close();
				} catch (Exception e) {
				}
			if (stmt != null)
				try {
					stmt.close();
				} catch (Exception e) {
				}
		}
		
		return vo;
	}

	public void register(HttpServletRequest request)throws Exception {
		request.setCharacterEncoding("utf-8");
		String uid = request.getParameter("uid");
		String pass = request.getParameter("pw1");
		String name = request.getParameter("name");
		String nick = request.getParameter("nick");
		String email = request.getParameter("email");
		String hp = request.getParameter("hp");
		String zip = request.getParameter("zip");
		String addr1 = request.getParameter("addr1");
		String addr2 = request.getParameter("addr2");
		String regip = 	request.getRemoteAddr(); //ip 주소 얻기
		
		final String HOST = "jdbc:mysql://192.168.0.126:3306/kjb";
		final String USER = "kjb";
		final String PASS = "1234";

		Connection conn = DBConfig.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try{
			
			String sql = Sql.INSERT_REGISTER;
			
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, uid);
			pstmt.setString(2, pass);
			pstmt.setString(3, name);
			pstmt.setString(4, nick);
			pstmt.setString(5, email);
			pstmt.setString(6, hp);
			pstmt.setString(7, zip);
			pstmt.setString(8, addr1);
			pstmt.setString(9, addr2);
			pstmt.setString(10, regip);
		
			pstmt.executeUpdate();
		
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			if(rs != null) try{rs.close();}catch(Exception e){}
			if(conn != null) try{conn.close();}catch(Exception e){}
			if(pstmt != null) try{pstmt.close();}catch(Exception e){}
		}
		
	}

}
