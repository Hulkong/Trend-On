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

		var beforePassword = $("#beforePassword").val();
		var password = $("#password").val();
		var rePassword = $("#rePassword").val();

/* 		if(!validation()) {
			return;
		} */

		$.ajax({
			url:'/onmap/public/setmber_password_chang.json',
			type:"POST",
			async: false,
			data:{
				"beforePassword":beforePassword,
				"password":password,
				"rePassword":rePassword
			},
			success: function(data){
				if("ok" == data.resultMsg) {
					alert("비밀번호를 변경했습니다.");
				} else {
					alert("이전 비밀번호를 확인해 주세요.");
				}
			},
			error: function(e) {
				alert("에러가 발생 했습니다. 관리자에게 문의하세요.");
			}
		});
	});

});

function validation() {
	var bObj = $("#beforePassword");
	var pObj = $("#password");
	var rpObj = $("#rePassword");

	var beforePassword = bObj.val();
	var password = pObj.val();
	var repassword = rpObj.val();

	if("" == beforePassword) {
		alert("이전 비밀번호를 입력하세요.");
		bObj.focus();
		return false;
	}

	if( 10 > beforePassword.length ) {
		alert("이전 비밀번호는 영문, 숫자, 기호 조합으로 10자 이상입니다.");
		bObj.focus();
		return false;
	}

	if(!passwordCheck(beforePassword)) {
		alert("이전 비밀번호는 영문, 숫자, 기호 조합으로 10자 이상입니다.");
		bObj.focus();
		return false;
	}

	if("" == password) {
		alert("비밀번호를 입력하세요.");
		pObj.focus();
		return false;
	}

	if( 10 > password.length ) {
		alert("비밀번호는 영문, 숫자, 기호 조합으로 10자 이상입니다.");
		pObj.focus();
		return false;
	}

	if(!passwordCheck(password)) {
		alert("비밀번호는 영문, 숫자, 기호 조합으로 10자 이상입니다.");
		pObj.focus();
		return false;
	}

	if("" == repassword) {
		alert("비밀번호 확인을 입력하세요.");
		rpObj.focus();
		return false;
	}

	if( 10 > repassword.length ) {
		alert("비밀번호는 영문, 숫자, 기호 조합으로 10자 이상입니다.");
		rpObj.focus();
		return false;
	}

	if(password != repassword) {
		alert("비밀번호와 비밀번호 확인이 서로 다릅니다.");
		return false;
	}

	return true;
}

function passwordCheck(pw) {
	var exptext = /^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{6,16}$/;

	if(exptext.test(pw) == false){
		return false;
	}

	return true;

}

</script>

</head>
<body>
	<div>
		<table border="1">
			<tr>
				<th>이전 비밀번호</th>
				<td>
					<input type="text" name="beforePassword" id="beforePassword" value="" />
				</td>
			</tr>
			<tr>
				<th>변경 비밀번호</th>
				<td>
					<input type="text" name="password" id="password" value="" />
				</td>
			</tr>
			<tr>
				<th>비밀번호 확인</th>
				<td>
					<input type="text" name="rePassword" id="rePassword" value="" />
				</td>
			</tr>
		</table>
	</div>
	<div>
		<span id="btnSave" style="cursor: pointer;" >확인</span>
		<span>취소</span>
	</div>
</body>
</html>