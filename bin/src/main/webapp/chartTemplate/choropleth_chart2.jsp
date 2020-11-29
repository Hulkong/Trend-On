<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!doctype html>
<html>
<head>
<title>지역경제 모니터링(이벤트-행정동과 인접한 행정동)</title>
<meta charset="utf-8" />
<link rel="stylesheet" href="/js/Leaflet-1.0.2/leaflet.css" />
<script type="text/javascript" src="/js/Leaflet-1.0.2/leaflet-src.js"></script>
<script src="/js/jquery/jquery-1.11.2.min.js"></script>
<script src="/js/d3Chart/d3.js"></script>
<script src="/js/Leaflet-1.0.2/geostats.js"></script>
<style>
@import url("//fonts.googleapis.com/earlyaccess/nanumgothic.css");
body{font-family:'Nanum Gothic',NanumGothic,'Nanum gothic',"Helvetica",verdana,sans-serif;font-size:8px;}
		
ul {margin:0; padding:0;}
#mapLegend {position:absolute; z-index:500; width:80px; background-color:rgba(255, 255, 255, .5); bottom:10px; right:15px; padding-top:5px; padding-left:3px; padding-right:3px;}
.map.legend ul li.key {border-top-width: 5px; border-top-style: solid; width: 20%; height:9.8px; padding-bottom:2px; padding-left: 0; padding-right: 0; display:inline-block; vertical-align:top;}
</style>
</head>
<body>
	<div id="viewport" style="width: 500px; height: 500px;">
		<div id="mapLegend"  class="map legend"></div>
	</div>
	<script type="text/javascript">
	
		var map24 = L.map('viewport',{
			zoomAnimation:false,
			fadeAnimation:false,
			zoomControl:false
		}).setView([ 37.492334, 127.062444 ],11);
		
		
		
		var featureStyle = {
		    "color": "#ff7800",
		    "weight": 5,
		    "fillOpacity":0.9,
		    "opacity": 0.65
		};
		
		
		map24.dragging.disable();
		map24.doubleClickZoom.disable(); 
		
		$(".leaflet-control-attribution.leaflet-control").hide();
		
