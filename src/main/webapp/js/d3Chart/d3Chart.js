Date.prototype.addHours = function(h) {    
   this.setTime(this.getTime() + (h*60*60*1000)); 
   return this;   
};
Date.prototype.addDays = function(days) {
  var dat = new Date(this.valueOf());
  dat.setDate(dat.getDate() + days);
  return dat;
};

/**
 * String to Date 변환
 * @param strdate 변활할 String (ex: '20161201')
 * @returns {Date}
 */
function yyyymmddToDate(strdate){
	return new Date(strdate.substr(0,4)+"-" +strdate.substr(4,2) +"-" +  strdate.substr(6,2));
}

/****
 * D3
 ****/


/**
 * treemap chart (사용 안함) 
 * @param inputData		표현할 data
 * @param divId			그래프를 그릴 div 의 id
 * @param  total		전체 합계
 */
function treemapChart(inputData, divId, total){
	
	var width = 960, height = 300;
	// 색상정의 ( 주석부분은 d3에서 지정한 색상 사용하는 거 : schemeCategory20)		
// 	var fader = function(color) { return d3.interpolateRgb(color, "#fff")(0.2); },
//     	color = d3.scaleOrdinal(d3.schemeCategory20.map(fader)),
	var	color = d3.scaleOrdinal().range(['#7013c4', '#d62728', '#2ca02c', '#ff7f0e', '#1626ce']),
    	format = d3.format(",d");
	
	var canvas = d3.select(divId)
				   .attr('width', width)
				   .attr("height", height);
	
	var treemap = d3.treemap()
					.tile(d3.treemapResquarify)
					.size([width,height])
					.round(true)
				    .paddingInner(1);
	
	var root = d3.hierarchy(inputData)
			     .eachBefore(function(d) { d.data.id = (d.parent ? d.parent.data.id + "." : "") + d.data.name; })
			     .sum(sumBySize)
			     .sort(function(a, b) { return b.height - a.height || b.value - a.value; });
	
	 treemap(root);
	 
	  var cell = canvas.selectAll("g")
				    .data(root.leaves())
				    .enter().append("g")
				    .attr("transform", function(d) { return "translate(" + d.x0 + "," + d.y0 + ")"; });
	  
	  // 각각의 cell 표현
	  cell.append("rect")
	      .attr("id", function(d) { return d.data.id; })
	      .attr("width", function(d) { return d.x1 - d.x0; })
	      .attr("height", function(d) { return d.y1 - d.y0; })
	      .attr("fill", function(d) { return color(d.parent.data.id); });
	  
	  
	  cell.append("clipPath")
      	  .attr("id", function(d) { return "clip-" + d.data.id; })
    	  .append("use")
      	  .attr("xlink:href", function(d) { return "#" + d.data.id; });

	  cell.append("text")
	      .attr("clip-path", function(d) { return "url(#clip-" + d.data.id + ")"; })
	      .selectAll("tspan")
	      .data(function(d) {return [d.data.name, ((d.value/total)*100).toFixed()+"%"]; })
	      .enter().append("tspan")
	      .attr("x", 4)
	      .attr("y", function(d, i) { return 13 + i * 10; })
	      .style('fill', 'white')
	      .text(function(d) { return d; });
	  
	  // tooltip
	  cell.append("title")
      	  .text(function(d) { return d.data.id + "\n" + format(d.value)+"원"; });
			 
	
	function sumBySize(d) {
		return d.size;
	}
}

/**
 * 수평 막대그래프 (사용안함)
 * @param chartData  표현할 data
 * @param divId      그래프를 그릴 div의 id
 */
function hozBarChart(chartData, divId){
	var barChartData = chartData;
//	console.log(barChartData);
	
	var margin = {top: 20, right: 30, bottom: 30, left: 40},
	    width = 960 - margin.left - margin.right,
	    height = 500 - margin.top - margin.bottom,
	    barHeight =20;
	
	// Scale
	var y = d3.scaleBand()
			  .range([height, 0])
			  .padding(0.1)
			  .domain(chartData.map(function(d){ return d.name; }));

	var x = d3.scaleLinear()
			  .range([0,width])
			  .domain([0, d3.max(chartData, function(d){return d.value; })]);

	// Axis
	var xAxis = d3.axisBottom(x);
	var yAxis = d3.axisLeft(y); 
	
	var chart = d3.select(divId)
				  .attr("width", width + margin.left + margin.right)
				  .attr("height", height + margin.top + margin.bottom)
				  .append("g")
				  .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
	
	// x Axis
	chart.append("g")
	     .attr("class", "x axis")
	     .attr("transform", "translate(0," + height + ")")
	     .call(xAxis);
	  
	// y Axis
	chart.append("g")
	     .attr("class", "y axis")
	     .call(yAxis); 
	
	// draw column
	chart.selectAll(".bar")
	     .data(chartData)
	     .enter().append("rect")
	     .attr("class", "bar")
//	     .attr("x", function(d) { return x(d.sale_cnt); })
	     .attr("y", function(d) { return y(d.name); })
	     .attr("height", barHeight -1 +"px")
	     .attr("width", function(d) { return x(d.value); })
	     .style('fill', 'steelblue');
	 
	chart.selectAll(".bar")
		 .append("text")
	     .attr("x", function(d) { return x(d.value) - 3; })
	     .attr("y", barHeight / 2)
	     .attr("dy", ".75em")
	     .text(function(d) { return d.value; })
	     .style('fill', 'white')
	     .style('font', '10px sans-serif')
	     .style('text-anchor','middle');
}

/**
 * 수직 바 차트 ( 사용 안함 )
 * @param chartData   표현할 data
 * @param divId		  그래프를 그릴 div의 id
 * @param attributes[]  색 매칭 배열
 */
function barChart(chartData, divId, attributes){
	var barChartData = chartData;
	
	var margin = {top: 20, right: 30, bottom: 30, left: 40},
	    width = 960 - margin.left - margin.right,
	    height = 500 - margin.top - margin.bottom;
	
	var color = function(name){
		$.each(attributes,function(index, item){
			if(item.name == name){
				console.log(item.hex);
				return item.hex;
			}
		});
	}
	
	// Scale
	var x = d3.scaleBand()
			  .range([0,width])
			  .padding(0.1)
			  .domain(chartData.map(function(d){ return d.time; }));

	var y = d3.scaleLinear()
			  .range([height, 0])
			  .domain([0, d3.max(chartData, function(d){return d.value; })]);

	// Axis
	var xAxis = d3.axisBottom(x);
	var yAxis = d3.axisLeft(y); 
	
	var chart = d3.select(divId)
				  .attr("width", width + margin.left + margin.right)
				  .attr("height", height + margin.top + margin.bottom)
				  .append("g")
				  .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
	
	// x Axis
	chart.append("g")
	     .attr("class", "x axis")
	     .attr("transform", "translate(0," + height + ")")
	     .call(xAxis);
	  
	// y Axis
	chart.append("g")
	     .attr("class", "y axis")
	     .call(yAxis); 
	
	// draw column
	chart.selectAll(".bar")
	     .data(chartData)
	     .enter().append("rect")
	     .attr("class", "bar")
	     .attr("x", function(d) { return x(d.time); })
	     .attr("y", function(d) { return y(d.value); })
	     .attr("height", function(d) { return height - y(d.value); })
	     .attr("width", x.bandwidth)
	     .style('fill', function(d) { 
	    	 					 var color ="#CC0000";
						    	 $.each(attributes,function(index, item){
						 			if(item.name == d.name){
						 				color = item.hex;
						 			}
						 		});
						    	 return color;
	    	 	});
	 
	chart.selectAll(".bar")
		 .append("text")
	     .attr("x", x.bandwidth() / 2)
	     .attr("y", function(d) { return x(d.value) + 3; })
	     .attr("dy", ".75em")
	     .text(function(d) { return d.value; })
	     .style('fill', 'white')
	     .style('font', '10px sans-serif')
	     .style('text-anchor','middle');
}

