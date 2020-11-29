<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!doctype html>
<html>
<head>
	<title>지역경제 모니터링 (계절에 따른 수평바)</title>
	<meta charset="utf-8" />
	<script src="/js/jquery/jquery-1.11.2.min.js"></script>
	<script src="/js/d3Chart/d3.js"></script>
	<style>
 		@import url("//fonts.googleapis.com/earlyaccess/nanumgothic.css");
		body{font-family:'Nanum Gothic',NanumGothic,'Nanum gothic',"Helvetica",verdana,sans-serif;font-size:10px;}
		
		text {
		  font-size: 14px;
		}
		
		.x.axis .tick  text{
		  font-size: 14px;
		}
		
		.axis path{
		  fill: none;
		  stroke: #000;
		  shape-rendering: crispEdges;
		}
		.y.axis .tick text{
    		font-size:14px;
		}
		.y.axis line {
		  fill: none;
		  stroke: #000;
		   shape-rendering: crispEdges;
		}
		.guideline {
			stroke-width: 0.7;
			shape-rendering: crispEdges;
		}
		.x.axis .tick line{
			stroke: lightgrey;
    		opacity: 0.7;
		}
		.x.grid .tick line{
			stroke: lightgrey;
    		opacity: 0.7;
		}
		
		text.barText { font-size:12px; }
	</style>
</head>
<body>
	<div id="viewport" style="width:568px;height:273px;"></div>
	<script type="text/javascript">
	var fullUrl = location.protocol+'//'+location.hostname+( (location.port)  ? ":"+location.port : '' );;
		var chart_config = {
				selectedRgnClss : 'H4',
				ctyCd : '11680',
				dataId : "rpt-trnd",
				pageId : "rpt-trnd-005-003",		
				choroColumn : "tot_sale_amt",
				startDate : "20190929",
				endDate : "20191003",
				colorCd : '#ffd5a7',
				unit: '원',
				ticks : 6
		};
		
		
