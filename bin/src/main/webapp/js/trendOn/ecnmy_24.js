/**
 * 맨 위의 시간에 따른 소비인구 변화 그래프 
 * @param timeData  시간에 따른 소비인구 변화 데이터
 * @param yColumn	소비인구수의 기준( 전체 / 주중 / 주말 )
 * @param defaultXY 처음 그래프위의 slider 위치 [date]
 **/
function topTimeGraph(timeData, yColumn, defaultXY){
	var newTileData = [],
		margin = {top: 0, right: 10, bottom: 20, left: 60};

	// 시간단위가 [0,6,9,12,15,18,21,24]이므로 24시간을 7개의 기간에 따른 index로 반환
	function getTimeCd(dd){
		if(dd < 1){
			return 7;
		}else if(dd<=6){
			return 1;
		}else if(dd<=9){
			return 2;
		}else if(dd<=12){
			return 3;
		}else if(dd<=15){
			return 4;
		}else if(dd<=18){
			return 5;
		}else if(dd<=21){
			return 6;
		}else if(dd<=24){
			return 7;
		}
	}

	for(var i = 0 ;i<25;i++){
		//x축에 따른 시간 범위 index 추가
		var dddf = timeData.filter(function(a){
			return a.timezon_cd == getTimeCd(i);
		});
		
		//d3 chart를 표현하기 위한 date format 만들기
		if(  dddf.length > 0   ){
			var item = $.extend({},dddf[0]);
			var tmpTime = item.timezon_cd;
			var currDate = new Date(ecnmy_24_config.bDate);
			item.date = currDate.addHours(i);
			item.timezon_cd = i;
			item.old_timezon_cd = tmpTime;
			newTileData.push(item);
		} ;
	}
	
	// 그래프 영역내의 html을 지우고 새로운 그래프를 그리기
	$("#time24Chart").empty();
	var xColumn = "timezon_cd";
	var HHformat = function(d){
		if(d.getTime() > (ecnmy_24_config.eDate.getTime() - (30*60*1000))){
			return "24시";
		}else{ 					
			var ff = d3.time.format("%H");
			return ff(d)+"시";
		}
	};
	
	// time slider graph 그리기
	timeLineChart("#time24Chart", newTileData, xColumn, yColumn, margin,newTileData.length,HHformat, defaultXY,timeHandler,ecnmy_24_config.bDate,ecnmy_24_config.eDate,"소비인구 수(명)",{'time':1});
}

/**
 * 주제도 표현
 * @param timeArr 선택한 시간대
 * @param column  주제도로 표현할 값
 */
function map24Cholopleth(timeArr,column){
	
	// 지도 색상 변경
	$.ajax({
		url:"/onmap/ecnmy_24/ecnmy_24_map.json",
		data:{
			"ctyCd" : ecnmy_24_config.sessionCtyCd,
			"date" : ecnmy_24_config.selectedDate,
			"period" : timeArr
		},
		success: function(data) {
			
// 					if(typeof data === 'string'){ 
// 						ajaxReload(data);
// 					}else{						
				var mapLayer = matchBlockFeature(map24, data.list, ecnmy_24_config.layerFid);
				legend = doBlkChoropleth(column,mapLayer,colorArr);
// 	console.log(legend);
				$("#ecnmy24_legend").empty();
				$("#ecnmy24_legend").append('<small> 일평균 시간대별 소비인구 수 </small>');
				makeLengend("ecnmy24_legend",colorArr,legend);
				
				if(legend){				
					map24Legend = [];
    				for(var i = 1 ; i < legend.length; i++){
    					var legendValue = legend[i];
    					legendValue = Math.round((legendValue/10))*10
    					if(legendValue >= 50){	        						
    						map24Legend.push(legendValue);
    					}
    				}
				}
// 					}
			
		}
	});
}

/**
 * 맵위의 stacked bar chart
 * @param timeArr 선택한 시간대
 * @param column  그래프로 표현할 값
 */
function mapGraphData(timeArr,column){
	if(timeArr === undefined) timeArr ='';

	$.ajax({
		url:"/onmap/ecnmy_24/ecnmy_24_map_graph_data.json",
		data:{
			"ctyCd" : ecnmy_24_config.sessionCtyCd,
			"date" : ecnmy_24_config.selectedDate,
			"rgnClss" : ecnmy_24_config.selectedRgnClss,
			"period" : timeArr
		},
		success: function(result) {
			
// 					if(typeof result === 'string') ajaxReload(result);
			//scatterChart 변경
			var inputData =[];
			if(result && result.mapGraph){
				for(var i = 0 ; i < 2 ; i++){
					var gubun = "h";
					if(i > 0) gubun = "e";

					for(var j = 0; j < result.mapGraph.length; j++){
						var chartData = {};
						chartData.name = result.mapGraph[j].nm;

						chartData.value = result.mapGraph[j][column+"_"+gubun];

						chartData.gubun = (gubun == "e" ? "유입 인구" : "상주 인구");


						inputData.push(chartData);
					}
				}

				var attributes =[
				                 {"gubun": "상주 인구", "hex": "#d3d3d3"},
				                 {"gubun": "유입 인구", "hex": "#ff8166"}
				                ];

				var label = { y:false };
				var title = "지역별 소비인구 비율";

				$("#scatterChart").empty();
				stackedBarChart_plus(inputData,"#scatterChart",250, attributes, label, title);
//				var chartHtml = $('#scatterChart').html(); 
// 						console.log(chartHtml);
// 						console.log($("body").on("find","#scatterChart"));
			}

		}
	});
}