/**
 * 그룹바 차트 (사용안함)
 * @param chartData     표현할 data
 * @param divId		    그래프를 그릴 div의 id
 * @param attributes[]  색 매칭 배열
 */
function groupedBar(chartData, divId, attributes){

	var margin = {top: 20, right: 30, bottom: 30, left: 40},
	    width = 960 - margin.left - margin.right,
	    height = 500 - margin.top - margin.bottom;
	
	var y = d3.scaleLinear()
	    .domain([0, d3.max(chartData[0], function(d){return d.value; })])
	    .range([height, 0]);
	
	var x0 = d3.scaleBand()
	    .domain(chartData[0].map(function(d){ return d.time; }))
	    .padding(0.5)
	    .range([0, width]);
	
	var xwidth = x0.bandwidth();

	var x1 = d3.scaleBand()
	    .domain(chartData[1].map(function(d){ return d.name; }))
	    .range([0, xwidth]);
	
	var z = attributes;
	
	var xAxis = d3.axisBottom(x0);
	var yAxis = d3.axisLeft(y); 
	
	var svg = d3.select(divId)
	    .attr("width", width + margin.left + margin.right)
	    .attr("height", height + margin.top + margin.bottom)
	    .append("g")
	    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
	
	svg.append("g")
	    .attr("class", "y axis")
	    .call(yAxis);
	
	svg.append("g")
	    .attr("class", "x axis")
	    .attr("transform", "translate(0," + height + ")")
	    .call(xAxis);
	
	svg.append("g").selectAll("g")
	   .data(chartData)
	   .enter().append("g")
	   .style("fill", function(d, i) { return z[i].hex; })
	   .attr("transform", function(d, i) { transX1 = x1(d[i].name) === undefined? x1.bandwidth(): x1(d[i].name); return "translate("+transX1+",0)"; })
	   .selectAll("rect")
	   .data(function(d) { return d; })
	   .enter().append("rect")
	   .attr("width", x1.bandwidth()-10)
	   .attr("height",  function(d) { return height - y(d.value); })
	   .attr("x", function(d, i) {  return x0(d.time) - 30; })
	   .attr("y", function(d) { return y(d.value); });
	
	var legend = svg.selectAll(".legend")
				    .data(attributes)
				    .enter().append("g")
				    .attr("class", "legend")
				    .attr("transform", function(d, i) { return "translate(0," + i * 20 + ")"; });
		
		legend.append("rect")
		    .attr("x", 24)
		    .attr("width", 18)
		    .attr("height", 18)
		    .style("fill", function(d){return d.hex;});
		
		legend.append("text")
		    .attr("x", 100)
		    .attr("y", 9)
		    .attr("dy", ".35em")
		    .style("text-anchor", "end")
		    .text(function(d) { return d.name; });
	
}

/**
 * stack group bar chart
 * @param chartData[]     표현할 data
 * @param divId		      그래프를 그릴 div의 id
 * @param attributes[]    x축에 사용할 column 명 배열 
 * @param legend[]		  범례에 사용할 값
 * @param tLength		  y축의 ticks
 */
