/**
 * 지도 관련 함수.
 */

/**
 * 주제도 영역 표시
 * @param url  		데이터를 가져올 url
 * @param config 	설정값들
 * @param fid  		layer에 할당할 id 값
 * @param rgnCode	지역단위 구분 코드
 * @param ctyCd		지역 코드(시군구)
 * @param callback	
 */
function makeMap(url, config, fid, rgnCode, ctyCd, callback){
	if(ctyCd === undefined || ctyCd == ""){
		ctyCd = config.sessionCtyCd;
	} 
	var admiAround = "";
	if(config.admiAround){ 
		admiAround = config.admiAround; 
	}
//	var asyncValue = false;
//	if(rgnCode !== undefined && rgnCode == 'H2') asyncValue = true;
	
	$.ajax({
		type: "GET",
		dataType: 'json',
		url:url,
		async: false,
		data:{
			"layerName" : fid,
			"ctyCd" : ctyCd,
			"admiCd" : config.selectAmdiCd,
			"admiAround" : admiAround,
			"rgnClss" : rgnCode
		},
		success: function(json) {
			// 매출변화
			mapArr[fid].data = $.extend({},json);
			mapArr[fid].layer = L.geoJSON(mapArr[fid].data, {
		        opacity: 0,
		        fillOpacity: 0
	    	}).bindPopup(L.popup({closeButton:false,autoPan:false}));
			mapArr[fid].layer._fid = fid;
			config.layerFid[fid] = mapArr[fid].layer._fid;
			mapArr[fid].layer.addTo(mapArr[fid].map);

			layerPopupSetting2(mapArr[fid].layer, mapArr[fid].map, fid, mapArr[fid].init, mapArr[fid].popup.column, mapArr[fid].popup.tit, mapArr[fid].popup.unit);

			
			
			mapArr[fid].bounds = mapArr[fid].layer.getBounds();
			mapArr[fid].map.fitBounds(mapArr[fid].bounds);
			
			if(callback) callback();
			
		}
	});
}


/**
* 행렬중 입력한 숫자와 가장 근접한 행 찾기
* @param num 입력한 수
* @param arr 기준 행렬
* @returns
*/
function closeset(num,arr){
	var curr=arr[0];
	var index = 0;
	
	for(var i = 0 ;i<arr.length;i++){
		if(Math.abs(num - arr[i]) <  Math.abs(num - curr) ){
			curr = arr[i];
			index = i;
		}
	}
	
	return arr.indexOf(curr);
}

/**
 * 행렬중 입력한 숫자의 범위 찾기
 * @param num 입력한 수
 * @param arr 기준 행렬
 * @returns
 */
function rangeset(num,arr){
	var curr=arr[0];
	
	if(arr[arr.length -1] <= num){
		return arr.length-1;
	}else{
		for(var i = 0 ; i < arr.length; i++){
			if(arr[i] > num){
				return i;
			}
		}
	}
	
}


/**
* 하나만 선택했을때의 단계구분도 (행정동)  --- 사용안함
*/
function doAdmiChoropleth2(colName, layer, data,colorArr){
	var classifyData = new Array();
	var colNameArr = colName;

	for(var i = 0 ;i<data.features.length;i++){
		var featureJson = data.features[i];
		var colNameCnt = featureJson.properties[colNameArr];	
		classifyData.push(colNameCnt);
	}

	var serie = new geostats(classifyData);
	var arrNum = serie.getQuantiles(6);
	function style(feature) {
		
		var colNameCnt = feature.properties[colNameArr];				
		var cIndex = Number(closeset(colNameCnt ,  arrNum  ) );
		
		var colar = colorArr[cIndex];
		
			return {
				fillColor: colar,
				weight: 1,
				opacity: 1,
				color: '#fff',
				dashArray: '1',
				fillOpacity: 0.5
			};	
	}
	
	layer.setStyle(style);	
}

