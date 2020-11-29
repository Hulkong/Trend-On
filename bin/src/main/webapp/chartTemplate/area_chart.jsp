<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!doctype html>
<html>
<head>
	<title>지역경제 모니터링</title>
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
		.tick text{
    		font-size:6px;
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
               fill: #bf6f31;
               stroke: #bf6f31;
               stroke-width: 0px
        }
		svg g path.line {
                stroke: #bf6f31;
                stroke-width: 1px;
                stroke-opacity: 1;
                fill: none;
		}
		.guideline {
			stroke-width: 1;
			shape-rendering: crispEdges;
		}
		
		text.lineText { font-size: 6px; }
	</style>
</head>
<body>
	<div id="viewport" style="width:800px;height:200px;"></div>
	<script type="text/javascript">
	var fullUrl = location.protocol+'//'+location.hostname+( (location.port)  ? ":"+location.port : '' );;
		var chart_config = {
				ticks:6,
				selectedRgnClss : 'H4',
				ctyCd : '11680',
				dataId : "rpt-trnd",
				pageId : "rpt-trnd-007-004",
				choroColumn : "rate",
				startDate : "20170929",
				endDate : "20171003"
		};
		
		var chartMargin = {
				top: 20,
				right: 35,
				bottom: 30,
				left: 60
		};
		
		
		//챠트 레이아웃을 위한 데이터
		var chartData = [{
			"name": "emp1",
			"code": 0,
			"value": 0,
			"color": "#000000"
		}, {
			"name": "emp4",
			"code": 0,
			"value": 0,
			"color": "#000000"
		}, {
			"name": "emp3",
			"code": 0,
			"value": 0,
			"color": "#000000"
		}, {
			"name": "emp5",
			"code": 0,
			"value": 0,
			"color": "#000000"
		}];
		
		var targetData = [{
			"name": "emp1",
			"code": 0,
			"value": 0,
			"color": "#000000"
		}, {
			"name": "emp4",
			"code": 0,
			"value": 0,
			"color": "#000000"
		}];
		
		var options = {};
		function drawChart(options){
			if(options){
                d3.select('#viewport').style('width', options.width + "px");
                d3.select('#viewport').style('height', options.height + "px");
                
                chart_config = $.extend(chart_config,options);
			}
			$.ajax({
				type : "GET",
				dataType : 'json',
				url : fullUrl+"/onmap/public/ecnmy_trnd/pdf/data_root.json",
				data : {
					"dataId" : chart_config.dataId,
					"h3Cd": chart_config.ctyCd,
					"ctyCd": chart_config.ctyCd,
					"admiCd": chart_config.admiCd,
					"startDate":chart_config.startDate,
					"endDate":chart_config.endDate
				},
				success : function(json) {
					var timeVal = ["0~6시","6~9시","9~12시","12~15시","15~18시","18~21시","21~24시"];
					var jChartArr = json[chart_config.pageId];
					
					chartData = [];
					targetData = [];
					for(var i = 0;i< jChartArr.length;i++){
						var item = jChartArr[i];
						chartData.push({
							"code": item.code,
							"name": item.cd_nm,
							"value": Number(item[chart_config.choroColumn]),
							"color": "#000000"
						});	
						
					}
					
					chartData.sort(function CompareForSort(first, second) {
						return first.code - second.code;
					});
					
					targetData = $.extend(targetData,chartData);
					
					chartData.push({
						"name": "emp1",
						"code": 0,
						"value": 0,
						"color": "#000000"
					});
					
					chartData.unshift({
						"name": "emp0",
						"code": 0,
						"value": 0,
						"color": "#000000"
					});
					
					actionChart();
					document.title = 'complete';
				},
				error : function(request,status,error){
					console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
				}
			});
			
			

			
		}
		
		function actionChart(){
			d3.select("#viewport").html("");
			
			
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
			
			var y = d3.scale.linear().range([chartHeight, 0]);
			
			var x = d3.scale.ordinal().rangePoints([0,chartWidth]);
			var xAxis = d3.svg.axis()
						      .scale(x)
						      .ticks(5);

			
			var yMaxValue = d3.max(chartData, function(d) { return d.value; });
			var yAxis = d3.svg.axis()
							  .scale(y)
							  .orient("left")
							  .innerTickSize(-chartWidth)
							  .ticks(chart_config.ticks)
							  .tickPadding(10)
							  .tickFormat(function(d){
								  return d+"%";
												
							  });
			
			var line = d3.svg.area()
						     .x(function(d) { return x(d.name); })
						     .y(function(d) { return y(d.value); })
						     .interpolate("cardinal");
			
// 			var interpolateTypes = ['linear','step-before','step-after','basis','basis-open','basis-closed','bundle','cardinal','cardinal-open','cardinal-closed','monotone'];
			
			var svg = d3.select("#viewport")
						.append("svg")
						.attr("width", chartWidth + chartMargin.left + chartMargin.right)
						.attr("height", chartHeight + chartMargin.top + chartMargin.bottom);
// 						.append("g")
// 						.attr("transform", "translate(" + chartMargin.left + "," + chartMargin.top + ")");

			  y.domain([0, yMaxValue + (yMaxValue / 8 )]).nice();
			  x.domain(chartData.map(function(d){ return d.name; }));
			  svg.datum(targetData);

			 var xGr = svg.append("g")
			      		  .attr("class", "x axis")
			      		  .attr("transform", "translate(" + chartMargin.left + "," + (chartHeight + chartMargin.top) + ")")
			      		  .call(xAxis);
			 
			 svg.selectAll('g.x.axis g text').each(insertLinebreaks);
			 
			  svg.append("g")
			     .attr("class", "y axis")
			     .attr("transform", "translate(" + chartMargin.left + "," + chartMargin.top + ")")
			     .call(yAxis);

			  var linePath = svg.append("g")
	            				.attr("transform", "translate(" + chartMargin.left + "," + chartMargin.top + ")")
			  					.append("path")
			      				.attr("class", "line")
			      				.x(function (d) {
									return x(d.name);
								})
								.y0(chartHeight)
								.y1(function (d) {
									return y(d.value);
								});
// 			      				.attr("d", line);
			  
			  
// 			 svg.selectAll(".guideline")
// 			 	.data(targetData)
// 	            .enter()
// 	            .append("g")
// 	            .attr("transform", "translate(" + chartMargin.left + "," + chartMargin.top + ")")
// 			 	.append("line")
// 				.attr("class", "guideline")
// 				.attr("x1", function(d) { return x(d.name); })
// 				.attr("y1", function(d) { return y(d.value); })
// 				.attr("x2",	function(d) { return x(d.name); })
// 				.attr("y2", chartHeight)
// 				.style("opacity", .7)
// 				.style("stroke", "lightgrey");
			  
			  svg.selectAll("dot")
	             .data(targetData)
	             .enter()
	             .append("g")
	             .attr("transform", "translate(" + chartMargin.left + "," + chartMargin.top + ")")
	             .append("circle")
	             .attr("r", 4.5)
	             .attr("cx", function(d) { return x(d.name); })
	             .attr("cy", function(d) { return y(d.value); });
			  
			  svg.selectAll(".lineText")
			     .data(targetData)
			     .enter()
			     .append("g")
	             .attr("transform", "translate(" + chartMargin.left + "," + chartMargin.top + ")")
	             .append("text")
	             .attr("class", "lineText")
	             .attr("y", function(d){return y(d.value)-4;})
	             .attr("x", function(d){return x(d.name);})
	             .style("text-anchor", "middle")
				 .attr('dy', '-1.2em')
	             .text(function(d){
	            	 return (d.value).toFixed(1);
	             });
		}
		
		function getIndexNumber(num, precision){
			var result = 0;
			var cnt =  Math.floor(1e-12 + Math.log(num) / Math.LN10);
			
			if(cnt < 4){  // 1000 이하일 경우
				result = num;
			}else{   // 1000 이상일 경우
				if(cnt%4 != 0){ // 만(4), 억(8), 조(12) 단위로만 표현
					cnt = 4 * Math.floor(cnt/4);
				}
				
				result = krWonRound(num,cnt,precision);
			}
			return result;
		}
		
		function krWonRound(value,index,precision){
			
			if(value == 0 )
				return 0;
			var prs = ["일","십","백","천","만","십만","백만","천만","억","십억","백억","천억","조"];
			var i = 0;
			var pre = 0;
			var minus = "";
			if(precision) pre = precision;
			if (value < 0){
				value *= -1;
				minus = "-"
			} 
			
			if(index) {
				if(index < prs.length) i = index;
				else i = prs.length - 1;
			}else{
				i = 1 + Math.floor(1e-12 + Math.log(value) / Math.LN10);
				i--;
			}
			if(prs.length < i) i = prs.length;
			return minus+d3.round(value/Math.pow(10,i) , pre) + prs[i];		
		}
		
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