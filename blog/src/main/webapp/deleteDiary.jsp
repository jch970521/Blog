<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<% 
	if(session.getAttribute("loginId") == null) { // 로그인 안 했을때
		response.sendRedirect("./index.jsp?errorMsg=do login");
		return;
	}

	int diaryNo = Integer.parseInt(request.getParameter("diaryNo"));
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
 <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
  <script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.slim.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<%
	if(session.getAttribute("loginId").equals("admin")){
%>
	<form action="./deletediaryAction.jsp" method="post">
				<input type="hidden" name="diaryNo" value="<%=diaryNo%>">
				<p>버튼을 누르면 일정이 삭제됩니다.</p>
				<button type="submit" class="btn btn-outline-secondary">삭제</button>
	</form>
<% 		
	}
%>	
</body>
</html>