/**
* [ 이벤트 효과 ]  단계구분도 (행정동)
* @param colName 			주제도로 표현할 값의 컬럼 명
* @param layer				
* @param colorArr			컬러 맵
* @param selectedAdmiCd 	선택한 행정동 코드
* @param fid 				변경할 layer id
*/
function doAdmiChoropleth3(colName, layer, colorArr, selectedAdmiCd, fid){
	var colorList = [
	                 [ '#fdae61', '#d7191c'],
	                 [ '#fdae61', '#d7191c'],
	                 [ '#ffffbf', '#fdae61', '#d7191c'],
	                 [ '#abdda4', '#ffffbf', '#fdae61', '#d7191c']
	                ];
//	var colorList = [
//	                 [ '#2c7bb6', '#d7191c'],
//	                 [ '#2c7bb6', '#d7191c'],
//	                 [ '#2c7bb6', '#ffffbf', '#d7191c'],
//	                 [ '#2c7bb6', '#ffffbf', '#fdae61', '#d7191c']
//	                 ];
	var classifyData = new Array();
	var useLayerArr = [];
	var colNameArr = colName;
	for(var fnum in layer._layers){
		var colNameCnt = layer._layers[fnum].feature.properties[colNameArr];	
		if(colNameCnt !== undefined){			
			classifyData.push(colNameCnt);
			
			// config에 zoomlevel을 위한 layer 저장
			useLayerArr.push(layer._layers[fnum]);
		}
	}
	
	// data들중 중복된 값 제외.
	var arrNum = classifyData.reduce(function(a,b){
		if (a.indexOf(b) < 0 ) a.push(b);
		return a;
	  },[]);
	
	// 주제도 단계 설정
	var num = 6;
	var serie = new geostats(arrNum);
//	var serie = new geostats(classifyData);
//	var arrNum = serie.getQuantiles(6);
	
	// data들중 중복된 값을 제외한 배열의 갯수가 주제도 단계값보다 작으면 
	// data들중 중복된 값을 제외한 배열을 단계기준값으로 사용.
	if(arrNum.length < (num-1)){
		if(arrNum.length == 1){
			arrNum.push((arrNum[0]-1));
		}
		// data들중 중복된 값을 제외한 배열의 값을 크기순으로 정렬.
		arrNum.sort(function(a, b){
			return a - b;
		});
		// 색상코드값도 배열의 갯수와 같은 색상배열로 선택
		colorArr = colorList[(arrNum.length-1)];
	}else{
		arrNum = serie.getQuantiles(num);
	}

	function style(feature) {
		
		var colNameCnt = feature.properties[colNameArr];	
		if(colNameCnt === undefined){
			return {
//				fillColor: colorArr[0],
				fillColor: '#2c7bb6',
				weight: 1,
				opacity: 1,
				color: '#fff',
				dashArray: '1',
				fillOpacity: 0.5
			};	
		}
		if(selectedAdmiCd && selectedAdmiCd == feature.properties.id){
			var cIndex = Number(closeset(colNameCnt ,  arrNum  ) );
			var colar = colorArr[cIndex];
				return {
					fillColor: colar,
					weight: 5,
					opacity: 1,
					color: '#333',
					dashArray: '1',
					fillOpacity: 0.5
				};	
		}else{
			var cIndex = Number(closeset(colNameCnt ,  arrNum  ) );
			var colar = colorArr[cIndex];
				return {
					fillColor: colar,
					weight: 1,
					opacity: 1,
					color: '#fff',
					dashArray: '1',
					fillOpacity: 0.5
				};	
		}

	}
	layer.setStyle(style);	
	
	
	// 해당시군구 항상 맨 위로 오게
	if(selectedAdmiCd){		
		for(var ll in layer._layers){
			if(layer._layers[ll].feature.properties.id == selectedAdmiCd){
				layer._layers[ll].bringToFront();
			}
		}
	}
}

/**
 * 트렌드온과 방문객 유입지역 전국 주제도 (행정동)
 * @param colName 주제도를 나눌 기준 컬럼
 * @param layer 
 * @param colorArr 컬러코드 배열
 * @param selectedCityCd 선택된 시군구 코드
 */
