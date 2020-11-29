<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page session="false" %>
<!doctype html>
<html lang="ko">
	<head>
		<title>${globalConfig['config.trendOn.title']}</title>
		<meta charset="utf-8" />
		<link rel="shortcut icon" type="image/x-icon" href="/images/common/favicon.ico" />
		<link rel="stylesheet" href="/css/import.css?ver=${globalConfig['config.version']}" />
		<link rel="stylesheet" href="/css/reset.css?ver=${globalConfig['config.version']}"  />
		<link rel="stylesheet" href="/css/common.css?ver=${globalConfig['config.version']}"  />
		<link rel="stylesheet" href="/css/style.css?ver=${globalConfig['config.version']}"  />
		<link rel="stylesheet" href="/css/dev.css?ver=${globalConfig['config.version']}"  />
		<script src="/js/jquery/jquery-1.11.2.min.js"></script>
		<script src="/js/jquery/jquery.easing.1.3.js"></script>
		<script src="/js/jquery/jquery-ui.js"></script>
		<script src="/js/jquery/jquery.fullpage.js"></script>
		<script src="/js/common.js?ver=${globalConfig['config.version']}"></script>
		<script src="/js/map.js?ver=${globalConfig['config.version']}"></script>
		
		<script src="/js/Leaflet-1.0.2/geostats.js"></script>
		<link rel="stylesheet" href="/js/Leaflet-1.0.2/leaflet.css" />
		<script type="text/javascript" src="/js/Leaflet-1.0.2/leaflet-src.js"></script>
		
		<script src="/js/d3Chart/d3.js"></script>
		<script src="/js/d3Chart/d3plus.js"></script>
		<script src="/js/d3Chart/d3Chart.js"></script>
	</head>
	<body>
		<div id="fog">
			<div class="reportDataLoading">
				<div class="loadingBox">
					<p class="tit">리포트 데이터를 생성중입니다.</p>
					<p><img src="/images/common/loading.gif" alt="로딩"/></p>
					<p class="desc">기간선택에 따라 다소 시간이 걸릴 수 있습니다.</p>
				</div>
			</div>
		</div>
		<div id="fog2">
			<div class="_dataReady">
				<div class="_container">
					<div class="_header">
					<p onclick="$(fog2).css('display', 'none')">X</p>
					</div>
					<div class="_contents">
					<p class="tit">보다 나은 서비스 제공을 위한 지역간 비교 업데이트 안내</p>
					<p class="desc">지역간 비교 기능이 업데이트 중입니다.</p>
					<p class="desc">안정적인 환경을 구축하기 위해 잠시 서비스 이용이 제한되는 점, 양해부탁드립니다.</p>
					<p class="desc">빠른 시일 내에 업데이트를 완료하겠습니다.</p>
					<p class="desc">감사합니다.</p>
					</div>
				</div>
			</div>
		</div>
		<div id="wrap">
			<!-- header -->
			<div id="header">
				<h1 class="logo"><a href="/onmap/crfc_main.do"><img src="/images/common/logo.png" alt="logo" /></a></h1>
				<div class="gnb">
					<%@ include file="/WEB-INF/jsp/onmap/main/include/layer_user.jsp" %>
					<c:set var="length" value="${fn:length(userInfo.cty_nm)}" />
					<c:set var="ctyName" value="${userInfo.cty_nm}" />
				</div>
				<div id="nav">
					<ul>
						<li><a href="/onmap/ecnmy_24/main.do">${ctyName} 24시</a></li>
						<li class="on"><a href="/onmap/ecnmy_trnd/main.do">경제 트렌드</a></li>
						<li><a href="/onmap/event_effect/main.do">이벤트 효과</a></li>
					</ul>
				</div>
			</div>
			<!-- //header -->

			<hr />

			<!-- contents -->
			<div id="contents">
				<div id="fp-nav2" class="section_top">
					<ul class="menu_anchor">
						<li><a href="#firstPage">거래금액</a></li>
						<li><a href="#secondPage">유입인구 특성</a></li>
						<li><a href="#thirdPage">유입인구 소비</a></li>
					</ul>
					<div class="compare_area">
						<a href="#none" class="btn_compare layer_open">지역간 비교</a>
						<!-- 레이어 팝업 ==================================================================================================== -->
						<div class="pop_layer">
							<div class="layer_compare">
								<!-- 상단 -->
								<div class="compare_header">
									<p class="tit_compare">지역간 비교</p>
									<div class="txt_period">
										2017.10.10 ~ 2017.10.10
									</div>
									<ul class="menu_compare">
										<li class="active"  page-id="anchorNav01"><a href="#none">거래금액</a></li> 
										<li page-id="anchorNav02"><a href="#none">유입인구 특성</a></li>
										<li page-id="anchorNav03"><a href="#none">유입인구 소비</a></li>
									</ul>
 									<a href="#none" class="btn_ty1" id="compareSelectBtn">지역선택</a>
									<a href="#none" class="btn_close region_close">닫기</a>
								</div>
								<!-- //상단 -->
								<!-- 본문 - 선택 ============================== -->
								<div class="compare_body">
									<div class="article_select">
										<div class="group_select">
											<p class="tit"><em>시/도</em>를 선택하세요</p>
											<div class="group_scroll" id="regionGroup1">
												<ul>
													<c:if test="${!empty regionMegaList }">
														<c:forEach var="item" items="${regionMegaList }">
																<li class="regionGroup1"><a href="#none" data-id="${item.id }" >${item.nm }</a></li>
														</c:forEach>
													</c:if>
												</ul>
											</div>
										</div>
										<div class="group_select">
											<p class="tit"><em>군/구</em>를 선택하세요</p>
											<div class="group_scroll" id="regionGroup2">
												<ul>
													<c:if test="${!empty regionCtyList }">
														<c:forEach var="item" items="${regionCtyList }">
																<li><a href="#none" data-id="${item.id }" >${item.nm }</a></li>
														</c:forEach>
													</c:if>
													<c:if test="${empty regionCtyList }">
														<li>시/도를 선택해주세요.</li>
													</c:if>
												</ul>
											</div>
										</div>
									</div>
									<div class="compare_btm">
										<ul>
											<li><button class="btn_confirm btn_show_compare" id="select_confirm">확인</button></li>
											<li><button class="btn_cancel btn_close compare_close">취소</button></li>
										</ul>
									</div>
								</div>
								<!-- //본문 - 선택 ============================== -->

								<!-- 본문 - 선택결과비교 ============================== -->
								<div class="compare_result">

								</div>
								<!-- //본문 - 선택결과비교 ============================== -->
							</div>
						</div>
						<!-- //레이어 팝업 ==================================================================================================== -->
					</div>
					<div class="article_rgt">
						<div class="group_period">
							<span class="search_period">2017. 06. 15 ~ 2017. 07. 26</span>
							<span class="btn_period"><a href="#layerPeriod">기간 직접 입력</a></span>
							<div id="layerPeriod" class="layer_period">
								<div class="pop_header">
									<p class="tit">기간 직접 입력</p>
									<p class="pop_period_txt">
										(데이터 기준일자 : <strong 	id="standard_period">2017년 01월 ~ 2017년 12월</strong>)<br/>
										(조회가능 범위 : 
										<c:choose> 
											<c:when test="${serviceClss ne 3 }">최대 1년</c:when>
											<c:when test="${serviceClss eq 3 }">최대 3개월</c:when>
										</c:choose>
										, 최소 3일)
									</p>
									<a href="##" class="btn_close">닫기</a>
								</div>
								<div class="pop_contents">
									<div class="article_calendar">
										<div class="group_lft">
											<p class="tit">시작일</p>
											<p class="txt" id="popSelectedSdate">2017.7.5</p>
											<div id="sDatepicker"></div>

										</div>
										<div class="group_rgt">
											<p class="tit">종료일</p>
											<p class="txt" id="popSelectedEdate">2017.7.5</p>
											<div id="eDatepicker"></div>

										</div>
									</div>
								</div>
								<div class="pop_footer">
									<button type="button" class="btn_confirm" onclick="changePeriod()">선택</button>
								</div>
							</div>
						</div>
						<div class="btn_list">
							<ul>
								<li class="btn_pdf"><a href="#">PDF 다운</a></li>
