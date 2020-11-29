<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<!doctype html>
<html lang="ko">
	<head>
		<title>지역경제 모니터링</title>
		<meta charset="utf-8" />
		<link rel="stylesheet" href="/css/import.css?ver=${globalConfig['config.version']}" />
		<link rel="stylesheet" href="/css/reset.css?ver=${globalConfig['config.version']}"  />
		<link rel="stylesheet" href="/css/common.css?ver=${globalConfig['config.version']}"  />
		<link rel="stylesheet" href="/css/style.css?ver=${globalConfig['config.version']}"  />
		<link rel="stylesheet" href="/css/dev.css?ver=${globalConfig['config.version']}"  />
		<script src="/js/jquery/jquery-1.11.2.min.js"></script>
		<script src="/js/jquery/jquery.easing.1.3.js"></script>
		<script src="/js/jquery/jquery-ui.js"></script>
		<script src="/js/jquery/jquery.fullpage.min.js"></script>
		<script src="/js/common.js?ver=${globalConfig['config.version']}"></script>
		<script src="/js/map.js?ver=${globalConfig['config.version']}"></script>
		
		<link rel="stylesheet" href="/css/dev.css?ver=${globalConfig['config.version']}" />
		
		<script src="/js/Leaflet-1.0.2/geostats.js"></script>
		<link rel="stylesheet" href="/js/Leaflet-1.0.2/leaflet.css" />
		<script type="text/javascript" src="/js/Leaflet-1.0.2/leaflet-src.js"></script>
		
		<script src="/js/d3Chart/d3.js"></script>
		<script src="/js/d3Chart/d3plus.js"></script>
		<script src="/js/d3Chart/d3Chart.js"></script>
	</head>
	<body>
		<div id="wrap">
			<!-- header -->
			<div id="header">
				<h1 class="logo"><a href="/"><img src="/images/common/logo.png" alt="logo" /></a></h1>
				<div class="gnb">
					<span class="user"><em><c:out value="${userId}"/></em>님 안녕하세요</span>
					<span class="btn"><a href="/onmap/login/logout.do">로그아웃</a></span>
				</div>
				<div id="nav">
					<ul>
						<li><a href="/onmap/ecnmy_24/main.do">안산 24시</a></li>
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
					<h2 class="tit_top">이벤트 효과</h2>
					<ul class="menu_anchor">
						<li><a href="#firstPage">매출액</a></li>
						<li><a href="#secondPage">방문객 특성</a></li>
						<li><a href="#thirdPage">방문객 지출</a></li>
					</ul>
					<div class="article_rgt">
						<div class="group_period">
							<span class="search_period">2017. 06. 15 ~ 2017. 07. 26</span>
