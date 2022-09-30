<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	String locationNo = request.getParameter("locationNo");
	System.out.println(locationNo+" <-- locationNo");	
	String word = request.getParameter("word"); // 검색어가 있을때와 없을때(null) 분기가 필요
	
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	final int ROW_PER_PAGE = 10;
	int beginRow = (currentPage - 1) * ROW_PER_PAGE;

	
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
		</div>
		
		<div class="col-sm-10">
			<!-- main -->
			<!-- 여기만 바뀜 -->
			<%
				// 게시글 목록
				String boardSql = "";
				PreparedStatement boardStmt = null;
				if(locationNo == null) {
					boardSql = "SELECT l.location_name locationName, b.location_no locationNo, b.board_no boardNo, b.board_title boardTitle FROM location l INNER JOIN board b ON l.location_no = b.location_no ORDER BY board_no DESC LIMIT ?, ?";
					boardStmt = conn.prepareStatement(boardSql);
					boardStmt.setInt(1, beginRow);
					boardStmt.setInt(2, ROW_PER_PAGE);
				} else {
					boardSql = "SELECT l.location_name locationName, b.location_no locationNo, b.board_no boardNo, b.board_title boardTitle FROM location l INNER JOIN board b ON l.location_no = b.location_no WHERE b.location_no = ? ORDER BY board_no DESC LIMIT ?, ?";
					boardStmt = conn.prepareStatement(boardSql);
					boardStmt.setInt(1, Integer.parseInt(locationNo));
					boardStmt.setInt(2, beginRow);
					boardStmt.setInt(3, ROW_PER_PAGE);
				}
				ResultSet boardRs = boardStmt.executeQuery();
				
				// 게시글 카운터(stmt, rs)
				PreparedStatement stmt2 = null;
				if(word == null) {
					stmt2 = conn.prepareStatement("select count(*) from board");
					//검색 안 했을떄는 board 테이블 갯수세서 전부 출력
				} else {
					stmt2 = conn.prepareStatement("select count(*) from board where board_title like ?");
					stmt2.setString(1, "%"+word+"%");
					//검색 했을때는 board 테이블에서 검색한거 포함한애들 갯수세서 출력
				}
				
				ResultSet rs2 = stmt2.executeQuery();
				int totalCount = 0;
				if(rs2.next()) {
					totalCount = rs2.getInt("count(*)");
				}
			%>	
			<%
				if(session.getAttribute("loginLevel") !=null 
					&& (Integer)(session.getAttribute("loginLevel"))>0){

			%>
			<div>
				<a href="./insertBoard.jsp">글 입력</a>
			</div>
			<%		
				}
			
			%>
			
			
			<table class="table table-hover table-striped">
				<thead class="table-primary" >
					<tr>
						<th>locationName</th>
						<th>boardNo</th>
						<th>boardTitle</th>
					</tr>
				</thead>
				<tbody>
					<% 
						while(boardRs.next()) {
					%>
							<tr>
								<td><%=boardRs.getString("locationName")%></td>
								<td><%=boardRs.getInt("boardNo")%></td>
								<td>
									<a href="./boardOne.jsp?boardNo=<%=boardRs.getInt("board_no")%>">
										<%=boardRs.getString("boardTitle")%>
									</a>	
								</td>
							</tr>
					<%		
						}
					%>
				</tbody>
			</table>
			
			<div>
				<form class="form-inline" action="./boardList.jsp">
					<%
						if(locationNo != null) {
					%>
							<input type="hidden" name="locationNo" value="<%=locationNo%>">
					<%		
						}
					%>
					<label>제목검색</label>
					<input type="text" class="form-control" name="word">
					<button type="submit" class="btn btn-primary">검색</button>
				</form>
			</div>
			
			<!--  페이징 -->
			<div>
				<ul class="pagination pagination-sm">
					<%
						if(locationNo == null) {
							if(currentPage > 1) {
					%>
								<li class="page-item"><a  class="page-link" href="./boardList.jsp?currentPage=<%=currentPage-1%>">이전</a></li>
					<%			
							}
						} else {
							if(currentPage > 1) {
					%>
								<li class="page-item"><a  class="page-link" href="./boardList.jsp?currentPage=<%=currentPage-1%>&locationNo=<%=locationNo%>">이전</a></li>
					<%		
							}
						}
						
					%>
					
					<%
						if(locationNo == null) {
					%>
							<li class="page-item" ><a  class="page-link" href="./boardList.jsp?currentPage=<%=currentPage+1%>">다음</a></li>
					<%		
						} else {
					%>
							<li class="page-item" ><a  class="page-link" href="./boardList.jsp?currentPage=<%=currentPage+1%>&locationNo=<%=locationNo%>">다음</a></li>
					<%	
						}
					%>
				</ul>
			</div>
			
		</div> <!-- end main -->
	</div>
</div>
</body>
</html>