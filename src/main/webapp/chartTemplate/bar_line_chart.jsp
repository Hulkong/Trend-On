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
		body{font-family:'Nanum Gothic',NanumGothic,'Nanum gothic',"Helvetica",verdana,sans-serif;font-size:11px;}
		
		
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
               fill: red;
        }
		svg g path.line {
                stroke: #1db34f;
                stroke-width: 3px;
                stroke-opacity: 1;
                fill: none;
		}
		
		path {
		    fill: none;
		}
		
	</style>
</head>
<body>
	<div id="viewport" style="width:500px;height:200px;"></div>
	<script type="text/javascript">
	var fullUrl = location.protocol + '//' + location.hostname + ((location.port) ? ":" + location.port : '');
	
	
	var chart_config = {
		ticks: 6,
		selectedRgnClss: 'H4',
		ctyCd: '11110',
		dataId: "rpt-evntEff",
		pageId: "rpt-evntEff-006-007",
// 		choroColumn: "tot_sale_amt",
		startDate: "20160606",
		endDate: "20160607"
	};

	var chartMargin = {
		top: 20,
		right: 130,
		bottom: 30,
		left: 70
	};


	var options = {};//phantomjs에서 활용하는 옵션
	var chartData = []; //챠트 데이터
	
	
	var seriesNames =  ["축1", "축2"]; //y 축 이름
	var colorArr = [  "#828282", "#d3d3d3"];//계열별 색상
	var krIndex = 8;
	function parseDate(str) {
		var y = str.substr(0, 4),
			m = str.substr(4, 2) - 1,
			d = str.substr(6, 2);
		var D = new Date(y, m, d);
		return (D.getFullYear() == y && D.getMonth() == m && D.getDate() == d) ? D : 'invalid date';
	}
	
	
	function krWonRound(value,index,precision){
		
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
	function drawChart(options) {
		if (options) {
			d3.select('#viewport').style('width', options.width + "px");
			d3.select('#viewport').style('height', options.height + "px");

			chart_config = $.extend(chart_config, options);
		}

		//http://localhost:8090/onmap/public/ecnmy_trnd/pdf/data_root.json?dataId=rpt-evntEff&h3Cd=11110&startDate=20160501&endDate=20160502
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
				
				seriesNames = ["매출액", "매출액변화율"]; //y 계열 이름
				colorArr = [  "#00A9CC", "#ff0000" ];//계열별 색상
				var jChartArr = json[chart_config.pageId];
				chartData = [];
				for(var i = 0;i< jChartArr.length;i++){
					var item = jChartArr[i];
					krWonRound(Number(item.chg_amt),8,4);
					chartData.push({
						"name": item.nm,
// 						"value": Math.round(Number(item.chg_amt) / 1000),
						"value": Number(item.chg_amt),
						"valueR": Number(item.rate)
					});	
				}
				
				krIndex = krWonRoundIndex(Math.max.apply(null, d3.extent(chartData , function(d){ return d.value }).map(Math.abs)))
				actionChart();
				document.title = 'complete';
			},
			error: function(request, status, error) {
				console.log("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
			}
		});
	}

	
	function formatWonRound(d){
  	  var tmpStr = String(Math.abs(d));
  	  var unit = "";
  	  var unitNum = 1;
  	  if(tmpStr.length > 1 && tmpStr.length <= 7){
  		  unitNum = 1000;
  		  unit = "천";
  	  }else if(tmpStr.length > 7 && tmpStr.length <= 11){
  		  unitNum  = 10000000;
  		  unit = "천만";
  	  }else if(tmpStr.length > 11 && tmpStr.length <= 13){
  		  unitNum  = 100000000;
  		  unit = "억";
  	  }
  	  return Math.round(d / unitNum,4) + unit ;
     }
	function actionChart() {
		d3.select("#viewport").html("");

		var chartWidth = Number(d3.select('#viewport').style('width').replace("px", "")) - chartMargin.left - chartMargin.right;
		
		var chartHeight = Number(d3.select('#viewport').style('height').replace("px", "")) - chartMargin.top - chartMargin.bottom;
		
		var color = d3.scale.ordinal().range(colorArr);
		
		var xScale = d3.scale.ordinal().rangeRoundBands([0,chartWidth], .3)
		
		var yScale = d3.scale.linear().range([chartHeight , 0]);
		
		var xAxis = d3.svg.axis().scale(xScale).ticks(5);
		
		var yMaxValue = d3.max(chartData, function(d) {
			return d.value;
		});
		var yAxis = d3.svg.axis()
		              .scale(yScale)
		              .orient("left")
		              .innerTickSize(-chartWidth)
		              .ticks(10)
		              .tickFormat(function(d){
		            	  return krWonRound(d,krIndex,4) +"원";
		              })
		              .tickPadding(10);
		
		
		var yMaxValue = d3.extent(chartData , function(d){ return d.value });
		
		
// 		    yMaxValue = yMaxValue + (yMaxValue / 8) ;


		var yScaleRight = d3.scale.linear().range([chartHeight, 0]);
		var yAxisRight = d3.svg.axis().scale(yScaleRight)
	    						.orient("right")		            
	    			            .ticks(chart_config.ticks)
	    			            .tickFormat(function(d){ return d+"%";})
	    			            .tickPadding(10);
		
		var yMaxValueRight = d3.extent(chartData , function(d){ return d.valueR });
		
		
		
		yAbsMaxValueRight = Math.max.apply(null, yMaxValueRight.map(Math.abs));
		
		
		
		yScaleRight.domain( [(yAbsMaxValueRight * -1) + (yAbsMaxValueRight * -1)/8 ,yAbsMaxValueRight + yAbsMaxValueRight /8] );
		
		
		var valueline2 = d3.svg.line()
		.interpolate('linear')
	    .x(function(d) { return xScale(d.name) + xScale.rangeBand() / 2 ; })
	    .y(function(d) { return yScaleRight(d.valueR); });
		
		
		
		yAbsMaxVale = Math.max.apply(null, yMaxValue.map(Math.abs));
		yScale.domain( [(yAbsMaxVale * -1) + (yAbsMaxVale * -1)/8 ,yAbsMaxVale + yAbsMaxVale /8] );
		
		
		
		xScale.domain(chartData.map(function(d) {
			return d.name;
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
	     .call(xAxis)
	     .selectAll("text")
	     .style("text-anchor", "end")
    	 .attr("dx", "-.55em")
	     .attr("dy", "-.8em")
	     .attr("transform", "rotate(-45)" );
		
		
		svg.append("g")
			.attr("class", "y axis")
			.attr("transform", "translate(0,0)")
			.call(yAxis);

		svg.append("g")
		.attr("class", "y axis")
		.attr("transform", "translate(" + chartWidth + ",0)")
		.call(yAxisRight);
		
		var bar =  svg.selectAll(".bar")
	      .data(chartData)
	    .enter().append("rect")
	      .attr("class", function(d) { return "bar bar--" + (d.value < 0 ? "negative" : "positive"); })
	      .attr("x", function(d) { return xScale(d.name); })
	      .attr("y", function(d) { return yScale(Math.max(0, d.value)); })
	      .attr("width", xScale.rangeBand() )
	      .attr("height", function(d) { return Math.abs(yScale(d.value) - yScale(0)); }  )
	      .style('fill', function(d) {  return color(0);	});
		  
		
	    svg.append("path")        // Add the valueline2 path.
        .style("stroke", color(1))
        .style("stroke-width", "2px")
        .attr("d", valueline2(chartData));
	    
	    svg.selectAll("dot")
        .data(chartData)
      .enter().append("circle")
        .attr("r", 3)
        .attr("cx",  function(d) { return xScale(d.name) + xScale.rangeBand() / 2 ; }  )
        .attr("cy", function(d) { return yScaleRight(d.valueR); }  );
	    
	    
	    
	    
		var legend = svg.selectAll(".legend")
		.data(seriesNames)
		.enter()
		.append("g").attr("class", "legend")
		.attr("transform", function(d, i) {
//				var ylegend = Number((i * 10))+Number((chartWidth/4));
			return "translate(0," + (i * 15) + ")";
		});

		legend.append("rect")
		  .attr("x", chartWidth+ chartMargin.right - 80)
		  .attr("width", 8)
		  .attr("height", 8)
		  .style("fill", function(d) { return color(d);  });
		
		legend.append("text")
		  .attr("x", chartWidth+ chartMargin.right - 70)
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