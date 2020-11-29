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
		<script src="/js/jquery/jquery-ui-draggable.min.js"></script>
		<script src="/js/jquery/jquery.easing.1.3.js"></script>
		<script src="/js/jquery/jquery-ui.js"></script>
		<script src="/js/jquery/jquery.fullpage.min.js"></script>
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
		<div id="wrap">
			<!-- header -->
			<div id="header">
				<h1 class="logo"><a href="/onmap/crfc_main.do"><img src="/images/common/logo.png" alt="logo" /></a></h1>
				<div class="gnb">
						<%@ include file="/WEB-INF/jsp/onmap/main/include/layer_user.jsp" %>
						<c:set var="length" value="${fn:length(userInfo.cty_nm)}" />
						<c:set var="ctyName" value="${userInfo.cty_nm}" />
<%-- 						<c:if test="${length > 2 }"> --%>
<%-- 							<c:set var="ctyName" value="${fn:substring(userInfo.cty_nm,0,(length-1))}" /> --%>
<%-- 						</c:if> --%>
				</div>
				<div id="nav">
					<ul>
						<li class="on"><a href="/onmap/ecnmy_24/main.do">${ctyName} 24시</a></li>
						<li><a href="/onmap/ecnmy_trnd/main.do">경제 트렌드</a></li>
						<li><a href="/onmap/event_effect/main.do">이벤트 효과</a></li>
					</ul>
				</div>
			</div>
			<!-- //header -->

			<hr />

			<!-- contents -->
			<div id="contents">
				<div id="fp-nav2" class="section_top">
<%-- 					<h2 class="tit_top">${ctyName} 24시</h2> --%>
					<h2 class="tit_top">시간대별 소비인구</h2>
					<p class="txt_infor_top">소비인구는 지역경제와 밀접한 소분류 40개 업종을 기준으로 집계함 (백화점, 할인점, 영화관 등 대형업종 제외)</p>
					<div class="article_rgt withExcel">
					
						
						<!-- btn_time -->
						<div class="group_time">
							<ul>
								<li class="total on"><a href="#none">전체</a></li>
								<li class="week_days"><a href="#none">주중</a></li>
								<li class="week_end"><a href="#none">주말</a></li>
							</ul>
						</div>
						<!-- ////btn_time -->
						<div class="excelBtn"><a href="#none" id="downExcel">엑셀다운</a></div>
						<!-- //btn_list -->
					</div>

					<div class="top_graph">
						<!-- 도움말 -->
						<div class="group_help">
							<p>
								조회를 원하시는 시간대에 따라 스크롤을 움직여 보세요.<br/>
								(데이터 기준일자 : <span id="dateWarn"></span>)
							</p>
						</div>
						<!-- //도움말 -->
						<div class="bx_graph" id="time24Chart">
<!-- 							<img src="/images/sub/graph_01.jpg" alt="" /> -->
						</div>
					</div>
				</div>

				<!-- 본문 ==================================================================================================== -->
				<!--  -->
				<div class="contents_body">
					<!--  -->
