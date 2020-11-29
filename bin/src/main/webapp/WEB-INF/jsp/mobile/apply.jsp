<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0">

	<title>Tread-ON</title>
	<link rel="shortcut icon" type="image/x-icon" href="/images/common/favicon.ico" />
	<link rel="stylesheet" href="/css/import.css?ver=${globalConfig['config.version']}" />
  	<link rel="stylesheet" href="/css/reset.css?ver=${globalConfig['config.version']}"  />
	<link rel="stylesheet" href="/css/common.css?ver=${globalConfig['config.version']}"  />
	<link rel="stylesheet" href="/css/style.css?ver=${globalConfig['config.version']}"  />
	<link rel="stylesheet" href="/css/dev.css?ver=${globalConfig['config.version']}"  />
	<link rel="stylesheet" href="/css/mobile.css?ver=${globalConfig['config.version']}" />
	<script src="/js/jquery/jquery-1.11.2.min.js"></script>
	<script src="/js/main.js?ver=${globalConfig['config.version']}"></script>
	<script>
		$(document).ready(function(){
			var isMobile = deviceChk();
			if(!isMobile){
				location.href="/";
			}
			
			// 창닫기
			$(".btn_cancel2").click(function(){
//				if (navigator.userAgent.indexOf("Firefox") != -1 || navigator.userAgent.indexOf("Chrome") !=-1) {
//					window.location.href="about:blank";
//			        window.close();
//			    } else {
//			        window.opener = null;
//			        window.open("", "_self");
//			        window.close();
//			    }


				try {
				    if (window.opener && !window.opener.closed) {
				        window.opener.함수호출();
				    }
				
				    if (navigator.appVersion.indexOf("MSIE") >= 0) {
				        top.window.opener = top;
				        top.window.open('','_parent','');
				        top.window.close();
				    } else {
				        window.open('about:blank','_self').close();
				    }
				} catch(e) {
				    window.opener = self;
				    self.close();
				}

			});
			
			//전체선택 체크박스 클릭
			$("#chkAll").click(function(){ 
				if($("#chkAll").prop("checked")) {    //만약 전체 선택 체크박스가 체크된상태일경우 
					//해당화면에 전체 checkbox들을 체크해준다 
					$("#chkbox").find("input[type=checkbox]").prop("checked",true); 
					
				} else { 	// 전체선택 체크박스가 해제된 경우 
					//해당화면에 모든 checkbox들의 체크를해제시킨다. 
					$("#chkbox").find("input[type=checkbox]").prop("checked",false); 
				} 
			});

			
			$("#useApply").click(function() {

				// 뉴스레터 체크
				if($("#letter_yn").is(":checked")){
					$("#newsletterYn").val("Y");
				}else{
					$("#newsletterYn").val("N");
				}
				
				// 필수입력항목 체크
				if(validateChk()){
					var mobileNum = $("#mobile1").val().trim() + "-" + $("#mobile2").val().trim() + "-" + $("#mobile3").val().trim(); 
					$("#mobile").val(mobileNum);
					
					// 신청서 등록
					$.ajax({
						url:"/onmap/public/useApplyProc.json",
						data:$("#userApplyForm").serialize(),
						type:"POST",
						success:function(state){
							if(state == 1){
								// form 초기화
								$("#chkbox").find("input[type=checkbox]").prop("checked",false);
								$("#userApplyForm")[0].reset();
								
								// popup 닫기 & 성공 popup 열기
								$("#applyDiv").hide();
								$("#applyFinish").show();	
							}else{
								alert("다시 시도해주세요.");
								return false;
							}
						}
					});
					
				}

			});
		});
		
		function validateChk(){
			var name = $.trim($("#name").val());
			var orgNm = $("#orgNm").val().trim();
			var dept = $("#dept").val().trim();
			var position = $("#position").val().trim();
			var mobile1 = $("#mobile1").val().trim();
			var mobile2 = $("#mobile2").val().trim();
			var mobile3 = $("#mobile3").val().trim();
			var email = $("#email").val().trim();
			
			if(name.length < 1){
				$("#name").focus();
				if($("#name").parent().find("p").length == 0) $("#name").parent().append("<p>이름을 적어주세요.</p>");
				return false;
			}
			
			if(orgNm.length < 1){
				$("#orgNm").focus();
				if($("#orgNm").parent().find("p").length == 0) $("#orgNm").parent().append("<p>기관명을 적어주세요.</p>");
				return false;
			}
			
			if(dept.length < 1){
				$("#dept").focus();
				if($("#dept").parent().find("p").length == 0) $("#dept").parent().append("<p>담당부서를 입력해주세요.</p>");
				return false;
			}
			
			if(position.length < 1){
				$("#position").focus();
				if($("#position").parent().find("p").length == 0) $("#position").parent().append("<p>직함을 입력해주세요.</p>");
				return false;
			}
			
			if(mobile1.length < 1){
				$("#mobile1").focus();
				if($("#mobile1").parent().find("p").length == 0) $("#mobile1").parent().append("<p>연착처를 입력해주세요.</p>");
				return false;
			}
			if(mobile2.length < 1){
				$("#mobile2").focus();
				if($("#mobile1").parent().find("p").length == 0) $("#mobile1").parent().append("<p>연착처를 입력해주세요.</p>");
				return false;
			}
			if(mobile3.length < 1){
				$("#mobile3").focus();
				if($("#mobile1").parent().find("p").length == 0) $("#mobile1").parent().append("<p>연착처를 입력해주세요.</p>");
				return false;
			}

			if(email.length < 1){
				$("#email").focus();
				if($("#email").parent().find("p").length == 0) $("#email").parent().append("<p>이메일을 입력해주세요.</p>");
				return false;
			}
			
			var policyChk = $("#use_yn").is(":checked");
			if(policyChk == false) {
				alert("이용회원 약관 및 개인정보 취급방침에 동의해 주세요");
				return false;
			}
			
			return true;
		}
		
		function remveAlarm(obj){
			if($(obj).attr("id").indexOf("mobile") != -1) obj = $("#mobile1");
			if($(obj).parent().find("p").length > 0) $(obj).parent().find("p").remove();
		}
	</script>
