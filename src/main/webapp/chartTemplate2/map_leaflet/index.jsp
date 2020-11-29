<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!doctype html>
<html>
	<head>
		<title>leaflet TMS 예제</title>
		<meta charset="utf-8" />
		<style>
			html, body { height:100%; overflow:hidden }
	 		@import url("//fonts.googleapis.com/earlyaccess/nanumgothic.css");
			body{font-family:'Nanum Gothic',NanumGothic,'Nanum gothic',"Helvetica",verdana,sans-serif;font-size:10px;}
			#pickMap {position:fixed; width:150px; height:30px; z-index:401; margin:20px; top:0; right:0; border-radius: 2px;}
		</style>
	    <link rel="stylesheet" type="text/css" href="../lib/Leaflet-1.0.2/leaflet.css" />
	    <script src="../lib/jquery-1.11.2.min.js"></script>
	    <script type="text/javascript" src="../lib/Leaflet-1.0.2/leaflet-src.js"></script>
	    <script type="text/javascript" src="../lib/Proj4/proj4-compressed.js"></script>
	    <script type="text/javascript" src="../lib/Proj4/proj4leaflet.js"></script>
	</head>
	<body>
		<div id="viewArea" style="width:100%;height:100%;">
			<div id="viewport" style="width:100%;height:100%;"></div>
			
			<select id="pickMap" name="pickMap" onChange="changeMap(this.value)">
				<option value="">지도를 선택해주세요.</option>
			</select>
		</div>
		
		<script type="text/javascript">
			var map;
    		var tmsInfos = {
    				daum: {
    		               srs: "EPSG:5181",
    		               proj: "+proj=tmerc +lat_0=38 +lon_0=127 +k=1 +x_0=200000 +y_0=500000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs",
    		               tileSize: 256,
    		//                extent: [-30000, -60000, 494288, 988576],
    					   bounds : L.bounds([-30000, -60000], [494288, 988576]),
    		               resolutions: [2048, 1024, 512, 256, 128, 64, 32, 16, 8, 4, 2, 1, 0.5, 0.25],
    		               origin: [-30000, -60000],
    		               zoomReverse : true,
    		               zoomOffset : 1,
    		               doTms: true,
    		               tileUrl: 'http://map{s}.daumcdn.net/map_2d/1712dec/L{z}/{y}/{x}.png'
    		         },
    		         naver: {
    		            	srs : "EPSG:5179",
    		            	proj : "+proj=tmerc +lat_0=38 +lon_0=127.5 +k=0.9996 +x_0=1000000 +y_0=2000000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +axis=neu +no_defs",
    		            	tileSize : 256,
//    	 	            	extent: [90112, 1192896, 1990673, 2761664],
    		            	bounds : L.bounds([90112, 1192896], [1990673, 2761664]),
    		            	resolutions: [4096, 2048, 1024, 512, 256, 128, 64, 32, 16, 8, 4, 2, 1, 0.5, 0.25],
    		            	origin: [90112, 1192896],
    		            	zoomReverse : false,
    		            	zoomOffset : 0,
    		            	doTms: true,
    		            	tileUrl: "https://simg.pstatic.net/onetile/get/184/0/0/{z}/{x}/{y}/bl_vc_bg/ol_vc_an"
    		         },
    		         vworldBase: {
    		            	srs: "EPSG:3857",
    		            	tileSize: 256,
    		            	zoomReverse : false,
    		            	zoomOffset : 0,
    		            	doTms:false,
    		            	tileUrl : "http://xdworld.vworld.kr:8080/2d/Base/201411/{z}/{x}/{y}.png"
    		         },
    		         vworldGray: {
    		            	srs: "EPSG:3857",
    		            	tileSize: 256,
    		            	zoomReverse : false,
    		            	zoomOffset : 0,
    		            	doTms:false,
    		            	tileUrl : "http://xdworld.vworld.kr:8080/2d/gray/201512/{z}/{x}/{y}.png"
    			   	 }
           };
		
		
    		// tmsInfos에서 가져온 정보로 crs
    		function getTmsCrs(name){
    	   		var crs = new L.Proj.CRS(
    	   				  tmsInfos[name].srs
    	   				, tmsInfos[name].proj 
    	   				, { resolutions: tmsInfos[name].resolutions
    		              , origin: tmsInfos[name].origin
    		              , bounds: tmsInfos[name].bounds
    		            }
    	   			);
    	   		
    	   		return crs;
    		}
    		
        	// 레이어 생성
    		function setMap(name) {
        		
        		var mapOption = { continuousWorld: true
        						, worldCopyJump: false};
        		
        		// viewport영역에 지도 생성.
        		if(tmsInfos[name].proj){
        			mapOption.crs = getTmsCrs(name);
        		}
    		    
        		map = L.map("viewport", mapOption)
        			   .setView([37.5668, 126.9784], 10);
        		
        		// 다음 basemap 레이어 생성
    		    new L.TileLayer(
    		    		tmsInfos[name].tileUrl, {
    			            maxZoom: 13,
    			            minZoom: 0,
    			            zoomOffset: tmsInfos[name].zoomOffset,
    			            zoomReverse: tmsInfos[name].zoomReverse,
    			            subdomains: '0123',
    			            continuousWorld: true,
    			            attribution: 'ⓒ '+name,
    			            tms: tmsInfos[name].doTms
    			        }).addTo(map);
    		}
        	
            function changeMap(name){
            	$("#viewport").remove();
            	$("#viewArea").append("<div id='viewport' style='width:100%;height:100%;'></div>")
            	setMap(name);
          		
            }
        	
    		 $(document).ready(function(){
    				var chkMapOptions = [];
	  	            for (var name  in tmsInfos) {
	  	            	chkMapOptions.push(name);
	  	            }
    			 
		  	        if(chkMapOptions.length > 0){
			            for( var i = 0; i < chkMapOptions.length; i++ ){
			             	 $("#pickMap").append("<option value="+chkMapOptions[i]+">"+chkMapOptions[i]+"</option>");
			            }
		            }
		             
		              $("#pickMap").val("daum");
    		    	// base 지도 생성
    		    	setMap('daum');
    		 });
	    </script>
	</body>
</html>