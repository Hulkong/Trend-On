/**
 * @description 시군구 현황 설정값 
 * @descriptor 김용현 
 * @date 2020.08.19
 */

if(!trendon) var trendon= {};

trendon.status = {
		
	ctyNm: null,
	admiNm: null,
	ctyCd: null,
	admiCd: null,
	rgnClss: null,
	dateYm: null,
	charts: {},
	dates: [],
	
	/**
	 * @description 행정동 콤보박스 리스트 클릭 이벤트
	 * @param event
	 * @param domId
	 * @returns
	 */
	clickComboBoxAdmiList: function(event, domId) {
		
		var dom = $(domId);
		var ctycd = event.target.getAttribute('ctycd');
		var admicd = event.target.getAttribute('admicd') ? event.target.getAttribute('admicd') : '';
		var text = event.target.textContent;
		
		dom.find('li.selected').removeClass('selected');
		
		$(event.target).addClass('selected');
		
		trendon.clickComboBox(domId);
		trendon.status.admiNm = text;
		dom.find('.name').text(text);
		
		trendon.status.admiCd = admicd;
		
		trendon.status.getConfig().map(function(config, index) {
			
			trendon.callAPI(
				[config],
				trendon.status.setParameter
			);
		})
	},

	/**
	 * @description 시간 콤보박스 리스트 초기화 이벤트
	 * @param event
	 * @param domId
	 * @returns
	 */
	resetComboBoxDateList: function() {
		var code = $('.layout.date').find('li').eq(0).attr('code');
		var text = $('.layout.date').find('li').eq(0).text();
		
		$('.layout.date').find('li.selected').removeClass('selected');
		$('.layout.date').find('li').eq(0).addClass('selected');
		$('.layout.date').find('.name').text(text);
		
		trendon.status.dateYm = code;
	},

	/**
	 * @description 시간 콤보박스 리스트 클릭 이벤트
	 * @param event
	 * @param domId
	 * @returns
	 */
	clickComboBoxDateList: function(event, domId) {
		
		var dom = $(domId);
		var code = event.target.getAttribute('code');
		var text = event.target.textContent;
		
		dom.find('li.selected').removeClass('selected');
		
		$(event.target).addClass('selected');
		
		trendon.clickComboBox(domId);
		dom.find('.name').text(text);
		
		trendon.status.dateYm = code;
		
		["layout0-chart1", "layout1-chart1"].map(function(item) {
			trendon.status.charts[item].update(code);
		});
		
		trendon.status.getConfig().map(function(config, index) {
			
			if(index === 0 || index === 1) {
				config['graph'] = null;
			}
			
			trendon.callAPI(
				[config],
				trendon.status.setParameter
			);
		});
	},


	/**
	 * @description 뉴스기사 리프레쉬 버튼 클릭 이벤트
	 * @returns
	 */
	clickRefreshNews: function() {
		var target = event.target;
		
		this.setNews();
		
		$(target).addClass('canRotate');
		
		setTimeout(function() {
			$(target).removeClass('canRotate');
		}, 1000);
	},

	/**
	 * @description 엑셀버튼 클릭 이벤트
	 */
	clickExcel: function() {
		trendon.loadingShow('fog', {
			title: '엑셀 데이터를 생성중입니다.',
			desc: '잠시만 기다려주세요.'
		});
		
		var path = '/onmap/ecnmy_24/makeExcel.json';
		var params = {
			admiCd: trendon.status.admiCd,
			ctyCd: trendon.status.ctyCd,
			ctyNm: trendon.status.ctyNm,
			dateYm: trendon.status.dateYm
		};
		var consoleMsg = '엑셀다운로드';
		var callback = {
		    beforeSend: function() {},
		    complete: function() {},
		    success: function(result) {
		    	trendon.loadingHide('fog');
		    	if(result['resultCnt'] === 0) alert('엑셀 데이터가 없습니다.');
		    	else trendon.excelDownload(result['oriFileName'], result['fileName'], "Y");
		    }
		}
		
		OM.Comm.getData(path, params, callback, consoleMsg);
	},
	
	/**
	 * @description 엑셀버튼 마우스엔터 이벤트
	 */
	mouseenterExcel: function(event) {
		var target = event.target;
		$(target).find('.excel_button').css('border-color', '#286135');
		$(target).find('.image').css('background', 'transparent url(/images/renew_v1/excel_on.png)');
		$(target).find('.download').css('color', '#286135');
	},
	
	/**
	 * @description 엑셀버튼 마우스리브 이벤트
	 */
	mouseleaveExcel: function() {
		var target = event.target;
		$(target).find('.excel_button').css('border-color', '#a4a4a4');
		$(target).find('.image').css('background', 'transparent url(/images/renew_v1/excel.png)');
		$(target).find('.download').css('color', '#a4a4a4');
	},
	
	/**
	 * @description 행정동 콤보박스 설정 
	 */
	setAdmiComboBox: function() {
		
		var that = this;
		var path = '/common/area_select_option.json';
		var params = {
			ctyCd: this.ctyCd,
			rgnClss: this.rgnClss
		};
		var consoleMsg = '행정동 리스트';
		
		var callback = {
			beforeSend: function() {},
			complete: function() {},
			success: function(result) {
				var domId = '.layout.region';
				var html = [
					'<li class="selected" ctycd="' + that.ctyCd + '"', 
					' onclick="trendon.status.clickComboBoxAdmiList(event, \' ' + domId + '\')">',
					that.ctyNm,
					'</li>'
				];
				
				result.map(function(item, index) {
					html.push(
						'<li ctycd="',
						that.ctyCd,
						'" admicd="',
						item['id'],
						'" onclick="trendon.status.clickComboBoxAdmiList(event, \' ' + domId + '\')">',
						item['nm'],
						'</li>'
					);
				});
				
				$(domId + ' .combo-box').empty();
				$(domId + ' .combo-box').append(html.join(''));
				$(domId + ' .name').text(that['ctyNm']);
				$('#regionTotCnt').text(result.length);  // 읍면동 총 개수 설정
				
				that.admiCd = '';
				trendon.status.setDateComboBox();
			}
		}
		
		OM.Comm.getData(path, params, callback, consoleMsg);
	},
	
	/**
	 * @description 날짜 콤보박스 설정
	 */
	setDateComboBox: function() {
		
		var path = '/onmap/ecnmy_24/last_stdr_date.json';
		var params = {};
		var consoleMsg = '최신 날짜';
		
		var callback = {
			beforeSend: function() {},
			complete: function() {},
			success: function(result) {
				var stdrDate = result['stdrDate'];
				
				if(!stdrDate) return;
				
				var html = [];
				var domId = '.layout.date';
				var year = stdrDate.substring(0, 4);
				var month = stdrDate.substring(4, 6);
				var codes = [];
				
				for(var i = 12; i >= 0; i--) {
					
					var code = [year, month].join('');
					var text = year + '년 ' + month + '월';
					
					if(i === 12) {
						$(domId + ' .name').text(text);
						html.push('<li class="selected" code="' + code + '" onclick="trendon.status.clickComboBoxDateList(event, \' ' + domId + '\')">' + text + '</li>');
					} else {
						html.push('<li code="' + code + '" onclick="trendon.status.clickComboBoxDateList(event, \' ' + domId + '\')">' + text + '</li>');
					}
					
					
					
					$(domId + ' .combo-box').empty();
					$(domId + ' .combo-box').append(html.join(''));
					
					if(Number(month) === 1) {
						month = 12;
						year -= 1;
					} else {
						month -= 1;
						
						if(month < 10) month = "0" + month;
					}
					
					codes.push(code);
				}
				
				OM.Comm.sort(codes, 'asc');
				trendon.status.dates = codes;
				trendon.status.dateYm = stdrDate;
				
				trendon.status.getConfig().map(function(config) {
					trendon.callAPI(
						[config],
						trendon.status.setParameter
					);
				})
			}
		};
		
		OM.Comm.getData(path, params, callback, consoleMsg);
		
	},
	
	/**
	 * @description 최신 뉴스 리스트 설정
	 */
	setNews: function() {
		
		var path = '/onmap/ecnmy_24/cty_news.json';
		var params = {
			ctyNm: this.ctyNm,
			num: 6
		};
		var consoleMsg = '선택 시군구의 최신 뉴스';
		var callback = {
	        beforeSend: function() {},
	        complete: function() {},
	        success: function(result) {
				result['list'].map(function(item, index) {
					var title = item['title'];
					var link = item['link'];
					var date = new Date(item['pubDate']);
					var convertDate = OM.Date.getArr(date);
				
					$('.article').eq(index).find('.link').attr('href', link);
					$('.article').eq(index).find('.news_title').html(title);
					$('.article').eq(index).find('.date').text(convertDate.join('-'));
					
					if(index === 0) {
						var text  = [
							convertDate[0] + '년',
							convertDate[1] + '월',
							convertDate[2] + '일 ',
							date.getHours() < 10 ? ("0" + date.getHours()) + '시' : date.getHours() + '시',
							(date.getMinutes() < 10 ? ("0" + date.getMinutes()) : date.getMinutes()) + '분(업데이트 기준)'
						].join('');
						$('.news .subtitle').text(text);
					}
				});
			}
		};
		
		OM.Comm.getData(path, params, callback, consoleMsg);
	},
	
	/**
	 * @description 서버 요청 파라미터 설정
	 */
	setParameter: function(data) {
		var tmpData = OM.Comm.deepCloneObj(data);  // 얕은 복사
		var keys = Object.keys(tmpData);
		
		keys.map(function(key, i) {
			var value = tmpData[key];
			if(key === 'ctyNm' && !value) tmpData[key] = trendon.status.ctyNm;
			if(key === 'ctyCd' && !value) tmpData[key] = trendon.status.ctyCd;
			if(key === 'admiCd' && !value) tmpData[key] = trendon.status.admiCd;
			if(key === 'rgnClss' && !value) tmpData[key] = trendon.status.rgnClss;
			if(key === 'dateYm' && !value) tmpData[key] = trendon.status.dateYm;
		});
		
		return tmpData;
	},
	
	/**
	 * 0. 거래금액(지도포함)
	 * 1. 유동인구(지도포함)
	 * 2. 성/연령별 대표인구
	 * 3. 읍면동 간 비교
	 */
	getConfig: function(index) {
		
		if(isNaN(index)) index = -1;
		
		var configs = [
			
			// 0. 거래금액(지도포함)
			{
				name: '0. 거래금액',
				data: {
					message: '데이터',
					domId: 'layout0',
					path: '/onmap/ecnmy_24/total_amt_txt.json',
					params: {
						ctyCd: null,
						admiCd: null,
						dateYm: null
					},
					callback: function() {
						var fn = this;
						return function(result) {
				        		var data1 = result['totalAmt'] ? result['totalAmt'] : null;   // 총 거래금액 
								var data2 = result['lastMonRate'] ? result['lastMonRate'] : null;   // 전달 대비 거래금액 비율
								var data3 = result['lastYearRate'] ? result['lastYearRate'] : null;   // 저년동기 대비 거래금액 비율
								var unit = ['원', '%'];
								var initVal = ['-', ''];
								var upDown = ['증가', '감소'];
								var dataType1 = data1 ? OM.Comm.numToKR(data1)[0] : initVal[0];
								var dataType2 = data1 ? OM.Comm.numToKR(data1)[1] + unit[0] : initVal[1];
								var dataType3 = data2 ? Number(data2).toFixed(1) + unit[1] : initVal[0];
								var dataType4 = data2 ? (data2 > 0 ? upDown[0] : upDown[1]) : initVal[1];
								var dataType5 = data3 ? Number(data3).toFixed(1) + unit[1] : initVal[0];
								var dataType6 = data3 ? (data3 > 0 ? upDown[0] : upDown[1]) : initVal[1];
								
								trendon.linkData('leftLayoutType1', {
									dataType1: dataType1,
									dataType2: dataType2,
									dataType3: dataType3,
									dataType4: dataType4,
									dataType5: dataType5,
									dataType6: dataType6
								}, fn['domId']);
						};
					}
				},
				graph : {
					message: '그래프',
					domId: 'layout0',
					chartId: 'chart1',
					path: '/onmap/ecnmy_24/total_amt_chart.json',
					params: {
						ctyCd: null,
						admiCd: null,
						dateYm: $('.date .combo-box li').eq(0).attr('code')
					},
					callback: function() {
						var fn = this;
						return function(result) {
					        	
							if(!result['list'] || result['list'].length === 0) {
					    		trendon.noData.show(fn['domId'], fn['chartId']);
					    		return;
					    	}
							
							var chart = trendon.draw('line-grouped-bar', result['list'], {
								domId: fn['domId'],
								chartId: fn['chartId'],
								dataKey: 'total_amt',
								dates: trendon.status.dates,
								xFormat: function(d) { return [d.substring(0, 4), d.substring(4,6)].join('.')},
								yFormat: function(d) { return OM.Comm.numToKR(d).join('') + '원'},
								margin: {
									top: 40,
									right: 50,
									bottom: 85,
									left: 85
								},
								barWidth: OM.Comm.remToPx(1.688, $('html').css('font-size').replace('px', ''))
							});
							
							trendon.status.charts[fn['domId'] + '-' + fn['chartId']] = chart;
						};
					}
				},
				map: {
					message: '지도',
					subMessage: '0. 거래금액-지도매핑',
					domId: 'layout0',
					mapId: 'map1',
					path: '/onmap/ecnmy_24/getStateMap.json',
					params: {
						ctyCd: null,
						admiCd: null,
						dateYm: null,
						rgnClss: null
					},
					callback: function() {
						var fn = this;
						var that = this;
						return function(result, params) {
							
							result['features'].sort(function(a, b) {
						        return a.properties['id'] === trendon.status.admiCd ? 1 : -1; 
							});
							
							trendon.draw('map', result, {
								id: 'admi_cd',
								url: '/onmap/ecnmy_24/total_amt_map.json',
								params: params,
								domId: fn['domId'],
								mapId: fn['mapId'],
								subMsg: fn['subMessage'],
								unit: '원',
								title: '거래금액',
								valueKey: 'sale_amt',
								tileMap: false,
								defaultColor: '#fecec2',
								colors: function(index) {
									return [
								        [ '#ff5c3c'],
								        [ '#fe8e75', '#ff5c3c'],
								        [ '#fe8e75', '#ff5c3c', '#c03c25'],
								        [ '#fecec2', '#fe8e75', '#c03c25', '#67000d'],
								        [ '#fecec2', '#fe8e75', '#ff5c3c', '#c03c25', '#67000d']
								       ][index];
								},
								limitMinZoom: true,
								callback: {
									mouseout: function(layers) {
										var layer = layers.getLayers().filter(function(layer) {     
										    return layer.feature.properties['id'] === trendon.status.admiCd;
										})[0];
										
										if(!layer) return;
										
										layer.bringToFront();
									},
									style: function(feature, style, data) {
										// 지역 리스트 중 가장 첫 번째 지역을 강조하는 스타일
										
										if(trendon.status.admiCd.length === 0) return;
										
										if(feature.properties['id'] === trendon.status.admiCd) {
//											style.fillColor = '#fff';
											style.weight = 3;
											style.color = '#000';
										}
									},
									onEachFeature: function(feature, layer) {}
								}
							})
						}
					}
				}
			},
			
			// 1. 유동인구(지도포함)
			{
				name: '1. 유동인구',
				data: {
					message: '데이터',
					domId: 'layout1',
					path: '/onmap/ecnmy_24/total_float_txt.json',
					params: {
						ctyCd: null,
						admiCd: null,
						dateYm: null
					},
					callback: function() {
						var fn = this;
						return 	function(result) {
							var data1= result['totalFloat'] ? result['totalFloat'] : null;   // 총 거래금액 
							var data2 = result['lastMonRate'] ? result['lastMonRate'] : null;   // 전달 대비 거래금액 비율
							var data3 = result['lastYearRate'] ? result['lastYearRate'] : null;   // 저년동기 대비 거래금액 비율
							var unit = ['명', '%'];
							var initVal = ['-', ''];
							var upDown = ['증가', '감소'];
							var dataType1 = data1 ? OM.Comm.numToKR(data1)[0] : initVal[0];
							var dataType2 = data1 ? OM.Comm.numToKR(data1)[1] + unit[0] : initVal[1];
							var dataType3 = data2 ? Number(data2).toFixed(1) + unit[1] : initVal[0];
							var dataType4 = data2 ? (data2 > 0 ? upDown[0] : upDown[1]) : initVal[1];
							var dataType5 = data3 ? Number(data3).toFixed(1) + unit[1] : initVal[0];
							var dataType6 = data3 ? (data3 > 0 ? upDown[0] : upDown[1]) : initVal[1];
							
							trendon.linkData('leftLayoutType1', {
								dataType1: dataType1,
								dataType2: dataType2,
								dataType3: dataType3,
								dataType4: dataType4,
								dataType5: dataType5,
								dataType6: dataType6
							}, fn['domId']);
						};
					}
				},
				graph : {
					message: '그래프',
					domId: 'layout1',
					chartId: 'chart1',
					path: '/onmap/ecnmy_24/total_float_chart.json',
					params: {
						ctyCd: null,
						admiCd: null,
						dateYm: $('.date .combo-box li').eq(0).attr('code')
					},
					callback: function() {
						var fn = this;
						return function(result, params) {
							
							if(!result['list'] || result['list'].length === 0) {
					    		trendon.noData.show(fn['domId'], fn['chartId']);
					    		return;
					    	}
							
							var chart = trendon.draw('line-grouped-bar', result['list'], {
								domId: fn['domId'],
								chartId: fn['chartId'],
								title: '유동인구',
								texts: ['상주 유동인구', '유입 유동인구', '총 유동인구'],
								colors: ['#d3d3d3', '#2ec5c5'],
								unit: '명',
								dataKey: 'total_cnt',
								dates: trendon.status.dates,
								xFormat: function(d) { return [d.substring(0, 4), d.substring(4,6)].join('.')},
								yFormat: function(d) { return OM.Comm.numToKR(d).join('') + '명'},
								margin: {
									top: 40,
									right: 50,
									bottom: 85,
									left: 85
								},
								barWidth: OM.Comm.remToPx(1.688, $('html').css('font-size').replace('px', ''))
							});
							
							trendon.status.charts[fn['domId'] + '-' + fn['chartId']] = chart;
						} 
					}
				},
				map: {
					message: '지도',
					subMessage: '1. 유동인구-지도매핑',
					domId: 'layout1',
					mapId: 'map2',
					path: '/onmap/ecnmy_24/getStateMap.json',
					params: {
						ctyCd: null,
						admiCd: null,
						dateYm: null,
						rgnClss: null
					},
					callback: function() {
						var fn = this;
						return function(result, params) {
							
							result['features'].sort(function(a, b) {
						        return a.properties['id'] === trendon.status.admiCd ? 1 : -1; 
							});
							
							trendon.draw('map', result, {
								id: 'admi_cd',
								url: '/onmap/ecnmy_24/total_float_map.json',
								params: params,
								domId: fn['domId'],
								mapId: fn['mapId'],
								subMsg: fn['subMessage'],
								unit: '명',
								title: '유동인구',
								valueKey: 'total_cnt',
								defaultColor: '#e0f5f6',
								colors: function(index) {
									return [
								        [ '#00b7b6'],
								        [ '#78d6d7', '#00b7b6'],
								        [ '#78d6d7', '#00b7b6', '#007a74'],
								        [ '#e0f5f6', '#78d6d7', '#007a74', '#083a38'],
								        [ '#e0f5f6', '#78d6d7', '#00b7b6', '#007a74', '#083a38']
								       ][index];
								},
								tileMap: false,
								limitMinZoom: true,
								callback: {
									mouseout: function(layers) {
										var layer = layers.getLayers().filter(function(layer) {     
										    return layer.feature.properties['id'] === trendon.status.admiCd;
										})[0];
										
										if(!layer) return;
										
//										layer.bringToBack();
										layer.bringToFront();
									},
									
									// 지역 리스트 중 가장 첫 번째 지역을 강조하는 스타일
									style: function(feature, style, data) {
										
										if(trendon.status.admiCd.length === 0) return;
										
										if(feature.properties['id'] === trendon.status.admiCd) {
//											style.fillColor = '#fff';
											style.weight = 3;
											style.color = '#000';
										}
									},
									onEachFeature: function(feature, layer) {}
								}
							})
						}
					}
				}
			},
			
			// 2. 성/연령별 대표인구
			{
				name: '2. 성/연령별 대표인구',
				data: {
					message: '데이터',
					domId: 'layout2',
					path: '/onmap/ecnmy_24/all_gender_age.json',
					params: {
						ctyCd: null,
						admiCd: null,
						dateYm: null
					},
					callback: function() {
						var fn = this;
						return function(result) {
							var dataType1 = result['floatTxt'] ? result['floatTxt'] : '-'; // 유동인구
							var dataType2 = result['amtTxt'] ? result['amtTxt'] : '-' // 소비인구
							
							trendon.linkData('leftLayoutType1', {
								dataType1: dataType1,
								dataType2: dataType2,
							}, fn['domId']);
						};
					}
				},
				graph: [
					{
						message: '통신사 그래프',
						domId: 'layout2',
						chartId: 'chart1',
						path: '/onmap/ecnmy_24/float_gender_age.json',
						params: {
							ctyCd: null,
							admiCd: null,
							dateYm: null
						},
						callback: function() {
							var fn = this;
							return	function(result) {
								
								trendon.draw('grouped-bar', result['list'], {
						    		domId: fn['domId'],
						    		chartId: fn['chartId'],
						    		sorts: [
						    			'f_20_cnt', 'm_20_cnt',
						    			'f_30_cnt', 'm_30_cnt',
						    			'f_40_cnt', 'm_40_cnt',
						    			'f_50_cnt', 'm_50_cnt',
						    			'f_60_cnt', 'm_60_cnt',
						    		],
						    		title: '유동인구',
						    		groups: ["20대", "30대", "40대", "50대", "60대"],
						    		colors: ['#e47677', '#54a7e8'],
									columns: ['여성', '남성'],
									images: ['/images/renew_v1/ic_female.png', '/images/renew_v1/ic_male.png'],
									unit: '%',
									barWidth: OM.Comm.remToPx(1.688, $('html').css('font-size').replace('px', ''))
						    	})
							};
						}
					},
					{
						message: '카드사 그래프',
						domId: 'layout2',
						chartId: 'chart2',
						path: '/onmap/ecnmy_24/amt_gender_age.json',
						params: {
							ctyCd: null,
							admiCd: null,
							dateYm: null
						},
						callback: function() {
							var fn = this;
							return	function(result) {
									
								trendon.draw('grouped-bar', result['list'], {
						    		domId: fn['domId'],
						    		chartId: fn['chartId'],
						    		sorts: [
						    			'f_20_rate', 'm_20_rate',
						    			'f_30_rate', 'm_30_rate',
						    			'f_40_rate', 'm_40_rate',
						    			'f_50_rate', 'm_50_rate',
						    			'f_60_rate', 'm_60_rate',
						    		],
						    		title: '소비인구',
						    		groups: ["20대", "30대", "40대", "50대", "60대"],
						    		colors: ['#e47677', '#54a7e8'],
									columns: ['여성', '남성'],
									images: ['/images/renew_v1/ic_female.png', '/images/renew_v1/ic_male.png'],
									unit: '%',
									barWidth: OM.Comm.remToPx(1.688, $('html').css('font-size').replace('px', ''))
						    	})
							};
						}
					}
				],
				map: null
			},
			
			// 3. 읍면동 간 비교
			{
				name: '3. 읍면동 간 비교',
				data: {
					message: '데이터',
					domId: 'layout3',
					path: '/onmap/ecnmy_24/admi_state_txt.json',
					params: {
						ctyCd: null,
						admiCd: null,
						dateYm: null
					},
					callback: function() {
						var fn = this;
						return function(result) {
							
							var data = result['list'] ? result['list'] : {};
							var dataType1 = data['pop'] ? data['pop'] : '-';  // 주민등록인구
							var dataType2 = data['pop_rnk'] && data['pop_rnk'] > 0 ? data['pop_rnk'] : '-'; // 주민등록인구 순위
							var dataType3 = data['float_cnt'] ? data['float_cnt'] : '-'; // 총 유동인구
							var dataType4 = data['float_cnt_rnk'] && data['float_cnt_rnk'] > 0 ? data['float_cnt_rnk'] : '-'; // 총 유동인구 순위
							var dataType5 = data['tot_amt'] ? data['tot_amt'] : '-'; // 총 거래금액
							var dataType6 = data['tot_amt_rnk'] && data['tot_amt_rnk'] > 0 ? data['tot_amt_rnk'] : '-'; // 총 거래금액 순위
							var dataType7 = data['tot_cnt'] ? data['tot_cnt'] : '-'; // 총 거래량
							var dataType8 = data['tot_cnt_rnk'] && data['tot_cnt_rnk'] > 0 ? data['tot_cnt_rnk'] : '-'; // 총 거래량 순위
							
							dataType1 = OM.Comm.numToKR(dataType1); 
							dataType3 = OM.Comm.numToKR(dataType3); 
							dataType5 = OM.Comm.numToKR(dataType5); 
							dataType7 = OM.Comm.numToKR(dataType7); 
							
							trendon.linkData('leftLayoutType1', {
								dataType1: dataType1[0],
								dataType2: dataType1[1] + '명' + (dataType2 && dataType2 > 0 ? ' (' + dataType2 + '위)' : ''),
								dataType3: dataType3[0],
								dataType4: dataType3[1] + '명' + (dataType4 && dataType4 > 0 ? ' (' + dataType4 + '위)' : ''),
								dataType5: dataType5[0],
								dataType6: dataType5[1] + '원' + (dataType6 && dataType6 > 0 ? ' (' + dataType6 + '위)' : ''),
								dataType7: dataType7[0],
								dataType8: dataType7[1] + '건' + (dataType8 && dataType8 > 0 ? ' (' + dataType8 + '위)' : ''),
							}, fn['domId']);
						};
					}
				},
				graph: {
					message: '테이블',
					domId: 'layout3',
					chartId: 'bx_graph',
					path: '/onmap/ecnmy_24/admi_state_list.json',
					params: {
						admiCd: null,
						ctyCd: null,
						dateYm: null
					},
					callback: function() {
						var fn = this;
						return function(result) {
							var cleanData = [];
							var domId = fn['domId'];
							var chartId = fn['chartId'];
							
							result['list'].map(function(item, index) {
								var arr = [];
								var pop = item['pop'] ? item['pop'] : 0;
								var floatCnt = item['float_cnt'] ? item['float_cnt'] : 0;
								var totAmt = item['tot_amt'] ? item['tot_amt'] : 0;
								var totCnt = item['tot_cnt'] ? item['tot_cnt'] : 0;
								var popRnk = item['pop_rnk'] ? item['pop_rnk'] : null;
								var floatCntRnk = item['float_cnt_rnk'] ? item['float_cnt_rnk'] : null;
								var totAmtRnk = item['tot_amt_rnk'] ? item['tot_amt_rnk'] : null;
								var totCntRnk = item['tot_cnt_rnk'] ? item['tot_cnt_rnk'] : null;
								
								arr.push([item['nm']]); // 행정동 이름
								arr.push([pop, popRnk]); // 주민등록인구
								arr.push([floatCnt, floatCntRnk]); // 총 유동인구 수
								arr.push([totAmt, totAmtRnk]); // 총 거래금액
								arr.push([totCnt, totCntRnk]); // 총 거래량
								
								cleanData.push(arr);
							});
							
							var html = [];
							html.push('<table class="cell-border hover order-column">');
							html.push('<thead>');
							html.push('<tr>');
							html.push('<th>명칭</th>');
							html.push('<th>주민등록인구(명)</th>');
							html.push('<th>총 유동인구(명)</th>');
							html.push('<th>총 거래금액(천원)</th>');
							html.push('<th>총 거래량(건)</th>');
							html.push('</tr>');
							html.push('</thead>');
							html.push('</table>');
							
							$('#' + domId).find('table').remove();
							$('#' + domId + ' .' + chartId).append(html.join(''));
						        
							jQuery.fn.dataTableExt.oSort["custom-desc"] = function(a, b) { return a > b ? -1 : a < b ? 1 : 0; };
							jQuery.fn.dataTableExt.oSort["custom-asc"] = function(a, b) { return a < b ? -1 : a > b ?  1 : 0; };
							jQuery.fn.dataTableExt.oSort["custom-pre"] = function(dom) { 
								var value = $(dom).attr('value');
								if(isNaN(Number(value))) return value;
								else return Number(value);
							};
							
							
							var table = $('#layout3').find('table').dataTable({
								keys: true,
								data: cleanData,
								paging: false,
								scrollY: '16.562rem',
								searching: false,
								info: false,
								asStripeClasses: [ 'openmate-on'],
								initComplete: function(settings, json) {
								    var api = this.api();
								    var firstRow = api.row(0).nodes()[0];
								    
								    $(this).find('tbody').prepend(firstRow);
								    firstRow.classList.add('first-row');
//								    $(settings.aoHeader[0][0].cell).addClass('no-order');
								    $('.openmate-on span[value=' + trendon.status.admiNm + ']').parent().parent().addClass('select');
								    
								},
								columnDefs: ['', '명', '명', '원', '건'].map(function(unit, index) {
									return {
										orderable: true, 
								    	targets: index, 
								    	className: index === 0 ? 'dt-body-center' : 'dt-body-right', 
								    	type: 'custom' ,
								    	render: function (data, type, row) {
								    		return [
								    			'<span value="' + data[0] + '">', 
								    			OM.Comm.addCommaToNum(data[0]) + (data[1] ? ' (' + data[1] + '위)' : ''), 
								    			'</span>'
								    		].join(''); 
								    	}
									}
								})
							});
							
							$('#layout3').find('table').on( 'order.dt', function () {
								var cloneDOM = $.clone($(this).find('.first-row')[0]);
								$(this).find('.first-row').remove();
							    $(this).find('tbody').prepend(cloneDOM);
							} );
						}
					}
				},
				map: null
			}
		]
		
		return index === -1 ? configs : [configs[index]];
	}
}