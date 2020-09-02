package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Vector;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class BoardDAO {
	
	Connection c;
	PreparedStatement p;
	ResultSet r;
	
	// DB의 커넥션풀을 사용하도록 설정하는 메소드
	
	public void getC() {
		try {
			Context initctx=new InitialContext();
			Context envctx=(Context) initctx.lookup("java:comp/env");
			DataSource ds=(DataSource) envctx.lookup("jdbc/pool");
			c=ds.getConnection();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
	}
	// 하나의 새로운 게시물이 넘어와서 저장되는 메소드
	public void insertBoard(BoardBean bean) {
		getC();
		
		int ref=0; // 글 그룹을 의미= 쿼리를 실행시켜서 가장 큰 ref값을 가져온 후, 여기에 +1을 한다
		int re_step=1; // 새 글이기에= 부모글 이기에
		int re_level=1;
		
		try {
			// 가장 큰 ref값을 읽어오는 쿼리 준비
			String refsql="select max(ref) from board";
			// 쿼리 실행 객체
			p=c.prepareStatement(refsql);
			// 쿼리 실행 후 결과 리턴
			r=p.executeQuery();
			if(r.next()) {
				ref=r.getInt(1)+1; // 최대값에 +1을 더해서 글 그룹을 설정한다 초기는 0이니깐
			}
			// 실제로 게시글 전체값을 데이터 테이블에 저장 , 밑에 0은 readcount
			String sql="insert into board values(board_seq.NEXTVAL,?,?,?,?,sysdate,?,?,?,0,?)";
			p=c.prepareStatement(sql);
			// ?에 값을 맵핑
			p.setString(1, bean.getWriter());
			p.setString(2, bean.getEmail());
			p.setString(3, bean.getSubject());
			p.setString(4, bean.getPassword());
			p.setInt(5, ref);
			p.setInt(6, re_step);
			p.setInt(7, re_level);
			p.setString(8, bean.getContent());
			// 쿼리를 실행하시오
			p.executeUpdate();
			//자원 반납
			c.close();
		}
		catch(Exception e) {
			e.printStackTrace();
		}	
	}
	// 모든 게시물을 리턴해주는 메소드 작성
	public Vector<BoardBean> getAll(int start,int end){
		Vector<BoardBean> v=new Vector<>();
		getC();
		
		try {
			String sql="select * from (select A.* ,Rownum Rnum from (select * from board order by ref desc,re_step asc)A) where Rnum>=? and Rnum<=? ";
			p=c.prepareStatement(sql);
			p.setInt(1, start);
			p.setInt(2, end);
			r=p.executeQuery();
			//데이터 개수가 몇개인지 모르기에 반복문 이용
			while(r.next()) {
				// 데이터를 패키징(가방=BoardBean 클래스 이용)
				BoardBean bean=new BoardBean();
				bean.setNum(r.getInt(1));
				bean.setWriter(r.getString(2));
				bean.setEmail(r.getString(3));
				bean.setSubject(r.getString(4));
				bean.setPassword(r.getString(5));
				bean.setReg_date(r.getDate(6).toString());
				bean.setRef(r.getInt(7));
				bean.setRe_step(r.getInt(8));
				bean.setRe_level(r.getInt(9));
				bean.setReadcount(r.getInt(10));
				bean.setContent(r.getString(11));
				v.add(bean);
			}
			c.close();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return v;
	}
	// 하나의 게시글 리턴
	public BoardBean getOneBoard(int num) {
		BoardBean bean= new BoardBean();
		getC();
		try {
			// 조회수 증가 쿼리
			String readsql="update board set readcount = readcount+1 where num=?";
			p=c.prepareStatement(readsql);
			p.setInt(1, num);
			p.executeUpdate();
			
			// 쿼리 준비
			String sql="select* from board where num=?";
			p=c.prepareStatement(sql);
			p.setInt(1, num);
			//쿼리 실행 후  결과 리턴
			r=p.executeQuery();
			if(r.next()) {
				bean.setNum(r.getInt(1));
				bean.setWriter(r.getString(2));
				bean.setEmail(r.getString(3));
				bean.setSubject(r.getString(4));
				bean.setPassword(r.getString(5));
				bean.setReg_date(r.getDate(6).toString());
				bean.setRef(r.getInt(7));
				bean.setRe_step(r.getInt(8));
				bean.setRe_level(r.getInt(9));
				bean.setReadcount(r.getInt(10));
				bean.setContent(r.getString(11));
			}
			c.close();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return bean;
	}
	
	// 답변글이 저장되는 메소드
	public void reWriteBoard(BoardBean bean) {
		// 부모 글 그룹과 글 레벨 글 스텝을 읽어온다
		int ref=bean.getRef();
		int re_step=bean.getRe_step();
		int re_level=bean.getRe_level();
		
		getC();
		try {
			////////////////핵심 코드//////////////////////////
			// 부모글과 ref가 같거나, 부모 글 보다 큰 re_level의 값을 전부 1씩 증가
			String levelsql="update board set re_level = re_level+1 where ref=? and re_level > ?";
			p=c.prepareStatement(levelsql);
			p.setInt(1, ref);
			p.setInt(2, re_level);
			p.executeUpdate();
			
			// 답변글 데이터 저장
			String sql="insert into board values(board_seq.NEXTVAL,?,?,?,?,sysdate,?,?,?,0,?)";
			p=c.prepareStatement(sql);
			p.setString(1, bean.getWriter());
			p.setString(2, bean.getEmail());
			p.setString(3, bean.getSubject());
			p.setString(4, bean.getPassword());
			p.setInt(5, ref); // 부모의 ref 값을 넣어줌
			p.setInt(6, re_step+1); // 답글 이기에 부모글re_step+1
			p.setInt(7, re_level+1);
			p.setString(8,bean.getContent());
			p.executeUpdate();
			c.close();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
	}
	//update , delete 하나의 게시글 리턴
	public BoardBean getOneUpdateBoard(int num) {
		BoardBean bean= new BoardBean();
		getC();
		try {
			
			// 쿼리 준비
			String sql="select* from board where num=?";
			p=c.prepareStatement(sql);
			p.setInt(1, num);
			//쿼리 실행 후  결과 리턴
			r=p.executeQuery();
			if(r.next()) {
				bean.setNum(r.getInt(1));
				bean.setWriter(r.getString(2));
				bean.setEmail(r.getString(3));
				bean.setSubject(r.getString(4));
				bean.setPassword(r.getString(5));
				bean.setReg_date(r.getDate(6).toString());
				bean.setRef(r.getInt(7));
				bean.setRe_step(r.getInt(8));
				bean.setRe_level(r.getInt(9));
				bean.setReadcount(r.getInt(10));
				bean.setContent(r.getString(11));
			}
			c.close();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return bean;
	}
	// updatePrㅐc 그리고 deleteProc에 필요한 패스워드 값을 리턴
	public String getPass(int num) {
		// 리턴할 변수 객체 선언
		String pass="";
		getC();
		try {
			String sql="select password from board where num=?";
			p=c.prepareStatement(sql);
			p.setInt(1, num);
			r=p.executeQuery();
			// 패스워드 값 저장
			if(r.next()) {
				pass=r.getString(1);
			}
			c.close();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return pass;
	}
	// 하나의 게시글을 수정하는 메소드
	public void updateBoard(BoardBean bean) {
		getC();
		try {
			String sql="update board set subject=?,content=? where num=?";
			p=c.prepareStatement(sql);
			p.setString(1, bean.getSubject());
			p.setString(2, bean.getContent());
			p.setInt(3, bean.getNum());
			p.executeUpdate();
			c.close();
			
		}
		catch(Exception e) {
			e.printStackTrace();
		}
	}
	public void deleteBoard(int num) {
		getC();
		try {
			String sql="delete from board where num=?";
			p=c.prepareStatement(sql);
			p.setInt(1, num);
			p.executeUpdate();
			c.close();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
	}
	// 전체 글의 개수를 리턴하는 메소드
	public int getAllCount() {
		getC();
		// 게시글 전체 수를 저장하는 변수
		int count=0;
		try {
			String sql="select count(*) from board";
			p=c.prepareStatement(sql);
			r=p.executeQuery();
			if(r.next()) {
				count=r.getInt(1); // 전체 게시글 수 리턴
			}
			c.close();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return count;
	}
}
