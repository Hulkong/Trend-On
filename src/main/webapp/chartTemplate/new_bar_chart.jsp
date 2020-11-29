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
		body{font-family:'Nanum Gothic',NanumGothic,'Nanum gothic',"Helvetica",verdana,sans-serif;font-size:12px;}
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
		text.barText { font-size:12px; }
	</style>
</head>
<body>
	<div id="viewport" style="width:500px;height:500px;"></div>
	<script type="text/javascript">
		var fullUrl = location.protocol+'//'+location.hostname+( (location.port)  ? ":"+location.port : '' );;
		var chart_config = {
				ticks:6,
				selectedRgnClss : 'H4',
				ctyCd : '47170',
				dataId : "rpt-new-evntEff",
				pageId : "rpt-new-evntEff-012-006",	//경제 트렌드 (6page) - 업종별 거래금액    //rpt-trnd-007-002  // rpt-trnd-005-002
				choroColumn : "sale_amt",    // SALE_AMT   // tot_sale_amt
				startDate : "20200612", 
				endDate : "20200615",
				unit:"원",
// 				lastStartDate : "20200605",
// 				lastEndDate : "20200608",
// 				admiCd : "47170690",
// 				admiAround : "'47170250','47170510','47170555','47170585','47170360','47170370','47170600','47170650','47170660'",
				
		};
	
		var chartMargin = {	top: 10, right: 10, bottom: 60, left: 80 };
		
		
		//챠트 레이아웃을 위한 데이터
		var chartData = [];
		
		var options = {};
		function drawChart(options){
			if(options){
                d3.select('#viewport').style('width', options.width + "px");
                d3.select('#viewport').style('height', options.height + "px");
                
                chart_config = $.extend(chart_config,options);                
			}
			
			document.title = 'drawChart start!!';
			
			getData(function(data) {
					
					for(var i = 0;i< data.length;i++){
						var item = data[i];
						chartData.push({
							"name": item.cd_nm,
							"value": Number(item[chart_config.choroColumn]),
							"color": item.color
						});	
						
					}
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
					"h3Cd" : chart_config.ctyCd,
					"ctyCd" : chart_config.ctyCd,
					"admiCd" : chart_config.admiCd,
					"startDate" : chart_config.startDate,
					"endDate" : chart_config.endDate,
					"lastStartDate" : chart_config.lastStartDate,
					"lastEndDate" : chart_config.lastEndDate
				},
				success : function(json) {
					if(callback) callback(json[chart_config.pageId]);	
				},
				error : function(request,status,error){
					console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
				}
			});
		}
		
		function actionChart(){
			
			// 영역 지정
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
			
			// Scale
			var x = d3.scale.ordinal()
					  .rangeRoundBands([0,chartWidth], .7)
					  .domain(chartData.map(function(d){ return d.name; }));

			var yMax = d3.max(chartData, function(d){return d.value; });
			var yMin = d3.min(chartData, function(d){return d.value; });
			
			var y = d3.scale.linear()
					  .range([chartHeight, 0])
					  .domain([(yMin/2), (yMax+(yMax/10))]);

			// Axis
			var xAxis = d3.svg.axis()
							  .scale(x)
							  .tickPadding(15)
							  .orient("bottom");
			
			var yAxis = d3.svg.axis().scale(y).orient("left")
									 .innerTickSize(-chartWidth)
									 .ticks(chart_config.ticks)
									 .tickFormat(function(d){
										 if(chart_config.unit =="")
											 return d+chart_config.unit;
										 else
										 	return getIndexNumber(d,1,true)+chart_config.unit;
									 })
									 .tickPadding(10);
									 
			// 그래프 생성 시작
			var chart = d3.select("#viewport")
						  .append("svg")
						  .attr("width", chartWidth + chartMargin.left + chartMargin.right)
						  .attr("height", chartHeight + chartMargin.top + chartMargin.bottom);
			
			// x축 추가
			chart.append("g")
			     .attr("class", "x axis")
			     .attr("transform", "translate(" + chartMargin.left + "," + (chartHeight +  chartMargin.top)  + ")")
			     .call(xAxis)
				 .selectAll("text")
				 .style("font-size","14px");
			
			chart.selectAll('g.x.axis g text').each(insertLinebreaks);
			
			// y축 추가
			chart.append("g")
			     .attr("class", "y axis")
			     .attr("transform", "translate(" + chartMargin.left + "," + chartMargin.top + ")")
			     .style("font-size","14px")
			     .call(yAxis); 
			
			// bar도형 추가
			chart.selectAll(".bar")
			     .data(chartData)
			     .enter()
			     .append('g')
			     .attr("transform", "translate(" + chartMargin.left + "," + chartMargin.top + ")")
			     .append("rect")
			     .attr("class", "bar")
			     .attr("x", function(d) { return x(d.name); })
			     .attr("y", function(d) { return y(d.value)-0.5; })
			     .attr("height", function(d) { return chartHeight - y(d.value); })
			     .attr("width", x.rangeBand())
			     .style('fill', function(d) {  return d.color;	})
			     .style('opacity', 1);
			
			// bar 도형 위에 숫자 추가
			chart.selectAll('.barText')
				 .data(chartData)
				 .enter()
				 .append("g")
				 .attr("transform", "translate(" + chartMargin.left + "," + chartMargin.top + ")")
				 .append("text")
				 .attr("class","barText")
				 .style("font-size","12px")
				 .attr("y", function(d) { return y(d.value);})
				 .attr("x", function(d) { return x(d.name)+(x.rangeBand()/2);})
				 .style("text-anchor", "middle")
				 .attr('dy', '-0.35em')
				 .text(function(d){
					var tCnt =  Math.floor(1e-12 + Math.log(d.value) / Math.LN10);
					if(chart_config.unit == "" ){
						return d.value;
				 	}else{
				 		if(tCnt == 8 || tCnt == 12){
							return  getIndexNumber(d.value, 2, false);
						}else{
							return  getIndexNumber(d.value, 1, false);
						}	
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