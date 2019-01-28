package kr.co.board1.service;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.PageContext;

import org.apache.tomcat.util.http.HttpMessages;

import kr.co.board1.config.DBConfig;
import kr.co.board1.config.Sql;
import kr.co.board1.vo.BoardVO;
import kr.co.board1.vo.MemberVO;

public class BoardService {
	private static BoardService service = new BoardService();
	public static BoardService getInstance() {
		return service;
	}
	private BoardService() {}
	
	public MemberVO getMember(HttpSession session) {
		
		MemberVO vo = (MemberVO)session.getAttribute("member");
		return vo;
	}
	
	public int write(int file, String... args) throws Exception{
		/*
		Connection conn =  DBConfig.getConnection();
	
		int seq = -1;
		PreparedStatement pstmt = conn.prepareStatement(Sql.INSERT_BOARD, PreparedStatement.RETURN_GENERATED_KEYS);
		
		pstmt.setString(1, args[0]);
		pstmt.setString(2, args[1]);
		pstmt.setString(3, args[2]);
		pstmt.setInt(4, file);
		pstmt.setString(5, args[3]);
		pstmt.executeUpdate();
		
		ResultSet rs = pstmt.getGeneratedKeys();

		if (rs.next()) {
			seq = rs.getInt(1);
			}
		
		conn.close();
		pstmt.close();
		
		
		return seq;
		
		----------------
		*/
		
		Connection conn =  DBConfig.getConnection();
		conn.setAutoCommit(false); //transaction start !!  defualt=true. 
		
		PreparedStatement pstmt = conn.prepareStatement(Sql.INSERT_BOARD);
		
		pstmt.setString(1, args[0]);
		pstmt.setString(2, args[1]);
		pstmt.setString(3, args[2]);
		pstmt.setInt(4, file);
		pstmt.setString(5, args[3]);
		
		Statement stmt = conn.createStatement();
		pstmt.executeUpdate();
		ResultSet rs = stmt.executeQuery(Sql.SELECT_MAX_SEQ);
		
		
		conn.commit(); // transaction apply & end
		
		int seq = 0;
		if(rs.next()) {
			seq = rs.getInt(1);
		}
		
		conn.close();
		pstmt.close();
		stmt.close();
		
		return seq;
		
		
	}
	