function doAdmiChoropleth(colName, layer, colorArr, selectedCityCd){
	var colorList = [
	                 [ '#fdae61', '#d7191c'],
	                 [ '#fdae61', '#d7191c'],
	                 [ '#ffffbf', '#fdae61', '#d7191c'],
	                 [ '#abdda4', '#ffffbf', '#fdae61', '#d7191c'],
	                 [ '#2c7bb6', '#abdda4', '#ffffbf', '#fdae61', '#d7191c']
	                ];
//	var colorList = [
//	                 [ '#2c7bb6', '#d7191c'],
//	                 [ '#2c7bb6', '#ffffbf', '#d7191c'],
//	                 [ '#2c7bb6', '#ffffbf','#fdae61', '#d7191c'],
//	                 [ '#2c7bb6', '#abdda4', '#ffffbf','#fdae61', '#d7191c'],
//	                 [ '#2c7bb6', '#abdda4', '#ffffbf','#fdae61', '#d7191c', '#d7191c']
//	                ];
	var classifyData = new Array();
	var colNameArr = colName;
	
	for(var fnum in layer._layers){
		var colNameCnt = layer._layers[fnum].feature.properties[colNameArr];	

		if(colNameCnt !== undefined){			
			classifyData.push(colNameCnt);
		}
	}

	// data들중 중복된 값 제외.
	var arrNum = classifyData.reduce(function(a,b){
		if (a.indexOf(b) < 0 ) a.push(b);
		return a;
	},[]);
	
	
	// 주제도 단계 설정
	var num = 6;
	var serie = new geostats(arrNum);
//	var serie = new geostats(classifyData);
	
	
	// data들중 중복된 값을 제외한 배열의 갯수가 주제도 단계값보다 작으면 
	// data들중 중복된 값을 제외한 배열을 단계기준값으로 사용.
	if(arrNum.length <= (num-1)){
//		arrNum.push(0);
		if(arrNum.length == 1){
			arrNum.push((arrNum[0]-1));
		}
		// data들중 중복된 값을 제외한 배열의 값을 크기순으로 정렬.
		arrNum.sort(function(a, b){
			return a - b;
		});
		// 색상코드값도 배열의 갯수와 같은 색상배열로 선택
		colorArr = colorList[ ( arrNum.length -1 )];
	}else{
		// 등개수이기 때문에 기준값이 중복될수 있음 (ex [0.3 ,0.3 ,0.6 ,0.6, 1.8])
		arrNum = serie.getQuantiles(num);
	}
	
	
	function style(feature) {
		
		var colNameCnt = feature.properties[colNameArr];
		if(layer._fid =='event6' && colNameCnt === undefined) {		// 유입인구 유입지역에서 값이 null이면 파란색으로
			if(selectedCityCd && selectedCityCd.indexOf(feature.properties.id) == 0){	// 선택한 지역이면
				return {
					fillColor: colar,
					weight: 5,
					opacity: 1,
					color: '#333',
					dashArray: '1',
					fillOpacity: 0
				};
			}else{
				return {
					fillColor: '#2c7bb6',
					weight: 1,
					opacity: 1,
					color: '#fff',
					dashArray: '1',
					fillOpacity: 0.5
				};
			}
			
		}
		
		if(colNameCnt === undefined) colNameCnt = 0;				// 값이 null이면 0으로 치환
		var cIndex = Number(closeset(colNameCnt ,  arrNum  ) );		// 등급 가져오기
		var colar = colorArr[cIndex];								// 색 가져오기
		
		if(selectedCityCd && selectedCityCd.indexOf(feature.properties.id) == 0){	// 선택한 지역이면
			
			return {
				fillColor: colar,
				weight: 5,
				opacity: 1,
				color: '#333',
				dashArray: '1',
				fillOpacity: 0
			};
		}else{																		// 선택한 지역이 아니면		
			return {
				fillColor: colar,
				weight: 1,
				opacity: 1,
				color: '#fff',
				dashArray: '1',
				fillOpacity: 0.5
			};	
		}
	}
	layer.setStyle(style);	
	
	//해당 시군구 코드가 있을때 테두리 강조
	if(selectedCityCd){		
		for(var ll in layer._layers){
			if( selectedCityCd.indexOf(layer._layers[ll].feature.properties.id) == 0 ){
				layer._layers[ll].bringToFront();
			}
		}
	}
}

