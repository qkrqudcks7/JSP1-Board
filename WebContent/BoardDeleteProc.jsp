<%@page import="model.BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
</head>
<body>
<%
	String pass=request.getParameter("password");
	int num=Integer.parseInt(request.getParameter("num"));
	
	// DB연결
	BoardDAO b= new BoardDAO();
	String password=b.getPass(num);
	
	if(pass.equals(password)){
		b.deleteBoard(num);
		response.sendRedirect("BoardList.jsp");
	}
	else{
%>
	<script>
		alert("패스워드를 확인해요")
		history.go(-1)
	</script>
<%		
	}
%>

</body>
</html>