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
	
	// DB�� Ŀ�ؼ�Ǯ�� ����ϵ��� �����ϴ� �޼ҵ�
	
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
	// �ϳ��� ���ο� �Խù��� �Ѿ�ͼ� ����Ǵ� �޼ҵ�
	public void insertBoard(BoardBean bean) {
		getC();
		
		int ref=0; // �� �׷��� �ǹ�= ������ ������Ѽ� ���� ū ref���� ������ ��, ���⿡ +1�� �Ѵ�
		int re_step=1; // �� ���̱⿡= �θ�� �̱⿡
		int re_level=1;
		
		try {
			// ���� ū ref���� �о���� ���� �غ�
			String refsql="select max(ref) from board";
			// ���� ���� ��ü
			p=c.prepareStatement(refsql);
			// ���� ���� �� ��� ����
			r=p.executeQuery();
			if(r.next()) {
				ref=r.getInt(1)+1; // �ִ밪�� +1�� ���ؼ� �� �׷��� �����Ѵ� �ʱ�� 0�̴ϱ�
			}
			// ������ �Խñ� ��ü���� ������ ���̺� ���� , �ؿ� 0�� readcount
			String sql="insert into board values(board_seq.NEXTVAL,?,?,?,?,sysdate,?,?,?,0,?)";
			p=c.prepareStatement(sql);
			// ?�� ���� ����
			p.setString(1, bean.getWriter());
			p.setString(2, bean.getEmail());
			p.setString(3, bean.getSubject());
			p.setString(4, bean.getPassword());
			p.setInt(5, ref);
			p.setInt(6, re_step);
			p.setInt(7, re_level);
			p.setString(8, bean.getContent());
			// ������ �����Ͻÿ�
			p.executeUpdate();
			//�ڿ� �ݳ�
			c.close();
		}
		catch(Exception e) {
			e.printStackTrace();
		}	
	}
	// ��� �Խù��� �������ִ� �޼ҵ� �ۼ�
	public Vector<BoardBean> getAll(int start,int end){
		Vector<BoardBean> v=new Vector<>();
		getC();
		
		try {
			String sql="select * from (select A.* ,Rownum Rnum from (select * from board order by ref desc,re_step asc)A) where Rnum>=? and Rnum<=? ";
			p=c.prepareStatement(sql);
			p.setInt(1, start);
			p.setInt(2, end);
			r=p.executeQuery();
			//������ ������ ����� �𸣱⿡ �ݺ��� �̿�
			while(r.next()) {
				// �����͸� ��Ű¡(����=BoardBean Ŭ���� �̿�)
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
	// �ϳ��� �Խñ� ����
	public BoardBean getOneBoard(int num) {
		BoardBean bean= new BoardBean();
		getC();
		try {
			// ��ȸ�� ���� ����
			String readsql="update board set readcount = readcount+1 where num=?";
			p=c.prepareStatement(readsql);
			p.setInt(1, num);
			p.executeUpdate();
			
			// ���� �غ�
			String sql="select* from board where num=?";
			p=c.prepareStatement(sql);
			p.setInt(1, num);
			//���� ���� ��  ��� ����
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
	
	// �亯���� ����Ǵ� �޼ҵ�
	public void reWriteBoard(BoardBean bean) {
		// �θ� �� �׷�� �� ���� �� ������ �о�´�
		int ref=bean.getRef();
		int re_step=bean.getRe_step();
		int re_level=bean.getRe_level();
		
		getC();
		try {
			////////////////�ٽ� �ڵ�//////////////////////////
			// �θ�۰� ref�� ���ų�, �θ� �� ���� ū re_level�� ���� ���� 1�� ����
			String levelsql="update board set re_level = re_level+1 where ref=? and re_level > ?";
			p=c.prepareStatement(levelsql);
			p.setInt(1, ref);
			p.setInt(2, re_level);
			p.executeUpdate();
			
			// �亯�� ������ ����
			String sql="insert into board values(board_seq.NEXTVAL,?,?,?,?,sysdate,?,?,?,0,?)";
			p=c.prepareStatement(sql);
			p.setString(1, bean.getWriter());
			p.setString(2, bean.getEmail());
			p.setString(3, bean.getSubject());
			p.setString(4, bean.getPassword());
			p.setInt(5, ref); // �θ��� ref ���� �־���
			p.setInt(6, re_step+1); // ��� �̱⿡ �θ��re_step+1
			p.setInt(7, re_level+1);
			p.setString(8,bean.getContent());
			p.executeUpdate();
			c.close();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
	}
	//update , delete �ϳ��� �Խñ� ����
	public BoardBean getOneUpdateBoard(int num) {
		BoardBean bean= new BoardBean();
		getC();
		try {
			
			// ���� �غ�
			String sql="select* from board where num=?";
			p=c.prepareStatement(sql);
			p.setInt(1, num);
			//���� ���� ��  ��� ����
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
	// updatePr��c �׸��� deleteProc�� �ʿ��� �н����� ���� ����
	public String getPass(int num) {
		// ������ ���� ��ü ����
		String pass="";
		getC();
		try {
			String sql="select password from board where num=?";
			p=c.prepareStatement(sql);
			p.setInt(1, num);
			r=p.executeQuery();
			// �н����� �� ����
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
	// �ϳ��� �Խñ��� �����ϴ� �޼ҵ�
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
	// ��ü ���� ������ �����ϴ� �޼ҵ�
	public int getAllCount() {
		getC();
		// �Խñ� ��ü ���� �����ϴ� ����
		int count=0;
		try {
			String sql="select count(*) from board";
			p=c.prepareStatement(sql);
			r=p.executeQuery();
			if(r.next()) {
				count=r.getInt(1); // ��ü �Խñ� �� ����
			}
			c.close();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return count;
	}
}
