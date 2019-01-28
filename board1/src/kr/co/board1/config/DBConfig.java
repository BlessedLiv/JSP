package kr.co.board1.config;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConfig {
	
	final static String HOST = "jdbc:mysql://192.168.0.126:3306/kjb";  //static은 클래스 메모리에 저장됨  
	final static String USER = "kjb";
	final static String PASS = "1234";


	public static Connection getConnection () throws Exception {
		
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = DriverManager.getConnection(HOST, USER, PASS);
		return conn;
	}
}
