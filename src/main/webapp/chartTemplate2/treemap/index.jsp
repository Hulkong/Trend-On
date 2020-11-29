<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!doctype html>
<html>
<head>
	<title>treemap chart 예제</title>
	<meta charset="utf-8" />
	<style>
		html, body { height:100%; overflow:hidden }
		body {
		  overflow: hidden;
		  margin: 0;
		  font-size: 14px;
		  font-family: "Helvetica Neue", Helvetica;
		}
		
		#chart, #header, #footer {
		  position: absolute;
		  top: 0;
		}
		
		#header, #footer {
		  z-index: 1;
		  display: block;
		  font-size: 36px;
		  font-weight: 300;
		  text-shadow: 0 1px 0 #fff;
		}
		
		#header.inverted, #footer.inverted {
		  color: #fff;
		  text-shadow: 0 1px 4px #000;
		}
		
		#header {
		  top: 80px;
		  left: 140px;
		  width: 1000px;
		}
		
		#footer {
		  top: 680px;
		  right: 140px;
		  text-align: right;
		}
		
		rect {
		  fill: none;
		  pointer-events: all;
		}
		
		pre {
		  font-size: 18px;
		}
		
		line {
		  stroke: #000;
		  stroke-width: 1.5px;
		}
		
		.string, .regexp {
		  color: #f39;
		}
		
		.keyword {
		  color: #00c;
		}
		
		.comment {
		  color: #777;
		  font-style: oblique;
		}
		
		.number {
		  color: #369;
		}
		
		.class, .special {
		  color: #1181B8;
		}
		
		a:link, a:visited {
		  color: #000;
		  text-decoration: none;
		}
		
		a:hover {
		  color: #666;
		}
		
		.hint {
		  position: absolute;
		  right: 0;
		  width: 1280px;
		  font-size: 12px;
		  color: #999;
		}
		.chart {
		  display: block;
		  margin: auto;
		}
		
		text {
		  font-size: 11px;
		}
		
		rect {
		  fill: none;
		}
	</style>
	<script src="../lib/jquery-1.11.2.min.js"></script>
	<script src="../lib/d3Chart/d3.js"></script>
