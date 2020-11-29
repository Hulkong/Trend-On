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
		<link rel="stylesheet" href="/css/daterangepicker.css?ver=${globalConfig['config.version']}" />
		<script type="text/javascript" src="/js/jquery/jquery-1.11.2.min.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery.easing.1.3.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-ui.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery.fullpage.js"></script>
		
<!-- 		<script type="text/javascript" src="/js/daterangepicker/moment.min.2.24.0.js"></script> -->
		<script type="text/javascript" src="/js/daterangepicker/moment.js"></script>
		<script type="text/javascript" src="/js/daterangepicker/daterangepicker.js"></script>
		
		<script type="text/javascript" src="/js/common.js?ver=${globalConfig['config.version']}"></script>
		<script type="text/javascript" src="/js/map.js?ver=${globalConfig['config.version']}"></script>

		<script type="text/javascript" src="/js/Leaflet-1.0.2/geostats.js"></script>
		<link rel="stylesheet" href="/js/Leaflet-1.0.2/leaflet.css" />
		<script type="text/javascript" src="/js/Leaflet-1.0.2/leaflet-src.js"></script>

		<script type="text/javascript" src="/js/d3Chart/d3.js"></script>
		<script type="text/javascript" src="/js/d3Chart/d3plus.js"></script>
		<script type="text/javascript" src="/js/d3Chart/d3Chart.js"></script>
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
						<li><a href="/onmap/ecnmy_trnd/main.do">경제 트렌드</a></li>
						<li class="on"><a href="/onmap/event_effect/main.do">이벤트 효과</a></li>
					</ul>
				</div>
			</div>
			<!-- //header -->

			<hr />

			<!-- contents -->
			<div id="contents">
				<div id="fp-nav2" class="section_top">
<!-- 					<h2 class="tit_top">이벤트 효과</h2> -->
					<ul class="menu_anchor">
						<li><a href="#firstPage">경제효과</a></li>
						<li><a href="#secondPage">유입인구 특성</a></li>
						<li><a href="#thirdPage">유입인구 소비</a></li>
					</ul>
					<div class="select_box select_ty2">
						<select id="areaOption" onchange="areaChnge(this.value)">
<%-- 							<c:if test="${!empty amdiList }"> --%>
<%-- 								<c:forEach var="aList" items="${amdiList }"> --%>
<%-- 									<option value="${aList.id }">${aList.nm }</option> --%>
<%-- 								</c:forEach> --%>
<%-- 							</c:if> --%>
						</select>
						<span class="tit sAmdiTit thisAmdi">${selectAmdiKr }</span>
					</div>
					<div class="article_rgt">
						<div class="group_period">
							<span class="search_period">2017. 06. 15 ~ 2017. 07. 26</span>
							<span class="btn_period"><a href="#layerPeriod">기간 직접 입력</a></span>
							<div id="layerPeriod" class="layer_period">
								<div class="pop_header">
									<p class="tit">기간 직접 입력</p>
									<p class="pop_period_txt">
										(데이터 기준일자 : <strong 	id="standard_period">2016년 10월 ~ 2017년 9월</strong>)<br/>
										(조회가능 범위 : 최대 3개월, 최소 3일)
									</p>
									<a href="##" class="btn_close">닫기</a>
								</div>
								<div class="pop_contents">
									<div class="article_calendar">
										<div class="group_lft">
											<p class="tit">비교기간 </p>
											<p class="txt" id="popSelectedLast">${lastStartDate } ~ ${lastEndDate }</p>
											<div id="sDatepicker"></div>

										</div>
										<div class="group_rgt">
											<p class="tit">선택기간</p>
											<p class="txt" id="popSelectedThis">2017.7.5 ~ 2017.7.15</p>
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
								<c:if test="${userInfo.service_clss eq '3'}">
								(조회가능 범위 : 최대 1개월, 최소 3일)
								</c:if>
								<c:if test="${userInfo.service_clss ne '3'}">
								(조회가능 범위 : 최대 3개월, 최소 3일)
								</c:if>
							</p>
						</div>
						<!-- //도움말 -->
					
						<div class="bx_graph dateRage" id="rangeEventChart">

						</div>
					</div>
					<!-- //상단 고정 그래프 -->
				</div>

				<!-- 본문 ==================================================================================================== -->
				<div id="fullpage">
					<div class="message_layer" id="dataLack">
						<div class="messageBox">
							<p>
								선택하신 기간과 지역은 표본의 크기가 작아서 서비스되지 않습니다.<br/>
								다른기간 혹은 다른 지역으로 이용해주세요.
							</p>
						</div>
					</div>
					<!-- section1 매출액 ============================== -->
					<div class="section" id="section1">
						<div class="inner">
							<h3 class="hide">경제효과</h3>
							<!-- 1set : 1piece ( graph ) -->
							<div class="article_group eResult1">