/**
* 하나만 선택했을때의 단계구분도 (블록)
* @param colName  주제도로 표현할 값의 컬럼 명
* @param layer	
* @param colorArr 컬러 맵 	
*/
function doBlkChoropleth(colName, layer, colorArr){
	var classifyData = new Array();
	var colNameArr = colName;

	for(var fnum in layer._layers){
		var colNameCnt = layer._layers[fnum].feature.properties[colNameArr];	
		if(colNameCnt > 0){
			classifyData.push(colNameCnt);
		}
	}
	
	var serie = new geostats(classifyData);
	var arrNum = serie.getQuantiles(11);
	
	function style(feature) {
		
		var colNameCnt = feature.properties[colNameArr];				
		var cIndex = Number(closeset(colNameCnt ,  arrNum  ) );
//		var cIndex = Number(rangeset(colNameCnt ,  arrNum  ) );
		var colar = colorArr[cIndex];
			return {
				fillColor: colar,
				weight: 1,
				opacity: 1,
				color: '#fff',
				dashArray: '1',
				fillOpacity: 0.5
			};	
	}
	layer.setStyle(style);	
	
	return arrNum;
}

/**
 * 지도 범례 
 * @param divId		범례를 담을 div id 
 * @param colorVal 	컬러 맵
 * @param vals 
 */
function makeLengend(divId , colorVal , vals){
//	var colorVal = ["#edf8e9","#a1d99b","#74c476","#41ab5d","#005a32"];    	
//	var vals = ["1111","2222","3333","4444","5555","6666","7777"];
	
	var colors = d3.scale.quantize().range(colorVal);
	var legend = d3.select('#'+divId).append('ul').attr('class', 'list-inline');
    var keys = legend.selectAll('li.key').data(colors.range());
    var liWidth = 100/(colorVal.length);
    
    keys.enter().append('li')
			    .attr('class', 'key')
			    .style({'border-top-color' : String, 'width':liWidth+'%'})
			    .text(function(d,i) {
			    	var result = " ";
			    	if(i == 0){
			    		result = "적음";
			    	}else if(i == (vals.length-1)){
			    		result = "많음";			    		
			    	}
			        var r = colors.invertExtent(d);
//			        return vals[i];
			        return result;
			    });
}

/**
 * 특정 layer를 map에서 찾음.
 * @param fid  찾고 싶은 layer id
 * @param map  
 * @returns
 */
function getLayerByFid(fid, map){
	for(var l in map._layers){
		if(map._layers[l]._fid == fid){
			return map._layers[l];
		}
	}
}

function removeLayer(fid){
	var map = mapArr[fid].map;
	var layers = map._layers;
	for(var  l in layers){
		if(fid == layers[l]._fid){
			map.removeLayer(layers[l]);
		}
	}
}

/**
 * 지도의 스타일초기화
 * @param fid		초기화시킬 레이어 id
 * @param layer     
 * @param selectCd  선택한 지역코드
 */
function initStyle(fid, layer, selectCd){

	function style(feature) {
		if(selectCd && selectCd.indexOf(feature.properties.id) != -1){
			return {
				weight: 5,
				opacity: 1,
				color: '#333',
				dashArray: '1',
				fillOpacity: 0
			};	
		}else{
			return {
				weight: 1,
				opacity: 0,
				color: '#fff',
				dashArray: '1',
				fillOpacity: 0
			};	
		}

	}
	layer.setStyle(style);	
}

/**
 * 유입인구 지도 초기화
 * @param map
 * @param fid
 */
function layersInitStyle(map, fid){
	var fLayers = getLayerByFid(fid, map);
	for(var ll in fLayers._layers){
		fLayers._layers[ll].setStyle({
				weight: 1,
				opacity: 0,
				color: '#fff',
				dashArray: '1',
				fillOpacity: 0
			});
//		initStyle(fid, fLayers._layers[ll]);
//		console.log(fLayers._layers[ll]);
	}
}

