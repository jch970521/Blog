<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
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
					<li><a href="./index.jsp">홈으로</a></li>
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
		</div>
		
		<!-- start main -->
		<div class="col-sm-10">
			<%
				if(session.getAttribute("loginId") != null) {
			%>
					<form method="post" action="./insertGuestbookAction.jsp">
						<div>
							<textarea rows="3" cols="50" name="guestbookContent"></textarea>
						</div>
						<div>
							<button type="submit">글입력</button>
						</div>
						<!-- 
							guestbook_no : auto increment
							guestbook_content : guestbookContent
							id : session.getAttribute("loginId")
							create_date : now()
						 -->
					</form>
			<%
				}
			%>
			<!-- to do -->
			<%
				/*
					SELECT guestbook_no guestbookNo, 
						   guestbook_content guestbookContent, 
						   id, 
						   create_date createDate 
					FROM guestbook 
					ORDER BY create_date 
					LIMIT ?,?
				*/
				
				int ROW_PER_PAGE = 10;
				int beginRow = 0;
				
				String guestbookSql = "SELECT guestbook_no guestbookNo, guestbook_content guestbookContent, id, create_date createDate FROM guestbook ORDER BY create_date DESC LIMIT ?,?";
				PreparedStatement guestbookStmt = conn.prepareStatement(guestbookSql);
				guestbookStmt.setInt(1, beginRow);
				guestbookStmt.setInt(2, ROW_PER_PAGE);
				ResultSet guestbookRs = guestbookStmt.executeQuery();
			%>
					<%
						while(guestbookRs.next()) {
					%>
							<table border="1">
								<tr>
									<td colspan="2"><%=guestbookRs.getString("guestbookContent")%></td>
								</tr>
								<tr>
									<td><%=guestbookRs.getString("id")%></td>
									<td><%=guestbookRs.getString("createDate")%></td>
								</tr>
							</table>
							<%
								String loginId = (String)session.getAttribute("loginId");
								if(loginId != null && loginId.equals(guestbookRs.getString("id"))) {
							%>
									<a href="./deleteGuestbook.jsp?guestbookNo=<%=guestbookRs.getInt("guestbookNo")%>">삭제</a>
							<%
								}

						}
					
					guestbookRs.close();
					guestbookStmt.close();
					conn.close();
					%>
				
		</div><!-- end main -->
	</div>
</div>
</body>
</html>