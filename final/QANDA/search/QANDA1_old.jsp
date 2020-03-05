<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" import="java.sql.*" %> 

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
	String strCon = request.getParameter("textData");
	String strTag = request.getParameter("Tag");
	
	// JDBC ドライバのロード
	Class.forName("org.gjt.mm.mysql.Driver");
	// データベースとの結合
	Connection db = DriverManager.getConnection("jdbc:mysql://localhost/QANDA_db?user=chef&password=secret&useUnicode=true&characterEncoding=utf-8");
	// Statement オブジェクトの生成
	Statement st = db.createStatement();
	// SQL 文を query に格納

	if(!(strCon == null || strCon.isEmpty())){
	String query = "select QUEID,CON,TAG from questions_tbl where CON like \"%"+ strCon +"%\";";
	ResultSet rs = st.executeQuery(query);		
%>
ユーザーID: <%= session.getAttribute("id")%>
<%
int UserID = new Integer(session.getAttribute("id").toString()).intValue();
%>

<h1>質問の表示</h1>
<form action="QANDA2.jsp">
<table border="1">
<tr><td>QUEID</td><td>内容</td><td>タグ</td></tr>

<%
	// nextメソッドでポインタを順次移動
	while(rs.next()){
%>
<tr>
<td>
<%= rs.getInt("QUEID")%>
</td>
<td>
<input type="hidden" name=queid value="<%= rs.getInt("QUEID")%>">
<input type="hidden" name=UserID value=<%=UserID%>>
<input type="submit" value="<%= rs.getString("CON")%>">
</td>
<td><%= rs.getString("TAG")%></td>
</tr>
<%
	}
	rs.close();
}else{
	String query1 = "select QUEID,CON,TAG from questions_tbl where TAG like \"%"+ strTag +"%\";";
	ResultSet rs1 = st.executeQuery(query1);		
%>

<h1>質問の表示</h1>
<form action="QANDA2.jsp">
<table border="1">
<tr><td>内容</td><td>タグ</td></tr>

<%
	// nextメソッドでポインタを順次移動
	while(rs1.next()) {
%>
<tr>
<td>
<input type="hidden" name=queid value="<%= rs1.getInt("QUEID")%>">
<input type="submit" value="<%= rs1.getString("CON")%>">
</td>
<td><%= rs1.getString("TAG")%></td>
</tr>
<%
	}
	rs1.close();
}
	// ResultSet, Statement, データベースを順にクローズ
	st.close();
	db.close();
%>
</table>
</form>
</body>
</html>