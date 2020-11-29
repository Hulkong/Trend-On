<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<!doctype html>
<html>
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
	
		<script src="/js/d3Chart/d3.js"></script>
		<script src="/js/d3Chart/d3plus.js"></script>
		<script src="/js/d3Chart/d3Chart.js"></script>
		
		<script src="/js/Leaflet-1.0.2/geostats.js"></script>
		<link rel="stylesheet" href="/js/Leaflet-1.0.2/leaflet.css" />
		<script type="text/javascript" src="/js/Leaflet-1.0.2/leaflet-src.js"></script>
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
					<h2 class="tit_top">경제 트렌드</h2>
					<ul class="menu_anchor">
						<li><a href="#firstPage" class="active">매출액</a></li>
						<li><a href="#secondPage">방문객 특성</a></li>
						<li><a href="#thirdPage">방문객 지출</a></li>
					</ul>
					<div class="compare_area">
						<a href="#" class="btn_compare layer_open">지역간 비교</a>
						<!-- 레이어 팝업 -->
						<div class="pop_layer">
							<div class="layer_compare">
								<!-- 레이어 팝업 상단 -->
								<div class="compare_header">
									<p class="tit_compare">지역간 비교</p>
									<ul class="menu_compare">
										<li class="active"><a href="#">매출액</a></li>
										<li><a href="#">방문객 특성</a></li>
										<li><a href="#">방문객 지출</a></li>
									</ul>
									<div class="select_box select_ty1">
										<select>
											<option selected="selected">이전기간</option>
											<option>선택2</option>
										</select>
										<span class="tit"></span>
									</div>
									<p class="txt">비교하실지역을 선택해 주세요</p>
									<a href="#" class="btn_close">닫기</a>
								</div>
								<!-- //레이어 팝업 상단 -->
								<!-- 레이어 팝업 본문 -->
								<div class="compare_body">
									<div class="article_select">
										<div class="group_select">
											<p class="tit"><em>시/도</em>를 선택하세요</p>
											<div class="group_scroll">
												<ul>
													<li><a href="#" class="on">서울시</a></li>
													<li><a href="#">부산광역시</a></li>
													<li><a href="#">대구광역시</a></li>
													<li><a href="#">부산광역시</a></li>
													<li><a href="#">대구광역시</a></li>
													<li><a href="#">부산광역시</a></li>
													<li><a href="#">대구광역시</a></li>
													<li><a href="#">부산광역시</a></li>
													<li><a href="#">대구광역시</a></li>
													<li><a href="#">부산광역시</a></li>
													<li><a href="#">대구광역시</a></li>
													<li><a href="#">부산광역시</a></li>
													<li><a href="#">대구광역시</a></li>
												</ul>
											</div>
										</div>
										<div class="group_select">
											<p class="tit"><em>군/구</em>를 선택하세요</p>
											<div class="group_scroll">
												<ul>
													<li><a href="#">강남구</a></li>
													<li><a href="#">강남구</a></li>
													<li><a href="#">강남구</a></li>
												</ul>
											</div>
										</div>
									</div>
									<div class="compare_btm">
										<ul>
											<li><button class="btn_confirm">확인</button></li>
											<li><button class="btn_cancel">취소</button></li>
										</ul>
									</div>
								</div>
								<!-- //레이어 팝업 본문 -->
							</div>
						</div>
						<!-- //레이어 팝업 -->
					</div>
					<div class="article_rgt">
						<div class="btn_list">
							<ul>
								<li class="btn_pdf"><a href="#">PDF 다운</a></li>
								<li class="btn_print"><a href="#">인쇄</a></li>
							</ul>
						</div>
					</div>
					<div class="top_graph">
						<div class="bx_graph" id="rangeChart">
						
						</div>
					</div>
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
									<h4 class="tit">거래총액</h2>
									<dl>
										<dt class="total">안산시 총 거래액 :</dt>
										<dd class="total" id="amtTotal_ET"></dd>

										<dt id="amt1_nm_ET"></dt>
										<dd id="amt1_val_ET"></dd>

										<dt id="amt2_nm_ET"></dt>
										<dd id="amt2_val_ET"></dd>

										<dt id="amt3_nm_ET"></dt>
										<dd id="amt3_val_ET"></dd>
									</dl>
								</div>
								<div class="article_rg">
									<div class="bx_graph" id="amtMap">
										<div id="ecnmyTrnd_salamt_legend" class="map legend"></div>
