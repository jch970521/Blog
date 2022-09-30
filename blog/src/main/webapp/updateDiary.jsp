<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Calendar"%>
<%

	if(session.getAttribute("loginId") == null) { // 로그인 안 했을때
		response.sendRedirect("./index.jsp?errorMsg=do login");
		return;
	}
	request.setCharacterEncoding("UTF-8");

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
	
	int diaryNo = Integer.parseInt(request.getParameter("diaryNo"));
	String diaryDate = request.getParameter("diaryDate");
	String diaryTodo = request.getParameter("diaryTodo");
	
	
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://localhost:3306/blog";
	String dbuser = "root";
	String dbpw = "1234";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	// 메뉴 목록
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
	<!-- Latest compiled and minified CSS -->
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
	<!-- jQuery library -->
	<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.slim.min.js"></script>
	<!-- Popper JS -->
	<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
	<!-- Latest compiled JavaScript -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<h1>Todo</h1>
	<%
		if(rs.next()){
	%>
		<form method="post" action="./updatediaryAction.jsp">
			<table border="1" width="60%">
				<tr>
					<td>diaryNo</td>
					<td><input type="hidden" name="diaryNo" value="<%=rs.getInt("diaryNo")%>"><%=rs.getInt("diaryNo")%></td>
				</tr>
				<tr>
					<td>diaryDate</td>
					<td><input type="text" name="diaryDate" value="<%=rs.getString("diaryDate")%>"></td>
				</tr>
				<tr>	
					<td>dirayTodo</td>
					<td><input type="text" name="diaryTodo" value="<%=rs.getString("diaryTodo")%>"></td>
				</tr>
				<tr>
					<td>createDate</td>
					<td><input type="hidden" name="create_date" value="<%=rs.getString("createDate")%>"><%=rs.getString("createDate")%></td>
				</tr>
			</table>
			<div>
				<button type="submit" class="btn btn-danger" >일정 수정하기</button>
				<a href="./diary.jsp" class="btn btn-danger" >돌아가기</a>
			</div>
		</form>
	<%
		}
	%>
	
	
</body>
</html>