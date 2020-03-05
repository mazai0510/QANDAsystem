// 
// DbSvlSmpl1.java
// 

// 必要なパッケージの指定
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

// 
public class DeleteQuestion extends HttpServlet {
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
		String strDeleteQuestionID = hreq.getParameter("DeleteQuestionID");
		String strUser = hreq.getParameter("UserID");

		// HTMLテキストの出力
		out.println("<html><head><meta http-equiv=\"Pragma\" content=\"no-cache\">");
		out.println("<meta http-equiv=\"Expires\" content=\"-1\">");
		out.println("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");

		out.println(" <link rel=\"stylesheet\" href=\"../css/common.css\">" );         /* css ファイルの読み込み */
		
		out.println("<title>質問の削除</title></head>");
		/* head ここまで
		   ------------------------------------------------------------- */
		
		out.println("<body>");
		/* body ここから
		   ------------------------------------------------------------- */
		out.println("<header>");   /* header ここから ------------------  */
		
		// ここまでは以降もそのまま使う
		if(strDeleteQuestionID.equals("")) {
		    out.println("<h1><a href=\"../../mypage/Mypage.jsp\">KIT解決</a></h1>");
		    out.println("<button type=“button” onclick=\"location.href='../../login/Login.html'\">ログアウト</button>");
		    out.println("</header><main>");     /* header ここまで, mainここから --------------------------  */
		    out.println("<h1>質問の削除失敗</h1>");
		    out.println("削除する質問のIDを入力してください <br>");
		    out.println("<button type=“button” onclick=\"location.href='../MYQUE.jsp'\">質問一覧へ戻る</button>");
		}
		else {
			Connection db = null;
			try {
				// JDBC ドライバのロード
				Class.forName("org.gjt.mm.mysql.Driver");
				// データベースとの結合
				db = DriverManager.getConnection("jdbc:mysql://localhost/QANDA_db?user=chef&password=secret&useUnicode=true&characterEncoding=utf-8");

				
				// Statement オブジェクトの生成
				Statement st = db.createStatement();
				// SQL 文を query に格納
				String query = "delete from questions_tbl where QUEID ='"+ strDeleteQuestionID + "' AND USERID ='"+ strUser+"'";

				// SQL 文を実行し挿入した数が返る
				int num = st.executeUpdate(query);
				if(num > 0) {
				    out.println("<h1><a href=\"../../mypage/Mypage.jsp\">KIT解決</a></h1>");
				    out.println("<button type=“button” onclick=\"location.href='../../login/Login.html'\">ログアウト</button>");
				    out.println("</header><main>");         /* header ここまで, mainここから -------------------------------  */
				    out.println("<h1>質問の削除完了</h1>");
				    out.println("質問が削除されました．");
				    out.println("<button type=“button” onclick=\"location.href='../MYQUE.jsp'\">質問一覧へ戻る</button>");
				}
				else {
				    out.println("<h1><a href=\"../../mypage/Mypage.jsp\">KIT解決</a></h1>");;
				    out.println("<button type=“button” onclick=\"location.href='../../login/Login.html'\">ログアウト</button>");
				    out.println("</header><main>");         /* header ここまで, mainここから -------------------------------  */
				    out.println("<h1>質問削除エラー</h1>");
				    out.println("質問IDが不適切です.");
				    out.println("<button type=“button” onclick=\"location.href='../MYQUE.jsp'\">質問一覧へ戻る</button>");
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
	    out.println("</main>");  /* main ここまで ----------------------------------  */

	    /* footer ----------------------------------  */
	    out.println("<footer>");
	    out.println("関連リンクなど");
	    out.println("</footer>");

	    out.println("</body></html>");
	/* body, html ここまで
	   ------------------------------------------------------------- */
	}
}