// 		L.tileLayer( 'http://xdworld.vworld.kr:8080/2d/gray/201512/{z}/{x}/{y}.png',{
		L.tileLayer('http://trend-on.co.kr/xdworld/2d/gray/201411/{z}/{x}/{y}.png',{
// 		L.tileLayer('http://map1.daumcdn.net/map_2d_hd/1711nov/{z}/{x}/{y}.png',{
			minZoom : 1,
			maxZoom : 19
		}).addTo(map24);
		
		var colorArr = [ '#2c7bb6', '#abdda4', '#ffffbf','#fdae61', '#d7191c' ];

		var map_config = {   
			"layerFid" : "layer24",
			"selectedRgnClss" : "H4",
			"ctyCd" : "31170",
			"dataId" : "rpt-evntEff",
			"pageId" : "rpt-evntEff-010-003",
			"choroColumn" : "rate",
			"strokeColor" : "#fff",
// 			"ctyAll" : "ALL",
// 			"zoomable" :true,
// 			"admiAround" : "'31170560','31170530','31170510','31170540','31170550'",
// 			"admiAround" : "'11680655','11680690','11680600','11680656','11680670'",
// "admiAround" : "'11680590','11680521','11680510','11680545','11680565','11680640'", 
// "admiCd" : "31170520",
			"startDate" : "20170816",
			"endDate" : "20171009"
		};
		
		function drawChart(options) {

			if (options) {
				$("#viewport").css("width", options.width + "px");
				$("#viewport").css("height", options.height + "px");

				map_config = $.extend(map_config, options);
				map24.invalidateSize();
				getVector();
			}else{
				getVector();
			}

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
		function getLayerByFid(fid, map) {
			for ( var l in map._layers) {
				if (map._layers[l]._fid == fid) {
					return map._layers[l];
				}
			}
		}
		function matchFeature(map, data, fid) {
			var fLayer = getLayerByFid(fid, map);
			for ( var l in fLayer._layers) {
				var feature = fLayer._layers[l].feature;
				var tempData = {};
				tempData[map_config.choroColumn] = 0;
				feature.properties = $.extend(feature.properties, tempData);
			}

			for ( var dt in data) {
				for ( var l in fLayer._layers) {
					var feature = fLayer._layers[l].feature;
					if (feature.properties.id == data[dt].id) {
						feature.properties = $.extend(feature.properties,
								data[dt]);
					}
				}
			}
			
			return fLayer
		}

		/**
		 * 하나만 선택했을때의 단계구분도 (행정동)
		 */
		function doAdmiChoropleth(colName, layer, colorArr) {
			var colorList = [
			                 [ '#2c7bb6', '#d7191c'],
			                 [ '#2c7bb6', '#d7191c'],
			                 [ '#2c7bb6', '#ffffbf', '#d7191c'],
			                 [ '#2c7bb6', '#ffffbf','#fdae61', '#d7191c'],
			                 [ '#2c7bb6', '#abdda4', '#ffffbf','#fdae61', '#d7191c' ]
			];
			
			var classifyData = new Array();
			var useLayerArr = [];
			var colNameArr = colName;
			for ( var fnum in layer._layers) {
				var colNameCnt = layer._layers[fnum].feature.properties[colNameArr];
				if(colNameCnt !== undefined){			
					classifyData.push(colNameCnt);
					
					// config에 zoomlevel을 위한 layer 저장
					useLayerArr.push(layer._layers[fnum]);
				}
			}

			// data들중 중복된 값 제외.
			var arrNum = classifyData.reduce(function(a,b){
				if (a.indexOf(b) < 0 ) a.push(b);
				return a;
			  },[]);
			
			// 주제도 단계 설정
			var num = 6;
			var serie = new geostats(classifyData);
//			var arrNum = serie.getQuantiles(6);
			
			// data들중 중복된 값을 제외한 배열의 갯수가 주제도 단계값보다 작으면 
			// data들중 중복된 값을 제외한 배열을 단계기준값으로 사용.
			if(arrNum.length <= (num-1)){
				if(arrNum.length == 1){
					arrNum.push((arrNum[0]-1));
				}
				// data들중 중복된 값을 제외한 배열의 값을 크기순으로 정렬.
				arrNum.sort(function(a, b){
					return a - b;
				});
				// 색상코드값도 배열의 갯수와 같은 색상배열로 선택
				colorArr = colorList[(arrNum.length-1)];
			}else{
				arrNum = serie.getQuantiles(num);
			}
			
// 			var serie = new geostats(classifyData);
// 			var arrNum = serie.getQuantiles(6);

			function style(feature) {

				var colNameCnt = feature.properties[colNameArr];
				if(colNameCnt === undefined){
					return {
						fillColor: colorArr[0],
						weight: 1,
						opacity: 1,
						color: '#fff',
						dashArray: '1',
						fillOpacity: 0.5
					};	
				}
				var cIndex = Number(closeset(colNameCnt, arrNum));
				var colar = colorArr[cIndex];
				
				if(map_config.admiCd && map_config.admiCd == feature.properties.id){
					return {
						fillColor : colar,
						weight : 2,
						opacity : 1,
						color : "#000000",
						fillOpacity : 0.5
					};
				}else{
					return {
						fillColor : colar,
						weight : 1,
						opacity : 1,
						color : map_config.strokeColor,
						fillOpacity : 0.5
					};	
				}
				
			}
			layer.setStyle(style);
			
			// 해당시군구 항상 맨 위로 오게
			if(map_config.admiCd){		
				for(var ll in layer._layers){
					if(layer._layers[ll].feature.properties.id == map_config.admiCd){
						layer._layers[ll].bringToFront();
					}
				}
			}
		}
		/*
		 * 형상 데이터는 동기로 
		 */
		function getVector() {
			$.ajax({
				type : "GET",
				dataType : 'json',
				url : "/onmap/public/event_effect/getEventMap.json",
				async : false,
				data : {
					"ctyCd" : map_config.ctyAll || map_config.ctyCd,
					"admiCd" : map_config.admiCd,
					"admiAround" : map_config.admiAround,
					"rgnClss" : map_config.selectedRgnClss
				},
				success : function(json) {
					var bounds = null;
					
					data24 = $.extend(true, {}, json);
					layer24 = L.geoJSON(data24, {
					// 						style : featureStyle
					});
					layer24._fid = map_config.layerFid;
					layer24.addTo(map24);
					bounds = layer24.getBounds();
					
					if(map_config.zoomable){
						var megaCd = map_config.ctyCd.substr(0,2);
						var megaLayer = null;
						var megaData = $.extend(true, {}, json);
						megaData.features = [];
						for(var ff in json.features){
							if(json.features[ff].properties.id.indexOf(megaCd) == 0){
								megaData.features.push(json.features[ff]);
							}
						}
						megaLayer = L.geoJSON(megaData, {
							style : {
								opacity : 0,
								fillOpacity : 0
							}
						});
						megaLayer._fid = "magaBound";
						megaLayer.addTo(map24);
						bounds = megaLayer.getBounds();
					}
					map24.off('moveend', getProperties);
					map24.on('moveend', getProperties);
					map24.fitBounds(bounds);
					//setTimeout( getProperties,200);
					makeLengend(colorArr)
				}
			});
		}
		/*
		속성 데이터는 비동기로
		 */
		function getProperties() {
			$.ajax({
						type : "GET",
						dataType : 'json',
						url : "/onmap/public/ecnmy_trnd/pdf/data_root.json",
						data : {
							"dataId" : map_config.dataId,
							"admiCd" : map_config.admiCd,
							"admiAround" : map_config.admiAround,
							"h3Cd" : map_config.ctyCd,
							"ctyCd" : map_config.ctyCd,
							"startDate" : map_config.startDate,
							"endDate" : map_config.endDate,
							"lastStartDate" : map_config.lastStartDate,
							"lastEndDate" : map_config.lastEndDate
						},
						success : function(json) {
							var propertiesData = json[map_config.pageId];
							var mapLayer = matchFeature(map24, propertiesData,
									map_config.layerFid);
							doAdmiChoropleth(map_config.choroColumn, mapLayer,
									colorArr);
							
							setTimeout( function(){
								document.title = 'complete';
							},300);
						}
					});
		}
		
		/**
		 * 지도 범례 
		 */
		function makeLengend(colorVal){
			var colors = d3.scale.quantize().range(colorVal);
			var legend = d3.select('#mapLegend').append('ul').attr('class', 'list-inline');
		    var keys = legend.selectAll('li.key').data(colors.range());
		    var liWidth = 100/(colorVal.length);
		    
		    keys.enter().append('li')
					    .attr('class', 'key')
					    .style({'border-top-color' : String, 'width':liWidth+'%', 'font-size' : '8px'})
					    .text(function(d,i) {
					    	var result = " ";
					    	if(i == 0){
					    		result = "적음";
					    	}else if(i == 4){
					    		result = "많음";			    		
					    	}
					        var r = colors.invertExtent(d);
					        return result;
					    });
		}

	</script>
</body>
</html>