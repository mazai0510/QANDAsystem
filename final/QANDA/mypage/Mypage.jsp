
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
     <h1><a href="Mypage.jsp">KIT解決</a></h1>
      <button type=“button” onclick="location.href='../login/Login.html'">ログアウト</button>
    </header>
    <main>
      <h1>ようこそ <%= session.getAttribute("name") %> さん </h1>
      <%-- ただリンクを貼ってるだけなので、本当にログアウトしてるわけではない(やり方分かり次第変更)  --%>
      <nav>
        <ul>
	<li><button type=“button” onclick="location.href='../question/Question.jsp'" class="btn1" >質問を投稿する</button></li>
	<li><button type=“button” onclick="location.href='../search/QANDA.jsp'" class="btn1">質問に回答する</button></li>
	</ul>
     
	<ul>
	<li><button type=“button” onclick="location.href='../myque/MYQUE.jsp'" class="btn2">投稿した質問を見る</button></li>
	<li><button type=“button” onclick="location.href='../myans/MYANS.jsp'"class="btn2" >回答した質問を見る</button></li>
	</ul>
      </nav>
    </main>
    <footer>
      関連リンクなど
    </footer>
  </body>
</html>
