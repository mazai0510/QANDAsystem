<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"
 import="java.sql.*" %>
<html>
<head>
<link rel="stylesheet" type="text/css" href="css.common.css">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
int UserID = new Integer(session.getAttribute("id").toString()).intValue();
%>
<title>QA</title>
    <link rel="stylesheet" href="css/common.css">
</head>
<body>
<header>
     <h1><a href="../mypage/Mypage.jsp">KIT解決</a></h1>
      <button type=“button” onclick="location.href='../login/Login.html'">ログアウト</button>
</header>
    <main> 
<h1>質問検索</h1>
<form action=QANDA1.jsp>
キーワード
<input type="text" name=textData required>
<input type="submit" value="検索">
</form>
<form action=QANDA1.jsp>
タグ検索
<input type="text" name=Tag required>
<input type="hidden" name=UserID value=<%=UserID%>>
<input type="submit" value="検索">

</form>
    </main>
<footer>
今後何か書きます
</footer>
</body>
</html>