<!-- 										<img src="/images/sub/graph_02.jpg" alt="" /> -->
									</div>
								</div>
							</div>
							<!-- // -->

							<!--  -->
							<div class="article_group">
								<div class="article_lf">
									<h4 class="tit">업종별 거래액</h2>
									<dl>
										<dt id="up1_nm_ET"></dt>
										<dd id="up1_val_ET"></dd>

										<dt id="up2_nm_ET"></dt>
										<dd id="up2_val_ET"></dd>

										<dt id="up3_nm_ET"></dt>
										<dd id="up3_val_ET"></dd>
									</dl>
								</div>
								<div class="article_rg">
									<div class="bx_graph" id="amtTreemap">
<!-- 										<img src="/images/sub/graph_02.jpg" alt="" /> -->
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
									<dl>
										<dt class="total">방문객 총 수 :</dt>
										<dd class="total" id="vstTotal_ET"></dd>

										<dt id="vst1_nm_ET"></dt>
										<dd id="vst1_val_ET"></dd>

										<dt id="vst2_nm_ET"></dt>
										<dd id="vst2_val_ET"></dd>

										<dt id="vst3_nm_ET"></dt>
										<dd id="vst3_val_ET"></dd>
									</dl>
								</div>
								<div class="article_rg">
									<div class="bx_graph" id="cntMap">
										<div id="ecnmyTrnd_cnt_legend" class="map legend"></div>
<!-- 										<img src="/images/sub/graph_02.jpg" alt="" /> -->
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
										<dd id="vst_char_ET"></dd>

										<dt>안산시민 특성</dt>
										<dd id="ctzn_char_ET"></dd>
									</dl>
								</div>
								<div class="article_rg">
									<div class="bx_graph" id="cntBar">
<!-- 										<img src="/images/sub/graph_02.jpg" alt="" /> -->
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
									<dl>
										<dt class="total">소비총액 :</dt>
										<dd class="total" id="cnsmpTotal_ET"></dd>

										<dt id="cnsmp1_nm_ET"></dt>
										<dd id="cnsmp1_val_ET"></dd>

										<dt id="cnsmp2_nm_ET"></dt>
										<dd id="cnsmp2_val_ET"></dd>

										<dt id="cnsmp3_nm_ET"></dt>
										<dd id="cnsmp3_val_ET"></dd>
									</dl>
								</div>
								<div class="article_rg">
									<div class="bx_graph" id="expndtrMap">
										<div id="ecnmyTrnd_expndtr_legend" class="map legend"></div>
<!-- 										<img src="/images/sub/graph_02.jpg" alt="" /> -->
									</div>
								</div>
							</div>
							<!-- // -->

							<!--  -->
							<div class="article_group">
								<div class="article_lf">
									<h4 class="tit">방문객 소비업종</h2>
									<dl>
										<dt class="total">소비 최다업종 :</dt>
										<dd class="total" id="up_cnsmpTotal_ET">한식</dd>

										<dt id="up_cnsmp1_nm_ET"></dt>
										<dd id="up_cnsmp1_val_ET"></dd>

										<dt id="up_cnsmp2_nm_ET"></dt>
										<dd id="up_cnsmp2_val_ET"></dd>

										<dt id="up_cnsmp3_nm_ET"></dt>
										<dd id="up_cnsmp3_val_ET"></dd>
									</dl>
								</div>
								<div class="article_rg">
									<div class="bx_graph">
										<div class="graph_half" id="expndtrBar1">
										
										</div>
										<div class="graph_half" id="expndtrBar2">
										
										</div>
									</div>
								</div>
							</div>
							<!-- // -->
							
							<!--  -->
							<div class="article_group">
								<div class="article_lf">
									<h4 class="tit">방문객 소비시간</h2>
									<dl>
										<dt class="total">최다 소비시간 :</dt>
										<dd class="total" id="cnsmpTimeTotal_ET"></dd>

										<dt id="cnsmpTime1_nm_ET"></dt>
										<dd id="cnsmpTime1_val_ET"></dd>

										<dt id="cnsmpTime2_nm_ET"></dt>
										<dd id="cnsmpTime2_val_ET"></dd>

										<dt id="cnsmpTime3_nm_ET"></dt>
										<dd id="cnsmpTime3_val_ET"></dd>
									</dl>
								</div>
								<div class="article_rg">
									<div class="bx_graph" id="inflowBar">
