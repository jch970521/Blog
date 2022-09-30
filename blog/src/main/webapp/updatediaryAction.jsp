<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>

<%
	if(session.getAttribute("loginId") == null) { // 로그인 안 했을때
		response.sendRedirect("./index.jsp?errorMsg=do login");
		return;
	}	

	request.setCharacterEncoding("UTF-8");

	int diaryNo = Integer.parseInt(request.getParameter("diaryNo"));
	String diaryDate = request.getParameter("diaryDate");
	String diaryTodo = request.getParameter("diaryTodo");
	
	
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://localhost:3306/blog";
	String dbuser = "root";
	String dbpw = "1234";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	String sql = "UPDATE diary SET diary_date = ? , diary_todo = ? , create_date = now() where diary_no = ? ";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, diaryDate);
	stmt.setString(2, diaryTodo);
	stmt.setInt(3, diaryNo);
	
	
	int row = stmt.executeUpdate();

	
	// 재요청
	response.sendRedirect("./diary.jsp");
	
	//연동 해제
	stmt.close();
	conn.close();
%>