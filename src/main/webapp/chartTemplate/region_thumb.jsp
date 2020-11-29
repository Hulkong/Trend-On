<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%><!doctype html>
<html>
<head>
<title>지역경제 모니터링</title>
<meta charset="utf-8" />
<link rel="stylesheet" href="/js/Leaflet-1.0.2/leaflet.css" />
<script type="text/javascript" src="/js/Leaflet-1.0.2/leaflet-src.js"></script>
<script src="/js/jquery/jquery-1.11.2.min.js"></script>
<script src="/js/Leaflet-1.0.2/geostats.js"></script>
</head>
<body>
	<div id="viewport" style="width: 500px; height: 500px;"></div>
	<script type="text/javascript">
		var fullUrl = location.protocol+'//'+location.hostname+( (location.port)  ? ":"+location.port : '' );;
		var map24 = L.map('viewport',{
			zoomAnimation:false,
			fadeAnimation:false,
			zoomControl:false
		}).setView([ 37.492334, 127.062444 ],11);
		
		
		
		var featureStyle = {
		    "color": "#ff0000",
		    "weight": 1,
		    "fillOpacity":0.0,
		    "opacity": 1
		};
		
		
		map24.dragging.disable();
		map24.doubleClickZoom.disable(); 
		
		$(".leaflet-control-attribution.leaflet-control").hide();
 		L.tileLayer( 'http://xdworld.vworld.kr:8080/2d/gray/201512/{z}/{x}/{y}.png',{
//		L.tileLayer('http://trend-on.co.kr/xdworld/2d/gray/201411/{z}/{x}/{y}.png',{
			minZoom : 1,
			maxZoom : 19
		}).addTo(map24);
		

		var map_config = {
			layerFid : "layer24",
			ctyCd : '42760',
// 			admiCd : '42760340',
			color : '#ff0000',
			fillOpacity : 0.0,
			selectedRgnClss : 'H4'
		};
		function matchFeature(map, data, fid) {
			var fLayer = getLayerByFid(fid, map);
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

		function drawChart(options) {
// 			options = {ctyCd:42760,admiCd:42760340,"color":"#ff0000","weight":1,"fillOpacity":0.0,"opacity":1}
			if (options) {
				$("#viewport").css("width", options.width + "px");
				$("#viewport").css("height", options.height + "px");

				featureStyle.color = options.color;
				featureStyle.weight = options.weight;
				featureStyle.opacity = options.opacity;
				featureStyle.fillOpacity = options.fillOpacity;

				map_config.fillOpacity = options.fillOpacity;
				map_config.ctyCd = options.ctyCd;
				if(options.admiCd) map_config.admiCd = options.admiCd;
				map24.invalidateSize();
			}
			getVector();
		}

		function getVector() {

			$.ajax({
				type : "GET",
				dataType : 'json',
				url : fullUrl+"/onmap/public/ecnmy_trnd/getTrndMap.json",
				data : {
					"ctyCd" : map_config.ctyCd,
					"date" : map_config.selectedDate,
					"rgnClss" : map_config.selectedRgnClss,
				},
				success : function(json) {
					data24 = $.extend(true, {}, json);
					layer24 = L.geoJSON(data24, {
						style : function(l){
							if(map_config.admiCd && map_config.admiCd == l.properties.id){
								featureStyle.fillColor = "#d7191c";
								featureStyle.fillOpacity = 0.5;
								featureStyle.weight = 3;
							}else{
								featureStyle.fillOpacity = map_config.fillOpacity;
								featureStyle.weight = 1;
								
							}
							
							return featureStyle
						}
					});
					layer24._fid = map_config.layerFid;
					layer24.addTo(map24);
					var bounds = layer24.getBounds();

					map24.off('moveend', setDocumentTitle);
					map24.on('moveend', setDocumentTitle);


					map24.fitBounds(bounds);
				},
				error:function(request,status,error){
    				console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
   				}


			});
		}
		/*
		 * zoomend 후 title변경
		 */
		function setDocumentTitle(){
// 			document.title = 'complete';
			setTimeout(function(){
				document.title = 'complete';
			},200);
			
		}
	</script>
</body>
</html>