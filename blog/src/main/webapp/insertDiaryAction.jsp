<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%

	if(session.getAttribute("loginId") == null || (Integer)session.getAttribute("loginLevel") < 1) {
		response.sendRedirect("./index.jsp");	
		return;
	} // 로그인 안했거나 admin 아닐때 index로 리턴
	request.setCharacterEncoding("UTF-8");

	String diaryDate = request.getParameter("diaryDate");
	String diaryTodo = request.getParameter("diaryTodo");
	
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://localhost:3306/blog";
	String dbuser = "root";
	String dbpw = "1234";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	
	String sql = "INSERT INTO diary(diary_date , diary_todo , create_date) VALUES (? ,? ,NOW() )";
	
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, diaryDate);
	stmt.setString(2, diaryTodo);
	stmt.executeUpdate();
	
	response.sendRedirect("./diary.jsp");
	
	stmt.close();
	conn.close();
%>