</head>
<body>
	<div id="viewport" style="width:100%;height:100%;"></div>
	
	<script type="text/javascript">
	
		// 접근 방식에 따라 drawChart() 자동실행
		if (typeof window.callPhantom === 'function') {
//			console.log("phantomjs callback");
		} else {
			$(document).ready(function() {
				drawChart();
			});
		}
	
		/**
		 * phantomjs이용시 차트를 그리기위한 초기 함수
		 * @param options 외부 입력값 객체
		 */
		function drawChart(options) {
			var opt = {};
			//외부 입력값 적용
			if (options) {
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
				url: "./data.jsp",
				success: function(result) {
					var json = JSON.parse(result);
					
					actionChart(options, json)
				}
			});
		}
		
		// chart 생성 함수
		function actionChart(options, chartData){
			
			var chart_config = {
					chartMargin : {top:0, right:0, bottom:30, left:0},
					colorArr : ['#ff8166','#ffd3a6','#2e6695','#17c0c0','#72f5c4','#777'],
					root : null,
					node : null
			};
			
			chart_config = $.extend(chart_config,options);
			
			d3.select("#viewport").html("");

			var chartWidth = Number(d3.select('#viewport').style('width').replace("px", "")) - chart_config.chartMargin.left - chart_config.chartMargin.right;
			var chartHeight = Number(d3.select('#viewport').style('height').replace("px", "")) - chart_config.chartMargin.top - chart_config.chartMargin.bottom;
			
			var xScale = d3.scale.linear().range([0, chartWidth]);
			var	yScale = d3.scale.linear().range([0, chartHeight]);
			
			var color = d3.scale.ordinal().range(chart_config.colorArr);

			var svg = d3.select("#viewport")
						.append("div")
						.attr("class", "chart")
						.style("width", chartWidth + "px")
						.style("height", chartHeight + "px")
						.append("svg:svg")
						.attr("width", chartWidth)
						.attr("height", chartHeight)
						.append("svg:g")
						.attr("transform", "translate(.5,.5)");

			var nodes = tree_map(chartData, chartWidth, chartHeight);

			// 정렬
			nodes.sort(function(a, b) {
				return  getDepth1value(b) - getDepth1value(a) ;
			});
			
			var cell = svg.selectAll("g")
						  .data(nodes)
						  .enter()
						  .append("svg:g")
						  .attr("class", "cell")
						  .attr("transform", function(d) {
							  return "translate(" + (d.x) + "," + (d.y) + ")";
						  });

			cell.append("svg:rect")
				.attr("width", function(d) {
					return d.dx +1.5;
				})
				.attr("height", function(d) {
					return d.dy +1.5;
				})
				.style("fill", function(d) {
					return color(d.color);
				})
				.style("stroke", function(d) {
					return d3.rgb(color(d.color)).darker(0.6);
				})
				.style("vector-effect","non-scaling-stroke")
				.style("shape-rendering","crispEdges")
				.style("transform","none");
			
			cell.append("svg:text")
			    .text(function(d) {
		    	  return d.name;
		  		 })
		        .attr("x",0)
		        .attr("dy", "0.9em") 
				.style("fill", function(d) {
					var c = color(d.color)
					if(getContrastYIQ(c) == 'black'){
						c = d3.rgb(c).darker(2);
					}else{
						c = d3.rgb(c).brighter(4.5);
					}
					return c;
				})
		        .each(function(d){
			    	wFontSize(d.name,this);
			    });
			
			cell.append("svg:text")
			    .text(function(d) {
			    	var str = d3.round(( (d.value/getRootvalue(d))*100),2)+"%";
				  	return str;    
				})
			    .attr("text-anchor", "middle")
			    .attr("x",function(d){
			          return d.dx / 2;
			    })
			    .attr("y",function(d){
			    	return (d.dy -(d.dy/20));
			    })
			    .style("fill", function(d) {
					var c = color(d.color);
					if(getContrastYIQ(c) == 'black'){
						c = d3.rgb(c).darker(2);
					}else{
						c = d3.rgb(c).brighter(4.5);
					}
					return c;
				})
			    .each(function(d){
			    	var str = d3.round(( (d.value/getRootvalue(d))*100),2)+"%";
			    	wFontSize(str,this,true);
			    });	
		}
		
		/**
		* 배열 group by
		* @param data group by를 할 배열
		* @param nestArr group을 형성할 기준이 되는 colum 들
		**/
		function groupData(data, nestArr) {
			var d, groupedData, i, j, k, len, len1, n, strippedData, val;
			groupedData = d3.nest();

			for (i = 0, len = nestArr.length; i < len; i++) {
				n = nestArr[i];
				(function(n) {
					return groupedData.key(function(d) {
						return d[n];
					});
				})(n);
			}
			return groupedData.entries(data);
		}

		/**
		* treemap을 그리기 위한 데이터 정의
		* @param chartData 차트에 사용할 data
		* @param w 차트 영역의 width
		* @param h 차트 영역의 height
		* return data ( treemap에 최적화된 데이터 형태를 return )
		**/
		var tree_map = function(chartData, w, h) {
			var d, data, groupedData, i, len, returnData, root;
			groupedData = groupData(chartData, ["code", "name"]);
			data = d3.layout.treemap()
							.mode("squarify")
							.round(true)
							.size([w, h])
							.children(function(d) {
								return d.values;
							})
							.padding(1)
							.sort(function(a, b) {
								return  a.value - b.value;
							})
							.nodes({
								name: "root",
								values: groupedData
							})
							.filter(function(d) {
								return !d.values && d.area;
							});
			;
			return data;
		};

		/**
		* node의 depth 찾기
		* @param node 
		**/
		function getDepth1value(node){
			if(node.depth > 1){
				return getDepth1value(node.parent);
			}
			return node.value;
		}

		/**
		* node의 상위 그룹 찾기
		* @param node 
		**/
		function getRootvalue(node){
			if(node.depth > 0){
				return getRootvalue(node.parent);
			}
			return node.value;
		}

		/**
		* box size 와 font size 에 따른 줄바꿈 함수
		* @param str 줄바꿈을 적용한 text
		* @param off (box width)/(font size) 한줄에 들어갈 수 있는 최대 글자수 
		* return rtn 최대 글자수로 쪼개진 text를 배열로 담아서 retrun
		**/
		function lineBreak(str , off){
		    var len, point, str; 
		    var rtn =[]
		       
		    point =  off ;
		    len = str.length;
		    rtn.push(str.substring(0, point));
		    
		    while (point < len) {
		    	var tmpStr = str.substring(point, point + off);
		        rtn.push(tmpStr);
		        point += off; 
		    } 
		    return rtn;
		 
		}

		/**
		* 어둔색에 가까운 색인지 밝은 색에 가까운 색인지 구분하기 위한 함수 
		* @param color 보색을 찾기 위한 상대 색
		* return black(color 값이 밝은 색에 가까움) / white(color 값이 어두운 색에 가까움)
		**/
		var getContrastYIQ = function(color) {
			  var hex = '#';
			  var r, g, b;
			  if (color.indexOf(hex) > -1) {
			    r = parseInt(color.substr(1, 2), 16);
			    g = parseInt(color.substr(3, 2), 16);
			    b = parseInt(color.substr(5, 2), 16);
			  } else {
			    color = color.match(/\d+/g);
			    r = color[0];
			    g = color[1];
			    b = color[2];
			  }

			  var yiq = ((r * 299) + (g * 587) + (b * 114)) / 1000;
			  return (yiq >= 128) ? 'black' : 'white';
		}

		/**
		* 박스의 크기에 따른 font size 를 계산하는 함수
		* @param str 박스안에 들어갈 text
		* @param obj 박스 object
		* @param nowrap true / false ( 줄바꿈 사용 유무 )
		* return
		**/
		function wFontSize(str,obj,nowrap){
			
			var w =  Number(d3.select(obj.parentElement.firstChild).attr("width"));
			var h =  Number(d3.select(obj.parentElement.firstChild).attr("height"));
			var size = Math.min(  (w / (0.8 * 10))  ,  (h / (0.8 * 10))  );
			size = size *2;
			var el = d3.select(obj);
			if(size == 0 )
				console.log(size);	

			el.style("font-size", size + "px");
			if(!nowrap){
				
				var words = lineBreak(str,w/size);
				var strOffset = 0;
				
				el.text('');
			
				for (var i = 0; i < words.length; i++) {
					var tspan = el.append('tspan').text(words[i]);
					if (i > 0)
						tspan.attr('x', 0).attr('dy', (i*size));
				}
			}
			
		}
	</script>
	</body>
</html>