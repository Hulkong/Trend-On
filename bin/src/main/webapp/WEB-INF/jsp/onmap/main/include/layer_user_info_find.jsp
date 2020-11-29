<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- 아이디비밀번호 찾기 -->
<div id="findDiv" class="pop_layer2 layer_find layer_div">
	<div class="layer_top non_boder">
		<p class="tit">비밀번호 찾기</p>
		<a href="#none" class="btn_close">닫기</a>
	</div>

	<div class="tab_wrap tab_find tab1">
		<div class="tab_tit">
			<ul>
				<li class="btn_pw on"><a href="#;">비밀번호 찾기</a></li>
			</ul>
		</div>

		<!-- tab_con : 비밀번호찾기 -->
		<div class="tab_con on" id="searchPwTb">
			<div class="layer_con">
				<div class="layer_con_top">
					<p class="tit">사용자 이름, 아이디, 이메일 주소를 입력하시면 이메일주소로 초기화된 비밀번호가 발송됩니다.<br />발송된 비밀번호는 로그인 후에 변경해주셔야 합니다.</p>
				</div>
				<dl class="dl_write">
					<dt><span class="tit">사용자 이름</span></dt>
					<dd>
						<input type="text" name="userNm" class="userNm" value="" />
					</dd>
				</dl>
				<dl class="dl_write">
					<dt><span class="tit">사용자 아이디</span></dt>
					<dd><input type="text" name="userId" class="inp_full userId" value="" /></dd>
				</dl>
			</div>
			<dl class="dl_write">
				<dt><span class="tit">사용자 이메일</span></dt>
				<dd>
					<input type="text" name="emailId" class="emailId" value="" /> @
					<input type="text" name="emailServer" class="emailServer" value="" style="width:75px;" />
					<div id="selectPwMailDiv" class="select_box select_ty1">
						<select id="selectPwMail">
							<option value="">선택</option>
							<option value="gmail.com">gmail.com</option>
							<option value="naver.com">naver.com</option>
							<option value="hanmail.net">hanmail.net</option>
							<option value="nate.com">nate.com</option>
							<option value="">직접입력</option>
						</select>
						<span class="tit"></span>
					</div>
					<input type="text" name="secondPwId" id="secondPwId" value="" style="display: none;" />
				</dd>
			</dl>
			<div class="layer_btm">
				<ul>
					<li><a href="#" id="btnPw" class="btn_confirm">확인</a></li>
					<li><a href="#" class="btn_cancel">취소</a></li>
				</ul>
			</div>
		</div>
		<!-- //tab_con : 비밀번호찾기 -->
		
		<!-- tab_con : 비밀번호 재설정 -->
			<div class="tab_con" id="pwResult">
				<div class="layer_con">
					<div class="layer_con_top">
						<p class="tit">사용자 비밀번호를 재설정합니다.</p>
					</div>

					<dl class="dl_write">
						<dt><span class="tit">비밀번호</span></dt>
						<dd>
							<input type="hidden" name="memberId" class="userId" value="" />
							<input type="password" name="regPassword" class="inp_full regPassword" />
							<p class="txt_sub">※ 영문, 기호, 숫자를 혼합하여 7자리 이상으로 입력해 주세요.</p>
						</dd>
					</dl>
					<dl class="dl_write">
						<dt><span class="tit">비밀번호 확인</span></dt>
						<dd>
							<input type="password" name="repassword" class="inp_full repassword"/>
						</dd>
					</dl>
				</div>
				<div class="layer_btm">
					<ul>
						<li><a href="#" id="btnChgPw" class="btn_confirm">확인</a></li>
						<li><a href="#" class="btn_cancel">취소</a></li>
					</ul>
				</div>
			</div>
			<!-- //tab_con : 비밀번호 재설정 -->
	</div>
</div>
<!-- //아이디비밀번호 찾기 -->