<!-- 								<li class="btn_print"><a href="#">인쇄</a></li> -->
							</ul>
						</div>
					</div>
					<!-- 상단 고정 그래프 -->
					<div class="top_graph">
						<!-- 도움말 -->
						<div class="group_help">
							<p class="fs13">
								조회를 원하시는 시간대에 따라 스크롤을 움직여 보세요.<br/>
								<span class="fs11">
								(데이터 기준일자 : <span id="dateWarn"></span>)<br/>
								(조회가능 범위 :
								<c:choose> 
									<c:when test="${serviceClss ne 3 }">최대 1년</c:when>
									<c:when test="${serviceClss eq 3 }">최대 3개월</c:when>
								</c:choose>
								, 최소 3일)
								</span>
							</p>
						</div>
						<!-- //도움말 -->
					
						<div class="bx_graph dateRage" id="rangeChart">

						</div>
					</div>
					<!-- //상단 고정 그래프 -->
				</div>

				<!-- 본문 ==================================================================================================== -->
				<div id="fullpage">
					<!-- section1 거래금액 ============================== -->
					<div class="section" id="section1">
						<div class="inner">
							<h3 class="hide">거래금액</h3>
							<!--  -->
							<div class="article_group">
								<div class="article_lf">
									<h4 class="tit">지역별 거래금액</h4>
									<dl>
										<dt class="total">${userInfo.cty_nm} 총 거래금액 :</dt>
										<dd class="total" id="amtTotal_ET"></dd>
									</dl>
									<table class="brd_dl" id="amt_list">
										
									</table>
									<p class="txt_infor">거래금액은 신용카드 사용실적 빅데이터를 기반으로<br/> 
														 현금거래 비율을 적용하여 추정</p>
								</div>
								<div class="article_rg">
									<div class="bx_graph" id="trendMap1_1">
										<img src="/images/common/icon_reload.png" alt="지도 초기화" title="전체보기" class="map_reLoad" onclick="mapReload('trend1_1')"/>
										<div id="ecnmyTrnd_salamt_legend" class="map legend"></div>

									</div>
								</div>
							</div>
							<!-- // -->

							<!--  -->
							<div class="article_group">
								<div class="article_lf">
									<h4 class="tit">업종별 거래금액</h4>
									<dl>
										<dt class="total">최대 매출 업종 :</dt>
										<dd class="total"><strong id="upTotal_ET"></strong></dd>
									</dl>
									<table class="brd_dl" id="upAmt_list">

									</table>
									<p class="txt_infor">분석업종은 지역경제와 밀접한 소분류 업종을 업종간<br/>
														  연관성을 고려하여 40개로 그룹화(백화점, 할인점, 예식장,<br/>
														  호텔, 영화관 등의 대형업종은 분석대상에서 제외)</p>
								</div>
								<div class="article_rg">
									<div class="bx_graph" id="amtTreemap">

									</div>
								</div>
							</div>
							<!-- // -->
						</div>
					</div>
					<!-- //section1 매출액 -->

					<!-- section2 유입인구 특성 ============================== -->
					<div class="section" id="section2">
						<div class="inner">
							<h3 class="hide">유입인구 특성</h3>
							<!--  -->
							<div class="article_group">
								<div class="article_lf">
									<h4 class="tit">지역별 유입인구 수</h4>
									<dl>
										<dt class="total">${ctyName} 유입인구 총 수 :</dt>
										<dd class="total" id="vstTotal_ET"> </td>
									</dl>
									<table class="brd_dl" id="vst_list">

									</table>
									<p class="txt_infor">
										 "유입인구"는 분석지역(시군구 단위)이외 지역에 거주지를 두고<br/> 
										 조회기간 동안 해당지역에서 소비행위를 한 인구
									</p>
								</div>
								<div class="article_rg">
									<div class="bx_graph" id="trendMap1_2">
										<img src="/images/common/icon_reload.png" alt="지도 초기화" title="전체보기" class="map_reLoad" onclick="mapReload('trend1_2')"/>
										<div id="ecnmyTrnd_cnt_legend" class="map legend"></div>

									</div>
								</div>
							</div>
							<!-- // -->

							<!--  -->
							<div class="article_group">
								<div class="article_lf">
									<h4 class="tit">성/연령별 대표 유입인구</h4>
									<dl>
										<dt class="total">유입인구 :</dt>
										<dd class="total" id="vst_char_ET"> </td>
									</dl>
									<p class="txt_sub_dl">${ctyName} 상권을 가장 많이 이용한 유입소비인구</p>
									<dl>
										<dt class="total">상주인구 :</dt>
										<dd class="total" id="ctzn_char_ET"> </td>
									</dl>
									<p class="txt_sub_dl">${ctyName} 상권을 가장 많이 이용한 상주인구</p>

									<p class="txt_infor">
										“상주인구＂는 분석지역(시군구 단위)에 자택 또는<br/>
										직장 주소를 두고 조회기간동안 해당지역에서<br/>
										소비행위를 한 인구
									</p>
								</div>
								<div class="article_rg">
									<div class="bx_graph" id="cntBar">

									</div>
								</div>
							</div>
							<!-- // -->
						</div>
					</div>
					<!-- //section2 유입인구 특성 ============================== -->

					<!-- section3 유입인구 소비 ============================== -->
					<div class="section" id="section3">
						<div class="inner">
							<h3 class="hide">유입인구 소비</h3>
							<!--  -->
							<div class="article_group">
								<div class="article_lf">
									<h4 class="tit">지역별 유입인구 소비</h4>
									<dl>
										<dt class="total">유입인구 소비총액 :</dt>
										<dd class="total" id="cnsmpTotal_ET"></td>
									</dl>
									<table class="brd_dl" id="cnsmp_list">
										
									</table>
									<p class="txt_infor">
										분석지역(시군구) 상주인구 외에 유입소비인구가<br/>
										소비한 금액을  기준으로 합산
									</p>
								</div>
								<div class="article_rg">
									<div class="bx_graph" id="trendMap1_3">
										<img src="/images/common/icon_reload.png" alt="지도 초기화" title="전체보기" class="map_reLoad" onclick="mapReload('trend1_3')"/>
										<div id="ecnmyTrnd_expndtr_legend" class="map legend"></div>

									</div>
								</div>
							</div>
							<!-- // -->

							<!--  -->
							<div class="article_group">
								<div class="article_lf">
									<h4 class="tit">업종별 유입인구 소비특성</h4>
									<dl>
										<dt class="total">활성업종 :</dt>
										<dd class="total"><strong id="up_cnsmpTotal_ET"> </strong></dd>
									</dl>
									<table class="brd_dl">
										<tr>
											<th id="up_cnsmp_nm_ET"> </th>
											<td id="up_cnsmp_val_ET"><strong> </strong>원</td>
										</tr>
									</table>

									<dl>
										<dt class="total">특화업종 :</dt>
										<dd class="total"><strong id="up_spacialTotal_ET"> </strong></dd>
									</dl>
									<table class="brd_dl">
										<tr>
											<th id="up_spacial_nm_ET"></th>
											<td id="up_spacial_val_ET"></td>
										</tr>
									</table>
									<p class="txt_infor">소비 특화지수: C = A/B *100 <br/>시군구 T업종 매출액 비율(%): A <br/>시도 T업종 매출액 비율(%): B</p>
								</div>
								<div class="article_rg">
									<div class="bx_graph">
										<div class="graph_half">
											<h5 class="tit">활성업종</h5>
											<div  id="expndtrBar1" class="box_pos"></div>
										</div>
										<div class="graph_half">
											<h5 class="tit">특화업종</h5>
											<div  id="expndtrBar2" class="box_pos"></div>
										</div>
									</div>
								</div>
							</div>
							<!-- // -->

							<!--  -->
							<div class="article_group">
								<div class="article_lf">
									<h4 class="tit">유입인구 소비시간</h4>
									<dl>
										<dt class="total">주요 소비시간 :</dt>
										<dd class="total"><strong id="cnsmpTimeTotal_ET"> </strong></dd>
									</dl>
									<table class="brd_dl" id="time_list">
										
									</table>
									<p class="txt_infor">시간대 표현은 01시 ~ 24시</p>
								</div>
								<div class="article_rg">
									<div class="bx_graph" id="inflowBar">

									</div>
								</div>
							</div>
							<!-- // -->

							<!--  -->
							<div class="article_group">
								<div class="article_lf">
									<h4 class="tit">유입인구 유입지역</h4>
									<dl>
										<dt class="total">주요 유입지역 :</dt>
										<dd class="total" id="inflowTotal_ET"> </dd>
									</dl>
									<table class="brd_dl" id="inflow_list">
										<tr>
											<th id="inflow1_nm_ET"> </th>
											<td id="inflow1_val_ET"> </td>
										</tr>
										<tr>
											<th id="inflow2_nm_ET"> </th>
											<td id="inflow2_val_ET"> </td>
										</tr>
										<tr>
											<th id="inflow3_nm_ET"> </th>
											<td id="inflow3_val_ET"> </td>
										</tr>
									</table>
									<p class="txt_infor">유입지역은 전국 226개 시군구 대상 </p>
								</div>
								<div class="article_rg">
									<div class="bx_graph" id="trendMap1_4">
										<img src="/images/common/icon_reload.png" alt="지도 초기화" title="전체보기" class="map_reLoad" onclick="mapReload('trend1_4')"/>
										<div id="ecnmyTrnd_inflow_legend" class="map legend"></div>
									</div>
								</div>
							</div>
							<!-- // -->
						</div>
					</div>
					<!-- //section3 유입소비인구 지출 ============================== -->
					</div>
				</div>
				<!-- //본문 ==================================================================================================== -->
			</div>
			<!-- //contents -->

			<!-- footer -->
			<%@ include file="/WEB-INF/jsp/onmap/main/include/layer_footer.jsp" %>
