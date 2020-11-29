<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<style>

#btnDmnAdd, #btnRgnAdd {
	height: 22px;
    line-height: 20px;
    width: 25px;
    padding: 0px 10px;
    border: 0;
}
a.btnDmnDlt, a.btnRgnDlt {
	display: inline-block;
	height: 22px;
    line-height: 20px;
    width: 25px;
    padding: 0px 10px;
	border: 0;
	color:#FFF; 
	background:#ca1515;
}

a.btn_delete {
	display:inline-block; 
	height:38px; 
	line-height:38px; 
	padding:0 20px; 
	border:1px solid #ca1515; 
	color:#FFF; 
	background:#ca1515;
}

.scrolltbody .rgnDiv {
    display: block;
    height: auto;
    overflow: auto;
}

.scrolltbody .dmnDiv {
    display: block;
    height: auto;
    overflow: auto;
}

.rgnDiv div, .dmnDiv div {
	margin-top: 1px;
}

</style>
<div id="popwrap">
	<!-- header -->
	<div id="popHeader">
		<h1 class="pop_tit">API 신청</h1>
		<a href="#none" id="btnCancl" class="btn_close">닫기</a>
	</div>
	<!-- //header -->

	<hr />

	<!-- contents -->
	<div id="popContents">
		<!-- 본문 ==================================================================================================== -->
		<div class="brd_wrap">
			<form name="popForm" id="popForm">
			<table class="brd_write scrolltbody">
				<colgroup>
					<col width="150px" />
					<col width="*" />
				</colgroup>
				
				<!-- API 명 start ==================================================================================================== -->
				<tr>
					<th scope="row">API 명</th>
					<td><input type="text" name="apiNm" id="apiNm" value=""/></td>
				</tr>
				<!-- API 명 end ==================================================================================================== -->
				
				<!-- API 설명 start ==================================================================================================== -->
				<tr>
					<th scope="row">API 설명</th>
					<td>
						<textarea name="apiDesc" id="apiDesc"></textarea>
					</td>
				</tr>
				<!-- API 설명 end ==================================================================================================== -->
				
				<!-- 서비스 지역 start ==================================================================================================== -->
				<tr class="region brd_btn">
					<th scope="row">서비스 지역</th>
					<td>
						<div class="rgnDiv">
							<div class="region" rgnIdx="0">
								<select class="megaCd" megaIdx="0" style="width: 110px;">
									<option value="">::: 시도</option>
								</select>
								
								<select class="ctyCd" ctyIdx="0" style="width: 110px;">
									<option value="">::: 시군구</option>
								</select>
								<a href="#none" id="btnRgnAdd" class="btn_confirm">추가</a>
								<a href="#none" class="btnRgnDlt">삭제</a>
							</div>
						</div>
					</td>
				</tr>
				<!-- 서비스 지역 end ==================================================================================================== -->
				
				<!-- 도메인명 or IP start ==================================================================================================== -->				
				<tr class="domain brd_btn">
					<th scope="row">도메인명 or IP</th>
					<td>
						<div class="dmnDiv">
							<div class="domain" domain-idx="0">
								<input type="text" class="domain" domain-idx="0" value="" style="width: 180px;"/>
								<a href="#none" id="btnDmnAdd" class="btn_confirm">추가</a>
								
							</div>
						</div>
					</td>
				</tr>
				<!-- 도메인명 or IP end ==================================================================================================== -->
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
			<li><a href="#none" id="btnPopUdt" class="btn_confirm" style="display:none;">수정</a></li>
			<li><a href="#none" id="btnPopDlt" class="btn_delete" style="display:none;">삭제</a></li>
			<li><a href="#none" id="btnCancel" class="btn_cancel">취소</a></li>
		</ul>
	</div>
	<!-- //footer -->
</div>
		
