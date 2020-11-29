<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

					<!-- 회원가입 01 -->
					<div id="regist01Div" class="pop_layer2 layer_join layer_div">
						<div class="layer_top non_boder">
							<p class="tit">회원가입</p>
							<a href="#none" class="btn_close">닫기</a>
						</div>
						<div class="join_step">
							<p>
								<img src="/images/common/join_step_01.gif" alt="약관동의" />
							</p>
						</div>
						<div class="layer_con">
							<div class="layer_con_top txt_rg">
								<label class="term_chk"><input type="checkbox" id="allCheck" name="agreCheck" />이용회원 약관 및 개인정보 수집 및 이용에 모두 동의합니다.</label>
							</div>
							<div class="article_agree">
								<div class="group_top">
									<div class="tit">
										이용회원 약관
									</div>
									<div class="bx_rgt">
										<label><input type="checkbox" id="stplayCheck" name="agreCheck" class="agreCheck" />동의합니다.</label>
									</div>
								</div>
								<div class="bx_term">
									<div class="bx_scroll" id="register_policy1">
									</div>
								</div>
							</div>

							<div class="article_agree">
								<div class="group_top">
									<div class="tit">
										개인정보수집 및 이용에 대한 안내
									</div>
									<div class="bx_rgt">
										<label><input type="checkbox" id="indvdlinfoCheck" name="agreCheck" class="agreCheck" />동의합니다.</label>
									</div>
								</div>
								<div class="bx_term">
									<div class="bx_scroll" id="register_policy2">
									</div>
								</div>
							</div>
						</div>
						<div class="layer_btm">
							<ul>
								<li><a href="#" id="btnAgre" class="btn_confirm">네! 동의합니다.</a></li>
								<li><a href="#" class="btn_cancel">아니요! 동의하지 않습니다.</a></li>
							</ul>
						</div>
					</div>
					<!-- //회원가입 01 -->

					<!-- 회원가입 02 -->
					<div id="regist02Div" class="pop_layer2 layer_join layer_div">
						<div class="layer_top non_boder">
							<p class="tit">회원가입</p>
							<a href="#" class="btn_close">닫기</a>
						</div>
						<div class="join_step">
							<p>
								<img src="/images/common/join_step_02.gif" alt="정보입력" />
							</p>
						</div>
						<div class="layer_con">
							<dl class="dl_write">
								<dt><span class="tit">사용자 아이디(이메일주소)</span></dt>
								<dd>
									<input type="hidden" id="checkIdYn" value="N"/>
									<input type="hidden" id="ctyCdYn" value="N"/>
									<input type="hidden" name="userId" id="userId" value="" />
									<input type="hidden" name="userNo" id="userNo" value="" />
									<input type="text" name="firstId" id="firstId" value="" /> @
									<div id="selectMailDiv" class="select_box select_ty1">
										<select id="selectMail">
											<option value="">선택</option>
											<option value="gmail.com">gmail.com</option>
											<option value="naver.com">naver.com</option>
											<option value="hanmail.net">hanmail.net</option>
											<option value="nate.com">nate.com</option>
											<option value="">직접입력</option>
										</select>
										<span class="tit"></span>
									</div>
									<input type="text" name="secondId" id="secondId" value="" style="display: none;width:100px;" />
									<button id="checkId" class="btn_side">중복체크</button>
									<p class="txt_sub" id="msgId"></p>
								</dd>
							</dl>
							<dl class="dl_write">
								<dt><span class="tit">사용자 이름</span></dt>
								<dd><input type="text" name="userNm" id="userNm" class="" /></dd>
							</dl>
							<dl class="dl_write">
								<dt><span class="tit">비밀번호</span></dt>
								<dd>
									<input type="password" name="regPassword" id="regPassword" class="inp_full" />
									<p class="txt_sub">※ 영문, 기호, 숫자를 혼합하여 7자리 이상으로 입력해 주세요.</p>
								</dd>
							</dl>
							<dl class="dl_write">
								<dt><span class="tit">비밀번호 확인</span></dt>
								<dd><input type="password" name="repassword" id="repassword" class="inp_full" /></dd>
							</dl>
							<dl class="dl_write">
								<dt><span class="tit">기관인증키</span></dt>
								<dd>
									<input type="text" name="authKey" id="authKey" value="">
									<input type="hidden" name="checkKeyYn" id="checkKeyYn" value="N">
									<input type="hidden" name="publicId" id="publicId" value="N">
									<button id="checkAuthKey" class="btn_side">인증키체크</button>
									
									
									<ul id="msgaMeg" class="list_txt" style="display:;">
										<li>- 본 서비스의 사용을 위해서는 사용기관으로 먼저 등록되어야 합니다.</li>
										<li>- <em>“아직 사용기관으로 등록되지 않은 상태입니다”</em> 메시지가 나오는 경우 02-395-7540 이나 sales@openmate-on.co.kr로 사용기관 등록을 해주시기 바랍니다.</li>
									</ul>
									<ul id="msgUserMeg" class="list_txt" style="display:none;">
										<li style="color:#ff0000;">- 최대 사용자까지 등록되었습니다.</li>
									</ul>
									<ul id="msgFailMeg" class="list_txt" style="display:none;">
										<li style="color:#ff0000;">- 등록되지않은 인증키입니다.</li>
									</ul>
								</dd>
							</dl>
						</div>
						<div class="layer_btm">
							<ul>
								<li><a href="#" id="btnUserRegist" class="btn_confirm">회원가입</a></li>
								<li><a href="#" class="btn_cancel">취소</a></li>
							</ul>
						</div>
					</div>
					<!-- //회원가입 02-->

					<!-- 회원가입 03 -->
					<div id="regist03Div" class="pop_layer2 layer_join layer_div">
						<div class="layer_top non_boder">
							<p class="tit">회원가입</p>
							<a href="#" class="btn_close">닫기</a>
						</div>
						<div class="join_step">
							<p>
								<img src="/images/common/join_step_03.gif" alt="메일확인" />
							</p>
						</div>
						<div class="layer_con">
							<div class="article_join_mail">
								<p>입력해주신 이메일주소로 사용자 승인을 위한 확인 주소를 발송하였습니다.<br />(이메일 발송에는 5~10분 정도 소요됩니다)<br /><br /><em>이메일로 전송된 주소를 클릭하시면 승인절차가 마무리되며 즉시 사용이 가능</em>합니다.<br />이메일이 오지 않는 경우 아래의 “승인메일 재발송＂ 버튼을 클릭하시면 재발송됩니다.</p>
							</div>
						</div>
						<div class="layer_btm">
							<ul>
								<li><a href="#" id="btnResnd" class="btn_confirm">승인메일 재발송</a></li>
							</ul>
						</div>
					</div>
					<!-- //회원가입 03-->

					<!-- 회원가입 04 -->
					<div id="regist04Div" class="pop_layer2 layer_join layer_div">
						<div class="layer_top non_boder">
							<p class="tit">회원가입</p>
							<a href="#" class="btn_close">닫기</a>
						</div>
						<div class="join_step">
							<p>
								<img src="/images/common/join_step_04.gif" alt="가입완료" />
							</p>
						</div>
						<div class="layer_con">
							<div class="article_join_complete">
								<p><em>이메일 확인이 완료되었습니다.</em><br />회원가입시에 입력하신 이메일 주소(아이디)와 비밀번호를 이용하여 로그인 하시면 즉시 사용이 가능합니다.<br /><br />감사합니다.</p>
							</div>
						</div>
						<div class="layer_btm">
							<ul>
								<li><a href="#" id="btnConfirm" class="btn_confirm">로그인 하러 가기</a></li>
							</ul>
						</div>
					</div>

