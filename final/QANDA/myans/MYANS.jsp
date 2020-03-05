<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" import="java.sql.*" %> 

<html>
<head>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="-1">
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=utf-8">
<title>回答一覧</title>
<link rel="stylesheet" href="css/common.css">
</head>
<body>
    <header>
      <h1><a href="../mypage/Mypage.jsp">KIT解決</a></h1>
      <button type=“button” onclick="location.href='../login/Login.html'">ログアウト</button>
    </header>
   <main> 
<%
	// リクエストパラメータの文字エンコーディング指定
	request.setCharacterEncoding("utf-8");
	//パラメータの入力とチェック
	int strId = new Integer(session.getAttribute("id").toString()).intValue();//セッションで引き継ぎ

	// JDBC ドライバのロード
	Class.forName("org.gjt.mm.mysql.Driver");
	// データベースとの結合
	Connection db = DriverManager.getConnection("jdbc:mysql://localhost/QANDA_db?user=chef&password=secret&useUnicode=true&characterEncoding=utf-8");

	// Statement オブジェクトの生成
	Statement st = db.createStatement();
	// SQL 文を query に格納
	String query = "select answers_tbl.CON, questions_tbl.CON,questions_tbl.QUEID, ANSID from answers_tbl,questions_tbl where answers_tbl.QUEID = questions_tbl.QUEID AND answers_tbl.USERID = "+ strId ;
	// SQL 文を実行し結果を ResultSet に格納
	ResultSet rs = st.executeQuery(query);
%>
<!--
<%= query %>クエリが正しいか確認
-->
<h1>回答した質問</h1>
<!--<form action="../search/QANDA2.jsp">-->
<table border="1">
<tr>
  <td>回答ID</td>
  <td>あなたの回答</td>
  <td>質問</td>
</tr>

<%
	// nextメソッドでポインタを順次移動
	while(rs.next()) {
%>
<tr>
  <td><%= rs.getInt("ANSID")%> </td>
  <td><%= rs.getString("answers_tbl.CON") %></td>
  <td>
<a href="../search/QANDA2.jsp?queid=<%= rs.getString("questions_tbl.QUEID")%>"><%= rs.getString("questions_tbl.CON")%>
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
      <form action=servlet/DeleteAnswer>
      	    <input type="text" name = DeleteAnswerID maxlength=10 placeholder="削除する回答のIDを入力">
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