// 		var color = {
// 				"max" : "#00a9cc",
// 				"spe" : "#005480"
// 		}
		
		var chartMargin = {
				top: 30,
				right: 20,
				bottom: 30,
				left: 90
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
					"ctyCd": chart_config.ctyCd,
					"admiCd": chart_config.admiCd,
					"startDate" : chart_config.startDate,
					"endDate" : chart_config.endDate
				},
				success : function(json) {
					var jChartArr = json[chart_config.pageId];
					var season = {"봄":"1","여름":"2","가을":"3","겨울":"4"};
					chartData = [];
					for(var i = 0;i< jChartArr.length;i++){
						var item = jChartArr[i];
						chartData.push({
							"name": item.stdr_qt,
							"value": Number(item[chart_config.choroColumn]),
							"text": item.stdr_yy,
							"order": season[item.stdr_qt.trim()], 
							"color": "#000000"
						});	
						
					}
					chartData.sort(function(a,b){
						return b.order - a.order;
					});
					
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
			var xDominMax = xMax + (xMax - xMin)/chart_config.ticks;
 			var xDominMin = xMin/2;
// 			var xDominMin = xMin - (xMin / 100 );
			
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
							  .ticks(chart_config.ticks)
							  .orient("bottom")
// 							  .innerTickSize(-chartHeight)
							  .tickSize(-chartHeight,0,0)
							  .tickPadding(15)
							  .tickFormat(function(d){
// 								  var ff = d3.format(",");
// 			       			      var midValue = (d / 100000000).toFixed(1);
// 			       	 		      var result = 0;
// 			       			      if(midValue.indexOf(".") != -1){
// 			       			    	 midValue = midValue.split(".");
// 			       			    	 result = ff(midValue[0])+"."+midValue[1];
// 			       			      }else{
// 			       			    	result = ff(midValue); 
// 			       			      }
			       			   
// 			       				return result;

			       				return getIndexNumber(d,1,true) + chart_config.unit;
								
							  });
			
			var yAxis = d3.svg.axis()
							  .scale(y)
							  .orient("left")
							  .tickFormat(function(d, i){
								  return  d;
							  })
							  .tickSize(5, 0, 0)
							  .tickPadding(10);
							 
			
			var chart = d3.select("#viewport")
						  .append("svg")
						  .attr("width", chartWidth + chartMargin.left + chartMargin.right)
						  .attr("height", chartHeight + chartMargin.top + chartMargin.bottom);
					
			// x Axis
			chart.append("g")
			   .attr("class", "x axis")
			   .attr("transform", "translate(" + chartMargin.left + "," + (chartHeight +chartMargin.top) + ")")
			   .call(xAxis);
			     
			// y Axis
			chart.append("g")
			   .attr("class", "y axis")
			   .attr("transform", "translate(" + chartMargin.left + "," + chartMargin.top + ")")
			   .call(yAxis);
			
			chart.select(".y.axis")
			   .selectAll("text")
			   .attr('dy', '-0.32em')
			   .append("tspan")
			   .attr('x','-15')
			   .attr('dy', '15')
			   .text(function(d,i){ 
				   var yyText = chartData[i].text;
				   if(chartData[i].text.indexOf("~") != -1){
					   var arrText = chartData[i].text.split("~")
					   yyText = arrText[0];
					}
				   return yyText ; 
				});
			chart.select(".y.axis")
			   .selectAll("text")
			   .attr('dy', '-0.32em')
			   .append("tspan")
			   .attr('x','-15')
			   .attr('dy', '15')
			   .text(function(d,i){ 
				   var yyText ="";
				   if(chartData[i].text.indexOf("~") != -1){
					   var arrText = chartData[i].text.split("~")
					   yyText = "~"+arrText[1];
					}
				   return yyText ; 
				});
			
// 			var bar = chart.selectAll("g")
// 						   .data(chartData)
// 			               .enter()
// 			               .append("g")
// 			               .attr("transform", "translate(" + chartMargin.left + "," + chartMargin.top + ")");

			
			
			chart.selectAll(".bar")
			     .data(chartData)
			     .enter()
			     .append("g")
				 .attr("transform", "translate(" + chartMargin.left + "," + chartMargin.top + ")")
			     .append("rect")
			     .attr("class", "bar")
			     .attr("y", function(d) { return y(d.name); })
			     .attr("x","0.5px")
			     .attr("height",y.rangeBand())
			     .attr("width", function(d) { return x(d.value); })
			     .style('fill', function(d){return chart_config.colorCd; })
			     .style('opacity', 1);
			
			chart.selectAll(".barText")
			     .data(chartData)
			     .enter()
			     .append("g")
				 .attr("transform", "translate(" + chartMargin.left + "," + chartMargin.top + ")")
			     .append("text")
			     .attr("class","barText")
		    	 .attr("y",function(d,i) {
		    	  	 return (y(d.name) + (y.rangeBand()/2)); 
		    	 })
				 .attr("x", function(d) { return x(d.value)/2; })
		    	 .style("fill","#333")
		    	 .style("text-anchor", "middle")
		    	 .attr('dy', '.35em')
			     .text(function(d){
			    	 var tCnt = Math.floor(1e-12 + Math.log(d.value) / Math.LN10);
			    	 if(tCnt == 8 || tCnt == 12){			    		 
		    	   		return getIndexNumber(d.value,1,false);
			    	 }else{
		    	   		return getIndexNumber(d.value,1,false);
			    	 }
		    	});


		}
		
		function getIndexNumber(num,precision, han){
			var result = 0;
			var cnt =  Math.floor(1e-12 + Math.log(num) / Math.LN10);
			
			if(cnt < 4){  // 1000 이하일 경우
				result = num;
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
			if(value == 0 ) return 0;
			
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
			var prs = ["일","십","백","천","만","십만","백만","천만","억","십억","백억","천억","조"];
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
