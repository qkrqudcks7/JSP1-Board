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
<%	
	// String num을 int num으로 변경
	int num=Integer.parseInt(request.getParameter("num").trim());//trim은 혹시 모르니 공백제거

	// DB접근
	BoardDAO b= new BoardDAO();
	BoardBean bean=b.getOneBoard(num);
%>
<center>
<h2>게시글 보기</h2>
<table width=600 border=1 bgcolor="skyblue">
<tr height=40>
	<td align="center" width=120>글번호</td>
	<td align="center" width=180><%=bean.getNum() %></td>
	<td align="center" width=120>조회수</td>
	<td align="center" width=180><%=bean.getReadcount() %></td>
</tr>
<tr height=40>
	<td align="center" width=120>작성자</td>
	<td align="center" width=180><%=bean.getWriter() %></td>
	<td align="center" width=120>작성일</td>
	<td align="center" width=180><%=bean.getReg_date() %></td>
</tr>
<tr height=40>
	<td align="center" width=120>이메일</td>
	<td align="center" colspan="3"><%=bean.getEmail() %></td>
</tr>
<tr height=40>
	<td align="center" width=120>제목</td>
	<td align="center" colspan="3"><%=bean.getSubject() %></td>
</tr>
<tr height=100>
	<td align="center" width=120>글 내용</td>
	<td align="center" colspan="3"><%=bean.getContent() %></td>
</tr>
<tr height=40>
	<td align="center" colspan="4">
															<!--ref re_step 등등 다 기억하고 넘겨줘야 되므로  --> <!-- 근데 꼭 이렇게 get방식으로 안 해도 되고 다음 페이지에서 받아와도 됨  -->
	<input type="button" value="답글쓰기" onclick="location.href='BoardReWrite.jsp?num=<%=bean.getNum()%>&ref=<%=bean.getRef()%>&re_step=<%=bean.getRe_step()%>&re_level=<%=bean.getRe_level()%>'">
	<input type="button" value="수정하기" onclick="location.href='BoardUpdate.jsp?num=<%=bean.getNum()%>'">
	<input type="button" value="삭제하기" onclick="location.href='BoardDelete.jsp?num=<%=bean.getNum()%>'">
	<input type="button" value="목록보기" onclick="location.href='BoardList.jsp'">
	</td>
	
</tr>
</table>
</center>
</body>
</html>