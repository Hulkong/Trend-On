<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication property="principal.extInfo" var="userInfo"/> 
<a href="#none" id="btnUser" class="user"><em>${userInfo.org_nm }</em>님 안녕하세요</a>
<!-- 사용자 메뉴-->
<div id="layerUser" class="layer_user layer_div" style="display: none;">
	
	<div class="layer_top">
		<span class="tit">${userInfo.org_nm } 님<em> ${userInfo.user_id }</em></span>
		<a href="#none" id="btnUserClose" class="btn_close">닫기</a>
	</div>
	
	<div class="bx_area">
		
		<sec:authorize access="hasRole('ROLE_ADMIN')" var="a"></sec:authorize>
		<sec:authorize access="hasRole('ROLE_GOLD')" var="g"></sec:authorize>
		
		<c:if test="${a || g}">
			<select id="temp_mega" onChange="megaChange(this.value)">
				<option value="">서울특별시</option>
			</select>
			<select id="temp_cty">
				<option value="">강남구</option>
			</select>
			<a href="#none" id="changeRegion" class="region_btn">변경</a>
		</c:if>
		
		<c:if test="${!a && !g}">
			<%-- ${userInfo.mega_nm } ${userInfo.cty_nm } --%>
			<select id="temp_mega_user" onChange="userMegaChange(this.value)">
				<!-- <option value="">서울특별시</option> -->
			</select>
			<select id="temp_cty_user"> 
				<!-- <option value="">강남구</option> -->
			</select>
			<a href="#none" id="changeRegion" class="region_btn">변경</a>
		</c:if>
			
		 
	</div>
	<div class="bx_util">
		<div class="user_map"> 
			<img src="${globalConfig['config.phantomjs.host']}/d3/region_thumb.jsp?h=98&w=141&o={ctyCd:${userInfo.cty_cd },%22color%22:%22%23ff0000%22,%22weight%22:1,%22fillOpacity%22:0.4,%22opacity%22:0.65} " alt="" />
		</div>
		<ul>
			<li><a href="<c:url value='/onmap/login/logout.do'/>" id="btnLogout" class="btn_confirm">로그아웃</a></li>
			<li><a href="#" class="btn_confirm pwdUpdate" data-value="password">비밀번호 변경</a></li>
			<li>
				<c:if test="${a}">
					<a href="/onmap/admin/main.do" target="_blank" class="btn_confirm" data-value="adminPage">관리자 페이지</a>
				</c:if>
			</li>
		</ul>
	</div>
	<form id="logoutForm" action="<c:url value='/onmap/login/logout.do'/>" ></form>
</div>

<!-- //사용자 메뉴 -->

<!-- [2019.02.15] 비번 변경 추가 -->
	<div id="layerUpdate" class="pop_layer2 layer_user_infor layer_div">
		<div class="layer_top">
			<p class="tit">비밀번호 변경</p>
			<a href="#none" class="btn_close">닫기</a>
		</div>
		<div class="layer_con">
			<form name="frm" id="frm" >
				<input type="hidden" name="userId" value="${userInfo.user_id }" />
				<dl class="dl_write">
					<dt><span class="tit">현재 비밀번호</span></dt>
					<dd><input type="password" id="beforePassword" name="beforePassword" value="" class="inp_full"/></dd>
				</dl>
				<dl class="dl_write">
					<dt><span class="tit">변경 비밀번호</span></dt>
					<dd><input type="password" id="password" name="password" value="" class="inp_full"/></dd>
				</dl>
				<dl class="dl_write">
					<dt><span class="tit">비밀번호 확인</span></dt>
					<dd><input type="password" id="repassword" name="repassword" value="" class="inp_full"/></dd>
				</dl>
			</form>
		</div>
		<div class="layer_btm">
			<ul>
				<li><a href="#none" id="changePwd" class="btn_confirm">확인</a></li>
				<li><a href="#none" class="btn_close" >취소</a></li>
			</ul>
		</div>
	</div>