/**
 * 시간 변화에 따른 callbak 함수
 * @param evt
 * @param start	왼쪽 슬라이더의 값 {date, old_timezon_cd, total_cnt, week_day_cnt, week_end_cnt}
 * @param end 오른쪽 슬라이더의 값 {date, old_timezon_cd, total_cnt, week_day_cnt, week_end_cnt}
 * @param column y축 value{ total_cnt / week_day_cnt / week_end_cnt}
 **/
function timeHandler(evt,start, end,column){
	$(".group_help").css("display","none");

	ecnmy_24_config.selectedTime.x0 = parseInt(start.timezon_cd)  ;
	ecnmy_24_config.selectedTime.x1 =  parseInt(end.timezon_cd)  ;

	var startCd = start.old_timezon_cd;
	var endCd = end.old_timezon_cd;
	var timeArr = "";
	if(startCd <= endCd){
		for(var i = startCd; i <= endCd; i++){
			timeArr += "'"+i+"'";
			if(i != endCd) timeArr +=",";
		}
		
		ecnmy_24_config.timeArr = timeArr;
		
		//지도 주제도 변경
		map24Cholopleth(timeArr,column);

		//지도위의 그래프 변경
		mapGraphData(timeArr,column);
	}

}

// 
/**
 * 지역선택(selectBox)
 * @param value 이동할 지역 admi_cd
 * @param chk	지도초기화인지 아닌지 (지도초기화 일때만 'init'값이 있음)
 **/
function zoomRegion(value, chk){
	var bounds = null;
	var coord = null;
	var tLayer = null;
	if(chk && chk == 'init'){
		bounds = initBounds;
		$("#admiSelect").val("");
		$("#admiTit").text("지역을 선택하세요.");
	}else{
//		for(var obj in map24._layers){
//			if(map24._layers[obj]._layers){
//				for(var objLayer in map24._layers[obj]._layers){
//					if(map24._layers[obj]._layers[objLayer].feature){
//						var mapFeature = map24._layers[obj]._layers[objLayer].feature;
//
//						if(mapFeature.properties.id	 == value){
//							bounds = map24._layers[obj]._layers[objLayer]._bounds;
//							coord = map24._layers[obj]._layers[objLayer].feature.geometry.coordinates;
//							break;
//						}
//					}
//				}
//			}
//		}
		
		for(var obj in map24._layers){
			if(map24._layers[obj].feature){
			
				var mapFeature = map24._layers[obj].feature;
				if(mapFeature.properties.id	 == value){
					bounds = map24._layers[obj]._bounds;
					coord = map24._layers[obj].feature.geometry.coordinates;
					tLayer = map24._layers[obj];
					break;
				}
			}
				
		}
	}
	
	map24.fitBounds(bounds);
	if(chk && chk == 'init'){
		for(var obj in map24._layers){
			if(map24._layers[obj].feature_id){
				map24.removeLayer(map24._layers[obj]);
			}
		}
	}else{
		setPolygon2(tLayer,value);
	}
	$("#admiSelect").focus();
}

/**
 * selectbox로 지도 선택시 검은 테두리 생성
 * @param coord 테두리 좌표값
 * @param value 지역 코드
 */
function setPolygon(coord,value){
	for(var obj in map24._layers){
		if(map24._layers[obj].feature_id){
			map24.removeLayer(map24._layers[obj]);
		}
	}
	var latlng = [];

	if(coord[0].length > 0){
		for(var i = 0 ; i < coord[0].length ; i++ ){
			var lnArray = [coord[0][i][1],coord[0][i][0]];
			latlng.push(lnArray);
		}
//		for(var i = 0 ; i < coord[0][0].length ; i++ ){
//			var lnArray = [coord[0][0][i][1],coord[0][0][i][0]];
//			latlng.push(lnArray);
//		}
	}

	var polygon = L.polygon(latlng
							,{fill: false,
								  weight: 5,
						          opacity: 1,
						          color: '#333333',
						          fillOpacity: 0
		                })

	polygon.feature_id = 'ecnmy24_admi_polygon_'+value;
	polygon.addTo(map24);
	polygon.bringToFront();
}

/**
 * selectbox로 지도 선택시 검은 테두리 생성(new)
 * @param tLayer 선택지역 layer
 * @param value 지역 코드
 */
function setPolygon2(tLayer,value){
	for(var obj in map24._layers){
		if(map24._layers[obj].feature_id){
			map24._layers[obj].setStyle({
				fill: false,
				weight: 5,
		        opacity: 0,
		        color: '#333333',
		        fillOpacity: 0
			});
//			map24.removeLayer(map24._layers[obj]);
		}
	}
	
	tLayer.setStyle({
		fill: false,
		weight: 5,
        opacity: 1,
        color: '#333333',
        fillOpacity: 0
	});
	
	tLayer.feature_id = 'ecnmy24_admi_polygon_'+value;
	tLayer.addTo(map24);
	tLayer.bringToFront();
}

