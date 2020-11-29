<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>
<html>
<head>
<title>Home</title>
</head>


<script type="text/javascript" src="/js/d3Chart/d3.min.js"></script>

<script type="text/javascript" src="/js/jquery/jquery-1.11.2.min.js"></script>
<script type="text/javascript">
var chartData =[{"d3plus":{"data":{},"depth":1,"active":0,"temp":0,"total":1},"color":"D","code":"소매","name":"편의점","value":86888841823,"id":"ND0006"},{"d3plus":{"data":{},"depth":1,"active":0,"temp":0,"total":1},"color":"D","code":"소매","name":"의복/의류","value":77610224297,"id":"ND0008"},{"d3plus":{"data":{},"depth":1,"active":0,"temp":0,"total":1},"color":"D","code":"소매","name":"슈퍼마켓","value":54474284493,"id":"ND0005"},{"d3plus":{"data":{},"depth":1,"active":0,"temp":0,"total":1},"color":"D","code":"소매","name":"화장품소매","value":32326930780,"id":"ND0013"},{"d3plus":{"data":{},"depth":1,"active":0,"temp":0,"total":1},"color":"D","code":"소매","name":"패션잡화","value":26991794665,"id":"ND0009"},{"d3plus":{"data":{},"depth":1,"active":0,"temp":0,"total":1},"color":"D","code":"소매","name":"가전제품","value":24869190495,"id":"ND0014"},{"d3plus":{"data":{},"depth":1,"active":0,"temp":0,"total":1},"color":"D","code":"소매","name":"사무/도서용품","value":20456577080,"id":"ND0011"},{"d3plus":{"data":{},"depth":1,"active":0,"temp":0,"total":1},"color":"D","code":"소매","name":"일반식료품","value":16075704154,"id":"ND0004"},{"d3plus":{"data":{},"depth":1,"active":0,"temp":0,"total":1},"color":"D","code":"소매","name":"축산물","value":12282576715,"id":"ND0003"},{"d3plus":{"data":{},"depth":1,"active":0,"temp":0,"total":1},"color":"D","code":"소매","name":"기념품/화훼","value":10586046960,"id":"ND0012"},{"d3plus":{"data":{},"depth":1,"active":0,"temp":0,"total":1},"color":"D","code":"소매","name":"스포츠/레저용품","value":9167575370,"id":"ND0010"},{"d3plus":{"data":{},"depth":1,"active":0,"temp":0,"total":1},"color":"D","code":"소매","name":"농산물","value":9144624562,"id":"ND0001"},{"d3plus":{"data":{},"depth":1,"active":0,"temp":0,"total":1},"color":"D","code":"소매","name":"건강/보조식품","value":8454862783,"id":"ND0007"},{"d3plus":{"data":{},"depth":1,"active":0,"temp":0,"total":1},"color":"D","code":"소매","name":"수산물","value":1777377572,"id":"ND0002"},{"d3plus":{"data":{},"depth":1,"active":0,"temp":0,"total":1},"color":"F","code":"생활서비스","name":"이미용서비스","value":127695393078,"id":"NF0001"},{"d3plus":{"data":{},"depth":1,"active":0,"temp":0,"total":1},"color":"F","code":"생활서비스","name":"주유소/충전소","value":34289582331,"id":"NF0004"},{"d3plus":{"data":{},"depth":1,"active":0,"temp":0,"total":1},"color":"F","code":"생활서비스","name":"사진관","value":28543534849,"id":"NF0003"},{"d3plus":{"data":{},"depth":1,"active":0,"temp":0,"total":1},"color":"F","code":"생활서비스","name":"차량관리","value":23147869515,"id":"NF0005"},{"d3plus":{"data":{},"depth":1,"active":0,"temp":0,"total":1},"color":"F","code":"생활서비스","name":"세탁소","value":5783087075,"id":"NF0002"},{"d3plus":{"data":{},"depth":1,"active":0,"temp":0,"total":1},"color":"O","code":"숙박","name":"골프스포츠","value":16852843519,"id":"NO0002"},{"d3plus":{"data":{},"depth":1,"active":0,"temp":0,"total":1},"color":"O","code":"숙박","name":"숙박","value":16291724350,"id":"NO0001"},{"d3plus":{"data":{},"depth":1,"active":0,"temp":0,"total":1},"color":"O","code":"숙박","name":"일반스포츠","value":12995742292,"id":"NO0003"},{"d3plus":{"data":{},"depth":1,"active":0,"temp":0,"total":1},"color":"Q","code":"음식","name":"한식","value":318012587849,"id":"NQ0003"},{"d3plus":{"data":{},"depth":1,"active":0,"temp":0,"total":1},"color":"Q","code":"음식","name":"일반주점","value":91180638845,"id":"NQ0013"},{"d3plus":{"data":{},"depth":1,"active":0,"temp":0,"total":1},"color":"Q","code":"음식","name":"유흥주점","value":88187026995,"id":"NQ0014"},{"d3plus":{"data":{},"depth":1,"active":0,"temp":0,"total":1},"color":"Q","code":"음식","name":"양식","value":85239827871,"id":"NQ0006"},{"d3plus":{"data":{},"depth":1,"active":0,"temp":0,"total":1},"color":"Q","code":"음식","name":"커피/디저트","value":73654355982,"id":"NQ0012"},{"d3plus":{"data":{},"depth":1,"active":0,"temp":0,"total":1},"color":"Q","code":"음식","name":"고기요리","value":53791933005,"id":"NQ0001"},{"d3plus":{"data":{},"depth":1,"active":0,"temp":0,"total":1},"color":"Q","code":"음식","name":"일식/횟집","value":52431597015,"id":"NQ0008"},{"d3plus":{"data":{},"depth":1,"active":0,"temp":0,"total":1},"color":"Q","code":"음식","name":"분식","value":48604555651,"id":"NQ0005"},{"d3plus":{"data":{},"depth":1,"active":0,"temp":0,"total":1},"color":"Q","code":"음식","name":"한식국/탕/찌개","value":45895510030,"id":"NQ0004"},{"d3plus":{"data":{},"depth":1,"active":0,"temp":0,"total":1},"color":"Q","code":"음식","name":"닭/오리요리","value":36002543475,"id":"NQ0002"},{"d3plus":{"data":{},"depth":1,"active":0,"temp":0,"total":1},"color":"Q","code":"음식","name":"중국음식","value":29090446844,"id":"NQ0007"},{"d3plus":{"data":{},"depth":1,"active":0,"temp":0,"total":1},"color":"Q","code":"음식","name":"수산물요리","value":23665340976,"id":"NQ0009"},{"d3plus":{"data":{},"depth":1,"active":0,"temp":0,"total":1},"color":"Q","code":"음식","name":"간식/패스트푸드","value":16723545809,"id":"NQ0011"},{"d3plus":{"data":{},"depth":1,"active":0,"temp":0,"total":1},"color":"Q","code":"음식","name":"기타외국식","value":3944745173,"id":"NQ0010"},{"d3plus":{"data":{},"depth":1,"active":0,"temp":0,"total":1},"color":"S","code":"의료","name":"특화병원","value":254836460261,"id":"NS0004"},{"d3plus":{"data":{},"depth":1,"active":0,"temp":0,"total":1},"color":"S","code":"의료","name":"일반병원","value":152392052685,"id":"NS0003"},{"d3plus":{"data":{},"depth":1,"active":0,"temp":0,"total":1},"color":"S","code":"의료","name":"의약/의료품","value":80634889695,"id":"NS0002"},{"d3plus":{"data":{},"depth":1,"active":0,"temp":0,"total":1},"color":"S","code":"의료","name":"동물병원","value":12297170315,"id":"NS0001"}];