<!-- 										<img src="/images/sub/graph_02.jpg" alt="" /> -->
									</div>
								</div>
							</div>
							<!-- // -->

							<!--  -->
							<div class="article_group">
								<div class="article_lf">
									<h4 class="tit">방문객 유입지역</h2>
									<dl>
										<dt class="total">최다 유입지 :</dt>
										<dd class="total" id="inflowTotal_ET"></dd>

										<dt id="inflow1_nm_ET"></dt>
										<dd id="inflow1_val_ET"></dd>

										<dt id="inflow2_nm_ET"></dt>
										<dd id="inflow2_val_ET"></dd>

										<dt id="inflow3_nm_ET"></dt>
										<dd id="inflow3_val_ET"></dd>
									</dl>
								</div>
								<div class="article_rg">
									<div class="bx_graph" id="inflowMap">
										<div id="ecnmyTrnd_inflow_legend" class="map legend"></div>
<!-- 										<img src="/images/sub/graph_02.jpg" alt="" /> -->
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
<!-- 	<script src="/js/ecnmy_trnd.js"></script> -->
	<script type="text/javascript">
	var ecnmy_trnd_config = {
			layerFid : {},
			sessionCtyCd:'1168',
			selectedDate:{start:"20161201", end:"20161202"},
			selectedRgnClss:'H4'
	};

// 	var colorArr = [ '#c6dbef', '#9ecae1', '#6baed6','#3182bd', '#08519c'  ];
	var colorArr = [ '#2c7bb6', '#abdda4', '#ffffbf','#fdae61', '#d7191c' ];
	
	var amtLayer = null;
	var cntLayer = null;
	var expndtrLayer = null;
	var inflowLayer = null;

	var indutyTreemapData = null;
	var cntBarData = null;
	var mostCommonData = null;

	// 경제 트렌드 : 매출액 지도
	var amtMap = L.map('amtMap',{ zoomControl:true
							  	, scrollWheelZoom:false
							  	, maxZoom:18
							  	, minZoom:7
							  }
	).setView([37.492334, 127.062444]);
	amtMap.dragging.disable();
	amtMap.doubleClickZoom.disable(); 
	L.tileLayer('http://xdworld.vworld.kr:8080/2d/gray/201411/{z}/{x}/{y}.png'
			, {	    attribution : '© Vworld'
				  , maxZoom : 19 
				  , minZoom : 7
			}).addTo(amtMap);
// 	L.tileLayer("http://tmap{s}.selfmap.co.kr:8081/TileMap/{z}/{y}/{x}.png", {
// 		 	minZoom : 7 , 
// 			maxZoom : 18 , 
// 			subdomains: "0123",
// 			reuseTiles: true,
// 			continuousWorld: true,
// 			attribution: "&copy; <a href=\"http://openmate.co.kr\">openmate</a>"
// 	}).addTo(amtMap);

	//경제트렌드 : 방문객수 지도
	var cntMap = L.map('cntMap',{ zoomControl:true
							  	, scrollWheelZoom:false
							  	, maxZoom:18
							  	, minZoom:7
							    }
	).setView([37.492334, 127.062444]);
	cntMap.dragging.disable();
	cntMap.doubleClickZoom.disable(); 
	L.tileLayer('http://xdworld.vworld.kr:8080/2d/gray/201411/{z}/{x}/{y}.png'
			, {	    attribution : '© Vworld'
				  , maxZoom : 19 
				  , minZoom : 7
			}).addTo(cntMap);
// 	L.tileLayer("http://tmap{s}.selfmap.co.kr:8081/TileMap/{z}/{y}/{x}.png", {
// 			minZoom : 7 , 
// 			maxZoom : 18 , 
// 			subdomains: "0123",
// 			reuseTiles: true,
// 			continuousWorld: true,
// 			attribution: "&copy; <a href=\"http://openmate.co.kr\">openmate</a>"
// 	}).addTo(cntMap);

	//경제트렌드 : 방문객 거래액 지도
	var expndtrMap = L.map('expndtrMap',{ zoomControl:true
										, scrollWheelZoom:false
										, maxZoom:18
										, minZoom:7
	}
	).setView([37.492334, 127.062444]);
	expndtrMap.dragging.disable();
	expndtrMap.doubleClickZoom.disable(); 
	L.tileLayer('http://xdworld.vworld.kr:8080/2d/gray/201411/{z}/{x}/{y}.png'
			, {	    attribution : '© Vworld'
				  , maxZoom : 19 
				  , minZoom : 7
			}).addTo(expndtrMap);
// 	L.tileLayer("http://tmap{s}.selfmap.co.kr:8081/TileMap/{z}/{y}/{x}.png", {
// 		minZoom : 7 , 
// 		maxZoom : 18 , 
// 		subdomains: "0123",
// 		reuseTiles: true,
// 		continuousWorld: true,
// 		attribution: "&copy; <a href=\"http://openmate.co.kr\">openmate</a>"
// 	}).addTo(expndtrMap);

	//경제트렌드 : 유입지역별 방문객수
	var inflowMap = L.map('inflowMap',{ zoomControl:true
		, scrollWheelZoom:false
		, maxZoom:19
		, minZoom:7
	}
	).setView([37.492334, 127.062444]);