<script type="text/javascript">
$(document).ready(function() {
	
	var jq = $('#popup');
	
	// popwrap의 높이를 기준으로 popup 레이어 높이 설정
	jq.height($('#popwrap').height()).draggable('option', 'disabled', false);
	
	// 팝업 닫기
	jq.find("#btnCancel, #btnCancl").click(function() {				
		jq.dialog('close');
	});

	// API 신청버튼 클릭
	jq.find("#btnPopSave").click(function() {
		
		var params = setParams();   // ajax data세팅
		
		if(params === undefined) return;
		
		$.ajax({
			url: '/onmap/admin/pop_api_regist.json',
			type:"POST",
			async: false,
			data: params,
			success:function(data) {

				if("ok" == data.resultMsg) {
					alert('api신청을 완료 했습니다.');
					jq.find('#popFooter').remove();
					jq.css({
						'height': '',
						'width': 'auto',
						'border': '0.8px solid #666',
						'min-height': 'auto'
					})
					jq.find('#popContents').empty().text('인증키: ' + data['apiKey']);
					jq.draggable('option', 'disabled', true);
				} else {
					alert("저장 중에 에러가 발생했습니다. 관리자에게 문의하세요.");
				}

			},
			error:function(e) {
				alert("관리자에게 문의해 주세요.");
			}
		});
	});
	
	// API 수정버튼 클릭
	jq.find('#btnPopUdt').on('click', function() {
		
		var params = setParams();    // ajax data세팅
		
		if(params === undefined) return;
		
		$.ajax({
			url: '/onmap/admin/pop_api_update.json',
			type:"POST",
			async: false,
			data: params,
			success:function(data) {

				if("ok" == data.resultMsg) {
					jq.dialog('close');
					location.reload();
					alert('API수정을 완료 했습니다.');
				} else {
					alert("저장 중에 에러가 발생했습니다. 관리자에게 문의하세요.");
				}

			},
			error:function(e) {
				alert("관리자에게 문의해 주세요.");
			}
		});
	})
	
	// API 삭제버튼 클릭
	jq.find('#btnPopDlt').on('click', function() {
		
		var params = setParams();    // ajax data세팅
		
		if(params === undefined) return;
		
		$.ajax({
			url: '/onmap/admin/pop_api_delete.json',
			type:"POST",
			async: false,
			data: params,
			success:function(data) {

				if("ok" == data.resultMsg) {
					jq.dialog('close');
					location.reload();
					alert('API삭제를 완료 했습니다.');
				} else {
					alert("저장 중에 에러가 발생했습니다. 관리자에게 문의하세요.");
				}

			},
			error:function(e) {
				alert("관리자에게 문의해 주세요.");
			}
		});
	})
	
	// 시도 조회 ajax
	$('#popForm').on('change', 'select.megaCd', function() {
		var megaCd = $(this).val();
		var selector = $(this).parent();
		
		// 시도코드로 행정동 코드 조회 및 DOM생성
		popMakeOptionCtyCd(megaCd, selector);
	});
	
	// 행정동 조회 ajax
	jq.find('#popForm').on('change', 'select.ctyCd', function() {
		var select = $(this);
		var ctyCd = select.val();
		var equal = false;    // 행정동 selectbox에서 동일한 값 체크하기위한 변수
		
		// 행정동 selectbox에서 동일한 값 체크하는 로직
		$('#popForm select.ctyCd option.choose').each(function(index, option) {
			
			if(ctyCd == $(option).val()) {
				alert('선택된 시군구입니다.\n다른 지역을 선택해 주세요.');
				select.val(select.find('option.choose').val()).prop('selected', true);
				equal = true;
			}
		});
		
		if(!equal) {
			select.find('option.choose').removeAttr('class');
			select.find('option:selected').addClass('choose');
		}
	});
	
	// 서비스 지역 추가
	jq.find("#btnRgnAdd").click(function() {
		
		var megaLength = $('select.megaCd').length;   // 시도 select박스 갯수 
		var ctyLength = $('select.ctyCd').length;     // 행정동 select박스 갯수 
		var basicDiv = $(this).parent();              // 새로운 div을 추가하기 위해 필요한 기준 div
		var insertDiv = basicDiv.clone();             // 새로 추가할 div
		
		// 새로 추가할 div세팅
		insertDiv.find('a').remove();
		insertDiv.attr('rgnIdx', megaLength);
		insertDiv.append('<a href="#none" class="btnRgnDlt">삭제</a>');
		
		// 추가될 시도 select박스는 초기화
		insertDiv.find('select.megaCd').attr('megaidx', megaLength);
		insertDiv.find('select.megaCd option').removeAttr('selected');
		insertDiv.find('select.megaCd option').eq(0).attr('selected', 'selected');
		
		// 추가될 시군구 select박스는 초기화
		insertDiv.find('select.ctyCd').attr('ctyidx', megaLength);
		insertDiv.find('select.ctyCd').empty();
		insertDiv.find('select.ctyCd').append("<option value=''>::: 시군구</option>");
		
		// select박스를 추가 시기별로 분기처리
		if(megaLength == 1) {
			basicDiv.after(insertDiv);
		} else {
			basicDiv.siblings('[rgnIdx="' + (megaLength - 1) + '"]').after(insertDiv);
		} 
		
		// 지역개수가 8개 이상이면 css조정
		if(megaLength > 7) {
			basicDiv.parent().css('height', '200px');
		}
		
		jq.height($('#popwrap').height())    // popwrap의 높이를 기준으로 popup 레이어 높이 설정
	});
	
	// 서비스 지역 삭제
	jq.find('#popForm').on('click', '.btnRgnDlt', function() {
		$(this).parent().remove();
		
		// tr의 rgnidx속성값 재배열
		$('div.region').each(function(index, tr) {
			$(tr).attr('rgnidx', index);
		})
		
		// 지역개수가 7개 이하이면 css조정
		if($('div.region').length < 8) {
			$('.rgnDiv').css('height', '');
		}
		
		jq.height($('#popwrap').height())    // popwrap의 높이를 기준으로 popup 레이어 높이 설정
	});
	
	// 도메인 추가
	jq.find('#btnDmnAdd').click(function() {
		
		var addPopDmn = $('input.domain').eq(0).clone();   // 도메인 input박스 복사
		var basicDiv = $(this).parent();                   // 새로운 div을 추가하기 위해 필요한 기준 div
		var dmnLength = $('input.domain').length;          // 도메인 input박스 갯수 
		var insertDiv = basicDiv.clone();                  // 새로 추가할 div
		
		// 새로 추가할 div세팅
	    insertDiv.find('a').remove();
	    insertDiv.attr('domain-idx', dmnLength);
	    insertDiv.append('<a href="#none" class="btnDmnDlt">삭제</a>');
		
	 	// 추가될 도메인 input 박스는 초기화
	    insertDiv.find('input.domain').val('');
	    insertDiv.find('input.domain').attr('domain-idx', dmnLength);
		
		// input박스를 추가 시기별로 분기처리
		if(dmnLength == 1) {
			basicDiv.after(insertDiv);
		} else {
			basicDiv.siblings('[domain-idx="' + (dmnLength - 1) + '"]').after(insertDiv);
		} 
		
		// 도메인개수가 5개 이상이면 css조정
		if(dmnLength > 3) {
			basicDiv.parent().css('height', '100px');
		}
		
		jq.height($('#popwrap').height())    // popwrap의 높이를 기준으로 popup 레이어 높이 설정
	});
	
	// 도메인 리스트 삭제
	jq.find('#popForm').on('click', '.btnDmnDlt', function() {
		$(this).parent().remove();
		
		// 각 도메인 div 인덱스값 재정렬
		$('div.domain').each(function(index, tr) {
	        $(tr).attr('domain-idx', index);
	    })
	    
	    // 도메인개수가 4개 이하면 css조정
		if($('div.domain').length < 5) {
			$('.dmnDiv').css('height', '');
		}
	});
});