<!-- 								<div class="eResult1"></div> -->
								<div class="article_lf">
									<h4 class="tit"><span class="thisAmdi">${selectAmdiKr }</span> 총 경제효과</h4>
									<dl>
										<dt class="total">평상시 대비 매출액 변화 :</dt>
										<dd class="total"><strong id="amt_rate1_EE"></strong><span class="temp_font">증가</span></dd>
									</dl>
									<table class="brd_dl" id="amt_rate_list">
										<!-- regionAmtChngeText -->

									</table>

									<p class="txt_infor">
										경제효과는 평상시(이벤트 전1~3주, 후1~2주)일평균 매출액 대비<br/>
										이벤트 기간의 일평균 매출액을 비교<br/>
										평상시(이벤트 전 3주, 후 2주, 총 5주)데이터가 없을 경우<br/>
										그래프에 표현된 기간동안의 일평균 매출액 데이터를 계산
									</p>
								</div>
								<div class="article_rg">
									<div class="bx_graph" id="eventChart1">

									</div>
								</div>
							</div>
							<!-- // -->


							<!-- 1set : 2piece (map) -->
							<div class="article_group eResult1">
<!-- 								<div class="eResult1"></div> -->
								<div class="article_lf">
									<h4 class="tit">주변지역 총 경제효과</h4>
									<div class="cate_sml">
<!-- 										<h5 class="tit_dl_black">매출액 기준 : <span class="tit_dl" id="mxmAmt"></span></h5> -->
										<h5 class="tit_dl_black">매출액 기준</h5>
										<h3><span class="tit_dl sub_tit"><span class="thisAmdi">${selectAmdiKr}</span> <span id="sAdmiAmt"></span> %</span></h3>
										<table class="brd_dl" id="mxmAmt_list">
										
										
										</table>
									</div>
									<div class="cate_sml">
<!-- 										<h5 class="tit_dl_black">거래량 기준 : <span class="tit_dl" id="mxmRate"></span></h5> -->
										<h5 class="tit_dl_black">거래량 기준</h5>
										<h3><span class="tit_dl sub_tit"><span class="thisAmdi">${selectAmdiKr}</span> <span id="sAdmiRate"></span> %</span></h3>
										<table class="brd_dl" id="mxmRate_list">

										</table>
									</div>
									<p class="txt_infor">주변지역은 해당 시군구 내 분석지역(선택한 행정동)에 인접한 읍면동</p>
								</div>
								
								<div class="article_rg">
									<div class="bx_graph box_pos pos_ty2">
										<div class="select_box select_ty1 eventSelect">
											<select id="amtMapSelect" onchange="amtMapChnge('event1',this.value)">
												<option value="rate" selected>매출액</option>
												<option value="cnt_rate" >거래량</option>
											</select>
											<span class="tit"></span>
										</div>
										<div id="eventMap1">
											<img src="/images/common/icon_reload.png" alt="지도 초기화" title="전체보기" class="map_reLoad" onclick="mapReload('event1')"/>
											<div id="event1_legend" class="map legend"></div>
										</div>
									</div>
								</div>
							</div>
							<!-- // -->

							<!-- 2set : 1piece ( graph ) -->
							<div class="article_group eResult2">
<!-- 								<div class="eResult2"></div> -->
								<div class="article_lf">
									<h4 class="tit"><span class="thisAmdi">${selectAmdiKr }</span> 업종별 경제효과</h4>
									<dl>
										<dt class="total">매출액 기준 :</dt>
										<dd class="total"><strong id="upjongAmtTop"> </strong></td>
									</dl>
									<table class="brd_dl">
										<tr>
											<th id="upjongAmtTop_nm"> </th>
											<td id="upjongAmtTop_val"></td>
										</tr>
									</table>
									<dl>
										<dt class="total">거래량 기준 :</dt>
										<dd class="total"><strong id="upjongRateTop"> </strong></dd>
									</dl>
									<table class="brd_dl">
										<tr>
											<th id="upjongRateTop_nm"> </th>
											<td id="upjongRateTop_val"></td>
										</tr>
									</table>
									<p class="txt_infor">
										업종별 경제효과는 평상시 대비 이벤트기간의<br/>
										일평균 매출액, 일평균 거래량을 비교
									</p>
								
									
								</div>
								<div class="article_rg">
									<div class="bx_graph">
										<div class="graph_half">
											<h5 class="tit">매출액 기준</h5>
											<div id="eventChart2" class="box_pos"></div>
										</div>
										<div class="graph_half">
											<h5 class="tit">거래량 기준</h5>
											<div id="eventChart3" class="box_pos"></div>
										</div>
									</div>
								</div>
							</div>
							<!-- // -->
							
							<!-- 2set : 2piece ( map ) -->
							<div class="article_group pb100 eResult2">
