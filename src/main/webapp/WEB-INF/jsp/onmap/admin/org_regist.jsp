<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!doctype html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/jsp/onmap/admin/include/library.jsp" %>
<script type="text/javascript">
$(document).ready(function() {

	// 기관등록 제이쿼리 루트 셀렉터
	var jq = $('#contents');
	
	// 테스트 파라미터 세팅 
	function test() {
		$("#orgNm").val('테스트_김용현');      
		$("#userId").val("seoul-gangnamgu");
		$("#mngNm").val('테스트_김용현');        
		$("#mngMobile").val('010-1111-1111');    
		$("#mngEmail").val('y_h_kim@openmate-on.co.kr');     
		$("#contractOrgan").val('테스트_김용현');
		$("#contractNm").val('테스트_김용현');   
		$("#useStrDate").val('20190815');   
		$("#useExpDate").val('20190915');   
	 }
	
	/**
	 * @description 필수 입력값 체크하는 함수
	*/ 
	
	function validation() {
		var orgNm = jq.find("#orgNm");                   // 기관명
		var megaCd = jq.find("#megaCd");                 // 시도코드 
		var ctyCd = jq.find("#ctyCd");                   // 시군구코드 
		var userId = jq.find('#userId');                 // 유저아이디 
		var mngNm = jq.find("#mngNm");                   // 담당자명 
		var mngMobile = jq.find("#mngMobile");           // 담당자 연락처(mobile)
		var mngEmail = jq.find("#mngEmail");             // 담당자 이메일
		var serviceClss = jq.find("#serviceClss");       // 서비스 유형 
		var contractOrgan = jq.find("#contractOrgan");   // 계약 담당회사명 
		var contractNm = jq.find("#contractNm");         // 계약 담당자명 
		var useStrDate = jq.find("#useStrDate");         // 서비스 사용 시작일 
		var useExpDate = jq.find("#useExpDate");         // 서비스 사용 종료일 

		if("" == orgNm.val()) {
			alert("기관명을 입력해 주세요.");
			orgNm.focus();
			return false;
		}

		
		var megaLength = $("select[name='megaCd']").length;
		var megaArr = new Array(megaLength);
		var cityArr = new Array(megaLength);
		
 		for(var i=0; i<megaLength; i++){                          
 	         megaArr[i] = $("select[name='megaCd']")[i].value;
 	         cityArr[i] = $("select[name='ctyCd']")[i].value;
 	         if("" == megaArr[i]) {
 			 	alert("시도를 선택해 주세요.");
 				$('#serviceTh').focus();
 				return false;
 		 	 }
 	         if( cityArr[i] == "" ){
 	        	alert("시군구를 선택해 주세요.");
 				$('#serviceTh').focus();
 				return false;
 	         }
 	    }
 		
		if("" == userId.val()) {
			alert("아이디를 입력해 주세요.");
			userId.focus();
			return false;
		}
		
		if(jq.find('#dupUserId').text().length > 0) {
			alert("중복된 아이디입니다.");
			userId.focus();
			return false;
		}
		
		if("" == mngNm.val()) {
			alert("기관 담당자명을 입력해 주세요.");
			mngNm.focus();
			return false;
		}

		if("" == mngMobile.val()) {
			alert("기관 담당자의 연락처를 입력해 주세요.");
			mngMobile.focus();
			return false;
		}
		
		// 핸도픈번호 정규식 
		var pheonRegExp = /^\d{3}-\d{3,4}-\d{4}$/;
		if(!pheonRegExp.test(mngMobile.val())) {
			alert('000-0000-0000 형식으로 입력해 주세요.');
			mngMobile.focus();
			return false;
		}
		
		if("" == mngEmail.val()) {
			alert("기관 담당자의 이메일을 입력해 주세요.");
			mngEmail.focus();
			return false;
		}
		
		// 이메일 정규식
		var emailRule = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
		if(!emailRule.test(mngEmail.val())) {            
			alert("올바른 이메일형식으로 입력해 주세요.");
			mngEmail.focus();
			return false;
		}

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

		return true; 
		
	}

	
	// 아이디 중복확인 
	jq.find('#userId').keydown(_.debounce(function(e) {
		
		var userId = $(this).val();
		
		// 입력값이 있을 경우 
		if(userId && userId.length > 0) {
			$.ajax({
				url: '/onmap/admin/checkDupUserId.json',
				type: 'POST',
				dataType: 'JSON',
				data: {userId: userId},
				asysc: true,
				success: function(check) {
					
					// 유저아이디가 중복인 경우 
					if(check) {
						$('#dupUserId').text('* 이미 사용중인 아이디입니다.');
						
					// 유저아이디가 중복이지 않은 경우 
					} else {
						$('#dupUserId').text('');
					}
				},
				error: function(a,b,c) {
					console.log(a, b, c)
				}
			});
		}
	}, 800));
	
	
	// 시도 셀렉트박스 체인지 이벤트 
	$(document).on("change", "select[name='megaCd']",function() {
		
		var megaCd = $(this).val();   // 시도코드 
		var that = $(this);
		
		// 중복 제거 - 상위에 전체가 있으면 선택 안되게 
		var megaCdArrLength = $("select[name='megaCd']").length;
		for( var i=0; i < megaCdArrLength; i++ ) {
			// 내가 선택한 시도랑 기존 시도랑 같은데 선택된 시군구가 전체일 때 false
			if( $("select[name='megaCd']").eq(i).not(this).val() == megaCd ) {
				if( $("select[name='ctyCd']").eq(i).val().substring(2,5) == '000' ) {
					$(this).val('');
					$(this).siblings('select').empty()
					$(this).siblings('select').append('<option value="">::: 시군구</option>')
					alert('해당 시도의 전체가 시군구가 이미 추가되었습니다.')
					return;
				}
			}
		}
		
		// 중복 제거 - 상위에 cty_cd가 중복이면 선택 안되게
		// 해당 시도코드에 대한 시군구 리스트 DOM 생성  
		getAreaSelectOption({
			rgnClss: 'H3',
			megaCd: megaCd
		}, function(data) {
			
			that.parent().find("select[name='ctyCd']").empty();
			
			if(data.length === 0) {
				var options = '<option value="">::: 시군구</option>';
			} else {
				var allCode = data[0].id.substring(0,2) + '000';
				var options = '<option value="'+allCode+'">::: 전체</option>';
				
				data.forEach(function(d, i) {
					options += '<option value="' + d['id'] + '">' + d['nm'] + '</option>';
				});				
			}
			
			that.parent().find("select[name='ctyCd']").append(options);
			that.parent().find('#refUserId').text('');   // 참고 유저아이디값 초기화 
		});
	});
	
	// 시도 셀렉트박스 체인지 이벤트 
	$(document).on("change", "select[name='ctyCd']",function() {
		
		var ctyCd = $(this).val();
		
		// 중복 제거 - 상위에 전체가 있으면 선택 안되게 
		var megaCdArrLength = $("select[name='megaCd']").length;
		if( megaCdArrLength > 1) {
			for( var i=0; i < megaCdArrLength; i++ ) {
				// 내가 선택한 시도랑 기존 시도랑 같은데 선택된 시군구가 전체일 때 false
				if( $("select[name='ctyCd']").eq(i).not(this).val() == ctyCd ) {
					alert('중복된 시군구를 선택할 수 없습니다.');
					$(this).val(ctyCd.substring(0,2) + '000');
					return;
				}
			}	
		}		
	});
	
	// 행정구역 영어명 조회 
	jq.find("#ctyCd").change(function() {
		
		var megaNm = $("#megaCd option:selected").text();   // 선택된 시도명 
		var ctyNm = $("#ctyCd option:selected").text();     // 선택된 시군구명 
		
		// 시도가 선택된 경우 
		if(megaNm && megaNm.length > 0) {
			$.ajax({
				url: '/onmap/admin/getAdmiDistEngNm.json',
				type: 'POST',
				dataType: 'JSON',
				data: {
					megaNm: megaNm,
					ctyNm: ctyNm
				},
				asysc: true,
				success: function(data) {
					
					// 해당 행정구역 영어명이 있을 경우 
					if(data['admiDistEngNm']) {
						
						// 정제된 행정구역 영어명
						var cleanNm = data['admiDistEngNm'].toLowerCase().replace('-', '').replace(/ /gi, "-");
						$('#refUserId').text(cleanNm);
						
					// 해당 행정구역 영어명이 없을 경우 
					} else {
						$('#refUserId').text('');
					}
				},
				error: function(a,b,c) {
					console.log(a, b, c)
				}
			});
		}
	});
	
	// 사용기간선택
	jq.find(".group_btn button").click(function() {
		var dataVal = $(this).data("val");
		var sDate = jq.find("#useStrDate").val();
		
		if("" == sDate) {
			alert("서비스 사용 시작일을 먼저 설정해주세요.");
			return false;
		} else {
			if("" != dataVal) {
				setMonth("useStrDate", "useExpDate", dataVal, sDate);
			}			
		}
	});

	// 등록버튼 클릭 이벤트 
	jq.find("#btnSave").click(function() {
		
		if(!confirm('정말 등록하시겠습니까?')) {
			return;
		}
		
		// 필수 입력값 검증
 		if(!validation()) {
			return;
		}
 		
		// 이미지파일 확장자 검증
 		var fileObj1 = $("#imgFile1");
 		var fileObj2 = $("#imgFile2");
 		if(fileObj1.val() != "" && fileObj1.val().indexOf(".") != -1) {
 			var ext = fileObj1.val().split(".").pop().toLowerCase();
 			if("jpg,png,jpeg".indexOf(ext) == -1) {
 				alert("이미지 파일만 업로드 할 수 있습니다.");
 				return;
 			}
 		}
 		if(fileObj2.val() != "" && fileObj2.val().indexOf(".") != -1) {
 			var ext = fileObj2.val().split(".").pop().toLowerCase();
 			if("jpg,png,jpeg".indexOf(ext) == -1) {
 				alert("이미지 파일만 업로드 할 수 있습니다.");
 				return;
 			}
 		}
 		
 		jq.find('#dataForm').attr("action", "/onmap/admin/setOrgContract.json");
 		
 		// 추가된 글자와 id를 쌍으로 불러오기
 		var firstObj;
		var ctyListTextArr = [];
		var ctyListCodeArr = [];
		var objArr = [];
		var obj = {};
		
		$("select[name='ctyCd']").map(function(x,sel){
			var val3 = $('#megaCd'+ (x+1) + ' option:selected').text()
		    for(var i=0; i<sel.options.length; i++){
		        if(sel.options[i].selected == true) {
		            var val1 = sel.options[i].text;
		            var val2 = sel.options[i].value;
		            ctyListTextArr.push(val1)
		            ctyListCodeArr.push(val2)
		            obj = {
		                   "id"  : val2,
		                   "nm"  : val1,
		                   'mega': val3 
		                   };
		            objArr.push(obj);
		        } 
		    }
		})
		
		firstObj = objArr.shift();
 		
 		// 1번 소팅
		var length = objArr.length;
		var temp;
		for (var i = 0; i < length - 1; i++) { // 순차적으로 비교하기 위한 반복문
		   for (var j = 0; j < length - 1 - i; j++) { // 끝까지 돌았을 때 다시 처음부터 비교하기 위한 반복문
		     if (objArr[j].id > objArr[j + 1].id) { // 두 수를 비교하여 앞 수가 뒷 수보다 크면
		       temp = objArr[j]; // 두 수를 서로 바꿔준다
		       objArr[j] = objArr[j + 1];
		       objArr[j + 1] = temp;
		     }
		   }
		}
		
		// 중복제거 (전체일 때 하위 도시 삭제)
 		var resultCty = [];
 		var zeroToTwoSub = ' ';
 		objArr.forEach(function(d, i){
 			if(d.id.substring(2, 5) == '000') {
 				zeroToTwoSub = d.id.substring(0, 2); // 11 000
 				resultCty.push(d);
 			} else {
 				if ( !d.id.startsWith(zeroToTwoSub) ) {
 					resultCty.push(d);
 				}
 			}
 		})
		
 		// 배열 분리하기 (그룹핑)
 		var groupObjMap = new Map();
 		var list = [];
 		resultCty.forEach(function(d,i){
 			if ( !groupObjMap.has(d.id.substring(0,2))  ) {
 				groupObjMap.set(d.id.substring(0,2), []);
 			}
 			groupObjMap.get(d.id.substring(0,2)).push(d);
 		})
 		
 		// 도시별로 정렬
 		groupObjMap.forEach(function(d,i){
 			d.sort(function(a, b) { // 한글 오름차순
 	 			return a.nm < b.nm ? -1 : a.nm > b.nm ? 1 : 0;
 	 		});
 		})
 		
 		var resultArr = [];
 		// 처음 값 넣기
 		resultArr.push(firstObj.id)
 		// 소트한 배열 합치기
 		var keyArr = Array.from( groupObjMap.keys());
 		keyArr.forEach(function(x){
 			groupObjMap.get(x).forEach(function(y){
 				resultArr.push(y.id);
 			})
 		})
 		
 		$('#cityArr').val(resultArr);
 		
 		// 등록할때 비고에 추가하기
		var initRm = '';
		var megaLength = $("select[name='megaCd']").length;
 		for(var j=0; j<megaLength; j++){
 			var selMega = $("select[name='megaCd']")[j];
 			var selCty = $("select[name='ctyCd']")[j];
 			var megaNm = $("select[name='megaCd']")[j].options[selMega.selectedIndex].text;
 			var ctyNm = $("select[name='ctyCd']")[j].options[selCty.selectedIndex].text;
 			initRm += megaNm + ' - ' + ctyNm + '\n';
		}
		var oldText = $('#rm').val() + '\n';
		oldText += initRm;
		$('#rm').val(oldText);
 		
 		
 		$('#dataForm').ajaxForm({
 			success: function(data) {
				if(data.resultCode > 0) {
					alert("기관 등록을 완료 했습니다.");
					location.href = '/onmap/admin/org_list.do';
				} else {
					alert(data.resultMsg);
				}
			},
			error: function() {
				alert("에러가 발생했습니다. 관리자에게 문의하세요");
			}
 			
 		}); 
 		
 		$('#dataForm').submit();
 		
// 		$.ajax({
// 			url:'/onmap/admin/setOrgContract.json',
// 			type: "POST",
// 			data: jq.find('#dataForm').serialize(),
// 			dataType: 'json',
// 			async: true,
// 			success: function(data) {
// 				console.log(data)
// 				if(data.resultCode > 0) {
// 					alert("기관 등록을 완료 했습니다.");
// 					location.href = '/onmap/admin/org_list.do';
// 				} else {
// 					alert(data.resultMsg);
// 				}
// 			},
// 			error: function(a, b, c) {
// 				console.log(a,b,c)
// 				alert("에러가 발생했습니다. 관리자에게 문의하세요");
// 			}
// 		});

	});
	
	// 전체 시도 리스트 DOM 생성 
	getAreaSelectOption({rgnClss: 'H1'}, function(data) {
		
		// 시도 리스트 DOM 생성
		var options = '';
		
		data.forEach(function(d, i) {
			options += '<option value="' + d['id'] + '">' + d['nm'] + '</option>'
		});
		
		jq.find('#megaCd1').append(options);
	});
	
	// 서비스 유형 DOM 생성 
	getCommonCodeList({code: 'SERVICE_CLSS'}, function(data) {
		
		var options = '';
		
		data.forEach(function(d, i) {
			options += '<option value="' + d['code'] + '">' + d['cd_nm'] + '</option>';
		});
		
		jq.find('#serviceClss').append(options);
		
	});
	
	// 추가 버튼 클릭
	$(document).on("click", "#addCtyCd",function() {
		
		var rowspanNum = $('#serviceTh').attr('rowspan');

		$('#serviceTh').attr('rowspan',parseInt(rowspanNum)+1);
		
		var lastTrNumber = $('tbody #serviceTr').length;
		var megaTrCount = jq.find('tr[id="serviceTr"]').eq(parseInt(lastTrNumber)-1).find('select').attr('id').replace(/[^0-9]/g,'');
		var html = '<tr id="serviceTr"><td colspan="5" id="serviceTd">';

		html += '<select name="megaCd" id="megaCd'+ (parseInt(megaTrCount) + parseInt(1)) +'" style="width: 150px; margin-right:3px;">';
		html += '</select>';
		html += '<select name="ctyCd" id="ctyCd'+ (parseInt(megaTrCount) + parseInt(1)) +'" style="width: 150px; margin-right:3px;"></select>'
		html += '<input type="button" value="삭제" name="del" id="del' + (parseInt(megaTrCount) + parseInt(1)) + '"/>'
		html += '</td></tr>';
		
		$('.brd_write.left_header #serviceTr').last().after(html);
		
		
		getAreaSelectOption({rgnClss: 'H1'}, function(data) {
			// 시도 리스트 DOM 생성
			var options = '<option value="">::: 시도</option>';
			data.forEach(function(d, i) {
				options += '<option value="' + d['id'] + '">' + d['nm'] + '</option>'
			});
			$(document).find('#megaCd' + (parseInt(megaTrCount)+parseInt(1)) ).append(options);
		});
		
		
		var options = '<option selected value>:::시군구</option>'
		jq.find('#ctyCd' + (parseInt(megaTrCount)+parseInt(1)) ).append(options);
		
	});
	
	$(document).on("click", "input[name='del']",function() {
		var rowspanNum = $('#serviceTh').attr('rowspan');
		$('#serviceTh').attr('rowspan',Number(rowspanNum)-1);
		var trNum = $(this).closest('tr').prevAll().length;
		$('.brd_write.left_header #serviceTr').eq(trNum-1).remove();
	});
	
});
</script>
</head>
<body>
	<div id="wrap">
		<!-- header -->
		<%@ include file="/WEB-INF/jsp/onmap/admin/include/top.jsp" %>
		<!-- //header -->

		<hr />

		<!-- container -->
		<div id="container">
			<!-- snb -->
			<%@ include file="/WEB-INF/jsp/onmap/admin/include/left.jsp" %>
			<!--//snb -->

			<hr />

			<!-- contents -->
			<div id="contents">
				<!-- 본문 ==================================================================================================== -->
				<div class="contents_body">
					<div class="section_top">
						<h3 class="tit">기관 등록</h3>
					</div>

					<form name="dataForm" id="dataForm" method="post" enctype="multipart/form-data">
					<input type="hidden" id="cityArr" name="cityArr" />
					<div class="brd_wrap">
						<h4 class="tit_caption">기관정보</h4>
						<table class="brd_write left_header">
							<colgroup>
								<col width="150px" />
								<col width="*" />
								<col width="150px" />
								<col width="*" />
								<col width="150px" />
								<col width="*" />
							</colgroup>
							<tr>
								<th scope="row">* 기관명</th>
								<td colspan="5">
									<input type="text" name="orgNm" id="orgNm" value="" />
								</td>
							</tr>
							
							<tr id="serviceTr">
									<th scope="row" rowspan="1" id="serviceTh">* 서비스 지역
										<input type="button" id="addCtyCd" value="추가"/>
									</th>
									<td colspan="5" id="serviceTd">
										<select name="megaCd" id="megaCd1" style="width: 150px;">
											<option value="">::: 시도</option>
										</select> 
										<select name="ctyCd" id="ctyCd1" style="width: 150px;">
											<option value="">::: 시군구</option>
										</select>
									</td>
									
								</tr>
							
							<tr>
								<th scope="row">* 아이디</th>
								<td colspan="5">
									<input type="text" name="userId" id="userId" value="" />
									<span id="refUserId" style="color:green; vertical-align: middle;"></span>
									<p id="dupUserId" style="color:red; margin: 6px 0 0 0;"></p>
								</td>
							</tr>
							<tr>
								<th scope="row">기관 슬로건</th>
								<td colspan="5">
									<input type="text" name="regionTxt" id="regionTxt" class="inp_full" value="" />
								</td>
							</tr>
							<tr>
								<th scope="row">메인 이미지</th>
								<td colspan="2">
									<input type="file" name="imgFile1" id="imgFile1"  accept="image/*" /><br/> 
									<em>* 가로 1921px * 세로 933px 파일을 선택해주세요.</em>
								</td>
								<th scope="row">슬로건 이미지</th>
								<td colspan="2">
									<input type="file" name="imgFile2" id="imgFile2"  accept="image/*"  /><br/> 
									<em>* 가로 676px * 세로 246px 파일을 선택해주세요.</em>
								</td>
							</tr>
							<tr>
								<th scope="row">* 담당자명</th>
								<td><input type="text" name="mngNm" id="mngNm" value="" /></td>
								<th scope="row">담당자 직함</th>
								<td><input type="text" name="mngPosition" id="mngPosition" value="" /></td>
								<th scope="row">담당자 부서</th>
								<td><input type="text" name="mngDept" id="mngDept" value="" /></td>
							</tr>
							<tr>
								<th scope="row">* 담당자 연락처(Mobile)</th>
								<td colspan="2"><input type="text" name="mngMobile" id="mngMobile" value="" class="inp_full" maxlength="14"/></td>
								<th scope="row">담당자 연락처(Tel)</th>
								<td colspan="2"><input type="text" name="mngTel" id="mngTel" value="" class="inp_full" maxlength="14"/></td>
							</tr>
							<tr>
								<th scope="row">* 이메일</th>
								<td colspan="5">
									<input type="text" name="mngEmail" id="mngEmail" value="" />
								</td>
							</tr>
							<tr>
								<th scope="row">비고</th>
								<td colspan="5">
									<textarea id="memo" name="memo" wrap="PHYSICAL" class="memoText"></textarea>
								</td>
							</tr>
						</table>
					</div>

					<div class="brd_wrap">
						<h4 class="tit_caption">계약정보</h4>
						<table class="brd_write left_header">
							<colgroup>
								<col width="150px" />
								<col width="*" />
								<col width="150px" />
								<col width="*" />
							</colgroup>
							<tr>
								<th scope="row">* 서비스 유형</th>
								<td colspan="3">
									<select name="serviceClss" id="serviceClss"></select>
								</td>
							</tr>
							<tr>
								<th scope="row">* 계약 담당회사명</th>
								<td><input type="text" name="contractOrgan" id="contractOrgan" value="" /></td>
								<th scope="row">* 계약 담당자명</th>
								<td><input type="text" name="contractNm" id="contractNm" value="" /></td>
							</tr>
							<tr>
								<th scope="row">계약금액(원)</th>
								<td colspan="3">
									<input type="text" name="contractFee" id="contractFee" value="0" onkeydown="return numberCheck2(event, 'A');"  maxlength="15"/>
								</td>
							</tr>
							<tr>
								<th scope="row">* 서비스 사용 시작일</th>
								<td colspan="3">
									<input type="text" name="useStrDate" id="useStrDate" class="pop_calendar" maxlength="8" onkeydown="return numberCheck2(event, '');" />
								</td>
							</tr>
							<tr>
								<th scope="row">서비스 사용 기간</th>
								<td colspan="3">
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
								<th scope="row">* 서비스 사용 종료일</th>
								<td colspan="3">
									<input type="text" name="useExpDate" id="useExpDate" class="pop_calendar" maxlength="8" onkeydown="return numberCheck2(event, '');" />
								</td>
							</tr>
							</tr>
							<tr>
								<th scope="row">비고</th>
								<td colspan="3">
									<textarea id="rm" name="rm" wrap="PHYSICAL" class="memoText"></textarea>
								</td>
							</tr>
						</table>

						<!-- brd_btm -->
						<div class="brd_btn brd_btm">
							<div class="group_cnt">
								<ul>
									<li><a href="#" id="btnSave" class="btn_confirm">등록</a></li>
									<li><a href="/onmap/admin/org_list.do" id="btnCancel" class="btn_cancel">취소</a></li>
								</ul>
							</div>
						</div>
						<!-- //brd_btm -->
					</div>
					</form>
				</div>
				<!-- //본문 ==================================================================================================== -->
			</div>
			<!-- //contents -->
		</div>
		<!-- container -->
		</div>
</body>
</html>