<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!doctype html>
<html>
<head>
	<title>지역경제 모니터링(수평 비율 바)</title>
	<meta charset="utf-8" />
	<script src="/js/jquery/jquery-1.11.2.min.js"></script>
	<script src="/js/d3Chart/d3.js"></script>
	<style>
 		@import url("//fonts.googleapis.com/earlyaccess/nanumgothic.css");
		body{font-family:'Nanum Gothic',NanumGothic,'Nanum gothic',"Helvetica",verdana,sans-serif;font-size:10px;}
		ul {margin-top:40px; padding:0;}
		
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
		.guideline {
			stroke-width: 1;
			shape-rendering: crispEdges;
		}
		.y.axis .tick line{
			stroke: lightgrey;
    		opacity: 0.7;
		}
		
		.midLine { width: 2px; height:15px; left:50%; float:left; position:absolute; background-color:#fff;top:0px;}
		.midText { position:absolute; top:-15px;float:left; left:48%; font-size:12px; }
		.textTop {top:-20px; position:absolute; display:block; width:100%; font-size:16px;font-weight:600;}
		.textBottom {top:40px; position:absolute; display:block; width:100%; font-size:14px;font-weight:400;}
		
		#viewport .sbox small {font-size:9px;}
		#viewport .sbox ul {position:relative;}
		#viewport .sbox ul li.key0 {border-top-width: 15px; border-top-style: solid; font-size: .75em; width:50%; height:9.8px; padding-bottom:5px; padding-left: 0; padding-right: 0; display:inline-block; vertical-align:top;text-align:left;opacity:0.6;}
		#viewport .sbox ul li.key1 {border-top-width: 15px; border-top-style: solid; font-size: .75em; width:50%; height:9.8px; padding-bottom:5px; padding-left: 0; padding-right: 0; display:inline-block; vertical-align:top;text-align:right;opacity:0.6;}
		
	</style>
</head>
<body>
	<div id="viewport" style="width:680px;height:350px;"></div>
	<script type="text/javascript">
	var fullUrl = location.protocol+'//'+location.hostname+( (location.port)  ? ":"+location.port : '' );;
		var chart_config = {
	              selectedRgnClss : 'H4',
	                ctyCd : '11680',
// 	                admiCd : '11680660',
	                dataId: 'rpt-trnd',					// rpt-evntEff           / rpt-trnd
	                pageId: 'rpt-trnd-008-001',			// rpt-evntEff-009-002   / rpt-trnd-008-001
// 	                choroColumn : "total_cnt",				
	                startDate : "20190119",
	                endDate : "20190127"
		};
	
		var colorVal =["#d3d3d3","#ff8166"];
		
		var chartMargin = {
				top: 100,
				right: 5,
				bottom: 20,
				left: 5
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
			
			var chartWidth = Number(d3.select('#viewport').style('width').replace("px", "")) - chartMargin.left - chartMargin.right;
			var chartHeight = Number(d3.select('#viewport').style('height').replace("px", "")) - chartMargin.top - chartMargin.bottom;
	
			var colors = d3.scale.linear().range(colorVal);
			
			var legend = d3.select('#viewport')
			               .append('div')
			               .attr("class","sbox")
			               .style("width",chartWidth+"px")
			               .style("height",chartHeight+"px")
			               .style("top", chartMargin.top+"px")
			               .style("left", chartMargin.left+"px")
			               .style("position", "relative")
			               .append('ul')
			               .attr('class', 'list-inline');
			
		    var keys = legend.selectAll('li.key').data(colors.range());
		    var liWidth = function(i){
		    	return chartData[i].value+"%"; 
		    }
		    
		    
		    // 색상 바
		    keys.enter()
		    	.append('li')
				.attr('class', function(d,i){return "key"+i;})
			    .style("border-top-color" , String)
			    .style("border-top-width" , function(){
			    	var borderTopWidth = chartHeight/4;
			    	return borderTopWidth+"px";
			    })
			    .style("width", function(d, i){ return liWidth(i);})
			    .style("margin-top", chartMargin.top);
		    
		    // 가운데 기준 선
		    var midLine = d3.select('.sbox')
						    .append("div")
						  	.attr("class", "midLine")
						    .style("width","2px")
						    .style("height", function(){
						    	var lineHeight = chartHeight/4;
						    	return lineHeight+"px";
						    })
						    .style("margin-top", chartMargin.top)
						    .style("margin-left", chartMargin.left)
						    
		    
		    // 텍스트
		    var midText = d3.select('.sbox')
			    			.append("div")
			    			.attr("class","midText")
			    			.text("50%");
		    
		    var text = d3.select('.sbox')
		    			 .selectAll('.text')
    					 .data(chartData)
    					 .enter()
					     .append("div")
					  	 .attr("class", "textTop")
					     .style("text-align", function(d, i){
					    	 console.log(d);
					    	 if(d.name == 'E'){					    		 
					    		 return "right";
					    	 }else{
					    		 return "left";
					    	 }
					     })
					     .text(function(d, i){
					    	 var result = " ";
						    	if(d.name == 'E'){
						    		result = d.value + "% 유입인구";
						    	}else {
						    		result = d.value + "% 상주인구";			    		
						    	}
						        return result;
					     });
		    
		    
		    text.append("div")
			  	.attr("class", "textBottom")
			  	.style("top", function(){
			  		return ((chartHeight/4)+$(".textTop").height()) +"px";
			  	})
			    .text(function(d, i){
			    	
			    	return getIndexNumber(d.total_cnt)+"명";
			    });
			
		}
		
		function getIndexNumber(num){
			var result = 0;
			var cnt =  Math.floor(1e-12 + Math.log(num) / Math.LN10);
			
			if(cnt < 4){  // 1000 이하일 경우
				result = num;
			}else{   // 1000 이상일 경우
				if(cnt%4 != 0){ // 만(4), 억(8), 조(12) 단위로만 표현
					cnt = 4 * Math.floor(cnt/4);
				}
				
				result = krWonRound(num,cnt,1);
			}
			return result;
		}
		
		function krWonRound(value,index,precision){
			
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
			return minus+d3.round(value/Math.pow(10,i) , pre) + prs[i];		
		}
	</script>
	</body>
</html>