var chart_config = {
		legend_width : 50,
		legend_margin : {top: 10, left:5}
}

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
	return data;
};

function getDepth1value(node){
	if(node.depth > 1){
		return getDepth1value(node.parent);
	}
	return node.value;
}


function getRootvalue(node){
	if(node.depth > 0){
		return getRootvalue(node.parent);
	}
	return node.value;
}

function groupBy(node, key){
	return node.reduce(function(rv,x){
		data = {color: x.color, code:x.code};
		if(rv.length > 0){
			var addObj = true;
			for(var i in rv){
				if(rv[i][key] == x[key]) addObj = false;
			}
			if(addObj){
				rv.push(data); 
			}
		}else{
			rv = [];
			rv.push(data); 
		}
// 		  (rv[0] = rv[x[key]] || []).push(x);
		    return rv;
	},{});
}

function fontSize(d, i) {
	
// 	
	
	var rectColor = d3.select(this.previousElementSibling).style("fill");
// 	console.log(p.find("rect").css("fill"));
	//console.log(d3.select(p[0]).style("fill"));
	var rectWidth = d3.select(this.previousElementSibling).attr("width");
	
	var size = 10;
	//size = (d.dx + d.dy) / 10;
	size = Math.min( (d.dx/4) , (d.dy/4) );
	
	d3.select(this)
		.append("tspan")
	    .attr("x", 2)
	    .attr("y", size)
	    .style('fill', function(d){
	    	var fill = d3.rgb(rectColor).darker(2);
	    	if((d3.rgb(rectColor).r + d3.rgb(rectColor).g + d3.rgb(rectColor).b) < (255*3/2)){
	    		fill = d3.rgb(rectColor).brighter(5);
	    	}
	    	return 	fill;
	    })
// 	    .style("font-size", (size-1) + "px")
		.style("font-size", function(){
			var TextSize = d3.round(rectWidth/d.name.length);
			return (Math.min(TextSize,size)-1);
		})
	    .text(function(d){
	    	var textValue = d.name;
// 	    	if(d.name.length > length){
// 	    		if(length > 1){	    			
// 	    			textValue = textValue.substr(0,(length-1))+"...";
// 	    		}else{
// 	    			textValue = textValue.substr(0,length);	    			
// 	    		}
// 	    	}
	    	return textValue;
	    });
	
	
	var color = d3.scale.ordinal().range(['#ff8166','#ffd3a6','#2e6695','#17c0c0','#72f5c4','#777']);
	
	
	d3.select(this)
		.append("tspan")
	    .attr("x", function(d){
	    	return 4;
	    })
	    .attr("y", d.dy)
	    .attr("text-anchor", "middle")
	    .style('fill', function(d){
	    	return 	d3.rgb(rectColor).darker(1);
	    })
	    .style("font-size", (size-1) + "px")
	    .text(   d3.round(( (d.value/getRootvalue(d))*100),2)  +"%" ).attr("x",function(d){
          return d.dx / 2;
        });
		
// 	var size = d.dx / 4;
// 	var words = d.name.split(' ');
// 	var word = words[0];
// 	var width = d.dx;
// 	var height = d.dy;
// 	var length = 0;
// 	d3.select(this).style("font-size", (size) + "px").text(word);
// 	while (((this.getBBox().width >= width) || (this.getBBox().height >= height/3)) && (size > 12)) {
// 		size--;
// 		d3.select(this).style("font-size", (size) + "px");
// 		this.firstChild.data = word;
// 	}
}

