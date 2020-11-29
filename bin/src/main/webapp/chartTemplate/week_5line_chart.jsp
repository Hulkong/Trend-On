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
		.y.axis .tick line{
			stroke: lightgrey;
    		opacity: 0.7;
		}
		
	    svg g circle {
               fill: #1db34f;
               stroke: #16873c;
               stroke-width: 2px
        }
		svg g path.line {
                stroke: #1db34f;
                stroke-width: 2px;
                stroke-opacity: 1;
                fill: none;
		}
	</style>
</head>
<body>
	<div id="viewport" style="width:500px;height:500px;"></div>
	<script type="text/javascript">
	var fullUrl = location.protocol + '//' + location.hostname + ((location.port) ? ":" + location.port : '');
	
	
	var chart_config = {
		ticks: 6,
		selectedRgnClss: 'H4',
		ctyCd: '11110',
		dataId: "rpt-evntEff",
// 		pageId: "rpt-trnd-006-004",
// 		choroColumn: "tot_sale_amt",
		startDate: "20160606",
		endDate: "20160607"
	};

	var chartMargin = {
		top: 20,
		right: 20,
		bottom: 30,
		left: 100
	};


	var options = {};//phantomjs에서 활용하는 옵션
	var chartData = []; //챠트 데이터
	var xColName = "xcol"; //x축이름
	var seriesCols = ["ycol1", "ycol2", "ycol3", "ycol4", "ycol5"]; //y 계열 컬럼명
	var seriesNames =  ["1계열", "2계열", "3계열", "4계열", "5계열"]; //y 계열 이름
	var colorArr = [  "#828282", "#d3d3d3", "#2e6695", "#ff8166", "#ff0000" ];//계열별 색상
	
	function parseDate(str) {
		var y = str.substr(0, 4),
			m = str.substr(4, 2) - 1,
			d = str.substr(6, 2);
		var D = new Date(y, m, d);
		return (D.getFullYear() == y && D.getMonth() == m && D.getDate() == d) ? D : 'invalid date';
	}

	function drawChart(options) {
		if (options) {
			d3.select('#viewport').style('width', options.width + "px");
			d3.select('#viewport').style('height', options.height + "px");

			chart_config = $.extend(chart_config, options);
		}

		//http://localhost:8080/onmap/public/ecnmy_trnd/pdf/data_root.json?dataId=rpt-evntEff&h3Cd=11110&startDate=20160501&endDate=20160502
		$.ajax({
			type: "GET",
			dataType: 'json',
			url: fullUrl + "/onmap/public/ecnmy_trnd/pdf/data_root.json",
			data: {
				"dataId": chart_config.dataId,
				"h3Cd": chart_config.ctyCd,
				"ctyCd": chart_config.ctyCd,
				"admiCd": chart_config.admiCd,
				"startDate": chart_config.startDate,
				"endDate": chart_config.endDate
			},
			success: function(json) {
				
				var jChartArr = json["rpt-evntEff-007-003"];
				
				console.log(JSON.stringify(jChartArr));
				
				var columOrder = ["lw3", "lw2", "lw1", "term", "aw1"];
				var columKr = ["3주일전", "2주일전", "1주일전", "이벤트기간", "1주일후"];
				colorArr = [  "#333333", "#d3d3d3", "#41C7EB", "#31D634", "#ff0000" ];
				
				xColName = "xcolkr"; //x축이름
				
				chartData = []; //차트 데이터
				seriesNames =[];
				seriesCols = [];
				if(jChartArr.length > 0){
					for(var i = 0 ;  i < jChartArr.length; i++){
						seriesCols.push("ycol"+(i+1)); //y 계열 컬럼 명
						seriesNames.push(jChartArr[i].cd_nm);
						var chartArr ={
								xcol: columOrder[i],
								
								xcolkr: columKr[i], //x 컬럼의 한글명
								xcolorder: i, //정렬을 위한 시퀀스
						};
						for(var j =0; j < jChartArr.length; j++){
							chartArr["ycol"+(j+1)+"Name"] = jChartArr[j].cd_nm;
							chartArr["ycol"+(j+1)+"valu"] = (jChartArr == null) ? 0 : jChartArr[j][columOrder[i]];
						}
						chartData.push(chartArr);
					}
				}

				chartData.sort(function CompareForSort(first, second) {
					return first.xcolorder - second.xcolorder;
				});
				
// 				console.log(seriesCols);
// 				console.log(chartData);
				
				actionChart();
				document.title = 'complete';
			},
			error: function(request, status, error) {
				console.log("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
			}
		});
	}

	function actionChart() {
		d3.select("#viewport").html("");

		var chartWidth = Number(d3.select('#viewport').style('width').replace("px", "")) - chartMargin.left - chartMargin.right;
		
		var chartHeight = Number(d3.select('#viewport').style('height').replace("px", "")) - chartMargin.top - chartMargin.bottom;
		
		var xScale = d3.scale.ordinal().rangePoints([0, chartWidth - 100]);
		
		var yScale = d3.scale.linear().range([chartHeight , 0]);
		
		var color = d3.scale.ordinal().range(colorArr);
		
		var xAxis = d3.svg.axis().scale(xScale).ticks(5);
		
		var yMaxValue = d3.max(chartData, function(d) {
			return d.value;
		});
		var yAxis = d3.svg.axis()
		              .scale(yScale)
		              .orient("left")
		              .innerTickSize(-(chartWidth - 100))
		              .ticks(chart_config.ticks)
		              .tickPadding(10);


		var yMaxValues = [];
		for (var i = 0; i < seriesCols.length; i++) {
			yMaxValues.push(d3.max(chartData, function(d) {
				return d[seriesCols[i] + "valu"];
			}));
		}
		var yMaxValue = d3.max(yMaxValues);
		var yData = [];


		for (var i = 0; i < seriesCols.length; i++) {

			var seriCol = seriesCols[i];
// 			console.log(seriCol);
			yData.push({
				"name": seriesNames[i],
				"values": chartData.map(function(d) {
					return {
						xcol: d[xColName],
						value: d[seriCol + "valu"]
					}
				})
			});
		}
		yScale.domain([0, yMaxValue + (yMaxValue / 8)]).nice();
		xScale.domain(chartData.map(function(d) {
			return d[xColName];
		}));


		var svg = d3.select("#viewport")
			.append("svg")
			.attr("width", chartWidth + chartMargin.left + chartMargin.right)
			.attr("height", chartHeight + chartMargin.top + chartMargin.bottom)
			.append("g")
			.attr("transform", "translate(" + chartMargin.left + "," + chartMargin.top + ")");

		svg.datum(chartData);

		svg.append("g")
			.attr("class", "x axis")
			.attr("transform", "translate(0," + chartHeight + ")")
			.call(xAxis);

		svg.append("g")
			.attr("class", "y axis")
			.attr("transform", "translate(0,0)")
			.call(yAxis);

		var line = d3.svg.line()
			.x(function(d) {
				return xScale(d.xcol);
			})
			.y(function(d) {
				return yScale(d.value);
			});


		var lines = svg.selectAll(".lines")
			.data(yData)
			.enter().append("g")
			.attr("class", "lines");


		lines.append("path")
			.attr("class", "line")
			.attr("d", function(d) {
				return line(d.values);
			})
			.style("stroke", function(d) {
				return color(d.name) ;
			});
		
		
		var legend = svg.selectAll(".legend")
		.data(seriesNames)
		.enter()
		.append("g").attr("class", "legend")
		.attr("transform", function(d, i) {
//				var ylegend = Number((i * 10))+Number((chartWidth/4));
			return "translate(0," + (i * 15) + ")";
		});

		legend.append("rect")
		  .attr("x", chartWidth - 80)
		  .attr("width", 11)
		  .attr("height", 11)
		  .style("fill", function(d) { return color(d);  });
		
		legend.append("text")
		  .attr("x", chartWidth - 60)
		  .attr("y", 8)
		  .style("text-anchor", "start")
		  .text( function(d) { return d;	} );

	}
	if(typeof window.callPhantom === 'function'){
// 		console.log("phantomjs callback");
	}else{
		$(document).ready(function(){
			drawChart();
		});
	}
	</script>
	</body>
</html>