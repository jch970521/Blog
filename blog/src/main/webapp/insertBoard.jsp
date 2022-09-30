<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%

	if(session.getAttribute("loginLevel") == null || (Integer)session.getAttribute("loginLevel") <1) {
		response.sendRedirect("./index.jsp");
		return;
	}

	/*
	if( (Integer)session.getAttribute("lovinLvel") <1 ){
	response.sendRedirect("./boardList.jsp");
		return;
	}*/
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://localhost:3306/blog";
	String dbuser = "root";
	String dbpw = "1234";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	// 메뉴 목록
	String locationSql = "SELECT location_no locationNo, location_name locationName FROM location";
	PreparedStatement locationStmt = conn.prepareStatement(locationSql);
	ResultSet locationRs = locationStmt.executeQuery();
	
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
<div class="container-fluid">
	<h1>Blog</h1>
	<hr>
	<div class="row">
		<div class="col-sm-2">
			<!-- left menu -->
			<div>
				<ul>
					
					<li><a href="./boardList.jsp">전체</a></li>
					<%
						while(locationRs.next()) {
					%>
							<li>
								<a href="./boardList.jsp?locationNo=<%=locationRs.getString("locationNo")%>">
									<%=locationRs.getString("locationName")%>
								</a>
							</li>
					<%		
						}
					%>	
				</ul>
			</div>
		</div><!-- 왼쪽에 리스트를 계속 출력해줄거니까 이쪽은 동일. -->
		
		<!-- main -->
		<div class="col-sm-10">
			<h1>게시글 입력</h1>
				<form method="post" action="./insertBoardAction.jsp">
					<table class="table table-bordered">
						<tr>
							<td>locationNo</td>
							<td>
								<select name="locationNo">
									<%
										locationRs.first(); //오류날수도있는데 일단 사용
										do {
									%>
										<option value="<%=locationRs.getInt("locationNo")%>">
											<%=locationRs.getString("locationName")%>
										</option>
									
									<%		
										} while(locationRs.next());
									%>
								</select></td>
						</tr>
						
						<tr>
							<td>boardTitle</td>
							<td><input type="text" name="boardTitle"></td>
						</tr>
						<tr>
							<td>boardContent</td>
							<td><textarea rows="5" cols="80" name="boardContent"></textarea></td>
						</tr>
						<tr>
							<td>boardPw</td>
							<td><input type="password" name="boardPw"></td>
						</tr>
					</table>
					<button type="submit">글 입력</button>
					<button type="reset">초기화 </button>
				</form>
			
			<!-- 글 입력 폼이 나옴. -->
			
		</div> <!-- end main -->
	</div>
</div>
</body>
</html>