<!-- 							<span class="btn_period"><a href="#layerPeriod">기간 직접 입력</a></span> -->
								<span class="btn_period"><a href="#none">기간 직접 입력</a></span>
							<div id="layerPeriod" class="layer_period">
								<div class="pop_header">
									<label><input type="checkbox" />비교대상</label>
									<div class="select_box select_ty1">
										<select>
											<option selected="selected">이전기간</option>
											<option>선택2</option>
										</select>
										<span class="tit"></span>
									</div>
									<a href="##" class="btn_close">닫기</a>
								</div>
								<div class="pop_contents">
									<div class="article_calendar">
										<div >시작일 : <span id="selectStartDate"></span>  종료일 : <span id="selectEndDate"></span></div>
										<div class="group_lft" id="sDatepicker">
											
										</div>
										<div class="group_rgt" id="eDatepicker">
											
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
								<li class="btn_print"><a href="#">인쇄</a></li>
							</ul>
						</div>
					</div>
					<!-- 상단 고정 그래프 -->
					<div class="top_graph">
						<div class="bx_graph" id="rangeEventChart">
						
						</div>
					</div>
					<!-- //상단 고정 그래프 -->
				</div>

				
				
				<!-- 본문 ==================================================================================================== -->
				<div id="fullpage">
					<div class="bg_area">
					<!-- section1 -->
					<div class="section" id="section1">
						<div class="inner">
							<h3 class="hide">매출액</h3>
							<!--  -->
							<div class="article_group">
								<div class="article_lf">
									<h4 class="tit">매출변화</h2>
									<dl>
										<dt class="total">이벤트 기간중 총 매출 :</dt>
										<dd class="total"><strong  id="amt_rate1_EE"></strong>%증가</dd>

										<dt>전년도 이벤트 기간중 총매출 :</dt>
										<dd><strong id="amt_rate2_EE"></strong>% 증가</dd>
									</dl>
								</div>
								<div class="article_rg">
									<div class="bx_graph" id="eventChart1">

									</div>
								</div>
							</div>
							<!-- // -->

							<!--  -->
							<div class="article_group">
								<div class="article_lf">
									<h4 class="tit">지역별 매출 변화</h2>
									<h5 class="tit_dl">최다증가</h5>
									<dl id="mxmAmt">
									
									</dl>
									<h5 class="tit_dl">최소증가</h5>
									<dl id="mummAmt">
									
									</dl>
									
								</div>
								<div class="article_rg">
									<div class="bx_graph"  id="eventMap1">
										<div id="event1_legend" class="map legend"></div>
										<select id="amtMapSelect" class="eventSelect" onchange="amtMapChnge(this.value)">
											<option value="amt" selected>금액</option>
											<option value="rate" >비율</option>
										</select>
										
									</div>
								</div>
							</div>
							<!-- // -->
							
														<!--  -->
							<div class="article_group">
								<div class="article_lf">
									<h4 class="tit">업종별 거래금액 변화</h2>
									<dl id="upjongAmtList">
										
									</dl>
								</div>
								<div class="article_rg">
									<div class="bx_graph" id="eventChart2">
									
									</div>
								</div>
							</div>
							<!-- // -->
							
														<!--  -->
							<div class="article_group">
								<div class="article_lf">
									<h4 class="tit">지역별 업종별 변화</h2>
									<div class="cate_sml">
										<h5 class="tit_dl" id="upjongAmt1"> </h5>
										<dl id="upAmtList1">
										
										</dl>
									</div>
									<div class="cate_sml">
										<h5 class="tit_dl" id="upjongAmt2"> </h5>
										<dl id="upAmtList2">
										
										</dl>
									</div>
									<div class="cate_sml">
										<h5 class="tit_dl" id="upjongAmt3"> </h5>
										<dl id="upAmtList3">
										
										</dl>
									</div>
								</div>
								<div class="article_rg">
									<div class="bx_graph"  id="eventMap2">
										<div id="event2_legend" class="map legend"></div>
										<select id="upAmtMapSelect" class="eventSelect" onchange="upAmtMapChnge(this.value)">
													<option value="" selected>업종을 선택해주세요.</option>
											<c:if test="${!empty upjongList}">
												<c:forEach var="item" items="${upjongList }">
													<option value="${item.code }">${item.cd_nm }</option>
												</c:forEach>
											</c:if>
										</select>
										
									</div>
								</div>
							</div>
							<!-- // -->
							
														<!--  -->
							<div class="article_group">
								<div class="article_lf">
									<h4 class="tit">업종별 거래금액 변화율</h2>
									<dl id="upjongRateList">
									
									</dl>
								</div>
								<div class="article_rg">
									<div class="bx_graph"  id="eventChart3">
									
									</div>
								</div>
							</div>
							<!-- // -->
							
														<!--  -->
							<div class="article_group">
								<div class="article_lf">
									<h4 class="tit">지역별 업종별 변화율</h2>
									<div class="cate_sml">
										<h5 class="tit_dl" id="upjongRate1"> </h5>
										<dl id="upRateList1">
										
										</dl>
									</div>
									<div class="cate_sml">
										<h5 class="tit_dl" id="upjongRate2"> </h5>
										<dl id="upRateList2">
										
										</dl>
									</div>
									<div class="cate_sml">
										<h5 class="tit_dl" id="upjongRate3"> </h5>
										<dl id="upRateList3">
										
										</dl>
									</div>
								</div>
								<div class="article_rg">
									<div class="bx_graph"  id="eventMap3">
										<div id="event3_legend" class="map legend"></div>
										<select id="upRateMapSelect" class="eventSelect" onchange="upRateMapChnge(this.value)">
													<option value="" selected>업종을 선택해주세요.</option>
											<c:if test="${!empty upjongList}">
												<c:forEach var="item" items="${upjongList }">
													<option value="${item.code }">${item.cd_nm }</option>
												</c:forEach>
											</c:if>
										</select>
									
									</div>
								</div>
							</div>
							<!-- // -->
						</div>
					</div>
					<!-- //section1 -->

					<!-- section2 -->
					<div class="section" id="section2">
						<div class="inner">
							<h3 class="hide">방문객 특성</h3>
							<!--  -->
							<div class="article_group">
								<div class="article_lf">
									<h4 class="tit">방문객 총 수</h2>
									<dl id="visitrCnt">
									
									</dl>
								</div>
								<div class="article_rg">
									<div class="bx_graph" id="eventMap4">
										<div id="event4_legend" class="map legend"></div>
										
									</div>
								</div>
							</div>
							<!-- // -->

							<!--  -->
							<div class="article_group">
								<div class="article_lf">
									<h4 class="tit">방문객 성/연령</h2>
									<dl>
										<dt>방문객 특성 :</dt>
										<dd><strong id="visitrChar"> </strong></dd>

										<dt>안산시민 특성</dt>
										<dd><strong id="ctznChar"> </strong></dd>
									</dl>
								</div>
								<div class="article_rg">
									<div class="bx_graph" id="eventChart4">
									
									</div>
								</div>
							</div>
							<!-- // -->
						</div>
					</div>
					<!-- //section2 -->

					<!-- section3 -->
					<div class="section" id="section3">
						<div class="inner">
							<h3 class="hide">방문객 지출</h3>
							<!--  -->
							<div class="article_group">
								<div class="article_lf">
									<h4 class="tit">방문객 소비액</h2>
									<dl id="cnsmpList">
									
									</dl>
								</div>
								<div class="article_rg">
									<div class="bx_graph" id="eventMap5">
										<div id="event5_legend" class="map legend"></div>
										
									</div>
								</div>
							</div>
							<!-- // -->

							<!--  -->
							<div class="article_group">
								<div class="article_lf">
									<h4 class="tit">방문객 소비업종</h2>
									<dl  id="cnsmpMxmList">
										
									</dl>
								</div>
								<div class="article_rg">
									<div class="bx_graph">
										<div class="graph_half" id="eventChart5_1">
										
										</div>
										<div class="graph_half" id="eventChart5_2">
										
										</div>
									</div>
								</div>
							</div>
							<!-- // -->
							
							<!--  -->
							<div class="article_group">
								<div class="article_lf">
									<h4 class="tit">방문객 소비시간</h2>
									<dl id="cnsmpTimeList">
									
									</dl>
								</div>
								<div class="article_rg">
									<div class="bx_graph" id="eventChart6">
										
									</div>
								</div>
							</div>
							<!-- // -->

							<!--  -->
							<div class="article_group">
								<div class="article_lf">
									<h4 class="tit">방문객 유입지역</h2>
									<dl id="visitrInflow">

									</dl>
								</div>
								<div class="article_rg">
									<div class="bx_graph" id="eventMap6">
										<div id="event6_legend" class="map legend"></div>
										
									</div>
								</div>
							</div>
							<!-- // -->
						</div>
					</div>
					<!-- //section3 -->
					</div>
				</div>
				<!-- //본문 ==================================================================================================== -->
			</div>
			<!-- //contents -->

			<!-- footer -->
			<div id="footer">
				<div class="inner">
					<address>Copyright ⓒ OPENmate_ON All rights reserved.</address>
				</div>
			</div>
			<!-- //footer -->
		</div>
	</body>
	<script src="/js/event_effect.js"></script>
	<script>
	var timeChart = null; 
	
	$(document).ready(function(){
		
		// 최상단 시계열 그래프
		setDataGraph();
		
		// 이벤트1
		regionAmtChngeMap("amt");
		regionAmtChngeText();
		regionAmtChngeGraph();
		
		// 이벤트2
	 	upjongAmtChngeText();
		
		// 이벤트3
	 	upjongRateChngeText();
		
		// 이벤트4
		eventVisitrMap();
	 	eventVisitrText();
	 	visitrCtznGraph();
		
		// 이벤트5
		eventVisitrCnsmpMap();
	 	eventVisitrCnsmpText();
	 	eventVisitrCnsmpGraph();
		
		// 이벤트6
	 	eventCnsmpTimeText();
	 	eventCnsmpTimeGraph();
	 	
		//레이어팝업 - 기간직접입력
		$(".btn_period").on("click", function(){
			var sdateText = $('.search_period').text().trim().split("~")[0];
			var edateText = $('.search_period').text().trim().split("~")[1];
			$("#selectStartDate").text(sdateText);
			$("#selectEndDate").text(edateText);
			
			$("#sDatepicker").datepicker({
				showOn:"both",
				dateFormat : "yy. mm. dd" ,
				onSelect: function(dateText,inst) { 
					$("#selectStartDate").text(dateText);
					$("#eDatepicker").datepicker( "option", "minDate", new Date(dateText) );
				}
			});
			$( "#sDatepicker" ).datepicker( "setDate", new Date(sdateText));
			
			$("#eDatepicker").datepicker({
				showOn:"both",
				dateFormat : "yy. mm. dd" ,
				onSelect: function(dateText,inst) { 
					$("#selectEndDate").text(dateText);
					$("#sDatepicker").datepicker( "option", "maxDate", new Date(dateText) );
				}
			});
			$( "#eDatepicker" ).datepicker( "setDate", new Date(edateText) );
			
			$(this).siblings(".layer_period").fadeIn();
		});
		$(".btn_close").on("click", function(){
			$(this).parents(".layer_period").fadeOut();
		});
		
	 	
	 	
	});
		
	function changePeriod(){
		var sPeriod = $("#selectStartDate").text().split(".");
		var ePeriod = $("#selectEndDate").text().split(".");
		var	sdate =  sPeriod[0].trim()+sPeriod[1].trim()+sPeriod[2].trim();
		var	edate =  ePeriod[0].trim()+ePeriod[1].trim()+ePeriod[2].trim();
		
		timeChart.setVal(sdate,edate);
		$(".search_period").text($("#selectStartDate").text() + " ~ " + $("#selectEndDate").text());
		$(".btn_close").trigger("click");
		
		// 이벤트1
		regionAmtChngeMap($("#amtMapSelect").val());
		regionAmtChngeText();
		regionAmtChngeGraph();
		
		// 이벤트2
	 	upjongAmtChngeText();
		
		// 이벤트3
	 	upjongRateChngeText();
		
		// 이벤트4
		eventVisitrMap();
	 	eventVisitrText();
	 	visitrCtznGraph();
		
		// 이벤트5
		eventVisitrCnsmpMap();
	 	eventVisitrCnsmpText();
	 	eventVisitrCnsmpGraph();
		
		// 이벤트6
		eventCnsmpTimeMap();
	 	eventCnsmpTimeText();
	 	eventCnsmpTimeGraph()
	}
	
	function setDataGraph(){
		//그래프 네비게이션 시작
		
		$.ajax({
			url : '/onmap/ecnmy_trnd/graph_data.json',
			data:{
				"ctyCd" : event_config.sessionCtyCd
			},
			success: function(result, status) {
				
				var margin = {top: 0, right: 10, bottom: 20, left: 10};
				timeChart = timeLineChart("#rangeEventChart", result.data, "stdr_date", "total_cnt", margin,12, null ,{'x':20161205, 'y':20161220}, timeHandler);
				
// 				var sDate = start.stdr_date.substr(0,4)+". "+start.stdr_date.substr(4,2)+". "+start.stdr_date.substr(6);
// 				var eDate = end.stdr_date.substr(0,4)+". "+end.stdr_date.substr(4,2)+". "+end.stdr_date.substr(6);
// 				$(".search_period").text(sDate+" ~ "+eDate);
				$(".search_period").text("2016 .12 .05 ~ 2016 .12 .20");
			}
		});
		
	}
		
	function timeHandler(evt, start, end, column){
		event_config.selectedStartDate = start.stdr_date; 
		event_config.selectedEndDate = end.stdr_date;


		var sDate = start.stdr_date.substr(0,4)+". "+start.stdr_date.substr(4,2)+". "+start.stdr_date.substr(6);
		var eDate = end.stdr_date.substr(0,4)+". "+end.stdr_date.substr(4,2)+". "+end.stdr_date.substr(6);
		$(".search_period").text(sDate+" ~ "+eDate);
		
		// 이벤트1
		regionAmtChngeMap($("#amtMapSelect").val());
		regionAmtChngeText();
		regionAmtChngeGraph();
		
		// 이벤트2
	 	upjongAmtChngeText();
		
		// 이벤트3
	 	upjongRateChngeText();
		
		// 이벤트4
		eventVisitrMap();
	 	eventVisitrText();
	 	visitrCtznGraph();
		
		// 이벤트5
		eventVisitrCnsmpMap();
	 	eventVisitrCnsmpText();
	 	eventVisitrCnsmpGraph();
		
		// 이벤트6
		eventCnsmpTimeMap();
	 	eventCnsmpTimeText();
	 	eventCnsmpTimeGraph()

	}
		
	function amtMapChnge(value){
		regionAmtChngeMap(value)
	}
	
	function upAmtMapChnge(value){
		upjongAmtChngeMap(value)
	}
	
	function upRateMapChnge(value){
		upjongRateChngeMap(value)
	}
		

	</script>
</html>