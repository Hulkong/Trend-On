Date.prototype.addHours = function(h) {    
   this.setTime(this.getTime() + (h*60*60*1000)); 
   return this;   
};
Date.prototype.addDays = function(days) {
  var dat = new Date(this.valueOf());
  dat.setDate(dat.getDate() + days);
  return dat;
};

function yyyymmddToDate(strdate){
	return new Date(strdate.substr(0,4)+"-" +strdate.substr(4,2) +"-" +  strdate.substr(6,2));
}

/****
 * D3
 ****/

//treemap chart
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

function stackedGroupedbar(chartData,divId,attributes,legend,tLength){

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
				      .tickFormat(function(d){return krWonRound(d,4,0);});
//				      .tickFormat(d3.format(".2s"));
 
	var color = d3.scale.ordinal()
						.range(["#1A3E61", "#CA3434", "#828282", "#d3d3d3"]);
	
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
					    .on("mouseover", function(d) {	
					            div.transition()		
					               .duration(200)		
					               .style("opacity", .9);		
					            div.html( function(){ 
					            			var data =[];
					            			if(d){
					            				var dataArr = {};
					            				dataArr.name = d.name_ko;
					            				dataArr.value = krWonRound(d.realValue,4,0)+"명";
					            				dataArr.color = color(d.name);
					            				data.push(dataArr);
					            			}
					            			return getTooltip(data);
					            	 })	
					            	.style("position","absolute")
					                .style("left", function(){
					                	var left = d3.event.pageX - ($(".article_rg").innerWidth() - cwidth + 40);
					                	if(left > (cwidth - margin.left - margin.right - 200)) left = cwidth - margin.left - margin.right - 200;
					                	return left + "px";
					                })		
						            .style("top",  function(){
//						            	console.log(d3.event.pageY);
//						            	return margin.top + "px";
						            	return y(d.yEnd)-50+"px";
						            });	
//				                .style("left", (d3.event.pageX - 155) + "px")		
//				                .style("top",  function(){ return y(d.yEnd)+"px";});	
				        })	
				        .on("mousemove", function(d){
				        	div.style("left", function(){
					        		var left = d3.event.pageX - ($(".article_rg").innerWidth() - cwidth + 40) -100;
				                	if(left > (cwidth - margin.left - margin.right - 200)) left = cwidth - margin.left - margin.right - 200;
				                	return left + "px";
					        	})
					        	.style("top",  function(){
//					            	return 0 + "px";
					        		return y(d.yEnd)-50+"px";
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
//		      .attr("x", function(d,i){ return(((width/5)*2)+(60*i)); })
		      .attr("x", function(d,i){ return(((width-230)/2)+(60*i)); })
		      .attr("width", 50)
		      .attr("height", 50)
		      .style("fill", function(d){ return d.color;});
	 
	    legend.append("text")
//		      .attr("x", function(d,i){ return(((width/5)*2)+(60*i))+30; })
		      .attr("x", function(d,i){ return(((width-230)/2)+(60*i))+30; })
		      .attr("y", 15)
		      .attr("width", 8+"px")
		      .attr("dy", ".35em")
		      .style("text-anchor", "middle");
	    
	    legend.select("text")
		      .attr("class", function(d){
	    		  if(d.value.indexOf("유입소비") != -1){
	    			  return "changeColor";
	    		  }
	    	  })
	    	  .append("tspan")  
//	    	  .attr("x", function(d,i){ return(((width/5)*2)+(60*i))+25; })
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
//		    	  console.log(text);
		    	  return text; 
	    	  });
	    
	    legend.select("text")
	    	  .attr("fill",function(d){
	    		  if(d.value.indexOf("유입소비") != -1){
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
	    	  
//		      .text(function(d){return d;});
//		      .text(function(d) { 
//		    	  var textGubun = d.indexOf(" ");
//		    	  var text = d;
//		    	  if(d){
//		    		  text = "<tspan>" + d.substr(0,textGubun) + "</tspan><tspan>" + d.substr(textGubun+1)+"</tspan>"; 
//		    	  }
//		    	  console.log(text);
//		    	  return text; 
//		      });
		 
}

function timeLineChart(divId, timeData, xColumn, yColumn, margin,tLength,tFormat,defaultVal, timeHandler , bDate, eDate, title, standards){
	var $container = $(divId);
	var cwidth = $container.width();
	var cheight = $container.height();
	var width = cwidth - margin.left - margin.right,
	    height = cheight - margin.top - margin.bottom;


	var y = d3.scale.linear().range([height, 0]);
	
	
//	console.log(timeData);
//	var x = d3.scale.linear().range([0, width]);
	if(!bDate){
		bDate = new Date();
	}
	if(!eDate){
		eDate = bDate.addDays(1);
	}
	var x = d3.time.scale().range([0, width]);
	//.domain([bDate, eDate])    // values between for month of january
	var xAxis = d3.svg.axis()
				      .scale(x)
				      .ticks(tLength )
				      .tickSize(-height);
	if(tFormat)
		xAxis.tickFormat(tFormat);

	
	var yMaxValue = d3.max(timeData, function(d) { return d[yColumn]; });
	var yValueWidth = (yMaxValue / 4);
	yValueWidth = Math.round(yValueWidth / 1000) * 1000; 
	var tickValues = [0,yValueWidth,yValueWidth*2,yValueWidth*3];
//	console.log("tickValues",tickValues);

//	xAxis.tickFormat(d3.time.format("%H"));
	var yAxis = d3.svg.axis()
	    .scale(y)
	    .orient("left")
		.innerTickSize(-(width))
	    .outerTickSize(0)
	    .tickValues(tickValues)
	    .tickPadding(10);	
		
	var title = d3.select(divId).append("text")
				   .text(title)
				   .style("position","absolute")
				   .style("font-size","7px")
				   .style("left","3px")
				   .style("top","7px");
				   

	var area = d3.svg.area()
				     .interpolate("monotone")
				     .x(function(d) { return x(d.date); })
				     .y0(height)
				     .y1(function(d) { return y(d[yColumn]); });

	var line = d3.svg.line()
				     .interpolate("monotone")
				     .x(function(d) { return x(d.date); })
				     .y(function(d) { return y(d[yColumn]); });

	var svg = d3.select(divId).append("svg")
						      .attr("width", width + margin.left + margin.right)
						      .attr("height", height + margin.top + margin.bottom)
						      .append("g")
						      .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

	   svg.append("clipPath")
		  .attr("id", "clip")
		  .append("rect")
		  .attr("width", width)
		  .attr("height", height);

	  x.domain([ bDate , eDate  ] ) ;
	  
	  
	  y.domain([0, yMaxValue + (yMaxValue / 8 )]).nice();
	  
	  svg.datum(timeData);

	  svg.append("path")
	      .attr("class", "area")
	      .attr("clip-path", "url(#clip)")
	      .attr("d", area);

	 var xGr = svg.append("g")
	      .attr("class", "x axis")
	      .attr("transform", "translate(0," + height + ")")
//	      .attr("transform", "rotate(-90)")
	      .call(xAxis);

	 
	   svg.append("clipPath")
		  .attr("id", "clip2")
		  .append("rect")
	      .attr("class", 'fillRect')
	      .attr("width",200)
	      .attr("x", 100)
	      .attr("y", 0)
	      .attr("height", height+21);
	  
	  
	  
	   svg.append("rect")
		  .attr("class", 'fillRect')
		  .attr("width",0)
		  .attr("x", 0)
		  .attr("y", height)
		  .attr("height", 30)
		  .attr("fill", "#F7941D");

	 var xGrWhite = svg.append("g")
				       .attr("class", "x axis")
				       .attr("clip-path", function(d,i) { return "url(#clip2)"; })
				       .attr("transform", "translate(0," + height + ")")
				       .call(xAxis); 
		 
		 
	  xGrWhite.selectAll("text")
			  .attr("dy", ".99em")
			  .style("font-size", "12px")
			  .attr("fill", "#ffffff");
	  
	  
	  
	  xGr.selectAll("text")
	     .attr("dy", ".99em")
	     .style("font-size", "12px");
	 
	  svg.append("g")
	      .attr("class", "y axis")
	      .attr("transform", "translate(0,0)")
	      .call(yAxis);

	  
	  
	  var linePath = svg.append("path")
				        .attr("class", "line")
				        .attr("d", line);
	  
	
	  svg.selectAll(".y .tick:not(:first-of-type) line")
	  	 .attr("stroke", "#777")
	  	 .attr("stroke-dasharray", "2,2");
	  
	  
	
	  var startSlider = sliderBuilder(x,y,timeData,svg,divId.substr(1),"startSlider",width,moveEndHandler);
	  var endSlider = sliderBuilder(x,y,timeData,svg,divId.substr(1),"endSlider",width,moveEndHandler);
	  
	  
      startSlider.constrain(function(event, ui) {
    	  var endSliderDate = x.invert(endSlider.getX());
		  ui.position.left = Math.min(ui.position.left, endSlider.getX() + margin.left );
		  ui.position.left = Math.max(0, ui.position.left);
		  
		  if(standards.time){ //최소 영역 1칸
			  endSliderDate.setTime((endSliderDate.getTime() - (1000 *60 * 60 * standards.time)));
			  ui.position.left = Math.min(ui.position.left, x(endSliderDate) );
		  }
		  
		  if(standards.month){//최소 3일 최대 1년  
			  endSliderDate.setDate(endSliderDate.getDate()-2);
			  ui.position.left = Math.min(ui.position.left, x(endSliderDate));
			  
			  var endTime = yyyymmddToDate(endSlider.value().stdr_date).getTime();
			  var startTime = yyyymmddToDate(startSlider.value().stdr_date).getTime();
			  
			  if(startTime < endTime){	
				  endSliderDate.setDate(endSliderDate.getDate()+2);
				  endSliderDate.setMonth(endSliderDate.getMonth()- standards.month);
//				  ui.position.left = Math.max(ui.position.left, x(endTime - (1000 *60 * 60 *24 *30*month)));
				  ui.position.left = Math.max(ui.position.left, x(endSliderDate));
				  
			  }
		  }
      });

      endSlider.constrain(function(event, ui) {
    	  var startSliderDate = x.invert(startSlider.getX());
    	  ui.position.left = Math.max(ui.position.left, startSlider.getX() + margin.left);
          ui.position.left = Math.min(margin.left + width, ui.position.left);
          
		  if(standards.time){
			  startSliderDate.setTime((startSliderDate.getTime() + (1000 *60 * 60 * standards.time)));
			  ui.position.left = Math.max(ui.position.left, x(startSliderDate) + margin.left );
		  }
          
          if(standards.month){        	  
        	  startSliderDate.setDate(startSliderDate.getDate()+2);
        	  ui.position.left = Math.max(ui.position.left, x(startSliderDate) + margin.left);
        	  var endTime = yyyymmddToDate(endSlider.value().stdr_date).getTime();
        	  var startTime = yyyymmddToDate(startSlider.value().stdr_date).getTime();
        	  
        	  if(startTime <= endTime){
        		  startSliderDate.setDate(startSliderDate.getDate()-2);
        		  startSliderDate.setMonth(startSliderDate.getMonth() + standards.month);
//        		  ui.position.left = Math.min(ui.position.left, x(startTime + (1000 *60 * 60 *24 *30*(month)))  +margin.left );
        		  ui.position.left = Math.min(ui.position.left, x(startSliderDate)  +margin.left );
        	  }
          }
      });
      
      
      var term;
      var dragBehavior = d3.behavior.drag()
					       .on("dragstart", function(){
					    	   term =  x.invert(endSlider.getX())  -   x.invert(startSlider.getX())
					       })
                           .on("drag", onSelectionDrag)
                           .on("dragend", onSelectionDragEnd);
	  
      function onSelectionDrag(){
          var $this = d3.select(this),
          currentX = +$this.attr("x"),
          sWidth = +$this.attr("width"),
          newX = currentX + d3.event.dx;

	      if (newX < 0 || newX+sWidth > width) return;
	  
	      rect.attr("x", newX);
          startSlider.move(newX);
          endSlider.move(newX + sWidth);

      }
      function onSelectionDragEnd(){
    	  var $this = d3.select(this);
    	  var currentX = $this.attr("x");
    	  var sWidth = $this.attr("width");
    	  var x0 = x.invert(currentX);
    	  var x1 = new Date(x0.getTime() + term);//x.invert(parseInt(currentX)+parseInt(sWidth));
    	  startSlider.move(x( dateRound(x0) ));
    	  endSlider.move(x( x1 ));
          moveEndHandler();
      }
	  var rect = svg.append("g").append("rect")
							    .attr("class", 'guideRect')
						        .attr("width",0)
						        .attr("x", 0)
						        .attr("height", height)
						        .attr("fill", "#fca65a")
						        .attr('opacity', 0.3)
						        .attr('cursor', "move")
						        .call(dragBehavior);
	  


	  var eventManager = $({});
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
		  
		  $(".gslider.startSlider").html( tFormat(x.invert(startX)));
		  $(".gslider.endSlider").html(   tFormat(x.invert(endX)) );
		  
		  
          $(".fillRect").attr("width",(endX-startX));
		  $(".fillRect").attr("x", startX);
		  
	  } 
	  function moveEndHandler(){
		  eventManager.trigger(divId+"-moveend" , [startSlider.value() , endSlider.value(), yColumn]);
	  }
	  function dateRound(x0){
		  var nDate = new Date(x0);
		  nDate.setHours(nDate.getHours() + Math.round(nDate.getMinutes()/60));
		  nDate.setMinutes(0);
		  return nDate;
	  }
	  function sliderBuilder(scaleX,scaleY,silderData,canvas,id,sliderName ,maxWidth,moveEndHandler){
		  var sliderGroup = canvas.append("g").attr("class", "marker");
		  
		  var dotLine = sliderGroup.append("line")
		  .attr("class", "guideline")
		  .attr("clip-path", "url(#clip)")
		  .attr("x1", 0)
		  .attr("y1", 0)
		  .attr("x2", 0)
		  .attr("y2", height);
		  
		  var dot = sliderGroup.append("circle")
		  .attr("class", "dot")
		  .attr("r", 2.5);
		 
		  
		  var _selectedData = silderData[0];
	      var _sliderDiv = $("#"+id).append("<div class='gslider "+sliderName+"'/>");
	      var _constrain;


          function constrain(dragConstrain) {
              _constrain = dragConstrain;
          }
          
	      $(".gslider."+sliderName).draggable({
	          axis: "x",
	          start : function() {
	             console.log(sliderName + " start!! " );
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
	             moveEndHandler();
	          }
	      });
	      
	      

		  function getStopTick(xleft){
			  var x0 = scaleX.invert(xleft);
			  return dateRound(x0);
		  }
		  var posX = 0;
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


/****
 * D3Plus
 ****/

//treemap chart
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
		    		return krWonRound(number,8,0);	
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
//	    .ui([
//		      {
//		        "method" : "color",
//		        "type": "drop",
//		        "title": "Change color scheme:",
//		        "value"  : [{"Random": "name"}, {"color": "color"}]
//		      }
//      	])
	    .draw();
 
}

function hozBar_plus(chartData, id, label, ticks, bColor,isFormat, unit){
	  if(bColor === undefined) bColor = "#fff";
	  var visualization = d3plus.viz()
	    .container(id)
	    .data(chartData)
	    .height({"small": 100})
	    .type("bar")
	    .id("name")
	    .background(bColor)
	    .x({"value" : "value", "label":label.x})
//	    .x({"value" : "value", "label":label.x})
//	    .y("name")
//	    .y({"scale": "discrete","grid": false})
//	    .y({"scale": "discrete", "value" : "name","grid": false, "label":label.y})
	    .y({"scale": "discrete", "value" : "name","grid": false, "label":false})
	    .format({
		    "number": function(number, params) {
		        if(isFormat){
		        	return krWonRound(number,8,2);		        	
		        }else{		    
		        	if(unit){
		        		return number+"%";		        		
		        	}else{		        		
		        		return number;
		        	}
		        }
		    }
		})
//	    .time('y')
	    .order({"value":"value","sort":"asc"})
	    .color("hex")
	    .draw();
}

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
							  .y({"value" : "value", "label" : label.y})
							  .attrs(attributes)
							  .format({
								    "number": function(number, params) {
								        return krWonRound(number,4,2);
								    }
							  })
							  .font({"size" : 12})
							  .labels({"font":{"size":12}})
							  .order({"value":"time","sort":"asc"})
							  .color("hex")
							  .legend({"size": 50, "order":{"sort":"desc"}})
							  .draw();
}

function stackedGroupedbar_plus(chartData,id,attributes){
	console.log(chartData);
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

function stackedBarChart_plus(chartData, id, height, attributes, label, title, bColor){
//			console.log("stackedBarChart_plus");
//			var orderArr =[]; 
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
			.container(id)
			.class(function(d){
//				console.log(d);
		    	return "chgstyle";
		    })
			.data(chartData)
			.height({"small": 100})
			.title({"value":title, "padding":5})
			.height({"value" : height})
			.type("bar")
			.id("gubun")
			.x({"value" : "name", "label" : false, "grid": false,"ticks":{"size":"3"}})
			.y({"value" : "value", "stacked":true, "label" : {"value":label.y,"valign":"top"}})
			.attrs(attributes)
			.legend({"size": 50})
			.color("hex")
			.format({
			    "number": function(number, params) {
			        return krWonRound(number,4,2);
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
							    	"label" : label.y
							    })
							    .size(2)
							    .x({"value" :"date" , "label" : label.x })
							    .format({
								    "number": function(number, params) {
								    	return krWonRound(number,8,1);
								    }
								})
								.font({"size" : 12})
								.labels({"font":{"size":12}})
							    .legend({"size": 50, "data": false, "filters": false,"order":{"value":"color","sort":"desc"}})
							    .attrs(attributes)
							    .color("hex")
							    .order({"value":"order","sort":"asc"})
							    .draw();

//	  var dot = d3.select(divId).select("svg")
//	  			  .data(inputData)
//			      .enter()
//			      .append("circle")
//			      .attr("class", "dot")
//			      .attr("y","0px")
//				  .attr("x","0px")
//			      .attr("r", 2.5);
//	  
//	 d3.select(divId).append("div")
//	 				 .style("display","block")
//	 				 .style("position","absolute")
//	 				 .style("width","52px")
//	 				 .style("height","187px")
//	 				 .style("top","10px")
//	 				 .style("left","72%")
//	 				 .style("opacity","0.3")
//	 				 .style("background-color","red");
}

function getTooltip(data,title){
	
	
	var tooltipHtml = '<div id="d3plus_tooltip_id_visualization_focus"	class="d3plus_tooltip d3plus_tooltip_small d3plus_tooltip_dev_contents">';
    tooltipHtml	+= '<div id="d3plus_tooltip_id_visualization_focus"	class="d3plus_tooltip d3plus_tooltip_small d3plus_tooltip_dev_contents">';
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
    tooltipHtml	+= '</div></div></div>';
    
    return tooltipHtml;
}

