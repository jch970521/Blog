<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	if(session.getAttribute("loginId") == null || (Integer)session.getAttribute("loginLevel") < 1) {
		response.sendRedirect("./index.jsp");	
		return;
	}
	/*
	if((Integer)session.getAttribute("loginLevel") < 1) {
		response.sendRedirect("./boardList.jsp");	
		return;
	}
	*/
	request.setCharacterEncoding("utf-8");	

	String guestbookContent = request.getParameter("guestbookContent");
	
	// 디버깅
	
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://localhost:3306/blog";
	String dbuser = "root";
	String dbpw = "1234";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	// 메뉴 목록
	String sql = "INSERT INTO guestbook(guestbook_content, id,create_date) VALUES(?,?,NOW())";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, guestbookContent);
	stmt.setString(2, (String)session.getAttribute("loginId"));
	stmt.executeUpdate();
	
	response.sendRedirect("./guestbook.jsp");	
	
	stmt.close();
	conn.close();
	
%>
