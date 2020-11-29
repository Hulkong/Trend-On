<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>
<html>
<head>
<title>경제24</title>
<script src="/js/jquery/jquery-1.11.2.min.js"></script>
<script src="/js/jquery/jquery-ui-draggable.min.js"></script>
<script src="/js/sub.js?ver=${globalConfig['config.version']}"></script>
<script src="/js/Leaflet-1.0.2/geostats.js"></script>
<link rel="stylesheet" href="/js/Leaflet-1.0.2/leaflet.css" />
<script type="text/javascript" src="/js/Leaflet-1.0.2/leaflet-src.js"></script>

<link href="/js/bootstrap/bootstrap.min.css" rel="stylesheet">
<link href="/js/bootstrap/bootstrap-slider.css" rel="stylesheet">

<script src="/js/bootstrap/bootstrap.min.js"></script>
<script src="/js/bootstrap/bootstrap-slider.js"></script>


<script src="//d3plus.org/js/d3.js"></script>
<script src="//d3plus.org/js/d3plus.js"></script>

<script src="/js/d3Chart/d3Chart.js"></script>
<style>
.mt50 {
	margin-top: 50px;
}

.mt20 {
	margin-top: 20px;
}

.boxArea {
	width: 100%;
	hegiht: 800px;
	margin: 0 auto;
}

.titleArea {
	width: 100%;
	hegiht: 100px;
	margin: 0 auto;
}

.titleArea h1 {
	text-align: center;
}
</style>
</head>
<body>
	<div class="titleArea">
		<h1>경제24!!!!</h1>
	</div>
	<div id="areaChart" style="width: 100%; height: 300px;"></div>

	<div class="boxArea amt mt50">
		<input id="ex18b" type="text" />
	</div>
	<div class="boxArea amt mt50">
		<div id="map24" style="height: 500px;"></div>
		<div id="scatterChart" class="mt20"></div>
		<!-- 		<svg id="scatterChart" class="mt20"></svg> -->
	</div>
</body>

<script>
var ecnmy_24_config = {
		sessionCtyCd:'1168',
		selectedDate:'201612', // 최근한달
		selectedRgnClss:'H4',
		selectedTime:[]
};

var data24 = null;
var layer24 = null;

//경제24 : 행정동별 고객수
var map24 = L.map('map24',{ zoomControl:true
	, scrollWheelZoom:true
	, maxZoom:18
	, minZoom:7
}
).setView([37.492334, 127.062444], 12);
L.tileLayer("http://tmap{s}.selfmap.co.kr:8081/TileMap/{z}/{y}/{x}.png", {
	minZoom : 7 , 
	maxZoom : 18 , 
	subdomains: "0123",
	reuseTiles: true,
	continuousWorld: true,
	attribution: "&copy; <a href=\"http://openmate-on.co.kr\">openmate-on</a>"
}).addTo(map24);