<!-- 								<div class="eResult2"></div> -->
								<div class="article_lf">
									<h4 class="tit">주변지역 업종별 경제효과</h4>
									<div>
										<h5 class="tit_dl_black">
											매출액 기준 : 
											<span class="tit_dl sub_tit">
												<span class="thisAmdi">${selectAmdiKr}</span> 
												<span id="mxmAmtUpjong"></span>
												, <span id="mxmAmtUpjong_value"></span>
											</span>
										</h5>
										<table class="brd_dl" id="mxmUpjongAmt_list">
										
										</table>
									</div>
									<div>
										<h5 class="tit_dl_black">
											거래량 기준 : 
											<span class="tit_dl sub_tit">
												<span class="thisAmdi">${selectAmdiKr}</span> 
												<span id="mxmRateUpjong"></span>
												, <span id="mxmRateUpjong_value"></span>
											</span>
										</h5>
										<table class="brd_dl" id="mxmUpjongRate_list">
	
										</table>
									</div>
								</div>
								
								<div class="article_rg">
									<div class="bx_graph">
										<div class="graph_half">
											<h5 class="tit">매출액 기준</h5>
											<div class="box_pos pos_ty2">
												<div class="select_box select_ty1 eventSelect" >
													<select id="upAmtMapSelect" onchange="upAmtMapChnge(this.value)">
																<option value="" selected>업종을 선택해주세요.</option>
<%-- 														<c:if test="${!empty upjongList}"> --%>
<%-- 															<c:forEach var="item" items="${upjongList }"> --%>
<%-- 																<option value="${item.code }">${item.cd_nm }</option> --%>
<%-- 															</c:forEach> --%>
<%-- 														</c:if> --%>
													</select>
													<span class="tit" id="upAmtSelectText"></span>
												</div>
											
												<div id="eventMap2">
													<img src="/images/common/icon_reload.png" alt="지도 초기화" title="전체보기" class="map_reLoad" onclick="mapReload('event2')"/>
													<div id="event2_legend" class="map legend"></div>
												</div>
											</div>
										</div>
										<div class="graph_half">
											<h5 class="tit">거래량 기준</h5>
											<div class="box_pos pos_ty2">
												<div class="select_box select_ty1 eventSelect">
													<select id="upRateMapSelect" onchange="upRateMapChnge(this.value)">
																<option value="" selected>업종을 선택해주세요.</option>
<%-- 														<c:if test="${!empty upjongList}"> --%>
<%-- 															<c:forEach var="item" items="${upjongList }"> --%>
<%-- 																<option value="${item.code }">${item.cd_nm }</option> --%>
<%-- 															</c:forEach> --%>
<%-- 														</c:if> --%>
													</select>
													<span class="tit"  id="upRateSelectText"></span>
												</div>
												<div id="eventMap3" class="box_pos">
													<img src="/images/common/icon_reload.png" alt="지도 초기화" title="전체보기" class="map_reLoad" onclick="mapReload('event3')"/>
													<div id="event3_legend" class="map legend"></div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
							<!-- // -->

						</div>
					</div>
					<!-- //section1 매출액 ============================== -->

					<!-- section2 유입소비인구 특성 ============================== -->
					<div class="section eResult3" id="section2">
						<div class="inner">
							<h3 class="hide">유입인구 특성</h3>
							<!--  -->
							<div class="article_group eResult3">
<!-- 								<div class="eResult3"></div> -->
								<div class="article_lf">
									<h4 class="tit">지역별 유입인구 수</h4>
									<dl>
										<dt class="total"><span class="thisAmdi">${selectAmdiKr }</span> 유입인구 수 :</dt>
										<dd class="total"><strong id="visitrTotal"> </strong>명</dd>
									</dl>
									<table class="brd_dl" id="visitrCnt">
										<!-- eventVisitrText -->
									</table>
									<p class="txt_infor">
										"유입인구"는 분석지역(선택한 행정동 기준 반경2km)이외 지역에<br/>
										거주지 주소를 두고 조회기간 동안 해당지역에서 <br/>소비행위를 한 인구
									</p>
								</div>
								<div class="article_rg">
									<div class="bx_graph" id="eventMap4">
										<img src="/images/common/icon_reload.png" alt="지도 초기화" title="전체보기" class="map_reLoad" onclick="mapReload('event4')"/>
										<div id="event4_legend" class="map legend"></div>

									</div>
								</div>
							</div>
							<!-- // -->

							<!--  -->
							<div class="article_group eResult3">