<!-- [2019.02.15] 비번 변경 추가 -->
<!-- [2019.02.15] 비번 변경 성공 추가 -->
	<div id="layerUpdateSucc" class="pop_layer2 layer_user_infor layer_div">
		<div class="layer_top">
			<p class="tit">비밀번호 변경 완료</p>
			<a href="#none" class="btn_close">닫기</a>
		</div>
		<div class="layer_con">
			<span class='tit'> 비밀번호가 변경 되었습니다.</span>
		</div>
		<div class="layer_btm">
			<ul>
				<li><a href="#none" class="btn_confirm btn_close">닫기</a></li>
			</ul>
		</div>
	</div>
<!-- [2019.02.15] 비번 변경 성공 추가 -->

<!-- 로그인 확인 -->
<div id="loginLayer" class="pop_layer2 layer_user_infor layer_div" style="display: none;">
	<div class="layer_top">
		<p class="tit">로그인</p>
		<a href="#" class="btn_close">닫기</a>
	</div>
	<div class="layer_con">
		<dl class="dl_write">
			<dt><span class="tit">아이디</span></dt>
			<dd><input type="text" id="userId" class="inp_full" /></dd>
		</dl>
		<dl class="dl_write">
			<dt><span class="tit">비밀번호</span></dt>
			<dd><input type="password" id="userPw" class="inp_full" /></dd>
		</dl>
	</div>
	<div class="layer_btm">
		<ul>
			<li><a href="#" id="btnLogin" class="btn_confirm">확인</a></li>
			<li><a href="#" class="btn_cancel">취소</a></li>
		</ul>
	</div>
</div>
<!-- //로그인 확인 -->

