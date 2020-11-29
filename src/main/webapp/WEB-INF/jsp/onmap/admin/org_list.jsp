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
	function makeOrgListTableDOM(data) {
		
		jq.find('#orgListTbody').empty();
		
		var tbodyContents = '';
		
		if(data.length === 0) {
			tbodyContents += '<tr>';
			tbodyContents += 	'<td colspan="10">등록된 기관 정보가 없습니다.</td>';
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
				tbodyContents += 	'<td ' + (d["service_clss"] === "C" ? "style='color: red;'" : "") + '>' + d['use_type_nm'] + '</td>';
				tbodyContents += 	'<td>'; 
				tbodyContents += 		'<a href="/onmap/admin/org_updt.do?' + queryString + '" class="btn_org_updt">';
				tbodyContents += 			d['org_nm'];
				tbodyContents +=		'</a>'
				tbodyContents += 	'</td>'
				tbodyContents += 	'<td>' + d['use_str_date'] + '</td>'
				tbodyContents += 	'<td>' + d['use_exp_date'] + '</td>'
				tbodyContents += 	'<td>' + numberWithCommas(d['tot_acc_cnt']) + '</td>'
				tbodyContents += 	'<td>' + d['contract_organ'] + ' / ' + d['contract_nm'] + '</td>'
				tbodyContents += 	'<td style="text-align:right;">' + numberWithCommas(d['contract_fee']) + '</td>'
				tbodyContents += '</tr>'
			});
		}
		
		jq.find('#orgListTbody').append(tbodyContents);
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
		var orgNm = jq.find('#orgNm').val();    	  // 기관명 
		var megaCd = jq.find('#megaCd').val();			  // 서비스지역 중 시도코드 
		var ctyCd = jq.find('#ctyCd').val();			      // 서비스지역 중 시군구코드 
		
		jq.find('#svcTypeChkbox input[type="checkbox"]:checked').each(function(i, ele) {
			serviceType.push($(ele).val());
		});
		
		if(serviceType.length === 0) {
			alert("서비스 유형을 하나이상 선택해주세요.");
			return false;
		}
		
		// 기관리스트 테이블 DOM 새로 생성 
		getOrgList({
			serviceClss: "'" + serviceType.join("','") + "'",
			orgNm: orgNm,
			megaCd: megaCd,
			ctyCd: ctyCd,
			limit: 10
		}, makeOrgListTableDOM);
		
		// 전체기관건수 표현 및 페이지리스트 DOM 새로 생성 
		getTotOrgList({
			serviceClss: "'" + serviceType.join("','") + "'",
			orgNm: orgNm,
			megaCd: megaCd,
			ctyCd: ctyCd
		}, function(data) {
			
			jq.find('#totOrg').text(data);
			
			makePageDOM({totCnt: data}, function(params) {
				
				// 파라미터가 비어있으면 리턴 
				if($.isEmptyObject(params)) {
					return;
				}
				
				// 기관리스트 테이블 DOM 새로 생성 
				getOrgList({
					serviceClss: "'" + serviceType.join("','") + "'",
					orgNm: orgNm,
					megaCd: megaCd,
					ctyCd: ctyCd,
					limit: params['limit'],
					offset: params['offset']
				}, makeOrgListTableDOM);
			});
		});
	});
	
	// 조회버튼 엔터 
	$("body").keydown(function(key) {
		
		if(key.keyCode == 13) {
			
			var serviceType = [];   // 서비스 유형 
			var orgNm = jq.find('#orgNm').val();    	  // 기관명 
			var megaCd = jq.find('#megaCd').val();			  // 서비스지역 중 시도코드 
			var ctyCd = jq.find('#ctyCd').val();			      // 서비스지역 중 시군구코드 
			
			jq.find('#svcTypeChkbox input[type="checkbox"]:checked').each(function(i, ele) {
				serviceType.push($(ele).val());
			});
			
			if(serviceType.length === 0) {
				alert("서비스 유형을 하나이상 선택해주세요.");
				return false;
			}
			
			// 기관리스트 테이블 DOM 새로 생성 
			getOrgList({
				serviceClss: "'" + serviceType.join("','") + "'",
				orgNm: orgNm,
				megaCd: megaCd,
				ctyCd: ctyCd,
				limit: 10
			}, makeOrgListTableDOM);
			
			// 전체기관건수 표현 및 페이지리스트 DOM 새로 생성 
			getTotOrgList({
				serviceClss: "'" + serviceType.join("','") + "'",
				orgNm: orgNm,
				megaCd: megaCd,
				ctyCd: ctyCd
			}, function(data) {
				jq.find('#totOrg').text(data);
				makePageDOM({totCnt: data}, function(params) {
					
					// 파라미터가 비어있으면 리턴 
					if($.isEmptyObject(params)) {
						return;
					}
					
					// 기관리스트 테이블 DOM 새로 생성 
					getOrgList({
						serviceClss: "'" + serviceType.join("','") + "'",
						orgNm: orgNm,
						megaCd: megaCd,
						ctyCd: ctyCd,
						limit: params['limit'],
						offset: params['offset']
					}, makeOrgListTableDOM);
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
			checkboxes += '<input type="checkbox" checked="checked" value="' + d['code'] + '"/>' + '<span>' + d['cd_nm'] + '</span>';
		});
		
		jq.find('#svcTypeChkbox').append(checkboxes);
		
		// 서비스 유형 체크박스 클릭 이벤트 바인딩 
		setSvcTypeChkboxClick(); 
		
	});
	
	// 전체기관 건수 표현 및 페이지리스트 DOM 생성 
	getTotOrgList({}, function(data) {
		
		// 전체기관 건수 화면 표현 
		jq.find('#totOrg').text(data);
		
		makePageDOM({totCnt: data}, function(params) {
			
			// 파라미터가 비어있으면 리턴 
			if($.isEmptyObject(params)) {
				return;
			}
			
			// 기관리스트 테이블 DOM 새로 생성 
			getOrgList({
				limit: params['limit'],
				offset: params['offset']
			}, makeOrgListTableDOM);
		});
	});
	
	// 기관리스트 테이블 DOM 생성
	getOrgList({
		limit: 10
	}, makeOrgListTableDOM);
	
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
						<h3 class="tit">기관 현황</h3>
					</div>

					<!-- 검색필터 -->
					<div class="search_wrap">
						<!-- 필터 -->
						<div class="filter_wrap">
							<table class="brd_write left_header">
								<colgroup>
									<col width="150px" />
									<col width="*" />
								</colgroup>
								<tr>
									<th scope="row">
										서비스 유형<input type="checkbox" id="serviceType" checked="checked" value="'C','CE','T','TE'" /> 
									</th>
									<td id="svcTypeChkbox"></td>
								</tr>
								<tr>
									<th scope="row">기관명</th>
									<td>
										<input type="text" name="orgNm" id="orgNm" value="" />
									</td>
								</tr>
								<tr>
									<th scope="row">서비스 지역</th>
									<td>
										<select id="megaCd" style="width: 150px;">
											<option value="">::: 시도</option>
										</select>
										<select id="ctyCd" style="width: 150px;">
											<option value="">::: 시군구</option>
										</select>
									</td>
								</tr>
							</table>
							<div class="filter_btm">
								<div class="filter_result">
									<dl>
										<dt>전체:</dt>
										<dd id="totOrg"></dd>
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
						<!-- brd_top -->
						<div class="brd_btn brd_top">
							<div class="group_rgt">
								<ul>
									<li><a href="/onmap/admin/org_regist.do" id="btnRegist" class="btn_confirm">신규등록</a></li>
								</ul>
							</div>
						</div>
						<!-- //brd_top -->

						<table class="brd_list">
							<colgroup>
								<col width="" />
							</colgroup>
							<thead>
								<tr>
									<th scope="col">서비스<br/>유형</th>
									<th scope="col">기관명</th>
									<th scope="col">사용 시작일</th>
									<th scope="col">사용 종료일</th>
									<th scope="col">접속건수</th>
									<th scope="col">계약담당자<br/>(소속/담당자)</th>
									<th scope="col">계약금액<br/>(원)</th>
								</tr>
							</thead>
							<tbody id="orgListTbody"></tbody>
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