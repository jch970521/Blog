<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%
		if(request.getParameter("errorMsg")!=null){
	%>
		<div><%=request.getParameter("errorMsg")%></div>
	<%		
		}
	%>
	<h1>index</h1>
	<%
		if(session.getAttribute("loginId") ==null ){//null일때 = 로그인한 적없음.
	%>		
	
	<h2>로그인</h2>
	<form method="post" action="./loginAction.jsp">
		<table border="1">
			<tr>
				<td>id</td>
				<td><input type="text" name="id" value="admin"></td>
			</tr>
			<tr>
				<td>pw</td>
				<td><input type="password" name="pw" value="1234"></td>
			</tr>
		</table>
		<button type="submit">로그인</button>
	</form>
	<a href="./insertMember.jsp">회원가입</a>
	<%
		} else{
	%>
		<h2><%=session.getAttribute("loginId")%>(<%=session.getAttribute("loginLevel")%>)님 반갑습니다.</h2>
		<a href="./logout.jsp">로그아웃</a>
	<%		
		}
	%>
	
	<ul>
		<li>
			<a href="./boardList.jsp">게시판</a>	
		</li>
		
		<li>
			<a href="./guestbook.jsp">방명록</a>
		</li>
		
		<li>
			<a href="./diary.jsp">다이어리</a>
		</li>
	</ul>
</body>
</html>