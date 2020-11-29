<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
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
		
		
		.axis path {
			fill: none;
			stroke: #000;
			shape-rendering: crispEdges;
		}
		.axis .tick text{
    		font-size:14px;
		}
		.axis line {
			fill: none;
			stroke: #000;
			shape-rendering: crispEdges;
		}
		
		.guideline {
			stroke-width: 1;
			shape-rendering: crispEdges;
		}
		
		.y.axis .tick line {
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
	<div id="viewport" style="width: 758px; height: 360px;"></div>
	<script type="text/javascript">
	
		var fullUrl = location.protocol+'//'+location.hostname+( (location.port)  ? ":"+location.port : '' ); 
		var chart_config = {
				ticks:6,
				selectedRgnClss : 'H4',
				ctyCd : '43760',
// 				admiCd : '43760310',
				dataId : "rpt-trnd",			// rpt-trnd			 // rpt-evntEff
				pageId : "rpt-trnd-011-005",	// rpt-trnd-011-005  // rpt-evntEff-012-005
				startDate : "20171016",
				endDate : "20171018",
// 				lastStartDate : "20161016",
// 				lastEndDate : "20161018",
				userNo:3
		};

		var colorArr = {  "h_m" : "#d4cebf"
						, "h_f" : "#afa99c"
						, "e_m" : "#ffbb72"
						, "e_f" : "#ff8a4a" 
		};
	
		var chartMargin = {
			top : 10,
			right : 10,
			bottom : 50,
			left : 35
		};

		var groupBy = function(xs, key) {
			return xs.reduce(function(rv, x) {
				(rv[x[key]] = rv[x[key]] || []).push(x);
				return rv;
			}, {});
		};

		//챠트 레이아웃을 위한 데이터
		var chartData = [ {
			"rootName" : "20대",
			"category" : "유입인구",
			"colnm" : "유입인구남자",
			"val" : 2659367,
			"yBegin" : 0,
			"yEnd" : 2659367
		}, {
			"rootName" : "20대",
			"category" : "유입인구",
			"colnm" : "유입인구여자",
			"val" : 3719105,
			"yBegin" : 2659367,
			"yEnd" : 6378472
		}, {
			"rootName" : "20대",
			"category" : "지역주민",
			"colnm" : "지역주민남자",
			"val" : 2531103,
			"yBegin" : 0,
			"yEnd" : 2531103
		}, {
			"rootName" : "20대",
			"category" : "지역주민",
			"colnm" : "지역주민여자",
			"val" : 4194400,
			"yBegin" : 2531103,
			"yEnd" : 6725503
		}];

		var roots = {};//groupBy(chartData,"rootName");
		var category = {};//groupBy(chartData,"category");
		var legend = {};

		var options = {};
		function drawChart(options) {
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
					"ctyCd" : chart_config.ctyCd,
					"admiCd" : chart_config.admiCd,
					"startDate" : chart_config.startDate,
					"userNo" : chart_config.userNo,
					"endDate" : chart_config.endDate,
					"lastStartDate" : chart_config.lastStartDate,
					"lastEndDate" : chart_config.lastEndDate
				},
				success : function(json) {
					chartData = [];
					var jChartArr = json[chart_config.pageId];
					
					for ( var nm in jChartArr[0]) {
						var sp = nm.split("_");
						var mae = (sp[1] == "m") ? "남자" : "여자";
						var ctz = (sp[0] == "e") ? "유입인구" : "상주인구";
						var obj = {
							rootName : sp[2] + "대",
							category : ctz,
							colnm : ctz + mae,
							val : jChartArr[0][nm],
							color : colorArr[sp[0]+"_"+sp[1]]
						};
						chartData.push(obj);
	
					}
	
					chartData.sort(function CompareForSort(first, second) {
						var r = 0;
	
						if (first.rootName < second.rootName) {
							r = -1;
						} else if (first.rootName > second.rootName) {
							r = 1;
						} else {
							r = 0;
							if (first.category < second.category) {
								r = -1;
							} else if (first.category > second.category) {
								r = 1;
							} else {
								r = 0;
								if (first.colnm.replace(first.category,"") < second.colnm.replace(second.category,"")) {
									r = -1;
								} else if (first.colnm.replace(first.category,"") > second.colnm.replace(second.category,"")) {
									r = 1;
								}else{
									r = 0;
								} 
							}
						}
						return r;
					});
					actionChart();
					document.title = 'complete';
				}
			});

		}
		
		function actionChart() {
			
			roots = groupBy(chartData, "rootName");
			category = groupBy(chartData, "category");
			legend = groupBy(chartData, "colnm");
			
			var legendArr = [];
			for ( var colnm in legend) {
				legendArr.push({
					"name" : colnm,
					"color" : legend[colnm][0].color
				});
			}

			for ( var nm in roots) {
				var tmpArr = (groupBy(roots[nm], "category"));
				var tmpMaxArr = [];
				for ( var nm1 in tmpArr) {

					var yBegin = 0, yEnd = 0;
					for (var i = 0; i < tmpArr[nm1].length; i++) {
						tmpArr[nm1][i].yBegin = yBegin;
						tmpArr[nm1][i].yEnd = yBegin + tmpArr[nm1][i].val;
						yBegin += tmpArr[nm1][i].val;
					}
					var fdfd = d3.sum(tmpArr[nm1], function(d) {
						return d.val;
					});
					tmpMaxArr.push(fdfd);
				}
				roots[nm].totalval = d3.max(tmpMaxArr);
			}
			d3.select("#viewport").html("");

			var chartWidth = Number(d3.select('#viewport').style('width').replace("px", ""))- chartMargin.left - chartMargin.right;
			var chartHeight = Number(d3.select('#viewport').style('height').replace("px", ""))	- chartMargin.top - chartMargin.bottom;

			var x0 = d3.scale.ordinal().rangeRoundBands([ 0, chartWidth - 100 ],	0.3);
			    x0.domain(d3.keys(roots));
			    
			var x1 = d3.scale.ordinal();
			    x1.domain(d3.keys(category)).rangeRoundBands([ 0, x0.rangeBand() ]);
			var y = d3.scale.linear().range([ chartHeight, 0 ]);

			
			var xAxis = d3.svg.axis()
			                  .scale(x0)
			                  .tickPadding(10)
			                  .orient("bottom");

			var yAxis = d3.svg.axis()
							  .scale(y)
							  .orient("left")
							  .innerTickSize(-chartWidth + 100).tickPadding(10)
							  .ticks(chart_config.ticks)
							  .tickPadding(5)
							  .tickFormat(function(d){
// 								  var ff = d3.format(",");
// 								  if(d > 10000){
// 									d = krWonRound(d, 4, 1);  
// 								  }else{
// 									d = ff(d);
// 								  }
									return d+"%";
							  });

// 			var color = d3.scale.ordinal().range([  "#828282", "#d3d3d3", "#2e6695", "#ff8166" ]);

			var svg = d3.select("#viewport")
				        .append("svg")
						.attr("width",chartWidth + chartMargin.left + chartMargin.right)
						.attr("height",chartHeight + chartMargin.top + chartMargin.bottom)
// 						.append( "g")
// 						.attr( "transform", "translate(" + chartMargin.left + "," + chartMargin.top + ")");

			var yMax = 0;
			var yValueArray = [];
			for ( var nm in roots) {

				yValueArray.push(roots[nm].totalval)
			}
			yMax = d3.max(yValueArray);
			yMax = yMax + (yMax / 10);
			y.domain([ 0, yMax ]);

			svg.append("g")
			   .attr("class", "x axis")
			   .attr("transform","translate("+ chartMargin.left +"," + (chartHeight+chartMargin.top) + ")")
			   .call(xAxis);

			svg.append("g")
			   .attr("class", "y axis")
			   .attr( "transform", "translate(" + chartMargin.left + "," + chartMargin.top + ")")
			   .call(yAxis);
			   
			var project_stackedbar = svg.selectAll(".project_stackedbar")
										.data(chartData)
										.enter()
										.append("g")
										.attr( "transform", "translate(" + chartMargin.left + "," + chartMargin.top + ")")
										.append("g")
										.attr("class", "g")
										.attr("transform", function(d) {
											return "translate(" + x0(d.rootName) + ",0)";
										});

				project_stackedbar.selectAll("rect")
								  .data(function(d) { return roots[d.rootName];  })	
								  .enter()
								  .append("g")
								  .attr( "transform", "translate(0,0)")
								  .append("rect")
								  .attr("width", x1.rangeBand())
								  .attr("x", function(d) { return x1(d.category);  })
								  .attr("y", function(d) { return y(d.yEnd);  })
								  .attr("height", function(d) { return y(d.yBegin) - y(d.yEnd); })
								  .style("fill", function(d) { 
									  return d.color;  
// 									  return color(d.colnm);  
								  })
								  .attr("opacity", 0.3);
				
				
				project_stackedbar.selectAll('.barText')
								  .data(function(d) { return roots[d.rootName];  })
								  .enter()
								  .append("g")
								  .attr("transform", "translate(0,0)")
								  .append("text")
								  .attr("class","barText")
								  .attr("x", function(d) { return x1(d.category)+(x1.rangeBand()/2);  })
								  .attr("y", function(d) { 
									  var yResult = 0;
									  if(d.yBegin > 0){
										  yResult = y(d.yBegin) + ((y(d.yEnd) -y(d.yBegin))/2)+8;
									  }else{
										  yResult = y(d.yEnd)+((y(d.yBegin) - y(d.yEnd))/2)+8;  
									  }
									  return yResult
								  })
								  .style("text-anchor", "middle")
								  .style("opacity", 0.25)
								  .attr('dy', '-0.5em')
								  .text(function(d){
								  		return  (d.val).toFixed(1);
								  });
				

			var legend = svg.selectAll(".legend")
							.data(legendArr)
							.enter()
							.append("g")
							.attr( "transform", "translate(" + chartMargin.left + "," + chartMargin.top + ")")
							.append("g").attr("class", "legend")
							.attr("transform", function(d, i) {
// 								var ylegend = Number((i * 10))+Number((chartWidth/4));
								return "translate(0," + (i * 15) + ")";
							});

				legend.append("rect")
					  .attr("x", chartWidth - 90)
					  .attr("width", 11)
					  .attr("height", 11)
					  .style("fill", function(d) { 
						  return d.color;  
// 						  return color(d.name);  
					  })
					  .style('opacity', 0.7);
	
				legend.append("text")
					  .attr("x", chartWidth - 75)
					  .attr("y", 8)
					  .style("text-anchor", "start")
					  .text( function(d) { return d.name;	} );

			//Create Title 
// 			svg.append("text")
// 			   .attr("x", chartWidth / 2)
// 			   .attr("y", 0)
// 			   .style("text-anchor", "middle")
// 			   .text("성/연령별 유입인구 수");
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
	</script>
</body>
</html>