function drawChart() {

	var w = 645 - 0,
		h = 301 - 60,
		x = d3.scale.linear().range([0, w]),
		y = d3.scale.linear().range([0, h]),
		color = d3.scale.ordinal().range(['#ff8166','#ffd3a6','#2e6695','#17c0c0','#72f5c4','#777']),
		root,
		node;

	var svg = d3.select("#viewport").append("div")
		.attr("class", "chart")
		.style("width", w + "px")
		.style("height", h + "px")
		.append("svg:svg")
		.attr("width", w)
		.attr("height", h)
		.append("svg:g")
		.attr("transform", "translate(.5,.5)");

	var nodes = tree_map(chartData, w, h);

	
	nodes.sort(function(a, b) {
		return  getDepth1value(b) - getDepth1value(a) ;
	})
// 	console.log(nodes);
	var cell = svg.selectAll("g")
		.data(nodes)
		.enter().append("svg:g")
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
     .each(fontSize);
//     x: d.x + d.dx / 2,
//     y: d.y + d.dy / 2,
//     width: d.dx,
//     height: d.dy,



		// 범례
// 	  var legendData = groupBy(nodes,'color');
// 	  var legend = svg.selectAll(".legend")
// 				      .data(legendData)
// 				      .enter().append("g")
// 				      .attr("class", "legend")
// 				      .attr("transform", function(d) { 
// 				    	  	var legendml = chart_config.legend_margin.top;
// 				    		return "translate(0," + (h - margin.bottom + 10) + ")"; 
// 				      });
	  
// 		  legend.append("rect")
// 			      .attr("x", function(d,i){
// 			    	  var legendw = chart_config.legend_width;
// 			    	  var legendml = chart_config.legend_margin.left;
// 			    	  var legendCellw = legendw+(legendml *2);
// 			    	  var starter =(legendw * legendData.length) + (legendml * (legendData.length -1) * 2);
// 			    	  starter = (w - starter)/2;
			    	  
// 			    	  return(starter + (legendCellw * i)); 
// 			      })
// 			      .attr("width", chart_config.legend_width)
// 			      .attr("height", chart_config.legend_width)
// 			      .style("fill", function(d){ 
// 			    	  return color(d.color);
// 			       });
		  
// 			legend.append("text")
// 		    	  .append("tspan")  
// 		    	  .attr("x", function(d,i){ 
// 		    		  var legendw = chart_config.legend_width;
// 			    	  var legendml = chart_config.legend_margin.left;
// 			    	  var legendCellw = legendw+(legendml *2);
// 			    	  var starter =(legendw * legendData.length) + (legendml * (legendData.length -1) * 2);
// 			    	  starter = (w - starter)/2;
			    	  
// 			    	  return(starter + (legendCellw * i)); 
// 		    	  })
// 		    	  .attr("y", function(d){ return d.dy;})
// 		    	  .attr("dy", "7px")
// 		    	  .attr("dominant-baseline","alphabetic")
// 		    	  .style("baseline-shift","0%")
// 		    	  .style("font-size","12px")
// 		    	  .text(function(d){
// 			    	  return d.code; 
// 		    	  });
	
}
$(document).ready(function() {


	drawChart();

});
</script>
<style>

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
<body>
	<h1>index page</h1>

	<div id="viewport" "></div>
</body>
</html>
