<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"  %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/jsp/onmap/admin/include/library.jsp" %>
<script type="text/javascript">

$(document).ready(function() {
	
	// 기관현황 제이쿼리 루트 셀렉터
	var jq = $('#contents');    
	
	/**
	 * @description 서비스유형 체크박스 클릭 이벤트 바인딩 하는 함수  
	 */
	function setSvcTypeChkboxClick() {
		
		// 서비스 유형 선택시 적용
		jq.find('#svcTypeChkbox input[type="checkbox"]').click(function() {
			
			// 현재 선택한 서비스유형의 체크박스가 체크된 경우 
			if($(this).prop('checked')) {
				
				// 서비스유형 체크박스 체크
				jq.find('#serviceType').prop('checked', true);   
				
			// 현재 선택한 서비스유형의 체크박스가 해제된 경우 
			} else {
				
				var selectedChkboxLength = jq.find('#svcTypeChkbox input[type="checkbox"]:checked').length;
				
				if(selectedChkboxLength === 0) {
					
					// 서비스유형 체크박스 해제 
					jq.find('#serviceType').prop('checked', false);  
				}
			}
		});
	}
	
	/**
	 * @description 기관리스트 테이블 UI 생성하는 함수 
	 * @param data: 테이블생성시 필요데이터, Array  
	 */
	function makeApiListTableDom(data) {
		
		jq.find('#apiListTbody').empty();
		
		var tbodyContents = '';
		
		if(data.length === 0) {
			tbodyContents += '<tr>';
			tbodyContents += 	'<td colspan="10">등록된 API 정보가 없습니다.</td>';
			tbodyContents += '</tr>';
		} else {
			data.forEach(function(d, i) {
				
				var queryString = $.param({
					orgId: d['org_id'],
					contractId: d['contract_id'],
					megaCd: d['mega_cd'],
					ctyCd: d['cty_cd']
				});
				
				tbodyContents += '<tr>';
				tbodyContents += '<td>' + d['service_clss_nm'] + '</td>';
				tbodyContents += '<td>';
// 				tbodyContents += 	'<a href="#" class="btn_api_updt">';
				tbodyContents += 		d['api_nm'];
// 				tbodyContents += 	'</a>';
				tbodyContents += '</td>';
				tbodyContents += '<td>';
				tbodyContents += 	'<a href="/onmap/admin/org_updt.do?' + queryString + '" class="btn_org_updt">';
				tbodyContents += 		d['org_nm'];
				tbodyContents += 	'</a>';
				tbodyContents += '</td>';
				tbodyContents += '<td>' + d['use_str_date'] + '</td>';
				tbodyContents += '<td>' + d['use_exp_date'] + '</td>';
				tbodyContents += '</tr>';
			});
		}
		
		jq.find('#apiListTbody').append(tbodyContents);
	}
	
	// 서비스유형 다중선택 클릭 이벤트 
	jq.find('#serviceType').click(function(){
		
		// 전체선택 체크박스가 체크된 경우
		if($(this).prop("checked")) { 	 
			
			// 서비스유형 체크박스 체크
			jq.find('#svcTypeChkbox input[type="checkbox"]').prop('checked', true);
			
		// 전체선택 체크박스가 해제된 경우
		} else {
			
			// 서비스유형 체크박스 해제
			jq.find('#svcTypeChkbox input[type="checkbox"]').prop('checked', false);
			
		}
	});
	
	// 조회버튼 클릭 
	jq.find("#btnSearch").click(function() {
		
		var serviceType = [];   // 서비스 유형 
		var apiNm = jq.find('#apiNm').val();    	  // API명 
		var orgNm = jq.find('#orgNm').val();    	  // 기관명 
		var megaCd = jq.find('#megaCd').val();			  // 서비스지역 중 시도코드 
		var ctyCd = jq.find('#ctyCd').val();			      // 서비스지역 중 시군구코드 
		var startDt = jq.find("#startDt").val();      				  // 기간선택 시작 
		var endDt = jq.find("#endDt").val();						  // 기간선택 끝 
		
		jq.find('#svcTypeChkbox input[type="checkbox"]:checked').each(function(i, ele) {
			serviceType.push($(ele).val());
		});
		
		if(serviceType.length === 0) {
			alert("서비스 유형을 하나이상 선택해주세요.");
			return false;
		}
		
		// 기관리스트 테이블 DOM 새로 생성 
		getApiList({
			serviceClss: "'" + serviceType.join("','") + "'",
			apiNm: apiNm,
			orgNm: orgNm,
			megaCd: megaCd,
			ctyCd: ctyCd,
			startDt: startDt,
			endDt: endDt,
			limit: 10
		}, makeApiListTableDom);
		
		// 전체기관건수 표현 및 페이지리스트 DOM 새로 생성 
		getTotApiList({
			serviceClss: "'" + serviceType.join("','") + "'",
			apiNm: apiNm,
			orgNm: orgNm,
			megaCd: megaCd,
			ctyCd: ctyCd,
			startDt: startDt,
			endDt: endDt
		}, function(data) {
			
			jq.find('#totApiList').text(data);
			
			makePageDOM({totCnt: data}, function(params) {
				
				// 파라미터가 비어있으면 리턴 
				if($.isEmptyObject(params)) {
					return;
				}
				
				// 기관리스트 테이블 DOM 새로 생성 
				getApiList({
					serviceClss: "'" + serviceType.join("','") + "'",
					apiNm: apiNm,
					orgNm: orgNm,
					megaCd: megaCd,
					ctyCd: ctyCd,
					startDt: startDt,
					endDt: endDt,
					limit: params['limit'],
					offset: params['offset']
				}, makeApiListTableDom);
			});
		});
	});
	
	// 조회버튼 엔터 
	$("body").keydown(function(key) {
		
		if(key.keyCode == 13) {
			
			var serviceType = [];   // 서비스 유형 
			var apiNm = jq.find('#apiNm').val();    	  // API명 
			var orgNm = jq.find('#orgNm').val();    	  // 기관명 
			var megaCd = jq.find('#megaCd').val();			  // 서비스지역 중 시도코드 
			var ctyCd = jq.find('#ctyCd').val();			      // 서비스지역 중 시군구코드 
			var startDt = jq.find("#startDt").val();      				  // 기간선택 시작 
			var endDt = jq.find("#endDt").val();						  // 기간선택 끝 
			
			jq.find('#svcTypeChkbox input[type="checkbox"]:checked').each(function(i, ele) {
				serviceType.push($(ele).val());
			});
			
			if(serviceType.length === 0) {
				alert("서비스 유형을 하나이상 선택해주세요.");
				return false;
			}
			
			// 기관리스트 테이블 DOM 새로 생성 
			getApiList({
				serviceClss: "'" + serviceType.join("','") + "'",
				apiNm: apiNm,
				orgNm: orgNm,
				megaCd: megaCd,
				ctyCd: ctyCd,
				startDt: startDt,
				endDt: endDt,
				limit: 10
			}, makeApiListTableDom);
			
			// 전체기관건수 표현 및 페이지리스트 DOM 새로 생성 
			getTotApiList({
				serviceClss: "'" + serviceType.join("','") + "'",
				apiNm: apiNm,
				orgNm: orgNm,
				megaCd: megaCd,
				ctyCd: ctyCd,
				startDt: startDt,
				endDt: endDt
			}, function(data) {
				
				jq.find('#totApiList').text(data);
				
				makePageDOM({totCnt: data}, function(params) {
					
					// 파라미터가 비어있으면 리턴 
					if($.isEmptyObject(params)) {
						return;
					}
					
					// 기관리스트 테이블 DOM 새로 생성 
					getApiList({
						serviceClss: "'" + serviceType.join("','") + "'",
						apiNm: apiNm,
						orgNm: orgNm,
						megaCd: megaCd,
						ctyCd: ctyCd,
						startDt: startDt,
						endDt: endDt,
						limit: params['limit'],
						offset: params['offset']
					}, makeApiListTableDom);
				});
			});
		}
	});
	
	// 시도 셀렉트박스 체인지 이벤트 
	jq.find("#megaCd").change(function() {
		
		var megaCd = $(this).val();   // 시도코드 

		// 해당 시도코드에 대한 시군구 리스트 DOM 생성  
		getAreaSelectOption({
			rgnClss: 'H3',
			megaCd: megaCd
		}, function(data) {
			
			jq.find("#ctyCd").empty();
			
			if(data.length === 0) {
				var options = '<option value="">::: 시군구</option>';
			} else {
				var options = '<option value="">::: 전체</option>';
				
				data.forEach(function(d, i) {
					options += '<option value="' + d['id'] + '">' + d['nm'] + '</option>';
				});				
			}
			
			jq.find("#ctyCd").append(options);
		});
	});

	// 전체 시도 리스트 DOM 생성 
	getAreaSelectOption({rgnClss: 'H1'}, function(data) {
		
		// 시도 리스트 DOM 생성
		var options = '';
		
		data.forEach(function(d, i) {
			options += '<option value="' + d['id'] + '">' + d['nm'] + '</option>'
		});
		
		jq.find('#megaCd').append(options);
	});

	// 서비스 유형 DOM 생성 
	getCommonCodeList({code: 'SERVICE_CLSS'}, function(data) {
		
		var checkboxes = '';
		
		data.forEach(function(d, i) {
			if(d['code'] === '5' || d['code'] === '6') {
				checkboxes += ' <input type="checkbox" checked="checked" value="' + d['cd'] + '"/>' + d['cd_nm'];
			}
		});
		
		jq.find('#svcTypeChkbox').append(checkboxes);
		
		// 서비스 유형 체크박스 클릭 이벤트 바인딩 
		setSvcTypeChkboxClick(); 
		
	});
	
	// 전체기관 건수 표현 및 페이지리스트 DOM 생성 
	getTotApiList({}, function(data) {
		
		// 전체기관 건수 화면 표현 
		jq.find('#totApiList').text(data);
		
		makePageDOM({totCnt: data}, function(params) {
			
			// 파라미터가 비어있으면 리턴 
			if($.isEmptyObject(params)) {
				return;
			}
			
			// 기관리스트 테이블 DOM 새로 생성 
			getApiList({
				limit: params['limit'],
				offset: params['offset']
			}, makeApiListTableDom);
		});
	});
	
	// 기관리스트 테이블 DOM 생성
	getApiList({
		limit: 10
	}, makeApiListTableDom);
	
	// 오늘날짜 기준으로 endDt값 세팅
	jq.find('#endDt').val(getStringDt(new Date(), 'day'));
});
</script>
</head>
<body>
	<div id="popup" style="background-color: white;"></div>
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
						<h3 class="tit">API 현황</h3>
					</div>

					<!-- 검색필터 -->
					<div class="search_wrap">
						<!-- 필터 -->
						<div class="filter_wrap">
							<table class="brd_write left_header">
								<colgroup>
									<col width="150px" />
									<col width="*" />
									<col width="150px" />
									<col width="*" />
								</colgroup>
								<tr>
									<th scope="row">
										서비스 유형<input type="checkbox" id="serviceType" checked="checked" value="'C','CE','T','TE'" /> 
									</th>
									<td id="svcTypeChkbox" colspan="3"></td>
								</tr>
								<tr>
									<th scope="row">API 명</th>
									<td>
										<input type="text" name="apiNm" id="apiNm" value="" />
									</td>
									<th scope="row">기관명</th>
									<td>
										<input type="text" name="orgNm" id="orgNm" value="" />
									</td>
								</tr>
								<tr>
									<th scope="row">시군구</th>
									<td colspan="3">
										<select name="megaCd" id="megaCd" style="width: 100px;">
											<option value="">::: 시도</option>
										</select>
										<select name="ctyCd" id="ctyCd" style="width: 100px;">
											<option value="">::: 시군구</option>
										</select>
									</td>
								</tr>
								<tr>
									<th scope="row">가입일자</th>
									<td colspan="3">
										<input type="text" name="startDt" id="startDt" value="" class="pop_calendar" /> -
										<input type="text" name="endDt" id="endDt" value="" class="pop_calendar" />
									</td>
								</tr>
							</table>
							<div class="filter_btm">
								<div class="filter_result">
									<dl>
										<dt>전체:</dt>
										<dd id="totApiList"></dd>
									</dl>
								</div>
								<div class="filter_btn">
									<button type="button" id="btnSearch" class="btn_confirm">조회</button>
								</div>
							</div>
						</div>
						<!-- //필터 -->
					</div>
					<!-- //검색필터 -->

					<div class="brd_wrap">
						<table class="brd_list">
							<colgroup>
								<col width="" />
							</colgroup>
							<thead>
								<tr>
									<th scope="col">서비스 유형</th>
									<th scope="col">API 명</th>
									<th scope="col">기관명</th>
									<th scope="col">서비스 <br/>시작일</th>
									<th scope="col">서비스 <br/>종료일</th>
								</tr>
							</thead>
							<tbody id="apiListTbody"></tbody>
						</table>

						<!-- paginate -->
						<div class="paginate"></div>
						<!-- //paginate -->
					</div>
				</div>
				<!-- //본문 ==================================================================================================== -->
			</div>
			<!-- //contents -->
		</div>
		<!-- container -->
	</div>
</body>
</html>