/**
 * 행정동 주제도를 위한 데이터 변경 함수( 각 레이어의 id 값을 비교해서 properties 변경 ) 
 * @param map
 * @param data 매칭시킬 데이터
 * @param fid  매칭시킬 레이어 id
 * @returns
 */
function matchFeature(map, data, fid){
	var  fLayer = getLayerByFid(fid, map);
	for (var dt in data){
		for(var  l in fLayer._layers){
			var feature = fLayer._layers[l].feature;
			if(feature.properties.id == data[dt].id){
					feature.properties = $.extend(feature.properties,data[dt]);	
			}
		}
	}
	return fLayer
}

/**
 * 행정동 주제도를 위한 데이터 변경 함수 ( data list에 없는 값들을 초기화 시킴. )
 * 선택한 행정동 & 주변 행정동을 제외한 지역의 값에만 값을 적용
 * @param map
 * @param data
 * @param fid
 * @param layer
 * @returns
 */
function matchFeature2(map, data, fid, layer){
	var fLayer = getLayerByFid(fid, map);
	var deaultLayer = layer._layers;
	
	// 주제도에서 나온 지역이 아닌 지역의 feature를 지운다.
	for(var  l in fLayer._layers){
		var feature = fLayer._layers[l].feature;
		if(feature.properties.id == deaultLayer[l].feature.properties.id){
			var keys = Object.keys(feature.properties);
			for(var i = 0 ; i < keys.length; i++){
				if('id,nm,full_name'.indexOf(keys[i]) == -1 ){
					delete feature.properties[keys[i]];
				}
//					feature.properties = deaultLayer[l].feature.properties;	
			}
		}
	}
	
	for (var dt in data){
		for(var  l in fLayer._layers){
			var feature = fLayer._layers[l].feature;
			if(feature.properties.id == data[dt].id){
					feature.properties = $.extend(feature.properties,data[dt]);	
			}
		}
	}
	return fLayer
}

/**
 * 블록단위의 주제도를 위한 데이터 변경 함수 
 * @param map
 * @param data
 * @param fid
 * @returns
 */
function matchBlockFeature(map, data, fid){
	var  fLayer = getLayerByFid(fid, map);
	
	// 기본 값 채워넣기( default value )
	for(var  l in fLayer._layers){
		var feature = fLayer._layers[l].feature;
		var tempData = {week_end_cnt: 0, week_days_cnt: 0, total_cnt: 0};
		feature.properties = $.extend(feature.properties,tempData);	
	}
	
	// 제공된 데이터가 있을 경우만 데이터 적용
	for (var dt in data){
		for(var  l in fLayer._layers){
			var feature = fLayer._layers[l].feature;	
			if(feature.properties.id == data[dt].id){
				feature.properties = $.extend(feature.properties,data[dt]);	
			}
		}
	}
	return fLayer
}

/**
 * 마우스 오버시 나오는 popup 세팅 (사용안함)
 * mapLayer : 적용할 레이어
 * map : 적용할 map
 * name : 새로 추가할때 사용할 레이어 이름
 * initCd : 추가된 레이어명 저장
 **/
