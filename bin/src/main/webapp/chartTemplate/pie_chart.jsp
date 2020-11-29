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

		
		.arc text {
			text-anchor: middle;
		}
		.arc path {
			stroke: #fff;
		}
	</style>
</head>
<body>
	<div id="viewport" style="width:332px;height:332px;"></div>
	<script type="text/javascript">
	var fullUrl = location.protocol+'//'+location.hostname+( (location.port)  ? ":"+location.port : '' );;
		var chart_config = {
				selectedRgnClss : 'H4',
                ctyCd : '11680',
//	                admiCd : '11680660',
                dataId: 'rpt-trnd',					// rpt-evntEff           / rpt-trnd
                pageId: 'rpt-trnd-008-001',			// rpt-evntEff-009-002   / rpt-trnd-008-001
//	                choroColumn : "total_cnt",				
                startDate : "20190119",
                endDate : "20190127",
				ticks : 6,
				chartMargin : { top: 0, right: 0, bottom: 0, left: 0 },
				colorArr : [ '#d4cebf', '#ff8a4a' ],
				innerRadius: 64,
				outerRadius: 124
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
		}];
		
		
		var options = {};
		function drawChart(options){
			if(options){
                d3.select('#viewport').style('width', options.width + "px");
                d3.select('#viewport').style('height', options.height + "px");
                
                options.outerRadius = (options.height/2);
                options.innerRadius = ((options.height/2)- 80);
                console.log(options.height,options.outerRadius, options.innerRadius);
                chart_config = $.extend(chart_config,options);
                
			}
			document.title = 'drawChart start!!';
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
					"endDate":chart_config.endDate,
					"lastStartDate" : chart_config.lastStartDate,
					"lastEndDate" : chart_config.lastEndDate
				},
				success : function(json) {
					var jChartArr = json[chart_config.pageId];
// 					var jChartArr = [{"code":"E","total_cnt":160032,"rate":97.1},{"code":"H","total_cnt":4835,"rate":2.9}];
// 					var jChartArr = [{"h_rate":9.0,"total_cnt":3480587,"e_cnt":3168471,"e_rate":91.0,"h_cnt":312116}]
					chartData = [];
					
					if(chart_config.dataId == 'rpt-evntEff'){
						for(var i = 0;i< jChartArr.length;i++){
							var item = jChartArr[i];
							chartData.push({
								"name": item.code,
								"value": Number(item.rate),
								"total_cnt": Number(item.total_cnt)
							});	
						}
					}else{
						if(jChartArr.length > 0){							
							for(var j = 0;j< 2;j++){
								var item = jChartArr[0];
								var name = (j == 0 ? 'e': 'h');
								chartData.push({
									"name": name.toUpperCase(),
									"value": Number(item[name+"_rate"]),
									"total_cnt": Number(item[name+"_cnt"])
								});	
							}
						}
					}

					
					// 유입인구 먼저로 순서 변경
					chartData.sort(function (a,b){
						 return a.name > b.name ? -1 : a.name < b.name ? 1 : 0;

					});
					
					actionChart();
					
					setTimeout(function(){
						document.title = 'complete';
					},300);
				},
				error : function(request,status,error){
					console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
				}
			});
			
		}
		
		function actionChart(){
			d3.select("#viewport").html("");
			var chartWidth = Number(d3.select('#viewport').style('width').replace("px", "")) - chart_config.chartMargin.left - chart_config.chartMargin.right;
			var chartHeight = Number(d3.select('#viewport').style('height').replace("px", "")) - chart_config.chartMargin.top - chart_config.chartMargin.bottom;
			
			var color = d3.scale.ordinal().range(chart_config.colorArr);
			
			var chart = d3.select("#viewport")
						  .append("svg")
						  .attr("width", chartWidth + chart_config.chartMargin.left + chart_config.chartMargin.right)
						  .attr("height", chartHeight + chart_config.chartMargin.top + chart_config.chartMargin.bottom)
						  .append("g")
						  .attr("transform", "translate(" + chart_config.outerRadius + "," + chart_config.outerRadius + ")");
			
			var arc = d3.svg.arc()
			                .innerRadius(chart_config.innerRadius)
			                .outerRadius(chart_config.outerRadius);
			
			var pie = d3.layout.pie().value(function(d){ return d.value;})
			
			var arcs = chart.selectAll(".arc")
							.data(pie(chartData))
							.enter()
						  	.append("g")
							.attr("class", "arc");
			
			arcs.append("path")
				.attr("d", arc)
				.attr("fill", function(d){ return color(d.value)});
			
			arcs.append("text")
				.attr("transform", function(d){ return "translate(" + arc.centroid(d) + ")"; })
				.style("font-size", "12px")
				.text(function(d) { 
					return d.data.value+"%";
			});
			arcs.append("text")
				.attr("transform", function(d){ return "translate(" + arc.centroid(d) + ")"; })
				.attr("dy",15)
				.style("font-size", "12px")
				.text(function(d) { 
// 					console.log(d.data);
					return "(" + getIndexNumber(d.data.total_cnt,2,true) + "명)";
			});
				 
			
			var legendArr = [
				{name : "상주인구" , color: '#d4cebf'},
				{name : "유입인구" , color: '#ff8a4a'}
			]; 
			var legend = chart.selectAll(".legend")
						.data(legendArr)
						.enter()
						.append("g")
						.attr( "transform", "translate(" + (-chart_config.outerRadius - 80 - 50 ) + "," + (-10) + ")")
						.append("g").attr("class", "legend")
						.attr("transform", function(d, i) {
							return "translate(0," + (i * 15) + ")";
						});
			
			legend.append("rect")
				  .attr("x", chartWidth - 90)
				  .attr("width", 10)
				  .attr("height", 10)
				  .style("fill", function(d) { 
					  return d.color;  
				  })
				  .style('opacity', 1);
			
			legend.append("text")
				  .attr("x", chartWidth - 75)
				  .attr("y", 6)
				  .style("font-size", "12px")
				  .style("text-anchor", "start")
				  .text( function(d) { return d.name;	} );
			
			
			 
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