<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" import="java.sql.*" %> 

<html>
  <head>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="-1">
    <META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=utf-8">
    <title>質問一覧</title>
    <link rel="stylesheet" href="css/common.css">
  </head>
  <body>
    <header>
      <h1><a href="../mypage/Mypage.jsp">KIT解決</a></h1>
      <button type=“button” onclick="location.href='../login/Login.html'">ログアウト</button>
    </header>
    <main> 
      <h1>あなたの質問</h1>
      <p>投稿した質問の一覧です。</p>
      <p>質問の内容をクリックすると詳細を確認できます。</p>
    <%-- この範囲はjspのコメント  -->
    <%-- 
    	 ユーザID: <%= session.getAttribute("id") %>
    --%>
    <%
	// リクエストパラメータの文字エンコーディング指定
	request.setCharacterEncoding("utf-8");
	//パラメータの入力とチェック
	// session.getAttribute("id") はオブジェクト型
	int strId = new Integer(session.getAttribute("id").toString()).intValue(); ;

	// JDBC ドライバのロード
	Class.forName("org.gjt.mm.mysql.Driver");
	// データベースとの結合
	Connection db = DriverManager.getConnection("jdbc:mysql://localhost/QANDA_db?user=chef&password=secret&useUnicode=true&characterEncoding=utf-8");

	// Statement オブジェクトの生成
	Statement st = db.createStatement();
	// SQL 文を query に格納
	String query = "select QUEID,CON,TAG from questions_tbl where USERID = "+ strId ;
	// SQL 文を実行し結果を ResultSet に格納
	ResultSet rs = st.executeQuery(query);
    %>
    <!--
    <%= query %>クエリが正しいか確認
    -->
   <!-- <form action="../search/QANDA2.jsp"> -->
      <table border="1">
        <tr>
	  <td>質問ID</td>
	  <td>内容</td>
    	  <td>タグ</td>
        </tr>

	  <%
	    // nextメソッドでポインタを順次移動
	    while(rs.next()) {
  	  %>
    	<tr>
	  <td>
	    <%= rs.getInt("QUEID")%>
	  </td>
      	  <td>
	    <a href="../search/QANDA2.jsp?queid=<%= rs.getString("QUEID")%>"><%= rs.getString("CON")%>
	   <!-- 
	   <input type="hidden" name=queid value="<%= rs.getInt("QUEID")%>">
           <input type="submit" value="<%= rs.getString("CON")%>">
	    -->
      	  </td>
      	  <td>
            <%= rs.getString("TAG") %>
      	  </td>
        </tr>
    	  <%
    	    }
	    // ResultSet, Statement, データベースを順にクローズ
	    rs.close();
	    st.close();
	    db.close();
	  %>
  	</table>
      </form>
      <form action=servlet/DeleteQuestion>
      	    <input type="text" name = DeleteQuestionID maxlength=10 placeholder="削除する質問のIDを入力">
 	    	   <button type="submit">削除</button>
	<% 
	int UserID = new Integer(session.getAttribute("id").toString()).intValue(); 
	%>
		   <input type="hidden" name=UserID value=<%=UserID%>>
      </form>
    </main>
    <footer>
      関連リンクなど
    </footer>
  </body>
</html>