<!-- 								<div class="eResult3"></div> -->
								<div class="article_lf">
									<h4 class="tit">성/연령별 대표 유입인구 </h4>
									<dl>
										<dt class="total"><span class="thisAmdi">${selectAmdiKr }</span> 유입인구 :</dt>
										<dd class="total"><strong id="visitrChar"> </strong></dd>
									</dl>
									<p class="txt_sub_dl"><span class="thisAmdi">${selectAmdiKr }</span> 상권을 가장 많이 이용한 ${ctyName} 유입소비인구</p>
									<dl>
										<dt class="total"><span class="thisAmdi">${selectAmdiKr }</span> 상주인구 :</dt>
										<dd class="total"><strong id="ctznChar"> </strong></dd>
									</dl>
									<p class="txt_sub_dl"><span class="thisAmdi">${selectAmdiKr }</span> 상권을 가장 많이 이용한 ${ctyName} 상주인구</p>

									<p class="txt_infor">
										"상주인구"는 분석지역(선택한 행정동 기준 반경2km)에<br/> 
										자택 혹은 직장 주소를 두고 조회기간 동안 해당지역에서<br/> 
										소비행위를 한 인구
									</p>
								</div>
								<div class="article_rg">
									<div class="bx_graph" id="eventChart4">

									</div>
								</div>
							</div>
							<!-- // -->
						</div>
					</div>
					<!-- //section2 유입소비인구 특성 ============================== -->

					<!-- section3 유입소비인구 지출 ============================== -->
					<div class="section eResult3" id="section3">
						<div class="inner">
							<h3 class="hide">유입인구 소비</h3>
							<!-- 지역별 유입소비인구 소비 순위 -->
							<!--  -->
							<div class="article_group eResult3">
<!-- 								<div class="eResult3"></div> -->
								<div class="article_lf">
									<h4 class="tit">유입인구 소비시간</h4>
									<dl>
										<dt class="total">주요 소비시간 :</dt>
										<dd class="total"><strong id="cnsmpTimeTop"> </strong></dd>
									</dl>
									<table class="brd_dl" id="cnsmpTimeList">
										<!-- eventCnsmpTimeText -->
									</table>
									<p class="txt_infor">시간대 표현은 01시 ~ 24시</p>
								</div>
								<div class="article_rg">
									<div class="bx_graph" id="eventChart6">

									</div>
								</div>
							</div>
							<!-- // -->

							<!--  -->
							<div class="article_group eResult3">
