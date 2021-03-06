/**
 * @description 시군구 vs 광역시도 비교 설정값
 * @descriptor 김용현
 * @date 2020.08.23
 */

/**
 * 1. 거래금액(지도)
 * 2. 업종별 거래금액
 * 3. 유입인구 수(지도)
 * 4. 성/연령별 대표 유입인구
 * 5. 유입인구 소비(지도)
 * 6. 업종별 유입인구 소비특성
 * 7. 유입인구 소비시간 
 * 8. 유입인구 유입지역(지도) 
 */

if(!trendon) var trendon= {};

trendon.compare = {
		
	/**
	 * @description 서버 요청 파라미터 설정
	 */
	setParameter: function(data) {
		var tmpData = OM.Comm.deepCloneObj(data);  // 얕은 복사
		var keys = Object.keys(tmpData);
		
		keys.map(function(key) {
			var value = tmpData[key];
			
			if(key === 'ctyCd' && !value) tmpData[key] = trendon.trnd.ctyCd;
// 				if(key === 'startDate' && !value) tmpData[key] = trendon.trnd.startDate;
// 				if(key === 'endDate' && !value) tmpData[key] = trendon.trnd.endDate;
			if(key === 'startDate' && !value) tmpData[key] = '20200601';
			if(key === 'endDate' && !value) tmpData[key] = '20200630';
			if(key === 'rgnClss' && !value) tmpData[key] = trendon.trnd.rgnClss;
		});
		
		return tmpData;
	},
	
	getConfig: function(index) {
		
		if(isNaN(index)) index = -1;
		
		var configs = [
			
			// 1. 거래금액(지도포함)
			{
				name: '1. 거래금액',
				data: [{
					message: '시군구 데이터',
					path: '/onmap/ecnmy_trnd/ecnmy_trnd_amt_text.json',
					params: {
						ctyCd: null,
						startDate: null,
						endDate: null,
						limitCnt: 3
					},
					callback: function(result) {
						
						return;
						var arr = [];
						var dataType1= result['amtTotal'];
						var dataType2 = result['amtRankList'];
						
						if(!dataType1) return;
						if(!dataType2 || dataType2.length === 0) return;
						
						for(var i = 0; i < dataType2.length; i++) {
							var tmpValue = OM.Comm.numToKR(dataType2[i]['sale_amt']);
							
							arr.push({
								data1: dataType2[i]['admi_nm'],
								data2: tmpValue[0],
								data3: tmpValue[1] + '원'
							})
						}
						
						trendon.linkData('leftLayoutType2', {
							dataType1: OM.Comm.numToKR(dataType1)[0],
							dataType2: arr
						}, 'layout1');
					}
				}],
				graph : null,
				map: [{
					message: '지도',
					path: '/onmap/ecnmy_trnd/getTrndMap.json',
					params: {
						ctyCd: null,
						startDate : null,
						endDate : null,
						rgnClss: null
					},
					callback: function(result, params) {
						
						var baseMap  = OM.Map.createBaseMapV1('map1-left');  // 배경지도 생성
						var colors = ['#fecec2', '#fe8e75', '#ff5c3c', '#c03c25', '#67000d'];
						
						// 지도와 연결할 데이터 가져옴
						OM.Comm.getData('/onmap/ecnmy_trnd/salamt.json', params, function(subResult) {
							
							var gradeSection = 6;  // 등급 갯수
							var layer = null;
							var style = null;
							
							// choropleth style 설정
							style = OM.Map.getChoroplethStyle(subResult['list'], {
								gradeSection: gradeSection,
								mappingKey: 'id',
								filterKey: 'sale_amt',
								style: {
									fillColor: function(index) { return colors[index];}
								}
							});
							
							layer = OM.Map.createGeojsonLayer(baseMap, result, style);  // 레이어 생성
							
							// layer 커스터마이징(마우스 이벤트 바인딩 + 범례)
							trendon.setCustomLayer(layer, subResult['list'], {
								gradeSection: gradeSection,
								title: '지역별 거래금액',
								unit: '원',
								domID: 'left-compare1',
								mappingKey: 'id',
								filterKeys: ['admi_nm', 'sale_amt'],
								colors: colors
							});
						}, '1. 거래금액-지도매핑')
					}
				}]
			},
			
			// 2. 업종별 거래금액
			{
				name: '2. 업종별 거래금액',
				data : [{
					message: '데이터',
					path: '/onmap/ecnmy_trnd/upjong_amt_list.json',
					params: {
						ctyCd : null,
						startDate : null,
						endDate : null,
						limitCnt: 3
					},
					callback: function(result) {
						
						return;
						
						var arr = [];
						var list = result['list'];
						var dataType1= list[0]['cd_nm'];
						var dataType2 = list;
						
						if(!dataType1) return;
						if(!dataType2 || dataType2.length === 0) return;
						
						for(var i = 0; i < dataType2.length; i++) {
							var tmpValue = OM.Comm.numToKR(dataType2[i]['sale_amt']);
							
							arr.push({
								data1: dataType2[i]['cd_nm'],
								data2: tmpValue[0],
								data3: tmpValue[1] + '원'
							})
						}
						
						trendon.linkData('leftLayoutType2', {
							dataType1: dataType1,
							dataType2: arr
						}, 'layout4');
					}
				}],
				graph: [{
					message: '그래프(수정안함)',
					path: '/onmap/ecnmy_trnd/ecnmy_trnd_amt_chart.json',
					params: { 
						ctyCd : null,
						startDate : null,
						endDate : null
					},
					callback: function(result) {
						var indutyTreemapData = result.indutyList;
						var iTLen = 8; 
						if(indutyTreemapData){
							var data =[];
							for(var i = 0; i < indutyTreemapData.length; i++){
								var chartData = {};
								
								chartData.color = indutyTreemapData[i].upjong1_cd;
								chartData.code = indutyTreemapData[i].upjong1_nm;
								chartData.name = indutyTreemapData[i].cd_nm;
								chartData.value = indutyTreemapData[i].sale_amt;
								chartData.id = indutyTreemapData[i].upjong2_cd;	
								
								data.push(chartData);
								
							}
							
							OM.Chart.treemap(data, {
									domId: 'left-compare2',
									chartId: 'chart1',
									background: '#f8f8f8'
								}
							);
						}
					}
				}],
				map: null
			},
			
			// 3. 지역별 유입인구 수(지도포함)
			{
				name: '3. 지역별 유입인구 수',
				data: [{
					message: '시군구 데이터',
					path: '/onmap/ecnmy_trnd/ecnmy_trnd_amt_text.json',
					params: {
						ctyCd: null,
						startDate: null,
						endDate: null,
						limitCnt: 3
					},
					callback: function(result) {
						
						return;
						var arr = [];
						var dataType1= result['amtTotal'];
						var dataType2 = result['amtRankList'];
						
						if(!dataType1) return;
						if(!dataType2 || dataType2.length === 0) return;
						
						for(var i = 0; i < dataType2.length; i++) {
							var tmpValue = OM.Comm.numToKR(dataType2[i]['sale_amt']);
							
							arr.push({
								data1: dataType2[i]['admi_nm'],
								data2: tmpValue[0],
								data3: tmpValue[1] + '원'
							})
						}
						
						trendon.linkData('leftLayoutType2', {
							dataType1: OM.Comm.numToKR(dataType1)[0],
							dataType2: arr
						}, 'layout1');
					}
				}],
				graph : null,
				map: [{
					message: '지도',
					path: '/onmap/ecnmy_trnd/getTrndMap.json',
					params: {
						ctyCd: null,
						startDate : null,
						endDate : null,
						rgnClss: null
					},
					callback: function(result, params) {
						
						var baseMap  = OM.Map.createBaseMapV1('map2-left');  // 배경지도 생성
						var colors = ['#fecec2', '#fe8e75', '#ff5c3c', '#c03c25', '#67000d'];
						
						// 지도와 연결할 데이터 가져옴
						OM.Comm.getData('/onmap/ecnmy_trnd/salamt.json', params, function(subResult) {
							
							var gradeSection = 6;  // 등급 갯수
							var layer = null;
							var style = null;
							
							// choropleth style 설정
							style = OM.Map.getChoroplethStyle(subResult['list'], {
								gradeSection: gradeSection,
								mappingKey: 'id',
								filterKey: 'sale_amt',
								style: {
									fillColor: function(index) { return colors[index];}
								}
							});
							
							layer = OM.Map.createGeojsonLayer(baseMap, result, style);  // 레이어 생성
							
							// layer 커스터마이징(마우스 이벤트 바인딩 + 범례)
							trendon.setCustomLayer(layer, subResult['list'], {
								gradeSection: gradeSection,
								title: '지역별 거래금액',
								unit: '원',
								domID: 'left-compare3',
								mappingKey: 'id',
								filterKeys: ['admi_nm', 'sale_amt'],
								colors: colors
							});
						}, '3. 지역별 유입인구 수-지도매핑')
					}
				}]
			},
			
			// 4. 성/연령별 대표 유입인구
			null,
			
			// 5. 유입인구 소비(지도)
			{
				name: '5. 유입인구 소비',
				data: [{
					message: '시군구 데이터',
					path: '/onmap/ecnmy_trnd/ecnmy_trnd_amt_text.json',
					params: {
						ctyCd: null,
						startDate: null,
						endDate: null,
						limitCnt: 3
					},
					callback: function(result) {
						
						return;
						var arr = [];
						var dataType1= result['amtTotal'];
						var dataType2 = result['amtRankList'];
						
						if(!dataType1) return;
						if(!dataType2 || dataType2.length === 0) return;
						
						for(var i = 0; i < dataType2.length; i++) {
							var tmpValue = OM.Comm.numToKR(dataType2[i]['sale_amt']);
							
							arr.push({
								data1: dataType2[i]['admi_nm'],
								data2: tmpValue[0],
								data3: tmpValue[1] + '원'
							})
						}
						
						trendon.linkData('leftLayoutType2', {
							dataType1: OM.Comm.numToKR(dataType1)[0],
							dataType2: arr
						}, 'layout1');
					}
				}],
				graph : null,
				map: [{
					message: '지도',
					path: '/onmap/ecnmy_trnd/getTrndMap.json',
					params: {
						ctyCd: null,
						startDate : null,
						endDate : null,
						rgnClss: null
					},
					callback: function(result, params) {
						
						var baseMap  = OM.Map.createBaseMapV1('map3-left');  // 배경지도 생성
						var colors = ['#fecec2', '#fe8e75', '#ff5c3c', '#c03c25', '#67000d'];
						
						// 지도와 연결할 데이터 가져옴
						OM.Comm.getData('/onmap/ecnmy_trnd/salamt.json', params, function(subResult) {
							
							var gradeSection = 6;  // 등급 갯수
							var layer = null;
							var style = null;
							
							// choropleth style 설정
							style = OM.Map.getChoroplethStyle(subResult['list'], {
								gradeSection: gradeSection,
								mappingKey: 'id',
								filterKey: 'sale_amt',
								style: {
									fillColor: function(index) { return colors[index];}
								}
							});
							
							layer = OM.Map.createGeojsonLayer(baseMap, result, style);  // 레이어 생성
							
							// layer 커스터마이징(마우스 이벤트 바인딩 + 범례)
							trendon.setCustomLayer(layer, subResult['list'], {
								gradeSection: gradeSection,
								title: '지역별 거래금액',
								unit: '원',
								domID: 'left-compare5',
								mappingKey: 'id',
								filterKeys: ['admi_nm', 'sale_amt'],
								colors: colors
							});
						}, '5. 유입인구 소비-지도매핑')
					}
				}]
			},
			
			// 6. 업종별 유입인구 소비특성
			{
				name: '6. 업종별 유입인구 소비특성',
				data: [{
					message: '데이터',
					path: '/onmap/ecnmy_trnd/ecnmy_trnd_expndtr_chart.json',
					params: {
						ctyCd: null,
						startDate: null,
						endDate: null
					},
					callback: function(result) {
						
						return;
						
						var activeSector = result['mostCommonList'][0]; // 활성업종 1위
						var specialSector = result['mostSpecializedList'][0]; // 특화업종 1위
						var dataType1 = [activeSector['cd_nm'], OM.Comm.numToKR(activeSector['sale_amt'])[0]].join(' '); // 주요 방문시간
						var dataType2 = [specialSector['cd_nm'], specialSector['rate']].join(' '); // 주요 방문시간
						
						if(!dataType1) return;
						if(!dataType2) return;
						
						trendon.linkData('leftLayoutType1', {
							dataType1: dataType1,
							dataType2: dataType2,
						}, 'layout8');
					}
				}],
				graph: [{
					message: '그래프(수정안함)',
					path: '/onmap/ecnmy_trnd/ecnmy_trnd_expndtr_chart.json',
					params: {
						ctyCd: null,
						startDate: null,
						endDate: null
					},
					callback: function(result) {
						
						var mostCommonData = result.mostCommonList;
						var mostSpecializedData = result.mostSpecializedList;
						
						if(mostCommonData){
							var data =[];
							for(var i = 0; i < mostCommonData.length; i++){
								var chartData = {};
								chartData.name = mostCommonData[i].cd_nm;
								chartData.value = mostCommonData[i].sale_amt;
								chartData.y = i+1;
								chartData.hex = '#fe8d75';
								
								data.push(chartData);
							}
							
							OM.Chart.horizontalBar(data, {
								domId: 'left-compare6',
								chartId: 'chart1',
								label: {
									x:"소비 금액",
									y:"업종"
								},
								unit: {"form":"won","length":8},
								background: '#f8f8f8'
							});
						}
						
						if(mostSpecializedData){
							var data =[];
							for(var i = 0; i < mostSpecializedData.length; i++){
								var chartData = {};
								chartData.name = mostSpecializedData[i].cd_nm;
								chartData.value = mostSpecializedData[i].rate;
								chartData.y = i+1;
								chartData.hex = '#fe8d75';
								
								data.push(chartData);
							}
							
							OM.Chart.horizontalBar(data, {
								domId: 'left-compare6',
								chartId: 'chart2',
								label: {
									x:"소비 특화지수",
									y:"업종"
								},
								unit: {"form":"index","length":0},
								background: '#f8f8f8'
							});
						}
					}
				}],
				map: null
			},
			
			// 7. 유입인구 소비시간 
			// 8. 유입인구 유입지역(지도)
		]
		
		return index === -1 ? configs : [configs[index]];
	}
}