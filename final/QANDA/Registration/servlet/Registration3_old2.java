// 
// DbSvlSmpl1.java
// 

// 必要なパッケージの指定
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

// すでに使われているアカウントを登録しない かつ、0より大きくて使われていないIDを割り振るver
public class Registration3 extends HttpServlet {
// SvlEx2::doGet()

// SvlEx2::doGet()
    public void doPost(HttpServletRequest hreq,	// リクエスト
		       HttpServletResponse hres)	// レスポンス
	throws ServletException, IOException {
	// リクエストパラメータの文字エンコーディング指定
	hreq.setCharacterEncoding("utf-8");
	// コンテント種類の指定
	hres.setContentType("text/html;charset=utf-8");
	// 出力用PrintWriterの参照を取得
	PrintWriter out = hres.getWriter();

	// パラメータの入力とチェック
	String strUserName = hreq.getParameter("Name");
	String strPassword = hreq.getParameter("Password");

	// HTMLテキストの出力
	out.println("<html><head><meta http-equiv=\"Pragma\" content=\"no-cache\">");
	out.println("<meta http-equiv=\"Expires\" content=\"-1\">");
	out.println("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
	// ここまでは以降もそのまま使う
	if(strUserName.equals("") || strPassword.equals("")) {
	    out.println("未入力の項目がありますので，登録できません．");
	}
	else {
	    out.println("<title>アカウントの登録</title></head>");
	    Connection db = null;
	    try {
		// JDBC ドライバのロード
		Class.forName("org.gjt.mm.mysql.Driver");
		// データベースとの結合
		db = DriverManager.getConnection("jdbc:mysql://localhost/QANDA_db?user=chef&password=secret&useUnicode=true&characterEncoding=utf-8");

		// Statement オブジェクトの生成
		Statement st = db.createStatement();

		// データベースに同じ名前と同じパスワードのものがいないか検索する
		String query_check = "select * from user_tbl where PASS='" + strPassword + "'and NAME ='" + strUserName +"'";
		ResultSet num_check = st.executeQuery(query_check);
		num_check.last();
		int row_count = num_check.getRow();
		
		// もしselectの実行結果が空白でなければ
		if(row_count != 0){
		    out.println("そのパスワードと名前の組はすでに使われています");
		    out.println("<button type=“button” onclick=\"location.href='../Registration.html'\">アカウント作成画面へ</button>");
		}
		else{
		    // 一番目のユーザID
		    String FirstUSERID_check = "select * from user_tbl where USERID=1";
		    ResultSet firstUser_check = st.executeQuery(FirstUSERID_check);
		    firstUser_check.last();
		    int row_count2 = firstUser_check.getRow();
		    
		    //SQL 文
		    String query;

		    // USERID が "1" のユーザがすでに存在していたら
		    if(row_count2 != 0){
			// 1より大きくてかつ使われていないユーザIDを検索する
			String StrUserID = "select min(USERID+1) from user_tbl where (USERID+1) not in(select USERID from user_tbl)";
			// ResultSet の中身は表のようなデータ
			ResultSet num3 = st.executeQuery(StrUserID);
			int code=0;
			while(num3.next()){
			    // カラム名を指定して、値をとってくる
			    code = num3.getInt("min(USERID+1)");
			    // out.println(code);
			}
			// SQL 文を query に格納
			 query = "insert into user_tbl set USERID='" + code + "', PASS='" + strPassword + "', NAME='" + strUserName + "'";
		    }
		    // USERID が "1" のユーザがいなければ
		    else{
			// out.println("1番を追加");
			// USERIDを"1"としてSQL 文を query に格納
			query = "insert into user_tbl set USERID='" + "1" + "', PASS='" + strPassword + "', NAME='" + strUserName + "'";
		    }

		    // SQL 文を実行し挿入した数が返る
		    
		    int num = st.executeUpdate(query);
		    if(num > 0) {
			out.println("データが登録されました．");
			out.println("<button type=“button” onclick=\"location.href='../../login/Login.html'\">ログイン画面へ</button>");
		    }
		    else {
			out.println("データが登録されませんでした．");
			// out.println("<button type=“button” onclick="location.href='../Login.html'">ログイン画面へ</button>");
		    }  
		}

		// Statement, データベースを順にクローズ
		st.close();
		db.close();
	    } catch(SQLException e) {
		out.println("接続失敗<br>" + e.toString());
	    } catch(Exception e){
		e.printStackTrace();
	    } finally{
		try {
		    db.close();
		} catch(Exception e){}
	    }
	}
	out.println("</body></html>");
    }
}
