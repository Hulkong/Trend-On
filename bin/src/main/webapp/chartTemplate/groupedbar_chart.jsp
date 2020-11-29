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
			font-size:12px;
		}
		text.barText { font-size:12px; }
	</style>
</head>
<body>
	<div id="viewport" style="width:700px;height:500px;"></div>
	<script type="text/javascript">
	var fullUrl = location.protocol+'//'+location.hostname+( (location.port)  ? ":"+location.port : '' );;
		var chart_config = {
				ticks : 4,
				selectedRgnClss : 'H4',
				ctyCd : '42760',
// 				admiCd : '46730310',
// 				admiAround : "'42760330','42760320','42760350'",
				dataId : "rpt-trnd",           // rpt-trnd          / rpt-trnd          / rpt-evntEff		  // rpt-evntEff					/ 
				pageId : "rpt-trnd-012-001",   // rpt-trnd-012-001  /rpt-trnd-012-005   / rpt-evntEff-013-005  // rpt-evntEff-013-001			/rpt-trnd-011-005
				startDate : "20160502",
				endDate : "20160504",
// 				lastStartDate : "20150502",
// 				lastEndDate : "20150504",
				gubun: "days"                    // days              / time               / time				  // days						/age
		};

	
		var chartMargin = {
				top: 10,
				right: 10,
				bottom: 30,
				left: 50
		};
		
		var groupBy = function(xs, key) {
			return xs.reduce(function(rv, x) {
				(rv[x[key]] = rv[x[key]] || []).push(x);
				return rv;
			}, {});
		};
		
		//챠트 레이아웃을 위한 데이터
		var chartData = [{
			"rootName": "6~9",
			"colnm" : "시민",
			"value": 100,
			"desc": "0",
			"color": "#000000"
		},
		{
			"rootName": "6~9",
			"colnm" : "유입인구",
			"value": 200,
			"desc": "0",
			"color": "#dfdfdf"
		},
		{
			"rootName": "9~12",
			"colnm" : "시민",
			"value": 50,
			"desc": "0",
			"color": "#000000"
		},{
			"rootName": "9~12",
			"colnm" : "유입인구",
			"value": 500,
			"desc": "0",
			"color": "#dfdfdf"
		}];
		
		var color =["#ff8a4a", "#d4cebf"];
		var xGubun = {
				"days" : ["월요일","화요일","수요일","목요일","금요일","토요일","일요일"],
				"time" : ["0~6시","6~9시","9~12시","12~15시","15~18시","18~21시","21~24시"],
				"age" : ["20대","30대","40대","50대","60대"]
		};
		
		var roots = {};//groupBy(chartData,"time");
		var category = {};//groupBy(chartData,"name");
		
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
					"admiAround": chart_config.admiAround,
					"startDate":chart_config.startDate,
					"endDate":chart_config.endDate,
					"lastStartDate" : chart_config.lastStartDate,
					"lastEndDate" : chart_config.lastEndDate
				},
				success : function(json) {
					chartData = [];
					var jChartArr = json[chart_config.pageId];
					var timeVal = xGubun[chart_config.gubun]
					if(chart_config.gubun && chart_config.gubun == 'days'){
						for(var i = 0 ; i < jChartArr.length ; i++){
							var item = jChartArr[i];
							chartData.push({
								"rootName": item.dow,
								"rootCd": timeVal.indexOf(item.dow.trim()),
								"colnm" : (item.div_cd =='E'?"유입인구":"상주인구"),
								"color" : (item.div_cd =='E'?color[0]:color[1]),
								"value": item.rate,
								"desc": "0",
							});	
							
						}
					}else if (chart_config.gubun && chart_config.gubun == 'age'){
// 						console.log(jChartArr);
					}else{
						for(var j = 0; j< jChartArr.length; j++){
							var item = jChartArr[j];
							chartData.push({
								"rootName": item.cd_nm,
								"rootCd": timeVal.indexOf(item.cd_nm.trim()),
								"colnm" : "상주인구",
								"color" : color[1],
								"value": item.h_total_cnt,
								"desc": "0",
							});	
							chartData.push({
								"rootName": item.cd_nm,
								"rootCd": timeVal.indexOf(item.cd_nm.trim()),
								"colnm" : "유입인구",
								"color" : color[0],
								"value": item.e_total_cnt,
								"desc": "0",
							});	
						}
					
					}
					
					chartData.sort(function CompareForSort(first, second) {
						var result = 0;
						if(first.colnm < second.colnm){
						 	result = -1;	
						}else if(first.colnm == second.colnm){
							result = 0;
						}else{
							result =1;
						}
						
						return result;
					});
					
					chartData.sort(function CompareForSort(first, second) {
						return first.rootCd - second.rootCd;
					});
					
					actionChart();
					document.title = 'complete';
				}
			});
		}
		
		function actionChart(){
			roots = groupBy(chartData, "rootName");
			category = groupBy(chartData, "colnm");
			var groupedXrange =[];
			for(nm in roots){
				groupedXrange.push(nm);
			}
			
			d3.select("#viewport").html("");
			
			
			var chartWidth = Number(d3.select('#viewport').style('width').replace("px", "")) - chartMargin.left - chartMargin.right;
			var chartHeight = Number(d3.select('#viewport').style('height').replace("px", "")) - chartMargin.top - chartMargin.bottom;
	
			
			var yMaxValue = d3.max(chartData, function(d){return d.value; })
			
			var y = d3.scale.linear()
				      .domain([0, yMaxValue+(yMaxValue/chart_config.ticks)])
				      .range([chartHeight, 0]);
			var x0 = d3.scale.ordinal().rangeRoundBands([ 0, chartWidth -100 ],	0.5);
		    x0.domain(d3.keys(roots));

		    
			var x1 = d3.scale.ordinal();
		    x1.domain(d3.keys(category)).rangeRoundBands([ 0, x0.rangeBand() ]);
		    
			var xAxis = d3.svg.axis()
							  .scale(x0)
							  .tickPadding(5)
							  .orient("bottom");
			
// 			var color = d3.scale.ordinal().range([  "#d3d3d3", "#ff8166", "#2e6695", "#ff8166", "#828282", "#d3d3d3" ]);
			
			var yAxis = d3.svg.axis()
							  .scale(y)
							  .orient("left")
							  .innerTickSize(-chartWidth + 100)
							  .ticks(chart_config.ticks)
							  .tickPadding(10)
							  .tickFormat(function(d){
								  return d +"%";
								
							  });
			
			var svg = d3.select("#viewport")
						.append("svg")
					    .attr("width", chartWidth + chartMargin.left + chartMargin.right)
					    .attr("height", chartHeight + chartMargin.top + chartMargin.bottom);
// 					    .append("g")
// 					    .attr("transform", "translate(" + chartMargin.left + "," + chartMargin.top + ")");
			
			svg.append("g")
			   .attr("class", "y axis")
			   .attr("transform", "translate(" + chartMargin.left + "," + chartMargin.top + ")")
			   .call(yAxis);
			
			svg.append("g")
			   .attr("class", "x axis")
			   .attr("transform", "translate(" + chartMargin.left + "," + (chartHeight + chartMargin.top) + ")")
			   .call(xAxis)			
			   .selectAll("text")
			   .style("text-anchor", "middle");
			
			
			var groupedBar = svg.selectAll(".groupedBar")
								.data(chartData)
								.enter()
								.append("g")
								.attr("transform", "translate(" + chartMargin.left + "," + chartMargin.top + ")")
								.attr("class", "g")
								.attr("transform", function(d) {
									return "translate(" + x0(d.rootName) + ",0)";
								});
			
			
			groupedBar.selectAll("rect")
					  .data(function(d) { return roots[d.rootName];  })	
					  .enter()
					  .append("g")
					  .attr("transform", "translate(" + chartMargin.left + "," + chartMargin.top + ")")
					  .append("rect")
					  .attr("width", x1.rangeBand())
					  .attr("x", function(d) { return x1(d.colnm);  })
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
					  .data(function(d) { return roots[d.rootName];  })
					  .enter()
					  .append("g")
					  .attr("transform", "translate(" + chartMargin.left + "," + chartMargin.top + ")")
					  .append("text")
					  .attr("class","barText")
					  .attr("y", function(d) { 
						 if(d.value)
						  	return y(d.value);
					  })
					  .attr("x", function(d) { return x1(d.colnm)+(x1.rangeBand()/2);})
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
// 						    	var ylegend = Number((i * 8))+Number((chartWidth/4));
						    	return "translate(0," + (i * 15) + ")"; 
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