// ajax data세팅하는 함수
function setParams() {
	
	// 각 input값에 대한 검증
	if(!validation()) return;
	
	var params = $("#popForm").serialize();
	var megaCd = '';
	var ctyCd = '';
	var domainVal = '';
	var insertDm = [];
	var insertMega = [];
	var insertCty = [];
	
	// 시도 지역코드 파라미터 세팅
	$('select.megaCd').each(function(index, selector) {
		insertMega.push($(selector).val());
	});
	
	megaCd = insertMega.join(',');
	
	// 행정동 지역코드 파라미터 세팅
	$('select.ctyCd').each(function(index, selector) {
		insertCty.push($(selector).val());
	});
	
	ctyCd = insertCty.join(',');

	// 도메인 파라미터 세팅
	$('input.domain').each(function(idx, selc) {
		if($(selc).val() != "") insertDm.push($(selc).val());
	});
		
	// 중복 도메인 검사			
	insertDm.forEach(function(value, index) {
		var	tmpDmnVal = value;
		
		for(var idx = 0; idx < $('input.domain').length; idx++) {
			//자신을 제외한 값과 비교
			if(index != idx) {
				if(tmpDmnVal == $('input.domain')[idx].value) {
					delete insertDm[idx];
				}
			}
		}
	});
	
	insertDm = insertDm.filter(function(n){ return n != undefined });    // 빈배열은 삭제
	domainVal = insertDm.join(',');
	
	params = params + '&' + 'megaCd=' + megaCd;
	params = params + '&' + 'ctyCd=' + ctyCd;
	params = params + '&' + 'domain=' + domainVal;
	
	return params;
}

// 선택된 시도에 대한 행정동 데이터 조회 후 DOM 생성 하는 함수
function popMakeOptionCtyCd(megaCd, selector){
	
	// 행정동 selectbox 초기화
	selector.find('select.ctyCd').empty();
	selector.find('select.ctyCd').append("<option value=''>::: 시군구</option>");

	$.ajax({
		url:'/common/area_select_option.json',
		type:"POST",
		data:{
			"rgnClss":"H3",
			"megaCd":megaCd
		},
		async: false,
		success: function(data){
			var selectOption = "";
			
			for(var i = 0; i < data.length; i++) {
				var dataMap = data[i];
				selector.find('select.ctyCd').append("<option value=" + dataMap.id + " "+selectOption+">" + dataMap.nm + "</option>");
				selectOption = "";
			}

		}
	});
}

