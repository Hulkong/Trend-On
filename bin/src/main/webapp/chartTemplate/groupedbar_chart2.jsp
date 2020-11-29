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
		.x.axis .tick text{
    		font-size:11px;
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
		text.barText { font-size:8px; }
	</style>
</head>
<body>
	<div id="viewport" style="width:700px;height:500px;"></div>
	<script type="text/javascript">
	var fullUrl = location.protocol+'//'+location.hostname+( (location.port)  ? ":"+location.port : '' );;
		var chart_config = {
				ticks : 4,
				selectedRgnClss : 'H4',
				ctyCd : '11110',
				dataId : "rpt-trnd",           // rpt-trnd          
				pageId : "rpt-trnd-005-002",   // rpt-trnd-005-002
				startDate : "20160602",
				endDate : "20160704",
				unit: '원',
				choroColumn : "tot_sale_amt",
				gubun: "month"                    // month				
		};

	
		var chartMargin = {
				top: 50,
				right: 10,
				bottom: 80,
				left: 60
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
		
		var color =["#d4cebf", "#ff8a4a"];
		var roots = {};//groupBy(chartData,"time");
		var category = {};//groupBy(chartData,"name");
		var xGubn = []
		
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
					if(chart_config.gubun && chart_config.gubun == 'month'){
						var dataLen = jChartArr.length;
							// 데이터 수가 24개가 아니면 뒤에 나오는 12개 내에서만 출력
						if(jChartArr.length < 24){
							// bar chart 그리기
							chartData = setBarData(jChartArr);
							sortArr(chartData);
							actionBarChart();
						}else{
							// 데이터 수가 24개 이상이면 범례사용
							var bar_type = [
								jChartArr[0].cd_nm.substr(0,4)+"년"+	jChartArr[0].cd_nm.substr(4,2)+"월 "+"~"+jChartArr[11].cd_nm.substr(0,4)+"년"+	jChartArr[11].cd_nm.substr(4,2)+"월",
								jChartArr[12].cd_nm.substr(0,4)+"년"+	jChartArr[12].cd_nm.substr(4,2)+"월 "+"~"+jChartArr[23].cd_nm.substr(0,4)+"년"+	jChartArr[23].cd_nm.substr(4,2)+"월"
							];
							chartData = setGroupedData(jChartArr, bar_type);
							sortArr(chartData);
							actionChart();
						}
					}
						
					document.title = 'complete';
				}
			});
		}
		
		function sortArr(chartData){
			// 정렬
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
		}
		
		function setGroupedData(jChartArr, bar_type){
			var chartData = [];
			for(var i = 0 ; i < jChartArr.length ; i++){
				var item = jChartArr[i];
				var gbn = 0;
				if(i > 11) gbn =1;
				chartData.push({
					"rootName": item.cd_nm.substr(4,2)+'월',
					"rootCd": (gbn == 0 ? (i+1) : (i-11)),
					"colnm" : bar_type[gbn],	// 년도 가르는 날짜 필요
					"color" : color[gbn],
					"value": item[chart_config.choroColumn],
					"desc": "0",
				});	
			}
			return chartData;
		}
		
		function setBarData(jChartArr){
			chartData = [];
			var idx = 0;
			if(jChartArr.length > 12){
				idx = 	jChartArr.length - 12;
			}
			for(idx; idx< jChartArr.length; idx++){
				
					var item = jChartArr[idx];
					var xcol = item.cd_nm;
					if(chart_config.pageId == 'rpt-trnd-005-002'){
						xcol = xcol.substr(0,4)+"년 "+xcol.substr(4)+"월"
					}
					chartData.push({
						"name": xcol,
						"value": Number(item[chart_config.choroColumn]),
						"color": "#ff8a4a"
					});	
				
			}
			return chartData;
		}
		
		// 그룹바 차트 그리기
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
			var x0 = d3.scale.ordinal().rangeRoundBands([ 0, chartWidth ],	0.3);
		    x0.domain(d3.keys(roots));

		    
			var x1 = d3.scale.ordinal();
		    x1.domain(d3.keys(category)).rangeRoundBands([ 0, x0.rangeBand() ]);
		    
			var xAxis = d3.svg.axis()
							  .scale(x0)
							  .orient("bottom");
			