function stackedGroupedbar(chartData, divId, attributes, legend, tLength){

	var $container = $(divId);
	var cwidth = $container.width();
	var cheight = $container.height();
	
	var margin = {top: 20, right: 20, bottom: 100, left: 40},
    	 width = cwidth - margin.left - margin.right,
    	height = cheight - margin.top - margin.bottom;
 
	var x0 = d3.scale.ordinal()
	    			 .rangeRoundBands([0, width], 0.3);
	 
	var x1 = d3.scale.ordinal();
	 
	var y = d3.scale.linear()
					.range([height, 0]);
	 
	var xAxis = d3.svg.axis()
				      .scale(x0)
				      .orient("bottom")
				      .innerTickSize(-(height));
	 
	var yAxis = d3.svg.axis()
				      .scale(y)
				      .orient("left")
				      .innerTickSize(-(width))
				      .ticks(tLength)
				      .tickFormat(function(d){return d+"%";});
//				      .tickFormat(d3.format(".2s"));
 
	var color = d3.scale.ordinal()
						.range(["#2e6695", "#ff8166", "#9b9b9b", "#d3d3d3"]);
	
	// Define the div for the tooltip
	var div = d3.select(divId).append("div")	
							  .attr("class", "tooltip")				
							  .style("opacity", 0);
	
	var svg = d3.select(divId).append("svg")
							   .attr("width", width + margin.left + margin.right)
							   .attr("height", height + margin.top + margin.bottom)
							   .append("g")
							   .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

	 
	  x0.domain(chartData.map(function(d) { return d.name; }));
	  x1.domain(d3.keys(attributes)).rangeRoundBands([0, x0.rangeBand()]);
	 
	  y.domain([0, d3.max(chartData, function(d) { 
	    return d.total; 
	  })]);
	 
	  svg.append("g")
	  	  .attr("class", "axisStack")
//	      .attr("class", "x axis")
	      .attr("transform", "translate(0," + height + ")")
	      .call(xAxis);
	 
	  svg.append("g")
//	      .attr("class", "y axis")
	  	  .attr("class", "axisStack")
	      .call(yAxis)
	      .append("text")
	      .attr("transform", "rotate(-90)")
	      .attr("y", 6)
	      .attr("dy", ".7em")
	      .style("text-anchor", "end")
	      .text("");
	 
	  var project_stackedbar = svg.selectAll(".project_stackedbar")
							      .data(chartData)
							      .enter().append("g")
							      .attr("class", "g")
							      .attr("transform", function(d) { return "translate(" + x0(d.name) + ",0)"; });
	 
	  project_stackedbar.selectAll("rect")
				        .data(function(d) { return d.columnDetails; })
				        .enter()
				        .append("rect")
				        .attr("width", x1.rangeBand())
				        .attr("x", function(d) { 
				        	return x1(d.column);
				        })
				        .attr("y", function(d) {
				        	return y(d.yEnd); 
				        })
					    .attr("height", function(d) { 
					        return y(d.yBegin) - y(d.yEnd); 
					    })
					    .style("fill", function(d) { return color(d.name); })
					    .style("fill-opacity","0.9")
					    .on("mouseover", function(d) {	
					            div.transition()		
					               .duration(200)		
					               .style("opacity", 1);		
					            div.html( function(){ 
					            			var data =[];
					            			if(d){
					            				var dataArr = {};
					            				dataArr.name = d.name_ko;
					            				dataArr.value = d.realValue+"%";
					            				dataArr.color = color(d.name);
					            				data.push(dataArr);
					            			}
					            			return getTooltip(data);
					            	 })	
					            	.style("position","absolute")
					                .style("left", function() {
					                	
					                		var left = d3.event.pageX - ($(".article_rg").innerWidth() - cwidth + 40);
					                		
					                		if(left > (cwidth - margin.left - margin.right - 200)) left = cwidth - margin.left - margin.right - 200;
					                	
					                		if(divId === "#cntBar1" || divId === '#cntBar2'){
//							        			left =  d3.event.pageX - cwidth + margin.right + margin.left + x0.rangeBand() + x1.rangeBand();
					                			var tooltipWidth = $('#d3plus_tooltip_id_visualization_focus').width();
							        			left = event.offsetX - (tooltipWidth / 2) ;
							        		}
					                	
						        		return left + "px";
					                })		
						            .style("top",  function(){
						            	if(divId == "#cntBar1" || divId == "#cntBar2"){
						            		return y(d.yEnd) - margin.top -20 +"px";
						        		}else{
//						        			// 마우스의 위치 - 첫번째 섹션의 높이 - (지도 혹은 그래프의 높이 * 2) - (지도 혹은 그래프의 top, bottom padding 값 ) - 항상 따라다니는 top의 높이 +(이 그래프의 margin bottom)
						        			var top = d3.event.pageY -  $('.section').height() - (cheight*2) - 115 - 192 + margin.bottom;
							        		return top +"px";
						        		}
						            });	
//				                .style("left", (d3.event.pageX - 155) + "px")		
//				                .style("top",  function(){ return y(d.yEnd)+"px";});	
				        })	
				        .on("mousemove", function(d){
				        	div.style("left", function(){
					        		var left = d3.event.pageX - ($(".article_rg").innerWidth() - cwidth + 40) -100;
				                	if(left > (cwidth - margin.left - margin.right - 200)) left = cwidth - margin.left - margin.right - 200;
				                	
					        		if(divId === "#cntBar1" ||  divId === '#cntBar2'){
//					        			left =  d3.event.pageX - cwidth + margin.right + margin.left + x0.rangeBand() + x1.rangeBand();
					        			var tooltipWidth = $('#d3plus_tooltip_id_visualization_focus').width();
					        			left = event.offsetX - (tooltipWidth / 2) ;
					        		}
				                	
				                	return left + "px";
					        	})
					        	.style("top",  function(){
					        		if(divId == "#cntBar1" || divId == "#cntBar2"){
					        			return y(d.yEnd) - margin.top -20 +"px";
					        		}else{
//					        			// 마우스의 위치 - 첫번째 섹션의 높이 - (지도 혹은 그래프의 높이 * 2) - (지도 혹은 그래프의 top, bottom padding 값 ) - 항상 따라다니는 top의 높이 +(이 그래프의 margin bottom)
					        			var top = d3.event.pageY -  $('.section').height() - (cheight*2) - 115 - 192 + margin.bottom;
					        			return top +"px";
					        		}
					            });	
				        })
				        .on("mouseout", function(d) {		
					            div.transition()		
					                .duration(500)	
					                .style("opacity", 0);
				        });
	 
	  var legend = svg.selectAll(".legend")
				      .data(legend)
				      .enter().append("g")
				      .attr("class", "legend")
				      .attr("transform", function(d, i) { 
				    		return "translate(0," + (cheight - 90) + ")"; 
				      });
	 
	    legend.append("rect")
		      .attr("x", function(d,i){ return(((width-230)/2)+(60*i)); })
		      .attr("width", 50)
		      .attr("height", 50)
		      .style("fill", function(d){ return d.color;});

	 
	    legend.append("text")
		      .attr("x", function(d,i){ return(((width-230)/2)+(60*i))+30; })
		      .attr("y", 15)
		      .attr("width", 8+"px")
		      .attr("dy", ".35em")
		      .style("text-anchor", "middle");
	    
	    legend.select("text")
		      .attr("class", function(d){
	    		  if(d.value.indexOf("방문객") != -1){
	    			  return "changeColor";
	    		  }
	    	  })
	    	  .append("tspan")  
	    	  .attr("x", function(d,i){ return(((width-230)/2)+(60*i))+25; })
	    	  .attr("dy", "7px")
	    	  .attr("dominant-baseline","alphabetic")
	    	  .style("baseline-shift","0%")
	    	  .style("font-size","12px")
	    	  .text(function(d){
	    		  var textGubun = d.value.indexOf(" ");
		    	  var text = d.value;
		    	  if(d.value){
		    		  text = d.value.substr(0,textGubun); 
		    	  }
		    	  return text; 
	    	  });
	    
	    legend.select("text")
	    	  .attr("fill",function(d){
	    		  if(d.value.indexOf("방문객") != -1){
	    			  return "#ffffff";
	    		  }
	    	  })
	    	  .append("tspan")
//	    	  .attr("x", function(d,i){ return(((width/5)*2)+(60*i))+25; })
	    	  .attr("x", function(d,i){ return(((width-230)/2)+(60*i))+25; })
	    	  .attr("dy", "14px")
	    	  .attr("dominant-baseline","alphabetic")
	    	  .style("baseline-shift","0%")
	    	  .style("font-size","12px")
	    	  .text(function(d){
	    		  var textGubun = d.value.indexOf(" ");
		    	  var text = "";
		    	  if(textGubun != -1){
		    		  text = d.value.substr(textGubun); 
		    	  }
//		    	  console.log(text);
		    	  return text; 
	    	  });
	    	  
	    
	    
	    legend.append("rect")
	      .attr("x", function(d,i){ return(((width-230)/2)+(60*i)); })
	      .attr("width", 50)
	      .attr("height", 50)
	      .style("fill", function(d){ return "transparent";})
	      .on("mouseover", function(d) {	
	            div.transition()		
	               .duration(200)		
	               .style("opacity", 1);		
	            div.html( function(){ 
	            			var data =[];
	            			if(d){
	            				var dataArr = {};
	            				dataArr.name = d.value;
	            				dataArr.value = (d.rate).toFixed(1)+"%";
	            				dataArr.color = d.color;
	            				data.push(dataArr);
	            			}
	            			return getTooltip(data);
	            	 })	
	            	.style("position","absolute")
	                .style("left", function(){
	                	var left = d3.event.pageX - ($(".article_rg").innerWidth() - cwidth + 40);
	                	if(left > (cwidth - margin.left - margin.right - 200)) left = cwidth - margin.left - margin.right - 200;
	                	
	                	if(divId === "#cntBar1" ||  divId === '#cntBar2'){
		        			var tooltipWidth = $('#d3plus_tooltip_id_visualization_focus').width();
		        			left = event.offsetX - (tooltipWidth / 2) ;
		        		}
	                	
	                	return left + "px";
	                })		
		            .style("top",  function() {
		            	
		            	if(divId === "#cntBar1" || divId === "#cntBar2") {
		            		var tooltipHeight = $('#d3plus_tooltip_id_visualization_focus').height();
		            		return event.offsetY - tooltipHeight - 20 + "px";
		        		} else {
		        			// 마우스의 위치 - 첫번째 섹션의 높이 - (지도 혹은 그래프의 높이 * 2) - (지도 혹은 그래프의 top, bottom padding 값 ) - 항상 따라다니는 top의 높이 +(이 그래프의 margin bottom)
		        			var top = d3.event.pageY -  $('.section').height() - (cheight*2) - 115 - 192 ;
			        		return top +"px";
		        		}
		            });	
      })	
      .on("mousemove", function(d){
      	div.style("left", function(){
			var left = d3.event.pageX - ($(".article_rg").innerWidth() - cwidth + 40) -100;
	      	if(left > (cwidth - margin.left - margin.right - 200)) left = cwidth - margin.left - margin.right - 200;
	      	
	      	if(divId === "#cntBar1" ||  divId === '#cntBar2'){
				var tooltipWidth = $('#d3plus_tooltip_id_visualization_focus').width();
				left = event.offsetX - (tooltipWidth / 2) ;
			}
	      	
	      	return left + "px";
    	})
    	.style("top",  function() {
    		if(divId === "#cntBar1" || divId === "#cntBar2") {
    			var tooltipHeight = $('#d3plus_tooltip_id_visualization_focus').height();
        		return event.offsetY - tooltipHeight - 20 + "px";
    		} else {
    			// 마우스의 위치 - 첫번째 섹션의 높이 - (지도 혹은 그래프의 높이 * 2) - (지도 혹은 그래프의 top, bottom padding 값 ) - 항상 따라다니는 top의 높이 +(이 그래프의 margin bottom)
    			var top = d3.event.pageY -  $('.section').height() - (cheight*2) - 115 - 192 + margin.bottom;
    			return top +"px";
    		}
        });	
      })
      .on("mouseout", function(d) {		
	            div.transition()		
	                .duration(500)	
	                .style("opacity", 0);
      });
		 
}

