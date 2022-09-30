<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	request.setCharacterEncoding("UTF-8");
	int locationNo = Integer.parseInt(request.getParameter("locationNo"));
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String boardPw = request.getParameter("boardPw");
	// 디버깅
	
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://localhost:3306/blog";
	String dbuser = "root";
	String dbpw = "1234";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	//메뉴목록
	String sql ="INSERT INTO board(location_no,board_title,board_content,board_pw,create_date) VALUES ( ?,?,?,PASSWORD(?),now() )";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, locationNo);
	stmt.setString(2, boardTitle);
	stmt.setString(3, boardContent);
	stmt.setString(4, boardPw);
	// 쿼리 실행되었는지 확인하기.
	int row = stmt.executeUpdate();
	if(row == 1 ){// row가 1 ( 글이 성공적으로 입력되었을때 )
		//
		
	} else{ // row가 1이아님 ( 오류가 난 상황 )
		//
	}
	
	// 재요청
	response.sendRedirect("./boardList.jsp");
	
	// 종료
	stmt.close();
	conn.close();
%>
