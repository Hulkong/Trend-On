<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!doctype html>
<html>
	<head>
		<title>proportion bar chart 예제</title>
		<meta charset="utf-8" />
		<style>
	 		@import url("//fonts.googleapis.com/earlyaccess/nanumgothic.css");
			html, body { height:100%; overflow:hidden }
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
			function drawChart(options) {
				var opt = {};
				
				//외부 입력값 적용
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
						var chartData = [{
								"name": "emp1",
								"value": "0",
								"desc": "0",
								"color": "#000000"
							}, {
								"name": "emp2",
								"value": "0",
								"desc": "0",
								"color": "#000000"
							}, {
								"name": "emp3",
								"value": "0",
								"desc": "0",
								"color": "#000000"
							}];
						var total_data = {};
						var target_data = {};
						
						if(json){
							total_data.name = "전체<br/>"+json.name;
							target_data.name = json.category2+"<br/>"+json.name;
							
							total_data.value = json.totValue;
							target_data.value = json.value;
							
							total_data.desc = json.category1+"<br/>"+json.name+"비율<br/>"+json.rate1+"%";
							target_data.desc = json.category2+"<br/>"+json.name+"비율<br/>"+json.rate2+"%";
							
							total_data.color = "#595959";
							target_data.color = "#FF5050";
						}
						
						actionChart(options, chartData, total_data, target_data);
					}
				});
			}
			
			// chart 생성 함수
			function actionChart(options, chartData, total_data, target_data){
				d3.select("#viewport").html("");
				
				var chart_config = {
					ticks : 6,
					chartMargin : {top:20, right:5, bottom:50, left:80},
					marker : {x:6, y:6, w:30, h:30}
				};
				chart_config = $.extend(chart_config,options);
				
				// unshift : 배열의 맨처음에 object 추가
				chartData.unshift(target_data);
				chartData.unshift(total_data);
				
				console.log(chartData);
				
				var chartWidth = Number(d3.select('#viewport').style('width').replace("px", "")) - chart_config.chartMargin.left - chart_config.chartMargin.right;
				var chartHeight = Number(d3.select('#viewport').style('height').replace("px", "")) - chart_config.chartMargin.top - chart_config.chartMargin.bottom;
		
		
				var color = d3.scale.ordinal().range(chart_config.colorArr);
				
				var insertLinebreaks = function(d) {
					var el = d3.select(this);
					if (d.indexOf("emp") > -1) {
						d = "";
					}
					var words = d.split('<br/>');
					el.text('');
		
					for (var i = 0; i < words.length; i++) {
						var tspan = el.append('tspan').text(words[i]);
						if (i > 0)
							tspan.attr('x', 0).attr('dy', '15');
					}
				};
		
				var endAll = function(transition, callback) {
					var n = 0;
					transition.each(function() {
						++n;
					}).each('end', function() {
						if (!--n)
							callback.apply(this, arguments);
					});
				}
				var xScale = d3.scale.ordinal().rangeRoundBands([0, chartWidth], .05);
		
				var yScale = d3.scale.linear().range([chartHeight, 0]);
		
				var yMax = d3.max(chartData, function(d) {
					return d.value;
				});
		
				var xAxis = d3.svg.axis().scale(xScale);
		
				var yAxis = d3.svg.axis()
								  .scale(yScale)
								  .orient("left")
								  .ticks(chart_config.ticks)
								  .tickFormat(function(d){
									  var ff = d3.format(",");
									  return ff(d);
								  });
		
				var svg = d3.select("#viewport")
							.append("svg")
							.attr("width",chartWidth + chart_config.chartMargin.left + chart_config.chartMargin.right)
							.attr("height", chartHeight + chart_config.chartMargin.top + chart_config.chartMargin.bottom)
							.append("g")
							.attr("transform","translate(" + chart_config.chartMargin.left + "," + chart_config.chartMargin.top + ")");
		
				d3.selectAll('g').transition().call(endAll, function(a, b, c) {
					d3.selectAll("title").text('complete');	
				});
		
				xScale.domain(chartData.map(function(d) {
					return d.name;
				}));
				yScale.domain([0, yMax + (yMax / 10)]);
				//x 축
				svg.append("g")
				   .attr("class", "x axis")
				   .attr("transform","translate(0," + chartHeight + ")")
				   .style("font-size","9px")
				   .call(xAxis);
				
				svg.selectAll('g.x.axis g text').each(insertLinebreaks);
				//y 축
				svg.append("g")
					.attr("class", "y axis")
					.call(yAxis)
	// 				.append("text")
	// 				.attr("transform", "translate(0,-20)")
	// 				.attr("y", 6)
	// 				.attr("dy",".71em")
	// 				.style("text-anchor", "end")
	// 				.style("font-size","8px")
	// 				.text("(단위: "+data_config.unitSep+")");
		
				//전체 데이터의 시작화살표
				svg.append("svg:defs").append("svg:marker")
					.attr("id", "triangleAstart")
					.attr("refX", chart_config.marker.x)
					.attr("refY", chart_config.marker.y)
					.attr("markerWidth", chart_config.marker.w)
					.attr("markerHeight", chart_config.marker.h)
					.attr("orient", "270")
					.append("path").attr("d","M 0 0 12 6 0 12 3 6")
					.style("fill", total_data.color);
				//전체 데이터의 종료화살표
				svg.append("svg:defs").append("svg:marker")
					.attr("id", "triangleAend")
					.attr("refX", chart_config.marker.x)
					.attr("refY", chart_config.marker.y)
					.attr("markerWidth", chart_config.marker.w)
					.attr("markerHeight", chart_config.marker.h)
					.attr("orient", "auto")
					.append("path").attr("d", "M 0 0 12 6 0 12 3 6")
					.style("fill",total_data.color);
				//대상 데이터의 시작화살표
				svg.append("svg:defs").append("svg:marker")
					.attr("id", "triangleBstart")
					.attr("refX", chart_config.marker.x)
					.attr("refY", chart_config.marker.y)
					.attr("markerWidth", chart_config.marker.w)
					.attr("markerHeight", chart_config.marker.h)
					.attr("orient", "270")
					.append("path").attr("d","M 0 0 12 6 0 12 3 6")
					.style("fill", target_data.color);
				//대상 데이터의 종료화살표
				svg.append("svg:defs").append("svg:marker")
					.attr("id", "triangleBend")
					.attr("refX", chart_config.marker.x)
					.attr("refY", chart_config.marker.y)
					.attr("markerWidth", chart_config.marker.w)
					.attr("markerHeight", chart_config.marker.h)
					.attr("orient", "auto")
					.append("path")
					.attr("d", "M 0 0 12 6 0 12 3 6")
					.style("fill",target_data.color);
		
				//전체 데이터의 수평 line
				svg.append("line")
					.attr("class", "guideline")
					.attr("x1",	xScale(total_data.name))
					.attr("y1", yScale(total_data.value))
					.attr("x2",	xScale("emp1") + (xScale.rangeBand()))
					.attr("y2", yScale(total_data.value))
					.style("stroke", total_data.color);
				//대상 데이터의 수평 line
				svg.append("line")
					.attr("class", "guideline")
					.attr("x1",	xScale(target_data.name))
					.attr("y1", yScale(target_data.value))
					.attr("x2",	xScale("emp1") + (xScale.rangeBand()))
					.attr("y2", yScale(target_data.value))
					.style("stroke", target_data.color);
		
				//전체 데이터의 수직 line(화살표)
				svg.append("line")
					.attr("class", "guideline")
					.attr("x1",	xScale("emp1") + (xScale.rangeBand() / 2))
					.attr("y1",	yScale(target_data.value) + chart_config.marker.y)
					.attr("x2",	xScale("emp1") + (xScale.rangeBand() / 2))
					.attr("y2",	chartHeight - chart_config.marker.y)
					.style("stroke", target_data.color)
					.attr("marker-start", "url(#triangleBstart)")
					.attr("marker-end",	"url(#triangleBend)");
		
				//대상 데이터의 수직 line(화살표)
				svg.append("line")
					.attr("class", "guideline")
					.attr("x1",	xScale("emp1") + (xScale.rangeBand() / 2))
					.attr("y1",	yScale(total_data.value) + chart_config.marker.y)
					.attr("x2",	xScale("emp1") + (xScale.rangeBand() / 2))
					.attr("y2",	yScale(target_data.value) - chart_config.marker.y)
					.style("stroke", total_data.color)
					.attr("marker-start", "url(#triangleAstart)")
					.attr("marker-end",	"url(#triangleAend)");
		
				//전체 데이터의 비율text
				svg.append("text")
					.data([total_data.desc])
					.attr("id",	"rectA")
					.attr("fill", total_data.color)
					.attr("x",xScale("emp1") + (xScale.rangeBand()))
					.attr("y",yScale(target_data.value) -100).each(function(d) {
							var arr = d.split("<br/>");
							for (i = 0; i < arr.length; i++) {
								d3.select(this).append("tspan")
											   .text(arr[i]).attr("dy", i ? "1.2em" : 0)
											   .attr("x", xScale("emp1") + (xScale.rangeBand()))
											   .attr("class", "tspan" + i);
							}
					});
				//대상 데이터의 비율text
				svg.append("text")
					.data([target_data.desc])
					.attr("id",	"rectB")
					.attr("fill", target_data.color)
					.attr("x", xScale("emp1") + (xScale.rangeBand()))
					.attr("y", yScale(target_data.value) + 100 ).each(function(d) {
						var arr = d.split("<br/>");
						for (i = 0; i < arr.length; i++) {
							d3.select(this).append("tspan")
										   .text(arr[i])
										   .attr("dy",i ? "1.2em" : 0)
										   .attr("x",xScale("emp1") + (xScale.rangeBand()))
										   .attr("class", "tspan" + i);
						}
					});
				
				//전체 , 대상의 bar chart
				svg.selectAll("bar")
					.data(chartData)
					.enter()
					.append("rect")
					.style(	"fill",	function(d) {return d.color;})
					.attr("x", function(d) {return xScale(d.name);})
					.attr("width", xScale.rangeBand())
					.attr("y", function(d) {return yScale(d.value);})
					.attr("height", function(d) {return chartHeight - yScale(d.value);});
				
				
				document.title = 'complete';
		
			}
		</script>
	</body>
</html>