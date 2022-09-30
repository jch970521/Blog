
<%@ page import="java.util.Calendar"%>
<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	Calendar c = Calendar.getInstance();

	int diaryNo = Integer.parseInt(request.getParameter("diaryNo"));
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
	
	String sql = "SELECT diary_no diaryNo , diary_date diaryDate , diary_todo diaryTodo , create_date createDate FROM diary WHERE diary_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, diaryNo);
	
	ResultSet rs = stmt.executeQuery();


%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
  <script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.slim.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<h1>Todo</h1>
	<%
		if(rs.next()){
	%>
		<form method="post">
			<table border="1" width="60%" style="background-color:black">
				<tr>
					<td style="color:white;">diaryNo</td>
					<td style="color:white;"><%=rs.getInt("diaryNo") %></td>
				</tr>
				<tr>
					<td style="color:white;">diaryDate</td>
					<td style="color:white;"><%=rs.getString("diaryDate")%></td>
				</tr>
				<tr>	
					<td style="color:white;">dirayTodo</td>
					<td style="color:white;"><%=rs.getString("diaryTodo") %></td>
				</tr>
				<tr>
					<td style="color:white;">createDate</td>
					<td style="color:white;"><%=rs.getString("createDate") %></td>
				</tr>	
	<%
		}
	%>
	</table>
	<a href="./updateDiary.jsp?diaryNo=<%=diaryNo%>" class="btn btn-outline-dark">일정 수정</a>
	<a href="./deleteDiary.jsp?diaryNo=<%=diaryNo%>" class="btn btn-outline-dark">일정 삭제</a>
	<a href="./diary.jsp" class="btn btn-outline-dark" >돌아가기</a>
		</form>
</body>
</html>
