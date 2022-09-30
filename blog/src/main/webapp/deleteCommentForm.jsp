<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String comment_no = request.getParameter("comment_no");
	String board_no = request.getParameter("board_no");
	
	//확인.
	System.out.println(comment_no + " <-- c_no");
	System.out.println(board_no + " <-- b_no");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>댓글 삭제</title>
</head>
<body>
	<form action="./deleteCommentAction.jsp?board_no=<%=board_no%>&comment_no=<%=comment_no%>" method="post">
		<input type="hidden" name="comment_no" value="<%=comment_no%>">
		비밀번호 : 
		<input type="password" name = "comment_pw">
		<button type="submit">삭제</button>
	</form>
</body>
</html>