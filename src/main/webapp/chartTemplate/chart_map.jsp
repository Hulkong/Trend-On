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
</head>
<body>
	<div id="viewport" style="width: 500px; height: 500px;"></div>
	<script type="text/javascript">
	
		var map24 = L.map('viewport',{
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
		L.tileLayer( 'http://xdworld.vworld.kr:8080/2d/Base/201612/{z}/{x}/{y}.png',{
			minZoom : 1,
			maxZoom : 19
		}).addTo(map24);
		

		var map_config = {
			layerFid : "layer24",
			ctyCd : '4127',
			selectedRgnClss : 'H4'
		};
		function matchFeature(map, data, fid) {
			var fLayer = getLayerByFid(fid, map);
			for ( var dt in data) {
				for ( var l in fLayer._layers) {
					var feature = fLayer._layers[l].feature;
					if (feature.properties.id == data[dt].id) {
						feature.properties = $.extend(feature.properties,data[dt]);
					}
				}
			}
			return fLayer
		}
		function drawChart(options) {

			if (options) {
				$("#viewport").css("width", options.width + "px");
				$("#viewport").css("height", options.height + "px");

				featureStyle.color = options.color;
				featureStyle.weight = options.weight;
				featureStyle.opacity = options.opacity;
				featureStyle.fillOpacity = options.fillOpacity;

				map_config.ctyCd = options.ctyCd;
				map24.invalidateSize();
			}
			getVector();
		}

		function getVector() {

			$.ajax({
				type : "GET",
				dataType : 'json',
				url : "/onmap/public/ecnmy_trnd/getTrndMap.json",
				data : {
					"ctyCd" : map_config.ctyCd,
					"date" : map_config.selectedDate,
					"rgnClss" : map_config.selectedRgnClss,
				},
				success : function(json) {
					data24 = $.extend(true, {}, json);
					layer24 = L.geoJSON(data24, {
						style : featureStyle
					});
					layer24._fid = map_config.layerFid;
					layer24.addTo(map24);
					var bounds = layer24.getBounds();
					map24.fitBounds(bounds);
					document.title = 'complete';
				}
			});
		}
	</script>
</body>
</html>