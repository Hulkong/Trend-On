<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!doctype html>
<html>
<head>
	<title>지역경제 모니터링</title>
	<meta charset="utf-8" />
	<script src="/js/d3Chart/d3.js"></script>
	<style>
 		@import url("//fonts.googleapis.com/earlyaccess/nanumgothic.css");
		text {
		  font: 11px "Nanum Gothic";
		}
		
		.axis text {
		  font: 11px "Nanum Gothic";
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
	</style>
</head>
<body>
	<div id="viewport" style="width:500px;height:500px;"></div>
	<script type="text/javascript">
		var total_data = {
			"name": "전체<br/>소비금액",
			"value": 28817,
			"desc": "지역시민<br/>소비금액 비율<br/>55.2%",
			"color": "#595959"
		};
		var target_data = {
			"name": "유입인구<br/>소비금액",
			"value": 12913,
			"desc": "유입인구<br/>소비금액 비율<br/>44.8%",
			"color": "#FF5050"
		};
		var chartMargin = {
				top: 20,
				right: 20,
				bottom: 70,
				left: 70
		};
		var options = {
				"to" : total_data,
				"ta" : target_data,
				"ma" : chartMargin
		};

	
	
	
	
	
	
		function drawChart(options) {
			
			if(options){
                total_data = options.to;
                target_data = options.ta;
                chartMargin = options.ma;
			}
			d3.select("#viewport").html("");
			//챠트 레이아웃을 위한 데이터
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
			chartData.unshift(target_data);
			chartData.unshift(total_data);
			
			
			var chartWidth = Number(d3.select('#viewport').style('width').replace("px", "")) - chartMargin.left - chartMargin.right;
			var chartHeight = Number(d3.select('#viewport').style('height').replace("px", "")) - chartMargin.top - chartMargin.bottom;
	
	
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
	
			var yAxis = d3.svg.axis().scale(yScale).orient("left").ticks(10);
	
			var svg = d3.select("#viewport")
						.append("svg").attr("width",chartWidth + chartMargin.left + chartMargin.right)
						.attr("height", chartHeight + chartMargin.top + chartMargin.bottom)
						.append("g")
						.attr("transform","translate(" + chartMargin.left + "," + chartMargin.top + ")");
	
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
			   .call(xAxis);
			
			svg.selectAll('g.x.axis g text').each(insertLinebreaks);
			//y 축
			svg.append("g")
				.attr("class", "y axis")
				.call(yAxis)
				.append("text")
				.attr("transform", "translate(60,-20)")
				.attr("y", 6)
				.attr("dy",".71em")
				.style("text-anchor", "end")
				.text("(단위: 원)");
	
			//전체 데이터의 시작화살표
			svg.append("svg:defs").append("svg:marker")
				.attr("id", "triangleAstart")
				.attr("refX", 6)
				.attr("refY", 6)
				.attr("markerWidth", 30)
				.attr("markerHeight", 30)
				.attr("orient", "270")
				.append("path").attr("d","M 0 0 12 6 0 12 3 6")
				.style("fill", total_data.color);
			//전체 데이터의 종료화살표
			svg.append("svg:defs").append("svg:marker")
				.attr("id", "triangleAend")
				.attr("refX", 6)
				.attr("refY", 6)
				.attr("markerWidth", 30)
				.attr("markerHeight", 30)
				.attr("orient", "auto")
				.append("path").attr("d", "M 0 0 12 6 0 12 3 6")
				.style("fill",total_data.color);
			//대상 데이터의 시작화살표
			svg.append("svg:defs").append("svg:marker")
				.attr("id", "triangleBstart")
				.attr("refX", 6)
				.attr("refY", 6)
				.attr("markerWidth", 30)
				.attr("markerHeight", 30)
				.attr("orient", "270")
				.append("path").attr("d","M 0 0 12 6 0 12 3 6")
				.style("fill", target_data.color);
			//대상 데이터의 종료화살표
			svg.append("svg:defs").append("svg:marker")
				.attr("id", "triangleBend")
				.attr("refX", 6)
				.attr("refY", 6)
				.attr("markerWidth", 30)
				.attr("markerHeight", 30)
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
				.attr("y1",	yScale(target_data.value) + 6)
				.attr("x2",	xScale("emp1") + (xScale.rangeBand() / 2))
				.attr("y2",	chartHeight - 6).style("stroke", target_data.color)
				.attr("marker-start", "url(#triangleBstart)")
				.attr("marker-end",	"url(#triangleBend)");
	
			//대상 데이터의 수직 line(화살표)
			svg.append("line").attr("class", "guideline")
				.attr("x1",	xScale("emp1") + (xScale.rangeBand() / 2))
				.attr("y1",	yScale(total_data.value) + 6)
				.attr("x2",	xScale("emp1") + (xScale.rangeBand() / 2))
				.attr("y2",	yScale(target_data.value) - 6)
				.style("stroke", total_data.color)
				.attr("marker-start", "url(#triangleAstart)")
				.attr("marker-end",	"url(#triangleAend)");
	
			//전체 데이터의 비율text
			svg.append("text")
				.data([total_data.desc])
				.attr("id",	"rectA")
				.attr("fill", total_data.color)
				.attr("x",xScale("emp1") + (xScale.rangeBand()))
				.attr("y",yScale(total_data.value) + 50).each(function(d) {
						var arr = d.split("<br/>");
						for (i = 0; i < arr.length; i++) {
							d3.select(this).append("tspan").text(arr[i]).attr("dy",
								i ? "1.2em" : 0).attr("x",
								xScale("emp1") + (xScale.rangeBand())).attr(
								"class", "tspan" + i);
						}
				});
			//대상 데이터의 비율text
			svg.append("text")
				.data([target_data.desc])
				.attr("id",	"rectB")
				.attr("fill", target_data.color)
				.attr("x", xScale("emp1") + (xScale.rangeBand()))
				.attr("y", yScale(target_data.value) + 50).each(function(d) {
					var arr = d.split("<br/>");
					for (i = 0; i < arr.length; i++) {
						d3.select(this).append("tspan").text(arr[i]).attr("dy",
							i ? "1.2em" : 0).attr("x",
							xScale("emp1") + (xScale.rangeBand())).attr(
							"class", "tspan" + i);
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
	
			
	
	
	
		}
	</script>
	</body>
</html>