/**
 * 시계열 그래프 
 * @param divId 	    그래프를 그릴 div의 id
 * @param timeData 	    표현할 data
 * @param xColumn	    x축에 나타낼 데이터의 column명
 * @param yColumn       y축에 나타낼 데이터의 column명
 * @param margin{}      margin값으로 사용할 top, right, bottom, left
 * @param tLength       화면 사이즈별 ticks의 갯수
 * @param tFormat       x축의 format yy/mm/dd
 * @param defaultVal    첫 화면에 보여줄 선택일
 * @param timeHandler   callback함수
 * @param bDate		    그래프 전체의 시작일
 * @param eDate         그래프 전체의 마지막날
 * @param title		    y축의 title
 * @param standards{}   선택할 수 있는 기간 제한 
 * @returns {___anonymous30235_30251}
 */
function timeLineChart(divId, timeData, xColumn, yColumn, margin, tLength, tFormat, defaultVal, timeHandler, bDate, eDate, title, standards){
	var $container = $(divId);
	var cwidth = $container.width();
	var cheight = $container.height();
	var width = cwidth - margin.left - margin.right,
	    height = cheight - margin.top - margin.bottom;


	var y = d3.scale.linear().range([height, 0]);
	var x = d3.time.scale().range([0, width]);
	
	//  전체 시작일과 종료일이 없을 경우
	if(!bDate){
		bDate = new Date();
	}
	if(!eDate){
		eDate = bDate.addDays(3);
	}
	
	// x값  전체 범위 설정
	x.domain([ bDate , eDate  ] ) ;
	
	// x축 기준 설정
	var xAxis = d3.svg.axis()
				      .scale(x)
				      .ticks(tLength )
				      .tickSize(-height);
	// x축 라벨 형식 변경 
	if(tFormat)
		xAxis.tickFormat(tFormat);

	// y축 라벨 갯수와 값 정의
	var yMaxValue = d3.max(timeData, function(d) { return d[yColumn]; });
	var yValueWidth = (yMaxValue / 4);
	yValueWidth = Math.round(yValueWidth / 1000) * 1000; 
	var tickValues = [0,yValueWidth,yValueWidth*2,yValueWidth*3];

	// y축  전체 범위 설정
	y.domain([0, yMaxValue + (yMaxValue / 8 )]).nice();
	
	// y축 기준 설정
	var yAxis = d3.svg.axis()
	    .scale(y)
	    .orient("left")
		.innerTickSize(-(width))
	    .outerTickSize(0)
	    .tickValues(tickValues)
	    .tickFormat(function(d){
	    	var minLength = getIndexNumber(yValueWidth);
	    	return krWonRound(d,minLength,1);
	    })
	    .tickPadding(10);	
		
	// 그래프 제목 설정
	var title = d3.select(divId)
	              .append("text")
				  .text(title)
				  .style("position","absolute")
				  .style("font-size","7px")
				  .style("left","3px")
				  .style("top","7px");
				   
	// 영역 그래프 설정
	var area = d3.svg.area()
				     .interpolate("monotone")
				     .x(function(d) { return x(d.date); })
				     .y0(height)
				     .y1(function(d) { return y(d[yColumn]); });

	// 라인 그래프 설정
	var line = d3.svg.line()
				     .interpolate("monotone")
				     .x(function(d) { return x(d.date); })
				     .y(function(d) { return y(d[yColumn]); });

	// 그래프 그리기 시작(그래프 영역 설정)
	var svg = d3.select(divId).append("svg")
						      .attr("width", width + margin.left + margin.right)
						      .attr("height", height + margin.top + margin.bottom)
						      .append("g")
						      .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

	// 실제 화면에 보여질 영역 자르기 (id='clip')
	svg.append("clipPath")
	   .attr("id", "clip")
	   .append("rect")
	   .attr("width", width)
	   .attr("height", height);

	// 실제 시계열 그래프 데이터 바인딩
	svg.datum(timeData);
	
	// 아이디 'clip' 영역안에  영역 차트 추가
	svg.append("path")
	   .attr("class", "area")
	   .attr("clip-path", "url(#clip)")
	   .attr("d", area);

	// X축 추가
	var xGr = svg.append("g")
				 .attr("class", "x axis")
      			 .attr("transform", "translate(0," + height + ")")
//	      		 .attr("transform", "rotate(-90)")
      			 .call(xAxis);

	xGr.selectAll("text")
	   .attr("dy", ".99em")
	   .style("font-size", "12px");
	
	
	// x축을 덮는 기간 선택 박스가 실제 보여질 영역 자르기 (주황색 선택박스 영역, id='clip2') 
	svg.append("clipPath")
	   .attr("id", "clip2")
	   .append("rect")
	   .attr("class", 'fillRect')
	   .attr("width",200)
	   .attr("x", 100)
	   .attr("y", 0)
	   .attr("height", height+21);
	  
	// x축을 덮는 기간 선택 박스를 아이디 'clip2'영역안에 추가
	svg.append("rect")
	   .attr("class", 'fillRect')
	   .attr("width",0)
	   .attr("x", 0)
	   .attr("y", height)
	   .attr("height", 20)
	   .attr("fill", "#F7941D");

	// 아이디 'clip2'영역안에 새로운 x축 추가
	var xGrWhite = svg.append("g")
					  .attr("class", "x axis")
					  .attr("clip-path", function(d,i) { return "url(#clip2)"; })
					  .attr("transform", "translate(0," + height + ")")
					  .call(xAxis); 
		 
	// 새로운 x축 안에 text 추가	 
	xGrWhite.selectAll("text")
			.attr("dy", ".99em")
			.style("font-size", "12px")
			.attr("fill", "#ffffff");
	  
	// y축 추가  	 
	svg.append("g")
	   .attr("class", "y axis")
	   .attr("transform", "translate(0,0)")
	   .call(yAxis);

	// 그리드 스타일 변경 (y축에 대한 그리드 "-----")
	svg.selectAll(".y .tick:not(:first-of-type) line")
	   .attr("stroke", "#777")
	   .attr("stroke-dasharray", "2,2");
	  
	// 라인 그래프 추가
	var linePath = svg.append("path")
					  .attr("class", "line")
					  .attr("d", line);
	  
	  
	// 슬라이더 손잡이 (startSlider: 왼쪽, endSlider: 오른쪽)
	var startSlider = sliderBuilder(x,y,timeData,svg,divId.substr(1),"startSlider",width,moveEndHandler);
	var endSlider = sliderBuilder(x,y,timeData,svg,divId.substr(1),"endSlider",width,moveEndHandler);
  
	// 그래프 위의 선택 영역 박스
	var rect = svg.append("g").append("rect")
				  .attr("class", 'guideRect')
				  .attr("width",0)
				  .attr("x", 0)
				  .attr("height", height)
				  .attr("fill", "#fca65a")
				  .attr('opacity', 0.3)
				  .attr('cursor', "move");
	
	// 왼쪽 슬라이더  handler(선택 최소 혹은 최대 기간 외의 조회 막기)
	startSlider.constrain(function(event, ui) {
		var endSliderDate = x.invert(endSlider.getX());		// 선택한 기간의 종료일 
		ui.position.left = Math.min(ui.position.left, endSlider.getX() + margin.left );	//슬라이더 손잡이 위치와 선택한 기간의 종료일 위치 비교
		ui.position.left = Math.max(0, ui.position.left);	// 시작점과 슬라이더 손잡이 위치 비교
			  
		// 경제 24시(시간단위)
		if(standards.time){ //최소 영역 1칸
			endSliderDate.setTime((endSliderDate.getTime() - (1000 *60 * 60 * standards.time)));
			ui.position.left = Math.min(ui.position.left, x(endSliderDate) );
		}
  
		// 경제트렌드, 이벤트효과(날짜단위)
		if(standards.month){//최소 3일 최대 6개월
			// 최소 삼일이상 선택해야하는 부분 설정
			endSliderDate.setDate(endSliderDate.getDate()-2);	// 최소3일에 대한 기준일 만들기
			ui.position.left = Math.min(ui.position.left, x(endSliderDate));	// 기준일의 위치와 현재 슬라이더 손잡이 위치 비교
			
			// 최대 6개월까지만 선택해야하는 부분 설정
			var endTime = yyyymmddToDate(endSlider.value().stdr_date).getTime();	// 선택한 기간의 종료일
			var startTime = yyyymmddToDate(startSlider.value().stdr_date).getTime();	// 선택한 기간의 시작일
			  
			if(startTime < endTime){	
				endSliderDate.setDate(endSliderDate.getDate()+3);	// 위에서 변경한 최소3일에 대한 기준 값 원상복귀
				endSliderDate.setMonth(endSliderDate.getMonth()- Number(standards.month));	// 최대 6개월대한 기준일 만들기
//				ui.position.left = Math.max(ui.position.left, x(endTime - (1000 *60 * 60 *24 *30*month)));
				ui.position.left = Math.max(ui.position.left, x(endSliderDate));	// 기준일의 위치와 현재 슬라이더 손잡이의 위치 비교
			}
		}
	});

	// 오른쪽 슬라이더  handler(선택 최소 혹은 최대 기간 외의 조회 막기)
	endSlider.constrain(function(event, ui) {
		var startSliderDate = x.invert(startSlider.getX());	// 선택한 기간의 시작일
		ui.position.left = Math.max(ui.position.left, startSlider.getX() + margin.left);	//슬라이더 손잡이 위치와 선택한 기간의 시작일 비교
		ui.position.left = Math.min(margin.left + width, ui.position.left);	// 선택가능한 가장 큰 값과 슬라이더 손잡이 위치 비교
		  
		// 경제 24시(시간단위)
		if(standards.time){
			startSliderDate.setTime((startSliderDate.getTime() + (1000 *60 * 60 * standards.time)));
			ui.position.left = Math.max(ui.position.left, x(startSliderDate) + margin.left );
		}
      
		// 경제트렌드, 이벤트효과(날짜단위)
		if(standards.month){   
			// 최소 삼일이상 선택해야하는 부분 설정
			startSliderDate.setDate(startSliderDate.getDate()+2);	//최소 3일에 대한 기준일 만들기
			ui.position.left = Math.max(ui.position.left, x(startSliderDate) + margin.left);	//기준일과 현재 슬라이터 손잡이 위치 비교
			
			// 최대 6개월까지만 선택해야하는 부분 설정
			var endTime = yyyymmddToDate(endSlider.value().stdr_date).getTime();	// 선택한 기간의 종료일
			var startTime = yyyymmddToDate(startSlider.value().stdr_date).getTime();	// 선택한 기간의 시작일
			
			if(startTime <= endTime){
				startSliderDate.setMonth(startSliderDate.getMonth() + Number(standards.month));	// 최대 6개월대한 기준일 만들기
				startSliderDate.setDate(startSliderDate.getDate()-3);	// 위에서 변경한 최소3일에 대한 기준 값 원상복귀
//        		  ui.position.left = Math.min(ui.position.left, x(startTime + (1000 *60 * 60 *24 *30*(month)))  +margin.left );
				ui.position.left = Math.min(ui.position.left, x(startSliderDate)  +margin.left );	// 기준일의 위치와 현재 슬라이더 손잡이의 위치 비교
			}
		}
	});
      
    
	// 선택영역 날짜 간격(width)
	var term;
	// 드래그시 이벤트 추가
	var dragBehavior = d3.behavior.drag()
						 .on("dragstart", function(){	// 드래그 시작시
							 term =  x.invert(endSlider.getX())  -   x.invert(startSlider.getX())	// 간격 계산
						 })
						 .on("drag", onSelectionDrag)	// 드래그 중
						 .on("dragend", onSelectionDragEnd); // 드래그 종료시
	
	// 드래그 기능 추가
	rect.call(dragBehavior);
	
	// 드래그 중
	function onSelectionDrag(){
		var $this = d3.select(this),	// 주황색 선택 영역 박스 객체 
		currentX = +$this.attr("x"),	// 주황색 선택 영역 박스 객체의 x값
		sWidth = +$this.attr("width"),	// 주황색 선택 영역 박스 객체의 너비
		newX = currentX + d3.event.dx;	// 주황색 선택 영역 박스 객체의 x값 + 움직인 x값
		
		if (newX < 0 || newX + sWidth > width) return;
		  
		rect.attr("x", newX);	// 주황색 선택영역 박스 위치변경
		startSlider.move(newX);	// 왼쪽 슬라이더 위치변경
		endSlider.move(newX + sWidth);	// 오른쪽 슬라이더 위치변경
	}

   // 드래그 종료시
	function onSelectionDragEnd(){
		var $this = d3.select(this);	// 주황색 선택 영역 박스 객체 
		var currentX = $this.attr("x");	// 주황색 선택 영역 박스 객체의 x값
		var sWidth = $this.attr("width");	// 주황색 선택 영역 박스 객체의 너비
		var x0 = x.invert(currentX);	// 주황색 선택 영역 박스 왼쪽 x값을 날짜로 변환
//    	  var x1 = new Date(x0.getTime() + term);			//x.invert(parseInt(currentX)+parseInt(sWidth));
		var x1 = new Date(dateRound(x0).getTime() + term);	// 주황색 선택 영역 박스 오른쪽 x값을 날짜로 변환
			  
		startSlider.move(x( dateRound(x0) ));	// 왼쪽 슬라이더 위치변경
		endSlider.move(x( x1 ));	// 오른쪽 슬라이더 위치변경
		moveEndHandler();	//마우스 handler 호출
	}

	var eventManager = $({});	// 마우스 움직임이 끝났을때, 선택한 시간에 대한 처리 함수 호출
	if(timeHandler){
		eventManager.bind(divId+"-moveend" , timeHandler);
	}


	setVal(defaultVal.x0,defaultVal.x1);
	return {setVal : setVal} ;
	  
	  
	  
	function setVal (x0,x1){
		endSlider.move(x(x1));
		startSlider.move(x(x0));	
	}

	  
	function rectRedraw(){
		startX = startSlider.getX();
		endX = endSlider.getX();
		if(endX-startX < 0)return;
		      
		$(".guideRect").attr("width",(endX-startX));
		$(".guideRect").attr("x", startX);
		
		$(".gslider.startSlider").css("left", startX-1);
		$(".gslider.startSlider").css("margin-left", -$(".gslider.startSlider").outerWidth()+margin.left+3);
		$(".gslider.endSlider").css("left", endX+margin.left+1);
		  
		$(".gslider.startSlider").html( tFormat(dateRound(x.invert(startX))));
		$(".gslider.endSlider").html(   tFormat(dateRound(x.invert(endX))) );
		  
		$(".fillRect").attr("width",(endX-startX));
		$(".fillRect").attr("x", startX);
		  
	} 
	  
	function moveEndHandler(){
		if(divId !== undefined && divId == "#time24Chart"){
			eventManager.trigger(divId+"-moveend" , [startSlider.value() , endSlider.value(), yColumn]);
		}else{			  
			eventManager.trigger(divId+"-moveend" , [x.invert(startSlider.getX()) , x.invert(endSlider.getX()), yColumn]);
		}
	}
	 
	// 문자를 잘짜 데이터로 변경 
	function dateRound(x0){
		var nDate = new Date(x0);
		nDate.setHours(nDate.getHours() + Math.round(nDate.getMinutes()/60));
		nDate.setMinutes(0);
		return nDate;
	}
	  
	/**
	 * 슬라이더 생성 함수
	 * @scaleX		x값 계산기
	 * @scaleY		y값 계산기
	 * @silderData	전체 데이터
	 * @canvas		그래프 영역(svg 객체)
	 * @id			"#"
	 * @sliderName	슬라이더 이름(startSlider, endSlider)
	 * @maxWidth		그래프 전체 영역의 width
	 * @moveEndHandler	움직임이 끝났을때의 handler
	 * 
	 */
	function sliderBuilder(scaleX,scaleY,silderData,canvas,id,sliderName ,maxWidth,moveEndHandler){
		// 슬라이더의 양끝쪽에 라인을 추가할 영역 만들기
		var sliderGroup = canvas.append("g").attr("class", "marker");
		 
		// 슬라이더의 양끝쪽 라인 추가
		var dotLine = sliderGroup.append("line")
								 .attr("class", "guideline")
								 .attr("clip-path", "url(#clip)")
								 .attr("x1", 0)
								 .attr("y1", 0)
								 .attr("x2", 0)
								 .attr("y2", height);
		  
		 // 슬라이더의 양끝쪽 라인 위의 점 추가
		var dot = sliderGroup.append("circle")
							 .attr("class", "dot")
							 .attr("r", 2.5);
		 
		  
		var _selectedData = silderData[0];
		var _sliderDiv = $("#"+id).append("<div class='gslider "+sliderName+"'/>");	// 슬라이더 영역 추가
		var _constrain;
		
		
		function constrain(dragConstrain) {
			_constrain = dragConstrain;
		}
		  
		$(".gslider."+sliderName).draggable({
			axis: "x",
			start : function() {
			},
			drag: function(event, ui) {
				if (_constrain) {
					_constrain(event, ui);
				}
				var offx = (sliderName == "startSlider") ?  margin.left : 0;//왼쪽 slider margin처리
				moveX($(this).position().left + offx - margin.left);
			},
			stop : function() {
				var offx = (sliderName == "startSlider") ?  margin.left : 0;//왼쪽 slider margin처리
				var tick = getStopTick($(this).position().left + offx - margin.left);
				moveX(scaleX(tick));
				moveEndHandler()
			}
		});
  
  
		// x좌표를 날짜(도메인)으로 변경
		function getStopTick(xleft){
			var x0 = scaleX.invert(xleft);
			return dateRound(x0);
		}
		
		var posX = 0;
		
		// 주황색 선택영역 움직이기
		function moveX(xxx){		  
			if (xxx < 0 || xxx > maxWidth) return;
				  
			var rWidth = 0;
			var rPosx = 0;
				  
			posX = xxx;
			var x0 = scaleX.invert(posX);	
			var newValue = Math.round(x0);
			var bisectTimeCd = d3.bisector(function(d) { return d.date }).left;
			var i = bisectTimeCd(silderData, x0, 1);
				  
			var d0 = silderData[i - 1];
			var d1 = silderData[i];
			var d = x0.getTime() - d0.date.getTime() > d1.date.getTime() - x0 ? d1 : d0;
			_selectedData = d;
			var nearYvalue= scaleY(d.total_cnt);	  
				  
			var pathEl = linePath.node();
			var pathLength = pathEl.getTotalLength();
			var beginning = posX, end = pathLength, target;
				  
			while (true) {
				target = Math.floor((beginning + end) / 2);
				pos = pathEl.getPointAtLength(target);
				if ((target === end || target === beginning) && pos.x0 !== x) {
					break;
				}
				if (pos.x > posX)      end = target;
				else if (pos.x < posX) beginning = target;
				else break; //position found
			}
			  
			dot.attr("transform", "translate(" + pos.x + "," + pos.y + ")");
			dotLine.attr("transform", "translate(" + pos.x + ",0)");
			rectRedraw();
			
					  
		}
				  
		return {
			move:moveX,
			value:function(){return _selectedData;},
			getX:function(){return posX;},
			constrain:constrain
		}
	}
}