<!-- 								<div class="eResult3"></div> -->
								<div class="article_lf">
									<h4 class="tit">유입인구 유입지역</h4>
									<dl>
										<dt class="total">주요 유입지역 :</dt>
										<dd class="total"><strong id="visitrInflowTop"> </strong></dd>
									</dl>
									<table class="brd_dl" id="visitrInflowList">
										<!-- eventCnsmpTimeText -->
									</table>
									<p class="txt_infor">유입지역은 전국 226개 시군구 대상</p>
								</div>
								<div class="article_rg">
									<div class="bx_graph" id="eventMap6">
										<img src="/images/common/icon_reload.png" alt="지도 초기화" title="전체보기" class="map_reLoad" onclick="mapReload('event6')"/>
										<div id="event6_legend" class="map legend"></div>

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

	<script>
	var event_config = { layerFid : {}								// 레이어 아이디 모음
					   , sessionCtyCd:'${userInfo.cty_cd}'			// 사용자 정보에서 가져오는 지역코드(시군구)
					   , selectAmdiCd:'${selectAmdi}'				// 선택한 행정동
					   , sessionUserNo:'${userInfo.user_no}'		// 사용자 고유no
					   , sessionTypeCd: '${userInfo.service_clss}'	// 사용자 타입 ( 테스트, 계약 )
					   , selectedStartDate:'${startDate}'			// 선택한 기간의 시작일
					   , selectedEndDate:'${endDate}'				// 선택한 기간의 종료일
					   , selectedLastStartDate:'${lastStartDate}'	// 선택한 기간의 전년도 시작일
					   , selectedLastEndDate:'${lastEndDate}'		// 선택한 기간의 전년도 종료일
					   , admiAround : "${admiAround}"				// 선택한 행정동 주변 행정동
					   , admiFlg : "${flg}"							// 동/읍(1), 면(0) 구분
					   , selectedRgnClss:'H4'						// 지역단위
// 					   , limitStartDate:'20150501'
					   , limitStartDate:'20180101'					// 테스트일 경우 사용하는 시계열 그래프의 시작일
					   , limitEndDate:'20181231'					// 테스트일 경우 사용하는 시계열 그래프의 종료일
					   , chk:0										// 달력 생성 여부 (0일경우 달력 없음)
					   , periodMon : 24								// 시계열 그래프의 총 기간
					   , pageError : false							// 에러페이지 on/off (기준 3가지 모두 미달일 경우 true)
					   , validateChk : {							// 기준 체크
						   status : false,
						   result1 : false, 						// 이벤트 기간동의 총액이 10만원보다 작을 경우
						   result2 : false, 						// 업종이 3개보다 작을 경우
						   result3 : false							// 방문객 수가 100명 이하
					   }
	};

	var colorArr = [ '#2c7bb6', '#abdda4', '#ffffbf','#fdae61', '#d7191c'];

	var timeChart = null;
	var bDate ;
	var lDate ;
	var eDate ;
	
	// mapArr 안의 값 설명
	// bounds 			:  mbr로 사용할 최소반경 테두리 
	// map      		:  지도 저장
	// data  			:  지도에 올라가는 데이터 저장
	// layer 			:  지도위에 올라가는 polygon을 각각 layer로 저장( fid로 검색 가능 )
	// init  			:  지도 초기화할때 사용
	// zoom  			:  전국지도일때만 다른 zoom level을 주기위해 사용
	// popup - column   :  실제 내용에 사용되는 내용 [ nm 내용의 제목 || value 컬럼명 || areaYn 제목에 지역명을 넣을지 (Y 넣는다, N 안넣는다)]
	// popup - tit      :  value 팝업의 제목(실제사용) ||  title 팝업 제목의 일부(추가로 붙여서 사용) || areaYn 제목에 지역명을 넣을지 ( Y 넣는다,  N 안넣는다 )
	// popup - unit		:  단위 
	var mapArr = {
			event1 : { bounds:null , map:null, data:null, layer:null, init:null, 
					   popup:{column:[{"nm":"매출액 기준","value":"rate", "areaYn":"N"},{"nm":"거래량 기준","value":"cnt_rate", "areaYn":"N"}],tit:{"value":"경제효과","tit":"경제효과","color":"#333", "areaYn":"Y"},unit:["%","%"]}},
			event2 : { bounds:null , map:null, data:null, layer:null, init:null, 
					   popup:{column:[{"nm":"매출액 변화","value":"rate", "areaYn":"N"}],tit:{"value":"업종별 매출액 변화","tit":"업종별 매출액 변화","color":"#333", "areaYn":"Y"},unit:"%"}},
			event3 : { bounds:null , map:null, data:null, layer:null, init:null, 
					   popup:{column:[{"nm":"거래량 변화","value":"cnt_rate", "areaYn":"N"}],tit:{"value":"업종별 거래량 변화","tit":"업종별 거래량 변화","color":"#333", "areaYn":"Y"},unit:"%"}},
			event4 : { bounds:null , map:null, data:null, layer:null, init:null, 
					   popup:{column:"in_cnt_kr",tit:{"value":"지역별 유입인구 수","color":"#333"},unit:"명"}},
			event6 : { bounds:null , map:null, data:null, layer:null, init:null, zoom:7,
				       popup:{column:"rate_kr",tit:{"value":"유입인구 유입지역","color":"#333"},unit:"%"}}
	}
	
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
	}
	
	// section별 데이터 load
	var sectionFunc = {
			"firstPage" : {
				"status" : false,
				"lastValue" : "test",
				"lastArea" : "test",
				"action" : function() {
					if(this.lastValue == event_config.selectedStartDate+":"+event_config.selectedEndDate+":"+event_config.selectedLastStartDate+":"+event_config.selectedLastEndDate && this.lastArea == event_config.selectAmdiCd){
						return;
					}
					$("#dataLack").hide();
					$("body").css({"overflow" : "auto"});
					// 이벤트1
					validateChk(function(){
						if(event_config.validateChk.result1){
							$(".eResult1").show();
							regionAmtChngeText();
							regionAmtChngeGraph(); //이벤트1 : 그래프(전년&올해)
		
							regionAmtChngeMap("event1",$("#amtMapSelect").val());	// 이벤트2 : map
						}else{
							$(".eResult1").hide();
						}
						
						if(event_config.validateChk.result2){
							$(".eResult2").show();
							upjongAmtChngeGraph2(); // 이벤트1 : 금액기준 그래프
							upjongRateChngeGraph2(); // 이벤트1 : 비율기준 그래프
							
							upjongAmtChngeText2(); // 이벤트2 : text & map 
						} else {
// 							$(".eResult2").hide();
							$(".eResult2").css("display","none");
						}
					});	

					this.lastValue = event_config.selectedStartDate+":"+event_config.selectedEndDate+":"+event_config.selectedLastStartDate+":"+event_config.selectedLastEndDate;
					this.lastArea = event_config.selectAmdiCd;
				}
			},
			"secondPage" : {
				"status" : false,
				"lastValue" : "test",
				"lastArea" : "test",
				"action" : function() {
					if(this.lastValue == event_config.selectedStartDate+":"+event_config.selectedEndDate && this.lastArea == event_config.selectAmdiCd){
						return;
					}
					$("#dataLack").hide();
					$("body").css({"overflow" : "auto"});
					// check date(데이터 크기 체크)
					validateChk(function(){
						if(event_config.validateChk.result3) {
							$(".eResult3").show();
							regionAmtChngeText(); //이벤트1 : text
							
							// 이벤트4
					 		eventVisitrMap();
					 	 	eventVisitrText();
					 	 	visitrCtznGraph();
						} else {
							$(".eResult3").hide();
						}
					});

				 	 	
					this.lastValue = event_config.selectedStartDate+":"+event_config.selectedEndDate;
					this.lastArea = event_config.selectAmdiCd;
				}
			},
			"thirdPage" : {
				"status" : false,
				"lastValue" : "test",
				"lastArea" : "test",
				"action" : function() {

					if(this.lastValue == event_config.selectedStartDate+":"+event_config.selectedEndDate && this.lastArea == event_config.selectAmdiCd){
						return;
					}
					$("#dataLack").hide();
					$("body").css({"overflow" : "auto"});
					// check date(데이터 크기 체크)
					validateChk(function(){
						if(event_config.validateChk.result3) {
							$(".eResult3").show();
							regionAmtChngeText(); //이벤트1 : text
							
					 		// 이벤트6
					 	 	eventCnsmpTimeText();
					 	 	eventCnsmpTimeGraph();
					 	 	eventCnsmpTimeMap();
					 	 } else {
					 		$(".eResult3").hide();
					 	 }
					});

					

			 	 	this.lastValue = event_config.selectedStartDate+":"+event_config.selectedEndDate;
			 	 	this.lastArea = event_config.selectAmdiCd;
				}
			}
	};

	var lastAnchorLink = "firstPage";
	$(document).ready(function(){
		//브라우저 체크
		var agent = navigator.userAgent.toLowerCase();
		
		// 현재 section 찾기
		window.anchorLinkCallBack = function(anchorLink, index){
			sectionFunc[anchorLink].action();
			lastAnchorLink = anchorLink ;

		};
		
		// 지도위 selectBox option 변경
		$.ajax({
			type: "GET",
			dataType: 'json',
			url:"/common/area_select_option.json",
			data:{
				"ctyCd" : event_config.sessionCtyCd.substr(0,4),
				"rgnClss" : event_config.selectedRgnClss
			},
			success: function(json) {
// 				$("#areaOption").empty();
				
				// 한글 오름차순
				json.sort(function(a, b) { 
					return a.nm < b.nm ? -1 : a.nm > b.nm ? 1 : 0;
				});

				for(var i = 0 ; i< json.length; i++){
					var optionHtml = "<option value='"+json[i].id+"'>"+json[i].nm+"</option>";
					$("#areaOption").append(optionHtml);
				}
				
				$(".thisAmdi").text(json[0]['nm']);
				event_config.selectAmdiCd = json[0]['id'];
				areaChnge();
			}
		})
		
		// 최상단 시계열 그래프 & 지도 그리기
		
// 		setDataGraph();
// 		sectionFunc[lastAnchorLink].action();


		// 안내메세지 숨기기
		$(".group_help").click(function(){
			$(".group_help").css("display","none");	
		});

		//레이어팝업 - 기간직접입력
		$(".btn_period").on("click", function(){
			
			// 기간직접입력 popup이 시계열 그래프가 그려진 후에만 열리게 한다.
			if($('#rangeEventChart').html().trim() == null || $('#rangeEventChart').html().trim() == ''){
				alert("다시 시도해주세요.");
				return;
			}
			
			// 기간직접입력 popup에 현재 선택된 날짜 나오게 하기
			$("#popSelectedThis").text($('.search_period').text());

			var lastStart = event_config.selectedLastStartDate;
			var lastEnd = event_config.selectedLastEndDate;
			
			// 기간직접입력 popup에 현재 선택된 날짜의 일년전 날짜가 나오게 하기 
			$("#popSelectedLast").text(lastStart.substr(0,4) + ". " + lastStart.substr(4,2) + ". " + lastStart.substr(6,2) + " ~ " + lastEnd.substr(0,4) + ". " + lastEnd.substr(4,2) + ". " + lastEnd.substr(6,2));

			// 팝업 open
			$(this).siblings(".layer_period").fadeIn();
			
			// 데이터 기준일자 
			$("#standard_period").text(bDate.getFullYear() + "년 " + (bDate.getMonth()+1) + "월 ~ " + lDate.getFullYear() + "년 " + (lDate.getMonth()+1) + "월");

			// 처음 버튼 클릭시 달력 생성
			if(event_config.chk == 0){			
				makeCalendar();
			}else{
				// 전년도
// 				$("#sDCatepicker").data('dateRangePicker').setMaxDate(moment($('.search_period').text().trim().split("~")[0],"YYYY-MM-DD").substract(1,"days"));
				$("#sDatepicker").data('dateRangePicker').setStart(lastStart.substr(0,4) + "-" + lastStart.substr(4,2) + "-" + lastStart.substr(6,2));
				$("#sDatepicker").data('dateRangePicker').setEnd(lastEnd.substr(0,4) + "-" + lastEnd.substr(4,2) + "-" + lastEnd.substr(6,2));
// 				$("#sDatepicker").data('dateRangePicker').setStart(lastStart.substr(0,4) + ". " + lastStart.substr(4,2) + ". " + lastStart.substr(6,2));
// 				$("#sDatepicker").data('dateRangePicker').setEnd(lastEnd.substr(0,4) + ". " + lastEnd.substr(4,2) + ". " + lastEnd.substr(6,2));
				
				// 선택 기간
				$("#eDatepicker").data('dateRangePicker').setStart($('.search_period').text().trim().split("~")[0]);
				$("#eDatepicker").data('dateRangePicker').setEnd($('.search_period').text().trim().split("~")[1]);
			}
			
			
		});
		
		// 기간직접입력 popup 닫기
		$(".btn_close").on("click", function(){
			$(this).parents(".layer_period").fadeOut();
		});

		

	});

	//레이어 생성 및 주제도 표현
	function drawMap(admiCd, callback){
		var mapUrl = "/onmap/event_effect/getEventMap.json";
		for(var i = 1 ; i < 7; i++){
			if(i != 5){ 
				// 처음 로딩할때
				if(admiCd === undefined){ 
					// map 생성
					mapArr["event"+i].map = loadMap("eventMap"+i);
				
					// [이벤트 6] 유입인구 유입지역의 레이어 생성
					if(i == 6){ 
// 						mapUrl = "/onmap/event_effect/getEventCtyMap.json";
// 						makeMap(mapUrl, event_config, 'event'+i, "H2", callback);
						if(callback) callback();
					}
				}else{ // 지역변경 시
					// [이벤트 1~4] 지도위 레이어 삭제
					if(i != 6) {
						removeLayer('event'+i);
					} else {
// 						layersInitStyle(mapArr["event"+i].map, 'event'+i);
					}
				}
				
				// [이벤트 1~4] 지도 레이어 생성
				if(i != 6){ 
					makeMap(mapUrl, event_config, 'event'+i, "H4");
				}
			}
		}
		if(admiCd !== undefined){ 
			callback();
		}
	}
	
	/**
	* 행정동 선택에 따른 페이지 내용 변경
	* @param admiCd 선택된 행정동 코드  (코드가 있으면 지역을 선택했을때, 코드가 없으면 페이지에 들어온 순간)
	**/
	function areaChnge(admiCd){
		
		if(admiCd){  // 지역을 선택했을 때
			event_config.selectAmdiCd = admiCd;
			setFlg(admiCd);		// 동/읍 , 면 구분값 가져오기
			$(".thisAmdi").text($("#areaOption option:selected").text());
			//안내 메시지 숨기기
			$(".group_help").css("display","none");
		}
		
		// 업종 selectbox option 변경
		getUpjongOption();
		
		// validate 초기화
		event_config.validateChk.status = false;
		
		getAdmiList(function(){
			//top그래프 변경
	 		$("#rangeEventChart").empty();
	 		setDataGraph(admiCd);
	 		
	 		//주제도 표현
			drawMap(admiCd, function(){
// 				//현재 보고있는 section의 내용 변경
				sectionFunc[lastAnchorLink].action();
			});
	 		
		});
		

	}
	
	/**
	 * 동/읍 , 면 구분값 가져오기
	 * @param admiCd 선택된 행정동 코드
	 **/
	function setFlg(admiCd){
		$.ajax({
			url : '/onmap/event_effect/getAdmiFlg.json',
			data : {
				'admiCd' : admiCd
			},
			success: function(result, status) {
				event_config.admiFlg = result;
			}
		});
	}
	
	/**
	 * 맨 위의 시간에 따른 소비인구 변화 그래프 
	 * @param admiCd 선택된 행정동 코드
	 **/
	function setDataGraph(admiCd){
		if(admiCd) loadingShow2('rangeEventChart');
		//그래프 네비게이션 시작
		$.ajax({
			url : '/onmap/event_effect/graph_data.json',
			data:{
				"ctyCd"  : event_config.sessionCtyCd,
				"admiCd"  : event_config.selectAmdiCd,
				"periodMon" : event_config.periodMon,
				"min_date":event_config.limitStartDate,
				"max_date":event_config.limitEndDate,
				"serviceClss" : event_config.sessionTypeCd
			},
			success: function(result, status) {
				
				event_config.limitStartDate = result.data[0].stdr_date;
				event_config.limitEndDate = result.data[result.data.length-1].stdr_date;
				
				var margin = {top: 0, right: 10, bottom: 20, left: 60};

				for(var i = 0 ;i<result.data.length;i++){
					var item = result.data[i];
					item.date = yyyymmddToDate(item.stdr_date);
				}
				bDate = yyyymmddToDate (result.min_stdr_date);
				eDate = yyyymmddToDate (result.max_stdr_date);
				lDate = yyyymmddToDate (result.max_stdr_date);
				
				// 스크롤 관련 팝업 날짜 입력
				$("#dateWarn").text(bDate.getFullYear() + "년 " + (bDate.getMonth()+1) + "월 ~ " + eDate.getFullYear() + "년 " + (eDate.getMonth()+1) + "월");

				var tickes = 20;

				if($("#wrap").hasClass("device_tb")){
					tickes = 10;
				}

				// 테스트 기간
				var limitPeriod = 1;
				// 계약일때 기간 
				if(event_config.sessionTypeCd == '1') limitPeriod = 3;
				
				timeChart = timeLineChart("#rangeEventChart", result.data, "stdr_date", "sale_amt", margin,tickes, d3.time.format("%y/%m/%d") ,{'x0':yyyymmddToDate(event_config.selectedStartDate), 'x1':yyyymmddToDate(event_config.selectedEndDate)}, timeHandler,bDate,eDate,"소비금액(원)",{'month':limitPeriod});
				var start = event_config.selectedStartDate;
				var end = event_config.selectedEndDate;
				var sDate = start.substr(0,4)+". "+start.substr(4,2)+". "+start.substr(6);
				var eDate = end.substr(0,4)+". "+end.substr(4,2)+". "+end.substr(6);
				$(".search_period").text(sDate+" ~ "+eDate);
				if(admiCd) loadingHide('rangeEventChart');
			}
		});

	}

	//보고서 출력
	$("body").on('click', ".btn_pdf", function(e) {
		if(event_config.pageError || !event_config.validateChk.result1){
			alert("기간 혹은 지역을 변경 후 다시 선택해주세요.");
			return false;
		}
		
		loadingShow('fog');
		var fileNm = "/evntEff_dong/evntEff_rpt/evntEff_rpt001";
		
		if(event_config.admiFlg == '0'){			// "면" 이면
			fileNm = "/evntEff_small/evntEff_rpt/evntEff_rpt001";
			if(!event_config.validateChk.result2) fileNm = "/evntEff_small/evntEff_rpt_excl02/evntEff_rpt001";
			if(!event_config.validateChk.result3) fileNm = "/evntEff_small/evntEff_rpt_excl03/evntEff_rpt001";
			if(!event_config.validateChk.result3 && !event_config.validateChk.result2) fileNm = "/evntEff_small/evntEff_rpt_excl0203/evntEff_rpt001";
		} else {									// "동/읍" 이면
			if(!event_config.validateChk.result2) fileNm = "/evntEff_dong/evntEff_rpt_excl02/evntEff_rpt001";
			if(!event_config.validateChk.result3) fileNm = "/evntEff_dong/evntEff_rpt_excl03/evntEff_rpt001";
			if(!event_config.validateChk.result3 && !event_config.validateChk.result2) fileNm = "/evntEff_dong/evntEff_rpt_excl0203/evntEff_rpt001";
		}
	
		var chart_config = {
				ctyCd : event_config.sessionCtyCd,
				h3Cd : event_config.sessionCtyCd,
				admiCd : event_config.selectAmdiCd,
				userNo : event_config.sessionUserNo,
				dataId : "rpt-evntEff",
				admiAround : event_config.admiAround,
				lastStartDate : event_config.selectedLastStartDate,
				lastEndDate : event_config.selectedLastEndDate,
				startDate : event_config.selectedStartDate,
				endDate : event_config.selectedEndDate
				
		};

		$.ajax({
			type : "GET",
			dataType : 'json',
			url : "/onmap/public/ecnmy_trnd/pdf/data_root.json",
			data : {
				"dataId" : chart_config.dataId,
				"ctyCd": chart_config.ctyCd,
				"h3Cd": chart_config.h3Cd,
				"admiCd": chart_config.admiCd,
				"userNo": chart_config.userNo,
				"lastStartDate":chart_config.lastStartDate,
				"lastEndDate":chart_config.lastEndDate,
				"startDate":chart_config.startDate,
				"admiAround" : chart_config.admiAround,
				"endDate":chart_config.endDate
			},
			success : function(json) {
				loadingHide('fog');
				window.open("/report/viewer.do?file=/report.pdf?fileNm%3D"+fileNm+"%26dataId%3Drpt-evntEff%26ctyCd%3D"+chart_config.ctyCd+"%26h3Cd%3D"+chart_config.ctyCd+"%26userNo%3D"+chart_config.userNo+"%26startDate%3D"+chart_config.startDate+"%26endDate%3D"+chart_config.endDate+"%26lastStartDate%3D"+chart_config.lastStartDate+"%26lastEndDate%3D"+chart_config.lastEndDate+"%26admiAround%3D"+chart_config.admiAround+"%26admiCd%3D"+chart_config.admiCd+"");
			},
			error : function(request,status,error){
				console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		});
		

	});	

	</script>
	<script src="/js/trendOn/event_effect.js?ver=${globalConfig['config.version']}"></script>
</html>