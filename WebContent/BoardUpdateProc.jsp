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
	// DB에 연결
	BoardDAO b= new BoardDAO();
	// 해당 게시글의 패스워드값을 얻어옴
	String pass=b.getPass(mybean.getNum());
	// 기존  패스워드랑 update 패스워드 비교
	if(pass.equals(mybean.getPassword())){
		//데이터 수정 메소드 호출
		b.updateBoard(mybean);
		// 수정이 완료되면  전체 게시글 보기
		response.sendRedirect("BoardList.jsp");
	}
	else{
%>
	<script>
		alert("패스워드가 일치하지 않습니다.")
		history.go(-1)
	</script>
<%		
	}
%>
</body>
</html>