function layerPopupSetting(mapLayer, map, name, initCd, column, title, menu){
	
	mapLayer.on('mouseover',function(e){
    	(function(layer, properties) {
    		
    		if(layer.options.color == "#2B83BA") return;
    		
    		// 마우스 오버시 지역 테두리 변경
			layer.setStyle({
				fillColor: layer.options.fillColor,
				weight: 5,
				opacity: 1,
				color: '#2B83BA',
				dashArray: '1',
				fillOpacity: layer.options.fillOpacity,
				bak_color : layer.options.color,
				bak_opacity: layer.options.opacity,
				bar_weight: layer.options.weight
			});	
			
			layer.bringToFront();
			
//    		if(layer.feature.properties.id == initCd){
//    			return;
//    		}
//    		
//			var latlng = [];
//    		if(layer.feature.geometry.coordinates[0].length > 0){
//				for(var i = 0 ; i < layer.feature.geometry.coordinates[0][0].length ; i++ ){
//					var lnArray = [layer.feature.geometry.coordinates[0][0][i][1],layer.feature.geometry.coordinates[0][0][i][0]];
//					latlng.push(lnArray);
//				}
//    		}
//
//    		var polygon = L.polygon(latlng
//    								,{fillColor: 'white',
//									  weight: 5,
// 							          opacity: 1,
//							          color: '#2b83ba',
//			//				          dashArray: '3',
//							          fillOpacity: 0
//			                });
//
//    		polygon.feature_id = 'ecnmyTrnd_'+name+'_polygon_'+layer.feature.properties.id;
//    		initCd = layer.feature.properties.id;
//    		polygon.addTo(map);
//    		
//    		polygon.on('mouseout',function(e){
//				(function(layer, properties) {
//					for(var obj in map._layers){
//						if(map._layers[obj].feature_id && map._layers[obj].feature_id.indexOf("ecnmyTrnd_"+name+"_polygon_") != -1 ){
//							map.removeLayer(map._layers[obj]);
//							initBlkCd =null;
//							mapLayer.closePopup();
//						}
//					}
//
//				})(e.layer, e.properties);
//			});
    		
    		//popup 
    		var popupData = [];
    		
    		if(Array.isArray(column)){
//    			console.log("array");
    			for(var i = 0 ; i < column.length ; i++){
    				var popupArr = {};
    				
    				var popValue = layer.feature.properties[column[i].value];
        			
    				if(popValue === undefined) popValue = 0;
    				
        			if(column[i].value == 'rate'){ 
        				popValue = popValue+"%"; 
        			}else if(column[i].value.indexOf('cnt') != -1){ 
        				popValue = krWonRound(popValue,4,1)+"명";
        			}else{
        				if(menu && menu == 'event'){            					
        					popValue = krWonRound(popValue,8,2)+"원";    				
        				}else{        					
        					popValue = krWonRound(popValue,8,1)+"원";    				
        				}
        			}
    				
    				popupArr.name = layer.feature.properties["nm"] + " " + column[i].nm;
    				popupArr.value = popValue;
    				
    				popupData.push(popupArr);
    			}
    		}else{
    			var popValue = layer.feature.properties[column];
    			
    			if(popValue === undefined) popValue = 0;
    			
    			if(column == 'rate'){ 
    				popValue = popValue+"%"; 
    			}else if(column.indexOf('cnt') != -1){ 
    				popValue = krWonRound(popValue,4,1)+"명";
    			}else{
    				if(menu && menu == 'event'){    					
    					popValue = krWonRound(popValue,8,2)+"원";    				
    				}else{    					
    					popValue = krWonRound(popValue,8,1)+"원";    				
    				}
    			}
    			
    			 popupData.push({"name":layer.feature.properties["nm"], "value":popValue});
    		}
    		
    		mapLayer.setPopupContent(getMapTooltip(popupData,title));
    		mapLayer.openPopup(e.latlng);
    		
    	})(e.layer, e.properties);
	});
	
	mapLayer.on('mouseout',function(e){
    	(function(layer, properties) {
    		if(layer.options.color == "#fff") return;
    		
    		var lcolor = (layer.options.bak_color !== undefined?layer.options.bak_color:'#fff');
    		var lopacity = (layer.options.bak_opacity !== undefined?layer.options.bak_opacity:'1');
    		var lweight = (layer.options.bak_weight !== undefined?layer.options.bak_weight:'1');
    		
    		layer.setStyle({
				fillColor: layer.options.fillColor,
				weight: lweight,
				opacity: lopacity,
				color: lcolor,
				dashArray: 1,
				fillOpacity: layer.options.fillOpacity
			});	
    		mapLayer.closePopup();
    		
    		if(layer.options.bak_color != "#fff"){	
    			layer.bringToFront();
    		}else{
    			layer.bringToBack();
    		}
    		
    	})(e.layer, e.properties);
	});
}



/**
 * 마우스 오버시 나오는 popup 세팅
 * mapLayer : 적용할 레이어
 * map : 적용할 map
 * name : 새로 추가할때 사용할 레이어 이름
 * initCd : 추가된 레이어명 저장
 **/
