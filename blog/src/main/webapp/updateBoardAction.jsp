<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>

<%
	if(session.getAttribute("loginId") == null) { // 로그인 안 했을때
		response.sendRedirect("./index.jsp?errorMsg=do login");
		return;
	}	

	request.setCharacterEncoding("UTF-8");

	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String boardPw = request.getParameter("boardPw");
	
	System.out.println(boardNo + " <-- no");
	System.out.println(boardTitle + " <-- title");
	System.out.println(boardContent + " <-- content");
	System.out.println(boardPw + " <-- pw");
	
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://localhost:3306/blog";
	String dbuser = "root";
	String dbpw = "1234";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	/*
		바꿀수있는것
		locationName - > locationNo를 바꾸면 이름은 자동으로 바뀜.
		boardTitle -> 제목 변경 가능
		boardContent -> 내용 변경가능.
		그런데
		글번호와 , 글비밀번호가 맞아야 수정가능.

	*/
	String upSql = "UPDATE board SET board_title = ?, board_content = ? WHERE board_no = ? AND board_pw = PASSWORD(?)";
	PreparedStatement upStmt = conn.prepareStatement(upSql);
	upStmt.setString(1, boardTitle);
	upStmt.setString(2, boardContent);
	upStmt.setInt(3, boardNo);
	upStmt.setString(4, boardPw);
	
	int row = upStmt.executeUpdate();
	if(row == 1 ){// row가 1 ( 글이 성공적으로 입력되었을때 )
		//
		System.out.println("글 수정성공");
	} else{ // row가 1이아님 ( 오류가 난 상황 )
		//
		System.out.println("글 수정실패");
	}
	
	// 재요청
	response.sendRedirect("./boardList.jsp");
	
	//연동 해제
	upStmt.close();
	conn.close();
%>
