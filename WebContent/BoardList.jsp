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
<!-- �Խñ� ���⿡ ī���͸� �����ϱ� ���� �������� -->
<%
	// ȭ�鿡 ������ �Խñ��� ������ ����
	int pageSize=10;
	// ���� ī���͸� Ŭ���� ��ȣ���� �о��
	String pageNum=request.getParameter("pageNum");
	// ���� ó�� boardlist.jsp�� Ŭ���ϰų�  ����,���� �� �ٸ� �Խñۿ��� �� �������� �Ѿ����
	// ������ �ѹ� ���� ���⿡ nulló���� ���ش�
	if(pageNum==null){
		pageNum="1";
	}
	int count=0; // ��ü ���� ������ �����ϴ� ����
	int number=0; // ������ �ѹ��� ����
	// ���� ������ �ϴ� ������ ���ڸ� ����
	int currentPage=Integer.parseInt(pageNum);
	
	
	// ��ü �Խñ��� ������ jsp������ ��������
	BoardDAO b=new BoardDAO();
	// ��ü �Խñ��� ������ �о�帮�� �޼ҵ� ȣ��
	count=b.getAllCount();
	// ���� �������� ������ ���� ��ȣ�� ����(DB���� �ҷ��� ���۹�ȣ �ǹ�)
	int startRow=(currentPage-1)*pageSize+1;
	int endRow=currentPage*pageSize;
	
	
	// �ֽű� 10���� �������� ��ü �Խñ��� ���� �޾��ִ� �޼ҵ� ȣ��
	Vector<BoardBean>v=b.getAll(startRow,endRow);
	// ���̺� ǥ���� ��ȣ�� ����
	number=count-(currentPage-1)*pageSize;
%>
<center>
<h2>��ü �Խñ� ����</h2>

<table width=700 border=1 bgcolor="skyblue">
<tr height=40>
	<td align="right" colspan="5">
	<!-- <button>���� �̷��� �� �� ���� -->
	<input type="button" value="�۾���" onclick="location.href='BoardWrite.jsp'">
	</td>
</tr>
<tr height=40>
	<td width=50 align="center">��ȣ</td>
	<td width=320 align="center">����</td>
	<td width=100 align="center">�ۼ���</td>
	<td width=150 align="center">�ۼ���</td>
	<td width=70 align="center">��ȸ��</td>
</tr>
<%
	for(int i=0;i<v.size();i++){
		BoardBean bean=v.get(i);	
%>
<tr height=40>
	<!-- ��ȣ�� pk�ϱ� ���� ǥ��  -->
	<td width=50 align="center"><%=number-- %></td>
	<!-- pk�� num�� �Ѱ��ش� --> <!-- �鿩���� �߰� �ؾߵǴϱ� left��  -->
	<td width=320 align="left">
	<a href="BoardInfo.jsp?num=<%=bean.getNum()%>" style="text-decoration:none">
	<%

		if(bean.getRe_step()>1){
			// 5ĭ��
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
<!-- ������ ī���͸� �ҽ��� �ۼ� -->
<%
	if(count>0){
		// ī���͸� ���ڸ� �󸶱��� ������ ������ ����
		int pageCount=count/pageSize+(count%pageSize==0 ? 0:1);
		
		// ���� ������ ���ڸ� ����
		int startPage=1;
		
		if(currentPage % 10!=0){
			startPage=(int)(currentPage/10)*10+1; // 11�����Ұ��� 21���� �Ұ���
		}
		else{
			startPage=((int)(currentPage/10)-1)*10+1;
		}
		
		// ī���͸� ó�� ����
		int pageBlock=10;
		// ȭ�鿡 ������ �������� ������ ����
		int endPage=startPage+pageBlock-1;
		
		if(endPage > pageCount){
			endPage=pageCount;
		}
		// ���� �̶�� ��ũ�� ������� �ľ�
		if(startPage>10){
%>
			<a href="BoardList.jsp?pageNum=<%=startPage-10%>">[����]</a>
<%
		}
		// ����¡ ó��
		for(int i=startPage;i<=endPage;i++){
%>
			<a href="BoardList.jsp?pageNum=<%=i%>">[<%=i %>]</a>
<%			
		}
		// ���� �̶�� ��ũ�� ������� �ľ�
		if(endPage<pageCount){
%>
			<a href="BoardList.jsp?pageNum=<%=startPage+10%>">[����]</a>
<%			
		}
	}
%>
</center>
</body>
</html>