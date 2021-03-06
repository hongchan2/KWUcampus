<%@ page import="java.sql.*"%>
<%@ page import="dbPractice.Connect.DBConnect"%>
<%--
  Created by IntelliJ IDEA.
  User: User
  Date: 2019-05-31
  Time: 오후 3:37
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width initial-scale=1">
	<link rel="stylesheet" href="css/bootstrap.css">
<meta charset="utf-8">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>문자 보내기</title>
<%
	if (session.getAttribute("id") == null) // 로그인 중인지 확인
	{
		out.println("<script> alert('로그인이 되어 있지 않습니다.'); location.href = 'index.jsp'; </script>");
	}

	Connection conn = null;
	Statement stmt = null;
	ResultSet rs = null;

	conn = DBConnect.getConnection();
	stmt = conn.createStatement();
%>
</head>
<body>
<br>
<a href="Pmaterial.jsp">강의자료 관리</a> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a href="Smanagement.jsp">메일 보내기</a> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a href="Smanagement_SMS.jsp">문자 보내기</a> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a href="logoutAction.jsp">로그아웃</a>
<br><hr>
<h2>문자 보내기</h2>
<br><br>
	<form method="post" action="Smanagement_SMS.jsp" accept-charset="utf-8">
		과목 명 : <select name="Cid" id="Cid" tabindex="1"
			onchange="document.getElementById('CidToSA').value  = this.options[this.options.length - 1].text">
			<%
				String sql1 = "select Cid, CName from course where Pid='" + session.getAttribute("id") + "';"; // 과목 이름 가져오기
				String Cid = null; // 현재 선택한 과목 번호
				rs = stmt.executeQuery(sql1);

				while (rs.next()) {
					out.println("<option value='" + rs.getString("Cid") + "'>" + rs.getString("CName") + "</option>");
					if(Cid == null)
						Cid = rs.getString("Cid");
				}
			%>
		</select> <input type="submit" value="수강생관리">
	</form>

	<%
		if (request.getParameter("Cid") != null) {
			Cid = request.getParameter("Cid");
		}

		String sql2 = "select Sid from enroll where Cid='" + Cid + "';";
		rs = stmt.executeQuery((sql2));
		String Sids = "('null')";

		if (rs.next()) {
			Sids = "('" + rs.getString("Sid") + "'";
			while (rs.next()) {
				Sids += ",'" + rs.getString("Sid") + "'";
			}
			Sids += ")";
		}

		String sql3 = "select * from student where Sid in " + Sids + ";";

		rs = stmt.executeQuery(sql3);
	%>

	<form action="sendAction_SMS.jsp" method="post">
		<table class="table table-striped">
			<%
				out.println("<tr><th></th><th scope=\"col\">학번</th><th scope=\"col\">이름</th><th scope=\"col\">학년</th><th scope=\"col\">이메일</th><th scope=\"col\">전화번호</th><th scope=\"col\">학과</th></tr>");
				while (rs.next()) {
					out.println("<tr>");
					out.println("<td><input type='checkbox' name='Sids' value='" + rs.getString("Sid") + "'</td>");
					out.println("<td>" + rs.getString("Sid") + "</td>");
					out.println("<td>" + rs.getString("Sname") + "</td>");
					out.println("<td>" + rs.getString("Year") + "</td>");
					out.println("<td>" + rs.getString("Email") + "</td>");
					out.println("<td>" + rs.getString("Pno") + "</td>");
					out.println("<td>" + rs.getString("Dept") + "</td>");
					out.println("</tr>");
				}
			%>
		</table>
		<br> <br> <br> <input type="text" name="Cid"
			value="<%=Cid%>" style="display: none">
		<p>
			내용 :
			<textarea rows="32" cols="16" size="512"
				style="width: 500px; height: 200px;" name="contents"></textarea>
		</p>
		<input type="submit" value="SMS전송">
	</form>
	<%     	//DB사용 후 close() 필수!
	stmt.close();
	rs.close();
	conn.close(); %>

</body>
</html>