/**
 * lineChart (사용안함)  
 * @param chartData   표현할 data
 * @param id 		  그래프를 그릴 div의 id
 * @param valueColumn 그래프에 표현할 데이터의 column명
 * @param options      
 */
function lineChart(chartData, id, valueColumn, options){
	d3.select('#'+id).html("");
	
	var chart_config = {
			ticks:6,
			chartMargin : {top:20, right:35, bottom:60, left:35}
	};
	
	chart_config = $.extend(chart_config,options);
	
	var chartWidth = Number(d3.select('#'+id).style('width').replace("px", "")) - chart_config.chartMargin.left - chart_config.chartMargin.right;
	var chartHeight = Number(d3.select('#'+id).style('height').replace("px", "")) - chart_config.chartMargin.top - chart_config.chartMargin.bottom;

	
	var yScale = d3.scale.linear().range([chartHeight, 0]);
	var xScale = d3.scale.ordinal().rangePoints([0,chartWidth]);
	
	var yMaxValue = d3.max(chartData, function(d) { return d[valueColumn]; });
	//axis
	var xAxis = d3.svg.axis()
				      .scale(xScale)
				      .ticks(5);

	var yAxis = d3.svg.axis()
					  .scale(yScale)
					  .orient("left")
					  .innerTickSize(-chartWidth)
					  .ticks(chart_config.ticks)
					  .tickPadding(10)
					  .tickFormat(function(d){
						  var ff = d3.format(",");
						  return ff(d);
					  });
	
	var line = d3.svg.line()
				     .x(function(d) { return xScale(d.name); })
				     .y(function(d) { return yScale(d[valueColumn]); });

	var svg = d3.select("#"+id)
				.append("svg")
				.attr("width", chartWidth + chart_config.chartMargin.left + chart_config.chartMargin.right)
				.attr("height", chartHeight + chart_config.chartMargin.top + chart_config.chartMargin.bottom)
				.append("g")
				.attr("transform", "translate(" + chart_config.chartMargin.left + "," + chart_config.chartMargin.top + ")");
	
	yScale.domain([0, yMaxValue + (yMaxValue / 8 )]).nice();
	xScale.domain(chartData.map(function(d){ return d.name; }));
	
	//datum : 
	svg.datum(chartData);
	var dataSize = chartData.length;
	
	svg.append("g")
       .attr("class", "x axis")
       .attr("transform", "translate(0," + chartHeight + ")")
       .call(xAxis)
       .selectAll(".tick text")
       .style("text-anchor", function(){ 
    	   if(dataSize > 16){    		   
    		   return"end"
    	   }else{
    		   return"middle"
    	   }
       })
       .style("font-size","9px")
       .attr("transform", function(){
    	   if(dataSize > 16){    
    		   return "rotate(-45)";
    	   }else{
    		   return "rotate(0)";
    	   }
       });
	
	

			     
	 
    svg.append("g")
       .attr("class", "y axis")
       .attr("transform", "translate(0,0)")
       .call(yAxis);

	var linePath = svg.append("path")
				      .attr("class", "line")
				      .attr("d", line);
	  
    svg.selectAll("dot")
       .data(chartData)
       .enter()
       .append("circle")
       .attr("r", 2)
       .attr("cx", function(d) { return xScale(d.name); })
       .attr("cy", function(d) { return yScale(d[valueColumn]); });
}


