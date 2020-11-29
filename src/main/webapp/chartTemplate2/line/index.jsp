<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!doctype html>
<html>
<head>
	<title>line chart 예제</title>
	<meta charset="utf-8" />
	<style>
		html, body { height:100%; overflow:hidden }
		@import url("//fonts.googleapis.com/earlyaccess/nanumgothic.css");
		body{font-family:'Nanum Gothic',NanumGothic,'Nanum gothic',"Helvetica",verdana,sans-serif;font-size:10px;}
		.axis path{
		  fill: none;
		  stroke: #000;
		  shape-rendering: crispEdges;
		}
		.y.axis line {
		  fill: none;
		  stroke: #000;
		  shape-rendering: crispEdges;
		}
		.y.axis .tick line{
		  stroke: lightgrey;
    	  opacity: 0.7;
		}
	    svg g circle {
          fill: #1db34f;
          stroke: #16873c;
          stroke-width: 2px
        }
		svg g path.line {
          stroke: #1db34f;
          stroke-width: 2px;
          stroke-opacity: 1;
          fill: none;
		}
	</style>
	<script src="../lib/jquery-1.11.2.min.js"></script>
	<script src="../lib/d3Chart/d3.js"></script>
</head>
<body>
	<div id="viewport" style="width:100%;height:100%;"></div>
	
	<script type="text/javascript">
	
		// 접근 방식에 따라 drawChart() 자동실행
		if (typeof window.callPhantom === 'function') {
//			console.log("phantomjs callback");
		} else {
			$(document).ready(function() {
				drawChart();
			});
		}
	
		/**
		 * phantomjs이용시 차트를 그리기위한 초기 함수
		 * @param options 외부 입력값 객체
		 */
		function drawChart(options){
			var opt = {};
			//외부 입력값 적용
			if(options){
                d3.select('#viewport').style('width', options.width + "px");
                d3.select('#viewport').style('height', options.height + "px");
                
                opt = options;
			}
			getJson(opt);
		}
		
		/*
		 * 데이터를 가져오는 함수
		 */
		function getJson(options){
			$.ajax({
				url : "./data.jsp",
				success : function(result) {
					var timeVal = ["0~6시","6~9시","9~12시","12~15시","15~18시","18~21시","21~24시"];
					var json = JSON.parse(result);
					
					chartData = [];
					for(var i = 0;i< json.length;i++){
						var item = json[i];
						chartData.push({
							"code": item.code,
							"name": item.name,
							"value": Number(item.value),
							"color": "#000000"
						});	
						
					}
					
					// 정렬
					chartData.sort(function CompareForSort(first, second) {
						return first.code - second.code;
					});
					
					actionChart(options, chartData);
					document.title = 'complete';
				}
			});
		}
		
		// chart 생성 함수
		function actionChart(options, chartData){
			d3.select("#viewport").html("");
			
			var chart_config = {
					ticks:6,
					chartMargin : {top:20, right:20, bottom:30, left:70}
			};
			
			chart_config = $.extend(chart_config,options);
			
			var chartWidth = Number(d3.select('#viewport').style('width').replace("px", "")) - chart_config.chartMargin.left - chart_config.chartMargin.right;
			var chartHeight = Number(d3.select('#viewport').style('height').replace("px", "")) - chart_config.chartMargin.top - chart_config.chartMargin.bottom;
	
			
			var yScale = d3.scale.linear().range([chartHeight, 0]);
			var xScale = d3.scale.ordinal().rangePoints([0,chartWidth]);
			
			var yMaxValue = d3.max(chartData, function(d) { return d.value; });
			//axis
			var xAxis = d3.svg.axis()
						      .scale(xScale)
						      .ticks(5);

			var yAxis = d3.svg.axis()
							  .scale(yScale)
							  .orient("left")
							  .innerTickSize(-chartWidth)
							  .ticks(chart_config.ticks)
							  .tickPadding(10)
							  .tickFormat(function(d){
								  var ff = d3.format(",");
								  return ff(d);
							  });
			
			var line = d3.svg.line()
						     .x(function(d) { return xScale(d.name); })
						     .y(function(d) { return yScale(d.value); });

			var svg = d3.select("#viewport")
						.append("svg")
						.attr("width", chartWidth + chart_config.chartMargin.left + chart_config.chartMargin.right)
						.attr("height", chartHeight + chart_config.chartMargin.top + chart_config.chartMargin.bottom)
						.append("g")
						.attr("transform", "translate(" + chart_config.chartMargin.left + "," + chart_config.chartMargin.top + ")");
			
			yScale.domain([0, yMaxValue + (yMaxValue / 8 )]).nice();
			xScale.domain(chartData.map(function(d){ return d.name; }));
			
			//datum : 
			svg.datum(chartData);

			var xGr = svg.append("g")
					     .attr("class", "x axis")
					     .attr("transform", "translate(0," + chartHeight + ")")
					     .call(xAxis);
			 
		    svg.append("g")
		       .attr("class", "y axis")
		       .attr("transform", "translate(0,0)")
		       .call(yAxis);

			var linePath = svg.append("path")
						      .attr("class", "line")
						      .attr("d", line);
			  
		    svg.selectAll("dot")
               .data(chartData)
               .enter()
               .append("circle")
               .attr("r", 2)
               .attr("cx", function(d) { return xScale(d.name); })
               .attr("cy", function(d) { return yScale(d.value); });
		}
	</script>
	</body>
</html>