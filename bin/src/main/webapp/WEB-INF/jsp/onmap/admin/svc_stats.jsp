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
	
	var jq = $('#contents');   // 서비스 사용통계 제이쿼리 루트 셀렉터
	
	/**
	 * @description 서비스 사용통계 리스트 테이블 UI 생성하는 함수 
	 * @param data: 테이블생성시 필요데이터, Array  
	 */
	function makeSvcStatsListTableDOM(data) {
		jq.find('#svcStatsListTbody').empty();
		
		var tbodyContents = '';
		
		if(data.length === 0) {
			tbodyContents += '<tr>';
			tbodyContents += 	'<td colspan="9">해당 기관에 대한 서비스 사용통계가 없습니다.</td>';
			tbodyContents += '</tr>';
		} else {
			data.forEach(function(d, i) {
				
				if(d['full_name']) {
					var fullName = '(' + d['full_name'] + ')';
				} else {
					var fullName = '';
				}
				
				tbodyContents += '<tr>';
				tbodyContents += 	'<td>' + d['org_nm'] + fullName + '</td>';
				tbodyContents += 	'<td>' + d['time'] + '</td>';
				tbodyContents += 	'<td>' + numberWithCommas(d['access_cnt']) + '</td>';
				tbodyContents += 	'<td>' + numberWithCommas(d['ecnmy24']) + '</td>';
				tbodyContents += 	'<td>' + numberWithCommas(d['ecnmy_trnd']) + '</td>';
				tbodyContents += 	'<td>' + numberWithCommas(d['evnt_effect']) + '</td>';
				tbodyContents += '</tr>';
			});
		}
		
		jq.find('#svcStatsListTbody').append(tbodyContents);
	}
	
	// 검색 결과 조회
	jq.find("#btnSearch").click(function() {

		var type = jq.find("input:radio[name=date]:checked").val();   // 기간 구분
		var startDt = jq.find("#startDt").val();      				  // 기간선택 시작 
		var endDt = jq.find("#endDt").val();						  // 기간선택 끝 
		var orgId = jq.find('#orgId').val();						  // 기관아이디
		
		if(Number(jq.find("#startDt").val()) > Number(jq.find("#endDt").val())){
			alert("기간의 마지막날이 시작일보다 작을 수 없습니다.");
			return false;
		}
		
		// 사용통계 리스트 테이블 DOM 새로 생성 
		getSvcStatsList({
			type: type,
			startDt: startDt,
			endDt: endDt,
			orgId: orgId,
			limit: 10
		}, makeSvcStatsListTableDOM);
		
		// 사용통계 총건수 가져옴
		getTotSvcStatsList({
			type: type,
			startDt: startDt,
			endDt: endDt,
			orgId: orgId
		}, function(data) {
			
			// 서비스 사용통계 총건수 화면 표현 
			jq.find('#totSvcStatsList').text(data);
			
			// 페이지리스트 DOM 새로 생성 
			makePageDOM({totCnt: data}, function(params) {
				
				// 파라미터가 비어있으면 리턴 
				if($.isEmptyObject(params)) {
					return;
				}
				
				// 사용통계 리스트 테이블 DOM 새로 생성 
				getSvcStatsList({
					type: type,
					startDt: startDt,
					endDt: endDt,
					orgId: orgId,
					limit: params['limit'],
					offset: params['offset']
				}, makeSvcStatsListTableDOM);
			});
		});
	});

	// 조회버튼 엔터 
	$("body").keydown(function(key) {
		
		if(key.keyCode == 13) {
			var type = jq.find("input:radio[name=date]:checked").val();   // 기간 구분
			var startDt = jq.find("#startDt").val();      				  // 기간선택 시작 
			var endDt = jq.find("#endDt").val();						  // 기간선택 끝 
			var orgId = jq.find('#orgId').val();						  // 기관아이디
			
			if(Number(jq.find("#startDt").val()) > Number(jq.find("#endDt").val())){
				alert("기간의 마지막날이 시작일보다 작을 수 없습니다.");
				return false;
			}
			
			// 사용통계 리스트 테이블 DOM 새로 생성 
			getSvcStatsList({
				type: type,
				startDt: startDt,
				endDt: endDt,
				orgId: orgId,
				limit: 10
			}, makeSvcStatsListTableDOM);
			
			// 사용통계 총건수 가져옴
			getTotSvcStatsList({
				type: type,
				startDt: startDt,
				endDt: endDt,
				orgId: orgId
			}, function(data) {
				
				// 서비스 사용통계 총건수 화면 표현 
				jq.find('#totSvcStatsList').text(data);
				
				// 페이지리스트 DOM 새로 생성 
				makePageDOM({totCnt: data}, function(params) {
					
					// 파라미터가 비어있으면 리턴 
					if($.isEmptyObject(params)) {
						return;
					}
					
					// 사용통계 리스트 테이블 DOM 새로 생성 
					getSvcStatsList({
						type: type,
						startDt: startDt,
						endDt: endDt,
						orgId: orgId,
						limit: params['limit'],
						offset: params['offset']
					}, makeSvcStatsListTableDOM);
				});
			});
		}
	});
	
	// 엑셀 다운로드
	jq.find("#btnExcel").click(function() {
		var type = jq.find("input:radio[name=date]:checked").val();   // 기간 구분
		var startDt = jq.find("#startDt").val();      				  // 기간선택 시작 
		var endDt = jq.find("#endDt").val();						  // 기간선택 끝 
		var orgId = jq.find('#orgId').val();						  // 기관아이디
		
		makeExcelSvcStats({
			type: type,
			startDt: startDt,
			endDt: endDt,
			orgId: orgId
		}, function(data) {
			fileDown("서비스 사용통계.xlsx", data.fileName,"Y");
		});
	});
	
	// 사용통계 리스트 테이블 DOM 새로 생성 
	getSvcStatsList({
		type: 'month',
		limit: 10
	}, makeSvcStatsListTableDOM);
	
	// 기관명 셀렉트박스 DOM 생성
	getOrgList({}, function(data) {
		
		var options = '';
		
		data.forEach(function(d, i) {
			options += '<option value="' + d['org_id'] + '">' + d['org_nm'] + '</option>';
		});
		
		jq.find('#orgId').append(options);
	});
	
	// 사용통계 총건수 가져옴
	getTotSvcStatsList({
		type: 'month',
		startDt: '',
		endDt: getStringDt(new Date(), 'month')
	}, function(data) {
		
		// 서비스 사용통계 총건수 화면 표현 
		jq.find('#totSvcStatsList').text(data);
		
		// 페이지리스트 DOM 새로 생성 
		makePageDOM({totCnt: data}, function(params) {
			
			// 파라미터가 비어있으면 리턴 
			if($.isEmptyObject(params)) {
				return;
			}
			
			// 사용통계 리스트 테이블 DOM 새로 생성 
			getSvcStatsList({
				type: jq.find("input:radio[name=date]:checked").val(),
				limit: params['limit'],
				offset: params['offset']
			}, makeSvcStatsListTableDOM);
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
						<h3 class="tit">서비스 사용통계</h3>
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
									<th scope="row">기간 구분</th>
									<td>
										<label for="dateMonth"><input type="radio" name="date" id="dateMonth" value="month" checked="checked" />월</label>
										<label for="dateDay"><input type="radio" name="date" id="dateDay" value="day" />일</label>
									</td>
								</tr>
								<tr>
									<th scope="row">기간 선택</th>
									<td>
										<input type="text" name="startDt" id="startDt" value="" class="pop_calendar" maxlength="8" /> 
									-
										<input type="text" name="endDt" id="endDt" value="" class="pop_calendar" maxlength="8" />
									</td>
								</tr>
								<tr>
									<th scope="row">기관명</th>
									<td>
										<select name="orgId" id="orgId" style="width:150px">
											<option value="">전체</option>
										</select>
									</td>
								</tr>
							</table>
							<div class="filter_btm">
								<div class="filter_result">
									<dl>
										<dt>전체:</dt>
										<dd id="totSvcStatsList"></dd>
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
						<table class="brd_list brd_bdr">
							<colgroup>
								<col width="" />
							</colgroup>
							<thead>
								<tr>
									<th scope="col" rowspan="2">이용기관</th>
									<th scope="col" rowspan="2">기간</th>
									<th scope="col" rowspan="2">사용자 접속건수</th>
									<th scope="col" colspan="6">서비스 이용건수</th>
								</tr>
								<tr>
									<th scope="col">경제24시</th>
									<th scope="col">경제트렌드</th>
									<th scope="col">이벤트효과</th>
								</tr>
							</thead>
							<tbody id="svcStatsListTbody"></tbody>
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