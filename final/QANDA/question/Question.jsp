<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"
import="java.sql.*" %>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>マイページ</title>
    <link rel="stylesheet" href="css/common.css">
  </head>
  <body>
    <header>
	<h1><a href="../mypage/Mypage.jsp">KIT解決</a></h1>
     	<button type=“button” onclick="location.href='../login/Login.html'">ログアウト</button>
    </header>
    <main>
      <h1>質問の投稿</h1>
      <form action=servlet/Questions>
	<input type="text" name=Tag maxlength="20"  placeholder="タグを入力してください" style="margin-bottom: 1em" >
	<textarea type="text" name=Contents maxlength="300" placeholder="質問を入力してください" ></textarea>
	<input type="submit" value="送信">
	<!-- ユーザID:  <%= session.getAttribute("id") %> -->
	

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
