<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>

<%
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String boardPw = request.getParameter("boardPw");
	
	System.out.println(boardNo + " <-- no");
	System.out.println(boardPw + " <-- pw");
	
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://localhost:3306/blog";
	String dbuser = "root";
	String dbpw = "1234";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	PreparedStatement stmt = conn.prepareStatement("delete from board where board_no = ? and board_pw = password(?)");
	stmt.setInt(1, boardNo);
	stmt.setString(2, boardPw);
	System.out.println(stmt + " <-- stmt");
	
	int row = stmt.executeUpdate();
	System.out.println(row);
	if(row == 0) {
		response.sendRedirect("./boardOne.jsp?boardNo="+boardNo);
	} else {
		response.sendRedirect("./boardList.jsp");
	}
	
	//
	stmt.close();
	conn.close();
%>