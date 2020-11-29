<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!doctype html>
<html>
	<head>
		<title>horizontal bar chart 예제</title>
		<meta charset="utf-8" />
		<style>
	 		@import url("//fonts.googleapis.com/earlyaccess/nanumgothic.css");
			html, body { height:100%; overflow:hidden }
			body{font-family:'Nanum Gothic',NanumGothic,'Nanum gothic',"Helvetica",verdana,sans-serif;font-size:10px;}
			text {
			  font: 10px;
			}
			.axis text {
			  font: 9px;
			}
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
			if (typeof window.callPhantom === 'function') {
// 				console.log("phantomjs callback");
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
				if(options){
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
			function getJson(options){
				$.ajax({
					url : "./data.jsp",
					success : function(result) {
						var json = JSON.parse(result);
						
						chartData = [];
						for(var i = 0;i< json.length;i++){
							var item = json[i];
							chartData.push({
								"name": item.name,
								"value": item.value,
								"color": "#000000"
							});	
							
						}
						chartData.reverse();
						actionChart(options,chartData);
						document.title = 'complete';
					}
				});
			}
		
			// chart 생성 함수
			function actionChart(options,chartData){
				d3.select("#viewport").html("");
				
				var chart_config = {
						ticks: 4,
						chartMargin : { top: 30,	right: 10, bottom: 30, left: 70 },
						barColor : "#005480"
				};
				chart_config = $.extend(chart_config,options);
				
				var chartWidth = Number(d3.select('#viewport').style('width').replace("px", "")) - chart_config.chartMargin.left - chart_config.chartMargin.right;
				var chartHeight = Number(d3.select('#viewport').style('height').replace("px", "")) - chart_config.chartMargin.top - chart_config.chartMargin.bottom;
				
				// Scale
				var xScale = d3.scale.linear()
							   .range([0,chartWidth])
							   .domain([0, d3.max(chartData, function(d){return d.value; })]);
				
				var yScale = d3.scale.ordinal()
							   .rangeRoundBands([chartHeight, 0],0.3)
							   .domain(chartData.map(function (d) {return d.name; }));
				
				// Axis
				var xAxis = d3.svg.axis()
							  .scale(xScale)
							  .ticks(chart_config.ticks)
							  .orient("top")
							  .tickFormat(function(d){
							 	var ff = d3.format(",");
							 	return ff(d);
							  });
				
				var yAxis = d3.svg.axis()
								  .scale(yScale)
								  .orient("left")
								  .tickSize(0);
								 
				
				var chart = d3.select("#viewport")
							  .append("svg")
							  .attr("width", chartWidth + chart_config.chartMargin.left + chart_config.chartMargin.right)
							  .attr("height", chartHeight + chart_config.chartMargin.top + chart_config.chartMargin.bottom)
							  .append("g")
							  .attr("transform", "translate(" + chart_config.chartMargin.left + "," + chart_config.chartMargin.top + ")");
				
					// x Axis
					chart.append("g")
					     .attr("class", "x axis")
					     .attr("transform", "translate(0,0)")
					     .call(xAxis);
					  
					// y Axis
					chart.append("g")
					     .attr("class", "y axis")
					     .call(yAxis); 
				
					// draw column
					chart.selectAll(".bar")
					     .data(chartData)
					     .enter()
					     .append("rect")
					     .attr("class", "bar")
					     .attr("y", function(d) { return yScale(d.name); })
					     .attr("height",yScale.rangeBand())
					     .attr("width", function(d) { return xScale(d.value); })
					     .style('fill', function(d){return chart_config.barColor; });
			}
		</script>
	</body>
</html>