function layerPopupSetting2(mapLayer, map, name, initCd, column, title, unit){

	mapLayer.on('mouseover',function(e){
    	(function(layer, properties) {
    		
    		//방문객 유입지역에 값을 없을 경우 popup 일시정지
    		if(mapArr[name].popupStop && layer.options.color != "#333") return;
    		
    		// 서비스 대상 유무 확인 (서비스 대상일 경우 title을 백업해둔다.)
    		var backTitle = "";
    		if(layer.options.fillOpacity === undefined || layer.options.fillOpacity == 0){
    			backTitle = title;
    		}
    		// 이미 마우스 밑에 있는 layer일경우 거르기
    		if(layer.options.color == "#2B83BA") return;
    		
    		// 마우스 오버시 지역 테두리 변경
    		layer.setStyle({
				fillColor: layer.options.fillColor,
				weight: 5,
				opacity: 1,
				color: '#2B83BA',
				dashArray: '1',
				fillOpacity: layer.options.fillOpacity,
				bak_color : layer.options.color,
				bak_opacity: layer.options.opacity,
				bar_weight: layer.options.weight
			});	
    		// 해당 레이어를 맨앞으로 가져오기
			layer.bringToFront();
			
    		//popup 
    		var popupData = [];
    		
    		//컬럼이 배열일 경우 (popup contents에 값이 두개 이상들어갈 경우 혹은 왼쪽의 내용을 변경하고싶은 경우)
    		if(Array.isArray(column)){
    			for(var i = 0 ; i < column.length ; i++){
    				var popupArr = {};
    				
    				// popup 내용의 왼쪽 부분에 들어갈 내용 ( 지역명 사용 여부 )
    				if(column[i].areaYn !== undefined && column[i].areaYn == 'N'){    					
    					popupArr.name = column[i].nm;
    				}else{    					
    					popupArr.name = layer.feature.properties["nm"] + " " + column[i].nm;
    				}
    				
    				// popup 내용의 오른쪽 부분에 들어갈 내용
    				var popValue = "0.0";
    				var rateSign = "";
					var rateSignKr = "증가";
					
    				if(Array.isArray(column[i].value)){  
    					if((layer.feature.properties[column[i].value[0]]+"").indexOf('-') == -1){
    						rateSign = "+";
    					}
    					popValue =  rateSign + layer.feature.properties[column[i].value[0]] + unit[i][0] + rateSignKr;
    					popupArr.value = popValue;
    				}else{
    					if(layer.feature.properties[column[i].value] === undefined){	// 값이 없을 경우
    						popValue = "-"
    					}else{    									
    						if((layer.feature.properties[column[i].value]+"").indexOf('-') == -1){
        						rateSign = "+";
        					}
    						popValue =  rateSign + layer.feature.properties[column[i].value];
    					}
    					popupArr.value = popValue + unit[i];
    				}
    				
    				popupData.push(popupArr);
    			}
    		}else{
    			var popValue = layer.feature.properties[column];
    			
    			if(popValue === undefined) popValue = "0.0";
    			
    			// 방문객 유입지역일 경우 해당 시군구의 popup내용 변경
    			if("event6,trend1_4,trend2_4,trend3_4".indexOf(name) != -1){  
    				if(backTitle != ""){
    					title={"value":"서비스 대상지역","color":"#333"};
    					popupData.push({"name":layer.feature.properties["full_name"], "value":""});    					
    				}else{
    					popupData.push({"name":layer.feature.properties["full_name"], "value":popValue + unit});
    				}
    			}else{
    				popupData.push({"name":layer.feature.properties["nm"], "value":popValue + unit});
    			}
    		}
    		
    		if(title.areaYn && title.areaYn == 'Y'){
    			title.value = layer.feature.properties["nm"] + " " + title.tit;
    		}
    		
    		mapLayer.setPopupContent(getMapTooltip(popupData,title));
    		mapLayer.openPopup(e.latlng);
    		
    		if(backTitle != ""){
    			title = backTitle;
    			backTitle = "";
    		}
    		
    	})(e.layer, e.properties);
	});
	
	mapLayer.on('mouseout',function(e){
    	(function(layer, properties) {
    		//방문객 유입지역에 값을 없을 경우 popup 일시정지
//    		if(mapArr[name].popupStop) return;
    		
    		if(layer.options.color == "#fff") return;
    		
    		var lcolor = (layer.options.bak_color !== undefined?layer.options.bak_color:'#fff');
    		var lopacity = (layer.options.bak_opacity !== undefined?layer.options.bak_opacity:'1');
    		var lweight = (layer.options.bar_weight !== undefined?layer.options.bar_weight:'1');
    		
    		layer.setStyle({
				fillColor: layer.options.fillColor,
				weight: lweight,
//				opacity: lopacity,
				color: lcolor,
				dashArray: 1,
				fillOpacity: layer.options.fillOpacity
			});	
    		mapLayer.closePopup();
    		
    		if(layer.options.bak_color != "#fff"){	
    			layer.bringToFront();
    		}else{
    			layer.bringToBack();
    		}
    		
    	})(e.layer, e.properties);
	});
}