</head>
<body>


	<div id="applyDiv">
		<!--header s  -->
		<div id="wrap_head">
			<h1 class="main_logo bold helv">
				<a href="/" id="logo"><img src="/images/common/logo2.png" alt="Trend-ON"></a>
			</h1>
			<div id="content">
				<div class="con_top">
					<p class="tit">Trend-ON 서비스 사용신청  </p>
					<p class="txt">‘지방자치단체’, ‘공공기관’을 대상으로 <br/>사용신청을 받고 있습니다.</p>
				</div>
			</div>
		</div>
		<!-- header e  -->
		<!-- article s  -->
		<div id="main">
			<form id="userApplyForm"  method="post" >
			<input type="hidden" name="newsletterYn" id="newsletterYn" value="N"/>
			<input type="hidden" name="mobile" id="mobile" value=""/>
				<div class="layer_con">
					<p class="txt_notice">*는 필수 입력 항목입니다.</p>
					<dl class="dl_write2">
						<dt>* 이름</dt>
						<dd>
							<input type="text" class="inp_full" name="name" id="name" onkeydown="remveAlarm(this);"/>
						</dd>
		
						<dt>* 기관명</dt>
						<dd>
							<input type="text" class="inp_co" placeholder="기관명" name="orgNm" id="orgNm" onkeydown="remveAlarm(this);" />
						</dd>
						<dt>* 담당부서</dt>
						<dd>
							<input type="text" class="inp_co" placeholder="담당부서" name="dept" id="dept" onkeydown="remveAlarm(this);" />
						</dd>
						<dt>* 직함</dt>
						<dd>
							<input type="text" class="inp_co" placeholder="직함" name="position" id="position" onkeydown="remveAlarm(this);" />
						</dd>
		
						<dt>* 연락처</dt>
						<dd>
							<input type="tel" placeholder="010" class="inp_num" name="mobile1" id="mobile1" onkeydown="remveAlarm(this);"/> - 
							<input type="tel" placeholder="0000" class="inp_num" name="mobile2" id="mobile2" onkeydown="remveAlarm(this);"/> - 
							<input type="tel" placeholder="0000" class="inp_num" name="mobile3" id="mobile3" onkeydown="remveAlarm(this);"/>
						</dd>
		
						<dt>* 이메일</dt>
						<dd><input type="text" class="inp_full" name="email" id="email" onkeydown="remveAlarm(this);"/></dd>
		
						<dt>사용 신청 내용</dt>
						<dd>
							<textarea cols="5" rows="5" name="memo" id="memo" placeholder="OO시 일자리경제과 담당자 입니다. OO시 ‘ㅇㅇ축제’의 정량적인 효과 확인을 위해  서비스사용신청 문의드립니다."></textarea>
						</dd>
					</dl>
				</div>
				<div class="con_btm" id="chkbox" >
					<label><input type="checkbox" id="chkAll"/><em>전체 동의</em></label>
					<label><input type="checkbox" name="use_yn" id="use_yn"/>이용약관 및 개인정보 취급방침 동의 (필수)</label>
					<label><input type="checkbox" name="letter_yn" id="letter_yn"/>오픈메이트온 뉴스레터 수신 동의 (선택)</label>
				</div>
				<div class="layer_btm">
					<ul>
						<li><a href="#" class="btn_confirm" id="useApply">사용 신청하기</a></li>
						<!-- <li><a href="#" class="btn_cancel">취소</a></li> -->
					</ul>
				</div>
			</form>
		</div>
	</div>	
	<div id="applyFinish" style="display:none;">
	<!--header s  -->
		<div id="wrap_head">
			<h1 class="main_logo bold helv">
				<a href="/" id="logo"><img src="/images/common/logo2.png" alt="Trend-ON"></a>
			</h1>
			<div id="content">
				<div class="con_top con_top2">
					<p class="tit">Trend-ON 서비스 사용신청이</br> 완료되었습니다. </p>
				</div>
			</div>
		</div>
		<div class="layer_con">
			<div class="group_txt">
<!-- 				<p class="tit">Safe-ON서비스 사용신청이 완료되었습니다.</p> -->
				<p class="finishImg"><img src="/images/sample/finish.png" width="50%"/></p>
				<p class="txt">담당자 확인후 연락 드리겠습니다</p>
				<p class="txt">감사합니다!</p>
			</div>
		</div>
		<div class="layer_btm">
			<ul>
				<li><a href="/" class="btn_cancel">트렌드온으로 가기</a></li>
			</ul>
		</div>
	</div>
	<!-- article e  -->
	<!-- footer -->
	<div id="footer" class="footer_main2">
		<div class="inner">
			<ul class="f_menu">
				<li><a href="/common/policy.html?page=0" target="_self">서비스 약관</a></li>
				<li><a href="/common/policy.html?page=1" target="_self">개인정보 취급방침</a></li>
				<li><a href="http://www.openmate-on.co.kr/" target="_blank">회사소개</a></li>
			</ul>
			<p class="copyright">Copyright ⓒ OPENmate_ON All rights reserved.</p>
		</div>
	</div>
	<!-- //footer -->
</body>
</html>