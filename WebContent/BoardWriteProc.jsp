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
		<!--게시글 작성한 데이터를 한번에 읽어드림  -->
	<jsp:useBean id="mybean" class="model.BoardBean">
		<jsp:setProperty name="mybean" property="*" />
	</jsp:useBean>
	
<%
	// DB쪽으로 빈 클래스를 넘겨줌
	BoardDAO b=new BoardDAO();
	// 데이터 저장 메소드 호출
	b.insertBoard(mybean);
	// 게시글 저장 후 전체 게시글 보기
	response.sendRedirect("BoardList.jsp");
	
%>

</body>
</html>