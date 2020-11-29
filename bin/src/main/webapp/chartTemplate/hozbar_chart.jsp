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
		
		text {
		  font: 14px;
		  font-weight:200;
		}
		
		.y.axis line {
 		  fill: none; 
 		  stroke: lightgrey; 
 		  opacity: 1; 
  		  shape-rendering: crispEdges; 
		}
		.axis .tick text{
    		font-size:14px;
		}
		.guideline {
			stroke-width: 1;
			shape-rendering: crispEdges;
		}
		.y.axis .tick line{
			stroke: #000;
    		opacity: 0.5;
		}
		
		.x.axis .tick line{
			stroke: lightgrey;
    		opacity: 1;
		}
		
		.axis path{
		  fill: none;
		  stroke: #000;
		  shape-rendering: crispEdges;
		}
		text.barText { font-size:12px; }
	</style>
</head>
<body>
	<div id="viewport" style="width:568px;height:440px;"></div>
	<script type="text/javascript">
	var fullUrl = location.protocol+'//'+location.hostname+( (location.port)  ? ":"+location.port : '' );;
		var chart_config = {
				selectedRgnClss : 'H4',
				sep : 'max',	              // max               / spe               / eSpe                  / eMax
				ctyCd : '46230',
// 				admiCd : '46230515',
				dataId : "rpt-trnd",          // rpt-trnd          / rpt-trnd          / rpt-evntEff          / rpt-evntEff
				pageId : "rpt-trnd-011-001",  // rpt-trnd-011-001  / rpt-trnd-011-002  / rpt-evntEff-006-001  / rpt-evntEff-006-002 
				startDate : "20180915",
				endDate : "20180917",
// 				lastStartDate : "20170915",
// 				lastEndDate : "20170917",
				ticks : 4
		};
		
		var vColumns = {
				"max" : {
					colName : "cd_nm",
					valCol : "chart_sale_amt",
					color : "#ffbb72",
					unit : "원"
				},
				"spe" : {
					colName : "cd_nm",
					valCol : "rate",
					color : "#ff9d68",
					unit : ""
				},
				"eMax" : {
					colName : "cd_nm",
					valCol : "rate",
					color : "#ffbb72",
					unit : "%"
				},
				"eSpe" : {
					colName : "cd_nm",
					valCol : "rate",
					color : "#ff9d68",
					unit : "%"
				}
		}
		
// 		var vTitle = {
// 				"max" : "최다 소비업종",
// 				"spe" : "특화 소비업종"
// 		}
		
