<%@page import="model.BoardBean"%>
<%@page import="java.util.Vector"%>
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
<!-- 게시글 보기에 카운터링 설정하기 위한 변수설정 -->
<%
	// 화면에 보여질 게시글의 개수를 지정
	int pageSize=10;
	// 현재 카운터를 클릭한 번호값을 읽어옴
	String pageNum=request.getParameter("pageNum");
	// 만약 처음 boardlist.jsp를 클릭하거나  수정,삭제 등 다른 게시글에서 이 페이지로 넘어오면
	// 페이지 넘버 값이 없기에 null처리를 해준다
	if(pageNum==null){
		pageNum="1";
	}
	int count=0; // 전체 글의 개수를 저장하는 변수
	int number=0; // 페이지 넘버링 변수
	// 현재 보고자 하는 페이지 숫자를 저장
	int currentPage=Integer.parseInt(pageNum);
	
	
	// 전체 게시글의 내용을 jsp쪽으로 가져오기
	BoardDAO b=new BoardDAO();
	// 전체 게시글의 개수를 읽어드리는 메소드 호출
	count=b.getAllCount();
	// 현재 페이지에 보여줄 시작 번호를 설정(DB에서 불러올 시작번호 의미)
	int startRow=(currentPage-1)*pageSize+1;
	int endRow=currentPage*pageSize;
	
	
	// 최신글 10개를 기준으로 전체 게시글을 리턴 받아주는 메소드 호출
	Vector<BoardBean>v=b.getAll(startRow,endRow);
	// 테이블에 표시할 번호를 지정
	number=count-(currentPage-1)*pageSize;
%>
<center>
<h2>전체 게시글 보기</h2>

<table width=700 border=1 bgcolor="skyblue">
<tr height=40>
	<td align="right" colspan="5">
	<!-- <button>말고도 이렇게 쓸 수 있음 -->
	<input type="button" value="글쓰기" onclick="location.href='BoardWrite.jsp'">
	</td>
</tr>
<tr height=40>
	<td width=50 align="center">번호</td>
	<td width=320 align="center">제목</td>
	<td width=100 align="center">작성자</td>
	<td width=150 align="center">작성일</td>
	<td width=70 align="center">조회수</td>
</tr>
<%
	for(int i=0;i<v.size();i++){
		BoardBean bean=v.get(i);	
%>
<tr height=40>
	<!-- 번호는 pk니깐 쉽게 표현  -->
	<td width=50 align="center"><%=number-- %></td>
	<!-- pk인 num을 넘겨준다 --> <!-- 들여쓰기 추가 해야되니깐 left로  -->
	<td width=320 align="left">
	<a href="BoardInfo.jsp?num=<%=bean.getNum()%>" style="text-decoration:none">
	<%

		if(bean.getRe_step()>1){
			// 5칸씩
			for(int j=0;j<(bean.getRe_step()-1)*5;j++){
	%>&nbsp;
	<%			
			}
		}
	%>
	
	<%=bean.getSubject() %></a></td>
	<td width=100 align="center"><%=bean.getWriter() %></td>
	<td width=150 align="center"><%=bean.getReg_date() %></td>
	<td width=70 align="center"><%=bean.getReadcount() %></td>
</tr>
<%
	}
%>

</table>
<p>
<!-- 페이지 카운터링 소스를 작성 -->
<%
	if(count>0){
		// 카운터링 숫자를 얼마까집 보여줄 것인지 결정
		int pageCount=count/pageSize+(count%pageSize==0 ? 0:1);
		
		// 시작 페이지 숫자를 설정
		int startPage=1;
		
		if(currentPage % 10!=0){
			startPage=(int)(currentPage/10)*10+1; // 11부터할건지 21부터 할건지
		}
		else{
			startPage=((int)(currentPage/10)-1)*10+1;
		}
		
		// 카운터링 처리 숫자
		int pageBlock=10;
		// 화면에 보여질 페이지의 마지막 숫자
		int endPage=startPage+pageBlock-1;
		
		if(endPage > pageCount){
			endPage=pageCount;
		}
		// 이전 이라는 링크를 만들건지 파악
		if(startPage>10){
%>
			<a href="BoardList.jsp?pageNum=<%=startPage-10%>">[이전]</a>
<%
		}
		// 페이징 처리
		for(int i=startPage;i<=endPage;i++){
%>
			<a href="BoardList.jsp?pageNum=<%=i%>">[<%=i %>]</a>
<%			
		}
		// 다음 이라는 링크를 만들건지 파악
		if(endPage<pageCount){
%>
			<a href="BoardList.jsp?pageNum=<%=startPage+10%>">[다음]</a>
<%			
		}
	}
%>
</center>
</body>
</html>