var timeData = $.parseJSON('<c:out value="${timeGraph}" escapeXml="false"/>');;
$(document).ready(function(){
	
	
	
	
	// 경제24  매출액 : amtData  - 지도
	$.ajax({
		type: "GET",
		dataType: 'json',
		url:"/onmap/ecnmy_24/ecnmy_24_map.json",
		data:"ctyCd="+ecnmy_24_config.sessionCtyCd+"&date="+ecnmy_24_config.selectedDate +"&rgnClss="+ecnmy_24_config.selectedRgnClss,
		success: function(json) {
			data24 = $.extend(true, {}, json);
			layer24 = L.geoJSON(json);
			layer24.addTo(map24);
			
			doAdmiChoropleth('total_cnt',layer24,data24);
		}
	});
	
	// 경제24 매출액 지도 범례
	$.ajax({
		type: "GET",
		dataType: 'json',
		url:"/onmap/ecnmy_24/ecnmy_24_map_legend.json",
		data:"ctyCd="+ecnmy_24_config.sessionCtyCd+"&date="+ecnmy_24_config.selectedDate +"&rgnClss="+ecnmy_24_config.selectedRgnClss,
		success: function(json) {
			console.log(json);
		}
	});
	
	mapGraphData();
	
// 	var sliderB = new Slider("#ex18b", { ticks: [0, 1, 2, 3, 4, 5, 6, 7],
// 									 ticks_positions: [0, 28, 40, 52, 64, 76, 88, 100],
// 									 ticks_labels: ['0시', '6시', '9시', '12시', '15시', '18시', '21시', '24시'],  
// 									 value: [0, 1], 
// 									 tooltip: 'hide',
// 									 range: true,
// 									 focus:true
// 							});

// 	sliderB.on("slide", function(sliderValue) {
// // 		console.log(sliderValue)
// 		if(sliderValue[0] == ecnmy_24_config.selectedTime[0] && sliderValue[1] == ecnmy_24_config.selectedTime[1]){
// 		}else{
// 			ecnmy_24_config.selectedTime = sliderValue;
			
// 			var sTime = sliderValue[0];
// 			var eTime = sliderValue[1];
// 			var timeArr = '';
// 			if(sTime == '0'){
// 				timeArr += "'7',";
// 				sTime = sTime + 1;
// 			}
			
// 			for(var i = sTime ; i <= eTime; i++){
// 				timeArr += "'"+i+"'";
// 				if(eTime != i){
// 					timeArr += ',';
// 				}
// 			}
// // 			console.log(timeArr);
// // 			console.log(data24);
// // 			doAdmiChoropleth('total_cnt',layer24,data24);

// 			$.ajax({
// 				type: "GET",
// 				dataType: 'json',
// 				url:"/onmap/ecnmy_24/ecnmy_24_map.json",
// 				data:"ctyCd="+ecnmy_24_config.sessionCtyCd+"&date="+ecnmy_24_config.selectedDate +"&rgnClss="+ecnmy_24_config.selectedRgnClss+"&period="+timeArr,
// 				success: function(json) {
// 					data24 = $.extend(true, {}, json);
// // 					layer24 = L.geoJSON(json);
// // 					console.log(data24);
// 					doAdmiChoropleth('total_cnt',layer24,data24);
					
// 				}
// 			});
			
// 			$.ajax({
// 				type: "GET",
// 				dataType: 'json',
// 				url:"/onmap/ecnmy_24/ecnmy_24_map_legend.json",
// 				data:"ctyCd="+ecnmy_24_config.sessionCtyCd+"&date="+ecnmy_24_config.selectedDate +"&rgnClss="+ecnmy_24_config.selectedRgnClss+"&period="+timeArr,
// 				success: function(json) {
// 					console.log(json);
// 				}
// 			});
// 		}
// 	});
});

function mapGraphData(timeArr){
	if(timeArr === undefined) timeArr ='';
	
	$.ajax({
		url:"/onmap/ecnmy_24/ecnmy_24_map_graph_data.json",
		data:"ctyCd="+ecnmy_24_config.sessionCtyCd+"&date="+ecnmy_24_config.selectedDate +"&rgnClss="+ecnmy_24_config.selectedRgnClss+"&period="+timeArr,
		success: function(data) {
		
			var inputData =[];
			for(var i = 0; i < data.mapGraph.length; i++){
				var chartData = {};
				chartData.name = data.mapGraph[i].nm;
				chartData.value = data.mapGraph[i].res_pop_cnt;
				chartData.weight = data.mapGraph[i].total_cnt;
				
				inputData.push(chartData);
			}
				scatterChart_plus(inputData,"#scatterChart");
		}
	});
}



function areaChart(data){
	console.log("areaChart start!");
	console.log(data);

}
</script>

<style>
svg {
	font: 10px sans-serif;
}

path.line {
	fill: none;
	stroke: #666;
	stroke-width: 1.5px;
}

path.area {
	fill: #e7e7e7;
}

.axis {
	shape-rendering: crispEdges;
}

.x.axis line {
	stroke: #fff;
}

.x.axis .minor {
	stroke-opacity: .5;
}

.x.axis path {
	display: none;
}

.y.axis line, .y.axis path {
	fill: none;
	stroke: #000;
}

.guideline {
	stroke: rgb(255, 0, 0);
	stroke-width: 2
}

.marker .dot {
	fill: #FF0000;
}

.gslider {
	width: 100px;
	height: 100px;
	border: 1px solid red;
}
</style>
<script type="text/javascript">
// https://bl.ocks.org/mbostock/1166403
// http://io.morphocode.com/urban-layers/js/graph.js
// http://bl.ocks.org/duopixel/3824661

var timeVal = ["0-6","6-9","9-12","12-15","15-18","18-21","21-24"];
var $container = $('#areaChart');
var cwidth = $container.width();
var cheight = $container.height();



var margin = {top: 40, right: 90, bottom: 40, left: 40},
    width = cwidth - margin.left - margin.right,
    height = cheight - margin.top - margin.bottom;


var x = d3.scale.linear().range([0, width]);
var y = d3.scale.linear().range([height, 0]);
var xAxis = d3.svg.axis()
    .scale(x)
    .ticks(timeVal.length)
    .tickSize(-height)
    .tickFormat(function(d){return timeVal[parseInt(d)-1] + "시";});