/****
 * D3Plus
 ****/


/**
 * treemap chart
 * @param chartData  표현할 data
 * @param id         그래프 그릴 div 의 id 
 * @param bColor     background color 
 */
function treemap_plus(chartData,id, bColor){
	  if(bColor === undefined) bColor = "#fff";
	  // instantiate d3plus
	  var visualization = d3plus.viz()
	    .container(id)
	    .data(chartData)
	    .type("tree_map")
	    .height({"small": 100})
	    .background(bColor)
	    .color({
	    	"scale": ['#2e6695','#72f5c4','#17c0c0','#ff8166','#ffd3a6','#777'], 
	    	"value": "color"
	    })
//	    .color("color")                // groups colored to show ungrouping
	    .id({
	      "value": ["code","name"],
	      "grouping": true            // grouping set to false ungroups parent nesting
	    })
	    .format({
		    "number": function(number, params) {
		    	if(params.key == 'value'){
		    		var tCnt =  Math.floor(1e-12 + Math.log(number) / Math.LN10);
		    		return krWonRound(number,tCnt,1)+"원";	
		    	}else if(params.key == 'share'){
		    		return number.toFixed(1) +"%";
		    	}
		        
		    }
		})
	    .depth(1)
	    .size("value")
	    .labels({"align": "left", "valign": "top"})
	    .legend({
	      "size": 50,
	      "order": {
	        "sort": "desc",
	        "value": "size"
	      }
	    })
	    .tooltip({"stacked":false})
	    .draw();
}

