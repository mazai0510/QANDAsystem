import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class Login extends HttpServlet {

    public void doPost(HttpServletRequest hreq,
		       HttpServletResponse hres)
	throws ServletException, IOException { 

	// リクエストパラメータの文字エンコーディング指定	
	hreq.setCharacterEncoding("utf-8");
	// コンテント種類の指定
	hres.setContentType("text/html;charset=utf-8");
	// 出力用PrintWriterの参照を取得
	PrintWriter out = hres.getWriter();

	String username = hreq.getParameter("Name");
	String password = hreq.getParameter("Password");

	// HTMLテキストの出力
	/* htmlとhead ここから
	   ------------------------------------------------------------- */
	out.println("<html><head><meta http-equiv=\"Pragma\" content=\"no-cache\">");
	out.println("<meta http-equiv=\"Expires\" content=\"-1\">");
	out.println("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");

	out.println(" <link rel=\"stylesheet\" href=\"../css/common.css\">" );         /* css ファイルの読み込み */

	out.println("<title>ログイン</title></head>");
	/* head ここまで
	   ------------------------------------------------------------- */
	
	out.println("<body>");
	/* body ここから
	   ------------------------------------------------------------- */
	out.println("<header>");   /* header ここから ------------------  */
	
	
	int cntUsr = -1; 
	Connection db = null;
	try {
	    // JDBC ドライバのロード
	    Class.forName("org.gjt.mm.mysql.Driver");
	    // データベースとの結合
	    db = DriverManager.getConnection("jdbc:mysql://localhost/QANDA_db?user=chef&password=secret&useUnicode=true&characterEncoding=utf-8");

	    // Statement オブジェクトの生成
	    Statement st = db.createStatement();
	    String query = "select *,count(*) as cnt from user_tbl where NAME='" + username + "' AND PASS='" + password + "'";
	    ResultSet rs = st.executeQuery(query);
	    

	    rs.next();
	    if (rs.getInt("cnt") == 1) {
		
		//session
		HttpSession session = hreq.getSession(true);
		session.setAttribute("login", true);
		session.setAttribute("id", rs.getInt("USERID"));
		session.setAttribute("name", rs.getString("NAME"));

		//Mypageにリダイレクト
		 
		hres.sendRedirect("../../mypage/Mypage.jsp");
		out.println("</header><main>");     /* header ここまで, mainここから --------------------------  */
		
	 

		// 存在しないアカウントの場合
	    }else{
		hreq.setAttribute("err", true);
		out.println("<h1>KIT解決</h1>");
		out.println("</header><main>");     /* header ここまで, mainここから --------------------------  */

		out.println("<h1>ログイン失敗</h1>");
		out.println("ユーザ名とパスワードが一致しません。<br>");
		out.println("<button type=“button” onclick=\"location.href='../Login.html'\">ログイン画面へ</button>");
	    }	





	    rs.close();
	    st.close();
	    db.close();
	} catch(SQLException e) {
	    // sqlの構文エラー
	    hres.sendRedirect("../errdd.html");
	} catch(Exception e){
	    // sql以外の例外
	    e.printStackTrace();
	    hres.sendRedirect("../error.html");
	} finally{
	    try {
		db.close();
	    } catch(Exception e){}
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