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
		<!--�Խñ� �ۼ��� �����͸� �ѹ��� �о�帲  -->
	<jsp:useBean id="mybean" class="model.BoardBean">
		<jsp:setProperty name="mybean" property="*" />
	</jsp:useBean>
	
<%
	// DB������ �� Ŭ������ �Ѱ���
	BoardDAO b=new BoardDAO();
	// ������ ���� �޼ҵ� ȣ��
	b.insertBoard(mybean);
	// �Խñ� ���� �� ��ü �Խñ� ����
	response.sendRedirect("BoardList.jsp");
	
%>

</body>
</html>