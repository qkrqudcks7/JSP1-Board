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
<!-- 데이터 한 번에 받아오는 bean 클래스 사용  -->
	<jsp:useBean id="mybean" class="model.BoardBean">
		<jsp:setProperty name="mybean" property="*" />
	</jsp:useBean>
<%
	// DB객체 생성
	BoardDAO b= new BoardDAO();
	b.reWriteBoard(mybean);
	
	// 답변 데이터를 모두 저장 후 전체 게시글 보기를 설정
	response.sendRedirect("BoardList.jsp");
%>
</body>
</html>