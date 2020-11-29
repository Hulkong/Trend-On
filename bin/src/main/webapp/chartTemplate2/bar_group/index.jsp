<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!doctype html>
<html>
	<head>
		<title>grouped bar chart 예제</title>
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
			.y.axis .tick line{
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
			function drawChart(options){
				var opt ={};
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
						
						chartData = [];
						var timeVal = ["0~6시","6~9시","9~12시","12~15시","15~18시","18~21시","21~24시"];
						
						for(var i = 0;i< json.length;i++){
							var item = json[i];
							chartData.push({
								"rootName": item.name,
								"rootCd": timeVal.indexOf(item.name.trim()),
								"colnm" : item.category,
								"value": item.value,
								"desc": "0",
							});	
							
						}
						
						// 정렬
						chartData.sort(function CompareForSort(first, second) {
							return first.rootCd - second.rootCd;
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
						ticks : 4,
						chartMargin : {top: 10,	right: 20,	bottom: 70,	left: 100},
						color : [ "#2e6695", "#ff8166", "#828282", "#d3d3d3" ],
						xAxis: {"rotate" : 0, "textAnchor":"middle"}
				};
				chart_config = $.extend(chart_config,options);
				
				var roots = groupBy(chartData, "rootName");
				var category = groupBy(chartData, "colnm");
				
				var groupedXrange =[];
				for(nm in roots){
					groupedXrange.push(nm);
				}
				
				var chartWidth = Number(d3.select('#viewport').style('width').replace("px", "")) - chart_config.chartMargin.left - chart_config.chartMargin.right;
				var chartHeight = Number(d3.select('#viewport').style('height').replace("px", "")) - chart_config.chartMargin.top - chart_config.chartMargin.bottom;
		
				var yScale = d3.scale.linear()
					      	   .domain([0, d3.max(chartData, function(d){return d.value; })])
					      	   .range([chartHeight, 0]);
				
				var xScale0 = d3.scale.ordinal()
								.rangeRoundBands([ 0, chartWidth -100 ], 0.1)
								.domain(d3.keys(roots));
	
			    
				var xScale1 = d3.scale.ordinal()
			    				.domain(d3.keys(category))
			    				.rangeRoundBands([ 0, xScale0.rangeBand() ]);
			    
				var xAxis = d3.svg.axis()
								  .scale(xScale0)
								  .orient("bottom");
				
				var color = d3.scale.ordinal()
							  .range(chart_config.color);
				
				var yAxis = d3.svg.axis()
								  .scale(yScale)
								  .orient("left")
								  .innerTickSize(-chartWidth + 100)
								  .ticks(chart_config.ticks)
								  .tickPadding(10)
								  .tickFormat(function(d){
									  var ff = d3.format(",");
									  return ff(d);
								  });
				
				var svg = d3.select("#viewport")
							.append("svg")
						    .attr("width", chartWidth + chart_config.chartMargin.left + chart_config.chartMargin.right)
						    .attr("height", chartHeight + chart_config.chartMargin.top + chart_config.chartMargin.bottom)
						    .append("g")
						    .attr("transform", "translate(" + chart_config.chartMargin.left + "," + chart_config.chartMargin.top + ")");
				
					svg.append("g")
					   .attr("class", "y axis")
					   .call(yAxis);
				
					svg.append("g")
					   .attr("class", "x axis")
					   .attr("transform", "translate(0," + chartHeight + ")")
					   .call(xAxis)			
					   .selectAll("text")
				       .style("text-anchor", chart_config.xAxis.textAnchor)
				       .attr("transform", "rotate("+chart_config.xAxis.rotate+")" );
				
				
				var groupedBar = svg.selectAll(".groupedBar")
									.data(chartData)
									.enter()
									.append("g")
									.attr("class", "g")
									.attr("transform", function(d) {
										return "translate(" + xScale0(d.rootName) + ",0)";
									});
				
				
					groupedBar.selectAll("rect")
							  .data(function(d) { return roots[d.rootName];  })	
							  .enter()
							  .append("rect")
							  .attr("width", xScale1.rangeBand())
							  .attr("x", function(d) { return xScale1(d.colnm);  })
							  .attr("y", function(d) { return yScale(d.value);  })
							  .attr("height", function(d) { return chartHeight - yScale(d.value); })
							  .style("fill", function(d) { return color(d.colnm);  });
				
				
				var legendArr = [];
				for ( var colnm in category) {
					legendArr.push({
						"name" : colnm
					});
				}
				
				var legend = svg.selectAll(".legend")
							    .data(legendArr)
							    .enter()
							    .append("g")
							    .attr("class", "legend")
							    .attr("transform", function(d, i) { 
	// 						    	var ylegend = Number((i * 8))+Number((chartWidth/4));
							    	return "translate(0," + (i * 15) + ")"; 
							    });
		
					legend.append("rect")
						  .attr("x", chartWidth - 80)
						  .attr("width", 11)
						  .attr("height", 11)
						  .style("fill", function(d){return color(d.name);});
					
					legend.append("text")
					      .attr("x", chartWidth - 60)
					      .attr("y", 8)
					      .style("text-anchor", "start")
					      .text(function(d){return d.name;});
				
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