// 	inflowMap.dragging.disable();
	inflowMap.doubleClickZoom.disable(); 
	L.tileLayer('http://xdworld.vworld.kr:8080/2d/gray/201411/{z}/{x}/{y}.png'
			, {	    attribution : '© Vworld'
				  , maxZoom : 19
				  , minZoom : 7
			}).addTo(inflowMap);
// 	L.tileLayer("http://tmap{s}.selfmap.co.kr:8081/TileMap/{z}/{y}/{x}.png", {
// 		minZoom : 7 , 
// 		maxZoom : 18 , 
// 		subdomains: "0123",
// 		reuseTiles: true,
// 		continuousWorld: true,
// 		attribution: "&copy; <a href=\"http://openmate.co.kr\">openmate</a>"
// 	}).addTo(inflowMap);

	$(document).ready(function(){
		
		// 날짜별 그래프 슬라이더
		setTimeGraph();
		
		// 경제트렌드  지도
		$.ajax({
			type: "GET",
			dataType: 'json',
			url:"/onmap/ecnmy_trnd/getTrndMap.json",
			data:{
				"layerName" : "amtLayer",
				"ctyCd" : ecnmy_trnd_config.sessionCtyCd,
				"rgnClss" : ecnmy_trnd_config.selectedRgnClss
			},
			success: function(json) {
				
				// 거래액
				amtLayer = L.geoJSON(json);
				amtLayer._fid = "amtLayer";
				ecnmy_trnd_config.layerFid.amtLayer = amtLayer._fid;
				amtLayer.addTo(amtMap);
				var bounds = amtLayer.getBounds();
				amtMap.fitBounds(bounds);
				
				// 방문객 수
				cntLayer = L.geoJSON(json);
				cntLayer._fid = "cntLayer";
				ecnmy_trnd_config.layerFid.cntLayer = cntLayer._fid;
				cntLayer.addTo(cntMap);
				
				var bounds = cntLayer.getBounds();
				cntMap.fitBounds(bounds);
				
				// 소비액
				expndtrLayer = L.geoJSON(json);
				expndtrLayer._fid = "expndtrLayer";
				ecnmy_trnd_config.layerFid.expndtrLayer = expndtrLayer._fid;
				expndtrLayer.addTo(expndtrMap);
				
				var bounds = expndtrLayer.getBounds();
				expndtrMap.fitBounds(bounds);
				
			}
		});
		
		// 유입지역별 주제도
		$.ajax({
			type: "GET",
			dataType: 'json',
			url:"/onmap/ecnmy_trnd/getTrndCtyMap.json",
			data:{
				"layerName" : "inflowLayer",
				"startDate" : ecnmy_trnd_config.selectedDate.start,
				"endDate" : ecnmy_trnd_config.selectedDate.end,
				"rgnClss" : "H2"
			},
			success: function(json) {
				inflowLayer = L.geoJSON(json);
				inflowLayer._fid = "inflowLayer";
				ecnmy_trnd_config.layerFid.inflowLayer = inflowLayer._fid;
				inflowLayer.addTo(inflowMap);
				
				var bounds = inflowLayer.getBounds();
				inflowMap.fitBounds(bounds);
		
				// 주제도 표현
				setTrndMapChoropleth();
			}
		});
		
			
		// 경제 트렌드 각 페이지 text
		setTrndTextArea();
		
		// 경제 트렌드 그래프 
		setTrndGraphArea();
		
		
	});
	
	
	function setTimeGraph(){
// 		console.log(ecnmy_trnd_config.sessionCtyCd);
		//그래프 네비게이션 시작
		
		$.ajax({
			url : '/onmap/ecnmy_trnd/graph_data.json',
			data:{
				"ctyCd" : ecnmy_trnd_config.sessionCtyCd
			},
			success: function(result, status) {
				
				var margin = {top: 0, right: 10, bottom: 20, left: 10};
				timeLineChart("#rangeChart", result.data, "stdr_date", "total_cnt", margin,12, null ,{'x':20161205, 'y':20161220}, dateHandler);
// 				console.log(result);
			}
		});
		
	}
	
	function dateHandler(evt,start, end,column){
		ecnmy_trnd_config.selectedDate.start = start.stdr_date; 
		ecnmy_trnd_config.selectedDate.end = end.stdr_date;
		
		// 경제 트렌드 주제도 변경
		setTrndMapChoropleth();
		
		// 경제 트렌드 각 페이지 text
		setTrndTextArea();
		
		// 경제 트렌드 그래프 
		setTrndGraphArea();
		
		
	}
	
	function setTrndMapChoropleth(){
		
		// 경제트렌드  매출액 : amtData
		$.ajax({
			type: "GET",
			dataType: 'json',
			url:"/onmap/ecnmy_trnd/salamt.json",
			data:{
				"ctyCd" : ecnmy_trnd_config.sessionCtyCd,
				"startDate" : ecnmy_trnd_config.selectedDate.start,
				"endDate" : ecnmy_trnd_config.selectedDate.end,
				"rgnClss" : ecnmy_trnd_config.selectedRgnClss
			},
			success: function(data) {
// 				console.log(data.list);
				var mapLayer = matchFeature(amtMap, data.list, ecnmy_trnd_config.layerFid.amtLayer);
				doAdmiChoropleth("sale_amt",mapLayer,colorArr);
			}
		});
		
		// 경제트렌드  방문자수 : cntData
		$.ajax({
			type: "GET",
			dataType: 'json',
			url:"/onmap/ecnmy_trnd/visitr_co.json",
			data:{
				"ctyCd" : ecnmy_trnd_config.sessionCtyCd,
				"startDate" : ecnmy_trnd_config.selectedDate.start,
				"endDate" : ecnmy_trnd_config.selectedDate.end,
				"rgnClss" : ecnmy_trnd_config.selectedRgnClss
			},
			success: function(data) {
// 				console.log(data.list);
				var mapLayer = matchFeature(cntMap, data.list, ecnmy_trnd_config.layerFid.cntLayer);
				doAdmiChoropleth("total_cnt",mapLayer,colorArr);
			}
		});
	

		
		// 경제트렌드  방문객 거래액 : expndtrData
		$.ajax({
			type: "GET",
			dataType: 'json',
			url:"/onmap/ecnmy_trnd/visitr_expndtr.json",
			data:{
				"ctyCd" : ecnmy_trnd_config.sessionCtyCd,
				"startDate" : ecnmy_trnd_config.selectedDate.start,
				"endDate" : ecnmy_trnd_config.selectedDate.end,
				"rgnClss" : ecnmy_trnd_config.selectedRgnClss
			},
			success: function(data) {
				var mapLayer = matchFeature(expndtrMap, data.list, ecnmy_trnd_config.layerFid.expndtrLayer);
				doAdmiChoropleth("sale_amt",mapLayer,colorArr);
			}
		});
	
		// 유입지역별 주제도
		$.ajax({
			type: "GET",
			dataType: 'json',
			url:"/onmap/ecnmy_trnd/visitr_inflow.json",
			data:{
				"ctyCd" : ecnmy_trnd_config.sessionCtyCd,
				"startDate" : ecnmy_trnd_config.selectedDate.start,
				"endDate" : ecnmy_trnd_config.selectedDate.end,
				"rgnClss" : "H2"
			},
			success: function(data) {
				var mapLayer = matchFeature(inflowMap, data.list, ecnmy_trnd_config.layerFid.inflowLayer);
				doAdmiChoropleth("in_cnt",mapLayer,colorArr);
			}
		});
	
		// 경제 트렌드 주제도 범례
		trndMapLegends();
	}
	
	function setTrndTextArea(){
		// 경제 트렌드 각 페이지 text
		$.ajax({
			url : '/onmap/ecnmy_trnd/ecnmy_trnd_text_data.json',
			data:{
				"ctyCd" : ecnmy_trnd_config.sessionCtyCd,
				"megaCd" : ecnmy_trnd_config.sessionCtyCd.substr(0,2),
				"startDate" : ecnmy_trnd_config.selectedDate.start,
				"endDate" : ecnmy_trnd_config.selectedDate.end,
				"rgnClss" : ecnmy_trnd_config.selectedRgnClss
			},
			success: function(result, status) {
// 				console.log(result);
				// ET1.매출액  amtRankList
				if(result.amtRankList.length > 0){
					var total = 0;
					for(var i = 0 ; i < result.amtRankList.length; i++){
						$("#amt"+(i+1)+"_nm_ET").text(result.amtRankList[i].admi_nm + " :");
						$("#amt"+(i+1)+"_val_ET").html("<strong>"+Math.round(result.amtRankList[i].sale_amt/100000000) + "</strong>억원");
						total += result.amtRankList[i].sale_amt;
					}
					$('#amtTotal_ET').html("<strong>"+Math.round(total/100000000)+"</strong>억원");
				}
				
				// ET1.매출액  indutyRankList
				if(result.indutyRankList.length > 0){
					for(var i = 0; i < result.indutyRankList.length; i++){
						$("#up"+(i+1)+"_nm_ET").text(result.indutyRankList[i].cd_nm + " :");
						$("#up"+(i+1)+"_val_ET").html("<strong>"+Math.round(result.indutyRankList[i].sale_amt/100000000) + "</strong>억원");
					}
				}
				
				// ET2. 방문객 visitrRankList
				if(result.visitrRankList.length > 0){
					var total = 0;
					for(var i = 0 ; i < result.visitrRankList.length; i++){
						$("#vst"+(i+1)+"_nm_ET").text(result.visitrRankList[i].nm + " :");
						$("#vst"+(i+1)+"_val_ET").html("<strong>"+Math.round(result.visitrRankList[i].total_cnt/1000) + "</strong>천명");
						total += result.visitrRankList[i].total_cnt;
					}
					$('#vstTotal_ET').html("<strong>"+Math.round(total/1000)+"<strong>천명");
				}
				
				// ET2. 방문객 특성 visitrChartrList
				if(result.visitrChartrList.length > 0){
					$('#vst_char_ET').html("<strong>"+result.visitrChartrList[0].chr+"</strong>");
				}
				// ET2. 시민 특성 ctznChartrList
				if(result.ctznChartrList.length > 0){
					$('#ctzn_char_ET').html("<strong>"+result.ctznChartrList[0].chr+"</strong>");
				}
				
				// ET3. 방문객 소비액 cnsmpList
				if(result.cnsmpList.length > 0){
					var total = 0;
					for(var i = 0 ; i < result.cnsmpList.length; i++){
						$("#cnsmp"+(i+1)+"_nm_ET").text(result.cnsmpList[i].nm + " :");
						$("#cnsmp"+(i+1)+"_val_ET").html("<strong>"+Math.round(result.cnsmpList[i].sale_amt/100000000) + "</strong>억원");
						total += result.cnsmpList[i].sale_amt;
					}
					$('#cnsmpTotal_ET').html("<strong>"+Math.round(total/100000000)+"</strong>억원");
				}
				
				// ET3. 방문객 소비액 cnsmpIndutycntList
				if(result.cnsmpIndutycntList.length > 0){
					var total = 0;
					for(var i = 0 ; i < result.cnsmpIndutycntList.length; i++){
						$("#up_cnsmp"+(i+1)+"_nm_ET").text(result.cnsmpIndutycntList[i].cd_nm + " :");
						$("#up_cnsmp"+(i+1)+"_val_ET").html("<strong>"+result.cnsmpIndutycntList[i].rate+"</strong>%(<strong>"+Math.round(result.cnsmpIndutycntList[i].sale_amt/100000000) + "</strong>억원)");
						total += result.cnsmpList[i].sale_amt;
					}
					$('#up_cnsmpTotal_ET').html("<strong>"+result.cnsmpIndutycntList[0].cd_nm+"</strong>");
				}
				
				// ET4. 방문객 소비시간 timeCntList
				if(result.timeCntList.length > 0){
					for(var i = 0 ; i < result.timeCntList.length; i++){
						$("#cnsmpTime"+(i+1)+"_nm_ET").text(result.timeCntList[i].cd_nm + " :");
						$("#cnsmpTime"+(i+1)+"_val_ET").html("<strong>"+result.timeCntList[i].rate+"</strong>%(<strong>"+Math.round(result.timeCntList[i].total_cnt/1000) + "</strong>천명)");
					}
					$('#cnsmpTimeTotal_ET').html("<strong>"+result.timeCntList[0].cd_nm+"</strong>");
				}
				
				// ET4. 방문객 유입지역 inflowList
				if(result.inflowList.length > 0){
					for(var i = 0 ; i < result.inflowList.length; i++){
						$("#inflow"+(i+1)+"_nm_ET").text(result.inflowList[i].nm + " :");
						$("#inflow"+(i+1)+"_val_ET").html("<strong>"+result.inflowList[i].rate+"</strong>%(<strong>"+Math.round(result.inflowList[i].in_cnt/1000) + "</strong>천명)");
					}
					$('#inflowTotal_ET').html("<strong>"+result.inflowList[0].nm+"</strong>");
				}
			}
		});
	}
	
	function setTrndGraphArea(){
		// 경제 트렌드 그래프 
		$.ajax({
			url : '/onmap/ecnmy_trnd/ecnmy_trnd_chart_data.json',
			data:{
				"ctyCd" : ecnmy_trnd_config.sessionCtyCd,
				"startDate" : ecnmy_trnd_config.selectedDate.start,
				"endDate" : ecnmy_trnd_config.selectedDate.end
			},
			success: function(result, status) {
				cntBarData = result.cntList;
				indutyTreemapData = result.indutyList;
				mostCommonData = result.mostCommonList;
				mostSpecializedData = result.mostSpecializedList;
				timeChartData = result.timeChartList;
				
				
				if(cntBarData){
					var attributes = {
							  "h" : ["manCtzn", "womanCtzn"],
							  "e" : ["manVisitr","womanVisitr"]
						};
						var inputData =[];
						for(var i = 2; i < 7; i++){
							var chartData = {};
							var detailsArr =[];
							
							chartData.manVisitr = cntBarData[0]['e_m_'+(i*10)+'_cnt'];
							chartData.womanVisitr = cntBarData[0]['e_f_'+(i*10)+'_cnt'];
							chartData.manCtzn = cntBarData[0]['h_m_'+(i*10)+'_cnt'];
							chartData.womanCtzn = cntBarData[0]['h_f_'+(i*10)+'_cnt'];
							chartData.name = (i*10)+"대";
							chartData.total = Math.max((chartData.manVisitr + chartData.womanVisitr) , (chartData.manCtzn + chartData.womanCtzn));
							for(var j = 0 ; j < 2; j++){
								var column = "e";
								if(j > 0) column = "h";
								for(var k = 0 ; k < 2; k++){
									var detailsData = {};
									detailsData.column = column;
									detailsData.name = attributes[column][k];
									if(k == 0){
										detailsData.yBegin = 0;
										detailsData.yEnd = chartData[attributes[column][k]];
									}else{
										detailsData.yBegin = chartData[attributes[column][k-1]];
										detailsData.yEnd = chartData[attributes[column][k]] + chartData[attributes[column][k-1]];
									}
									detailsArr.push(detailsData);
								}
							}
							
							chartData.columnDetails = detailsArr;
							inputData.push(chartData);
						}	
						
						var legend = ["방문객 남성","방문객 여성","시민 남성","시민 여성"];
						
						$("#cntBar").empty();
						stackedGroupedbar(inputData,"#cntBar",attributes,legend);
				}
				
				if(indutyTreemapData){
					var data =[];
					for(var i = 0; i < indutyTreemapData.length; i++){
						var chartData = {};
						chartData.color = indutyTreemapData[i].upjong1_cd;
						chartData.code = indutyTreemapData[i].upjong1_nm;
						chartData.name = indutyTreemapData[i].cd_nm;
						chartData.value = indutyTreemapData[i].sale_amt;
						chartData.id = indutyTreemapData[i].upjong2_cd;
						
						data.push(chartData);
						
					}
					
					$("#amtTreemap").empty();
					treemap_plus(data, "#amtTreemap");
				}
				
				if(mostCommonData){
					var data =[];
					for(var i = 0; i < mostCommonData.length; i++){
						var chartData = {};
						chartData.name = mostCommonData[i].cd_nm;
						chartData.value = mostCommonData[i].sale_amt;
						chartData.y = i+1;
						chartData.hex = '#2e6695';
						
						data.push(chartData);
					}
					
					var label={
							x:"소비 금액",
							y:"업종"
					};
					
					$("#expndtrBar1").empty();
					hozBar_plus(data, "#expndtrBar1", label);
				}
				
				if(mostSpecializedData){
					var data =[];
					for(var i = 0; i < mostSpecializedData.length; i++){
						var chartData = {};
						chartData.name = mostSpecializedData[i].cd_nm;
						chartData.value = mostSpecializedData[i].rate;
						chartData.y = i+1;
						chartData.hex = '#2e6695';
						
						data.push(chartData);
					}
					var label={
							x:"소비 비율",
							y:"업종"
					};
					
					$("#expndtrBar2").empty();
					hozBar_plus(data, "#expndtrBar2",label);
				}
				if(timeChartData){
					var timeArr = ["0-6","6-9","9-12","12-15","15-18","18-21","21-24"];
					var data =[];
					var groupData =[];
					for(var i = 0; i < 2 ; i++){
						var type = "e";
						if(i > 0) type = "h";
						var groupArr =[];
						for(var j = 1; j < 8; j++){
							var chartData = {};
							
							if(type == 'e') chartData.name = "방문객";
							else chartData.name = "시민";
							
							chartData.value = timeChartData[0][type+'_'+j+'_cnt'];
							chartData.x = j;
							chartData.time = timeArr[j-1];
							data.push(chartData);
							groupArr.push(chartData);
						}	
						groupData.push(groupArr);
					}
					
					var attributes =[
					                 {"name": "시민", "hex": "#d3d3d3"},
					                 {"name": "방문객", "hex": "#ff8166"}
					                ];
					
					var label={
							x:"시간대",
							y:"고객수"
					};
					$("#inflowBar").empty();
					barChart_plus(data.reverse(), "#inflowBar",attributes,label);

				}
			}
		});
	}
	
	function trndMapLegends(){
		// 경제 트렌드 매출액 : 지도 범례
		$.ajax({
			url : '/onmap/ecnmy_trnd/salamt_legend.json',
			data:{
				"ctyCd" : ecnmy_trnd_config.sessionCtyCd,
				"startDate" : ecnmy_trnd_config.selectedDate.start,
				"endDate" : ecnmy_trnd_config.selectedDate.end,
				"rgnClss" : ecnmy_trnd_config.selectedRgnClss
			},
			success: function(result, status) {
				var legend = result.legend.reverse();
				var vals =[];
				if(legend.length > 0){
					for(var i = 0 ; i < legend.length; i++){
						vals.push(Math.round(legend[i].max_value/1000000).toLocaleString());
					}
				}
				$("#ecnmyTrnd_salamt_legend").empty();
				$("#ecnmyTrnd_salamt_legend").append('<small> 행정동별 매출액 (단위:백만원) </small>');
				makeLengend("ecnmyTrnd_salamt_legend",colorArr,vals);
				
			}
		});
	
		// 경제 트렌드 방문자수 : 지도 범례
		$.ajax({
			url : '/onmap/ecnmy_trnd/visitr_co_legend.json',
			data:{
				"ctyCd" : ecnmy_trnd_config.sessionCtyCd,
				"startDate" : ecnmy_trnd_config.selectedDate.start,
				"endDate" : ecnmy_trnd_config.selectedDate.end,
				"rgnClss" : ecnmy_trnd_config.selectedRgnClss
			},
			success: function(result, status) {
				var vals =[];
				if(result.legend.length > 0){
					for(var i = 1 ; i < 6; i++){
						vals.push(result.legend[0]["max_value"+i].toLocaleString());
					}
				}
				$("#ecnmyTrnd_cnt_legend").empty();
				$("#ecnmyTrnd_cnt_legend").append('<small>  행정동별 방문객 수 (단위: 명) </small>');
				makeLengend("ecnmyTrnd_cnt_legend",colorArr,vals);
				
			}
		});
		
		// 경제 트렌드 방문객 거래액 : 지도 범례
		$.ajax({
			url : '/onmap/ecnmy_trnd/visitr_expndtr_legend.json',
			data:{
				"ctyCd" : ecnmy_trnd_config.sessionCtyCd,
				"startDate" : ecnmy_trnd_config.selectedDate.start,
				"endDate" : ecnmy_trnd_config.selectedDate.end,
				"rgnClss" : ecnmy_trnd_config.selectedRgnClss
			},
			success: function(result, status) {
				var vals =[];
				if(result.legend.length > 0){
					for(var i = 1 ; i < 6; i++){
						vals.push(Math.round(result.legend[0]["max_value"+i]/1000000).toLocaleString());
					}
				}
				$("#ecnmyTrnd_expndtr_legend").empty();
				$("#ecnmyTrnd_expndtr_legend").append('<small> 행정동별 방문객 소비금액 (단위:백만원) </small>');
				makeLengend("ecnmyTrnd_expndtr_legend",colorArr,vals);
				
			}
		});
		
		// 경제 트렌드 유입지역별 방문객수 : 지도 범례
		$.ajax({
			url : '/onmap/ecnmy_trnd/visitr_inflow_legend.json',
			data:{
				"startDate" : ecnmy_trnd_config.selectedDate.start,
				"endDate" : ecnmy_trnd_config.selectedDate.end,
				"ctyCd" : ecnmy_trnd_config.sessionCtyCd,
				"megaCd" : ecnmy_trnd_config.sessionCtyCd.substr(0,2),
				"rgnClss" : "H2"
			},
			success: function(result, status) {
				var vals =[];
				if(result.legend.length > 0){
					for(var i = 1 ; i < 6; i++){
						vals.push(result.legend[0]["max_value"+i].toLocaleString());
					}
				}
				$("#ecnmyTrnd_inflow_legend").empty();
				$("#ecnmyTrnd_inflow_legend").append('<small> 유입지역별 방문객 수 (단위: 명) </small>');
				makeLengend("ecnmyTrnd_inflow_legend",colorArr,vals);
			}
		});
	}
	</script>
</html>