/**
 * 해당시군구의 bound를 가져오기
 * @param fid      레이어 id
 * @param areaCd   지역코드
 * @param callback
 */
function setConfigBound(fid, areaCd, callback){
//	mapArr[fid].zoom = mapArr[fid].map.getZoom();
	
	for(var l in mapArr[fid].layer._layers){
		var cty_cd = mapArr[fid].layer._layers[l].feature.properties.id;
		if(areaCd.indexOf(cty_cd) == 0){
			
			var ctyBound = mapArr[fid].layer._layers[l].getBounds();
			mapArr[fid].bounds = ctyBound;
			
			callback();
		}
	}
}

/**
 * 초기 map의 bound로 이동.(지도 초기화)
 * @param id 지도 fid
 */
function mapReload(id){
	mapArr[id].map.fitBounds(mapArr[id].bounds,{'maxZoom':mapArr[id].zoom});	
}

/**
 * tooltip html 코드 
 * @param data          내용에 들어갈 data
 * @param title []      제목 색 과 제목 값
 * @returns {String}    popup html
 */
function getMapTooltip(data, title){

//	d.name + "<br/>"  + d.yEnd    
//	var tooltipHtml = '<div id="d3plus_tooltip_id_visualization_focus"	class="d3plus_tooltip d3plus_tooltip_small d3plus_tooltip_dev_contents">';
	var tooltipHtml = '';
//	tooltipHtml	+= '<div id="d3plus_tooltip_id_visualization_focus"	class="d3plus_tooltip d3plus_tooltip_small d3plus_tooltip_dev_contents">';
//	tooltipHtml	+= '<div class="d3plus_tooltip_container d3plus_tooltip_dev_container">';
	tooltipHtml	+= '<div class="d3plus_tooltip_header d3plus_tooltip_dev_header">';
	tooltipHtml	+= '<div class="d3plus_tooltip_title d3plus_tooltip_dev_title" style="color:'+title.color+';"><b>'+title.value+'</b></div>';
	tooltipHtml	+= '</div>';
	tooltipHtml	+= '<div class="d3plus_tooltip_data_container d3plus_tooltip_dev_data_container">';
	// 111111
		if(data){
			for(var i = 0 ; i < data.length ; i++ ){
				tooltipHtml	+= '<div class="d3plus_tooltip_data_block d3plus_tooltip_dev_data_block">';
				tooltipHtml	+= '<div class="d3plus_tooltip_data_name d3plus_tooltip_dev_data_name">'+data[i].name+'</div>';
				tooltipHtml	+= '<div class="d3plus_tooltip_data_value d3plus_tooltip_dev_data_value">'+data[i].value+'</div>';
				tooltipHtml	+= '</div>';
				
					if(i < (data.length -1)){
						tooltipHtml	+= '<div class="d3plus_tooltip_data_seperator d3plus_tooltip_dev_data_seperator"></div>';
					}
			}
		}		
		
	tooltipHtml	+= '</div>';
//	tooltipHtml	+= '<div class="d3plus_tooltip_footer d3plus_tooltip_dev_footer"></div>';
//	tooltipHtml	+= '</div>';
	
	return tooltipHtml;
}
