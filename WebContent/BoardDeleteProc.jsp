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
	
	// DB����
	BoardDAO b= new BoardDAO();
	String password=b.getPass(num);
	
	if(pass.equals(password)){
		b.deleteBoard(num);
		response.sendRedirect("BoardList.jsp");
	}
	else{
%>
	<script>
		alert("�н����带 Ȯ���ؿ�")
		history.go(-1)
	</script>
<%		
	}
%>

</body>
</html>