// 		var color = {
// 				"spe" : "",
// 				"max" : "#005480",
// 				"mRate" : "#005480"
// 		}
		
		var chartMargin = {
				top: 30,
				right: 10,
				bottom: 0,
				left: 120
		};
		
		
		//챠트 레이아웃을 위한 데이터
		var chartData = [{
			"name": "emp1",
			"value": 100,
			"desc": "0",
			"color": "#000000"
		}, {
			"name": "emp2",
			"value": 1000,
			"desc": "0",
			"color": "#333333"
		}, {
			"name": "emp3",
			"value": 500,
			"desc": "0",
			"color": "#dfdfdf"
		}];
		
		var options = {};
		function drawChart(options){
			if(options){
//                 chart_config.sep = options.sep;
//                 d3.select('#viewport').style('width', options.width + "px");
//                 d3.select('#viewport').style('height', options.height + "px");
                
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
					"h3Cd" : chart_config.ctyCd,
					"ctyCd" : chart_config.ctyCd,
					"admiCd" : chart_config.admiCd,
					"admiAround" : chart_config.admiAround,
					"startDate" : chart_config.startDate,
					"endDate" : chart_config.endDate,
					"lastStartDate" : chart_config.lastStartDate,
					"lastEndDate" : chart_config.lastEndDate
				},
				success : function(json) {
					var jChartArr = json[chart_config.pageId];
					chartData = [];
					for(var i = 0;i< jChartArr.length;i++){
						var item = jChartArr[i];
						chartData.push({
							"name": item[vColumns[chart_config.sep].colName],
							"value": Number(item[vColumns[chart_config.sep].valCol]),
							"color": "#000000"
						});	
						
					}
					chartData.reverse();
					actionChart();
					document.title = 'complete';
				}
			});

			
		}
		
		function actionChart(){
			d3.select("#viewport").html("");
			
			
			var chartWidth = Number(d3.select('#viewport').style('width').replace("px", "")) - chartMargin.left - chartMargin.right;
			var chartHeight = Number(d3.select('#viewport').style('height').replace("px", "")) - chartMargin.top - chartMargin.bottom;
			
			var xMax = d3.max(chartData, function(d){return d.value; });
			var xMin = d3.min(chartData, function(d){return d.value; });
			
			
			var xDominMin = xMin - (xMax- xMin)/chart_config.ticks;
			if(xMin > 0) xDominMin = 0;
			var xDominMax = xMax + (xMax- xMin)/chart_config.ticks;
			if(xMax < 0) xDominMax = 0;
		
			
			// Scale
			var x = d3.scale.linear()
					  .range([0,chartWidth])
					  .domain([xDominMin, xDominMax]);
			
			var y = d3.scale.ordinal()
					  .rangeRoundBands([chartHeight, 0],0.5)
					  .domain(chartData.map(function (d) {return d.name; }));
			
			// Axis
			var xAxis = d3.svg.axis()
							  .scale(x)
							  .ticks(4)
							  .orient("top")
							  .tickSize(-chartHeight,0,0)
							  .tickPadding(10)
							  .tickFormat(function(d){
								  return getIndexNumber(d,0,true) + vColumns[chart_config.sep].unit;
								
							  });
			
			var yAxis = d3.svg.axis()
							  .scale(y)
							  .orient("left")
							  .tickSize(5, 0, 0)
							  .tickPadding(10);
							 
			
			var chart = d3.select("#viewport")
						  .append("svg")
						  .attr("width", chartWidth + chartMargin.left + chartMargin.right)
						  .attr("height", chartHeight + chartMargin.top + chartMargin.bottom)
// 						  .append("g")
// 						  .attr("transform", "translate(" + chartMargin.left + "," + chartMargin.top + ")");
			
			// x Axis
			chart.append("g")
			     .attr("class", "x axis")
			     .attr("transform", "translate(" + chartMargin.left + "," + chartMargin.top + ")")
			     .style("font-size", "14px")
			     .call(xAxis);
			  
			// y Axis
			chart.append("g")
			     .attr("class", "y axis")
				 .attr("transform", "translate(" + chartMargin.left + "," + chartMargin.top + ")")
				 .style("font-size", "14px")
			     .call(yAxis); 
			
			// draw column
			chart.selectAll(".bar")
			     .data(chartData)
			     .enter()
			     .append("g")
				 .attr("transform", function(d){
					 transValue = "";
					 if(d.value < 0){
						 transValue = "translate(" + (chartMargin.left + x(0) + x(0) - x(Math.abs(d.value))) + "," + chartMargin.top + ")"
					 }else{
						 transValue = "translate(" + (chartMargin.left + x(0)) + "," + chartMargin.top + ")";
					 }
					return transValue; 
				 })
			     .append("rect")
			     .attr("class", "bar")
			     .attr("y", function(d) { return y(d.name); })
			     .attr("x","1px")
			     .attr("height",y.rangeBand())
			     .attr("width", function(d) {
			    	 return x(Math.abs(d.value))- x(0); 
			     })
			     .style('fill', function(d){return vColumns[chart_config.sep].color; })
			     .style('opacity', 1);
			
			
			chart.selectAll("barText")
				 .data(chartData)
			     .enter()
			     .append("g")
				 .attr("transform", "translate(" + chartMargin.left + "," + chartMargin.top + ")")
			     .append("text")
			     .attr("class","barText")
		    	 .attr("y",function(d,i) {
		    	  	 return (y(d.name) + (y.rangeBand()/2)); 
		    	 })
				 .attr("x", function(d) { return (x(0)+x(d.value))/2; })
		    	 .style("fill","#333")
		    	 .style("font-size", "12px")
		    	 .style("text-anchor", "middle")
		    	 .attr('dy', '.35em')
			     .text(function(d){
			    	 var tCnt = Math.floor(1e-12 + Math.log(d.value) / Math.LN10);
			    	 if(tCnt == 8 || tCnt == 12){
				    	 return getIndexNumber(d.value,2,false);
			    	 }else{	    		 
				    	 return getIndexNumber(d.value,1,false);
			    	 }
			     });
				 

		}
		
		function getIndexNumber(num,precision,han){
			var result = 0;
			var minus = "";
			if (num < 0){
				num *= -1;
				minus = "-"
			} 
			
			var cnt =  Math.floor(1e-12 + Math.log(num) / Math.LN10);
			
			if(cnt < 4){  // 1000 이하일 경우
				result = minus + num;
			}else{   // 1000 이상일 경우
				if(cnt%4 != 0){ // 만(4), 억(8), 조(12) 단위로만 표현
					cnt = 4 * Math.floor(cnt/4);
				}
				
				result = krWonRound(num,cnt,precision,han);
			}
			return result;
		}
		
		function krWonRound(value,index,precision,han){
			var result = "";
			
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
			result = minus+(value/Math.pow(10,i)).toFixed(pre);
			if(han) result += prs[i];
			return result;
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