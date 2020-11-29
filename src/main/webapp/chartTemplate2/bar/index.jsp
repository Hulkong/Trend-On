<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!doctype html>
<html>
<head>
	<title>bar chart 예제</title>
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
		.guideline {
			stroke-width: 1;
			shape-rendering: crispEdges;
		}
		.y.axis .tick line{
			stroke: lightgrey;
    		opacity: 0.7;
		}
	</style>
	<script src="../lib/jquery-1.11.2.min.js"></script>
	<script src="../lib/d3Chart/d3.js"></script>
</head>
<body>
	<div id="viewport" style="width:100%;height:100%;"></div>
	
	<script type="text/javascript">
		
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
			var opt = {};
			//외부 입력값 적용
			if (options) {
				d3.select('body').style("height", options.height + "px");
				d3.select('body').style("width", options.height + "px");				
	            d3.select('#viewport').style('width', options.width + "px");
	            d3.select('#viewport').style('height', options.height + "px");
	
				opt = options;
			}
			getJson(opt);
			
	
		}
		
		/*
		 * 데이터를 가져오는 함수
		 */
		function getJson(options) {
			
			$.ajax({
				url : "./data.jsp",			
				success: function(result, status) {
					var json = JSON.parse(result);
					var chartData = [];
					for(var i = 0;i< json.length;i++){
						var item = json[i];
						chartData.push({
							"name": item.name,
							"value": Number(item.value),
							"color": "#2c7bb6"
						});	
					}
					actionChart(options, chartData);
					document.title = 'complete';
				}
			});
			
		}
	
		// chart 생성 함수
		function actionChart(options, chartData){
			
			var chart_config = {
					ticks : 6,
					chartMargin : { top: 10, right: 20, bottom: 100, left: 70 }
			};
			chart_config = $.extend(chart_config,options);
			d3.select("#viewport").html("");
			
			var chartWidth = Number(d3.select('#viewport').style('width').replace("px", "")) - chart_config.chartMargin.left - chart_config.chartMargin.right;
			var chartHeight = Number(d3.select('#viewport').style('height').replace("px", "")) - chart_config.chartMargin.top - chart_config.chartMargin.bottom;
	
			// Scale
			var xScale = d3.scale.ordinal()
						   .rangeRoundBands([0,chartWidth], .05)
						   .domain(chartData.map(function(d){ return d.name; }));

			var yMax = d3.max(chartData, function(d){return d.value; });
			
			var yScale = d3.scale.linear()
						   .range([chartHeight, 0])
						   .domain([0, yMax + (yMax / 10 ) ]);

			// Axis
			var xAxis = d3.svg.axis()
						  .scale(xScale)
						  .orient("bottom");
			
			var yAxis = d3.svg.axis().scale(yScale).orient("left")
						  .innerTickSize(-chartWidth)
						  .ticks(chart_config.ticks)
						  .tickPadding(10);
									 
			
			var chart = d3.select("#viewport")
						  .append("svg")
						  .attr("width", chartWidth + chart_config.chartMargin.left + chart_config.chartMargin.right)
						  .attr("height", chartHeight + chart_config.chartMargin.top + chart_config.chartMargin.bottom)
						  .append("g")
						  .attr("transform", "translate(" + chart_config.chartMargin.left + "," + chart_config.chartMargin.top + ")");
			
					 // x Axis
					 chart.append("g")
					      .attr("class", "x axis")
					      .attr("transform", "translate(0," + chartHeight + ")")
					      .call(xAxis)
						  .selectAll("text")
					      .style("text-anchor", "end")
					      .attr("dx", "-.8em")
					      .attr("dy", "-.55em")
					      .attr("transform", "rotate(-45)" );
					  
					 // y Axis
					 chart.append("g")
					      .attr("class", "y axis")
					      .call(yAxis); 
					
					 // draw column
					 chart.selectAll(".bar")
					      .data(chartData)
					      .enter().append("rect")
					      .attr("class", "bar")
					      .attr("x", function(d) { return xScale(d.name); })
					      .attr("y", function(d) { return yScale(d.value); })
					      .attr("height", function(d) { return chartHeight - yScale(d.value); })
					      .attr("width", xScale.rangeBand())
					      .style('fill', function(d) {  return d.color;	});
			 
		}
	</script>
	</body>
</html>