<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%
	if(session.getAttribute("loginId") == null) { //로그인 x
		response.sendRedirect("./index.jsp");
		return;
	}

	if(request.getParameter("diaryNo") == null) { // diary번호가 x일때
		response.sendRedirect("./diary.jsp");
		return;
	}
	
	int diaryNo = Integer.parseInt(request.getParameter("diaryNo"));
	
	//연결
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://localhost:3306/blog";
	String dbuser = "root";
	String dbpw = "1234";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	String sql = "DELETE FROM diary WHERE diary_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, diaryNo);
	
	int row = stmt.executeUpdate();
	
	response.sendRedirect("./diary.jsp");
	
	stmt.close();
	conn.close();
%>
