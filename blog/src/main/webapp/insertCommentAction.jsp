<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%
	request.setCharacterEncoding("UTF-8");

	if(session.getAttribute("loginId") == null) { // 로그인 안 했을때
		response.sendRedirect("./index.jsp?errorMsg=do login");
		return;
	}

	//인코딩
	request.setCharacterEncoding("UTF-8");
	
	//board의 no
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int comment_pw = Integer.parseInt(request.getParameter("comment_pw"));
	String comment_content = request.getParameter("comment_content");

	//1 ) 드라이버 로딩
		Class.forName("org.mariadb.jdbc.Driver");
		out.print("드라이버 로딩 성공");
	//2 ) 접속
		Connection conn = null;
		conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/blog","root","1234");
		System.out.println(conn + " conn ");
	
		// db처리 - 서비스(모델)
		PreparedStatement stmt = conn.prepareStatement("insert into comment (board_no , comment_content, comment_pw , create_date) values(?, ? , ?, now() )");
		stmt.setInt(1, boardNo);
		stmt.setString(2, comment_content);
		stmt.setInt(3, comment_pw);
		
	
		System.out.println(stmt);
		
		stmt.executeUpdate();
		response.sendRedirect("./boardOne.jsp?boardNo="+boardNo);

		stmt.close();
		conn.close();
%>