<script type="text/javascript">
	$(document).ready(function() {
		
		(function() {
			$('.userNm').val('김용현');
			$('.userId').val('seoul-gangnamgu');
			$('.emailId').val('y_h_kim');
		})()
		
		// 확인버튼 클릭 
		$("#btnPw").click(function() {

			// 유효성 검사
			if(validation("searchPwTb", "pw")) {	
				var emailId = $("#searchPwTb .emailId").val();
				var emailServer = $("#searchPwTb .emailServer").val();
				var userNm = $("#searchPwTb .userNm").val();
				var userId = $("#searchPwTb .userId").val();
				var email = emailId + "@" + emailServer;
	
				getMberInfo(userNm, userId, email);   // 회원 정보에 해당하는 아이디 조회
			}
		});

		// 비밀번호 재설정
		$("#btnChgPw").click(function(){
			if(validation("pwResult", "re_pw")) {
				var userId = $("#pwResult .userId").val();
				var pwd = $("#pwResult .regPassword").val();
				resetPassword(userId, pwd);
			}
		});

		// 메일 뒷주소 select 선택하기
		$("#selectPwMail").change(function() {
			if($(this).val() == ""){
				$("#selectPwMailDiv .tit").text(this.options[this.selectedIndex].text);
			}else{				
				$("#selectPwMailDiv .tit").text($(this).val());
			}
			$(".emailServer").val($(this).val());
			$(".emailServer").show();
		});

	});

	// 회원 정보에 해당하는 아이디 조회하는 함수(비밀번호 변경을 위한 확인 과정)
	function getMberInfo(userNm, userId, email) {

		$.ajax({
			url:'/onmap/member/getMemberIdPwd.json',
			type:"POST",
			data:{
				userNm: userNm,
				userId: userId,
				email: email
			},
			async: true,
			dataType: "text",
			success: function(data){
				if(data) {
// 					console.log(data);
					if(data == 1) {
						$(".tab_con").hide();
						$("#pwResult").show();
						$("#pwResult .userId").val(userId);
					} else {	//비밀번호 조회시 count가 0일 경우 등
						alert("입력하신 정보에 해당하는 고개정보가 없습니다.");	
					}
				} else {
					alert("입력하신 정보에 해당하는 고객정보가 없습니다.");
				}

			},
			error: function(e){
				alert("에러가 발생했습니다. 관리자에게 문의 하세요");
			}
		});

	}

	// 비밀번호 재설정하는 함수 
	function resetPassword(userId, pwd){
		$.ajax({
			url: '/onmap/member/resetPassword.json',
			type: "POST",
			data:{
				'userId' : userId,
				'pwd' : pwd
			},
			async: true,
			dataType: "text",
			success:function(data){
				console.log(data);
				if(data == 1){
					if(confirm("비밀번호가 변경되었습니다.\n로그인하시겠습니까?")){
						$("#btnLogin").click();
					}else{
						$(".btn_close").click();
					};	
				}else{
					alert("관리자에게 문의하세요.");
					return false;
				}
				
			}
		});
	}
	
	// 입력값 유효성 검증하는 함수 
	function validation(tableName, type) {
		var userNm = $("#" + tableName + " .userNm");         // 사용자 이름 
		var userId = $("#" + tableName + " .userId");         // 사용자 아이디 
		var emailId = $("#" + tableName + " .emailId");   // 사용자 이메일 아이디 
		var emailServer = $("#" + tableName + " .emailServer"); // 사용자 이메일 도메인 
		var pwd = $("#" + tableName + " .regPassword");
		var repPwd = $("#" + tableName + " .repassword");

		// 비밀번호 찾기일 경우 
		if(type && type == 'pw') {
			
			// 사용자 이름 검증 
			if("" == userNm.val()) {
				alert("사용자 이름을 입력하세요.");
				userNm.focus();
				return false;
			}
			
			// 사용자 아이디 검증 
			if("" == userId.val()) {
				alert("사용자 아이디를 입력하세요.");
				userNm.focus();
				return false;
			}
			
			// 사용자 이메일 아이디 검증 
			if("" == emailId.val()) {
				alert("사용자 이메일을 입력해주세요.");
				emailId.focus();
				return false;
			}
			
			// 사용자 이메일 도메인 검증 
			if("" == emailServer.val()) {
				alert("사용자 이메일을 입력하세요.");
				emailServer.focus();
				return false;
			}
		}
		
		// 비번 재설정시
		if(type && type == "re_pw"){
			if("" == pwd.val()) {
				alert("비밀번호를 입력하세요.");
				pwd.focus();
				return false;
			}

			if( 7 > pwd.val().length ) {
				alert("비밀번호는 영문, 숫자, 기호 조합으로 7자 이상입니다.");
				pwd.focus();
				return false;
			}

			if(!passwordCheck(pwd.val())) {
				alert("비밀번호는 영문, 숫자, 기호 조합으로 7자 이상입니다.");
				pwd.focus();
				return false;
			}

			if("" == repPwd.val()) {
				alert("비밀번호 확인을 입력하세요.");
				repPwd.focus();
				return false;
			}

			if( 7 > repPwd.val().length ) {
				alert("비밀번호는 영문, 숫자, 기호 조합으로 7자 이상입니다.");
				repPwd.focus();
				return false;
			}

			if(pwd.val() != repPwd.val()) {
				alert("비밀번호와 비밀번호 확인이 서로 다릅니다.");
				return false;
			}
		}
		
		return true;
	}
	
	// 비밀번호 체크하는 함수
	function passwordCheck(pw) {
		
		var exptext = /^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{6,16}$/;

		if(exptext.test(pw) == false){
			return false;
		}

		return true;

	}
</script>