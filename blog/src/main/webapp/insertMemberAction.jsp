<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	request.setCharacterEncoding("UTF-8");
	String id = request.getParameter("id");
	String pw = request.getParameter("pw");
	
	if(id==null || pw==null || id.length() <4 || pw.length() <4 ){
		response.sendRedirect("./insertMember.jsp?errorMsg=error");
		return; //return 적지않고 대신 else 문을 사용해도 된다.
	}
	
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://localhost:3306/blog";
	String dbuser = "root";
	String dbpw = "1234";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	
	String sql = "insert into member(id , pw , level) values(?,password(?),0)";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, id);
	stmt.setString(2, pw);
	stmt.executeQuery();

	response.sendRedirect("./index.jsp");

	
%>