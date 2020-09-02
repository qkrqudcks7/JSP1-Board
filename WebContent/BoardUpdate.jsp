<%@page import="model.BoardBean"%>
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
<center>
<h2>게시글 수정</h2>
<%
	// 해당 게시글 번호를 통해서 게시글을 수정
	int num=Integer.parseInt(request.getParameter("num").trim());
	// 하나의 게시글에 대한 정보를 리턴받는다
	BoardDAO b=new BoardDAO();
	BoardBean bean=b.getOneUpdateBoard(num);
%>
<form action="BoardUpdateProc.jsp" method="post">
<table width=600 border=1 bgcolor="skyblue">
<tr height=40>
	<td width=120 align="center">작성자</td>
	<td width=180 align="center"><%=bean.getWriter() %></td>
	<td width=120 align="center">작성일</td>
	<td width=180 align="center"><%=bean.getReg_date() %></td>
</tr>
<tr height=40>
	<td width=120 align="center">제목</td>
	<td width=480 colspan="3">&nbsp;
	<input type="text" name="subject" value="<%=bean.getSubject() %>" size=60>
	</td>
</tr>
<tr height=40>
	<td width=120 align="center">패스워드</td>
	<td width=480 colspan="3">&nbsp;
	<input type="password" name="password" size=60>
	</td>
</tr>
<tr height=40>
	<td width=120 align="center">글 내용</td>
	<td width=480 colspan="3">&nbsp;
	<textarea rows=10 cols=60 name="content" align="left"><%=bean.getContent() %></textarea>
	</td>
</tr>
<tr height=40>
	<td colspan="4" align="center">
	<input type="hidden" name="num" value="<%=bean.getNum() %>">
	<input type="submit"value="글 수정">&nbsp;&nbsp;
	<input type="button" onclick="location.href='BoardList.jsp'" value="전체 설정 보기">
</table>
</form>
</center>
</body>
</html>