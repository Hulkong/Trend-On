/**
 * @description 트렌드온 전용 라이브러리 
 * @descriptor 김용현
 * @date 2020.08.19
 */
if(!trendon) var trendon= {};

trendon = (function() {
	$("#fullpage").fullpage({
		anchors: ["firstPage", "secondPage", "thirdPage"],
		//Scrolling
		autoScrolling: false,
		fitToSection: false,
		easing: "easeInOutCubic",
		afterLoad: function(anchorLink, index){
            if(   window.anchorLinkCallBack  ){
            	window.anchorLinkCallBack(anchorLink, index);
            }
		}
	});
	
	return {
		
		// event to click date button 
		openDate: function(pageNm) {
			
			// 레이어 닫음
			if($('._btn._date').hasClass('on')) {
				$('._btn._date').removeClass('on');
				$(".layer_period").fadeOut();
			// 레이어 열음
			} else {
				$('._btn._date').addClass('on');
				$(".layer_period").fadeIn();  // 팝업 open
				if(pageNm !== undefined && pageNm == 'trendon') trendon.trnd.setAllWithDate();
			}
		},
		
		/*
		 * @description 기간직접입력 -> 선택 버튼 클릭
		 */
		clickTimeserires: function(type) { 
			
			switch(type) {
				case 'all':
					all();
					break;
				case 'type1':
					type1();
					break;
				case 'type2':
					type2();
					break;
				default:
					console.log('not to match type');
			}
			
			// 전체보기
			function all() {
				
				$('._btn._card').removeClass('active');
				$('._btn._pop').removeClass('active');
				
//				if($('._btn._allview').hasClass('active')) {
//					
//					$('._btn._allview').removeClass('active');
//					$('#layout0 .line.type1').css('visibility', 'hidden');
//					$('#layout0 .line.type2').css('visibility', 'hidden');
//					
//				} 
				
				$('._btn._allview').addClass('active');
				$('#layout0 .line.type1').css('display', 'block');
				$('#layout0 .line.type2').css('display', 'block');
				$('#rangeChart .left').css('display', 'block');
				$('#rangeChart .right').css('display', 'block');
				$('#rangeChart .left line').css('stroke', '#cccccc');
				$('#rangeChart .right line').css('stroke', 'none');
				
			}
			
			// 카드소비
			function type1() {
				$('._btn._allview').removeClass('active');
				$('._btn._pop').removeClass('active');
				
//				if($('._btn._card').hasClass('active')) {
//					$('._btn._card').removeClass('active');
//					$('#layout0 .line.type1').css('visibility', 'hidden');
//				} 
				
				$('._btn._card').addClass('active');
				$('#layout0 .line.type1').css('display', 'block');
				$('#layout0 .line.type2').css('display', 'none');
				$('#rangeChart .left').css('display', 'block');
				$('#rangeChart .right').css('display', 'none');
				$('#rangeChart .left line').css('stroke', '#cccccc');
				$('#rangeChart .right line').css('stroke', 'none');
			}
			
			// 유동인구
			function type2() {
				$('._btn._allview').removeClass('active');
				$('._btn._card').removeClass('active');
				
//				if($('._btn._pop').hasClass('active')) {
//					$('._btn._pop').removeClass('active');
//					$('#layout0 .line.type2').css('visibility', 'hidden');
//				} 
				
				$('._btn._pop').addClass('active');
				$('#layout0 .line.type2').css('display', 'block');
				$('#layout0 .line.type1').css('display', 'none');
				$('#rangeChart .left').css('display', 'none');
				$('#rangeChart .right').css('display', 'block');
				$('#rangeChart .left line').css('stroke', 'none');
				$('#rangeChart .right line').css('stroke', '#cccccc');
			}
			
		},
		
		/**
		 * @description 데이터 정제
		 * @params {String} name 이름
		 * @params {Array or Object} data 정제할 데이터
		 */
		clean: function(name, data, options) {
			if(!name) return;
			
			switch(name) {
				case 'grouped-bar':
					return groupedBar(data, options);
					break;
				case 'line-grouped-bar':
					return lineGroupedBar(data, options);
					break;
				case 'treemap':
					treemap(data, options);
					break;
				case 'horizontal-bar':
					return horizontalBar(data, options);
					break;
				case 'multi-line':
					return multiLine(data, options);
					break;
				case 'timeseries':
					return timeseries(data, options);
					break;
				default:
					console.log('not to match graph')
			}
			
			// 그룹 막대 그래프
			function groupedBar(data, options) {
				
				var cleanData = [];
				var keys = Object.keys(data);
				
				// 정제 버전1
				if(options['cleanVersion'] === '1') {
					
					options.sorts.map(function(key, index) {

						var group = options.groups[Math.floor(index / 2)];
						var column = index % 2 === 0 ? options.columns[0] : options.columns[1];
						var color = index % 2 === 0 ? options.colors[0] : options.colors[1];
						var value = data[key] ? data[key] : 0;
						
						cleanData.push({
							group: group,
							column: column,
							value: value,
							sortCd: index,
							tooltip: {
								title: [options['title'], column].join(' '),
								color: color,
								data: [{
									name: 'value',
									value: options.format(value).join('') + options['unit'],
									color: null
								}]
							}
						})
					});
				} 
				
				// 정제 버전2
				if(options['cleanVersion'] === '2') {
					data.map(function(item) {
						var groupKey = item[options.groupKey];
						var groupIdx = options.keys.indexOf(groupKey);
						var group = options.groups[groupIdx];
						var value1 = item[options.valueKeys[0]] ? item[options.valueKeys[0]] : 0;
						var value2 = item[options.valueKeys[1]] ? item[options.valueKeys[1]] : 0;
						
						// 방문시간
						cleanData.push({
							group: group,
							column: options.columns[0],
							value: value1,
							sortCd: (groupIdx * 2),
							tooltip: {
								title: options.columns[0],
								color: options.colors[0],
								data: [{
									name: 'value',
									value: options.format(value1) + options['unit'],
									color: null
								}]
							}
						})
						
						// 소비시간
						cleanData.push({
							group: group,
							column: options.columns[1],
							value: value2,
							sortCd: (groupIdx * 2) + 1,
							tooltip: {
								title: options.columns[1],
								color: options.colors[1],
								data: [{
									name: 'value',
									value: options.format(value2) + options['unit'],
									color: null
								}]
							}
						})
					});
				}
				
				OM.Comm.sortObject(cleanData, 'asc', 'sortCd');
				
				return cleanData;
			};
			
			// 선 + 그룹 막대 그래프
			function lineGroupedBar(data, options) {
				var barData = [];
				var lineData = [];

				var data1 = data.filter(function(item, index){ return item['loc_clss_cd'] === 'A' });  // 총합 
				var data2 = data.filter(function(item, index){ return item['loc_clss_cd'] === 'E' });   // 유입인구
				var data3 = data.filter(function(item, index){ return item['loc_clss_cd'] === 'R' });   // 상주인구
				
				options.dates.map(function(date, index) {
					
					var filterVal1 = data.filter(function(item, index){ 
						return item['stdr_ym'] === date && item['loc_clss_cd'] === 'A'; 
					})[0];
					
					var filterVal2 = data.filter(function(item, index){ 
						return item['stdr_ym'] === date && item['loc_clss_cd'] === 'E'; 
					})[0];
					
					var filterVal3 = data.filter(function(item, index){ 
						return item['stdr_ym'] === date && item['loc_clss_cd'] === 'R'; 
					})[0];
					
					var value1 = filterVal1 && filterVal1[options.dataKey] ? filterVal1[options.dataKey] : 0;
					var value2 = filterVal2 && filterVal2[options.dataKey] ? filterVal2[options.dataKey] : 0;
					var value3 = filterVal3 && filterVal3[options.dataKey] ? filterVal3[options.dataKey] : 0;
					
					
					
					// 상주인구
					barData.push({
						group: date,
						column: options.texts[0],
						value: value3,
						sortCd: (index * 2),
						tooltip: {
							title: options.texts[0],
							color: options.colors[0],
							data: [{
								name: 'value',
								value: OM.Comm.numToKR(value3).join('') + options['unit'],
								color: null
							}],
						}
					});
					
					// 유입인구
					barData.push({
						group: date,
						column: options.texts[1],
						value: value2,
						sortCd: (index * 2) + 1,
						tooltip: {
							title: options.texts[1],
							color: options.colors[1],
							data: [{
								name: 'value',
								value: OM.Comm.numToKR(value2).join('') + options['unit'],
								color: null
							}],
						}
					});
					
					
					// 총 인구
					lineData.push({
						group: date,
						column: 'A',
						value: value1,
						sortCd: null,
						tooltip: {
							title: options.texts[2],
							color: options.colors[2],
							data: [{
								name: 'value',
								value: OM.Comm.numToKR(value1).join('') + options['unit'],
								color: null
							}],
						}
					});
				});
				
				OM.Comm.sortObject(barData, 'asc', 'sortCd');
				
				return {
					lineData: lineData,
					barData: barData
				}
			};
			
			function treemap() {};
			
			// 수평 막대 그래프
			function horizontalBar(data, options) {
				return data.map(function(item, index) {
					return {
						name: item[options.name],
						value: item[options['value']],
						y: index + 1,
						hex: options['color']
					};
				});
			}
			
			// 다중 선 그래프
			function multiLine(data, options) {
				var data1 = data[0];
				var data2 = data[1];
				var cleanData = [];
				var xAxis = ["3주전", "2주전", "1주전", "이벤트기간", "1주후", "2주후"];
				
				xAxis.map(function(x, index) {
					
					var chartData = {};
					chartData.name = "선택기간";
					chartData.value = data1["law" + (index + 1)] ? data1["law" + (index + 1)] : 0;
					chartData.date = x;
					chartData.order = (index + 1);
					
					cleanData.push(chartData);
					
					if(chartData.value === 0) return;
					
					var valueLen = Math.floor(1e-12 + Math.log(chartData.value) / Math.LN10);
					if(options.attributes[0].length > valueLen) options.attributes[0].length = valueLen;
					if(options.attributes[1].length > valueLen) options.attributes[1].length = valueLen;
				});
				
				xAxis.map(function(x, index) {
					
					var chartData = {};
					chartData.name = "비교기간";
					chartData.value = data2["law" + (index + 1)] ? data2["law" + (index + 1)] : 0;
					chartData.date = x;
					chartData.order = (index + 1);
					
					cleanData.push(chartData);
					
					if(chartData.value === 0) return;
					
					var valueLen = Math.floor(1e-12 + Math.log(chartData.value) / Math.LN10);
					if(options.attributes[0].length > valueLen) options.attributes[0].length = valueLen;
					if(options.attributes[1].length > valueLen) options.attributes[1].length = valueLen;
				});
				
				return cleanData;
			};
			
			// 시계열 그래프
			function timeseries(data, options) {
				var lineData1 = [];
				var lineData2 = [];
				
				data.data.map(function(item) {
					
					var obj = {
						date:  new Date(OM.Date.getArr(item['stdr_date']).join('-')),
						value: item['sale_amt'] ? item['sale_amt'] : 0
					};
				
					lineData1.push(obj)
				})
				
				data.data2.map(function(item) {
					var obj ={
						date:  new Date(OM.Date.getArr(item['stdr_date']).join('-')),
						value: item['total_cnt'] ? item['total_cnt'] : 0
					};
					
					lineData2.push(obj)
				})
				
				return [lineData1, lineData2];
			}
		},
		
		/**
		 * @description 그래프 / 지도 렌더링
		 */
		draw: function(name, data, options) {
			
			if(!name) return;
			
			var fn = this;
			
			switch(name) {
				case 'grouped-bar':
					return groupedBar(name, data, options);
					break;
				case 'line-grouped-bar':
					return lineGroupedBar(name, data, options);
					break;
				case 'treemap':
					treemap();
					break;
				case 'horizontal-bar':
					return horizontalBar(name, data, options);
					break;
				case 'multi-line':
					return multiLine(name, data, options);
					break;
				case 'timeseries':
					return timeseries(name, data, options);
					break;
				case 'map':
					return map(data, options);
					break;
				default:
					console.log('not to match graph')
			}
			
			/**
			 * 시군구현황 - 성/연령별 대표인구(카드사, 통신사): {list:{}}
			 * 경제트렌드 - 성/연령별 대표인구(카드사, 통신사): {list:{}}
			 * 경제트렌드 - 유입인구 성/연령 특성(카드사, 통신사): {list:{}} 
			 * 경제트렌드 - 유입인구 시간대 특성: {list: []}  
			 * 이벤트효과 - 성/연령별 대표인구(카드사, 통신사): {list: {}}  
			 * 이벤트효과 - 유입인구 성/연령별 특성(카드사, 통신사): {list: []}  
			 * 이벤트효과 - 유입인구 시간대 특성: {list: []}  
			 */
			function groupedBar(name, data, options) {

				var domId = options['domId'];
				var chartId = options['chartId'];
				
				if(!domId || !chartId) {
					console.log('not domId or chartId');
					return;
				}
				
				if(!data) {
		    		trendon.noData.show(domId, chartId);
		    		return;
		    	}
				
				options = $.extend({}, {
					groups:  [],
					title: '',
					colors: [],
					columns: [],
					images: [],
					tooltips: [],
					unit: '',
					format: function(d) { return [d.toFixed(1)]; },
					cleanVersion: '1',
					legendType: 'image',
					margin: {
						top: 40,
						right: 0,
						bottom: 85,
						left: 50
					},
					barWidth: 27
				}, options);
				
				var cleanData = fn.clean(name, data, options);
				
				// 범례 툴팁 데이터 설정
				options.columns.map(function(column, i) {
					var sum = cleanData.filter(function(item) {
						return item['column'] === column;
					}).reduce(function(acc, v, i) {
						return acc + v['value'];
					}, 0);
					
					 options.tooltips.push({
						 title: column,
						 color: options.colors[i],
						 data: [{
							 name: 'value',
							 value: options.format(sum) + options['unit'],
							 color: null
						 }]
					 });
				});
				
				OM.Chart.groupedBarV1(cleanData, {
					legend: {
						type: options['legendType'],
						data: [0, 1].map(function(d) {
							return {
								text: options['legendType'] === 'image' ? null : options.columns[d],
								icon: options.images[d],
								column: options.columns[d],
								color: options.colors[d],
								tooltip: options.tooltips[d]
							}
						})
					},
					title: options['title'],
					domId: options['domId'],
					chartId: options['chartId'],
					tickFormat:  function(d) { return options.format(d) + options['unit']; },
					ticks: 7,
					colors: options['colors'],
					margin: options['margin'],
					barWidth: options['barWidth']
				});
			};
			
			// 시군구현황 - 거래금액 + 유동인구
			function lineGroupedBar(name, data, options) {
				
				var domId = options['domId'];
				var chartId = options['chartId'];
				
				if(!domId || !chartId) {
					console.log('not domId or chartId');
					return;
				}
				
				options = $.extend({}, {
					title: '거래금액',
					texts: ['상주 거래금액', '유입 거래금액', '총 거래금액'],
					colors: ['#d3d3d3', '#fe8d75', '#ff0000'],
					tooltips: [],
					unit: '원',
					dataKey: null,
					yFormat: null,
					barWidth: 27
				}, options);
				
				var cleanData = fn.clean(name, data, options);
				var barData = cleanData['barData'];
				var lineData = cleanData['lineData'];
				var chart = new OM.Chart.groupedBarLine();
				
				options.texts.map(function(text, i) {
					var sum = barData.filter(function(item) {
						return item['column'] === text;
					}).reduce(function(acc, v, i) {
						return acc + v['value'];
					}, 0)
					
					 options.tooltips.push({
						 title: text,
						 color: options.colors[i],
						 data: [{
							name: 'value',
							value: OM.Comm.numToKR(sum).join('') + options['unit'],
							color: null
						}]
					 });
				})
				
				chart.draw({
					bar_data: barData,
					line_data: lineData
				}, {
					legend: {
						type: 'text',
						data: [0, 1].map(function(d) {
							return {
								text: options.texts[d],
								icon: null,
								column: options.texts[d],
								color: options.colors[d],
								tooltip: options.tooltips[d]
							}
						})
					},
					title: options['title'],
					domId: domId,
					chartId: chartId,
					xFormat: options['xFormat'],
					yFormat: options['yFormat'],
					ticks: 7,
					colors: options['colors'],
					margin: options['margin'],
					selectValue: trendon.status.dateYm,
					barWidth: options['barWidth']
				});
				
				return chart
			};
		
			function treemap() {}
			
			function horizontalBar(name, data, options) {
				var domId = options['domId'];
				var chartId = options['chartId'];
				
				if(!domId || !chartId) {
					console.log('not domId or chartId');
					return;
				}
				
				if(!data || data.length === 0) {
					trendon.noData.show(domId, chartId);
					return;
				}
				
				options = $.extend({}, {
					name: null,
					value: null,
					color: '#ff0000',
					x: '',
					y: '',
					background: '#f8f8f8',
					format: function(value) { return value; }
				}, options);
				
				var cleanData = fn.clean(name, data, options);
				
				OM.Chart.horizontalBar(cleanData, {
					domId: domId,
					chartId: chartId,
					label: {
						x: options['x'],
						y: options['y']
					},
					format: options['format'],
					background: options['background']
				});
			}
			
			function multiLine(name, data, options) {
				
				var domId = options['domId'];
				var chartId = options['chartId'];
				
				if(!domId || !chartId) {
					console.log('not domId or chartId');
					return;
				}
		    	
		    	if(!data[0] || !data[1]) {
		    		trendon.noData.show(domId, chartId);
					return;
		    	}
		    	
		    	var check = false;
		    	
		    	Object.keys(data[0]).map(function(v) {
		    		if(data[0][v] !== 0) check = true;
		    	});
		    	
		    	Object.keys(data[1]).map(function(v) {
		    		if(data[0][v] !== 0) check = true;
		    	});
		    	
		    	
		    	if(!check) {
		    		trendon.noData.show(domId, chartId);
					return;
		    	}

				options = $.extend({}, {
					attributes: [],
					label: null,
					background: '#ffffff',
					unit: null
				}, options);
				
				var cleanData = fn.clean(name, data, options);
				
				OM.Chart.multiLine(cleanData, {
					domId: domId,
					chartId: chartId,
					label: options['label'],
					attributes: options['attributes'],
					background: options['background']
				})
			}
			
			// 시계열 그래프
			function timeseries(name, data, options) {
				var domId = options['domId'];
				var chartId = options['chartId'];
				
				if(!domId || !chartId) {
					console.log('not domId or chartId');
					return;
				}
				
				if(data.data.length === 0) {
					trendon.noData.show(domId, chartId);
		    		return;
				};
				
				options = $.extend({}, {
					maxDate: new Date(),
					maxDate: new Date(),
					title: []
				}, options);
				
				var cleanData = fn.clean('timeseries', data, options)
				var graph = new OM.Chart.Timeseries({
					domId: "#rangeChart", 
					lineData: cleanData,
					margin: {
						top: 0, 
						right: 60, 
						bottom: 20, 
						left: 60
					},
					tLength: 20, 
					xFormat: d3.time.format("%y/%m/%d"),
					yFormat: function(d) { return OM.Comm.numToKR(d).join('')},
					defaultVal: options['defaultValue'],
					timeHandler: options['callback'],
					startDate: options['minDate'],
					endDate: options['maxDate'],
					title: options['title'],
					standards: options['standards']
				});
				graph.draw();
				
				return graph;
			}
			
			function map(mapData, options) {
				
				var domId = options['domId'];
				var mapId = options['mapId'];
				
				if(!domId || !mapId) {
					console.log('not domId or mapId');
					return;
				}
				
				options = $.extend({}, {
					id: 'id',
					title: '',
					unit: '',
					nmKey: 'nm',
					valueKey: null,
					subMsg: '지도매핑',
					callback: {
						moveend: function() {},
						mouseout: function() {},
						style: function() {},
						onEachFeature: function() {},
//						fitBounds: function() {}
					},
					limitMinZoom: false,
					tileMap: true,
				}, options);
				
				// 지도와 연결할 데이터 가져옴
				OM.Comm.getData(
					options['url'], 
					options['params'], 
					{
						beforeSend: function() {
							trendon.noData.hide(domId, 'map');
						},
						complete: function() {
							trendon.closeLoading(domId, 'map');
						},
						success: function(subResult) {
							
							var data = subResult['list'];
							
							if(!data || data.length === 0) {
					    		trendon.noData.show(domId, 'map');
					    		return;
					    	}
							
							var cleanData = [];
							var gradeSection = 6;  // 등급 갯수
							var layer = null;
							var style = null;
							var baseMap  = null;  // 배경지도 생성 
							var layer = null;
							
							if(OM.Map.checkBaseMap(mapId)) {
								baseMap = OM.Map.getBaseMap(mapId);
							} else {
								baseMap  = OM.Map.createBaseMap(mapId, { tileMap: options['tileMap'] });  // 배경지도 생성
							}
							
							OM.Map.zoom.min.active(baseMap);
							
							// choropleth 설정을 위한 데이터 정제
							data.map(function(item) {
								cleanData.push({
									id: item[options.id],  // 지도 매핑키 
									value: item[options.valueKey], // 지도색상 매핑키
									nm: item[options.nmKey]
								})
							});
							
							OM.Comm.sortObject(cleanData, 'desc', 'value');
							
							// choropleth style 설정
							style = OM.Map.getChoroplethStyle(cleanData, {
								gradeSection: gradeSection,
								mappingKey: 'id',  // 지도 매핑키
								style: {
									fillColor: function(index) { 
										
										if(index == null) return options.defaultColor;
										if(cleanData.length < 4) return options.colors(cleanData.length -1)[index];
										else return options.colors(4)[index];
										
									}
								},
								callback: options.callback['style']
							});
							
							// 기존 레이어가 있을 경우 스타일 업데이트
							if(OM.Map.checkLayer(mapId, baseMap)) {
								layer = OM.Map.getLayer(mapId, baseMap);
								layer.setStyle(style);
								
							// 기존 레이어가 없을 경우 레이어 생성	
							} else {
								layer = OM.Map.createGeojsonLayer(baseMap, mapData, {
									style: style,
									onEachFeature: options.callback['onEachFeature']
								});
							}
							
							// layer 커스터마이징(마우스 이벤트 바인딩 + 범례)
							trendon.setCustomLayer(layer, cleanData, {
								gradeSection: gradeSection,  // 등급 갯수
								title: options['title'], // 팝업 및 범례 제목
								unit: options['unit'],  // 팝업에 표현될 단위
								domID: domId,  // 연결시킬 엘리먼트 id
								mappingKey: 'id',  //  지도 매핑키 
								colors: options['colors'](4),  // 범례색상
								callback: options['callback']
							});
							
							setTimeout(function() {
								OM.Map.zoom.min.inActive(baseMap);
							}, 300);
						}
					},
					options['subMsg']
				);
			}
		},
		
		/**
		 * @description 공통 레이아웃 데이터 바인딩
		 */
		layout: {
			bind: {
				type1: function(result, keys, unit, domId) {
					
					var data1 = result[keys[0]];
					var data2 = result[keys[1]];
					var arr = [];
					
					if(!unit) unit = ''; 
					
					trendon.linkData('leftLayoutType1', {
						dataType1: data1 ? data1 : '-'
					}, domId);
					
					if(!data2 || data2.length === 0) {
						trendon.noData.show(domId, 'dataTable');
						return;
					} 
					
					data2.map(function(item) {
						var tmpValue = OM.Comm.numToKR(item[keys[2]]);
						
						arr.push({
							data1: item[keys[3]],
							data2: tmpValue[0],
							data3: tmpValue[1] + unit
						})
					});
					
					trendon.linkData('leftLayoutType2', arr, domId);
				}
			}
		},
		
		/**
		 * @description 데이터가 없을 경우의 레이아웃
		 */
		noData : {
			
			html: '<p class="no-data">데이터 없음</p>',
			style: {
				get: function() {
					return [
						'text-align: center;',
					    'vertical-align: middle;',
					    'display: inline-block;',
					    'width: 100%;',
					    'background: #D3D3D3;',
					    'color: #000;',
					    'z-index: 2;',
					    'position: relative;'
				    ]
				}
			},

			make: function(container) {
				var height = container.clientHeight;
				var style = this.style.get();
				style.push('line-height:' + height + 'px;');
				
				container.innerHTML = this.html;
				
				var target =  container.getElementsByClassName('no-data')[0];
				
				target.style.cssText = style.join('');
			},
			
			// 추후 classToApply타입 중 array도 받도록 변경
			show : function(domId, classToApply) {
				
				var container = document.getElementById(domId);
				
				if(!container) return;
				
				var subContainer = container.getElementsByClassName(classToApply)[0];
				
				if(!subContainer) return;
				
				var target = subContainer.getElementsByClassName('no-data')[0];
				
				if(!target) {
					this.make(subContainer);
				} else {
					target.classList.remove('hidden');
				}
			},
			
			hide : function(domId, classToApply) {
				var container = document.getElementById(domId);
				
				if(!container) return;
				
				var subContainer = container.getElementsByClassName(classToApply)[0];
				
				if(!subContainer) return;
				
				var target = subContainer.getElementsByClassName('no-data')[0];
				
				if(!target) return;
				
				target.classList.add('hidden');
			}
		},
		
		openLoading: function(domId, classToApply) {
			var container = document.getElementById(domId);
			
			if(!container) return;
			
			var spinner = container.getElementsByClassName(classToApply)[0];
			
			if(!spinner) return;
			if(spinner.className.indexOf('spinner') >= 0) return;
			
			spinner.classList.add('spinner');
		},
		
		closeLoading: function(domId, classToApply) {
			var container = document.getElementById(domId);
			
			if(!container) return;
			
			var spinner = container.getElementsByClassName(classToApply)[0];
			
			if(!spinner) return;
			
			spinner.classList.remove('spinner');
		},
		
		/**
		 * @description 콤보박스 마우스엔터 이벤트
		 */
		mouseenterComboBox: function(domId) {
			var comboBox = $(domId).find('.combo-box');
			comboBox.addClass('on').css('display', 'block');
		},
		
		/**
		 * @description 콤보박스 마우스리브 이벤트
		 */
		mouseleaveComboBox: function(domId) {
			var comboBox = $(domId).find('.combo-box');
			comboBox.removeClass('on').css('display', 'none');
		},
		
		/**
		 * @description 콤보박스 클릭
		 * @param event
		 * @returns
		 */
		clickComboBox: function(domId) {
			var comboBox = $(domId).find('.combo-box');
			
			if(comboBox.hasClass('on')) {
				comboBox.removeClass('on').css('display', 'none');
			} else {
				comboBox.addClass('on').css('display', 'block');
			}
		},
		
		callAPI: function(configs, setParameter, requestKeys) {
			
			if(!Array.isArray(requestKeys) || requestKeys.length === 0) {
				requestKeys = ['data', 'graph', 'map']; // 실제 서버에 요청할 키값들(횟수)
			}
			
			if(!Array.isArray(configs) || configs.length === 0) return;
			
			configs.reduce(function(acc, v, i) {
				
				if(!v) return;
				
				requestKeys.map(function(key) {
					
					if(!v[key] || v[key].length === 0) return;
					
					var realKeys =  Array.isArray(v[key]) ? v[key] : [v[key]] ;
					
					realKeys.map(function(data) {
						var path = data['path'];
						var params = setParameter(data['params']);
						var title = v['name'];
						var message = data['message'];
						var callback = {
							success: data['callback'](),
							beforeSend: null,
							complete: null
						};
						var consoleMsg = [
							[title, message].join('-'), 
							false
						]
						
						// 그래프 속성값일 경우
						if(key === 'graph') {
							callback['beforeSend'] = function() {
								var chartIds = data['chartId'];
								if(!Array.isArray(chartIds)) chartIds = [data['chartId']];
								
								chartIds.map(function(chartId) {
									trendon.openLoading(data['domId'], chartId);
									trendon.noData.hide(data['domId'], chartId);
								});
							}
							
							callback['complete'] = function() {
								var chartIds = data['chartId'];
								if(!Array.isArray(chartIds)) chartIds = [data['chartId']];
								
								chartIds.map(function(chartId) {
									trendon.closeLoading(data['domId'], chartId);
								});
							} 
						}
						
						// 지도 속성값일 경우
						if(key === 'map') {
							
							callback['beforeSend'] = function() {
								trendon.openLoading(data['domId'], 'map');
								trendon.noData.hide(data['domId'], 'map');
							}
						}
						
						OM.Comm.getData(path, params, callback, consoleMsg);
					});
				});
			}, []);
		},
		
		/**
		 * @description 
		 * @param layer
		 * @param data
		 * @param options
		 * @returns
		 */
		setCustomLayer: function(layer, data, options) {
			
			if(!layer) return;
			if(!data || data.length === 0) return;
			
			var title = options['title'];
			var unit = options['unit'];
			var domID = options['domID'];
			var gradeSection = options['gradeSection'];
			var mappingKey = options['mappingKey'];
			var mouseout = options.callback['mouseout'];
			
			if(!title) return;
			if(!unit) return;
			if(!domID) return;
			if(!gradeSection) return;
			if(!mappingKey) return;
			
			// connect to mouseout event 
			OM.Map.mouseoutOfLayer(layer, function(e) {
				layer.closePopup();
//				layer.resetStyle(e.layer);
				
				layer.setStyle({
					color: '#d3d3d3',
					weight : 1
				});
				e.layer.bringToBack();
				mouseout(layer);
			});
			
			// connect to mouseover event
			OM.Map.mouseoverOfLayer(layer, function(e) {
				var properties = e.layer.feature.properties;
				var id = properties[mappingKey];
				var filterVal = data.filter(function(item) {
					return item[mappingKey] === id;
				})[0];
				
				var tooltipNm = properties['nm']; 
				var tooltipVal = '-' + unit;
				var tempVal = null;
				var koreaVal = null;
				
				if(filterVal) {
					tooltipNm = filterVal['nm']; 
					tempVal = filterVal['value'];
					koreaVal = OM.Comm.numToKR(tempVal);
					
					if(unit !== '%' && koreaVal[0] <= 100) tooltipVal = '100명 이하';
					else tooltipVal = koreaVal[0] + koreaVal[1] + unit;
				} 
				
				var tooltip = {
					title: {
							value: title,
							color: '#333'
					},
					data: [{
							name: tooltipNm,
							value: tooltipVal
					}]
				};
				
				var html = OM.Map.getMapTooltip(tooltip);
				
				layer.setPopupContent(html);
				layer.openPopup(e.latlng);
				
				e.layer.setStyle({
					weight: 5,
					color: '#2B83BA',
					dashArray: '1'
				});

				e.layer.bringToFront();					
			});
			
			// 범례 생성
			OM.Map.createLegend(
				domID, 
				options['colors'] ? options['colors'] : getMapColor([gradeSection - 2]), 
				[1, 2, 3, 4, 5],
				title
			);
		},
		
		/**
		 * 맨 위의 시간에 따른 소비인구 변화 그래프 
		 **/
		setTimeGraph: function(){
			//그래프 네비게이션 시작
			$.ajax({
				url : '/onmap/ecnmy_trnd/graph_data.json',
				data:{
					"ctyCd" : ecnmy_trnd_config.sessionCtyCd,
					"periodMon" : 24,
					"min_date":ecnmy_trnd_config.limitStartDate,
					"max_date":ecnmy_trnd_config.limitEndDate,
					"serviceClss" : ecnmy_trnd_config.sessionTypeCd
				},
				success: function(result, status) {
					if(result.data){
						ecnmy_trnd_config.limitStartDate = result.data[0].stdr_date;
						ecnmy_trnd_config.limitEndDate = result.data[result.data.length-1].stdr_date;
					
						var margin = {top: 0, right: 10, bottom: 20, left: 60};

						for(var i = 0 ;i<result.data.length;i++){
							var item = result.data[i];
							item.date = yyyymmddToDate(item.stdr_date);
						}
						bDate = yyyymmddToDate (result.min_stdr_date);
						eDate = yyyymmddToDate (result.max_stdr_date);;
						lDate = yyyymmddToDate (result.max_stdr_date);;

						// 스크롤 관련 팝업 날짜 입력
						$("#dateWarn").text(bDate.getFullYear() + "년 " + (bDate.getMonth()+1) + "월 ~ " + eDate.getFullYear() + "년 " + (eDate.getMonth()+1) + "월");
						
						var tickes = 20;
						if($("#wrap").hasClass("device_tb")){
							tickes = 10;
						}
						
						// 테스트 기간
						var limitPeriod = ecnmy_trnd_config.maxPeriod;
						
						timeChart = timeLineChart("#rangeChart", result.data, "stdr_date", "sale_amt", margin,tickes, d3.time.format("%y/%m/%d") ,{'x0':yyyymmddToDate(ecnmy_trnd_config.selectedStartDate), 'x1':yyyymmddToDate(ecnmy_trnd_config.selectedEndDate)}, dateHandler,bDate,eDate,"소비금액(원)",{'month':limitPeriod});
						var start = ecnmy_trnd_config.selectedStartDate;
						var end = ecnmy_trnd_config.selectedEndDate;
						var sDate = start.substr(0,4)+". "+start.substr(4,2)+". "+start.substr(6);
						var eDate = end.substr(0,4)+". "+end.substr(4,2)+". "+end.substr(6);
						$(".search_period").text(sDate+" ~ "+eDate);
					}
				}
			});
		},

		/**
		 * @description 시도리스트 가져옴
		 * @param result 
		 */
		getMegaList: function() {
			$.ajax({
				url : '/common/area_select_option.json',
				data: {rgnClss: 'H1'},
				success: function(result, status) {

					var currCtyCd = ecnmy_trnd_config.sessionCtyCd;
					var megaCd = currCtyCd.substring(0, 2);
					
					var data = result.filter(function(item) {
						return item.id === megaCd;
					})
					
					if(data.length === 0) return;
					
					var megaNm = data[0]["nm"];
					var ctyNm = ecnmy_trnd_config['sessionCtyNm']; 
					ecnmy_trnd_config['sessionMegaNm'] = megaNm;
					
					$('.btn_compare.layer_open').text(['vs', megaNm].join(' '));
					$('.tit_compare').text([ctyNm, 'vs', megaNm].join(' '));
				}
			});
		},
		
		/**
		 * @description 엑셀 다운로드
		 * @param fileName
		 * @param originFileName
		 * @returns
		 */
		excelDownload: function(orgFileName, realFileName, delYn) {
			
			$("#direct-download-form").remove();
			$("body").append("<form id=\"direct-download-form\" name=\"direct-download-form\" method=\"post\" style=\"display:none;\"></form>");
			var form = $("#direct-download-form");

			form.append("<input type=\"hidden\" name=\"orgFileName\" id=\"orgFileName\">");
			form.append("<input type=\"hidden\" name=\"fileName\" id=\"fileName\">");
			form.append("<input type=\"hidden\" name=\"delYn\" id=\"delYn\">");

			$('#orgFileName').val(orgFileName);
			$('#fileName').val(realFileName);
			$('#delYn').val(delYn);

			form.attr("action", "/common/fileDirectDownload.do");

			form.submit();
			
//			var formdata = new FormData();
//			formdata.append("orgFileName", fileName); 
//			formdata.append("fileName", originFileName);
//			formdata.append("delYn", "Y");
//			var xhr = new XMLHttpRequest();
//
//			xhr.open("POST", "/common/fileDirectDownload.do");  
//			xhr.send(formdata);
		},
		
		/**
		 * @description 시계열 그래프 가이드박스 닫음
		 */
		closeHelp: function() {
			$(".group_help").css("display", "none");
		},
		
		/**
		 * @description 기간 직접입력 레이아웃 닫음
		 */
		closeDate: function() {
			$('._btn._date').removeClass('on');
			$(".layer_period").fadeOut();
		},
		
		/**
		 * 로딩바 활성화 ( background : black )
		 * @param divId 로딩바를 활성화 시킬 위치의 id
		 */
		loadingShow: function(divId, data){
			
			var title = data['title'] ? data['title'] : '';
			var desc = data['desc'] ? data['desc'] : '';
			
			// 배경 색 넣기
			if(divId == 'fog') {
				$("body").css({"overflow" : "hidden"});
				$('#fog').find('.tit').text(title);
				$('#fog').find('.desc').text(desc);
				$('#fog').show();
			} else {		 
				$("#"+divId).css("background","rgba(0, 0, 0, 0.3)");
				
				var loadW = $("#"+divId).width();
				var loadH = $("#"+divId).height();
				
				// loading 이미지 로드
				if($("#"+divId).find(".loadingImg").length > 0){
					$("#"+divId+" .loadingImg").show();
				}else{		
					if(divId.indexOf("Map") == -1){			
						$("#"+divId).html("<div class='loadingImg' style='width:"+loadW+"px;height:"+loadH+";'><img src='/images/common/loading.gif' style='width:32px;height:32px;'></div>");
					}else{
						$("#"+divId).append("<div class='loadingImg' style='width:"+loadW+"px;height:"+loadH+";'><img src='/images/common/loading.gif' style='width:32px;height:32px;'></div>");			
					}
				}
			}
		},
		
		/**
		 * 로딩바 비활성화
		 * @param divId 로딩바를 비활성화 시킬 위치의 id
		 */
		loadingHide: function(divId){
			
			// 배경 색 빼기
			if(divId == 'fog'){
				$('#fog').hide();
				$("body").css({"overflow" : "auto"});
			}else{		
				$("#"+divId).css("background","rgba(0, 0, 0, 0)");
				// 이미지 빼기
				$("#"+divId).find(".loadingImg").hide();
			}
			
		},
		
		/**
		 * @description open the PDF
		 * @param params
		 * @returns
		 */
		openPDF: function(params) {
			
			var that = this;
			that.loadingShow('fog', {
				title: '리포트 데이터를 생성중입니다.',
				desc: '기간선택에 따라 다소 시간이 걸릴 수 있습니다.'
			});
			
			if(Object.keys(params).length === 0) {
				alert('PDF 생성을 위한 필수 파라미터가 없습니다.')
				return;
			}
			
			var path = "/onmap/public/ecnmy_trnd/pdf/data_root.json";
			var callback = {
			    beforeSend: function() {},
			    complete: function() {},
			    success: function(result) {
			    	that.loadingHide('fog');
			    	
			    	var backendURL = "/report/viewer.do?file=/report.pdf";
					var query = OM.Comm.buildQuery(params);
					
					window.open(backendURL + "?" + encodeURIComponent(query));
			    }
			}
			
			OM.Comm.getData(path, params, callback, 'pdf');
		},
		
		/**
		 * @description 레이아웃에 데이터 연결
		 * @param name
		 * @param data
		 * @param domId
		 * @returns
		 */
		linkData: function(name, data, domId) {
			
			var names = ['leftLayoutType1', 'leftLayoutType2'];
			
			if(names.indexOf(name) < 0) return;
			
			if(!domId || $('#' + domId).length === 0) return;
			
			switch(name) {
				case 'leftLayoutType1':
					toLeftType1(data, domId);
					break;
				case 'leftLayoutType2':
					toLeftType2(data, domId);
					break;
				default: 
					break;
			}
			
			/**
			 * 거래금액(시군구 현황)
			 * 유동인구(시군구 현황)
			 * 읍면동 간 비교(시군구 현황)
			 * 성/연령별 대표인구(시군구현황)
			 * 성/연령별 대표인구(경제트렌드)
			 * 유입인구 성/연령 특성(경제트렌드)
			 * 유입 소비인구 소비특성(경제트렌드)
			 * 유입인구 시간대 특성(경제트렌드)
			 * 성/연령별 대표인구(이벤트효과)
			 * 업종별 경제효과(이벤트효과)
			 * 유입인구 성/연령별 특성(이벤트효과)
			 * 행정동 경제효과 변화(이벤트효과)
			 * 행정동 유동인구 변화(이벤트효과
			 */
			function toLeftType1(data, domId) {
				
				Object.keys(data).map(function(key, i) {
					$('#' + domId).find('.' + key).text(data[key]);
				});
			}
			
			/**
			 * 지역별 거래금액(경제트렌드)
			 * 지역별 유동인구 수(경제트렌드)
			 * 업종별 거래금액(경제트렌드)
			 * 유입 소비인구 거래금액(경제트렌드)
			 * 유입 유동인구 수(경제트렌드)
			 * 유입 유동인구 유입지역(경제트렌드)
			 * 주변지역 유동인구 변화(이벤트효과)
			 * 유입 유동인구 수(이벤트효과)
			 * 유입 유동인구 유입지역(이벤트효과)
			 */
			function toLeftType2(data, domId) {
				var html = [];
				
				html.push('<tbody>');
				data.map(function(item, index) {
					var data1 = item['data1'];
					var data2 = item['data2'];
					var data3 = item['data3'];
					
					html.push('<tr>');
					html.push('<th class="text-l-r">');
					html.push('<em class="rank num-m-t font-black-light">' + (index+ 1) + '</em>');
					html.push(data1);
					html.push("</th>");
					html.push('<td class="text-l-b"><strong>' + data2 + '</strong>' + data3 + '</td>');
					html.push('</tr>');
				});
				html.push('</tbody>');
				
				$('#' + domId).find('.dataTable').empty();
				$('#' + domId).find('.dataTable')[0].innerHTML = html.join('');
			}
		}
	}
})();