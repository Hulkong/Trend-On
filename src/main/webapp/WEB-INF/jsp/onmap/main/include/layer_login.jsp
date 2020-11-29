<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<form id="userLoginForm"  method="post" >
	<input type="hidden" name="saved_username" id="saved_username" value="" />
	<!-- 로그인 -->
	<div id="loginDiv" class="pop_layer2 layer_login layer_div">
		<div class="layer_top">
			<p class="tit">로그인</p>
			<a href="#none" class="btn_close">닫기</a>
		</div>
		<div class="layer_con">
			<dl class="dl_write">
				<dt><span class="tit">아이디</span></dt>
				<dd><input type="text" name="userId" id="userId" class="inp_full" value="" /></dd>
			</dl> 
			<dl class="dl_write">
				<dt><span class="tit">비밀번호</span></dt>
				<dd><input type="password" name="password" id="password" class="inp_full" value="" onKeyDown="onKeyDown(event)"/></dd>
			</dl>
		</div>
		<div class="login_msg">
			<label><input type="checkbox" id="saved_id" name="saved_id" />사용자 아이디 기억</label>
			<span class="login_err_msg"></span>
		</div>
		<div class="layer_btm">
			<ul>
				<li><a href="#" id="btnUserLogin" class="btn_confirm">확인</a></li>
				<li><a href="#" id="btnContact" >아이디/비밀번호 찾기</a></li>
			</ul>
		</div>
	</div>
	<!-- //로그인 -->
</form>

<!-- 로그인 -->
<div id="contactDiv" class="pop_layer2 layer_login layer_div" style="display:none;">
	<div class="layer_top">
		<p class="tit">아이디/비밀번호 찾기</p>
		<a href="#none" class="btn_close">닫기</a>
	</div>
	<div class="layer_con">
		<dl class="dl_write">
			<dt style="display:block;"><span>아이디 또는 비밀번호와 관련된 문의는 아래의 연락처로 연락주시기바랍니다.</span></dt>
			<dt style="display:block;"><span class="tit">Email : sales@openmate-on.co.kr</span></dt>
			<dt style="display:block;"><span class="tit">Tel : 02-6956-7541</span></dt>
			<dt style="display:block;"></dt>
		</dl>
	</div>
</div>
<!-- //로그인 -->

<script type="text/javascript">
	$(document).ready(function() {
		
// 		// 구삼성 사용자
// 		var v1Member = [
//             'admin@openmate.co.kr'
//             ,'jm001@korea.kr'
//             ,'cho1003@korea.kr'
//             ,'creator@korea.kr'
//             ,'iamkjc@korea.kr'
//             ,'andong01@korea.kr'
//             ,'samjin-ium@hanmail.net'
//             ,'emulison@naver.com'
//             ,'nshin@korea.kr'
//             ,'nice@nice.co.kr'
//             ,'davidkimspam@gmail.com'
//             ,'lshj2000@naver.com'
//             ,'ganni1431@naver.com'
//             ,'nsy@openmate.co.kr'
//             ,'nice_sp'
//             ,'nice_sd'];

		// 구삼성 사용자
		var v1Member = [
            'admin2',		// 오픈메이트온
            'nice2',		// 나이스지니데이터
//             'jeungpyeong',	// 증평
            'andong',		// 안동
            'gg_icheon',	// 이천
            'yeoju',		// 여주
            'yeoncheon'		// 연천
        ];
		
		$("#btnUserLogin").click(function() {
			
			var userId = $("#userId").val();
			
			if($("#saved_id").is(":checked")) {
				$("#saved_username").val(userId);
			}else{
				$("#saved_username").val("");				
			}
			
			// 삼성서버로 포워딩
			if(v1Member.indexOf(userId) >= 0) {
				$("#userLoginForm").attr("action", "https://v1.trend-on.co.kr/onmap/login/loginProc.do").submit();
				
			// 국민서버로 포워딩
			} else {
				$("#userLoginForm").attr("action", "/onmap/login/loginProc.do").submit();
			}
		});
		
		
		$('#btnContact').click(function(){
			$('#loginDiv').hide();
			$('#contactDiv').show();
		})
	});

	var cName = "saved_username=";
	var cookieData = document.cookie;
    var start = cookieData.indexOf(cName);
    var cValue = '';
    if(start != -1){
         start += cName.length;
         var end = cookieData.indexOf(';', start);
         if(end == -1)end = cookieData.length;
         cValue = cookieData.substring(start, end);
    }
    cValue = cValue.replace(/\"/g,"");

    if(cValue != "" && null != cValue) {
    	$("#userId").val(cValue);
    	$("#saved_id").prop("checked", true);
    }
    
	function onKeyDown(e){
	    if(e.keyCode == 13){
	    	$("#btnUserLogin").click();
	    }
	}
</script>
