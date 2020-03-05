<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" import="java.sql.*"%> 

<html>
  <head>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="-1">
    <META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=utf-8">
    <title>質問の詳細</title>
    <link rel="stylesheet" type="text/css" href="css/common.css">
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
	String Queid = request.getParameter("queid");
	String Conte = request.getParameter("answer");
	String Ref = request.getParameter("ref");
	String Baid = request.getParameter("baid");
	%>
	<!--
	<p>ユーザーID: <%= session.getAttribute("id")%></p>
	<p>質問ID: <%= Queid%></p>
	-->

	<%
	int UserID = new Integer(session.getAttribute("id").toString()).intValue();

	//ベストアンサーが決められた場合
	if(Baid != null){
		Class.forName("org.gjt.mm.mysql.Driver");
		Connection db = DriverManager.getConnection("jdbc:mysql://localhost/QANDA_db?user=chef&password=secret&useUnicode=true&characterEncoding=utf-8");
		Statement st = db.createStatement();	
		String query = "update questions_tbl set BAID="+Baid+" where QUEID="+Queid+";";
		int num = st.executeUpdate(query);
		if(num <= 0){

		%>
		更新できませんでした。
		<%

		}
	}

	//高評価ボタンが押されていた場合
	if("1".equals(Ref)){
		Class.forName("org.gjt.mm.mysql.Driver");
		Connection db = DriverManager.getConnection("jdbc:mysql://localhost/QANDA_db?user=chef&password=secret&useUnicode=true&characterEncoding=utf-8");
		Statement st = db.createStatement();	
		String query = "update questions_tbl set REF = REF+1 where QUEID="+Queid+";";
		int num = st.executeUpdate(query);
		if(num <= 0) {

		%>
		更新できませんでした。
		<%

		}
	}

	if(Queid == null || Queid.isEmpty()){

	%>
		質問IDが取得できてないです.
	<%

	}
	else{
		if(!(Conte == null || Conte.isEmpty())){
	
		//内容が追加された場合
	
		Class.forName("org.gjt.mm.mysql.Driver");
		Connection db = DriverManager.getConnection("jdbc:mysql://localhost/QANDA_db?user=chef&password=secret&useUnicode=true&characterEncoding=utf-8");
		Statement st = db.createStatement();	
		String query = "insert into answers_tbl set QUEID="+Queid+", ANSID=0, CON='"+Conte+"', USERID="+UserID+";";
		// SQL 文を実行し挿入した数が返る
		int num = st.executeUpdate(query);
			    if(num <= 0) {
			    %>
				データが登録されませんでした。
			    <%
	    		    }
		}
	
		//常に必要な処理
	
		// JDBC ドライバのロード
		Class.forName("org.gjt.mm.mysql.Driver");
		// データベースとの結合
		Connection db = DriverManager.getConnection("jdbc:mysql://localhost/QANDA_db?user=chef&password=secret&useUnicode=true&characterEncoding=utf-8");

		// Statement オブジェクトの生成
		Statement st = db.createStatement();
		// SQL 文を query に格納
		String query = "select CON,TAG,REF,USERID,BAID from questions_tbl where QUEID="+Queid+";";
		// SQL 文を実行し結果を ResultSet に格納
		ResultSet rs = st.executeQuery(query);
		%>
		<h1>質問</h1>

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
			</table>
			<%
			//ベストアンサーを表示するための変数
			Baid = rs.getString("BAID");
		}
		%>

		<!--ベストアンサーを表示する処理-->

		<p style="text-align: left">ベストアンサー</p>
		<table border="1">
		<tr><td>内容</td><td>回答者</td></tr>


		<%
		// SQL 文を query に格納
		String query1 = "select CON,USERID from answers_tbl where USERID="+Baid+" and QUEID="+Queid+";";
		// SQL 文を実行し結果を ResultSet に格納
		ResultSet rs1 = st.executeQuery(query1);
		// nextメソッドでポインタを順次移動
		while(rs1.next()) {
		%>


		<tr>
		<td><%= rs1.getString("CON") %></td>
		<td><%= rs1.getString("USERID")%></td>
		</tr>


		<%
		}
		%>


		</table>

		<!--質問に対する回答を表示させる処理-->

		<p style="text-align: left">回答の表示</p>
		<table border="1">
		<tr><td>内容</td><td>回答者</td></tr>


		<%
		// SQL 文を query に格納
		String query2 = "select CON,USERID from answers_tbl where QUEID="+Queid+";";
		// SQL 文を実行し結果を ResultSet に格納
		ResultSet rs2 = st.executeQuery(query2);
		// nextメソッドでポインタを順次移動
		while(rs2.next()) {
		%>


		<tr>
		<td><%= rs2.getString("CON") %></td>
		<td><%= rs2.getString("USERID")%></td>
		</tr>


		<%
		}
		%>


</table>

<form action="QANDA2.jsp">
<textarea type="text" name="answer" cols="80" rows="6" maxlength="300" required></textarea>
<input type="hidden" name="queid" value=<%=Queid%>>
<input type="hidden" name="userid" value="<%= UserID%>">
<br><input type="submit" value="回答">
</form>

<form method="post" action="QANDA2.jsp">
<input type = "hidden" name = ref value = "1">
<input type = "hidden" name = queid value = <%=Queid%>>
<input type="submit" value="good">
</form>

<%
	// SQL 文を query に格納
	String query3 = "select USERID from questions_tbl where QUEID="+Queid+";";
	// SQL 文を実行し結果を ResultSet に格納
	ResultSet rs3 = st.executeQuery(query);
	while(rs3.next()) {
		if( UserID == rs3.getInt("USERID") && (Baid == null)){
%>


		ベストアンサーは誰の質問？
		<form action="QANDA2.jsp">
		<input type="text" name="baid" maxlength="5">
		<input type="hidden" name="queid" value=<%=Queid%>>
		<input type="submit" value="決定">
		</form>
		

<%
		}
	}
	// ResultSet, Statement, データベースを順にクローズ
	rs.close();
	rs1.close();
	rs2.close();
	rs3.close();
	st.close();
	db.close();
	}
%>
     </main>
    </body>
</html>