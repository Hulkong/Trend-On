<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<script type="text/javascript">
$(document).ready(function() {
	
	var parentJq = $('#contents');            // 기관수정 제이쿼리 루트 셀렉터
	var jq = $('#popup');			         // 계약정보 추가 제이쿼리 루트 셀렉터
	var orgId = '${param.orgId}';		     // 기관 아이디 
	var contractId = '${param.contractId}';   // 계약 아이디
	var serviceClss = '${param.serviceClss}';   // 계약 아이디
	
	/**
	 * @description 필수 입력값 체크하는 함수
	 */
	function validation() {
		var serviceClss = jq.find("#serviceClss");       // 서비스 유형 
		var contractOrgan = jq.find("#contractOrgan");   // 계약 담당회사명 
		var contractNm = jq.find("#contractNm");         // 계약 담당자명 
		var contractFee = jq.find("#contractFee");       // 계약 금액
		var useStrDate = jq.find("#useStrDate");         // 서비스 사용 시작일 
		var useExpDate = jq.find("#useExpDate");         // 서비스 사용 종료일 
		var megaCd = parentJq.find("#megaCd");           // 서비스 시도코드 
		var ctyCd = parentJq.find("#ctyCd");             // 서비스 시군구코드 

		if("" == serviceClss.val()) {
			alert("서비스 유형을 선택해 주세요.");
			serviceClss.focus();
			return false;
		}

		if("" == contractOrgan.val()){
			alert("계약 담당자(회사명)를 입력해 주세요.");
			contractOrgan.focus();
			return false;
		}
		
		if("" == contractNm.val()){
			alert("계약 담당자(담당자 이름)를 입력해 주세요.");
			contractNm.focus();
			return false;
		}
		
		if("" == contractFee.val()){
			alert("계약 금액읋 입력해 주세요.");
			contractNm.focus();
			return false;
		}

		if("" == useStrDate.val()) {
			alert("서비스 사용 시작일을 입력해 주세요.");
			useStrDate.focus();
			return false;
		}

		if(isNaN(useStrDate.val())) {
			alert("서비스 사용 시작일이 숫자가 아닙니다.");
			useStrDate.focus();
			return false;
		}
		
		if(8 > (useStrDate.val()).length) {
			alert("서비스 사용 시작일을 잘못 입력했습니다. \n다시 입력해 주세요");
			useStrDate.focus();
			return false;
		}

		if("" == useExpDate.val()) {
			alert("서비스 사용 종료일을 입력해 주세요.");
			useExpDate.focus();
			return false;
		}

		if(isNaN(useExpDate.val())) {
			alert("서비스 사용 종료일이 숫자가 아닙니다.");
			useExpDate.focus();
			return false;
		}
		
		if(8 > (useExpDate.val()).length) {
			alert("서비스 사용 종료일을 잘못 입력했습니다. \n다시 입력해 주세요");
			useExpDate.focus();
			return false;
		}

		if(useStrDate.val() > useExpDate.val()) {
			alert("서비스 사용 종료일은 서비스 사용 시작일 보다 작으면 안됩니다.");
			useExpDate.focus();
			return false;
		}
		
		if("" == megaCd.val()) {
			alert("서비스 지역을 선택해 주세요.");
			megaCd.focus();
			return false;
		}
		
		if("" == ctyCd.val()) {
			alert("서비스 지역을 선택해 주세요.");
			ctyCd.focus();
			return false;
		}

		return true;
	}
	
	// 팝업 닫기
	jq.find(".btn_close").click(function() {				
		jq.dialog('close');
	});

	// 서비스 사용기간 버튼 클릭
	jq.find(".group_btn button").click(function(){
		var dataVal = $(this).data("val");
		var sDate = jq.find(".useStrDate").val();
		
		if("" == sDate){
			alert("서비스 사용 시작일을 먼저 설정해주세요.");
			return false;
		}else{
			if("" != dataVal) {
				setMonth("useStrDate", "useExpDate", dataVal, sDate);
			}			
		}
	});

	// 확인버튼 클릭 이벤트
	jq.find("#btnPopSave").click(function() {
		
		if(!confirm('정말 수정하시겠습니까?')) {
			return;
		}
		
		// 필수 입력값 검증
 		if(!validation()) {
			return;
		}

		// orgId, megaCd, ctyCd form태그에 추가
 		jq.find('#popForm').append('<input type="hidden" name="orgId" value="' + orgId + '"/>');
 		jq.find('#popForm').append('<input type="hidden" name="contractId" value="' + contractId + '"/>');
		$.ajax({
			url: '/onmap/admin/modifiedContract.json',
			type:"POST",
			async: true,
			data: $("#popForm").serialize(),
			dataType: 'json',
			success:function(data) {
 				
				
				if(data.resultCode > 0) {
					alert("계약 수정을 완료 했습니다.");
					location.reload();
					
				} else {
					alert(data.resultMsg);
				}
			},
			error:function(e) {
				alert("관리자에게 문의해 주세요.");
			}
		});
	});
	
	// 서비스 유형 DOM 생성 
	getCommonCodeList({code: 'SERVICE_CLSS'}, function(data) {
		
		var options = '';
		
		data.forEach(function(d, i) {
			options += '<option value="' + d['code'] + '">' + d['cd_nm'] + '</option>';
		});
		
		jq.find('#serviceClss').append(options);
		jq.find('#serviceClss').val(serviceClss);
	});
	
	// 계약정보 수정 값 세팅
	getContract({
		orgId: orgId,
		contractId: contractId 
	}, function(data) {
		jq.find("#contractOrgan").val(data['contract_organ']);
		jq.find("#contractNm").val(data['contract_nm']);
		jq.find("#contractFee").val(data['contract_fee']);
		jq.find("#useStrDate").val(data['use_str_date']);
		jq.find("#useExpDate").val(data['use_exp_date']);
		jq.find("#rm").val(data['rm']);
	})
});
</script>

