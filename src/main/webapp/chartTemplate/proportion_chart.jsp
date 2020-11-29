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
	</style>
</head>
<body>
	<div id="viewport" style="width:500px;height:500px;">
	
	
	
	</div>
	<script type="text/javascript">
		var total_data = {
			"name": "전체<br/>소비금액",
			"value": 28817,
			"desc": "상주인구<br/>소비금액 비율<br/>55.2%",
			"color": "#9e968d"
		};
		var target_data = {
			"name": "유입인구<br/>소비금액",
			"value": 12913,
			"desc": "유입인구<br/>소비금액 비율<br/>44.8%",
			"color": "#e28864"
		};
		var chartMargin = {
				top: 5,
				right: 5,
				bottom: 50,
				left: 80
		};
		var options = {
				"to" : total_data,
				"ta" : target_data,
				"ma" : chartMargin
		};

	
	
	
	
		var data_config = {
				ticks : 6,
				ctyCd : '42760',
// 				admiCd : '42760340',
// 				dataId : "rpt-evntEff",
// 				pageId : "rpt-evntEff-011-003",
				choroColumn : "sale_amt",
				startDate : "20181001",
				endDate : "20181009",
				total_color: "#9e968d",
				target_color: "#e28864",
// 				columSep : "amt"
			};
			
		var vColumns = { 
			"amt":{
				 totName : "tot_sale_amt"
				,tarName : "sale_amt"
				,desc : "소비금액"
				,totRate : "rate1"
				,tarRate : "rate2"
				,unitSep : "원"
			},
			"cnt":{
				 totName : "tot_sale_cnt"
				,tarName : "sale_cnt"
				,desc : "거래량"
				,totRate : "rate3"
				,tarRate : "rate4"
				,unitSep : "건"
			}
		};
		function drawChart(options) {
			
			if(options){
// 				data_config.columSep = options.sep;
                d3.select('#viewport').style('width', options.width + "px");
                d3.select('#viewport').style('height', options.height + "px");
                
                data_config = $.extend(data_config,options);
			}
			
			$.ajax({
				type : "GET",
				dataType : 'json',
				url : "/onmap/public/ecnmy_trnd/pdf/data_root.json",
				data : {
					"dataId" : data_config.dataId,
					"h3Cd" : data_config.ctyCd,
					"ctyCd" : data_config.ctyCd,
					"admiCd" : data_config.admiCd,
					"startDate" : data_config.startDate,
					"endDate" : data_config.endDate,
					"lastStartDate" : data_config.lastStartDate,
					"lastEndDate" : data_config.lastEndDate
				},
				success : function(json) {"전체<br/>소비금액"
					
					total_data.name = "전체<br/>"+vColumns[data_config.columSep].desc;
					target_data.name = "유입인구<br/>"+vColumns[data_config.columSep].desc;
					
					
					total_data.value = json[data_config.pageId][0][vColumns[data_config.columSep].totName];
					target_data.value = json[data_config.pageId][0][vColumns[data_config.columSep].tarName];
					
					total_data.desc = "상주인구<br/>"+vColumns[data_config.columSep].desc+" 비율<br/>"+json[data_config.pageId][0][vColumns[data_config.columSep].tarRate]+"%"   ;
					target_data.desc = "유입인구<br/>"+vColumns[data_config.columSep].desc+" 비율<br/>"+ json[data_config.pageId][0][vColumns[data_config.columSep].totRate]+"%";
					
					total_data.color = data_config.total_color;
					target_data.color = data_config.target_color;

					data_config.unitSep = vColumns[data_config.columSep].unitSep;
					actionChart();
				}
			});
		}
		
		
		function actionChart(){
			d3.select("#viewport").html("");
			//챠트 레이아웃을 위한 데이터
			var chartData = [{
				"name": "emp1",
				"value": "0",
				"desc": "0",
				"color": "#000000"
			}
			, {
				"name": "emp2",
				"value": "0",
				"desc": "0",
				"color": "#000000"
			}
// 			, {
// 				"name": "emp3",
// 				"value": "0",
// 				"desc": "0",
// 				"color": "#000000"
// 			}
			];
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
			var xScale = d3.scale.ordinal().rangeRoundBands([0, chartWidth], .6);
	
			var yScale = d3.scale.linear().range([chartHeight, 0]);
	
			var yMax = d3.max(chartData, function(d) {
				return d.value;
			});
	
			var xAxis = d3.svg.axis().scale(xScale).tickPadding(5);
	
			var yAxis = d3.svg.axis()
							  .scale(yScale)
							  .orient("left")
							  .ticks(data_config.ticks)
							  .innerTickSize(-chartWidth)
							  .tickPadding(5)
							  .tickFormat(function(d){
								  return getIndexNumber(d)+vColumns[data_config.columSep].unitSep;
								
							  });
	
			var svg = d3.select("#viewport")
						.append("svg")
						.attr("width",chartWidth + chartMargin.left + chartMargin.right)
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
			   .style("font-size","14px")
			   .call(xAxis);
			
			svg.selectAll('g.x.axis g text').each(insertLinebreaks);
			//y 축
			svg.append("g")
				.attr("class", "y axis")
				.style("font-size","14px")
				.call(yAxis)
// 				.append("text")
// 				.attr("transform", "translate(0,-20)")
// 				.attr("y", 6)
// 				.attr("dy",".71em")
// 				.style("text-anchor", "end")
// 				.style("font-size","8px")
// 				.text("(단위: "+data_config.unitSep+")");
	
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
// 				.attr("fill", total_data.color)
				.attr("fill", "#635e5b")
				.attr("x",xScale("emp1") + (xScale.rangeBand()))
				.attr("y",((yScale(target_data.value) - yScale(total_data.value))/2)+yScale(total_data.value)-10 )
				.each(function(d) {
						var arr = d.split("<br/>");
						for (i = 0; i < arr.length; i++) {
							d3.select(this).append("tspan")
// 										   .text(arr[i]).attr("dy", i ? "1.2em" : 0)
										   .text(arr[i]).attr("dy", "1.2em")
										   .style("font-size","14px")
										   .style("color","#635e5b")
										   .attr("x", xScale("emp1") + (xScale.rangeBand()))
										   .attr("class", "tspan" + i);
						}
				});
			//대상 데이터의 비율text
			svg.append("text")
				.data([target_data.desc])
				.attr("id",	"rectB")
				.attr("fill", target_data.color)
				.attr("x", xScale("emp1") + (xScale.rangeBand()))
				.attr("y", ((chartHeight - yScale(target_data.value))/2)+yScale(target_data.value)-10 )
				.each(function(d) {
					var arr = d.split("<br/>");
					for (i = 0; i < arr.length; i++) {
						d3.select(this).append("tspan")
									   .text(arr[i])
									   .attr("dy",i ? "1.2em" : 0)
									   .style("font-size","14px")
									   .attr("x",xScale("emp1") + (xScale.rangeBand()))
									   .attr("class", "tspan" + i);
					}
				});
			
			//전체 , 대상의 bar chart
			svg.selectAll("bar")
				.data(chartData)
				.enter()
				.append("rect")
				.style(	"fill",	function(d) {return d.color;})
				.attr("x", function(d) {return xScale(d.name);})
// 				.attr("width", "20px")
				.attr("width", xScale.rangeBand())
				.attr("y", function(d) {return yScale(d.value);})
				.attr("height", function(d) {return chartHeight - yScale(d.value);})
				.style('opacity', 1);
			
			
			document.title = 'complete';
	
		}
		
		function getIndexNumber(num){
			var result = 0;
			var cnt =  Math.floor(1e-12 + Math.log(num) / Math.LN10);
			
			if(cnt < 4){  // 1000 이하일 경우
				result = num;
			}else{   // 1000 이상일 경우
				if(cnt%4 != 0){ // 만(4), 억(8), 조(12) 단위로만 표현
					cnt = 4 * Math.floor(cnt/4);
				}
				
				result = krWonRound(num,cnt,1);
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
				i = index;
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