/**
 * 수평 바 chart
 * @param chartData  표현할 data
 * @param id         그래프 그릴 div 의 id 
 * @param label{}    x축, y축의 제목
 * @param ticks		 
 * @param bColor     background color 
 * @param unit{}	 단위
 */
function hozBar_plus(chartData, id, label, ticks, bColor, unit){
	  if(bColor === undefined) bColor = "#fff";
	  var visualization = d3plus.viz()
	    .container(id)
	    .data(chartData)
	    .height({"small": 100})
	    .type("bar")
	    .id("name")
	    .background(bColor)
	    .x({"value" : "value", "label":label.x})
	    .y({"scale": "discrete", "value" : "name","grid": false, "label":false})
	    .format({
		    "number": function(number, params) {
		        if(unit.form == "won"){
		        	return krWonRound(number,unit.length,1)+"원";		        	
		        }else if(unit.form == 'rate'){		    
		        	return number+"%";		        		
		        }else{		        		
		        	return number;
		        }
		    }
		})
	    .order({"value":"value","sort":"asc"})
	    .color("hex")
	    .draw();
}

/**
 * group bar chart
 * @param chartData     표현할 data
 * @param id            그래프 그릴 div 의 id 
 * @param attributes[]  group별 색상 맵핑 배열
 * @param timeArr[]		x축의 값
 * @param label{}       x축, y축의 제목
 * @param bColor        background color 
 **/
function barChart_plus(chartData, id, attributes, timeArr, label, bColor){ //"#f8f8f8"
	if(bColor === undefined) bColor = "#fff";
	var visualization = d3plus.viz()
							  .container(id)
							  .data(chartData)
							  .background(bColor)
							  .height({"small": 100})
							  .type("bar")
							  .id("name")
							  .x({"value" : "time", "label" : label.x})
							  .y({"value" : "value", "label" : false})
							  .attrs(attributes)
							  .format({
								    "number": function(number, params) {
								        return number.toFixed(1) +"%";
								    }
							  })
							  .font({"size" : 12})
							  .labels({"font":{"size":12}})
							  .order({"value":"time","sort":"asc"})
							  .color("hex")
							  .legend({"size": 50, "order":{"sort":"desc"}})
							  .draw();
}

/**
 * stack group bar chart (사용안함)
 * @param chartData  표현할 data
 * @param id		 그래프 그릴 div 의 id 
 * @param attributes group별 색상 맵핑 배열
 */
function stackedGroupedbar_plus(chartData,id,attributes){
	var visualization = d3plus.viz()
							  .container(id)
							  .data(chartData)
							  .type("bar")
							  .id(["time","name"])
							  .x("time")
							  .x2("name")
							  .y({"value" : "value"})
//							  .y2({"value" : "valuCe"})
//							  .y({"value" : "value", "stacked":true})
							  .attrs(attributes)
							  .color("hex")
							  .draw();
}


/**
 * stack bar chart (24시)
 * @param chartData     표현할 data
 * @param divId		    그래프 그릴 div 의 id 
 * @param height	    그래프의 높이
 * @param attributes[]  group별 색상 맵핑 배열
 * @param label{}       x축, y축의 제목
 * @param title			그래프의 제목
 * @param bColor		background color 
 */
