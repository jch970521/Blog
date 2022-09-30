<%@page import="java.util.Calendar"%>
<%@page import="vo.Diary"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	Calendar c = Calendar.getInstance();
	if(request.getParameter("y")!=null || request.getParameter("m")!=null || request.getParameter("d") !=null) {
		int y = Integer.parseInt(request.getParameter("y"));
		int m = Integer.parseInt(request.getParameter("m"));
		int d = Integer.parseInt(request.getParameter("d"));
		
		if(m== -1){ //1월에서 이전버턴
			m=11;
			y = y-1 ; // y+=1; --y ; y-- ;
		}
		if(m==12){//12월에서 이전버턴
			m= 0;
			y = y+1; // y+=1; y++; ++y;
		}
		c.set(Calendar.YEAR , y);
		c.set(Calendar.MONTH , m);
		c.set(Calendar.DATE , d);
		
	}
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://localhost:3306/blog";
	String dbuser = "root";
	String dbpw = "1234";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	String sql = "SELECT diary_no diaryNo , diary_date diaryDate , diary_todo diaryTodo FROM diary WHERE YEAR(diary_date) = ? AND MONTH(diary_date) = ? ORDER BY diary_date DESC";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, c.get(Calendar.YEAR));
	stmt.setInt(2, c.get(Calendar.MONTH)+1);
	
	

	stmt.close();
	conn.close();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
	if(session.getAttribute("loginId").equals("admin")){
%>
	<form method="post" action="./insertDiaryAction.jsp">
		<div>
			<input type="text" name="diaryDate" value="<%=c.get(Calendar.YEAR)%>-<%=c.get(Calendar.MONTH)+1%>-<%=c.get(Calendar.DATE)%>">
			<h2>오늘의 할일 입력</h2>
		</div>
		<div>
			<textarea rows="3" cols="50" name="diaryTodo"></textarea>		
		</div>
		<div>
			<button type="submit">할일 입력</button>
		</div>
	</form>
<% 		
	}
%>
</body>
</html>