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
	request.setCharacterEncoding("EUC-KR");
%>
<!-- ������ �� ���� �޾ƿ��� bean Ŭ���� ���  -->
	<jsp:useBean id="mybean" class="model.BoardBean">
		<jsp:setProperty name="mybean" property="*" />
	</jsp:useBean>
<%
	// DB��ü ����
	BoardDAO b= new BoardDAO();
	b.reWriteBoard(mybean);
	
	// �亯 �����͸� ��� ���� �� ��ü �Խñ� ���⸦ ����
	response.sendRedirect("BoardList.jsp");
%>
</body>
</html>