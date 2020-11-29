<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>

<script type="text/javascript" src='<c:url value="/js/jquery/jquery-1.11.2.min.js"/>'></script>

<script type="text/javascript">

$(document).ready(function() {
	$("#btnSave").click(function() {
		$("#loginForm").submit();
	});

	var cookieData = document.cookie;
	var start = cookieData.indexOf("saved_username=");
	var cValue = "";

	if(start != -1) {
		start += "saved_username=".length;
		var end = cookieDate.indexOf(";", start);

		if(end == -1) {
			end = cookieData.length;
			cValue = cookieData.substring(start, end);
		}
	}

	alert(cValue);

});

</script>

</head>
<body>
	<div>
		<div>
			<form id="loginForm" class="ui large form" method="post" action='<c:url value="/onmap/login/loginProc.do"/>'>
				<table border="1">
					<tr>
						<th>아이디</th>
						<td>
							<input type="text" name="userId" id="userId" value="onmap@openmate.co.kr" />
						</td>
					</tr>
					<tr>
						<th>패스워드</th>
						<td>
							<input type="password" name="password" id="password" value="openmate" />
						</td>
					</tr>
				</table>
			</form>
		</div>
		<div>
			<span id="btnSave" style="cursor: pointer;">로그인</span>
		</div>
	</div>

</body>
</html>