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
	<jsp:useBean id="mybean" class="model.BoardBean">
		<jsp:setProperty name="mybean" property="*" />
	</jsp:useBean>
<%
	// DB�� ����
	BoardDAO b= new BoardDAO();
	// �ش� �Խñ��� �н����尪�� ����
	String pass=b.getPass(mybean.getNum());
	// ����  �н������ update �н����� ��
	if(pass.equals(mybean.getPassword())){
		//������ ���� �޼ҵ� ȣ��
		b.updateBoard(mybean);
		// ������ �Ϸ�Ǹ�  ��ü �Խñ� ����
		response.sendRedirect("BoardList.jsp");
	}
	else{
%>
	<script>
		alert("�н����尡 ��ġ���� �ʽ��ϴ�.")
		history.go(-1)
	</script>
<%		
	}
%>
</body>
</html>