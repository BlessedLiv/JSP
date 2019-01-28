package kr.co.board1.config;

public class Sql {
	
	public static final String SELECT_TERMS = "select * from `JSP_TERMS`;";
	
	public static final String INSERT_REGISTER= "insert into `JSP_MEMBER` set uid=?,pass=PASSWORD(?), name=?,nick=?,email=?,hp=?,zip=?,addr1=?,addr2=?,regip=?,rdate=now();";
	
	public static final String SELECT_LOGIN = "select * from `JSP_MEMBER` where uid=? and pass=PASSWORD(?)";
	
	public static final String SELECT_MAX_SEQ = "select max(seq) from `JSP_BOARD`";
	
	public static final String INSERT_BOARD = "insert into `JSP_BOARD` SET "
												+ "cate='notice', title=?, content=?, uid=?, file=?, regip=?, rdate=now();";
	
	public static final String INSERT_FILE = "insert into `JSP_FILE` (parent, oldName, newName, rdate) values(?,?,?,now())";
	
	public static final String SELECT_COUNT = "select count(*) from `JSP_BOARD` where parent=0";
	
	public static final String SELECT_LIST = "select b.*, m.nick from `JSP_BOARD` as b join `JSP_MEMBER` as m on m.uid=b.uid where parent=0 order by b.seq desc limit ?, 10";
	
	public static final String SELECT_VIEW = "select * from `JSP_BOARD`  where seq=?";
	
	public static final String SELECT_VIEW_WITH_FILE= "select * from `JSP_BOARD` as b left join `JSP_FILE` as f on b.seq = f.parent where b.seq=?";
	
	public static final String UPDATE_HIT = "update `JSP_BOARD` set hit=hit+1 where seq=?";
	
	public static final String DELETE_LIST 	= "delete from `JSP_BOARD` where seq=?";
	
	public static final String DELETE_FILE = "delete from `JSP_FILE` where parent=?";
	
	public static final String MODIFY_BOARD = "UPDATE `JSP_BOARD` SET "
			+ "title=?, content=? where seq=?";
	
//	public static final String INSERT_COMMENT = "insert into `JSP_BOARD` (parent, content, uid, regip, rdate) values (?,?,?,?,now())";
	
	public static final String INSERT_COMMENT = "CALL insertComment(?,?,?,?)";
	
	public static final String SELECT_COMMENT = "SELECT b.*, m.nick FROM `JSP_BOARD` as b join `JSP_MEMBER` as m on m.uid=b.uid  WHERE parent=? order by seq ASC";

	
  //	public static final String SELECT_COMMENT = "SELECT b.*, m.nick FROM `JSP_BOARD` as b join `JSP_MEMBER` as m on m.uid=b.uid  WHERE parent=? order by seq ASC";
	
	
	
	public static final String SELECT_NICK = "select b.*, m.nick from `JSP_BOARD` as b join `JSP_MEMBER` as m on m.uid=b.uid";
	
	public static final String DELETE_COMMENT = "delete from `JSP_BOARD` WHERE seq=?";
	
//	public static final String DELETE_COMMENT_COUNT = "update `JSP_BOARD` set comment=comment-1 where parent=?";
	
	public static final String UPDATE_DOWNLOAD = "update `JSP_FILE` set download=download+1 where parent=?";
	
}