var yAxis = d3.svg.axis()
    .scale(y)
    .ticks(4)
    .orient("right");

var area = d3.svg.area()
    .interpolate("monotone")
    .x(function(d) { return x(d.timezon_cd); })
    .y0(height)
    .y1(function(d) { return y(d.total_cnt); });

var line = d3.svg.line()
    .interpolate("monotone")
    .x(function(d) { return x(d.timezon_cd); })
    .y(function(d) { return y(d.total_cnt); });

var svg = d3.select("div#areaChart").append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
  .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

   svg.append("clipPath")
	    .attr("id", "clip")
	  .append("rect")
	    .attr("width", width)
	    .attr("height", height);

  x.domain([  parseInt(timeData[0].timezon_cd), parseInt(timeData[timeData.length - 1].timezon_cd)  ] ) ;
  y.domain([0, d3.max(timeData, function(d) { return d.total_cnt; })]).nice();

  svg.datum(timeData);

  svg.append("path")
      .attr("class", "area")
      .attr("clip-path", "url(#clip)")
      .attr("d", area);

  svg.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0," + height + ")")
      .call(xAxis);

  svg.append("g")
      .attr("class", "y axis")
      .attr("transform", "translate(" + width + ",0)")
      .call(yAxis);

  var linePath = svg.append("path")
      .attr("class", "line")
      .attr("clip-path", "url(#clip)")
      .attr("d", line);
  
  
  //그래프 끝
  
  
  //slider 시작
  //slider는 선과 점이 slider의 위치에 따라 움직인다.
  
  
  var startSlider = sliderBuilder(x,y,timeData,svg,"areaChart","startSlider",width,{});
  var endSlider = sliderBuilder(x,y,timeData,svg,"areaChart","endSlider",width,{});
  
  
  function sliderBuilder(scaleX,scaleY,silderData,canvas,id,sliderName ,maxWidth,dragHandler){
	  var sliderGroup = canvas.append("g") .attr("class", "marker");
	  
	  var dotLine = sliderGroup.append("line")
	  .attr("class", "guideline")
	  .attr("clip-path", "url(#clip)")
	  .attr("x1", 0)
	  .attr("y1", 0)
	  .attr("x2", 0)
	  .attr("y2", height*2);
	  
	  var dot = sliderGroup.append("circle")
	  .attr("class", "dot")
	  .attr("r", 2.5);
	  
	  
	  var _selectedData = silderData[0];
      var _sliderDiv = $("#"+id).append("<div class='gslider "+sliderName+"' style='left:30px;position:relative'/>");
      
      var that = this;
      $(".gslider."+sliderName).draggable({
          axis: "x",
          start : function() {
             console.log(sliderName + " start!!");
          },
          drag: function(event, ui) {
        	  moveX($(this).position().left);
          },
          stop : function() {
             console.log(sliderName + " stop!!");
             console.log(_selectedData);
          }
      });
      
	  
	  
	  function moveX(xxx){		  
		  if (xxx < 0 || xxx > maxWidth) return;
		  
		  
		  var posX = xxx;
		  var x0 = scaleX.invert(posX);
		  var newValue = Math.round(x0);
		  var bisectTimeCd = d3.bisector(function(d) { return parseInt(d.timezon_cd); }).left;
		  var i = bisectTimeCd(silderData, x0, 1);
		  
		  var d0 = silderData[i - 1];
		  var d1 = silderData[i];
		  var d = x0 - parseInt(d0.timezon_cd) > parseInt(d1.timezon_cd) - x0 ? d1 : d0;
		  _selectedData = d;
		  var nearYvalue= scaleY(d.total_cnt);	  
				  
		  var pathEl = linePath.node();
		  var pathLength = pathEl.getTotalLength();
		  var beginning = posX, end = pathLength, target;
		  
		  while (true) {
		      target = Math.floor((beginning + end) / 2);
		      pos = pathEl.getPointAtLength(target);
		      if ((target === end || target === beginning) && pos.x0 !== x) {
		          break;
		      }
		      if (pos.x > posX)      end = target;
		      else if (pos.x < posX) beginning = target;
		      else break; //position found
		  }
		  dot.attr("transform", "translate(" + pos.x + "," + pos.y + ")");
		  dotLine.attr("transform", "translate(" + pos.x + ",0)");
	  }
	  
	  return {
		  move:moveX,
		  value:function(){return _selectedData;}
	  }
  }

  
  
</script>

</html>