<!-- 			<div id="footer"> -->
<!-- 				<div class="inner off"> -->
<!-- 					<button type="button" class="toggle_footer">열기</button> -->
<!-- 					<ul class="f_menu"> -->
<!-- 						<li><a href="/common/policy.html?page=0" target="_blank">서비스 약관</a></li> -->
<!-- 						<li><a href="/common/policy.html?page=1" target="_blank">개인정보 취급방침</a></li> -->
<!-- 						<li><a href="http://www.openmate-on.co.kr/" target="_blank">회사소개</a></li> -->
<!-- 					</ul> -->
<!-- 					<address> -->
<!-- 						서울특별시 서대문구 통일로 87, NH농협생명빌딩 동관 6층 (주) 오픈메이트온<br /> -->
<!-- 						사업자번호 : 763-88-01165    TEL. 02-395-7540~1    FAX. 02-395-7522    EMAIL. sales@openmate-on.co.kr -->
<!-- 					</address> -->
<!-- 					<p class="company_logo"> -->
<!-- 						<image src="/images/main/mateon_footer_logo.png" alt="OPENmate_ON"/> -->
<!-- 						<image src="/images/main/NICE_gray.png" alt="nice"/> -->
<!-- 					</p> -->
<!-- 					<p class="copyright">Copyright ⓒ OPENmate_ON All rights reserved.</p> -->
<!-- 				</div> -->
<!-- 			</div> -->
			<!-- //footer -->
		</div>
	</body>

	<script type="text/javascript">

	var bDate ;
	var lDate ;
	var eDate ;
	var timeHandlerId = null;
	var timeChart = null;

	var ecnmy_trnd_config = {
			layerFid : {},
			sessionCtyCd:'${userInfo.cty_cd}',
			sessionCtyNm:'${userInfo.cty_nm}',
			sessionUserNo:'${userInfo.user_no}',
			sessionTypeCd: '${userInfo.service_clss}',
			selectedStartDate:'${startDate}',
			selectedEndDate:'${endDate}',
			selectedRgnClss:'H4',
// 			limitStartDate:'20150501',
			limitStartDate:'20180101',
			limitEndDate:'20181231',
			minPeriod : '${minPeriod}',		// 달력에서 최소 선택 일
			maxPeriod : '${maxPeriod}'		// 달력에서 초대 선택 월
	};

	var colorArr = [ '#2c7bb6', '#abdda4', '#ffffbf','#fdae61', '#d7191c' ];

	var mapArr = {
			trend1_1 : { bounds:null , map:null, data:null, layer:null, init:null , popupStop : true
					   , popup:{column:"sale_amt_kr",tit:{"value":"지역별 거래금액","color":"#333"},unit:"원"}},
			trend1_2 : { bounds:null , map:null, data:null, layer:null, init:null , popupStop : true 
					   , popup:{column:"total_cnt_kr",tit:{"value":"지역별 유입인구 수","color":"#333"},unit:"명"}},
			trend1_3 : { bounds:null , map:null, data:null, layer:null, init:null , popupStop : true 
					   , popup:{column:"sale_amt_kr",tit:{"value":"지역별 유입인구 소비액","color":"#333"},unit:"원"}},
			trend1_4 : { bounds:null , map:null, data:null, layer:null, init:null ,zoom : 7 , popupStop : true
					   , popup:{column:"rate_kr",tit:{"value":"유입지역별 유입인구 비율","color":"#333"},unit:"%"}},
					   
			trend2_1 : { bounds:null , map:null, data:null, layer:null, init:null , popupStop : true 
					   , popup:{column:"sale_amt_kr",tit:{"value":"지역별 거래금액","color":"#333"},unit:"원"}},
			trend2_2 : { bounds:null , map:null, data:null, layer:null, init:null , popupStop : true 
					   , popup:{column:"total_cnt_kr",tit:{"value":"지역별 유입인구 수","color":"#333"},unit:"명"}},
			trend2_3 : { bounds:null , map:null, data:null, layer:null, init:null , popupStop : true 
					   , popup:{column:"sale_amt_kr",tit:{"value":"지역별 유입인구 소비액","color":"#333"},unit:"원"}},
			trend2_4 : { bounds:null , map:null, data:null, layer:null, init:null ,zoom : 7 , popupStop : true
					   , popup:{column:"rate_kr",tit:{"value":"유입지역별 유입인구 비율","color":"#333"},unit:"%"}},
					   
			trend3_1 : { bounds:null , map:null, data:null, layer:null, init:null , popupStop : true 
					   , popup:{column:"sale_amt_kr",tit:{"value":"지역별 거래금액","color":"#333"},unit:"원"}},
			trend3_2 : { bounds:null , map:null, data:null, layer:null, init:null , popupStop : true 
					   , popup:{column:"total_cnt_kr",tit:{"value":"지역별 유입인구 수","color":"#333"},unit:"명"}},
			trend3_3 : { bounds:null , map:null, data:null, layer:null, init:null , popupStop : true 
					   , popup:{column:"sale_amt_kr",tit:{"value":"지역별 유입인구 소비액","color":"#333"},unit:"원"}},
			trend3_4 : { bounds:null , map:null, data:null, layer:null, init:null ,zoom : 7 , popupStop : true
					   , popup:{column:"rate_kr",tit:{"value":"유입지역별 유입인구 비율","color":"#333"},unit:"%"}}
	};
	
	// 지도 그리기
	function loadMap(id){
		var map = L.map(id,{ zoomControl:false
						   , scrollWheelZoom:false
						   , maxZoom:18
						   , minZoom:7
						   , closePopupOnClick:false
		});
		map.doubleClickZoom.disable();
		new L.Control.Zoom({position:'topright'}).addTo(map);
		L.tileLayer( "${globalConfig['config.vworld.host']}/2d/gray/201411/{z}/{x}/{y}.png"
				   , { attribution : '© Vworld'
					 , maxZoom : 19
					 , minZoom : 7
		}).addTo(map);
		return map;
	};

	// section별 데이터 load
	var sectionFunc = {
			"firstPage" : {
				"status" : false,
				"lastValue" : "test",
				"dataStore" :{},
				"dataViewerLength" : 3,
				"action" : function() {
					// top 그래프 값이 변경됐을 경우에만 함수 처리하기
					if(this.lastValue == ecnmy_trnd_config.selectedStartDate+":"+ecnmy_trnd_config.selectedEndDate){
						return;
					}
					var time = 0;
					if(this.lastValue == 'test'){
						time = 1000;
					}
					setTimeout(function(){
						amtDataText(ecnmy_trnd_config.sessionCtyCd,"",function(data){
							sectionFunc.firstPage.dataStore.amtDataText = data;
						});
						amtDataGraph(ecnmy_trnd_config.sessionCtyCd,"",function(data){
							sectionFunc.firstPage.dataStore.amtDataGraph = data;
						});
						amtDataMap("trend1_1",ecnmy_trnd_config.sessionCtyCd,"",function(name,data){
							sectionFunc.firstPage.dataStore[name] = data;
						});
					},time);
					this.lastValue = ecnmy_trnd_config.selectedStartDate+":"+ecnmy_trnd_config.selectedEndDate;
				}
			},
			"secondPage" : {
				"status" : false,
				"lastValue" : "test",
				"dataStore" :{},
				"dataViewerLength" : 3,
				"action" : function() {
					// top 그래프 값이 변경됐을 경우에만 함수 처리하기
					if(this.lastValue == ecnmy_trnd_config.selectedStartDate+":"+ecnmy_trnd_config.selectedEndDate){
						return;
					}

					var time = 0;
					if(this.lastValue == 'test'){
						time = 1000;
					}

					setTimeout(function(){
						visitrCoText(ecnmy_trnd_config.sessionCtyCd,"",function(data){
							sectionFunc.secondPage.dataStore.visitrCoText = data;
						});
						visitrCoMap("trend1_2",ecnmy_trnd_config.sessionCtyCd,"",function(name,data){
							sectionFunc.secondPage.dataStore[name] = data;
						});
						visitrCoGraph(ecnmy_trnd_config.sessionCtyCd,"",function(data){
							sectionFunc.secondPage.dataStore.visitrCoGraph = data;
						});
					},time);

					this.lastValue = ecnmy_trnd_config.selectedStartDate+":"+ecnmy_trnd_config.selectedEndDate;
				}
			},
			"thirdPage" : {
				"status" : false,
				"lastValue" : "test",
				"dataStore" :{},
				"dataViewerLength" : 6,
				"action" : function() {
					// top 그래프 값이 변경됐을 경우에만 함수 처리하기
					if(this.lastValue == ecnmy_trnd_config.selectedStartDate+":"+ecnmy_trnd_config.selectedEndDate){
						return;
					}

					var time = 0;
					if(this.lastValue == 'test'){
						time = 1000;
					}

					setTimeout(function(){
						visitrExpndtrText(ecnmy_trnd_config.sessionCtyCd,"",function(data){
							sectionFunc.thirdPage.dataStore.visitrExpndtrText = data;
						});
						visitrExpndtrMap("trend1_3",ecnmy_trnd_config.sessionCtyCd,"",function(name,data){
							sectionFunc.thirdPage.dataStore[name] = data;
						});
						visitrExpndtrGraph(ecnmy_trnd_config.sessionCtyCd,"",function(data){
							sectionFunc.thirdPage.dataStore.visitrExpndtrGraph = data;
						});

						visitrInflowText(ecnmy_trnd_config.sessionCtyCd,"",function(data){
							sectionFunc.thirdPage.dataStore.visitrInflowText = data;
						});
						visitrInflowMap("trend1_4",ecnmy_trnd_config.sessionCtyCd,"",function(name,data){
							sectionFunc.thirdPage.dataStore[name] = data;
						});
						visitrInflowGraph(ecnmy_trnd_config.sessionCtyCd,"",function(data){
							sectionFunc.thirdPage.dataStore.visitrInflowGraph = data;
						});
					},time);

			 	 	this.lastValue = ecnmy_trnd_config.selectedStartDate+":"+ecnmy_trnd_config.selectedEndDate;
				}
			}
	};

	var lastAnchorLink = "firstPage";
	$(document).ready(function(){
		//브라우저 체크
		var agent = navigator.userAgent.toLowerCase();
		
		// 경제트렌드  지도
		var mapUrl = "/onmap/ecnmy_trnd/getTrndMap.json";
		for(var i = 1 ; i < 5; i++){		
			mapArr["trend1_"+i].map = loadMap("trendMap1_"+i);
			if(i == 4){ 
// 				mapUrl = "/onmap/ecnmy_trnd/getTrndCtyMap.json";
// 				makeMap(mapUrl, ecnmy_trnd_config, 'trend1_'+i, "H2");
			}else{
				makeMap(mapUrl, ecnmy_trnd_config, 'trend1_'+i, "H4");	
			}
		}

		//현재보고있는 section가져오기
		window.anchorLinkCallBack = function(anchorLink, index){
			sectionFunc[anchorLink].action();
			lastAnchorLink = anchorLink ;

		};

		// 날짜별 그래프 슬라이더
		setTimeGraph();

		// 해당 section의 데이터를 가져오기
		sectionFunc[lastAnchorLink].action();

		
		// 안내메세지 숨기기
		$(".group_help").click(function(){
			$(".group_help").css("display","none");	
		});
		
		
		// 레이어팝업 모달 ( 지역간 비교 버튼 클릭시 팝업 open )
		$(".layer_open").on("click", function() {
			
			$('#fog2').css('display', 'block');
			return;
			
			// 해당 지역의 데이터를 저장한 후에 지역간 비교 팝업 열기
// 			console.log(sectionFunc[lastAnchorLink].dataStore);
// 			console.log(sectionFunc[lastAnchorLink].dataViewerLength);
			if(Object.keys(sectionFunc[lastAnchorLink].dataStore).length < sectionFunc[lastAnchorLink].dataViewerLength){
				alert("다시 시도해주세요.");
				return false;
			}
			//안내메시지 숨기기
			$(".group_help").css("display","none");
			
			// 시/도 선택 리스트 초기화
			$("#regionGroup1 ul li").each(function(index,item){
				var dataId = $(item).find('a').attr('data-id');
				$(item).find('a').removeClass("on");
				if(index == 0){
					$(item).find('a').addClass("on");
					// 군/구 리스트 가져오기
					getCtyList($(item).find('a').attr("data-id"));
				}
			});

			var sDate = ecnmy_trnd_config.selectedStartDate.substr(0,4)+". "+ecnmy_trnd_config.selectedStartDate.substr(4,2)+". "+ecnmy_trnd_config.selectedStartDate.substr(6);
			var eDate = ecnmy_trnd_config.selectedEndDate.substr(0,4)+". "+ecnmy_trnd_config.selectedEndDate.substr(4,2)+". "+ecnmy_trnd_config.selectedEndDate.substr(6);
			$(".txt_period").text(sDate+" ~ "+eDate);
			$(this).siblings(".pop_layer").fadeIn();
			$("body").css({"overflow" : "hidden"});
		});

		// 지역간 비교의 닫기 버튼 클릭시 팝업 닫기 (오른쪽 위의 x 버튼)
		$(".region_close").on("click", function(){

			// 지역선택 버튼 클릭 효과
			$("#compareSelectBtn").click();
			// 결과 내용 숨기기
			$(".compare_result").hide();
			
			// 팝업창 닫기
			$(this).parents(".pop_layer").fadeOut();
			// 트렌드 화면의 scroll 보이기
			$("body").css({"overflow" : "auto"});	
		});
		
		// 지역간 비교 안의 지역선택 popup의 취소 버튼 클릭시 (지역selectbox밑의 '취소'버튼)
		$(".btn_cancel.compare_close").on("click", function(){
			var resultElement = $(".compare_result")[0];
			
			// 비교결과가 없을 경우 popup 전체를 종료
// 			console.log(resultElement.style.display);
			if(resultElement.style.display && resultElement.style.display == 'none'){ 
				$(".region_close").click();
			}else{
				// 비교 결과가 잇을 경우 지역선택 popup만 종료
				$(".compare_body").hide();
				// 팝업창 닫기
// 				$(this).parents(".pop_layer").fadeOut();
				// 트렌드 화면의 scroll 보이기
// 				$("body").css({"overflow" : "auto"});
			}
		})
		

		// 지역간 비교내의 지역(광역시도)선택시
		$("#regionGroup1 ul li").on("click", function(){
			$(this).parents("ul").find("li a").removeClass("on");
			$(this).find("a").addClass("on");

			var megaCd = $(this).find("a").attr("data-id");
			
			// 선택된 시/도에 해당하는 군/구 리스트 가져오기
			getCtyList(megaCd);

		});

		// 지역간 비교내의 지역(시군구) 선택시
		$("#regionGroup2").on("click"," ul li", function(){
			$(this).parents("ul").find("li a").removeClass("on");
			$(this).find("a").addClass("on");
		});


		//지역간 비교 확인 버튼 - 비교 지역 선택 완료 버튼 클릭시 
		$("#select_confirm").on("click", function(){
			//시/도 선택 확인
			var groupCk = false;
			$.each($("#regionGroup2 a"), function(x, item) {
				if($(this).hasClass("on")) {
					groupCk = true;
					return false;
				}
			});

			if(!groupCk) {
				alert("군/구를 선택해 주세요.");
				return;
			}

 			$(this).parents(".compare_body").hide();

			$(".compare_result").load("/onmap/ecnmy_trnd/"+$("#regionGroup2 ul li a.on").attr("data-id")+"/compare.do?nm="+ encodeURIComponent($("#regionGroup2 ul li a.on").text()));
			$(".compare_result").show();
			$(".menu_compare").show();
			
	   		$('.compare_result').animate({
	            scrollTop: '0px'
	        }, 'slow');
			
			var comBdHgt = $(window).innerHeight() - $(".compare_header").innerHeight() -100;
			$(".layer_compare .compare_result").css({"height" : comBdHgt});
		});
		
		$(window).on("resize",function(){
			$(".layer_compare .compare_result").css({"height" : $(window).innerHeight() - $(".compare_header").innerHeight() -100});
		});

		// 지역간비교  - 다른 지역 비교할때 버튼 클릭 ('지역선택' 버튼 클릭)
		$("#compareSelectBtn").on("click", function(){
// 			$(".compare_result").hide();
			$(".compare_body").show();
			
			$(this).siblings(".pop_layer").fadeIn();
			$("body").css({"overflow" : "hidden"});
		});
		
		
		
		
		//레이어팝업 - 기간직접입력
		$(".btn_period").on("click", function(){
			var sdateText = $('.search_period').text().trim().split("~")[0];
			var edateText = $('.search_period').text().trim().split("~")[1];
			$("#selectStartDate").text(sdateText);
			$("#selectEndDate").text(edateText);
			$("#popSelectedSdate").text(sdateText);
			$("#popSelectedEdate").text(edateText);
			
			$("#standard_period").text(bDate.getFullYear() + "년 " + (bDate.getMonth()+1) + "월 ~ " + lDate.getFullYear() + "년 " + (lDate.getMonth()+1) + "월");
			
			
			var baseStartDate = new Date(ecnmy_trnd_config.limitStartDate.substr(0,4)+"."+ecnmy_trnd_config.limitStartDate.substr(4,2)+"."+ecnmy_trnd_config.limitStartDate.substr(6,2));
			var baseEndDate = new Date(ecnmy_trnd_config.limitEndDate.substr(0,4)+"."+ecnmy_trnd_config.limitEndDate.substr(4,2)+"."+ecnmy_trnd_config.limitEndDate.substr(6,2));

			if( (navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1) || (agent.indexOf("msie") != -1) ) {
				baseStartDate = new Date(ecnmy_trnd_config.limitStartDate.substr(0,4)+"-"+ecnmy_trnd_config.limitStartDate.substr(4,2)+"-"+ecnmy_trnd_config.limitStartDate.substr(6,2));
				baseEndDate = new Date(ecnmy_trnd_config.limitEndDate.substr(0,4)+"-"+ecnmy_trnd_config.limitEndDate.substr(4,2)+"-"+ecnmy_trnd_config.limitEndDate.substr(6,2));
			
				sdateText = sdateText.replace(/\. /gi,"-");
				edateText = edateText.replace(/\. /gi,"-");
			}
			
			
			
			$("#sDatepicker").datepicker({
				monthNames : [ "1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월" ] ,
				dayNamesMin: ["일","월","화","수","목","금","토"],
// 				beforeShowDay: sEnableAllTheseDays,
				showMonthAfterYear: true,
				minDate : baseStartDate,
				maxDate : baseEndDate,
				dateFormat : "yy. mm. dd" ,
				yearSuffix : "년",
				onSelect : function(dateText,inst) {
					$("#selectStartDate").text(dateText);
					$("#popSelectedSdate").text(dateText);
					
				}
			});
			$("#sDatepicker").datepicker( "setDate", new Date(sdateText));

			$("#eDatepicker").datepicker({
				monthNames : [ "1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월" ] ,
				dayNamesMin: ["일","월","화","수","목","금","토"],
// 				beforeShowDay: eEnableAllTheseDays,
				showMonthAfterYear: true,
				minDate : baseStartDate,
				maxDate : baseEndDate,
				dateFormat : "yy. mm. dd" ,
				yearSuffix : "년",
				onSelect : function(dateText,inst) {
					$("#selectEndDate").text(dateText);
					$("#popSelectedEdate").text(dateText);
				}
			});
			$( "#eDatepicker" ).datepicker( "setDate", new Date(edateText) );

			$(this).siblings(".layer_period").fadeIn();
		});
		
		$(".btn_close").on("click", function(){
			$(this).parents(".layer_period").fadeOut();
		});

	});
	
	/**
	* 지역간 비교에서 지역선택시 시/도 선택했을때 군/구 리스트 가져오기 
	**/
	function getCtyList(megaCd) {
		$.ajax({
			url : '/common/area_select_option.json',
			data:{
				"megaCd" : megaCd,
				"rgnClss" : 'H3'
			},
			success: function(result, status) {
				if(result.length > 0){
					var reGroup2 = "<ul>";
					for(var i = 0 ; i < result.length; i++){
						reGroup2 += "<li><a href='#' data-id='" + result[i].id + "' >"+result[i].nm+"</a></li>";
					}
					reGroup2 += "</ul>";
					$("#regionGroup2").html(reGroup2);
				}
			}
		});
	}
	
	/**
	 * 맨 위의 시간에 따른 소비인구 변화 그래프 
	 **/
	function setTimeGraph(){
// 		console.log("${userInfo.service_clss}");
		//그래프 네비게이션 시작
		$.ajax({
			url : '/onmap/ecnmy_trnd/graph_data.json',
			data:{
				"ctyCd" : ecnmy_trnd_config.sessionCtyCd,
				"periodMon" : 24,
				"min_date":ecnmy_trnd_config.limitStartDate,
				"max_date":ecnmy_trnd_config.limitEndDate,
				"serviceClss" : ecnmy_trnd_config.sessionTypeCd
			},
			success: function(result, status) {
				if(result.data){
					ecnmy_trnd_config.limitStartDate = result.data[0].stdr_date;
					ecnmy_trnd_config.limitEndDate = result.data[result.data.length-1].stdr_date;
				
					var margin = {top: 0, right: 10, bottom: 20, left: 60};
	
					for(var i = 0 ;i<result.data.length;i++){
						var item = result.data[i];
						item.date = yyyymmddToDate(item.stdr_date);
					}
					bDate = yyyymmddToDate (result.min_stdr_date);
					eDate = yyyymmddToDate (result.max_stdr_date);;
					lDate = yyyymmddToDate (result.max_stdr_date);;
	
					// 스크롤 관련 팝업 날짜 입력
					$("#dateWarn").text(bDate.getFullYear() + "년 " + (bDate.getMonth()+1) + "월 ~ " + eDate.getFullYear() + "년 " + (eDate.getMonth()+1) + "월");
					
					var tickes = 20;
					if($("#wrap").hasClass("device_tb")){
						tickes = 10;
					}
					
					// 테스트 기간
					var limitPeriod = ecnmy_trnd_config.maxPeriod;
					// 계약일때 기간 
// 					if(ecnmy_trnd_config.sessionTypeCd == '1') limitPeriod = 12;
					
					
					timeChart = timeLineChart("#rangeChart", result.data, "stdr_date", "sale_amt", margin,tickes, d3.time.format("%y/%m/%d") ,{'x0':yyyymmddToDate(ecnmy_trnd_config.selectedStartDate), 'x1':yyyymmddToDate(ecnmy_trnd_config.selectedEndDate)}, dateHandler,bDate,eDate,"소비금액(원)",{'month':limitPeriod});
					var start = ecnmy_trnd_config.selectedStartDate;
					var end = ecnmy_trnd_config.selectedEndDate;
					var sDate = start.substr(0,4)+". "+start.substr(4,2)+". "+start.substr(6);
					var eDate = end.substr(0,4)+". "+end.substr(4,2)+". "+end.substr(6);
					$(".search_period").text(sDate+" ~ "+eDate);
				}
			}
		});

	}
	
	
	/**
	 * 보고서 출력
	 **/
	$("body").on('click', ".btn_pdf", function(e) {
		loadingShow('fog');
		var fileNm = "/trnd_rpt/trnd_rpt_main";
		
		var chart_config = {
				ctyCd : ecnmy_trnd_config.sessionCtyCd,
				h3Cd : ecnmy_trnd_config.sessionCtyCd,
				userNo : ecnmy_trnd_config.sessionUserNo,
				dataId : "rpt-trnd",
				startDate : ecnmy_trnd_config.selectedStartDate,
				endDate : ecnmy_trnd_config.selectedEndDate
		};
		
		$.ajax({
			type : "GET",
			dataType : 'json',
			url : "/onmap/public/ecnmy_trnd/pdf/data_root.json",
			data : {
				"dataId" : chart_config.dataId,
				"ctyCd": chart_config.ctyCd,
				"h3Cd": chart_config.h3Cd,
				"userNo": chart_config.userNo,
				"startDate":chart_config.startDate,
				"endDate":chart_config.endDate
			},
			success : function(json) {
// 				console.log(JSON.stringify(json));
				loadingHide('fog');
				window.open("/report/viewer.do?file=/report.pdf?fileNm%3D"+fileNm+"%26dataId%3Drpt-trnd%26ctyCd%3D"+chart_config.ctyCd+"%26h3Cd%3D"+chart_config.ctyCd+"%26userNo%3D"+chart_config.userNo+"%26startDate%3D"+chart_config.startDate+"%26endDate%3D"+chart_config.endDate+"");
			},
			error : function(request,status,error){
				console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		});
		

	});	
	
	</script>
	<script src="/js/trendOn/ecnmy_trnd.js?ver=${globalConfig['config.version']}"></script>
</html>
