<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!doctype html>
<html>
<head>
	<title>지역경제 모니터링(요일)</title>
	<meta charset="utf-8" />
	<script src="/js/jquery/jquery-1.11.2.min.js"></script>
	<script src="/js/d3Chart/d3.js"></script>
	<style>
 		@import url("//fonts.googleapis.com/earlyaccess/nanumgothic.css");
		body{font-family:'Nanum Gothic',NanumGothic,'Nanum gothic',"Helvetica",verdana,sans-serif;font-size:10px;}
		.axis path{
			fill: none;
			stroke: #000;
			shape-rendering: crispEdges;
		}
		.axis .tick text{
    		font-size:14px;
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
			font-size:15px;
		}
		text.barText { font-size:15px; }
	</style>
</head>
<body>
	<div id="viewport" style="width:700px;height:500px;"></div>
	<script type="text/javascript">
	var fullUrl = location.protocol+'//'+location.hostname+( (location.port)  ? ":"+location.port : '' );;
		var chart_config = {
				ticks : 4,
				selectedRgnClss : 'H4',
				ctyCd : '47170',
// 				admiCd : '46730310',
// 				admiAround : "'42760330','42760320','42760350'",
				dataId : "rpt-new-trnd",           // rpt-trnd          / rpt-trnd          / rpt-evntEff		  // rpt-evntEff					/ 
				pageId : "rpt-new-trnd-008-009",   // rpt-trnd-012-001  /rpt-trnd-012-005   / rpt-evntEff-013-005  // rpt-evntEff-013-001			/rpt-trnd-011-005
				startDate : "20200602",
				endDate : "20200610",
// 				lastStartDate : "20150502",
// 				lastEndDate : "20150504",
				unit: "%"
		};

	
		var chartMargin = { top: 10, right: 30, bottom: 30, left: 50 };
		
		var groupBy = function(xs, key) {
			return xs.reduce(function(rv, x) {
				(rv[x[key]] = rv[x[key]] || []).push(x);
				return rv;
			}, {});
		};
		
		//챠트 레이아웃을 위한 데이터
		var chartData = [{
			"name": "6~9",
			"groupname" : "시민",
			"value": 100,
			"desc": "0",
			"color": "#000000"
		}];
		
		
		var roots = {};//groupBy(chartData,"rootName");
		var category = {};//groupBy(chartData,"colnm");
		
		var options = {};
		function drawChart(options){
			if(options){
                d3.select('#viewport').style('width', options.width + "px");
                d3.select('#viewport').style('height', options.height + "px");
                
                chart_config = $.extend(chart_config,options);
			}

			getData(function(data){
				chartData = dataSort(data);
				actionChart();
				document.title = 'complete';
			});

		}
		
		function getData(callback){
			$.ajax({
				type : "GET",
				dataType : 'json',
				url : fullUrl+"/onmap/public/ecnmy_trnd/pdf/data_root.json",
				data : {
					"dataId" : chart_config.dataId,
					"h3Cd": chart_config.ctyCd,
					"ctyCd": chart_config.ctyCd,
					"admiCd": chart_config.admiCd,
					"admiAround": chart_config.admiAround,
					"startDate":chart_config.startDate,
					"endDate":chart_config.endDate,
					"lastStartDate" : chart_config.lastStartDate,
					"lastEndDate" : chart_config.lastEndDate
				},
				success : function(json) {
					if(callback) callback(json[chart_config.pageId]);
				}
			});
		}
		
		function dataSort(chartData){
			chartData.sort(function CompareForSort(first, second) {
				var result = 0;
				if(first.groupname_order < second.groupname_order){
				 	result = -1;	
				}else if(first.groupname_order == second.groupname_order){
					result = 0;
				}else{
					result =1;
				}
				
				return result;
			});
			
			chartData.sort(function CompareForSort(first, second) {
				return first.rootCd - second.rootCd;
			});
			
			return chartData;
		}
		
		function actionChart(){
			roots = groupBy(chartData, "name");
			category = groupBy(chartData, "groupname");
			var groupedXrange =[];
			for(nm in roots){
				groupedXrange.push(nm);
			}
			
			d3.select("#viewport").html("");
			
			
			var chartWidth = Number(d3.select('#viewport').style('width').replace("px", "")) - chartMargin.left - chartMargin.right;
			var chartHeight = Number(d3.select('#viewport').style('height').replace("px", "")) - chartMargin.top - chartMargin.bottom;
	
			
			// Scale
			var yMaxValue = d3.max(chartData, function(d){return d.value; })
			
			var y = d3.scale.linear()
				      .domain([0, yMaxValue+(yMaxValue/chart_config.ticks)])
				      .range([chartHeight, 0]);
			var x0 = d3.scale.ordinal().rangeRoundBands([ 0, chartWidth -100 ],	0.5);
		    x0.domain(d3.keys(roots));

			var x1 = d3.scale.ordinal();
		    x1.domain(d3.keys(category)).rangeRoundBands([ 0, x0.rangeBand() ]);
		    
		    // Axis
			var xAxis = d3.svg.axis()
							  .scale(x0)
							  .tickPadding(5)
							  .orient("bottom");
			
			var yAxis = d3.svg.axis()
							  .scale(y)
							  .orient("left")
							  .innerTickSize(-chartWidth + 100)
							  .ticks(chart_config.ticks)
							  .tickPadding(10)
							  .tickFormat(function(d){
								  return d + chart_config.unit;
								
							  });
			
			// 그래프 생성 시작
			var svg = d3.select("#viewport")
						.append("svg")
					    .attr("width", chartWidth + chartMargin.left + chartMargin.right)
					    .attr("height", chartHeight + chartMargin.top + chartMargin.bottom);
			
			// y축 추가
			svg.append("g")
			   .attr("class", "y axis")
			   .attr("transform", "translate(" + chartMargin.left + "," + chartMargin.top + ")")
			   .call(yAxis);
			
			// x축 추가
			svg.append("g")
			   .attr("class", "x axis")
			   .attr("transform", "translate(" + chartMargin.left + "," + (chartHeight + chartMargin.top) + ")")
			   .call(xAxis)			
			   .selectAll("text")
			   .style("text-anchor", "middle");
			
			// group으로 묶일 그래프의 영역 loop 시작
			var groupedBar = svg.selectAll(".groupedBar")
								.data(chartData)
								.enter()
								.append("g")
								.attr("transform", "translate(" + chartMargin.left + "," + chartMargin.top + ")")
								.attr("class", "g")
								.attr("transform", function(d) {
									return "translate(" + x0(d.name) + ",0)";
								});
			
			// bar 추가
			groupedBar.selectAll("rect")
					  .data(function(d) { return roots[d.name];  })	
					  .enter()
					  .append("g")
					  .attr("transform", "translate(" + chartMargin.left + "," + chartMargin.top + ")")
					  .append("rect")
					  .attr("width", x1.rangeBand())
					  .attr("x", function(d) { return x1(d.groupname);  })
					  .attr("y", function(d) { 
						 if(d.value)
						  	return y(d.value)-0.5;  
					  })
					  .attr("height", function(d) { 
						 if(d.value)
						  	return chartHeight - y(d.value); 
					  })
					  .style("fill", function(d) { return d.color;  })
					  .attr("opacity", 1);
			
			groupedBar.selectAll('.barText')
					  .data(function(d) { return roots[d.name];  })
					  .enter()
					  .append("g")
					  .attr("transform", "translate(" + chartMargin.left + "," + chartMargin.top + ")")
					  .append("text")
					  .attr("class","barText")
					  .attr("y", function(d) { 
						 if(d.value)
						  	return y(d.value);
					  })
					  .attr("x", function(d) { return x1(d.groupname)+(x1.rangeBand()/2);})
					  .style("text-anchor", "middle")
					  .attr('dx', '-0.05em')
					  .attr('dy', '-0.35em')
					  .style("opacity",0.5)
					  .text(function(d){
						  if(d.value)
							return (d.value).toFixed(1);
					  });
			
			
			var legendArr = [];
			for ( var colnm in category) {
				legendArr.push({
					"name" : colnm,
					"color" : category[colnm][0].color
				});
			}
			
			var legend = svg.selectAll(".legend")
						    .data(legendArr)
						    .enter()
						    .append("g")
			  				.attr("transform", "translate(" + chartMargin.left + "," + chartMargin.top + ")")
						    .append("g")
						    .attr("class", "legend")
						    .attr("transform", function(d, i) { 
						    	return "translate(0," + (i * 20) + ")"; 
						    });
	
				legend.append("rect")
					  .attr("x", chartWidth - 80)
					  .attr("width", 11)
					  .attr("height", 11)
					  .style("fill", function(d){return d.color;})
				 	  .style("opacity", 1);
				
				legend.append("text")
				      .attr("x", chartWidth - 60)
				      .attr("y", 8)
				      .style("text-anchor", "start")
				      .text(function(d){return d.name;});
			
		}
	</script>
	</body>
</html>