<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!doctype html>
<html>
	<head>
		<title>choropleth chart 예제</title>
		<meta charset="utf-8" />
		<link rel="stylesheet" type="text/css" href="../lib/Leaflet-1.0.2/leaflet.css" />
		<style>
			html, body { height:100%; overflow:hidden } 
			@import url("//fonts.googleapis.com/earlyaccess/nanumgothic.css");
			body{font-family:'Nanum Gothic',NanumGothic,'Nanum gothic',"Helvetica",verdana,sans-serif;font-size:8px;}	
		</style>
	</head>
	
	<script type="text/javascript" src="../lib/jquery-1.11.2.min.js"></script>
	<script type="text/javascript" src="../lib/Leaflet-1.0.2/leaflet-src.js"></script>
	<script type="text/javascript" src="../lib/d3Chart/d3.js"></script>
	<script type="text/javascript" src="../lib/Leaflet-1.0.2/geostats.js"></script>
	
	<body>
		<div id="viewport" style="width: 100%; height: 100%;"></div>
		
		
		<script type="text/javascript">
	
			var map = L.map('viewport',{
					zoomControl:false
				  , scrollWheelZoom:false
				  ,	zoomAnimation:false
				  ,	fadeAnimation:false
			}).setView([ 37.492334, 127.062444 ],11);
			
			// 지도 드래그 이동 막기
			map.dragging.disable();
			
			// 지도 더블클릭시 zoomIn 막기
			map.doubleClickZoom.disable(); 
			
			// vworld 지도 가져오기 
// 			L.tileLayer( 'http://xdworld.vworld.kr:8080/2d/gray/201512/{z}/{x}/{y}.png',{
			L.tileLayer('http://trend-on.co.kr/xdworld/2d/gray/201411/{z}/{x}/{y}.png',{
				minZoom : 1,
				maxZoom : 19
			}).addTo(map);
			
			// 지도의 도형 기본 스타일 정의
			var featureStyle = {
			    "color": "#ff7800",
			    "weight": 5,
			    "fillOpacity":0.9,
			    "opacity": 0.65
			};
			
			// 주제도 색상 정의
			var colorArr = [ '#2c7bb6', '#abdda4', '#ffffbf','#fdae61', '#d7191c' ];
	
			// map 기본 속성 ( 외부값으로 추가/변경 가능한 속상 배열 )
			var map_config = {
				"layerFid" : "layer",			// layerID
				"choroColumn" : "total_cnt",	// choropleth의 기준 속성값
				"strokeColor" : "#fff"			// 테두리 색상
			};
			
			// 접근 방식에 따라 drawChart() 자동실행
			if(typeof window.callPhantom === 'function'){
	//	 		console.log("phantomjs callback");
			}else{
				$(document).ready(function(){
					drawChart();
				});
			}
			
			/**
			 * phantomjs이용시 차트를 그리기위한 초기 함수
			 * @param options 외부 입력값 객체
			 */
			function drawChart(options) {
			
				//외부 입력값 적용
				if (options) {
					$("body").css("height", options.height + "px");
					$("body").css("width", options.height + "px");
					$("#viewport").css("width", options.width + "px");
					$("#viewport").css("height", options.height + "px");
	
					map_config = $.extend(map_config, options);
					map.invalidateSize();
				}
				getJson();
			}
			
			/*
			 * 데이터를 가져오는 함수
			 */
			function getJson() {
				$.ajax({
					url : "./data.jsp",			
					success: function(result, status) {
						var json = JSON.parse(result);
						var bounds = null;
						data = $.extend(true, {}, json);
						layer = L.geoJSON(data, {
						// 						style : featureStyle
						});
						layer._fid = map_config.layerFid;
						layer.addTo(map);
						bounds = layer.getBounds();
						map.off('moveend', setDocumentTitle);
						map.on('moveend', setDocumentTitle);
						map.fitBounds(bounds);
						doAdmiChoropleth(map_config.choroColumn, layer, colorArr);
						
					}
				});
			}
			
			/**
			 * choropleth 단계구분도 (행정동)
			 * @param colName 	choropleth의 기준 속성값
			 * @param layer		적용할 layer
			 * @param colorArr	choropleth 색상 배열
			 */
			function doAdmiChoropleth(colName, layer, colorArr) {
				var classifyData = new Array();
				var colNameArr = colName;
				for ( var fnum in layer._layers) {
					var colNameCnt = layer._layers[fnum].feature.properties[colNameArr];
					if (colNameCnt != '0') {
						classifyData.push(colNameCnt);
					}
				}
				var serie = new geostats(classifyData);
				var arrNum = serie.getQuantiles(6);
				function style(feature) {
	
					var colNameCnt = feature.properties[colNameArr];
					var cIndex = Number(closeset(colNameCnt, arrNum));
					var colar = colorArr[cIndex];
					return {
						fillColor : colar,
						weight : 1,
						opacity : 1,
						color : map_config.strokeColor,
						fillOpacity : 0.5
					};
				}
				layer.setStyle(style);
			}
			
			/**
			 * 행렬중 입력한 숫자와 가장 근접한 행 찾기
			 * @param num 입력한 수
			 * @param arr 기준 행렬
			 * @returns
			 */
			function closeset(num, arr) {
				var curr = arr[0];
				var index = 0;
	
				for (var i = 0; i < arr.length; i++) {
					if (Math.abs(num - arr[i]) < Math.abs(num - curr)) {
						curr = arr[i];
						index = i;
					}
				}
	
				return arr.indexOf(curr);
			}
	
			/*
			 * zoomend 후 title변경
			 */
			function setDocumentTitle(){
				document.title = 'complete';
			}
		</script>
	</body>
</html>