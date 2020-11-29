<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!doctype html>
<html>
	<head>
		<title>radar chart 예제</title>
		<meta charset="utf-8" />
		<style>
	 		@import url("//fonts.googleapis.com/earlyaccess/nanumgothic.css");
			html, body { height:100%; overflow:hidden }
			body{font-family:'Nanum Gothic',NanumGothic,'Nanum gothic',"Helvetica",verdana,sans-serif;font-size:10px;}
		</style>
		<script src="../lib/jquery-1.11.2.min.js"></script>
		<script src="../lib/d3Chart/d3.js"></script>
	</head>
	<body>
		<div id="viewport" style="width:100%;height:100%;"></div>
		
		<script type="text/javascript">
		
			// 접근 방식에 따라 drawChart() 자동실행
			if (typeof window.callPhantom === 'function') {
// 				console.log("phantomjs callback");
			} else {
				$(document).ready(function() {
					drawChart();
				});
			}
			
			/**
			 * phantomjs이용시 차트를 그리기위한 초기 함수
			 * @param options 외부 입력값 객체
			 */
			function drawChart(options){
				var opt ={};
				//외부 입력값 적용
				if(options){
					d3.select('body').style("height", options.height + "px");
					d3.select('body').style("width", options.height + "px");
	                d3.select('#viewport').style('width', options.width + "px");
	                d3.select('#viewport').style('height', options.height + "px");
	                
	                opt = options;
				}
				getJson(opt);
			}
			
			/*
			 * 데이터를 가져오는 함수
			 */
			function getJson(options){
				$.ajax({
					url : "./data.jsp",
					success : function(result) {
						var json = JSON.parse(result);
						
						chartData = [];
						chartDataArr = [];
						categoryArr = [];
						var timeVal = ["0~6시","6~9시","9~12시","12~15시","15~18시","18~21시","21~24시"];
						
						var j = 0;
						for(var i = 0;i< json.length;i++){
							var item = json[i];
							
							chartDataArr.push({
								"name": item.name,
								"rootCd": timeVal.indexOf(item.name.trim()),
								"colnm" : item.category,
								"value": item.value,
								"desc": "0",
							});	
							
							if(timeVal.length == chartDataArr.length){
								chartData[j] = chartDataArr ;
								chartDataArr = [];
								categoryArr.push(item.category);
								j++;
							}
							
						}
						
						// 정렬
						chartData.sort(function CompareForSort(first, second) {
							return first.rootCd - second.rootCd;
						});
						
						if(categoryArr.length > 0)options.categoryArr = categoryArr;
						
						actionChart(options, chartData);
						document.title = 'complete';
					}
				});
			}

			// chart 생성 함수
			function actionChart(options, chartData){
				
				
				var chart_config = {
						ticks : 4,
						chartMargin : {top: 10,	right: 20,	bottom: 70,	left: 100},
						radius: 5,
						factor: 1,
						factorLegend: .85,
						levels: 3,
						maxValue: 0,
						radians: 2 * Math.PI,
						opacityArea: 0.5,
						ToRight: 5,
						TranslateX: 80,
						TranslateY: 30,
						ExtraWidthX: 100,
						ExtraWidthY: 100,
						color: d3.scale.category10(),
						categoryArr : [1,2]
				};
				chart_config = $.extend(chart_config,options);
				d3.select("#viewport").html("");
				
				var chartWidth = Number(d3.select('#viewport').style('width').replace("px", "")) - chart_config.chartMargin.left - chart_config.chartMargin.right;
				var chartHeight = Number(d3.select('#viewport').style('height').replace("px", "")) - chart_config.chartMargin.top - chart_config.chartMargin.bottom;
				
				chart_config.maxValue = Math.max(chart_config.maxValue, d3.max(chartData, function(i){return d3.max(i.map(function(o){return o.value;}))}));
				var allAxis = (chartData[0].map(function(i, j){return i.name}));
				var total = allAxis.length;
				var radius = chart_config.factor*Math.min(chartWidth/2, chartHeight/2);
				var Format = function(d){return Math.floor(d)+"명"};
				
				d3.select("#viewport").select("svg").remove();
				var chart = d3.select("#viewport")
							  .append("svg")
							  .attr("width", chartWidth + chart_config.ExtraWidthX)
							  .attr("height", chartHeight + chart_config.ExtraWidthY)
							  .append("g")
							  .attr("transform", "translate(" + chart_config.TranslateX + "," + chart_config.TranslateY + ")");;

				// 범위 혹은 눈금을 알려주는 바탕 도형
				for(var j=0; j<chart_config.levels-1; j++){
					  var levelFactor = chart_config.factor*radius*((j+1)/chart_config.levels);
					  chart.selectAll(".levels")
					   	   .data(allAxis)
					   	   .enter()
					       .append("svg:line")
					   	   .attr("x1", function(d, i){return levelFactor*(1 - chart_config.factor*Math.sin(i*chart_config.radians/total));})
					   	   .attr("y1", function(d, i){return levelFactor*(1 - chart_config.factor*Math.cos(i*chart_config.radians/total));})
					  	   .attr("x2", function(d, i){return levelFactor*(1 - chart_config.factor*Math.sin((i+1)*chart_config.radians/total));})
					       .attr("y2", function(d, i){return levelFactor*(1 - chart_config.factor*Math.cos((i+1)*chart_config.radians/total));})
					       .attr("class", "line")
					       .style("stroke", "grey")
					       .style("stroke-opacity", "0.75")
					       .style("stroke-width", "0.3px")
					       .attr("transform", "translate(" + (chartWidth/2-levelFactor) + ", " + (chartHeight/2-levelFactor) + ")");
				}

				//범위 혹은 눈금을 알려주는 바탕 도형의 text
				for(var j=0; j<chart_config.levels; j++){
					  var levelFactor = chart_config.factor*radius*((j+1)/chart_config.levels);
					  chart.selectAll(".levels")
					   	   .data([1]) //dummy data
					       .enter()
					       .append("svg:text")
					       .attr("x", function(d){return levelFactor*(1-chart_config.factor*Math.sin(0));})
					       .attr("y", function(d){return levelFactor*(1-chart_config.factor*Math.cos(0));})
					       .attr("class", "legend")
					       .style("font-family", "sans-serif")
					       .style("font-size", "10px")
					       .attr("transform", "translate(" + (chartWidth/2-levelFactor + chart_config.ToRight) + ", " + (chartHeight/2-levelFactor) + ")")
					       .attr("fill", "#737373")
					       .text(Format((j+1)*chart_config.maxValue/chart_config.levels));
				}
				
				series = 0;

				var axis = chart.selectAll(".axis")
						        .data(allAxis)
							    .enter()
								.append("g")
								.attr("class", "axis");

				axis.append("line")
					.attr("x1", chartWidth/2)
					.attr("y1", chartHeight/2)
					.attr("x2", function(d, i){
						return chartWidth/2 - (radius * chart_config.factor*Math.sin(i*chart_config.radians/total));
					 })
					.attr("y2", function(d, i){
						return chartHeight/2 - (radius * chart_config.factor*Math.cos(i*chart_config.radians/total));
					 })
					.attr("class", "line")
					.style("stroke",function(d,i){return "grey";})
					.style("stroke-width", "1px");

				axis.append("text")
					.attr("class", "legend")
					.text(function(d){return d})
					.style("font-family", "sans-serif")
					.style("font-size", "11px")
					.attr("text-anchor", "middle")
					.attr("dy", "1.5em")
					.attr("transform", function(d, i){return "translate(0, -10)"})
					.attr("x", function(d, i){return (chartWidth/2 - (radius*chart_config.factorLegend*Math.sin(i*chart_config.radians/total)))-60*Math.sin(i*chart_config.radians/total);})
					.attr("y", function(d, i){return (chartHeight/2 - (radius*Math.cos(i*chart_config.radians/total)))-20*Math.cos(i*chart_config.radians/total);});
				
				
				
				//도형그리기
				chartData.forEach(function(y, x){
					  dataValues = [];
					  chart.selectAll(".nodes")
						   .data(y, function(j, i){
							  dataValues.push([
								(chartWidth/2-(radius*(parseFloat(Math.max(j.value, 0))/chart_config.maxValue)*chart_config.factor*Math.sin(i*chart_config.radians/total))), 
								(chartHeight/2-(radius*(parseFloat(Math.max(j.value, 0))/chart_config.maxValue)*chart_config.factor*Math.cos(i*chart_config.radians/total)))
							  ]);
							});
						  dataValues.push(dataValues[0]);
					  
					   chart.selectAll(".area")
						    .data([dataValues])
						    .enter()
						    .append("polygon")
						    .attr("class", "radar-chart-serie"+series)
						    .style("stroke-width", "2px")
						    .style("stroke", chart_config.color(series))
						    .attr("points",function(d) {
								var str="";
								for(var pti=0;pti<d.length;pti++){
									str=str+d[pti][0]+","+d[pti][1]+" ";
								}
							 	return str;
						  	})
						    .style("fill", function(j, i){return chart_config.color(series)})
						    .style("fill-opacity", chart_config.opacityArea)
						    .on('mouseover', function (d){
								z = "polygon."+d3.select(this).attr("class");
								chart.selectAll("polygon")
									 .transition(200)
									 .style("fill-opacity", 0.1); 
								chart.selectAll(z)
									 .transition(200)
									 .style("fill-opacity", .7);
							})
						    .on('mouseout', function(){
						    	chart.selectAll("polygon")
									 .transition(200)
									 .style("fill-opacity", chart_config.opacityArea);
						    });
						  series++;
					});
					series=0;
					
					//도형위의 point만들기
					chartData.forEach(function(y, x){
						  chart.selectAll(".nodes")
							   .data(y)
							   .enter()
							   .append("svg:circle")
							   .attr("class", "radar-chart-serie"+series)
							   .attr('r', chart_config.radius)
							   .attr("alt", function(j){return Math.max(j.value, 0)})
							   .attr("cx", function(j, i){
								  dataValues.push([
									(chartWidth/2 - (radius*(parseFloat(Math.max(j.value, 0))/chart_config.maxValue)*chart_config.factor*Math.sin(i*chart_config.radians/total))), 
									(chartHeight/2 - (radius*(parseFloat(Math.max(j.value, 0))/chart_config.maxValue)*chart_config.factor*Math.cos(i*chart_config.radians/total)))
							   	  ]);
								  return (chartWidth/2 - (radius*(Math.max(j.value, 0)/chart_config.maxValue))*chart_config.factor*Math.sin(i*chart_config.radians/total));
								})
							   .attr("cy", function(j, i){
							  	  return (chartHeight/2 - (radius*(Math.max(j.value, 0)/chart_config.maxValue))*chart_config.factor*Math.cos(i*chart_config.radians/total));
								})
							   .attr("data-id", function(j){return j.axis})
							   .style("fill", chart_config.color(series)).style("fill-opacity", .9)
							   .on('mouseover', function (d){
										newX =  parseFloat(d3.select(this).attr('cx')) - 10;
										newY =  parseFloat(d3.select(this).attr('cy')) - 5;
										
										tooltip.attr('x', newX)
											   .attr('y', newY)
											   .text(d.colnm +" : " +Format(d.value))
											   .transition(200)
											   .style('opacity', 1);
											
										z = "polygon."+d3.select(this).attr("class");
										chart.selectAll("polygon")
											 .transition(200)
											 .style("fill-opacity", 0.1); 
										chart.selectAll(z)
											 .transition(200)
											 .style("fill-opacity", .7);
								})
							   .on('mouseout', function(){
										tooltip.transition(200)
											   .style('opacity', 0);
										
										chart.selectAll("polygon")
											 .transition(200)
										 	 .style("fill-opacity", chart_config.opacityArea);
								});

					    series++;
					});
					
					//Tooltip
					var tooltip = chart.append('text')
									   .style('opacity', 0)
									   .style('font-family', 'sans-serif')
									   .style('font-size', '13px');
				  
					
					//범례	
					var legend = chart.append("g")
									  .attr("class", "legend")
									  .attr("height", 100)
									  .attr("width", 200)
									  .attr('transform', 'translate(90,20)');
					
						//범례 색박스
						legend.selectAll('rect')
							  .data(chart_config.categoryArr)
							  .enter()
							  .append("rect")
							  .attr("x", chartWidth - 200)
							  .attr("y", function(d, i){ return i * 20;})
							  .attr("width", 10)
							  .attr("height", 10)
							  .style("fill", function(d, i){ return chart_config.color(i);});
						
						
						//범례 text
						legend.selectAll('text')
							  .data(chart_config.categoryArr)
							  .enter()
							  .append("text")
							  .attr("x", chartWidth - 180)
							  .attr("y", function(d, i){ return i * 20 + 9;})
							  .attr("font-size", "11px")
							  .attr("fill", "#737373")
							  .text(function(d) { return d; });	
					
			}
			
			/**
			* 배열 group by
			* @param xs group by를 할 배열
			* @param key group을 형성할 기준이 되는 colum 값
			**/
			var groupBy = function(xs, key) {
				return xs.reduce(function(rv, x) {
					(rv[x[key]] = rv[x[key]] || []).push(x);
					return rv;
				}, {});
			};
		</script>
	</body>
</html>