// input값에 대한 유효성 검증하는 함수
function validation() {
	
	var apiNm = $("#popForm").find("#apiNm");
	var apiDesc = $("#popForm").find("#apiDesc");
	var mega = $("#popForm").find('select.megaCd');
	var cty = $("#popForm").find('select.ctyCd');
	var domainCheck = false;
	
	// API명 유효성 검증
	if("" == apiNm.val()) {
		alert("API명을 입력해 주세요.");
		apiNm.focus();
		return false;
	}
	
	// API 유효성 검증
	if("" == apiDesc.val()) {
		alert("API에 대한 설명을 입력해 주세요.");
		apiNm.focus();
		return false;
	}
	
	var ipEmpty = true;
	// 도메인 or IP 유효성 검증
	$("input.domain").each(function(idx, elm) {
		
		var domainVal = $(elm).val();
		
		if(!(isNaN(domainVal.split('.')[0]))) {    // IP일 때 정규식 및 메시지 세팅
			var reg = /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/;
			var msg = '유효한 ip를 입력해 주세요.';
			
			ipEmpty = false;    // ip가 하나라도 있으면 true
		} else {    // 도메인일 때 정규식 및 메시지 세팅
			var reg = /^(((http(s?))\:\/\/)?)([0-9a-zA-Z\-]+\.)+[a-zA-Z]{2,6}(\:[0-9]+)?(\/\S*)?/;
			var msg = '유효한 도메인을 입력해 주세요.';
		}
		
		var valid = reg.test(domainVal);    // 도메인 or IP 정규식 검증  
		
		// 검증되지 않고 localhost 아닐 때 false 리턴
		if ( !valid && domainVal != 'localhost' ) {
			alert(msg);
			$(elm).focus();
			domainCheck = true;
		}
	});
	
	// ip가 하나도 없을 경우 return
	if(ipEmpty) {
		alert('ip는 적어도 하나 입력해 주세요.');
		return false;
	}
	
	// 도메인이 유효하지 않을 경우 return
	if(domainCheck) {
		return false;
	}
	
	// 시도를 적어도 한개라도 선택하지 않으면 return
	var megaEmpty = false;
	
	mega.each(function(index, selector) {
		
		var megaCd = $(selector).find('option:selected').val();
		
		if("" == megaCd) {
			if(index == (mega.length - 1)) {
				alert("시도를 선택해 주세요.");
				megaEmpty = true;
				mega.focus();
				
			}		
		}
	});
	
	if(megaEmpty) return false; 
	
	// 행정동을 적어도 한개라도 선택하지 않으면 return
	var ctyEmpty = false;
	
	cty.each(function(index, selector) {
		
		var ctyCd = $(selector).find('option:selected').val();
		
		if("" == ctyCd) {
			if(index == (cty.length - 1)) {
				alert("행정동을 선택해 주세요.");
				ctyEmpty = true;
				cty.focus();
			}		
		}
	});
	
	if(ctyEmpty) return false;
	
	return true;
}

getApiNo({
	orgId: orgId,
	contractId: contractId 
}, function(data) {
	var apiNo = data;
	
	console.log(apiNo)
	
	// API이름이 없으면 신청화면으로 전환
	if(!apiNo) {
		jq.find(".pop_tit").text("API 신청");
		return;
	}
	
	// API이름이 있으면 수정화면으로 전환		
	jq.find('.pop_tit').text("API 수정");
	jq.find('#btnPopUdt,#btnPopDlt').show();
	jq.find('#btnPopSave').hide();
	
	// 지역개수가 8개 이상이면 css조정
	if(jq.find('div.region').length > 7) {
		jq.find('.rgnDiv').css('height', '200px');
	}
	
	// 도메인개수가 5개 이상이면 css조정
	if(jq.find('div.domain').length > 4) {
		jq.find('.dmnDiv').css('height', '100px');
	}	
		
	getApiInfo({
		orgId: orgId,
		contractId: contractId 
	}, function(data) {
		jq.find('#apiNm').val(data['api_nm']);
		jq.find('#apiDesc').val(data['api_desc']);
	});

	getApiRegion({
		apiNo: apiNo
	}, function(data) {
		
		
	});
	
	getApiDomain({
		apiNo: apiNo
	}, function(data) {
		
		var div = '';
		
		data.forEach(function(d, i) {
			div += '<div class="domain" domain-idx="' + i + '">';
			div += 	'<input type="text" class="domain" domain-idx="' + i + '" value="' + d['api_domain'] + '" style="width: 180px;">';
			
			if(i === 0) {
				div += 	'<a href="#none" id="btnDmnAdd" class="btn_confirm">추가</a>';
			} else {
				div += 	'<a href="#none" class="btnDmnDlt">삭제</a>';
			}
			
			div += '</div>';
		});
		
		jq.find('.dmnDiv').append(div);
	});
});

</script>