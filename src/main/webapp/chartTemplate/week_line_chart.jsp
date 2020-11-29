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
		   z-index:100;
		}
		.axis .tick text{
    		font-size:14px;
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
		.y.axis .tick line:firstChild{
			stroke: #000;
    		opacity: 1;
		}
		
	    svg g circle {
/*                fill: #1db34f; */
/*                stroke: #16873c; */
               stroke-width: 2px
        }
		svg g path.line {
                stroke: #1db34f;
                stroke-width: 5px;
                stroke-opacity: 1;
                fill: none;
		}
		
		text.lineText, text.lineText2 { font-size: 14px; }
		.legend text { font-size:16px; }
	</style>
</head>
<body>
	<div id="viewport" style="width:500px;height:500px;"></div>
	<script type="text/javascript">
	var fullUrl = location.protocol + '//' + location.hostname + ((location.port) ? ':' + location.port : '');
	
	
	var chart_config = {
		ticks: 6,
		selectedRgnClss: 'H4',
		ctyCd : '42760',
		admiCd : '42760340',
		dataId: 'rpt-evntEff',
		thisPageId: 'rpt-evntEff-005-007',
		lastPageId: 'rpt-evntEff-005-008',
// 		pageId: 'rpt-trnd-005-002',
// 		choroColumn: 'tot_sale_amt',
		startDate: '20180120',
		endDate: '20180131',
		lastStartDate: '20171001',
		lastEndDate: '20171019',
		unit : "원",
		gubun : "",
		boxFill: "#ff0000"
	};

	var chartMargin = {
		top: 0,
		right: 15,
		bottom: 30,
		left: 70
	};


	var options = {};//phantomjs에서 활용하는 옵션
	var chartData = []; //챠트 데이터
	var targetData = [];
	var xColName = 'xcol'; //x축이름
	var seriesCols = ['ycol1', 'ycol2']; //y 계열 컬럼명
	var seriesNames =  ['1계열', '2계열']; //y 계열 이름
// 	var colorArr = [  '#828282', '#d3d3d3', '#2e6695', '#ff8166' ];//계열별 색상
	var colorArr = []; 
	var colorMap = {
			"colorArr" : [ '#ff8a4a', '#d4cebf' ],
			"colorArr_float" : ['#2ec5c5', '#d3d3d3'],
			"colorArr_amt" : ['#fe8d75', '#d3d3d3']
	};
	
	function parseDate(str) {
		var y = str.substr(0, 4),
			m = str.substr(4, 2) - 1,
			d = str.substr(6, 2);
		var D = new Date(y, m, d);
		return (D.getFullYear() == y && D.getMonth() == m && D.getDate() == d) ? D : 'invalid date';
	}

	function drawChart(options) {
		if (options) {
			d3.select('#viewport').style('width', options.width + 'px');
			d3.select('#viewport').style('height', options.height + 'px');

			chart_config = $.extend(chart_config, options);
		}
		//http://localhost:8090/onmap/public/ecnmy_trnd/pdf/data_root.json?dataId=rpt-evntEff&h3Cd=11110&startDate=20160501&endDate=20160502
		$.ajax({
			type: 'GET',
			dataType: 'json',
			url: fullUrl + '/onmap/public/ecnmy_trnd/pdf/data_root.json',
			data: {
				'dataId': chart_config.dataId,
				'h3Cd': chart_config.ctyCd,
				'ctyCd': chart_config.ctyCd,
				'admiCd': chart_config.admiCd,
				'startDate': chart_config.startDate,
				'endDate': chart_config.endDate,
				'lastStartDate': chart_config.lastStartDate,
				'lastEndDate': chart_config.lastEndDate
			},
			success: function(json) {
				var jChartArrCuYear = json[chart_config.thisPageId][0]; //입력 기간 데이터 
				var jChartArrBeYear = json[chart_config.lastPageId][0]; //전년 기간 데이터 
				
				var columOrder = ['lw3', 'lw2', 'lw1', 'term', 'aw1', 'aw2'];
				var columKr = ['3주전', '2주전', '1주전', '이벤트기간', '1주후', '2주후'];
				
				
// 				var ycol1Name = parseDate(chart_config.startDate).getFullYear() + '년';
// 				var ycol2Name = parseDate(chart_config.startDate).getFullYear() - 1 + '년';
				var ycol1Name = '선택기간';
				var ycol2Name = '비교기간';

				
				xColName = 'xcolkr'; //x축이름
				seriesCols = ['ycol1', 'ycol2']; //y 계열 컬럼 명
				seriesNames = [ycol1Name, ycol2Name]; //y 계열 이름
				
				chartData = []; //차트 데이터
// 				colorArr = [  '#ff8a4a', '#d4cebf' ];//계열별 색상
				colorArr = colorMap["colorArr" + chart_config.gubun];
				

				
				for (var co = 0 ; co < columOrder.length; co++){
					chartData.push({
						xcol: columOrder[co],
						
						xcolkr: columKr[co], //x 컬럼의 한글명
						xcolorder: co, //정렬을 위한 시퀀스
						
						ycol1Name: ycol1Name,
						ycol1valu: (jChartArrCuYear == null) ? 0 : jChartArrCuYear[columOrder[co]] , 
						
						ycol2Name: ycol2Name,
						ycol2valu: (jChartArrBeYear == null) ? 0 : jChartArrBeYear[columOrder[co]]
					});
				}

				chartData.sort(function CompareForSort(first, second) {
					return first.xcolorder - second.xcolorder;
				});
				
				targetData = $.extend(targetData,chartData);
				
				chartData.push({
					"xcol": "emp1",
					"xcolkr": "emp1",
					"xcolorder": "0",
					"ycol1Name": "emp1_1",
					"ycol1valu": "0",
					"ycol2Name": "emp1_2",
					"ycol2valu": "0"
				});
				
				chartData.unshift({
					"xcol": "emp2",
					"xcolkr": "emp2",
					"xcolorder": "0",
					"ycol1Name": "emp2_1",
					"ycol1valu": "0",
					"ycol2Name": "emp2_2",
					"ycol2valu": "0"
				});
				
				actionChart();
				document.title = 'complete';
			},
			error: function(request, status, error) {
				console.log('code:' + request.status + '\n' + 'message:' + request.responseText + '\n' + 'error:' + error);
			}
		});
	}

	function actionChart() {
		d3.select('#viewport').html('');

		var chartWidth = Number(d3.select('#viewport').style('width').replace('px', '')) - chartMargin.left - chartMargin.right;
		var chartHeight = Number(d3.select('#viewport').style('height').replace('px', '')) - chartMargin.top - chartMargin.bottom;
		
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
		
		var xScale = d3.scale.ordinal().rangePoints([0, chartWidth]);
		var yScale = d3.scale.linear().range([chartHeight , 10]);
		
		var color = d3.scale.ordinal().range(colorArr);
		
		
		var xAxis = d3.svg.axis()
					  .scale(xScale)
					  .ticks(5);
		
		var yMaxValue = d3.max(chartData, function(d) {
			return d.value;
		});
		var yAxis = d3.svg.axis()
		              .scale(yScale)
		              .orient('left')
		              .innerTickSize(-(chartWidth))
		              .ticks(chart_config.ticks)
		              .tickFormat(function(d, i){
		            	  if(i > 0) return getIndexNumber(d, true) + chart_config.unit;
		            	  else return "";
		              })
		              .tickPadding(10);


		var yMaxValues = [];
		var yMinValues = [];
		for (var i = 0; i < seriesCols.length; i++) {
			yMaxValues.push(d3.max(targetData, function(d) {
				return d[seriesCols[i] + 'valu'];
			}));
		}
		for (var i = 0; i < seriesCols.length; i++) {
			yMinValues.push(d3.min(targetData, function(d) {
				return d[seriesCols[i] + 'valu'];
			}));
		}
		
		var yMaxValue = d3.max(yMaxValues);
		var yMinValue = d3.min(yMinValues);
		var yData = [];


		for (var i = 0; i < seriesCols.length; i++) {

			var seriCol = seriesCols[i];
			yData.push({
				'name': seriesNames[i],
				'values': targetData.map(function(d) {
					return {
						xcol: d[xColName],
						value: d[seriCol + 'valu']
					}
				})
			});
		}
		
// 		yScale.domain([0, yMaxValue + (yMaxValue / 8)]).nice();
		yScale.domain([yMinValue - (yMinValue/5), yMaxValue + (yMaxValue/5)]).nice();
		xScale.domain(chartData.map(function(d) {
			return d[xColName];
		}));


		var svg = d3.select('#viewport')
			.append('svg')
			.attr('width', chartWidth + chartMargin.left + chartMargin.right)
			.attr('height', chartHeight + chartMargin.top + chartMargin.bottom);
// 			.append('g')
// 			.attr('transform', 'translate(' + chartMargin.left + ',' + chartMargin.top + ')');

		svg.datum(targetData);

		svg.append('g')
			.attr('class', 'x axis')
			.attr('transform', 'translate('+chartMargin.left+',' + (chartHeight + chartMargin.top) + ')')
			.call(xAxis);

		svg.selectAll('g.x.axis g text').each(insertLinebreaks);
		
		svg.append('g')
			.attr('class', 'y axis')
			.attr('transform', 'translate(' + chartMargin.left + ',' + chartMargin.top + ')')
			.call(yAxis);

		var line = d3.svg.line()
			.x(function(d) {
				return xScale(d.xcol);
			})
			.y(function(d) {
				return yScale(d.value);
			});


		var lines = svg.selectAll('.lines')
			.data(yData)
			.enter()
			.append('g')
			.attr('transform', 'translate(' + chartMargin.left + ',' + chartMargin.top + ')')
			.attr('class', 'lines');


		lines.append('path')
			.attr('class', 'line')
			.attr('d', function(d) {
				
				// 값이 null인 object를 array에서 빼기
				var lineValues = [];
				if(d.values.length > 0){
					for(var dv = 0 ; dv < d.values.length; dv++){
						if(d.values[dv].value) lineValues.push(d.values[dv]);
					}
				}
				
// 				console.log('value : ' ,lineValues);
// 				console.log('value : ' , d.values);
// 				return line(d.values);
				return line(lineValues);
			})
			.style('stroke', function(d) {
				return color(d.name) ;
			});
		
		 var guideline = svg.selectAll(".guideline")
				 			.data(targetData)
				      		.enter()
				      		.append("g")
				      		.attr('transform', 'translate(' + chartMargin.left + ',' + chartMargin.top + ')')
						 	.append("line")
							.attr("class", "guideline")
							.attr("x1", function(d) { return xScale(d.xcolkr); })
							.attr("y1", function(d) { 
								var result = 0;
								if(d.ycol1valu > d.ycol2valu){
									result = d.ycol1valu;
								}else{
									result = d.ycol2valu;
								}
								return yScale(result); 
							})
							.attr("x2",	function(d) { return xScale(d.xcolkr); })
							.attr("y2", chartHeight)
							.style("opacity", .7)
							.style("stroke", "lightgrey");
		
		// 선택기간 line에 dot찍기
		var dot = svg.selectAll("dot")
				 	 .data(targetData)
					 .enter()
					 .append("g")
				     .attr('transform', 'translate(' + chartMargin.left + ',' + chartMargin.top + ')')
			         .append("circle")
			         .style("fill", function(d){ return color(d.ycol1Name)})
			         .style("stroke", function(d){ return color(d.ycol1Name)})
			         .attr("r", 9)
			         .attr("cx", function(d) { return xScale(d.xcolkr); })
			         .attr("cy", function(d) { if(d.ycol1valu) return yScale(d.ycol1valu); })
			         .style("opacity", function(d){ 
			        	if(d.ycol1valu) return 1;
			        	else return 0;
			          });
	
		var valueText1 = svg.selectAll(".lineText")
						    .data(targetData)
						    .enter()
						    .append("g")
					        .attr("transform", "translate(" + chartMargin.left + "," + chartMargin.top + ")")
					        .append("text")
					        .attr("class", "lineText")
					        .attr("x", function(d){return xScale(d.xcolkr);})
					        .attr("y", function(d){
					        	var textYCol1 = 0;
					        	if(d.ycol1valu && d.ycol2valu){
					        		if(d.ycol1valu > d.ycol2valu){
						        		textYCol1 = yScale(d.ycol1valu);
						        	}else{
						        		textYCol1 = yScale(d.ycol1valu)+50;
						        	}	
					        	}else{
					        		if(d.ycol1valu) textYCol1 = yScale(d.ycol1valu);
					        	}
					        	
					        	return textYCol1;
					        })
					        .style("text-anchor", "middle")
							.attr('dy', '-1.2em')
					        .text(function(d){
					        	if(d.ycol1valu) return getIndexNumber(d.ycol1valu,false);
					        }); 
		
		// 비교기간 line에 dot찍기
		var dot2 = svg.selectAll("dot2")
				 	 .data(targetData)
					 .enter()
					 .append("g")
				     .attr('transform', 'translate(' + chartMargin.left + ',' + chartMargin.top + ')')
			         .append("circle")
			         .style("fill", function(d){ return color(d.ycol2Name)})
			         .style("stroke", function(d){ return color(d.ycol2Name)})
			         .attr("r", 9)
			         .attr("cx", function(d) { return xScale(d.xcolkr); })
			         .attr("cy", function(d) { if(d.ycol2valu) return yScale(d.ycol2valu); })
			         .style("opacity", function(d){ 
			        	if(d.ycol2valu) return 1;
			        	else return 0;
			          });
		
		var valueText2 = svg.selectAll(".lineText2")
						    .data(targetData)
						    .enter()
						    .append("g")
					        .attr("transform", "translate(" + chartMargin.left + "," + chartMargin.top + ")")
					        .append("text")
					        .attr("class", "lineText2")
					        .attr("x", function(d){return xScale(d.xcolkr);})
					        .attr("y", function(d){
					        	var textYCol2 = 0;
					        	if(d.ycol2valu && d.ycol1valu){					        		
						        	if(d.ycol2valu > d.ycol1valu){
						        		textYCol2 = yScale(d.ycol2valu);
						        	}else{
						        		textYCol2 = yScale(d.ycol2valu)+50;
						        	}
					        	}else{
					        		if(d.ycol2valu) textYCol2 = yScale(d.ycol2valu);
					        	}
					        	return textYCol2;
					        })
					        .style("text-anchor", "middle")
							.attr('dy', '-1.2em')
					        .text(function(d){
					        	if(d.ycol2valu) return getIndexNumber(d.ycol2valu,false);
					        }); 

		 
		 var pointBox = svg.selectAll("rect")
		 				   .data(yData)
		 				   .enter()
		 				   .append("g")
				      	   .attr('transform', 'translate(' + chartMargin.left + ',' + chartMargin.top + ')')
		 				   .append("rect")
		 				   .attr("class", "bar")
					       .attr("x", (xScale("이벤트기간")-(chartWidth/12)))
// 					       .attr("dx", "-20")
					       .attr("height",  chartHeight)
					       .attr("width", (chartWidth/6))
					       .style('fill', chart_config.boxFill)
					       .style('Opacity', function(d,i){
					    	   if(i > 0){
					    		   return 0.2;
					    	   }else{
					    		   return 0;
					    	   }
					    	   
					    	});
					       

		 
		var legend = svg.selectAll('.legend')
						.data(seriesNames)
						.enter()
						.append("g")
					    .attr('transform', 'translate(' + chartMargin.left  + ',' + (chartMargin.top+10) + ')')
						.append('g').attr('class', 'legend')
						.attr('transform', function(d, i) {
							return 'translate(0,' + (i * 20) + ')';
						});
	
		legend.append('rect')
			  .attr('x', chartWidth - 65)
			  .attr('width', 15)
			  .attr('height', 15)
			  .style('fill', function(d) { return color(d);  });
		
		legend.append('text')
			  .attr('x', chartWidth - 45)
			  .attr('y', 10)
			  .style('text-anchor', 'start')
			  .text( function(d) { return d;	} );

	}
	
	function getIndexNumber(num, han){
		var result = 0;
		var cnt =  Math.floor(1e-12 + Math.log(num) / Math.LN10);
		
		if(cnt < 4){  // 1000 이하일 경우
			result = num;
		}else{   // 1000 이상일 경우
			if(cnt%4 != 0){ // 만(4), 억(8), 조(12) 단위로만 표현
				cnt = 4 * Math.floor(cnt/4);
			}
			
			result = krWonRound(num,cnt,1,han);
		}
		return result;
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
		result = minus+d3.round(value/Math.pow(10,i) , pre); 
		if(han) result += prs[i]; 
		
		return  result;		
	}
	
	
	
	if(typeof window.callPhantom === 'function'){
// 		console.log('phantomjs callback');
	}else{
		$(document).ready(function(){
			drawChart();
		});
	}
	</script>
	</body>
</html>