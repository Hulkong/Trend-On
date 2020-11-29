<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!doctype html>
<html>
<head>
	<title>openLayers v4.6.4 TMS</title>
	<meta charset="utf-8" />
	<style>
		html, body { height:100%; overflow:hidden }
 		@import url("//fonts.googleapis.com/earlyaccess/nanumgothic.css");
		body{font-family:'Nanum Gothic',NanumGothic,'Nanum gothic',"Helvetica",verdana,sans-serif;font-size:10px;}
		#pickMap {position:fixed; width:150px; height:30px; z-index:50; margin:20px; top:0; right:0; border-radius: 2px;}
	</style>
	<link rel="stylesheet" href="../lib/openlayers-4.6.4/css/ol.css" type="text/css">
	<script src="../lib/jquery-1.11.2.min.js"></script>
    <script type="text/javascript" src="../lib/Proj4/proj4.js"></script>
    <script type="text/javascript" src="../lib/openlayers-4.6.4/ol.js"></script>
</head>
<body>
	<div id="viewport" style="width:100%;height:100%;">
	</div>
	<select id="pickMap" name="pickMap" onChange="changeMap(this.value)">
		<option value="">지도를 선택해주세요.</option>
	</select>
	
	<script type="text/javascript">
		var map;
    	var tmsInfos = {
  			 naver: {
  	            	srs : "EPSG:5179",
  	            	proj : "+proj=tmerc +lat_0=38 +lon_0=127.5 +k=0.9996 +x_0=1000000 +y_0=2000000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +axis=neu +no_defs",
  	            	tileSize : 256,
  	            	extent: [90112, 1192896, 1990673, 2761664],
  	            	resolutions: [4096, 2048, 1024, 512, 256, 128, 64, 32, 16, 8, 4, 2, 1, 0.5, 0.25],
  	            	origin: [90112, 1192896],
  	            	tileUrlFunction: function(coordinate) {
  	            		var z = coordinate[0];
  	            		var x = coordinate[1];
  	            		var y = coordinate[2];
  	            		var url = "https://simg.pstatic.net/onetile/get/184/0/0/"+z+"/"+x+"/"+y+"/bl_vc_bg/ol_vc_an";
  	            		return url;
  	            	},
  	             	olLayer: {}
  	        },
            daum: {
	                srs: "EPSG:5181",
	                proj: "+proj=tmerc +lat_0=38 +lon_0=127 +k=1 +x_0=200000 +y_0=500000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs",
	                tileSize: 256,
	                extent: [-30000, -60000, 494288, 988576],
	                resolutions: [2048, 1024, 512, 256, 128, 64, 32, 16, 8, 4, 2, 1, 0.5, 0.25],
	                origin: [-30000, -60000],
	                tileUrlFunction: function(coordinate) {
	                    var z = tmsInfos["daum"].resolutions.length - coordinate[0];
	                    var x = coordinate[1];
	                    var y = coordinate[2];
	                    var url = 'http://map3.daumcdn.net/map_2d/1712dec/L' + z + '/' + y + '/' + x + '.png';
	                    return url;
	             	},
	             	olLayer: {}
            },
            vworldBase: {
	            	srs: "EPSG:3857",
	            	tileSize: 256,
	            	url : "http://xdworld.vworld.kr:8080/2d/Base/201411/{z}/{x}/{y}.png",
	            	olLayer: {}
            },
            vworldGray: {
            	srs: "EPSG:3857",
            	tileSize: 256,
	           	url : "http://xdworld.vworld.kr:8080/2d/gray/201411/{z}/{x}/{y}.png",
            	olLayer: {}
        }
           

        };
    	
    	$(document).ready(function(){
    		
    		var chkMapOptions = [];
            for (var name  in tmsInfos) {
            	chkMapOptions.push(name);
            	
            	// tms 정보 가져오기
                var tmsInfo = tmsInfos[name];
                
                // proj4에 없는 좌표계 추가하기
                if(tmsInfo.proj) proj4.defs(tmsInfo.srs, tmsInfo.proj);

                // 각 tms 정보별 layer 생성
                if(name.indexOf("vworld") > -1){
                	
                	tmsInfo.olLayer = new ol.layer.Tile({
                        source: new ol.source.XYZ({
                     	  projection: tmsInfo.srs,
    	                      url : tmsInfo.url
                        })
                    });
                	   
                }else{
                	
    	           	 tmsInfo.olLayer = new ol.layer.Tile({
    	                 source: new ol.source.XYZ({
    	                 projection: tmsInfo.srs,
    	                 extent: tmsInfo.extent,
   	                     tileGrid: new ol.tilegrid.TileGrid({
   	                         origin: tmsInfo.origin,
   	                         resolutions: tmsInfo.resolutions,
   	                         tileSize: tmsInfo.tileSize
   	                     }),
   	                     tileUrlFunction: tmsInfo.tileUrlFunction
    	                 })
    	             });
                	
                }
             
            }

            
            if(chkMapOptions.length > 0){
            	for( var i = 0; i < chkMapOptions.length; i++ ){
            		 $("#pickMap").append("<option value="+chkMapOptions[i]+">"+chkMapOptions[i]+"</option>");
            	}
            }
           
            $("#pickMap").val("daum");
            createMap("daum");
    	});

        
        function createMap(name){
            var baseTms = tmsInfos[name];

            map = new ol.Map({
                target: 'viewport',
        		controls:  ol.control.defaults({
                  attributionOptions:{
        			collapsible : false,
        			collapsed : false
        		  }
                }),
                layers: [baseTms.olLayer],
                view: new ol.View({
                    projection: baseTms.srs, //배경과 지도의 좌표계를 맞춘다.
                    resolutions: baseTms.resolutions,
                    center: ol.proj.transform([126.986, 37.541], 'EPSG:4326', baseTms.srs),
                    zoom: 8            
                })
            });
        }
        
        function changeMap(name){
        	$("#viewport").empty();
        	createMap(name)
      		
        }
	</script>
	</body>
</html>