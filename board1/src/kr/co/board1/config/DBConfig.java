package kr.co.board1.config;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConfig {
	
	final static String HOST = "jdbc:mysql://192.168.0.126:3306/kjb";  //static�� Ŭ���� �޸𸮿� �����  
	final static String USER = "kjb";
	final static String PASS = "1234";


	public static Connection getConnection () throws Exception {
		
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = DriverManager.getConnection(HOST, USER, PASS);
		return conn;
	}
}
