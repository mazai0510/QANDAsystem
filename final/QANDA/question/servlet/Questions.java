// 
// DbSvlSmpl1.java
// 

// 必要なパッケージの指定
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import ftf.TfIdf;

// 
public class Questions extends HttpServlet {
// SvlEx2::doGet()
	public void doGet(HttpServletRequest hreq,	// リクエスト
			  HttpServletResponse hres)	// レスポンス
		throws ServletException, IOException {
		// リクエストパラメータの文字エンコーディング指定
		hreq.setCharacterEncoding("utf-8");
		// コンテント種類の指定
		hres.setContentType("text/html;charset=utf-8");
		// 出力用PrintWriterの参照を取得
		PrintWriter out = hres.getWriter();

		// パラメータの入力とチェック
		String strContents = hreq.getParameter("Contents");
		String strTag = hreq.getParameter("Tag");
		// String strUser = session.getAttribute("id");
		String strUser = hreq.getParameter("UserID");


		// HTMLテキストの出力
		out.println("<html><head><meta http-equiv=\"Pragma\" content=\"no-cache\">");
		out.println("<meta http-equiv=\"Expires\" content=\"-1\">");
		out.println("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
		// ここまでは以降もそのまま使う
		if(strContents.equals("") || strTag.equals("")) {
		    out.println("未入力の項目がありますので，登録できません．");
		    out.println("<button type=“button” onclick=\"location.href='../Question.jsp'\">質問入力画面へ</button>");
		}
		else {
			out.println("<title>質問の投稿</title></head><body>");
			Connection db = null;
			try {
				// JDBC ドライバのロード
				Class.forName("org.gjt.mm.mysql.Driver");
				// データベースとの結合
				db = DriverManager.getConnection("jdbc:mysql://localhost/QANDA_db?user=chef&password=secret&useUnicode=true&characterEncoding=utf-8");

				
				// Statement オブジェクトの生成
				Statement st = db.createStatement();

				// 一番目の質問ID
				String FirstQuestionID_check = "select * from questions_tbl where QUEID=1";
				ResultSet firstQuestion_check = st.executeQuery(FirstQuestionID_check);
				firstQuestion_check.last();
				int row_count = firstQuestion_check.getRow();

				//SQL 文
				String query;
				int code = 0;
				// QUEID が "1" の質問がすでに存在していたら
				if(row_count != 0){
				    // 1より大きくてかつ使われていない質問IDを検索する
				    String StrQuestionID = "select min(QUEID+1) from questions_tbl where (QUEID+1) not in(select QUEID from questions_tbl)";
				    // ResultSet の中身は表のようなデータ
				    ResultSet num2 = st.executeQuery(StrQuestionID);
				    while(num2.next()){
					// カラム名を指定して、値をとってくる
					code = num2.getInt("min(QUEID+1)");
					//out.println(code);
				    }
				    
				    
				    
				    


				    // SQL 文を query に格納
				    query = "insert into questions_tbl set QUEID='" + code + "', CON='" + strContents + "', TAG='" + strTag + "',USERID= " + strUser;
				}
				// QUEID が "1" の質問がなければ
				else{
				    // out.println("1番を追加");
				    // QUEIDを"1"としてSQL 文を query に格納
				    query = "insert into questions_tbl set QUEID='" + "1" + "', CON='" + strContents + "', TAG='" + strTag + "',USERID= " + strUser ;
				}

				// SQL 文を実行し挿入した数が返る
				int num = st.executeUpdate(query);
				if(num > 0) {
					out.println("データが登録されました．");
					out.println("<button type=“button” onclick=\"location.href='../../mypage/Mypage.jsp'\">マイページへ</button>");
					// out.println(strUser);
				}
				else {
					out.println("データが登録されませんでした．");
					out.println("<button type=“button” onclick=\"location.href='../Mypage.jsp'\">マイページへ</button>");
				}
				// Statement, データベースを順にクローズ
				st.close();
				db.close();
				//類似質問検索
				TfIdf tfidf = new TfIdf();
				int i = 1;
				i = tfidf.searchSimQuestion(code, strContents);
				out.println(i);
				
				db = DriverManager.getConnection("jdbc:mysql://localhost/QANDA_db?user=chef&password=secret&useUnicode=true&characterEncoding=utf-8");
				st = db.createStatement();
				query = "select * from questions_tbl where QUEID='"+ i + "'";
				ResultSet rs = st.executeQuery(query);
				out.println("<table border='1'>");
				out.println("<tr><td>内容</td><td>質問番号</td></tr>");
				 
				while(rs.next()){
				out.println("<tr>" + "<td>"
					     + rs.getString("CON")
					     + "</td>" + "<td>"
					     + rs.getInt("QUEID")
					     + "</td>" + "</tr>");
					     
				}
				out.println("</table>");
				 rs.close();
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
