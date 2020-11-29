<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!doctype html>
<html>
<head>
<title>지역경제 모니터링</title>
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
		    "color": "#ffffff",
		    "weight": 5,
		    "fillOpacity":0.9,
		    "opacity": 0.65
		};
		
		
// 		map24.dragging.disable();
		map24.doubleClickZoom.disable(); 
		
		$(".leaflet-control-attribution.leaflet-control").hide();
		
 		L.tileLayer( 'http://xdworld.vworld.kr:8080/2d/gray/201512/{z}/{x}/{y}.png',{
//		L.tileLayer('http://trend-on.co.kr/xdworld/2d/gray/201411/{z}/{x}/{y}.png',{
// 		L.tileLayer('http://map1.daumcdn.net/map_2d_hd/1711nov/{z}/{x}/{y}.png',{
			minZoom : 1,
			maxZoom : 19
		}).addTo(map24);
		
		var colorMap = {
			"colorArr" : [ '#2c7bb6', '#abdda4', '#ffffbf','#fdae61', '#d7191c' ],
			"colorArr_float" : [ '#E0F5F6', '#78D6D7', '#00B7B6','#007A74', '#083A38' ],
			"colorArr_amt" : [ '#FAEAE9', '#FDAE9C', '#FF7558','#C03C25', '#67000D' ],
			"colorList" : [
	            [ '#d7191c'],
	            [ '#fdae61', '#d7191c'],
	            [ '#ffffbf', '#fdae61', '#d7191c'],
	            [ '#abdda4', '#ffffbf', '#fdae61', '#d7191c'],
	            [ '#2c7bb6', '#abdda4', '#ffffbf','#fdae61', '#d7191c'],
	            [ '#2c7bb6', '#abdda4', '#ffffbf','#fdae61', '#d7191c'],
	            [ '#2c7bb6', '#abdda4', '#ffffbf','#fdae61', '#d7191c', '#d7191c']
            ],
			"colorList_float" : [
				[ '#00b7b6'],
		        [ '#78d6d7', '#00b7b6'],
		        [ '#78d6d7', '#00b7b6', '#007a74'],
		        [ '#e0f5f6', '#78d6d7', '#007a74', '#083a38'],
		        [ '#e0f5f6', '#78d6d7', '#00b7b6', '#007a74', '#083a38'],
				[ '#E0F5F6', '#78D6D7', '#00B7B6','#007A74', '#083A38', '#083A38'],
	            [ '#E0F5F6', '#78D6D7', '#00B7B6','#007A74', '#083A38', '#083A38']
            ],
			"colorList_amt" : [
				[ '#ff5c3c'],
		        [ '#fe8e75', '#ff5c3c'],
		        [ '#fe8e75', '#ff5c3c', '#c03c25'],
		        [ '#fecec2', '#fe8e75', '#c03c25', '#67000d'],
		        [ '#fecec2', '#fe8e75', '#ff5c3c', '#c03c25', '#67000d'],
	            [ '#FAEAE9', '#FDAE9C', '#FF7558','#C03C25', '#67000D', '#67000D'],
	            [ '#FAEAE9', '#FDAE9C', '#FF7558','#C03C25', '#67000D', '#67000D']
            ]
		}

		
		
		var map_config = {
				"layerFid" : "layer24",
				"selectedRgnClss" : "H3",    	  // H4		// H2
				"ctyCd" : "47170",
// 				"admiCd" : "47170650",
//	 			"h3Cd" : "31170",
				"dataId" : "rpt-new-trnd",         	// rpt-trnd			rpt-trnd			rpt-trnd           rpt-evntEff
				"pageId" : "rpt-new-trnd-018-001", 	//rpt-trnd-006-003 	rpt-trnd-009-004  rpt-trnd-010-004   rpt-evntEff-010-003
				"choroColumn" : "rate",				//tot_sale_amt	 rate              sale_amt           rate
				"strokeColor" : "#fff",
// 	 			"ctyAll" : "ALL",
// 	  			"zoomable" :true,
				"startDate" : "20200612",
				"endDate" : "20200615",
				"gubun" : "",
				"opacity":0.5,
				"defaultColor": "#2c7bb6" // null일때 사용할  컬러
// 				"lastStartDate" : "20200601",
// 				"lastEndDate" : "20200605",
// 				"admiAround" : "'47170250','47170360','47170600','47170620','47170660','47170690'"
				
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

// 			console.log(data);
			for ( var dt in data) {
				for ( var l in fLayer._layers) {
					var feature = fLayer._layers[l].feature;
					if (feature.properties.id == data[dt].id) {
						feature.properties = $.extend(feature.properties, data[dt]);
					}
				}
			}
			return fLayer
		}

		/**
		 * 하나만 선택했을때의 단계구분도 (행정동)
		 */
		function doAdmiChoropleth(colName, layer) {
// 			console.log(colName, layer);
			var colorArr = [];
			var classifyData = new Array();
			for ( var fnum in layer._layers) {
				var colNameCnt = layer._layers[fnum].feature.properties[colName];
				if (colNameCnt !== undefined) {
					classifyData.push(colNameCnt);
				}
			}
			// data들중 중복된 값 제외.
			var arrNum = classifyData.reduce(function(a,b){
				if (a.indexOf(b) < 0 ) a.push(b);
				return a;
			  },[]);
			
			
			// 주제도 단계 설정
			var num = 6;
// 			var serie = new geostats(classifyData);
			var serie = new geostats(arrNum);
			
			// data들중 중복된 값을 제외한 배열의 갯수가 주제도 단계값보다 작으면 
			// data들중 중복된 값을 제외한 배열을 단계기준값으로 사용.
			if(arrNum.length <= (num-1)){
// 				if(arrNum.length == 1){
// 					arrNum.push((arrNum[0]-1));
// 				}
				// data들중 중복된 값을 제외한 배열의 값을 크기순으로 정렬.
				arrNum.sort(function(a, b){
					return a - b;
				});
				// 색상코드값도 배열의 갯수와 같은 색상배열로 선택
				colorArr = colorMap["colorList"+map_config.gubun][(arrNum.length-1)];
			}else{
				arrNum = serie.getQuantiles(num);
			}
			
			function style(feature) {
				
				var colNameCnt = feature.properties[colName];
				if(map_config.ctyAll == 'ALL' && colNameCnt === undefined) {		// 유입인구 유입지역에서 값이 null이면 파란색으로
					
					if(map_config.ctyCd && map_config.ctyCd.indexOf(feature.properties.id) == 0){	// 선택한 지역이면
						return {
							fillColor: colorMap["colorArr"+map_config.gubun][0],
							weight: 5,
							opacity: 1,
							color: '#333',
							dashArray: '1',
							fillOpacity: 0
						};
					}else{
						return {
							fillColor:  colorMap["colorArr"+map_config.gubun][0],
							weight: 1,
							opacity: 1,
							color: '#fff',
							dashArray: '1',
							fillOpacity: map_config['opacity']
						};
					}
				}
				
				var cIndex = Number(closeset(colNameCnt, arrNum));
				var colar = colorMap["colorArr"+map_config.gubun][cIndex];
				if(colorArr.length > 0) colar = colorArr[cIndex]
				
				if(feature.properties.id == '27230'){
					console.log(colar);
				}
				
				if(map_config.ctyAll && map_config.ctyCd.indexOf(feature.properties.id) == 0){
					return {
						weight : 2,
						opacity : 1,
						color : "#000000",
						fillOpacity : 0
					};
				}else{
					return {
						fillColor : colar,
						weight : 1,
						opacity : 1,
						color : map_config.strokeColor,
						fillOpacity : map_config['opacity']
					};
				}
				
			}
			layer.setStyle(style);
			
			// 해당시군구 항상 맨 위로 오게
			if(map_config.ctyAll){		
				for(var ll in layer._layers){
					if(map_config.ctyCd.indexOf(layer._layers[ll].feature.properties.id) == 0){
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
				url : "/onmap/public/ecnmy_trnd/getTrndMap.json",
				async : false,
				data : {
					"ctyCd" : map_config.ctyAll || map_config.ctyCd,
					"rgnClss" : map_config.selectedRgnClss
				},
				success : function(json) {
					
					var bounds = null;
					
					data24 = $.extend(true, {}, json);
					layer24 = L.geoJSON(data24, {
					// style : featureStyle
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
					makeLengend(colorMap["colorArr"+map_config.gubun])
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
							"h3Cd" : map_config.ctyCd,
							"ctyCd" : map_config.ctyCd,
							"admiCd" : map_config.admiCd,
							"startDate" : map_config.startDate,
							"endDate" : map_config.endDate,
							"lastStartDate" : map_config.lastStartDate,
							"lastEndDate" : map_config.lastEndDate
						},
						success : function(json) {
							var propertiesData = json[map_config.pageId];
							console.log(propertiesData);
							var mapLayer = matchFeature(map24, propertiesData,
									map_config.layerFid);
							doAdmiChoropleth(map_config.choroColumn, mapLayer);
							
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