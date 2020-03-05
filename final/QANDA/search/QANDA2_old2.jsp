<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" import="java.sql.*"%> 

<html>
<head>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="-1">
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=utf-8">
<title></title>
</head>
<body>

<%	
	// リクエストパラメータの文字エンコーディング指定
	request.setCharacterEncoding("utf-8");
	//パラメータの入力とチェック
	String Queid = (String)Url.queid;
	String Conte = request.getParameter("answer");
	String Eva = request.getParameter("evaluation");
//高評価ボタンが押されていた場合
if("1".equals(Eva)){
     	Class.forName("org.gjt.mm.mysql.Driver");
	Connection db = DriverManager.getConnection("jdbc:mysql://localhost/QANDA_db?user=chef&password=secret&useUnicode=true&characterEncoding=utf-8");
	Statement st = db.createStatement();	
	String query = "update questions_tbl set REF=REF+1 where QUEID="+Queid+";";
	int num = st.executeUpdate(query);
	if(num <= 0) {
%>
更新できませんでした。
<%
	}
}  



if(Queid == null || Queid.isEmpty()){
%>
質問が取得できてないですね
<%
}
else{
	if(!(Conte == null || Conte.isEmpty())){

	//内容が追加されている場合

	Class.forName("org.gjt.mm.mysql.Driver");
	Connection db = DriverManager.getConnection("jdbc:mysql://localhost/QANDA_db?user=chef&password=secret&useUnicode=true&characterEncoding=utf-8");
	Statement st = db.createStatement();	
	String query = "insert into answers_tbl set QUEID="+Queid+", ANSID=0, CON='"+Conte+"', USERID=0;";
	// SQL 文を実行し挿入した数が返る
	int num = st.executeUpdate(query);
	    if(num <= 0) {
%>
データが登録されませんでした。
<%
		}
	}

	//常時必要な処理

	// JDBC ドライバのロード
	Class.forName("org.gjt.mm.mysql.Driver");
	// データベースとの結合
	Connection db = DriverManager.getConnection("jdbc:mysql://localhost/QANDA_db?user=chef&password=secret&useUnicode=true&characterEncoding=utf-8");

	// Statement オブジェクトの生成
	Statement st = db.createStatement();
	// SQL 文を query に格納
	String query = "select CON,TAG,REF from questions_tbl where QUEID="+Queid+";";
	// SQL 文を実行し結果を ResultSet に格納
	ResultSet rs = st.executeQuery(query);
%>

<h1>質問の表示</h1>
<p>ユーザーID: <%= session.getAttribute("id")%></p>

<%
int UserID = new Integer(session.getAttribute("id").toString()).intValue();
%>

<table border="1">
<tr><td>内容</td><td>タグ</td><td>高評価</td></tr>

<%
	// nextメソッドでポインタを順次移動
	while(rs.next()){
%>

<tr>
<td><%= rs.getString("CON")%></td>
<td><%= rs.getString("TAG")%></td>
<td><%= rs.getString("REF")%></td>
</tr>
<%
	}

	//質問に対する回答を表示させる処理

	// SQL 文を query に格納
	String query1 = "select CON,USERID from answers_tbl where QUEID="+Queid+";";
	// SQL 文を実行し結果を ResultSet に格納
	ResultSet rs1 = st.executeQuery(query1);
%>
</table>
<p>回答の表示</p>
<table border="1">
<tr><td>内容</td><td>回答者</td></tr>

<%
	// nextメソッドでポインタを順次移動
	while(rs1.next()) {
%>

<tr>
<td><%= rs1.getString("CON") %></td>
<td><%= rs1.getString("USERID")%></td>
</tr>


<%
	}
	// ResultSet, Statement, データベースを順にクローズ
	rs.close();
	rs1.close();
	st.close();
	db.close();
}
%>

</table>
<form action="QANDA2.jsp">
<textarea name="answer" cols="80" rows="6" maxlength="20" required></textarea>
<input type="hidden" name=queid value=<%=Queid%>>
<input type="hidden" name=userid value="0">
<br><input type="submit" value="回答">
</form>

<form method="post" action="QANDA2.jsp">
<input type = "hidden" name = evaluation value = "1">
<input type = "hidden" name = queid value = <%=Queid%>>
<input type="submit" value="good">
</form>




</body>
</html>