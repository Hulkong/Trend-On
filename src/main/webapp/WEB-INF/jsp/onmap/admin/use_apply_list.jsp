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

	// 사용신청 현황 제이쿼리 루트 셀렉터
	var jq = $('#contents');  
	
	/**
	 * @description 사용신청 현황리스트 테이블 UI 생성하는 함수 
	 * @param data: 테이블생성시 필요데이터, Array  
	 */
	function makeUseApplyListTableDOM(data) {
		
		jq.find('#useApplyListTbody').empty();
		
		var tbodyContents = '';
		
		if(data.length === 0) {
			tbodyContents += '<tr>';
			tbodyContents += 	'<td colspan="10">등록된 사용신청 정보가 없습니다.</td>';
			tbodyContents += '</tr>';
		} else {
			data.forEach(function(d, i) {
				
				var queryString = $.param({
					no: d['no'],
					state: d['state'],
				});
				
				tbodyContents += '<tr>';
				tbodyContents += 	'<td>' + d['cnt'] + '</td>';
				tbodyContents += 	'<td>';
				tbodyContents += 		'<a href="/onmap/admin/use_apply_updt.do?' + queryString + '" class="btnUseApplyUpt">' + d['org_nm'] + '</a>';
				tbodyContents += 	'</td>';
				tbodyContents += 	'<td>'+ d['dept'] + '</td>';
				tbodyContents += 	'<td>' + d['position'] + '</td>';
				tbodyContents += 	'<td>' + d['name'] + '</td>';
				tbodyContents += 	'<td>' + d['mobile'] + '</td>';
				tbodyContents += 	'<td>' + d['email'] + '</td>';
				tbodyContents += 	'<td>' + d['newsletter_yn'] + '</td>';
				tbodyContents += 	'<td>' + d['reg_date'] + '</td>';
				tbodyContents += 	'<td>' + d['state_msg'] + '</td>';
				tbodyContents += '<tr>';
			});
		}
		
		jq.find('#useApplyListTbody').append(tbodyContents);	} 
	
	// 조회버튼 클릭 
	jq.find("#btnSearch").click(function() {
		
		var orgNm = jq.find('#orgNm').val();       // 기관명
		var mngNm = jq.find('#mngNm').val();	   // 담당자 이름
		var state = jq.find('#state').val();       // 상태 
		var startDt = jq.find('#startDt').val();   // 사용신청 일자 시작 
		var endDt = jq.find('#endDt').val();       // 사용신청 일자 끝
		
		if(Number(jq.find("#startDt").val()) > Number(jq.find("#endDt").val())){
			alert("기간의 마지막날이 시작일보다 작을 수 없습니다.");
			return false;
		}
		
		// 사용신청 현황 리스트 테이블 DOM 새로 생성 
		getUseApplyList({
			orgNm: orgNm,
			mngNm: mngNm,
			state: state,
			startDt: startDt, 
			endDt: endDt, 
			limit: 10
		}, makeUseApplyListTableDOM);
		
		// 사용신청 현황 전체건수 표현 및 페이지리스트 DOM 새로 생성 
		getTotUseApplyList({
			orgNm: orgNm,
			mngNm: mngNm,
			state: state,
			startDt: startDt, 
			endDt: endDt
		}, function(data) {
			
			// 사용신청 현황 전체건수 표현 
			jq.find('#totApplyList').text(data);
			
			// 페이지리스트 DOM 새로 생성 
			makePageDOM({totCnt: data}, function(params) {
							
				// 파라미터가 비어있으면 리턴 
				if($.isEmptyObject(params)) {
					return;
				}
				
				// 사용신청 현황 리스트 테이블 DOM 새로 생성 
				getUseApplyList({
					orgNm: orgNm,
					mngNm: mngNm,
					state: state,
					startDt: startDt, 
					endDt: endDt,
					limit: params['limit'],
					offset: params['offset']
				}, makeUseApplyListTableDOM);
			});
		});
	});
	
	// 조회버튼 엔터 
	$("body").keydown(function(key) {
		
		if(key.keyCode == 13) {
			
			var orgNm = jq.find('#orgNm').val();    	   // 기관명
			var mngNm = jq.find('#mngNm').val();
			var state = jq.find('#state').val();   // 서비스 유형 
			var startDt = jq.find('#startDt').val();
			var endDt = jq.find('#endDt').val();
			
			// 사용신청 현황 리스트 테이블 DOM 새로 생성 
			getUseApplyList({
				orgNm: orgNm,
				mngNm: mngNm,
				state: state,
				startDt: startDt, 
				endDt: endDt, 
				limit: 10
			}, makeUseApplyListTableDOM);
			
			// 사용신청 현황 전체건수 표현 및 페이지리스트 DOM 새로 생성 
			getTotUseApplyList({
				orgNm: orgNm,
				mngNm: mngNm,
				state: state,
				startDt: startDt, 
				endDt: endDt
			}, function(data) {
				
				// 사용신청 현황 전체건수 표현 
				jq.find('#totApplyList').text(data);
				
				// 페이지리스트 DOM 새로 생성 
				makePageDOM({totCnt: data}, function(params) {
								
					// 파라미터가 비어있으면 리턴 
					if($.isEmptyObject(params)) {
						return;
					}
					
					// 사용신청 현황 리스트 테이블 DOM 새로 생성 
					getUseApplyList({
						orgNm: orgNm,
						mngNm: mngNm,
						state: state,
						startDt: startDt, 
						endDt: endDt,
						limit: params['limit'],
						offset: params['offset']
					}, makeUseApplyListTableDOM);
				});
			});
		}
	});
	
	// 엑셀 다운로드
	jq.find("#btnExcel").click(function() {
		var orgNm = jq.find('#orgNm').val();    	   // 기관명
		var mngNm = jq.find('#mngNm').val();
		var state = jq.find('#state').val();   // 서비스 유형 
		var startDt = jq.find('#startDt').val();
		var endDt = jq.find('#endDt').val();
		
		makeExcelUseApply({
			orgNm: orgNm,
			mngNm: mngNm,
			state: state,
			startDt: startDt, 
			endDt: endDt,
		}, function(data) {
			fileDown("사용신청 이력.xlsx", data.fileName,"Y");
		});
		
	});

	// 상태 DOM 생성 
	getCommonCodeList({code: 'USE_APPLY_CD'}, function(data) {
		
		var options = '';
		
		data.forEach(function(d, i) {
			options += '<option value="' + d['code'] + '">' + d['cd_nm'] + '</option>';
		});
		
		jq.find('#state').append(options);
	});
	
	// 사용신청 현황 테이블 DOM 생성
	getUseApplyList({
		limit: 10
	}, makeUseApplyListTableDOM);
	
	// 사용신청 현황 전체건수 표현 및 페이지리스트 DOM 새로 생성 
	getTotUseApplyList({}, function(data) {
		
		// 사용신청 현황 전체건수 표현
		jq.find('#totApplyList').text(data);
		
		// 페이지리스트 DOM 새로 생성 
		makePageDOM({totCnt: data}, function(params) {
			
			// 파라미터가 비어있으면 리턴 
			if($.isEmptyObject(params)) {
				return;
			}
			
			// 사용신청 현황 테이블 DOM 새로 생성 
			getUseApplyList({
				limit: params['limit'],
				offset: params['offset']
			}, makeUseApplyListTableDOM);
		});
	});
	
	// 오늘날짜 기준으로 endDt값 세팅
	jq.find('#endDt').val(getStringDt(new Date(), 'day'));
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
						<h3 class="tit">사용신청 현황</h3>
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
									<th scope="row">기관명</th>
									<td>
										<input type="text" name="orgNm" id="orgNm" value="" />
									</td>
								</tr>
								<tr>
									<th scope="row">담당자 이름</th>
									<td>
										<input type="text" name="mngNm" id="mngNm" value="" />
									</td>
								</tr>
								<tr>
									<th scope="row">상태</th>
									<td>
										<select name="state" id="state" style="width: 150px;">
											<option value="">전체</option>
										</select>
									</td>
								</tr>
								<tr>
									<th scope="row">사용자신청 일자</th>
									<td>
										<input type="text" name="startDt" id="startDt" value="" class="pop_calendar" maxlength="8" /> -
										<input type="text" name="endDt" id="endDt" value="" class="pop_calendar" maxlength="8" />
									</td>
								</tr>
							</table>
							<div class="filter_btm">
								<div class="filter_result">
									<dl>
										<dt>전체:</dt>
										<dd id="totApplyList"></dd>
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
									<li><a href="#" id="btnExcel" class="btn_confirm">엑셀다운로드</a></li>
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
									<th scope="col">중복여부</th>
									<th scope="col">기관명</th>
									<th scope="col">담당부서</th>
									<th scope="col">직함</th>
									<th scope="col">이름</th>
									<th scope="col">연락처</th>
									<th scope="col">이메일</th>
									<th scope="col">뉴스레터<br/>동의</th>
									<th scope="col">사용신청<br/>등록일</th>
									<th scope="col">상태</th>
								</tr>
							</thead>
							<tbody id="useApplyListTbody"></tbody>
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