// 			var color = d3.scale.ordinal().range([  "#d3d3d3", "#ff8166", "#2e6695", "#ff8166", "#828282", "#d3d3d3" ]);
			
			var yAxis = d3.svg.axis()
							  .scale(y)
							  .orient("left")
							  .innerTickSize(-chartWidth )
							  .ticks(chart_config.ticks)
							  .tickPadding(10)
							  .tickFormat(function(d){
								  var tCnt =  Math.floor(1e-12 + Math.log(d) / Math.LN10);
									if(tCnt == 8 || tCnt == 12){
										return  getIndexNumber(d, 2, true);
									}else{
										return  getIndexNumber(d, 1, true);
									}
								  return d +chart_config.unit;
								
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
						  	return y(d.value);  
					  })
					  .attr("height", function(d) { 
						 if(d.value)
						  	return chartHeight - y(d.value); 
					  })
					  .style("fill", function(d) { return d.color;  })
					  .attr("opacity", 0.5);
			
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
						  if(d.value){
							  var tCnt =  Math.floor(1e-12 + Math.log(d.value) / Math.LN10);
								if(tCnt == 8 || tCnt == 12){
									return  getIndexNumber(d.value, 2, false);
								}else{
									return  getIndexNumber(d.value, 1, false);
								}							  
// 							return (d.value).toFixed(1);
						  }
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
			  				.attr("transform", "translate(" + chartMargin.left + "," + (chartMargin.top/2) + ")")
						    .append("g")
						    .attr("class", "legend")
						    .attr("transform", function(d, i) { 
// 						    	var ylegend = Number((i * 8))+Number((chartWidth/4));
						    	return "translate(-20,0)"; 
						    });
	
				legend.append("rect")
					  .attr("x", function(d,i){
						  return (chartWidth/3 * (i+1) -80) ;
					  })
					  .attr("width", 11)
					  .attr("height", 11)
					  .style("fill", function(d){return d.color;})
				 	  .style("opacity", 0.5);
				
				legend.append("text")
				      .attr("x", function(d, i){
				    	  
				    	return (chartWidth/3 * (i+1) -60);  
				      })
				      .attr("y", 8)
				      .style("text-anchor", "start")
				      .text(function(d){return d.name;});
			
		}
		
		function actionBarChart(){
			d3.select("#viewport").html("");
			
			
			var chartWidth = Number(d3.select('#viewport').style('width').replace("px", "")) - chartMargin.left - chartMargin.right;
			var chartHeight = Number(d3.select('#viewport').style('height').replace("px", "")) - chartMargin.top - chartMargin.bottom;
			chartMargin.top = 15;
			
			// Scale
			var x = d3.scale.ordinal()
					  .rangeRoundBands([0,chartWidth], .5)
					  .domain(chartData.map(function(d){ return d.name; }));

			var yMax = d3.max(chartData, function(d){return d.value; });
			
			var y = d3.scale.linear()
					  .range([chartHeight, 0])
					  .domain([0, yMax + (yMax / 10 ) ]);

			// Axis
			var xAxis = d3.svg.axis()
							  .scale(x)
							  .orient("bottom");
			
			var yAxis = d3.svg.axis().scale(y).orient("left")
									 .innerTickSize(-chartWidth)
									 .ticks(chart_config.ticks)
									 .tickFormat(function(d){
										 return getIndexNumber(d,1,true)+"원";
									 })
									 .tickPadding(10);
									 
			
			var chart = d3.select("#viewport")
						  .append("svg")
						  .attr("width", chartWidth + chartMargin.left + chartMargin.right)
						  .attr("height", chartHeight + chartMargin.top + chartMargin.bottom);
// 						  .append("g")
// 						  .attr("transform", "translate(" + chartMargin.left + "," + chartMargin.top + ")");
			
			// x Axis
			chart.append("g")
			     .attr("class", "x axis")
			     .attr("transform", "translate(" + chartMargin.left + "," + (chartHeight +  chartMargin.top)  + ")")
// 			     .attr("transform", "translate(0," + chartHeight + ")")
			     .call(xAxis)
				 .selectAll("text")				 
// 			     .style("text-anchor", "middle")
			     .style("text-anchor", "end")
			     .attr("dx", "0em")
			     .attr("dy", "0em")
			     .attr("transform", "rotate(-25)" );
			  
			// y Axis
			chart.append("g")
			     .attr("class", "y axis")
			     .attr("transform", "translate(" + chartMargin.left + "," + chartMargin.top + ")")
			     .call(yAxis); 
			
			// draw column
			chart.selectAll(".bar")
			     .data(chartData)
			     .enter()
			     .append('g')
			     .attr("transform", "translate(" + chartMargin.left + "," + chartMargin.top + ")")
			     .append("rect")
			     .attr("class", "bar")
			     .attr("x", function(d) { return x(d.name); })
			     .attr("y", function(d) { return y(d.value); })
			     .attr("height", function(d) { return chartHeight - y(d.value); })
			     .attr("width", x.rangeBand())
			     .style('fill', function(d) {  return d.color;	})
			     .style('opacity', 1);
			
			chart.selectAll('.barText')
				 .data(chartData)
				 .enter()
				 .append("g")
				 .attr("transform", "translate(" + chartMargin.left + "," + chartMargin.top + ")")
				 .append("text")
				 .attr("class","barText")
				 .attr("y", function(d) { return y(d.value);})
				 .attr("x", function(d) { return x(d.name)+(x.rangeBand()/2);})
				 .style("text-anchor", "middle")
// 				 .attr('dx', '1em')
				 .attr('dy', '-0.35em')
				 .text(function(d){
					var tCnt =  Math.floor(1e-12 + Math.log(d.value) / Math.LN10);
					if(tCnt == 8 || tCnt == 12){
						return  getIndexNumber(d.value, 2, false);
					}else{
						return  getIndexNumber(d.value, 1, false);
					}
				 });
				 
			 
		}
		
		function getIndexNumber(num, precision, han){
			var cnt =  Math.floor(1e-12 + Math.log(num) / Math.LN10);
			
			if(cnt < 4){  // 1000 이하일 경우
				result = num;
			}else{   // 1000 이상일 경우
				if(cnt%4 != 0){ // 만(4), 억(8), 조(12) 단위로만 표현
					cnt = 4 * Math.floor(cnt/4);
				}
			}
			return krWonRound(num,cnt,precision,han);
		}
		
		function krWonRound(value,index,precision,han){
			var result = "";
			
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
			
			result = minus+(value/Math.pow(10,i)).toFixed(pre);
			if(han) result += prs[i];
			
			return result;		
		}
	</script>
	</body>
</html>
