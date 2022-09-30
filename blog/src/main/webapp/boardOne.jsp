<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	if(session.getAttribute("loginId") == null) { // 로그인 안 했을때
		response.sendRedirect("./index.jsp?errorMsg=do login");
		return;
	}
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));

	
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://localhost:3306/blog";
	String dbuser = "root";
	String dbpw = "1234";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	// 메뉴 목록
	String locationSql = "SELECT location_no locationNo, location_name locationName FROM location";
	PreparedStatement locationStmt = conn.prepareStatement(locationSql);
	ResultSet locationRs = locationStmt.executeQuery();
	/*
	"SELECT 
		l.location_name locationName ,
		b.board_title boardTitle ,
		b.board_content boardContent,
		b.create_date createDate
	 FROM location l INNER JOIN board b
	 ON l.location_no = b.location_no 
	 WHERE b.board_no = ? ";
	*/
	String boardSql ="SELECT l.location_name locationName , b.board_title boardTitle , b.board_content boardContent, b.create_date createDate FROM location l INNER JOIN board b ON l.location_no = b.location_no WHERE b.board_no = ? ";
	PreparedStatement boardStmt = conn.prepareStatement(boardSql);
	boardStmt.setInt(1, boardNo);
	ResultSet boardRs = boardStmt.executeQuery();
	
	// 댓글
	Connection conn2 = DriverManager.getConnection("jdbc:mariadb://localhost:3306/blog","root","1234");
	PreparedStatement stmt2 = conn2.prepareStatement("select comment_no, comment_content, create_date ,board_no from comment where board_no = ?");	
	stmt2.setInt(1, boardNo);
	System.out.println(stmt2);
	
	ResultSet rs2 = stmt2.executeQuery();
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
					
					<li class="list-group-item list-group-item-warning" ><a href="./boardList.jsp">전체</a></li>
					<%
						while(locationRs.next()) {
					%>
							<li class="list-group-item list-group-item-warning" >
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
			<h1>상세보기</h1>
				<% if(boardRs.next()) {
				
				%>
					<table class="table table-bordered">
						<!-- list에서 클릭한 페이지의 정보를 보여주는 상세페이지.
						 boardNo를 체크해서 정보를 받아오면 됨.-->					
						<tr>
							<td>locationName</td>
							<td><%=boardRs.getString("locationName")%></td>
						</tr>
						<tr>
							<td>boardTitle</td>
							<td><%=boardRs.getString("boardTitle")%></td>
						</tr><tr>
							<td>boardContent</td>
							<td><%=boardRs.getString("boardContent")%></td>
						</tr><tr>
							<td>createDate</td>
							<td><%=boardRs.getString("createDate")%></td>
						</tr>
					</table>
					
				<%
					}
				
					if((Integer)session.getAttribute("loginLevel") >0 ){
						
					
				%>
				<div>
				<a href="./updateBoardForm.jsp?boardNo=<%=boardNo%>">글 수정</a>
				<a href="./deleteBoardForm.jsp?boardNo=<%=boardNo%>">글 삭제</a>
				</div>
				<%
					}
				%>
				<hr/>
				<!-- 댓글 -->
					<table border="1" width="100%" class="table table-dark" >
						<tr>
							<th>번호</th>
							<th>내용</th>
							<th>시간</th>
							<th>삭제</th>
							</tr>
				<%
					while(rs2.next()){	
				%>
					<tr>
						<td><%=rs2.getInt("comment_no")%></td>
						<td><%=rs2.getString("comment_content")%></td>
						<td><%=rs2.getString("create_date")%></td>
						
				<td><a href="./deleteCommentForm.jsp?comment_no=<%=rs2.getInt("comment_no")%>&board_no=<%=rs2.getInt("board_no")%>">삭제</a></td>
					</tr>
					
					<input type="hidden" name="boardNo" value = "<%=rs2.getInt("board_no")%>">
				<%
					}
				if((Integer)session.getAttribute("loginLevel") >0 ){
				%>
					</table>
				<hr/>
				<!-- 댓글 입력 폼 -->
				
					<div>
					<form action="./insertCommentAction.jsp" method="post">
						<input type="hidden" name="boardNo" value="<%=boardNo%>">
						<div>
							댓글
							<textarea rows="2" cols="50" name="comment_content"></textarea>
						</div>
						<div>
							비밀번호
						<input type="password" name="comment_pw">
						</div>
						<div>
							<button type="submit" class="btn btn-primary">댓글입력</button>
						</div>
					</form>
				</div>
				<%
					}
				%>	
		</div> <!-- end main -->
	</div>
</div>
</body>
</html>