<!-- 					<div class="regionSelect select_box select_ty1"> -->
<!-- 						<select id="admiSelect"  onchange="javascript:zoomRegion(this.value);"> -->
<!-- 							<option value="" selected>지역을 선택하세요.</option> -->
<!-- 						</select> -->
<!-- 						<span class="tit" id="admiTit">지역을 선택하세요.</span> -->
<!-- 					</div> -->
					<div class="section_map box_pos pos_ty3">
						<div class="select_box select_ty1 regionSelect">
							<select id="admiSelect"  onchange="javascript:zoomRegion(this.value);">
								<option value="" selected>지역을 선택하세요.</option>
							</select>
							<span class="tit" id="admiTit">지역을 선택하세요.</span>
						</div>
						
						<div id="map24">
							<img src="/images/common/icon_reload.png" alt="지도 초기화" title="전체보기" id="ecnmy24_reLoad" class="map_reLoad" onclick="zoomRegion(${userInfo.cty_cd},'init')" />
							
							<div class="chart24">
								<div id="scatterChart"></div>
								<a href="#none" ><img alt="그래프 닫기" src="/images/common/btn_close.png" id="chartClose" class="chartCloseBtn"/></a>
								<a href="#none"><img alt="그래프 열기" title="행정동별 소비인구" src="/images/common/btn_01.png" id="chartOpen" class="chartOpenBtn"/></a>
							</div>
	
							<div id="ecnmy24_legend" class="map legend">
						        <!--
						        <small> 일평균 시간대별 소비자 수 (단위:명) </small>
						         -->
						    </div>
						</div>
					</div>
					<!-- // -->
				</div>
				<!-- // -->
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
		var bDate = new Date("2 dec 2012 0:00:00"),
		    eDate = new Date(bDate.getTime() + 60 * 60 * 24 * 1000 );//new Date("2017-06-01 23:59:59")

		var ecnmy_24_config = {
				serviceClss: '${serviceClss}',
				layerFid : "layer24",
				sessionCtyCd:'${userInfo.cty_cd}',
				selectedDate:'${date}', 				// 최근한달
// 				selectedDate:'201705', 				// 최근한달
				selectedRgnClss:'H4',
				selectedTime:{'x0':6, 'x1':17},		// Default slider 값
				column: 'total_cnt',				// 버튼 값 ( 전체(total_cnt) / 주중(week_days_cnt)  / 주말(week_end_cnt) )
				timeArr : '',
				bDate : bDate,
				eDate : eDate
		};
		var colorArr = [ '#2b83ba',
						 '#64abb0',
						 '#9dd3a7',
						 '#c7e9ad',
						 '#edf8b9',
						 '#ffedaa',
						 '#fec980',
						 '#f99e59',
						 '#e85b3a',
						 '#d7191c' ]

		var timeData = null;
		var data24 = null;
		var layer24 = null;
		var data24_admi = null;
		var layer24_admi = null;
		var initBounds = null;
		var zoomLevel = null;
// 		var initBlkCd = null;
		var map24Legend = null;
		
		//경제24 : 행정동별 고객수
		var map24 = L.map('map24',{ zoomControl:false
			, scrollWheelZoom:true
			, maxZoom:18
			, minZoom:7
			, closePopupOnClick:false
		});
// 		map24.dragging.disable();
		map24.doubleClickZoom.disable();
		new L.Control.Zoom({position:'topright'}).addTo(map24);