	public void fileInsert(int parent, String oldName, String newName) throws Exception{
		
		Connection conn = DBConfig.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(Sql.INSERT_FILE);
		pstmt.setInt(1, parent);
		pstmt.setString(2, oldName);
		pstmt.setString(3, newName);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	public int getTotal() throws Exception{
		int total = 0;
		Connection conn = DBConfig.getConnection();
		Statement stmt = conn.createStatement();
		ResultSet rs = stmt.executeQuery(Sql.SELECT_COUNT);
		if(rs.next()) {
			total = rs.getInt(1); //첫번째 열 가저오기!!!
		}
		
		rs.close();
		stmt.close();
		conn.close();
		return total;
		
	}

	public int getLimitStart(String pg) {
		//start for limit number null check
		int start = 0;
		if(pg == null){
			start = 1;
		}else{
			start = Integer.parseInt(pg);
		}
		return (start - 1) * 10; //sql에 넣을 start 번호 지정
		
	}
	public int getPageEnd(int total) throws Exception {
		//paging calculation
		
		int pageEnd = 0; //page 번호(밑에 버튼)
		if(total%10==0){pageEnd = total/10;}else{pageEnd=(total/10)+1;} //총 글 수에 대한 page 번호 계산
		return pageEnd;
		
	}
	public int getPageCountStart(int total, int start) {
		return total - start ; // 각 글마다 가진 글 번호 지정
		
	}
	public int[] getPageGroupStartEnd(String pg, int pageEnd) {
		int[] groupStartEnd = new int[2];
		
		//page group calculation
		int current = 0;
		if(pg == null){
			current = 1;
		}else{
			current = Integer.parseInt(pg);
		}
		int currentPage = current;
		int currentPgGroup = (int)Math.ceil(currentPage/10.0);
		int groupStart = (currentPgGroup - 1) * 10  + 1 ;
		int groupEnd = groupStart + 9; //currentPgGroup * 10 ;
		
		if(groupEnd > pageEnd){
			groupEnd = pageEnd;
		}
		
		groupStartEnd[0] = groupStart;
		groupStartEnd[1] = groupEnd;
		return groupStartEnd;
	}
	public List<BoardVO> list(int start) throws Exception{
		List<BoardVO> list = new ArrayList<>();
		Connection conn = DBConfig.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(Sql.SELECT_LIST);
		pstmt.setInt(1, start);
		ResultSet rs = pstmt.executeQuery();
		
		while(rs.next()){
			BoardVO vo = new BoardVO();
			 vo.setSeq(rs.getString("seq"));  //colum명으로 해도 된다.
			 vo.setParent(rs.getString(2));
			 vo.setComment(rs.getString(3));
			 vo.setCate(rs.getString(4));
			 vo.setTitle(rs.getString(5));
			 vo.setContent(rs.getString(6));
			 vo.setFile(rs.getInt(7));
			 vo.setHit(rs.getString(8));
			 vo.setUid(rs.getString(9));
			 vo.setRegip(rs.getString(10));
			 vo.setRdate(rs.getString(11));
			 vo.setNick(rs.getString(12));
			 
			 list.add(vo);
		}
		
		rs.close();
		pstmt.close();
		conn.close();
		
		return list;
				
	}
	//조회수 +1
	public void updateHit(String seq) throws Exception{
		
		Connection conn = DBConfig.getConnection();
		PreparedStatement pstmt2 = conn.prepareStatement(Sql.UPDATE_HIT);
		pstmt2.setString(1,seq);
		pstmt2.executeUpdate();
		
		pstmt2.close();
	}
	
	public BoardVO view(HttpServletRequest request) throws Exception{
		
		
		request.setCharacterEncoding("utf-8");
		String seq = request.getParameter("seq");
		
			
		Connection conn = DBConfig.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(Sql.SELECT_VIEW_WITH_FILE);
		
		pstmt.setString(1,seq);
		
		ResultSet rs = pstmt.executeQuery();
		BoardVO vo = null;
		
		if(rs.next()){
			 vo = new BoardVO();
			 vo.setSeq(rs.getString("seq"));  //colum명으로 해도 된다.
			 vo.setParent(rs.getString(2));
			 vo.setComment(rs.getString(3));
			 vo.setCate(rs.getString(4));
			 vo.setTitle(rs.getString(5));
			 vo.setContent(rs.getString(6));
			 vo.setFile(rs.getInt(7));
			 vo.setHit(rs.getString(8));
			 vo.setUid(rs.getString(9));
			 vo.setRegip(rs.getString(10));
			 vo.setRdate(rs.getString(11));
			 vo.setOldName(rs.getString("oldName"));
			 vo.setDownload(rs.getString("download"));
			 vo.setNewName(rs.getString("newName"));
		}
		
		rs.close();
		pstmt.close();
		conn.close();
		
		return vo;
	}
	public String modify(HttpServletRequest request) throws Exception{
		
		request.setCharacterEncoding("utf-8");
		String seq = request.getParameter("seq");
		String title = request.getParameter("subject");
		String content = request.getParameter("content");
		
		
		Connection conn =  DBConfig.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(Sql.MODIFY_BOARD);
		

		pstmt.setString(1, title);
		pstmt.setString(2, content);
		pstmt.setString(3, seq);
		
		pstmt.executeUpdate();
		
		conn.close();
		pstmt.close();
		
		return seq;
		
	}
	public String delete(HttpServletRequest request) throws Exception{
		request.setCharacterEncoding("utf-8");
		String parent = request.getParameter("parent");
		String seq = request.getParameter("seq");
		Connection conn = DBConfig.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(Sql.DELETE_COMMENT);
		pstmt.setString(1,seq);
		pstmt.executeUpdate();
		
		pstmt.close();
		conn.close();
		return parent;
	}
	public String insertComment(HttpServletRequest request) throws Exception{
		request.setCharacterEncoding("utf-8");
		String comment  = request.getParameter("comment");
		String regip = request.getRemoteAddr();
		String parent = request.getParameter("parent");
		String uid = request.getParameter("uid");
				
		Connection conn = DBConfig.getConnection();
		
		CallableStatement call = conn.prepareCall(Sql.INSERT_COMMENT); //프로시져 사용!!
		call.setString(1,parent);
		call.setString(2,comment);
		call.setString(3,uid);
		call.setString(4,regip);
		
		call.execute();
		
		call.close();
		conn.close();
		
		return parent;
	}
	public List<BoardVO> listComment(String parent) throws Exception{
		
		Connection conn = DBConfig.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(Sql.SELECT_COMMENT);
		pstmt.setString(1,parent);
		
		PreparedStatement pstm = conn.prepareStatement(Sql.SELECT_NICK);
		
		
		ResultSet rs = pstmt.executeQuery();
		BoardVO vo = null;
		List<BoardVO> list = new ArrayList<>();
		
		while(rs.next()){
			 vo = new BoardVO();
			 vo.setSeq(rs.getString("seq"));  //colum명으로 해도 된다.
			 vo.setParent(rs.getString(2));
			 vo.setComment(rs.getString(3));
			 vo.setCate(rs.getString(4));
			 vo.setTitle(rs.getString(5));
			 vo.setContent(rs.getString(6));
			 vo.setFile(rs.getInt(7));
			 vo.setHit(rs.getString(8));
			 vo.setUid(rs.getString(9));
			 vo.setRegip(rs.getString(10));
			 vo.setRdate(rs.getString(11));
			 vo.setNick(rs.getString(12));
			 
			 list.add(vo);
		}
		
		rs.close();
		pstmt.close();
		conn.close();
		
		return list;
		
	}
	
	public void updateCommentCount() throws Exception {
		
	}
}