<script type="text/javascript">
	
	var cty_list = '';
	
	$(document).ready(function() {
		$("#btnUser").click(function() {
			$("#layerUser").show();
		});

		$(".btn_close, .btn_cancel").click(function() {
			$(this).parents(".layer_div").hide();
		});

		// 비밀번호 변경 팝업 open
		$('.pwdUpdate').click(function() {
			$('.layer_div').hide();
			$('#layerUpdate').show();
		});
		
		$("#layerUser li").click(function() {
			var type = $(this).contents().attr("data-value");
			
			//특정 계정 사용제한 시작
			var userNo = "${userInfo.user_no}";
			if(userNo == '45' && type){
				alert("테스트 계정으로는 이용하실 수 없습니다.");
				return false;
			}
			//특정 계정 사용제한 끝
			
			$("#layerUser").hide();
			$("#"+type+"Layer").show();
		});

		// 확인버튼 엔터 
		$("body").keydown(function(key) {
			
			if(key.keyCode == 13) {
				$('#changePwd').click();
			}
		});
		
		// 비밀번호 변경
		$('#changePwd').click(function() {
			
			// 비밀번호 검증
			if(!validation()){
				return;
			}
			
			$.ajax({
				url : '/onmap/member/updatePassword.json',
				type : 'POST',
				data : $("#frm").serialize(),
				success : function(data){
					if(data != undefined && data != null){
						
						if(data.resultMsg != undefined && data.resultMsg != '') alert(data.resultMsg);
						
						var resultCd = data.resultCode;
						
						if(resultCd == '10'){
							$('.layer_div').hide();
							$('#layerUpdateSucc').show();
						}else if(resultCd == '01'){			// 현재비밀번호 
							$("#beforePassword").val("");
							$("#beforePassword").focus();
						}else if(resultCd == '02'){
							$("#password").val("");
							$("#repassword").val("");
							$("#password").focus();
						}else if(resultCd == '03'){
							$("#repassword").val("");
							$("#repassword").focus();
						}else if(resultCd == '00'){
							$("#beforePassword").val(""); 
							$("#password").val("");
							$("#repassword").val("");
						}
					}
				}
			});
		});


		/*************************************************************/
		/////////////////////////로그인 이벤트 시작////////////////////////
		$("#btnLogin").click(function() {

			var userId = $("#userId").val();
			var userPw = $("#userPw").val();

			if("" == userPw) {
				alert("아이디를 입력해주세요.");
				return;
			}

			if("" == userPw) {
				alert("비밀번호를 입력해 주세요");
				return;
			}

			$.ajax({
				url:'/openmate/login.json',
				type:"POST",
				async: false,
				data:{
					"id":userId,
					"password":userPw
				},
				success: function(data){
					if(data.success) {
						$("#secsnLayer").show();
						$("#loginLayer").hide();
					} else {
						alert("로그인에 실패 했습니다.");
					}
				},
				error: function(e) {
					alert("에러가 발생 했습니다. 관리자에게 문의하세요.");
				}
			});
		});
		/////////////////////////로그인 이벤트 끝/////////////////////////
		/*************************************************************/


		/*************************************************************/
		/////////////////////////로그아웃 이벤트 시작////////////////////////
		$("#btnResult").click(function() {
			$("#logoutForm").submit();
		});
		/////////////////////////로그아웃 이벤트 끝/////////////////////////
		/*************************************************************/
		
		
		/*************************************************************/
		/////////////////////////임시 지역변경 - temp_mega option 가져오기 이벤트 시작////////////////////////
 		
		// 운영자 로그인 일 때만 실행
		
		if(${a} === true){
			$.ajax({
				url:'/common/area_select_option.json',
				type:"POST",
				data:{
					"rgnClss":"H1"
				},
				async: false,
				success: function(data){
					var userMega = "${userInfo.mega_cd}";
					$("#temp_mega").empty();
					for(var i = 0; i < data.length; i++) {
						var dataMap = data[i];
						if(userMega == dataMap.id){						
							$("#temp_mega").append("<option value=" + dataMap.id + " selected='selected'>" + dataMap.nm + "</option>");
						}else{
							$("#temp_mega").append("<option value=" + dataMap.id + ">" + dataMap.nm + "</option>");
						}
					}
					megaChange(userMega);
				}
			});
		} else {
			/////////////////////////유저 계약한 시도 가져오기////////////////////////
			$.ajax({
				url:'/onmap/member/getMega.json',
				type:"POST",
				data:{
					"rgnClss":"H1"
				},
				async: false,
				success: function(data){
					
					console.log('mega data :: ', data);
					
					cty_list = data['cty_list'];
					var mega_sort_list = data['mega_list'];
					
					console.log('asd : ', mega_sort_list);
					
					mega_sort_list.sort(function(a, b) { // 한글 오름차순
		 	 			return a.id < b.id ? -1 : a.id > b.id ? 1 : 0;
		 	 		});
					
					
					var userMega = "${userInfo.mega_cd}";
					$("#temp_mega_user").empty();
					
					for(var i = 0; i < mega_sort_list.length; i++) {
						var dataMap = mega_sort_list[i];
						if(userMega == dataMap.id){						
							$("#temp_mega_user").append("<option value=" + dataMap.id + " selected='selected'>" + dataMap.nm + "</option>");
						}else{
							$("#temp_mega_user").append("<option value=" + dataMap.id + ">" + dataMap.nm + "</option>");
						}
					}
					
					userMegaChange(data);
					
				}
			});
		}
		/////////////////////////임시 지역변경 - temp_mega option 가져오기 이벤트 끝/////////////////////////
		/*************************************************************/

		/////////////////////////////////////////////////////////////////////////
		/********************************임시 지역변경  이벤트 시작******************************/
		$("#changeRegion").click(function(){
			
			var mega_cd = "";
			var mega_nm = "";
			var cty_cd = "";
			var cty_nm = "";
			
			// 운영자 일 때
			if( ${a} === true ){
				mega_cd = $("#temp_mega").val();
				mega_nm = $("#temp_mega option:selected").text();
				cty_cd =  $("#temp_cty").val();
				cty_nm =  $("#temp_cty option:selected").text();
			} else {
				// 유저 일 때
				mega_cd = $("#temp_mega_user").val();
				mega_nm = $("#temp_mega_user option:selected").text();
				cty_cd =  $("#temp_cty_user").val();
				cty_nm =  $("#temp_cty_user option:selected").text();
			} 
			
			
			$.ajax({
				url:'/onmap/member/tmp-set-cty.json',
				type:"POST",
				data:{
					"mega_cd" : mega_cd,
					"mega_nm" : mega_nm,
					"cty_cd" : cty_cd,
					"cty_nm" : cty_nm
				},
				async: false,
				success: function(data){
// 					location.href=link;
					// 페이지의 top으로 이동
					document.documentElement.scrollTop = 0;

					// 페이지 reload
					location.reload();
					
				}
			});
		});

		/********************************임시 지역변경 이벤트 종료******************************/
		/////////////////////////////////////////////////////////////////////////
		
	});
	
	function megaChange(megaCd){
		$.ajax({
			url:'/common/area_select_option.json',
			type:"POST",
			data:{
				"rgnClss":"H3",
				"megaCd":megaCd
			},
			async: false,
			success: function(data){
				// 한글 오름차순
				data.sort(function(a, b) { 
					return a.nm < b.nm ? -1 : a.nm > b.nm ? 1 : 0;
				});
				
				var userCty = "${userInfo.cty_cd}";
				$("#temp_cty").empty();
				for(var i = 0; i < data.length; i++) {
					var dataMap = data[i];
					if(userCty == dataMap.id){						
						$("#temp_cty").append("<option value=" + dataMap.id + " selected='selected'>" + dataMap.nm + "</option>");
					}else{
						$("#temp_cty").append("<option value=" + dataMap.id + ">" + dataMap.nm + "</option>");
					}
				}

			}
		});
	}
	
	function userMegaChange(data1){
		
		var megaCd = '';
		megaCd = data1.mega_cd;
		
		$.ajax({
			url:'/common/area_select_option.json',
			type:"POST",
			data:{
				"rgnClss":"H3",
				"megaCd":megaCd
			},
			async: false,
			success: function(data){
				$("#temp_cty_user").empty();
				var dataMap = data1;

				if( !isNaN(dataMap) ) {
					for(var i = 0; i < cty_list.length; i++) {
						console.log('1')
						if (cty_list[i].id.substring(0,2) == dataMap.substring(0,2) ){
							$("#temp_cty_user").append("<option value=" + cty_list[i].id + ">" + cty_list[i].nm + "</option>");
						}	
					}	
				} else {
					for(var i = 0; i < cty_list.length; i++) {
						console.log('2')
						if(cty_list[i].id == dataMap.cty_cd ){
							$("#temp_cty_user").append("<option value=" + cty_list[i].id + " selected='selected'>" + cty_list[i].nm + "</option>");
						}else if (cty_list[i].id.substring(0,2) == dataMap.cty_cd.substring(0,2) ){
							$("#temp_cty_user").append("<option value=" + cty_list[i].id + ">" + cty_list[i].nm + "</option>");
						}	
					}	
				}
				
			}
		});
		
	}


	// 비밀번호 검증하는 함수
	function validation() {
		var bObj = $("#beforePassword");
		var pObj = $("#password");
		var rpObj = $("#repassword");
		
		var beforePassword = bObj.val();
		var password = pObj.val();
		var repassword = rpObj.val();

		if("" == beforePassword) {
			alert("현재 비밀번호를 입력하세요.");
			bObj.focus();
			return false;
		}
		
		if("" == password) {
			alert("변경할 비밀번호를 입력하세요.");
			pObj.focus();
			return false;
		}

		if("" == repassword) {
			alert("비밀번호 확인을 입력하세요.");
			rpObj.focus();
			return false;
		}
		
		if( 7 > password.length ) {
			alert("비밀번호는 영문, 숫자, 기호 조합으로 7자 이상입니다.");
			pObj.focus();
			return false;
		}

		if(!passwordCheck(password)) {
			alert("비밀번호는 영문, 숫자, 기호 조합으로 7자 이상입니다.");
			pObj.focus();
			return false;
		}

		if( 7 > repassword.length ) {
			alert("비밀번호는 영문, 숫자, 기호 조합으로 7자 이상입니다.");
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