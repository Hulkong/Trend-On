<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!doctype html>
<html>
	<head>
		<title>bar line chart 예제</title>
		<meta charset="utf-8" />
		<style>
	 		@import url("//fonts.googleapis.com/earlyaccess/nanumgothic.css");
			html, body { height:100%; overflow:hidden }
			body{
			  font-family:'Nanum Gothic',NanumGothic,'Nanum gothic',"Helvetica",verdana,sans-serif;
			  font-size:11px;
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
			.y.axis .tick line{
			  stroke: lightgrey;
	    	  opacity: 0.7;
			}
		    svg g circle {
	          fill: red;
	        }
			svg g path.line {
	          stroke: #1db34f;
	          stroke-width: 3px;
	          stroke-opacity: 1;
	          fill: none;
			}
			path {
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
//		 		console.log("phantomjs callback");
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
			function getJson(options){
				$.ajax({
					url : "./data.jsp",
					success: function(result) {
						options.seriesNames = ["매출액", "매출액변화율"]; //y 계열 이름
						options.colorArr = [  "#00A9CC", "#ff0000" ];//계열별 색상
						
						var json = JSON.parse(result);
						chartData = [];
						for(var i = 0;i< json.length;i++){
							var item = json[i];
							krWonRound(Number(item.value),8,4);
							chartData.push({
								"name": item.name,
								"value": Number(item.value),
								"valueR": Number(item.valueR)
							});	
						}
						
						options.krIndex = krWonRoundIndex(Math.max.apply(null, d3.extent(chartData , function(d){ return d.value }).map(Math.abs)))
						actionChart(options, chartData);
						document.title = 'complete';
					}
				});
			}
		
			// chart 생성 함수
			function actionChart(options, chartData) {
				d3.select("#viewport").html("");
	
				var chart_config = {
						ticks : 6,
						krIndex : 8, 							// 한글 수 단위(8 : 억, 7 :천만 ...)
						chartMargin : {top: 20, right: 130, bottom: 100, left: 70},
						colorArr : ["#828282", "#d3d3d3"],		//계열별 색상
						seriesNames : ["축1", "축2"] 				//y 축 이름
				};
				chart_config = $.extend(chart_config,options);
				
				var chartWidth = Number(d3.select('#viewport').style('width').replace("px", "")) - chart_config.chartMargin.left - chart_config.chartMargin.right;
				var chartHeight = Number(d3.select('#viewport').style('height').replace("px", "")) - chart_config.chartMargin.top - chart_config.chartMargin.bottom;
	
				var color = d3.scale.ordinal()
							  .range(chart_config.colorArr);
	
				var xScale = d3.scale.ordinal()
							   .rangeRoundBands([ 0, chartWidth ], .3);
	
				var yScale = d3.scale.linear()
							   .range([ chartHeight, 0 ]);
	
				var xAxis = d3.svg.axis()
							  .scale(xScale)
							  .ticks(5);
	
				var yMaxValue = d3.max(chartData, function(d) { return d.value;	});
				
				var yAxis = d3.svg.axis()
							  .scale(yScale)
							  .orient("left")
							  .innerTickSize(-chartWidth)
							  .ticks(10)
							  .tickFormat(function(d) {
									return krWonRound(d, chart_config.krIndex, 4) + "원";
							  })
							  .tickPadding(10);
	
				var yMaxValue = d3.extent(chartData, function(d) { return d.value });
	
				var yScaleRight = d3.scale.linear()
									.range([ chartHeight, 0 ]);
				
				var yAxisRight = d3.svg.axis()
								   .scale(yScaleRight)
								   .orient("right")
								   .ticks(chart_config.ticks)
								   .tickFormat(function(d) {
										return d + "%";
								   })
								   .tickPadding(10);
	
				var yMaxValueRight = d3.extent(chartData, function(d) { return d.valueR });
	
				yAbsMaxValueRight = Math.max.apply(null, yMaxValueRight.map(Math.abs));
	
				yScaleRight.domain([(yAbsMaxValueRight * -1) + (yAbsMaxValueRight * -1) / 8, yAbsMaxValueRight + yAbsMaxValueRight / 8 ]);
	
				var valueline2 = d3.svg.line()
								   .interpolate('linear')
								   .x(function(d) {
										return xScale(d.name) + xScale.rangeBand() / 2;
								   })
								   .y(function(d) {
										return yScaleRight(d.valueR);
								   });
	
				yAbsMaxVale = Math.max.apply(null, yMaxValue.map(Math.abs));
				
				yScale.domain([ (yAbsMaxVale * -1) + (yAbsMaxVale * -1) / 8, yAbsMaxVale + yAbsMaxVale / 8 ]);
	
				xScale.domain(chartData.map(function(d) { return d.name; }));
	
				var svg = d3.select("#viewport")
							.append("svg")
							.attr("width", chartWidth + chart_config.chartMargin.left + chart_config.chartMargin.right)
							.attr("height", chartHeight + chart_config.chartMargin.top + chart_config.chartMargin.bottom)
							.append("g")
							.attr("transform","translate(" + chart_config.chartMargin.left + "," + chart_config.chartMargin.top + ")");
	
					svg.datum(chartData);
		
					svg.append("g")
					   .attr("class", "x axis")
					   .attr("transform", "translate(0," + chartHeight + ")")
					   .call(xAxis)
					   .selectAll("text")
					   .style("text-anchor", "end")
					   .attr("dx", "-.55em")
					   .attr("dy", "-.8em")
					   .attr("transform", "rotate(-45)");
		
					svg.append("g")
					   .attr("class", "y axis")
					   .attr("transform", "translate(0,0)")
					   .call(yAxis);
		
					svg.append("g")
					   .attr("class", "y axis")
					   .attr("transform","translate(" + chartWidth + ",0)")
					   .call(yAxisRight);
	
				var bar = svg.selectAll(".bar")
							 .data(chartData)
							 .enter()
							 .append("rect")
							 .attr("class",	function(d) {
								return "bar bar--" + (d.value < 0 ? "negative" : "positive");
							 })
							 .attr("x", function(d) {
								return xScale(d.name);
							 }).attr("y", function(d) {
								return yScale(Math.max(0, d.value));
							 }).attr("width", xScale.rangeBand()).attr("height", function(d) {
								return Math.abs(yScale(d.value) - yScale(0));
							 })
							 .style('fill', function(d) {
								return color(0);
							 });
	
					  	  svg.append("path") // Add the valueline2 path.
						     .style("stroke", color(1))
						     .style("stroke-width", "2px")
						     .attr("d", valueline2(chartData));
		
						  svg.selectAll("dot")
						     .data(chartData)
						     .enter()
						     .append("circle")
						     .attr("r", 3)
						     .attr("cx", function(d) {
								return xScale(d.name) + xScale.rangeBand() / 2;
						     })
						     .attr("cy", function(d) {
								return yScaleRight(d.valueR);
						     });
	
				var legend = svg.selectAll(".legend")
								.data(chart_config.seriesNames)
								.enter()
								.append("g")
								.attr("class", "legend")
								.attr("transform", function(d, i) {
									return "translate(0," + (i * 15) + ")";
								});
	
					legend.append("rect")
						  .attr("x", chartWidth + chart_config.chartMargin.right - 80)
						  .attr("width", 8)
						  .attr("height", 8)
						  .style("fill", function(d) {
								return color(d);
						  });
		
					legend.append("text")
						  .attr("x", chartWidth + chart_config.chartMargin.right - 70)
						  .attr("y", 8)
						  .style("text-anchor", "start")
						  .text(function(d) {
								return d;
						  });
			}

			/**
			* 숫자를 문자로 변경
			* @param value 변경할 숫자값
			* @param index 단위제한( ex : index = 8 일경우 억단위까지만 표현후 반환 ) 
			* @param precision 소수점 자리수
			**/
			function krWonRound(value,index,precision){
				
				if(value == 0 )
					return 0;
				var prs = ["일","십","백","천","만","십만","백만","천만","억"];
				var i = 0;
				var pre = 0;
				var minus = "";
				if(precision) pre = precision;
				if (value < 0){
					value *= -1;
					minus = "-"
				} 
				
				if(index) {
					i = index;
				}else{
					i = 1 + Math.floor(1e-12 + Math.log(value) / Math.LN10);
					i--;
				}
				if(prs.length < i) i = prs.length;
				return minus+d3.round(value/Math.pow(10,i) , pre) + prs[i];		
			}
			
			/**
			* 단위에대한 인텍스 추출
			* @param value 변경할 숫자값 ( ex : value = 100000000(일억원)일경우 '8'을 반환 ) 
			**/
			function krWonRoundIndex(value){
				var prs = ["일","십","백","천","만","십만","백만","천만","억"];
				var i = 0;
				if (value < 0) value *= -1;
				i = 1 + Math.floor(1e-12 + Math.log(value) / Math.LN10);
				if(prs.length < i) i = prs.length;
				i--;
				return i;
			}
		</script>
	</body>
</html>