<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="vo.Diary"%>
<%
	Calendar c = Calendar.getInstance();
	if(request.getParameter("y")!=null || request.getParameter("m")!=null) {
		int y = Integer.parseInt(request.getParameter("y"));
		int m = Integer.parseInt(request.getParameter("m"));
		
		if(m== -1){ //1월에서 이전버턴
			m=11;
			y = y-1 ; // y+=1; --y ; y-- ;
		}
		if(m==12){//12월에서 이전버턴
			m= 0;
			y = y+1; // y+=1; y++; ++y;
		}
		c.set(Calendar.YEAR , y);
		c.set(Calendar.MONTH , m);
		
	}
	
	int lastDay = c.getMaximum(Calendar.DATE);
	
	int startBlank 	=0; // 1일 이전 빈 td의 개수 일요일이면 빈칸이0 ,월요일이면빈칸이 1... 토요일이면 빈칸이6 , (1일의 요일값에서 -1)
	Calendar first = Calendar.getInstance();
	first.set(Calendar.YEAR, c.get(Calendar.YEAR));
	first.set(Calendar.MONTH, c.get(Calendar.MONTH));
	first.set(Calendar.DATE ,1);
	startBlank = first.get(Calendar.DAY_OF_WEEK) -1;
	
	int endBlank = 7 - (startBlank+lastDay)%7; // 마지막 날짜 이후 빈 td의 개수
	if(endBlank==7){ // end블랭크가 7일때 한줄 더 나와서 7일때는 0 으로 초기화시켜줌.
		endBlank=0;
	}
			Class.forName("org.mariadb.jdbc.Driver");
			out.print("드라이버 로딩 성공");
			Connection conn = null;
			conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/blog","root","1234");
			out.print(conn);
	/*
	SELECT *
	FROM diary
	WHERE YEAR(diary_date) = ? AND MONTH(diary_date) = ?
	ORDER BY diary_date DESC;	
	*/
	String sql = "SELECT diary_no diaryNo , diary_date diaryDate , diary_todo diaryTodo FROM diary WHERE YEAR(diary_date) = ? AND MONTH(diary_date) = ? ORDER BY diary_date DESC";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, c.get(Calendar.YEAR));
	stmt.setInt(2, c.get(Calendar.MONTH)+1);
	ResultSet rs = stmt.executeQuery();
	// 특수한 환경의 타입 diray 테이블의 ResultSet -> 자바를사용하는 모든곳에서 사용할 수 있도록 .. ArrayList<Diary>
	ArrayList<Diary> list = new ArrayList<Diary>();
	while(rs.next()){
		Diary d = new Diary();
		d.diaryNo = rs.getInt("diaryNo");
		d.diaryDate = rs.getString("diaryDate");
		d.diaryTodo = rs.getString("diaryTodo");
		list.add(d);
	}
	System.out.print(list);
	
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

	<div>
		
 		<a href="./diary.jsp?y=<%=c.get(Calendar.YEAR)%>&m=<%=c.get(Calendar.MONTH)-1%>" class="btn btn-outline-success" >이전달</a>
      	<span><%=c.get(Calendar.YEAR)%>년 <%=c.get(Calendar.MONTH)+1%>월</span>
      	<a href="./diary.jsp?y=<%=c.get(Calendar.YEAR)%>&m=<%=c.get(Calendar.MONTH)+1%>" class="btn btn-outline-success" >다음달</a>
	</div>
	<div>startBlank : <%=startBlank%></div>

	<table border="1" width=100% style="background-color:#66ff99;">
	
	<tr style="text-align:center">
		<td>일</td>
		<td>월</td>
		<td>화</td>
		<td>수</td>
		<td>목</td>
		<td>금</td>
		<td>토</td>
	</tr>
	<tr>
		<%
			for(int i=1; i<=startBlank+lastDay+endBlank; i=i+1){
		
			if(i-startBlank < 1 ){
		%>
			<td>&nbsp;</td>
		<%
			}else if(i-startBlank > lastDay){
		%>
			<td>&nbsp;</td>
		<%		
			}else{
		%>
			<td>
				<input type="hidden" value="<%=c.get(Calendar.YEAR)%>" name="y">
				<input type="hidden" value="<%=c.get(Calendar.MONTH)%>" name="m">
				<input type="hidden" value="<%=i-startBlank%>" name="d">
				
				<a href="./insertDiary.jsp?y=<%=c.get(Calendar.YEAR)%>&m=<%=c.get(Calendar.MONTH)%>&d=<%=i-startBlank%>">
				<%=i-startBlank%>
			</a>
			<%
					for(Diary d : list){
						
						if(Integer.parseInt( d.diaryDate.substring(8) ) == i-startBlank){
				%>
					<input type="hidden" value="<%=d.diaryNo%>" name="diaryNo">
					<div><a href="./diaryOne.jsp?diaryNo=<%=d.diaryNo%>"><%=d.diaryTodo%></a></div>
				<%		
						}
					}
			%>
				</td>

		<%		
			}
			if(i%7==0){
				//i%7==0 && i!= startBlank+lastDay
		%>
				</tr><tr>
		<%		
			 }
			}
		%>
	</tr>
	</table>
<% 	
	rs.close();
	stmt.close();
	conn.close();
%>
</body>
</html>