function stackedBarChart_plus(chartData, divId, height, attributes, label, title, bColor){
	
			var groupbyMap = {};
			for(var i = 0 ;i<chartData.length;i++){
				var obj = chartData[i];
				if(groupbyMap[obj.name]){
					groupbyMap[obj.name] += (obj.value);
				}else{
					groupbyMap[obj.name] = (obj.value);
				}
			}

			if(bColor === undefined) bColor = "#fff";
			var visualization = d3plus.viz()
			.container(divId)
			.class(function(d){
//				console.log(d);
		    	return "chgstyle";
		    })
			.data(chartData)
			.height({"small": 100,"value":height})
			.title({"value":title, "padding":5})
			.type("bar")
			.id("gubun")
			.x({ "value" : "name"
			   , "label" : false
			   , "grid": false
			   , "ticks":{"size":"2"}
			})
			.y({"value" : "value", "stacked":true, "label" : {"value":label.y,"valign":"top"}})
			.attrs(attributes)
			.legend({"size": 50, "order":{"sort":"desc"}})
			.color("hex")
			.format({
			    "number": function(number, params) {
//			        return krWonRound(number,4,2);
			    	return number.toFixed(1)+"%";
			    }
			})
			.order({
				"sort":"desc",
				"value": function(d){
							return groupbyMap[d.name];
						 }
			})
			.draw();
			
//			console.log(d3.select("#scatterChart text"));
//			d3.select("#scatterChart text").attr();
			
}

/**
 * scatter chart (사용안함)
 * @param inputData  표현할 data
 * @param divId		 그래프 그릴 div 의 id 
 * @param label{}	 x축, y축의 제목	 
 * @param height     div id 의 높이 값 지정
 * @param bColor	 background color 
 **/
function scatterChart_plus(inputData, divId, label, height, bColor){
	  if(bColor === undefined) bColor = "#fff";
	  var visualization = d3plus.viz()
							    .container(divId) 
							    .data(inputData)  
							    .background(bColor)
							    .height({"value" : height})
							    .type("scatter")   
							    .id("name")       
							    .size({"value":5})
							    .x({"value" : "weight" , "label" : label.x})       
							    .y({"value" : "value" , "label" : label.y})   
							    .axes({"mirror": true})
							    .draw();            
}

/**
 * 다중 선 그래프
 * @param inputData  표현할 data
 * @param divId		 그래프 그릴 div 의 id 
 * @param label{}	 x축, y축의 제목	
 * @param attributes 각각의 line에 대한 색상 맵칭 object
 * @param bColor	 background color 
 */
function lineChartMulti_plus(inputData, divId, label, attributes, bColor){
	  if(bColor === undefined) bColor = "#fff";
	  var visualization = d3plus.viz()
							    .container(d3.select(divId))
//							    .class(function(d,i){
//							    	return "lineStyle";
//							    })
							    .data(inputData)
							    .height({"small": 100})
//							    .ticks({"size":"20"})
//							    .axes({"ticks":false})
							    .background(bColor)
							    .type("line")
							    .id("name")
							    .y({
							    	"value" :"value" , 
							    	"label" : false
							    })
							    .size(2)
							    .x({"value" :"date" , "label" : label.x })
							    .format({
								    "number": function(number, params) {
								    	return krWonRound(number,params.vars.attrs.value[0].length,1);
								    }
								})
								.font({"size" : 12})
								.labels({"font":{"size":12}})
//								.edges(attributes)
							    .legend({ "size": 50
							    	    , "data": false
//							    	    , "value": true
//							    	    , "filters": false
							    	    , "order":{"value":"color","sort":"asc"}
//							    	    , "text" : {"value" : "name"}
							    })
							    .attrs(attributes)
							    .color("hex")
							    .order({"value":"order","sort":"asc"})
							    .draw();
}


/**
 * 팝업의 html 생성
 * @param data[]    내용에 들어갈 data
 * @param title{}	title에 들어갈 data (color과 text)
 * @returns {String}
 */
function getTooltip(data,title){
	
	
	var tooltipHtml = '<div id="d3plus_tooltip_id_visualization_focus"	class="d3plus_tooltip d3plus_tooltip_small d3plus_tooltip_dev_contents">';
//    tooltipHtml	+= '<div id="d3plus_tooltip_id_visualization_focus"	class="d3plus_tooltip d3plus_tooltip_small d3plus_tooltip_dev_contents">';
    tooltipHtml	+= '<div class="d3plus_tooltip_container d3plus_tooltip_dev_container">';
    
    if(data.length == 1){
    	tooltipHtml	+= '<div class="d3plus_tooltip_header d3plus_tooltip_dev_header">';
    	if(data[0].color){    		
    		tooltipHtml	+= '<div class="d3plus_tooltip_title d3plus_tooltip_dev_title"><font color='+data[0].color+'>'+data[0].name+'</font></div>';
    	}else{    		
    		tooltipHtml	+= '<div class="d3plus_tooltip_title d3plus_tooltip_dev_title">'+data[0].name+'</div>';
    	}
        tooltipHtml	+= '</div>';
        tooltipHtml	+= '<div class="d3plus_tooltip_data_container d3plus_tooltip_dev_data_container">';
        tooltipHtml	+= '<div class="d3plus_tooltip_data_block d3plus_tooltip_dev_data_block">';
	    tooltipHtml	+= '<div class="d3plus_tooltip_data_name d3plus_tooltip_dev_data_name">value</div>';
	    tooltipHtml	+= '<div class="d3plus_tooltip_data_value d3plus_tooltip_dev_data_value">'+data[0].value+'</div>';
	    tooltipHtml	+= '</div>';
    }else if(title && data.length > 1){
    	
	    tooltipHtml	+= '<div class="d3plus_tooltip_header d3plus_tooltip_dev_header">';
	    tooltipHtml	+= '<div class="d3plus_tooltip_title d3plus_tooltip_dev_title">'+title+'</div>';
	    tooltipHtml	+= '</div>';
	    tooltipHtml	+= '<div class="d3plus_tooltip_data_container d3plus_tooltip_dev_data_container">';

    	for(var i = 0 ; i < data.length ; i++){
    		tooltipHtml	+= '<div class="d3plus_tooltip_data_block d3plus_tooltip_dev_data_block">';
    	    tooltipHtml	+= '<div class="d3plus_tooltip_data_name d3plus_tooltip_dev_data_name">value</div>';
    	    tooltipHtml	+= '<div class="d3plus_tooltip_data_value d3plus_tooltip_dev_data_value">'+data[i].value+'</div>';
    	    tooltipHtml	+= '</div>';
    	    
    	    if(i < (data.length -1)){
    	    	tooltipHtml	+= '<div class="d3plus_tooltip_data_seperator d3plus_tooltip_dev_data_seperator"></div>';
    	    }
    	}
    }
    
    tooltipHtml	+= '</div>';
    tooltipHtml	+= '<div class="d3plus_tooltip_footer d3plus_tooltip_dev_footer"></div>';
//    tooltipHtml	+= '</div></div></div>';
    tooltipHtml	+= '</div></div>';
    
    return tooltipHtml;
}