<div id="popwrap">
	<!-- header -->
	<div id="popHeader">
		<h1 class="pop_tit">계약정보 수정</h1>
		<a href="#none" class="btn_close">닫기</a>
	</div>
	<!-- //header -->

	<hr />

	<!-- contents -->
	<div id="popContents">
		<!-- 본문 ==================================================================================================== -->
		<div class="brd_wrap">
			<form name="popForm" id="popForm">
			<table class="brd_write left_header">
				<colgroup>
					<col width="150px" />
					<col width="*" />
				</colgroup>
				<tr>
					<th scope="row">서비스 유형</th>
					<td>
						<select name="serviceClss" id="serviceClss"></select>
					</td>
				</tr>
				
				<tr>
					<th scope="row">계약 담당자<br/>(회사명 / 담당자)</th>
					<td>
						<input type="text" name="contractOrgan" id="contractOrgan" value="" />&nbsp/&nbsp 
						<input type="text" name="contractNm" id="contractNm" value="" />
					</td>
				</tr>
				<tr>
					<th scope="row">계약금액(원)</th>
					<td>
						<input type="text" name="contractFee" id="contractFee" value="" />
					</td>
				</tr>
				
				<tr>
					<th scope="row">서비스 사용 시작일</th>
					<td>
						<input type="text" name="useStrDate" id="useStrDate" class="pop_calendar" value="" maxlength="8" />
					</td>
				</tr>
				
				<tr>
					<th scope="row">서비스 사용 기간</th>
					<td>
						<div class="group_btn">
							<button type="button" data-val="1">1개월</button>
							<button type="button" data-val="3">3개월</button>
							<button type="button" data-val="6">6개월</button>
							<button type="button" data-val="12">1년</button>
							<button type="button" data-val="">사용자 지정</button>
						</div>
					</td>
				</tr>
				
				<tr>
					<th scope="row">서비스 사용 종료일</th>
					<td>
						<input type="text" name="useExpDate" id="useExpDate" class="pop_calendar" value="" maxlength="8" />
					</td>
				</tr>
				<tr>
					<th scope="row">비고</th>
					<td>
						<textarea name="rm" id="rm" style="height:150px; !important"></textarea>
					</td>
				</tr>
			</table>
			</form>
		</div>

		<!-- //본문 ==================================================================================================== -->
	</div>
	<!-- //contents -->

	<hr />

	<!-- footer -->
	<div id="popFooter">
		<ul>
			<li><a href="#none" id="btnPopSave" class="btn_confirm">확인</a></li>
			<li><a href="#none" id="btnCancel" class="btn_cancel btn_close">취소</a></li>
		</ul>
	</div>
	<!-- //footer -->
</div>