// 		L.tileLayer('http://xdworld.vworld.kr:8080/2d/gray/201411/{z}/{x}/{y}.png'
		L.tileLayer('${globalConfig["config.vworld.host"]}/2d/gray/201411/{z}/{x}/{y}.png'
					, {	    attribution : '© Vworld'
						  , minZoom : 1
						  , maxZoom : 19
					}).addTo(map24);

		$(document).ready(function(){
// 			var mapHeight = $(window).height() - $(".section_top").height() - $("#header").height() - $("#footer").height()- 19;
			var mapHeight = $(window).height() - 220 - $("#footer").height();
			$("#map24").css("height", mapHeight);

			// 지도위 selectBox option 변경
			$.ajax({
				type: "GET",
				dataType: 'json',
				url:"/common/area_select_option.json",
				data:{
					"ctyCd" : ecnmy_24_config.sessionCtyCd.substr(0,4),
					"rgnClss" : ecnmy_24_config.selectedRgnClss
				},
				success: function(json) {
					$("#admiSelect").empty();
					
					// 한글 오름차순
					json.sort(function(a, b) { 
						return a.nm < b.nm ? -1 : a.nm > b.nm ? 1 : 0;
					});

					$("#admiSelect").append("<option value='' selected>지역을 선택하세요.</option>");
					for(var i = 0 ; i< json.length; i++){
						var optionHtml = "<option value='"+json[i].id+"'>"+json[i].nm+"</option>";
						$("#admiSelect").append(optionHtml);
					}
				}
			})

			// 지도 - 행정동별 지도 이동을 위한 feature가져오기
			$.ajax({
				type: "GET",
				dataType: 'json',
				url:"/onmap/ecnmy_24/ecnmy_24_admi.json",
				data:{
					"ctyCd" : ecnmy_24_config.sessionCtyCd,
					"rgnClss" : "H4",
				},
				success: function(json) {
					data24_admi = $.extend(true, {}, json);
					layer24_admi = L.geoJSON(data24_admi, {
						        opacity: 0,
						        fillOpacity: 0
					});

					layer24_admi._fid = "layer24_admi";
					layer24_admi.addTo(map24);
				}
			});

			// 경제24  매출액 : amtData  - 지도(블록)
			$.ajax({
				type: "GET",
				dataType: 'json',
				url:"/onmap/ecnmy_24/ecnmy_24_block.json",
				data:{
					"ctyCd" : ecnmy_24_config.sessionCtyCd,
					"date" : ecnmy_24_config.selectedDate,
					"rgnClss" : ecnmy_24_config.selectedRgnClss,
				},
				success: function(json) {
					data24 = $.extend(true, {}, json);

					layer24 = L.geoJSON(data24, {
						        opacity: 0,
						        fillOpacity: 0
					    }).bindPopup(L.popup({closeButton:false,autoPan:false}));

					layer24._fid = "layer24";
					layer24.addTo(map24);
					
					var bounds = layer24.getBounds();
					initBounds = layer24.getBounds();
					map24.fitBounds(bounds);

					zoomLevel = map24.getZoom();
					map24.setZoom(zoomLevel+1);

					layer24.on('mouseover',function(e){
		            	(function(layer, properties) {
		            		if(layer.options.color == "#2B83BA") return;
		            		// 마우스 오버시 지역 테두리 변경
		        			layer.setStyle({
		        				fillColor: layer.options.fillColor,
		        				weight: 5,
		        				opacity: 1,
		        				color: '#2B83BA',
		        				dashArray: '1',
		        				fillOpacity: layer.options.fillOpacity
		        			});	
		        			layer.bringToFront();

		            		//popup
		            		var period = $('.group_time li.on').text();
		            		var periodCd = $('.group_time li.on').attr("class").replace("on","").trim();

		            		//popup의 기간 값 설정
		            		if(periodCd == "total"){
		            			period += " (주중, 주말 포함)";
		            		}else if(periodCd == "week_days"){
		            			period += " (월요일 ~ 금요일)";
		            		}else if(periodCd == "week_end"){
		            			period += " (토요일 ~ 일요일)";
		            		}

		            		//popup의 소비인구 수 범위 설정
		            		var memCnt =  layer.feature.properties[periodCd+"_cnt"];
		            		if(map24Legend){
		            			if(map24Legend[map24Legend.length-1] <= memCnt){
		            				memCnt = map24Legend[map24Legend.length-1]+"명 이상"
		            			}else{		            				
		            				for(var i = 0 ; i < map24Legend.length; i++){
		            					if(map24Legend[i] > memCnt){
		            						if(i == 0){
		            							memCnt = map24Legend[i]+"명 미만";
		            						}else{	            							
			            						memCnt = map24Legend[i-1] +"명 ~ "+ map24Legend[i]+"명";
		            						}
			            					break;
		            					}
		            				}
		            			}
		            		}
		            		
		            		var popupData = [
		            		                 {"name":"기간", "value":period},
		            		                 {"name":"시간", "value":ecnmy_24_config.selectedTime.x0+"시 ~ "+ecnmy_24_config.selectedTime.x1+"시"},
// 		            		                 {"name":"소비인구 수", "value":layer.feature.properties[periodCd+"_cnt"]+"명"}
		            		                 {"name":"소비인구 수", "value":memCnt}
		            		                ];
		            		var title = {"value":"소비인구 수","color":"#333"};

		            		layer24.setPopupContent(getMapTooltip(popupData,title));
	            			layer24.openPopup(e.latlng);
	            			
		            	})(e.layer, e.properties);
					});
					
					layer24.on('mouseout',function(e){
		            	(function(layer, properties) {
		            		if(layer.options.color == "#fff") return;
		            		
		            		layer.setStyle({
		        				fillColor: layer.options.fillColor,
		        				weight: 1,
		        				opacity: 1,
		        				color: '#fff',
		        				dashArray: 1,
		        				fillOpacity: layer.options.fillOpacity
		        			});	
		            		layer24.closePopup();
		            		
		            		for(var ff in map24._layers){
		            			if(map24._layers[ff].feature_id && map24._layers[ff].feature_id.indexOf("ecnmy24_admi_polygon_") != -1){
		            				map24._layers[ff].bringToFront();
		            			}
		            		}
		            		
		            	})(e.layer, e.properties);
					});


					// 경제24 매출액 지도 주제도
					map24Cholopleth('',"total_cnt");
				}
			});

			// 상단의 시간에따른 소비인구수 그래프 데이터 가져오기
			// Data를 가져와서 topTimeGraph를 처음으로 호출하는 부분
			setTimeZonGraph();
			
			// 지도위의 그래프 그리기
			mapGraphData('','total_cnt');

			// 안내메세지 숨기기
			$(".group_help").click(function(){
				$(".group_help").css("display","none");	
			});
			
			// 주중, 주말, 전체 선택 버튼 클릭 이벤트
			$('.group_time li').click(function(){
				if($(this).hasClass('on')) return;

				//안내메시지 숨기기
				$(".group_help").css("display","none");
				
				// 버튼 색상 변경
				$('.group_time li').removeClass("on");
				var gubun = $(this).attr('class');
				$(this).addClass("on");

				var timeArr = "'1','2','3'";
				var selectedTime = {'x0':new Date(bDate).addHours(ecnmy_24_config.selectedTime.x0), 'x1':new Date(bDate).addHours(ecnmy_24_config.selectedTime.x1)};
				topTimeGraph(timeData, gubun+"_cnt", selectedTime);
				map24Cholopleth('',gubun+"_cnt");
				mapGraphData(timeArr, gubun+"_cnt");
			});
			
			// 그래프 숨기기
			$("#chartClose").click(function(){
				$("#scatterChart").hide('fold',700);
				$("#chartClose").hide();
				$("#chartOpen").show();
			});
			
			// 그래프 열기
			$("#chartOpen").click(function(){
				$("#scatterChart").show('fold',700,function(){
					// 그래프 다시그리기.
					mapGraphData(ecnmy_24_config.timeArr,ecnmy_24_config.column);
				});
				$("#chartClose").show();
				$("#chartOpen").hide();
			});
			
			// 엑셀 다운로드 
			$("#downExcel").click(function(){
				$.ajax({
					url:'/onmap/ecnmy_24/makeExcel.json',
					type:"POST",
					data:{
						"ctyCd" : ecnmy_24_config.sessionCtyCd,
						"ctyNm" : "${userInfo.cty_nm}",
						"date" : ecnmy_24_config.selectedDate
					},
					cache:false,
					success: function(data){
						fileDown(data.oriFileName, data.fileName, "Y");
					}
				});
				
				
			});

		});
		function setTimeZonGraph(){
			$.ajax({
				type: "GET",
				dataType: 'json',
				url:"/onmap/ecnmy_24/timeGraph.json",
				data:{
					"ctyCd" : ecnmy_24_config.sessionCtyCd,
					"date" : ecnmy_24_config.selectedDate,
					"rgnClss" : ecnmy_24_config.selectedRgnClss,
				},
				success: function(json) {
					// 스크롤 관련 팝업 날짜 입력
					$("#dateWarn").text(ecnmy_24_config.selectedDate.substr(0,4) + "년 " + ecnmy_24_config.selectedDate.substr(4,2) + "월");
					
					// 가장 최근 데이터값을 result 값에서 찾아서 전역변수에 담는다.
// 					ecnmy_24_config.selectedDate = json.date;
					
					// result 값중 시간당 소비인구수의 변화 데이터를 전역변수에 담는다.
					timeData = json.timeGraph;
					var selectedTime = {'x0':new Date(bDate).addHours(ecnmy_24_config.selectedTime.x0), 'x1':new Date(bDate).addHours(ecnmy_24_config.selectedTime.x1)};
					// 시간당 소비인구수의 변화 그래프 그리기
					topTimeGraph(json.timeGraph,"total_cnt",selectedTime);
				}
			});
		}
	</script>
	<script src="/js/trendOn/ecnmy_24.js?ver=${globalConfig['config.version']}"></script>
</html>