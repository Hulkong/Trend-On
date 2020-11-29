<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!doctype html>
<html>
	<head>
		<title>stacked bar chart 예제</title>
		<meta charset="utf-8" />
		<style>
	 		@import url("//fonts.googleapis.com/earlyaccess/nanumgothic.css");
			html, body { height:100%; overflow:hidden }
			body{font-family:'Nanum Gothic',NanumGothic,'Nanum gothic',"Helvetica",verdana,sans-serif;font-size:10px;}
			.axis path {
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
			.y.axis .tick line {
				stroke: lightgrey;
				opacity: 0.7;
			}
			.legend text {
				font-size:11px;
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
						
						var chartData = [];
						for(var i = 0;i< json.length;i++){
							var item = json[i];
							
							var obj = {
								rootName : item.age,
								category : item.category,
								val : item.value
							};
							chartData.push(obj);
						}
						chartData.sort(function CompareForSort(first, second) {
							var r = 0;
		
							if (first.rootName < second.rootName) {
								r = -1;
							} else if (first.rootName > second.rootName) {
								r = 1;
							} else {
								r = 0;
							}
							return r;
						});
						
						actionChart(options, chartData);
						document.title = 'complete';
					}
				});
			}

			// chart 생성 함수
			function actionChart(options,chartData) {
				
				var chart_config = {
						ticks:6,
						chartMargin : {top : 10, right : 10, bottom : 50, left : 70},
						color : [ "#2e6695", "#ff8166" ]
				};
				
				chart_config = $.extend(chart_config,options);
				var roots = groupBy(chartData, "rootName");
				var legend = groupBy(chartData, "category");
	
				var legendArr = [];
				for ( var colnm in legend) {
					legendArr.push({
						"name" : colnm
					});
				}
	
				for ( var nm in roots) {
					var tmpArr = roots[nm];
					var yBegin = 0, yEnd = 0;
					for (var i = 0; i < tmpArr.length; i++) {
						tmpArr[i].yBegin = yBegin;
						tmpArr[i].yEnd = yBegin + tmpArr[i].val;
						yBegin += tmpArr[i].val;
						
						if(i > 0) yEnd = tmpArr[i].yEnd;
					}	
					roots[nm].totalval = yEnd;
				}
				
				d3.select("#viewport").html("");
	
				var chartWidth = Number(d3.select('#viewport').style('width').replace("px", ""))- chart_config.chartMargin.left - chart_config.chartMargin.right;
				var chartHeight = Number(d3.select('#viewport').style('height').replace("px", ""))	- chart_config.chartMargin.top - chart_config.chartMargin.bottom;
	
				// scale
				var xScale = d3.scale.ordinal()
								.rangeRoundBands([ 0, chartWidth - 100 ],	0.3)
				    			.domain(d3.keys(roots));
				    
				var yScale = d3.scale.linear()
						  .range([ chartHeight, 0 ]);
	
				// Axis
				var xAxis = d3.svg.axis()
				                  .scale(xScale)
				                  .orient("bottom");
	
				var yAxis = d3.svg.axis()
								  .scale(yScale)
								  .orient("left")
								  .innerTickSize(-chartWidth + 100)
								  .tickPadding(10)
								  .ticks(chart_config.ticks)
								  .tickFormat(function(d){
									  var ff = d3.format(",");
									  return ff(d);
								  });
	
				var color = d3.scale.ordinal().range(chart_config.color);
	
				var svg = d3.select("#viewport")
					        .append("svg")
							.attr("width",chartWidth + chart_config.chartMargin.left + chart_config.chartMargin.right)
							.attr("height",chartHeight + chart_config.chartMargin.top + chart_config.chartMargin.bottom)
							.append( "g")
							.attr( "transform", "translate(" + chart_config.chartMargin.left + "," + chart_config.chartMargin.top + ")");
	
				var yMax = 0;
				var yValueArray = [];
				for ( var nm in roots) {
					yValueArray.push(roots[nm].totalval)
				}
				
				yMax = d3.max(yValueArray);
				yMax = yMax + (yMax / 10);
				yScale.domain([ 0, yMax ]);
	
				// x Axis
				svg.append("g")
				   .attr("class", "x axis")
				   .attr("transform","translate(0," + chartHeight + ")")
				   .call(xAxis);
	
				// y Axis
				svg.append("g")
				   .attr("class", "y axis")
				   .call(yAxis);
				   
	
				svg.selectAll("rect")
				   .data(chartData)
				   .enter()
				   .append("rect")
				   .attr("width", xScale.rangeBand())
				   .attr("x", function(d) { return xScale(d.rootName);  })
				   .attr("y", function(d) { return yScale(d.yEnd);  })
				   .attr("height", function(d) { return yScale(d.yBegin) - yScale(d.yEnd); })
				   .style("fill", function(d) { return color(d.category);  });
	
				// legend 
				var legend = svg.selectAll(".legend")
								.data(legendArr)
								.enter()
								.append("g")
								.attr("class", "legend")
								.attr("transform", function(d, i) {
									return "translate(0," + (i * 15) + ")";
								});
	
				legend.append("rect")
					  .attr("x", chartWidth - 90)
					  .attr("width", 11)
					  .attr("height", 11)
					  .style("fill", function(d) { return color(d.name);  });
	
				legend.append("text")
					  .attr("x", chartWidth - 75)
					  .attr("y", 8)
					  .style("text-anchor", "start")
					  .text( function(d) { return d.name; } );
	
			}
			
			/**
			* 배열 group by
			* @param xs group by를 할 배열
			* @param key group을 형성할 기준이 되는 colum 값
			**/
			var groupBy = function(xs, key) {
				return xs.reduce(function(rv, x) {
					(rv[x[key]] = rv[x[key]] || []).push(x);
					return rv;
				}, {});
			};
		</script>
	</body>
</html>