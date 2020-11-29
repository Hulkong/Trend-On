<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!doctype html>
<html>
<head>
	<title>multiple line chart 예제</title>
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
		function drawChart(options) {
			var opt = {};
			//외부 입력값 적용
			if (options) {
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
				url: "./data.jsp",
				success: function(result) {
					var json = JSON.parse(result);
					
					var columOrder = ["lw3", "lw2", "lw1", "term", "aw1"];	// x축 ticks의 순서에 맞게 data컬럼 정의 ( columOrder배열의 index를 이용해서 순서 정리 )
					var columKr = ["3주일전", "2주일전", "1주일전", "이벤트기간", "1주일후"]; // x축 ticks의 순서에 따른 한글명
					
					options.colorArr = [  "#333333", "#d3d3d3", "#41C7EB", "#31D634", "#ff0000" ]; // 각 row에 대한 color 정의
					options.xColName = "xcolkr"; //x축이름
					
					var chartData = []; //차트 데이터
					options.seriesNames =[];
					options.seriesCols = [];
					if(json.length > 0){
						for(var i = 0 ;  i < json.length; i++){
							options.seriesCols.push("ycol"+(i+1)); //y 계열 컬럼 명
							options.seriesNames.push(json[i].name);
							var chartArr ={
									xcol: columOrder[i],
									xcolkr: columKr[i], //x 컬럼의 한글명
									xcolorder: i, 		//정렬을 위한 시퀀스
							};
							for(var j =0; j < json.length; j++){
								chartArr["ycol"+(j+1)+"Name"] = json[j].name;
								chartArr["ycol"+(j+1)+"valu"] = (json == null) ? 0 : json[j][columOrder[i]];
							}
							chartData.push(chartArr);
						}
					}

					chartData.sort(function CompareForSort(first, second) {
						return first.xcolorder - second.xcolorder;
					});
					
					actionChart(options, chartData);
					document.title = 'complete';
				}
			});
		}

		// chart 생성 함수
		function actionChart(options, chartData) {
			
			var chart_config = {
					ticks: 6,
					chartMargin : {top:20, right:20, bottom:30, left:100},
					xColName : "xcol",		//x축이름
					seriesCols : ["ycol1", "ycol2", "ycol3", "ycol4", "ycol5"], 			//y 계열 컬럼명
					seriesNames : ["1계열", "2계열", "3계열", "4계열", "5계열"], 					//y 계열 이름
					colorArr : [  "#828282", "#d3d3d3", "#2e6695", "#ff8166", "#ff0000" ]	//계열별 색상
			};
			
			chart_config = $.extend(chart_config,options);
			
			d3.select("#viewport").html("");

			var chartWidth = Number(d3.select('#viewport').style('width').replace("px", "")) - chart_config.chartMargin.left - chart_config.chartMargin.right;
			var chartHeight = Number(d3.select('#viewport').style('height').replace("px", "")) - chart_config.chartMargin.top - chart_config.chartMargin.bottom;
			
			var xScale = d3.scale.ordinal().rangePoints([0, chartWidth - 100]);
			var yScale = d3.scale.linear().range([chartHeight , 0]);
			
			var color = d3.scale.ordinal().range(chart_config.colorArr);
			
			var xAxis = d3.svg.axis().scale(xScale).ticks(5);
			
			var yMaxValue = d3.max(chartData, function(d) {
				return d.value;
			});
			
			var yAxis = d3.svg.axis()
			              .scale(yScale)
			              .orient("left")
			              .innerTickSize(-(chartWidth - 100))
			              .ticks(chart_config.ticks)
			              .tickPadding(10);


			var yMaxValues = [];
			for (var i = 0; i < chart_config.seriesCols.length; i++) {
				yMaxValues.push(d3.max(chartData, function(d) {
					return d[chart_config.seriesCols[i] + "valu"];
				}));
			}
			var yMaxValue = d3.max(yMaxValues);
			var yData = [];

			for (var i = 0; i < chart_config.seriesCols.length; i++) {
				var seriCol = chart_config.seriesCols[i];
				yData.push({
					"name": chart_config.seriesNames[i],
					"values": chartData.map(function(d) {
						return {
							xcol: d[chart_config.xColName],
							value: d[seriCol + "valu"]
						}
					})
				});
			}
			
			yScale.domain([0, yMaxValue + (yMaxValue / 8)]).nice();
			xScale.domain(chartData.map(function(d) {
				return d[chart_config.xColName];
			}));


			var svg = d3.select("#viewport")
						.append("svg")
						.attr("width", chartWidth + chart_config.chartMargin.left + chart_config.chartMargin.right)
						.attr("height", chartHeight + chart_config.chartMargin.top + chart_config.chartMargin.bottom)
						.append("g")
						.attr("transform", "translate(" + chart_config.chartMargin.left + "," + chart_config.chartMargin.top + ")");

			svg.datum(chartData);

			svg.append("g")
			   .attr("class", "x axis")
			   .attr("transform", "translate(0," + chartHeight + ")")
			   .call(xAxis);

			svg.append("g")
			   .attr("class", "y axis")
			   .attr("transform", "translate(0,0)")
			   .call(yAxis);

			var line = d3.svg.line()
							 .x(function(d) {
								return xScale(d.xcol);
							 })
							 .y(function(d) {
								return yScale(d.value);
							 });


			var lines = svg.selectAll(".lines")
						   .data(yData)
						   .enter().append("g")
						   .attr("class", "lines");


			lines.append("path")
				 .attr("class", "line")
				 .attr("d", function(d) {
			 		return line(d.values);
				 })
				 .style("stroke", function(d) {
					return color(d.name) ;
				 });
			
			
			var legend = svg.selectAll(".legend")
							.data(chart_config.seriesNames)
							.enter()
							.append("g").attr("class", "legend")
							.attr("transform", function(d, i) {
								return "translate(0," + (i * 15) + ")";
							});

			legend.append("rect")
				  .attr("x", chartWidth - 80)
				  .attr("width", 11)
				  .attr("height", 11)
				  .style("fill", function(d) { return color(d);  });
			
			legend.append("text")
				  .attr("x", chartWidth - 60)
				  .attr("y", 8)
				  .style("text-anchor", "start")
				  .text( function(d) { return d;	} );

		}
		</script>
	</body>
</html>