<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>회원가입</h1>
	<%
		if(request.getParameter("errorMsg")!=null){
	%>
		<span style="color:red;"><%=request.getParameter("errorMsg")%></span>
	<%	
		}
	%>
	<form method="post" action="./insertMemberAction.jsp">
		<table border="1">
			<tr>
				<td>id</td>
				<td><input type="text" name="id"></td>
			</tr>
			
			<tr>
				<td>pw</td>
				<td><input type="password" name="pw"></td>
			</tr>
		</table>
		<button type="submit">회원가입</button>
	</form>
</body>
</html>