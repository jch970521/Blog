<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%
	
	request.setCharacterEncoding("utf-8");
	int boardNo = Integer.parseInt(request.getParameter("board_no"));	
	int comment_no = Integer.parseInt(request.getParameter("comment_no"));
	int comment_pw = Integer.parseInt(request.getParameter("comment_pw"));

	System.out.println(boardNo + " <-- boardNo");
	System.out.println(comment_no  + " <-- commentNo");
	

	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/blog","root","1234");
	out.println(conn + "<--conn");

	PreparedStatement stmt = conn.prepareStatement("delete from comment where comment_no=? and board_no=? and comment_pw = ?");
	stmt.setInt(1,comment_no);
	stmt.setInt(2,boardNo);
	stmt.setInt(3,comment_pw);
	
	System.out.println(stmt);
	
	int row = stmt.executeUpdate();
	
	System.out.println(row + " <-- row");
	
	response.sendRedirect("./boardOne.jsp?boardNo="+boardNo);
	
%>