// 
// DbSvlSmpl2.java
// 

// 必要なパッケージの指定
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

// 
public class QANDA1 extends HttpServlet {
// SvlSmpl1::doGet()
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
		String strId = hreq.getParameter("textData");
		String strTag = hreq.getParameter("Tag");
		// HTMLテキストの出力
		out.println("<html><head><meta http-equiv=\"Pragma\" content=\"no-cache\">");
		out.println("<meta http-equiv=\"Expires\" content=\"-1\">");
		out.println("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
		// ここまでは以降もそのまま使う
		if(strId.equals("") || strTag.equals("")) {
			out.println("未入力の項目がありますので，登録できません．");
		}
		else{
			out.println("<title>質問の表示</title></head>");
			Connection db = null;
			try {
				// JDBC ドライバのロード
				Class.forName("org.gjt.mm.mysql.Driver");
				// データベースとの結合
				db = DriverManager.getConnection("jdbc:mysql://localhost/student_db?user=chef&password=secret&useUnicode=true&characterEncoding=utf-8");

				// Statement オブジェクトの生成
				Statement st = db.createStatement();
				// SQL 文を query に格納
				if(!(strId == null || strId.isEmpty())){
				    String query = "select QUEID,CON,TAG from questions_tbl where CON like \"%"+ strId +"%\";";
				    ResultSet rs = st.executeQuery(query);
				    
				    	out.println("<h1>質問の表示</h1>");
					out.println("<form action=\"QANDA2.jsp\">");
					out.println("<table border=\"1\">");
					out.println("<tr><td>内容</td><td>タグ</td><tr>");
					
					while(rs.next()){
					    out.print("<tr>" + "<td>"
						      + "<input type=\"hidden\" name=queid value=\""
						      + rs.getInt("QUEID")
						      + "\"> <input type=\"submit\" value=\""
						      + rs.getString("CON")
						      + "\"> </td>" + "<td>"
						      + rs.getString("TAG")
						      + "</td>" + "<tr>");
					}
					rs.close();
				}else{
				    String query1 = "select QUEID,CON,TAG from questions_tbl where TAG like \"%"+ strTag +"%\";";
				    ResultSet rs1 = st.executeQuery(query1);

				    out.println("<h1>質問の表示</h1>");
				    out.println("<form action=\"QANDA2.jsp\">");
				    out.println("<table border=\"1\">");
				    out.println("<tr><td>内容</td><td>タグ</td><tr>");
				    
				    while(rs1.next()){
					out.print("<tr>" + "<td>"
						  + "<input type=\"hidden\" name=queid value=\""
						  + rs1.getInt("QUEID")
						  + "\"> <input type=\"submit\" value=\""
						  + rs1.getString("CON")
						  + "\"> </td>" + "<td>"
						  + rs1.getString("TAG")
						  + "</td>" + "<tr>");
				    }
				    rs1.close();
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
		out.println("</table></form></body></html>");
	}
}