<script type="text/javascript">
	$(document).ready(function() {
		$("#register_policy1").load("/common/terms_policy1.html");
		$("#register_policy2").load("/common/terms_policy2.html");
		
		$("#allCheck").click(function() {
			var obj = $(":input[name=agreCheck]");

			if($(this).is(":checked")) {
				obj.prop("checked", true);
			} else {
				obj.prop("checked", false);
			}
		});

		$("#stplayCheck, #indvdlinfoCheck").click(function(){
			var obj = $(".agreCheck:checked");

			if(2 == obj.length) {
				$("#allCheck").prop("checked", true);
			} else {
				$("#allCheck").prop("checked", false);
			}

		});

		$("#btnAgre").click(function() {
			var stplay = $("#stplayCheck").is(":checked");
			var indvdlinfo = $("#indvdlinfoCheck").is(":checked");


			if(stplay == false) {
				alert("이용회원 약관에 동의해 주세요");
				return;
			}

			if(indvdlinfo == false) {
				alert("개인정보수집 및 이용에 대한 안내에 동의해 주세요");
				return;
			}

			$(".layer_div").hide();
			$(":input[name=agreCheck]").prop("checked", false);

			$("#regist02Div").show();

		});

		///////////////////////////////////////////////////////////////////////////////////////////////////
		/************************************회원 가입 정보입력 시작************************************************/

		$("#firstId, #secondId").click(function() {
			$("#checkIdYn").val("N");
			$("#userId").val("");
		});

		$("#firstId").keyup(function(event){
			if (!(event.keyCode >=37 && event.keyCode<=40)) {
				var inputVal = $(this).val();
				$(this).val(inputVal.replace(/[^a-z0-9_\.\-]/gi,''));
// 				$(this).val(inputVal.replace(/[^a-z0-9]/gi,''));
			}
		});

		$("#selectMail").change(function() {
			$("#selectMailDiv").hide();
			$("#secondId").val($(this).val());
			$("#secondId").show();
		});

		/////////////////////////////////////////////////////////////////////////
		/**************************사용자 중복 ID 체크 시작******************************/
		$("#checkId").click(function() {

			var firstId = $("#firstId").val();
			var secondId = $("#secondId").val();
			var email = firstId+"@"+secondId;

			if("" == firstId || "" == secondId) {
				alert("사용자 ID를 입력하세요.");

				if("" == firstId) {
					$("#firstId").focus();
				} else {
					$("#secondId").focus();
				}

				return;
			}

			//email유형 체크
			if(!emailCheck(email)) {
				alert("유효하지 않은 사용자 ID 입니다.");
				return;
			}

			//ajax 중복ID 확인
			$.ajax({
				url: '<c:url value="/onmap/public/getusid.json"/>',
				type:"POST",
				data: {"userId":email },
				success:function(data) {

					if(0 != data.cnt) {
						$("#msgId").text("이미 사용중인 아이디 입니다.");
					} else {
						alert("사용 가능한 ID 입니다.");
						$("#msgId").text("");
						$("#userId").val(email);
						$("#checkIdYn").val("Y");
					}

				},
				error:function() {

				}
			});
		});
		/**************************사용자 중복 ID 체크 종료******************************/
		/////////////////////////////////////////////////////////////////////////


		/////////////////////////////////////////////////////////////////////////
		/********************************시군구 조회 시작******************************/
// 		$("#megaCd").change(function() {
			
// 			var megaCd = $(this).val();

// 			$("#ctyCd").empty();
// 			$("#ctyCd").append("<option value=''>시/군/구</option>");

// 			$.ajax({
// 				url:'/common/area_select_option.json',
// 				type:"POST",
// 				data:{
// 					"rgnClss":"H3",
// 					"megaCd":megaCd
// 				},
// 				async: false,
// 				success: function(data){

// 					for(var i = 0; i < data.length; i++) {
// 						var dataMap = data[i];
// 						$("#ctyCd").append("<option value=" + dataMap.id + ">" + dataMap.nm + "</option>");
// 					}

// 				}
// 			});
// 		});
		/********************************시군구 조회 종료******************************/
		/////////////////////////////////////////////////////////////////////////

		///////////////////////////////////////////////////////////////////////////////
		/********************************시군구 등록 여부 조회 시작******************************/
// 		$("#ctyCd").change(function() {

// 			$("#ctyCdYn").val("N");

// 			var megaCd = $("#megaCd").val();
// 			var ctyCd = $(this).val();

// 			$.ajax({
// 				url:'/onmap/public/getpublic.json',
// 				type:"POST",
// 				data:{
// 					"megaCd":megaCd,
// 					"ctyCd":ctyCd
// 				},
// 				async: false,
// 				success: function(data){
// 					if(0 == data.cnt) {
// 						$("#msgaMeg").show();
// 						$("#ctyCdYn").val("N");
// 					} else if(1 == data.cnt) {
// 						$("#msgUserMeg").show();
// 						$("#ctyCdYn").val("N");
// 					} else {
// 						$("#msgUserMeg").hide();
// 						$("#msgaMeg").hide();
// 						$("#ctyCdYn").val("Y");
// 					}
// 				}
// 			});
// 		});
		/********************************시군구 등록 여부 조회 종료******************************/
		///////////////////////////////////////////////////////////////////////////////
		
		///////////////////////////////////////////////////////////////////////////////
		/********************************인증키 체크 시작******************************/
		$("#checkAuthKey").click(function() {

			$("#checkKeyYn").val("N");

			var authKey = $("#authKey").val();

			$.ajax({
				url:'/onmap/public/getpublic.json',
				type:"POST",
				data:{
					"authKey":authKey
				},
				async: false,
				success: function(data){
					
					if(0 == data.cnt) {				// 인증키가 일치하는게 없음
						$("#msgFailMeg").show();
						$("#msgUserMeg").hide();
						$("#checkKeyYn").val("N");
					} else if(1 == data.cnt) {		// 사용자 정원초과
						$("#msgUserMeg").show();
						$("#msgFailMeg").hide();
						$("#checkKeyYn").val("N");
					} else {						// 인증 성공
						$("#msgUserMeg").hide();
						$("#msgFailMeg").hide();
						$("#publicId").val(data.publicId);
						$("#checkKeyYn").val("Y");
						alert("인증키 확인이 완료되었습니다.");
					}
				}
			});
		});
		/********************************인증키 체크 종료******************************/
		///////////////////////////////////////////////////////////////////////////////

		///////////////////////////////////////////////////////////////////////////////
		/********************************사용자 정보 저장 시작*********************************/
		$("#btnUserRegist").click(function() {
			var checkIdYn = $("#checkIdYn").val();
			var checkKeyYn = $("#checkKeyYn").val();
// 			var ctyCdYn = $("#ctyCdYn").val();

// 			var megaNm = $("#megaCd :selected").text();
// 			var ctyNm = $("#ctyCd :selected").text();

			if("N" == checkIdYn) {
				alert("사용자ID를 중복체크해주세요.");
				return;
			}
			
			if("N" == checkKeyYn || $("#publicId").val() == '') {
				alert("기관 인증키 체크를 해주세요.");
				return;
			}

// 			if("N" == ctyCdYn) {
// 				alert("사용기관 인증이 필요 합니다.")
// 				return;
// 			}

			if(!validation()) {
				return;
			}

			alert("가입 승인 이메일을 발송 중입니다.");

			$.ajax({
				url: '<c:url value="/onmap/public/setuser_regist.json"/>',
				type:"POST",
				data: { "userId":$("#userId").val()
					  , "userNm":$("#userNm").val()
					  , "password":$("#regPassword").val()
					  , "publicId":$("#publicId").val()
					  },
				success:function(data) {

					if("ok" == data.resultMsg) {

						$("#regist02Div").hide();
						$("#regist03Div").show();

						var userNo = data.userNo;

						$("#userNo").val(userNo);
					}

				},
				error:function(e) {
					alert("관리자에게 문의해 주세요.");
				}
			});

		});
		/********************************사용자 정보 저장 종료*********************************/
		///////////////////////////////////////////////////////////////////////////////

		/************************************회원 가입 정보입력 종료************************************************/
		///////////////////////////////////////////////////////////////////////////////////////////////////

		//승인 매일 재발송
		$("#btnResnd").click(function() {
			var userId = $("#userId").val();
			var userNo = $("#userNo").val();

			$.ajax({
				url:'<c:url value="/onmap/public/setmber_resnd.json"/>',
				type:"POST",
				data:{
					"userId":userId,
					"userNo":userNo
				},
				async: false,
				success: function(data){
	 				alert("승인 메일을 재발송 했습니다.");

				}
			});
		});

		$("#btnConfirm").click(function() {
			$("#btnLogin").trigger("click");
		});
	});


	function validation() {
		var fObj = $("#firstId");
		var sObj = $("#secondId");
		var uObj = $("#userNm");
		var pObj = $("#regPassword");
		var rpObj = $("#repassword");
		
		var firstId = fObj.val();
		var secondId = sObj.val();
		var userNm = uObj.val();
		var password = pObj.val();
		var repassword = rpObj.val();

		if("" == firstId) {
			alert("사용자 ID를 입력하세요.");
			fObj.focus();
			return false;
		}

		if("" == secondId) {
			alert("사용자 ID를 입력하세요.");
			sObj.focus();
			return false;
		}

		if("" == userNm) {
			alert("사용자 이름을 입력하세요");
			uObj.focus();
			return false;
		}

		if("" == password) {
			alert("비밀번호를 입력하세요.");
			pObj.focus();
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

		if("" == repassword) {
			alert("비밀번호 확인을 입력하세요.");
			rpObj.focus();
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

	function emailCheck(email) {
		var exptext = /^[A-Za-z0-9_\.\-]+@[A-Za-z0-9\-]+\.[A-Za-z0-9\-]+/;

		if(exptext.test(email) == false){
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