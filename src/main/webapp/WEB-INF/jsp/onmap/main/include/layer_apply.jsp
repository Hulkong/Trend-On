<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<form id="userApplyForm"  method="post" >
<input type="hidden" name="newsletterYn" id="newsletterYn" value="N"/>
	<!-- 사용신청 -->
	<div class="pop_layer2 layer_request layer_div" id="applyDiv" style="display:none;">
		<div class="layer_top non_boder">
			<p class="tit">사용신청하기</p>
			<a href="#" class="btn_close">닫기</a>
		</div>
		<div class="con_top">
			<p class="tit">Trend-ON 서비스 사용신청  </p>
			<p class="txt">‘지방자치단체’, ‘공공기관’을 대상으로 사용신청을 받고 있습니다.</p>
			<p class="txt2">개인, 민간기업의 사용신청은sales@openmate-on.co.kr로 문의주시기 바랍니다.</p>
		</div>
		<div class="layer_con">
			<p class="txt_notice">*는 필수 입력 항목입니다.</p>
			<dl class="dl_write2">
				<dt>* 이름</dt>
				<dd><input type="text" class="inp_full" name="name" id="name" /></dd>

				<dt>* 기관정보(기관명 | 담당부서 | 직함)</dt>
				<dd>
					<input type="text" class="inp_co" placeholder="기관명" name="orgNm" id="orgNm" />
					<input type="text" class="inp_co" placeholder="담당부서" name="dept" id="dept" />
					<input type="text" class="inp_co" placeholder="직함" name="position" id="position" />
				</dd>

				<dt>* 연락처</dt>
				<dd><input type="text" class="inp_full" placeholder="010-0000-0000" name="mobile" id="mobile"/></dd>

				<dt>* 이메일</dt>
				<dd><input type="text" class="inp_full" name="email" id="email" /></dd>

				<dt>사용 신청 내용</dt>
				<dd>
					<textarea cols="5" rows="2" name="memo" id="memo" placeholder="OO시 일자리경제과 담당자 입니다. OO시 ‘ㅇㅇ축제’의 정량적인 효과 확인을 위해  서비스사용신청 문의드립니다."></textarea>
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
				<li><a href="#" class="btn_cancel">취소</a></li>
			</ul>
		</div>
	</div>
	<!-- //사용신청 -->
</form>


<!-- 사용신청_완료 -->
<div class="pop_layer2 layer_request_fns layer_div" id="applyFinish" style="display:none;">
	<div class="layer_top">
		<p class="tit">사용신청 완료</p>
<!-- 		<a href="#" class="btn_close">닫기</a> -->
	</div>
	<div class="layer_con">
		<div class="group_txt">
			<p class="tit">Trend-ON서비스 사용신청이 완료되었습니다.</p>
			<p class="txt">담당자 확인후 연락 드리겠습니다</p>
			<p class="txt">감사합니다!</p>
		</div>
	</div>
	<div class="layer_btm">
		<ul>
			<li><a href="#" class="btn_confirm btn_close">완료</a></li>
<!-- 			<li><a href="#" class="btn_cancel">닫기</a></li> -->
		</ul>
	</div>
</div>
<!-- //사용신청_완료-->


<script type="text/javascript">
	$(document).ready(function() {
		
// 		test();
		
// 		function test() {
// 			$('#name').val('김용현');
// 			$('#orgNm').val('오픈메이트온');
// 			$('#dept').val('데이터서비스');
// 			$('#position').val('매니저');
// 			$('#mobile').val('010-2763-9988');
// 			$('#email').val('y_h_kim@openmate-on.co.kr');
// 		}

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
			// 버튼 비활성화
			$('#useApply').css({ 'pointer-events': 'none' });
			
			// 뉴스레터 체크
			if($("#letter_yn").is(":checked")){
				$("#newsletterYn").val("Y");
			}else{
				$("#newsletterYn").val("N");
			}
			
			// 필수입력항목 체크
			if(validateChk()){
				
				// 이메일 타입 & 현재날짜 form 태그에 추가
		 		$('#userApplyForm').append('<input type="hidden" name="emailType" value="useApply"/>');
		 		$('#userApplyForm').append('<input type="hidden" name="date" value="' + getTodayType() + '"/>');
				
				// 신청서 등록
				$.ajax({
					url:"/onmap/member/useApplyProc.json",
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
			}else{
				$('#useApply').css({ 'pointer-events': '' });
			}
		});
		
	});
    
	// yyyy-mm-dd 날짜로 리턴하는 함수
	function getTodayType() {
		var date = new Date();
		return date.getFullYear() + "-" + ("0" + (date.getMonth() + 1)).slice(-2) + "-" + ("0" + date.getDate()).slice(-2);
	}
	
	function onKeyDown(){
	    if(event.keyCode == 13){
	    	$("#useApply").click();
	    }
	}
	
	function validateChk() {
		var name = $("#name").val().trim();
		var orgNm = $("#orgNm").val().trim();
		var dept = $("#dept").val().trim();
		var position = $("#position").val().trim();
		var mobile = $("#mobile").val().trim();
		var email = $("#email").val().trim();
		
		if(name.length < 1){
			$("#name").focus();
			alert("이름을 입력해주세요.");
			return false;
		}
		
		if(orgNm.length < 1){
			$("#orgNm").focus();
			alert("기관명을 입력해주세요.");
			return false;
		}
		
		if(dept.length < 1){
			$("#dept").focus();
			alert("담당부서를 입력해주세요.");
			return false;
		}
		
		if(position.length < 1){
			$("#position").focus();
			alert("직함을 입력해주세요.");
			return false;
		}
		
		if(mobile.length < 1){
			$("#mobile").focus();
			alert("연착처를 입력해주세요.");
			return false;
		}

		if(email.length < 1){
			$("#email").focus();
			alert("이메일을 입력해주세요.");
			return false;
		}
		
		var policyChk = $("#use_yn").is(":checked");
		if(policyChk == false) {
			alert("이용회원 약관 및 개인정보 취급방침에 동의해 주세요");
			return false;
		}
		
		return true;
	}
</script>
