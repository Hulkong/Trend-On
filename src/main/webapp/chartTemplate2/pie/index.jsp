<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!doctype html>
<html>
<head>
	<title>pie chart 예제</title>
	<meta charset="utf-8" />
	<style>
		html, body { height:100%; overflow:hidden }
	
 		@import url("//fonts.googleapis.com/earlyaccess/nanumgothic.css");
		body{font-family:'Nanum Gothic',NanumGothic,'Nanum gothic',"Helvetica",verdana,sans-serif;font-size:10px;}

		.arc text {
			text-anchor: middle;
		}
		.arc path {
			stroke: #fff;
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
							"value": Number(item.value)
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
					chartMargin : { top: 10, right: 20, bottom: 100, left: 70 },
					colorArr : [ '#2b83ba', '#64abb0', '#9dd3a7', '#c7e9ad', '#edf8b9', '#ffedaa', '#fec980', '#f99e59', '#e85b3a', '#d7191c' ],
					innerRadius: 0,
					outerRadius: 300
			};
			chart_config = $.extend(chart_config,options);
			d3.select("#viewport").html("");
			
			var chartWidth = Number(d3.select('#viewport').style('width').replace("px", "")) - chart_config.chartMargin.left - chart_config.chartMargin.right;
			var chartHeight = Number(d3.select('#viewport').style('height').replace("px", "")) - chart_config.chartMargin.top - chart_config.chartMargin.bottom;
			
			var color = d3.scale.ordinal().range(chart_config.colorArr);
			
			var chart = d3.select("#viewport")
						  .append("svg")
						  .attr("width", chartWidth + chart_config.chartMargin.left + chart_config.chartMargin.right)
						  .attr("height", chartHeight + chart_config.chartMargin.top + chart_config.chartMargin.bottom)
						  .append("g")
						  .attr("transform", "translate(" + chart_config.outerRadius + "," + chart_config.outerRadius + ")");
			
			var arc = d3.svg.arc()
			                .innerRadius(chart_config.innerRadius)
			                .outerRadius(chart_config.outerRadius);
			
			var label = d3.svg.arc()
					      .outerRadius((chart_config.outerRadius*5/3))
					      .innerRadius((chart_config.innerRadius*5/3));
			
			var pie = d3.layout.pie().value(function(d){ return d.value;})
			
			var arcs = chart.selectAll(".arc")
							.data(pie(chartData))
							.enter()
						  	.append("g")
							.attr("class", "arc");
			
			arcs.append("path")
				.attr("d", arc)
				.attr("fill", function(d){ return color(d.value)});
			
			arcs.append("text")
				.attr("transform", function(d){ return "translate(" + label.centroid(d) + ")"; })
				.text(function(d) { return d.data.name; });
							
			 
		}
	</script>
	</body>
</html>