/**
 * @description 경제트렌드 스크립트 
 * @descriptor 김용현
 * @date 2020.08.19 
 */

if(!trendon) var trendon= {};

trendon.trnd = {
		
		lastAnchorLink: 'firstPage',	// 현재 화면이 위치한 영역명
		ctyCd: null,  // 시군구 코드
		megaCd: null, // 광역시도 코드
		serviceClss: null, // 서비스 코드
		startDate: null,  // 선택기간 시작날짜
		endDate: null, // 선택기간 종료날짜
		minStdrDate: null, // 데이터기준 시작일자
		maxStdrDate: null, // 데이터기준 죵료일자
		minPeriod: 3,	   // 선택가능한 최소기간  [ 테스트 계정: 3, 회원 계정: 3 ] (일)
		maxPeriod: 3,	   // 선택가능한 최대 기간 [ 테스트 계정: 3, 회원 계정: 12 ] (개월)
		rgnClss: null, // 행정구역 코드
		charts: {},
		
		
		/**
		 * @description 기관과 관련된 모든 데이터 설정
		 */
		setAllWithDate: function() {
			var minStdrDate = OM.Date.getArr(trendon.trnd.minStdrDate); // 데이터기준 시작일자 
			var maxStdrDate = OM.Date.getArr(trendon.trnd.maxStdrDate); // 데이터기준 종료일자
			var startDate = OM.Date.getArr(trendon.trnd.startDate); // 선택기간 시작일자
			var endDate = OM.Date.getArr(trendon.trnd.endDate); // 선택기간 죵료일자
			
			// 가이드 박스 기간 텍스트 설정
			$("#dateWarn").text([minStdrDate[0], "년 ", minStdrDate[1], "월", " ~ ", maxStdrDate[0], "년 ", maxStdrDate[1], "월"].join(''));
			
			// 기간 텍스트 설정
			$(".search_period").text(startDate.join('. ') + " ~ " + endDate.join('. '));
			
			// 기간 텍스트 설정(팝업)
			$("#standard_period").text([minStdrDate[0], "년 ", minStdrDate[1], "월", " ~ ", maxStdrDate[0], "년 ", maxStdrDate[1], "월"].join(''));

			// 현재 선택된 시작일 출력(팝업)
			$("#popSelectedSdate").text(startDate.join('. '));
			
			// 현재 선택된 종료일 출력(팝업)
			$("#popSelectedEdate").text(endDate.join('. '));
			
			
			
			// 기간직접입력 팝업 달력 동기화
			// 선택한 날짜 변경
			$("#sDatepicker").datepicker("setDate", new Date(startDate.join('-')));
			$("#eDatepicker").datepicker("setDate", new Date(endDate.join('-')));
			
			// 선택 가능한 limit 날짜 적용
			var sDate = new Date(startDate.join('-'));
			var eDate = new Date(endDate.join('-'));
			// 시작일은 선택한 날짜전후 1년 (단, 전 1년시 minStdrDate보다 클 경우, 후 1년시 endDate보다 작을 경우)
			eDate.setFullYear((eDate.getFullYear() -1))	;
			var sMinDate = Math.max(
					(new Date(minStdrDate.join('-'))).getTime(), 
					eDate.getTime()	
			);
			eDate.setFullYear((eDate.getFullYear() +1))	;
			eDate.setDate(eDate.getDate() -3);
			var sMaxDate = Math.min(
					eDate.getTime()
			); 
			eDate.setDate(eDate.getDate() +3);
			$('#sDatepicker').datepicker('option','minDate', new Date(sMinDate));     
			$('#sDatepicker').datepicker('option','maxDate', new Date(sMaxDate));     
//			// 종료일은 선택한 날짜전후 1년 (단, 후 1년시 maxStdrDate보다 작을 경우, 전 1년시 startDate보다 큰 경우)
			sDate.setDate(sDate.getDate() +3);
			var eMinDate = Math.max(
					sDate.getTime()
			); 
			sDate.setDate(sDate.getDate() -3);
//			
			sDate.setFullYear((sDate.getFullYear() +1))
			var eMaxDate = Math.min(
					new Date(maxStdrDate.join('-')).getTime(), 
					sDate.getTime()
			);
			$('#eDatepicker').datepicker('option','minDate', new Date(eMinDate));     
			$('#eDatepicker').datepicker('option','maxDate', new Date(eMaxDate));     
		},
		
		clickPeriod: function() {
			var startDate = $('#popSelectedSdate').text().replace(/ /gi, "").split('.');
			var endDate = $('#popSelectedEdate').text().replace(/ /gi, "").split('.');
			var chart = trendon.trnd.charts["layout0-dateRange"];
			
			trendon.trnd.startDate = startDate.join(''); // 선택기간 시작일자
			trendon.trnd.endDate = endDate.join(''); // 선택기간 죵료일자

//			this.setAllWithDate();
			
			trendon.trnd.getConfig().map(function(item, index) {
				
				// 시계열 그래프 제외
				if(index === 0) return;
				
				trendon.callAPI(
					trendon.trnd.getConfig(index),
					trendon.trnd.setParameter
				);
			});
			
			trendon.closeDate();
			
			chart.update(new Date(startDate.join('-')), new Date(endDate.join('-')));
			
			$(".search_period").text(startDate.join('. ') + " ~ " + endDate.join('. '));  // 기간 텍스트 설정
			
		},
		
		/**
		 * @description daterangepicker 설정
		 */
		createDateRangePicker: function() {
			
			var startDate = OM.Date.getArr(trendon.trnd.startDate);
			var endDate = OM.Date.getArr(trendon.trnd.endDate);
			var minStdrDate = OM.Date.getArr(trendon.trnd.minStdrDate);
			var maxStdrDate = OM.Date.getArr(trendon.trnd.maxStdrDate);
			
			$("#sDatepicker").datepicker({
				monthNames : [ "1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월" ] ,
				dayNamesMin: ["일","월","화","수","목","금","토"],
				showMonthAfterYear: true,
				minDate : new Date(minStdrDate.join('-')),
				maxDate : new Date(maxStdrDate.join('-')),
				dateFormat : "yy. mm. dd" ,
				yearSuffix : "년",
				onSelect : function(dateText,inst) {
					$("#selectStartDate").text(dateText);
					$("#popSelectedSdate").text(dateText);
					
					// 종료일 선택 달력 min/max 설정
					var dayArr = [inst.selectedYear,(inst.selectedMonth+1),(Number(inst.selectedDay)+3)];
					$('#eDatepicker').datepicker('option','minDate', new Date(dayArr.join('-')));  
				}
			});
			
			$("#eDatepicker").datepicker({
				monthNames : [ "1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월" ] ,
				dayNamesMin: ["일","월","화","수","목","금","토"],
				showMonthAfterYear: true,
				minDate : new Date(minStdrDate.join('-')),
				maxDate : new Date(maxStdrDate.join('-')),
				dateFormat : "yy. mm. dd" ,
				yearSuffix : "년",
				onSelect : function(dateText,inst) {
					$("#selectEndDate").text(dateText);
					$("#popSelectedEdate").text(dateText);
					
					// 시작일 선택 달력 min/max 설정
					var dayArr = [inst.selectedYear,(inst.selectedMonth+1),(inst.selectedDay-3)];
					$('#sDatepicker').datepicker('option','maxDate', new Date(dayArr.join('-')));
				}
			});
			
//			$("#sDatepicker").datepicker("setDate", new Date(startDate.join('-')));
//			$("#eDatepicker").datepicker("setDate", new Date(endDate.join('-')));
		},
		
		//event to click compare button 
		clickToCompare: function() {
			var currCtyNm = ecnmy_trnd_config.sessionCtyNm;
			var currCtyCd = ecnmy_trnd_config.sessionCtyCd;
			var mapIds = ['trend2_1', 'trend2_2', 'trend2_3', 'trend2_4', 'trend3_1', 'trend3_2', 'trend3_3', 'trend3_4'];
			var isEnoughLayer = true;
			var beforeDate = $('.layer_compare .txt_period').text().replace(/ /gi, "").trim();
			var sDate = beforeDate.split('~')[0];
			var eDate = beforeDate.split('~')[1];
			var convertSdate = sDate.split('.').join('');
			var convertEdate = eDate.split('.').join('')
			var compareSdate =  ecnmy_trnd_config.selectedStartDate;
			var compareEdate =  ecnmy_trnd_config.selectedEndDate;
			var comBdHgt = $(window).innerHeight() - $(".compare_header").innerHeight() -100;
			var beforeWindowSize = $('#windowSize').val();
			
			$('._btn._compare').addClass('on');
			$('.pop_layer').fadeIn();
			$(".compare_result").show();
			$(".menu_compare").show();

			$('.compare_result').animate({
		        scrollTop: '0px'
		    }, 'slow');
			
			
			$(".layer_compare .compare_result").css({"height" : comBdHgt});
			$("body").css({"overflow" : "hidden"});
			$('.compare_body').hide();
			
			// 선택된 기간이 변경되지 않았을 경우
			if(convertSdate === compareSdate && convertEdate === compareEdate) {
				// 윈도우 창 크기가 변하지 않으면서 지역비교에 관한 레이어가 모두 존재할 경우
				if(Number(beforeWindowSize) === window.outerWidth && isEnoughLayer) return;
			}
			
			$(".compare_result").load("/onmap/ecnmy_trnd/" + currCtyCd + "/compare.do?nm=" + encodeURIComponent(currCtyNm));
		},
		
		// event to click PDF button
		clickToPDF: function() {
			
			trendon.openPDF({
				fileNm: "/economy_trend/economy_trend_book",
				dataId: "rpt-new-trnd",
				ctyCd: trendon.trnd.ctyCd,
				h3Cd: trendon.trnd.ctyCd,
				userNo: null,
				startDate: trendon.trnd.startDate,
				endDate: trendon.trnd.endDate		
			})
		},
		
		/**
		 * @description 서버 요청 파라미터 설정
		 */
		setParameter: function(data) {
			var tmpData = OM.Comm.deepCloneObj(data);  // 얕은 복사
			var keys = Object.keys(tmpData);
			
			keys.map(function(key) {
				var value = tmpData[key];
				
				if(key === 'megaCd' && !value) tmpData[key] = trendon.trnd.megaCd;
				if(key === 'ctyCd' && !value) tmpData[key] = trendon.trnd.ctyCd;
				if(key === 'serviceClss' && !value) tmpData[key] = trendon.trnd.serviceClss;
 				if(key === 'startDate' && !value) tmpData[key] = trendon.trnd.startDate;
 				if(key === 'endDate' && !value) tmpData[key] = trendon.trnd.endDate;
//				if(key === 'startDate' && !value) tmpData[key] = '20200601';
//				if(key === 'endDate' && !value) tmpData[key] = '20200630';
				if(key === 'rgnClss' && !value) tmpData[key] = trendon.trnd.rgnClss;
			});
			
			return tmpData;
		},
		
		/**
		 * 0. 시계열 그래프
		 * 1. 지역별 거래금액(지도)
		 * 2. 지역별 유동인구수(지도)
		 * 3. 성/연령별 대표인구 
		 * 4. 업종별 거래금액 
		 * 5. 유입 소비인구 거래금액(지도)
		 * 6. 유입 유동인구 수 (지도)
		 * 7. 유입인구 성/연령 특성 
		 * 8. 유입 소비인구 소비특성
		 * 9. 유입인구 시간대 특성
		 * 10. 유입 유동인구 유입지역(지도) 
		 */
		getConfig: function(index) {
			
			if(isNaN(index)) index = -1;
			
			var configs = [
				
				// 0. 시계열 그래프
				{
					name: '0. 시계열 그래프',
					data: null,
					graph: {
						message: '그래프',
						domId: 'layout0',
						chartId: 'dateRange',
						path: '/onmap/ecnmy_trnd/graph_data.json',
						params: {
							serviceClss: null,
							ctyCd: null
						},
						callback: function() {
							var fn = this;
							return function(result) {
								
								var minStdrDate = OM.Date.getArr(trendon.trnd.minStdrDate); // 데이터기준 시작일자 
								var maxStdrDate = OM.Date.getArr(trendon.trnd.maxStdrDate); // 데이터기준 종료일자
								
								var chart = trendon.draw('timeseries', result, {
									domId: fn['domId'],
									chartId: fn['chartId'],
									minDate: new Date(minStdrDate.join('-')),
									maxDate: new Date(maxStdrDate.join('-')),
									callback: function (evt, startDate, endDate) {
										
										var startDate = OM.Date.getArr(startDate);
										var endDate = OM.Date.getArr(endDate);
										
										 trendon.trnd.startDate = startDate.join('');
										 trendon.trnd.endDate = endDate.join('');
										 
										 trendon.trnd.getConfig().map(function(config, index) {
											 if(index === 0) return;
											 
											 trendon.callAPI(
													 [config],
													 trendon.trnd.setParameter
											 );
										 }) 
										
										 trendon.trnd.setAllWithDate();
										 
										 $('.group_help').click();  // 안내박스 닫음
									},
									defaultValue:{
										'x0': new Date(OM.Date.getArr(trendon.trnd.startDate).join('-')), 
										'x1': new Date(OM.Date.getArr(trendon.trnd.endDate).join('-'))
									},
									title: ["거래금액(원)", "유동인구(명)"],
									standards: {'month': trendon.trnd.maxPeriod}
								});
								
								trendon.trnd.charts[fn['domId'] + '-' + fn['chartId']] = chart;
							}
						}
					},
					map: null
				},
				
				// 1. 지역별 거래금액(지도포함)
				{
					name: '1. 지역별 거래금액',
					data: {
						message: '데이터',
						domId: 'layout1',
						path: '/onmap/ecnmy_trnd/ecnmy_trnd_amt_text.json',
						params: {
							ctyCd: null,
							startDate: null,
							endDate: null,
							limitCnt: 3
						},
						callback: function() {
							var fn = this;
							return function(result) {
									
								var data1= result['amtTotal'];
								var data2 = result['amtRankList'];
								var dataType1 = '-';
								var dataType2 = '';
								var dataType3 = [];
								var unit = '원';
								
								if(data1) {
									dataType1 = OM.Comm.numToKR(data1);
									dataType2 = dataType1[1] + unit; 
								}
								
								trendon.linkData('leftLayoutType1', {
									dataType1: dataType1[0],
									dataType2: dataType2
								}, fn['domId']);
								
								if(!data2 || data2.length === 0) {
									trendon.noData.show(fn['domId'], 'dataTable');
									return;
								} 
								
								data2.map(function(item) {
									var tmpValue = OM.Comm.numToKR(item['sale_amt']);
									
									dataType3.push({
										data1: item['admi_nm'],
										data2: tmpValue[0],
										data3: tmpValue[1] + unit
									})
								});
								
								trendon.linkData('leftLayoutType2', dataType3, fn['domId']);
							}
						}
					},
					graph : null,
					map: {
						message: '지도',
						subMessage: '1. 지역별 거래금액-지도매핑',
						domId: 'layout1',
						mapId: 'map1',
						path: '/onmap/ecnmy_trnd/getTrndMap.json',
						params: {
							ctyCd: null,
							startDate : null,
							endDate : null,
							rgnClss: null
						},
						callback: function() {
							var fn = this;
							return function(result, params) {
								trendon.draw('map', result, {
									id: 'id',
									url: '/onmap/ecnmy_trnd/salamt.json',
									params: params,
									domId: fn['domId'],
									mapId: fn['mapId'],
									subMsg: fn['subMessage'],
									unit: '원',
									title: '지역별 거래금액',
									nmKey: 'admi_nm',
									valueKey: 'sale_amt',
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
											    return layer.feature.properties['id'] === trendon.trnd.ctyCd;
											})[0];
											
											if(!layer) return;
											
											layer.bringToFront();
										}
									}
								})
							}
						}
					}
				},
				
				// 2. 지역별 유동인구 수(지도포함)
				{
					name: '2. 지역별 유동인구 수',
					data : {
						message: '데이터',
						domId: 'layout2',
						path: '/onmap/ecnmy_trnd/ecnmy_trnd_float_txt.json',
						params: {
							ctyCd : null,
							startDate : null,
							endDate : null
						},
						callback: function() {
							var fn = this;
							return function(result) {
							    	
						    	var data1= result['total'];
								var data2 = result['rankList'];
								var dataType1 = null;
								var dataType2 = null;
								var dataType3 = [];
								var unit = '명';
								
								if(data1) {
									dataType1 = OM.Comm.numToKR(data1);
									dataType2 = dataType1[1] + unit; 
								} else {
									dataType1 = '-';
									dataType2 = '';
								}
								
								trendon.linkData('leftLayoutType1', {
									dataType1: dataType1[0],
									dataType2: dataType2
								}, fn['domId']);
								
								if(!data2 || data2.length === 0) {
									trendon.noData.show(fn['domId'], 'dataTable');
									return;
								} 
								
								data2.map(function(item) {
									var tmpValue = OM.Comm.numToKR(item['cnt']);
									
									dataType3.push({
										data1: item['admi_nm'],
										data2: tmpValue[0],
										data3: tmpValue[1] + unit
									})
								});
								
								trendon.linkData('leftLayoutType2', dataType3, fn['domId']);
						    };
						}
					},
					graph : null,
					map: {
						message: '지도',
						subMessage: '2. 지역별 유동인구 수-지도매핑',
						domId: 'layout2',
						mapId: 'map2',
						path: '/onmap/ecnmy_trnd/getTrndMap.json',
						params: {
							ctyCd: null,
							startDate : null,
							endDate : null,
							rgnClss: null
						},
						callback: function() {
							var fn = this;
							return function(result, params) {
								
								trendon.draw('map', result, {
									id: 'id',
									url: '/onmap/ecnmy_trnd/float_cnt_map.json',
									params: params,
									domId: fn['domId'],
									mapId: fn['mapId'],
									subMsg: fn['subMessage'],
									unit: '명',
									title: '지역별 유동인구 수',
									nmKey: 'admi_nm',
									valueKey: 'cnt',
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
									limitMinZoom: true
								})
							}
						}
					}
				},
			
				// 3. 성/연령별 대표인구
				{
					name: '3. 성/연령별 대표인구',
					data: {
						message: '데이터',
						domId: 'layout3',
						path: '/onmap/ecnmy_trnd/all_gender_age.json',
						params: {
							ctyCd: null,
							startDate: null,
							endDate: null
						},
						callback: function() {
							var fn = this;
							return function(result) {
					    		var dataType1 = result['floatTxt']; // 유동인구
								var dataType2 = result['amtTxt'] // 소비인구
								
								if(!dataType1) dataType1 = '-';
								if(!dataType2) dataType2 = '-';
								
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
							domId: 'layout3',
							chartId: 'chart1',
							path: '/onmap/ecnmy_trnd/all_float_list.json',
							params: {
								ctyCd: null,
								startDate: null,
								endDate: null
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
							    		title: '유동인구',
							    		groups: ["20대", "30대", "40대", "50대", "60대 이상"],
							    		colors: ['#e47677', '#54a7e8'],
										columns: ['여성', '남성'],
										images: ['/images/renew_v1/ic_female.png', '/images/renew_v1/ic_male.png'],
										unit: '%'
							    	})
								};
							}
						},
						{
							message: '카드사 그래프',
							domId: 'layout3',
							chartId: 'chart2',
							path: '/onmap/ecnmy_trnd/all_sale_list.json',
							params: {
								ctyCd: null,
								startDate: null,
								endDate: null
							},
							callback: function() {
								var fn = this;
								return	function(result) {
										
									trendon.draw('grouped-bar', result['lsit'], {
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
							    		groups: ["20대", "30대", "40대", "50대", "60대 이상"],
							    		colors: ['#e47677', '#54a7e8'],
										columns: ['여성', '남성'],
										images: ['/images/renew_v1/ic_female.png', '/images/renew_v1/ic_male.png'],
										unit: '%'
							    	})
								};
							}
						}
					],
					map: null
				},
				
				// 4. 업종별 거래금액
				{
					name: '4. 업종별 거래금액',
					data : {
						message: '데이터',
						domId: 'layout4',
						path: '/onmap/ecnmy_trnd/upjong_amt_list.json',
						params: {
							ctyCd : null,
							startDate : null,
							endDate : null,
							limitCnt: 3
						},
						callback: function() {
							var fn = this;
							return function(result) {
							    	
						    	var data1= result['list'][0]['cd_nm'];
								var data2 = result['list'];
								var dataType1 = data1;
								var dataType2 = [];
								var unit = '원';
								
								if(!data1) dataType1 = '-';
								
								trendon.linkData('leftLayoutType1', {
									dataType1: dataType1,
								}, fn['domId']);
								
								if(!data2 || data2.length === 0) {
									trendon.noData.show(fn['domId'], 'dataTable');
									return;
								} 
								
								data2.map(function(item) {
									var tmpValue = OM.Comm.numToKR(item['sale_amt']);
									
									dataType2.push({
										data1: item['cd_nm'],
										data2: tmpValue[0],
										data3: tmpValue[1] + unit
									})
								});
								
								trendon.linkData('leftLayoutType2', dataType2, fn['domId']);
						    };
						}
					},
					graph: {
						message: '그래프(수정안함)',
						domId: 'layout4',
						chartId: 'chart1',
						path: '/onmap/ecnmy_trnd/ecnmy_trnd_amt_chart.json',
						params: { 
							ctyCd : null,
							startDate : null,
							endDate : null
						},
						callback: function() {
							var fn = this;
							return function(result) {
							    	
					    		var data = result.indutyList;
					    		
								if(!data || data.length === 0) {
									trendon.noData.show(fn['domId'], fn['chartId']);
						    		return;
								}
								
								var cleanData =[];
								
								data.map(function(item) {
									cleanData.push({
										color: item['upjong1_cd'],
										code: item['upjong1_nm'],
										name: item['cd_nm'],
										value: item['sale_amt'],
										id: item['upjong2_cd']
									})
								});
								
								OM.Chart.treemap(cleanData, {
										domId: fn['domId'],
										chartId: fn['chartId'],
										background: 'transparent'
									}
								);
						    };
						}
					},
					map: null
				},
				
				// 5. 유입 소비인구 거래금액(지도포함)
				{
					name: '5. 유입 소비인구 거래금액',
					data : {
						message: '데이터',
						domId: 'layout5',
						path: '/onmap/ecnmy_trnd/inflow_amt_txt.json',
						params: {
							ctyCd : null,
							startDate : null,
							endDate : null,
							limitCnt: 3
						},
						callback: function() {
							var fn = this;
							return function(result) {
							    	
						    	var data1= result['amtTxt'];
								var data2 = result['list'];
								var dataType1 = null;
								var dataType2 = null;
								var dataType3 = [];
								var unit = '원';
								
								if(data1) {
									dataType1 = OM.Comm.numToKR(data1);
									dataType2 = dataType1[1] + unit; 
								} else {
									dataType1 = '-';
									dataType2 = '';
								}
								
								trendon.linkData('leftLayoutType1', {
									dataType1: dataType1[0],
									dataType2: dataType2
								}, fn['domId']);
								
								if(!data2 || data2.length === 0) {
									trendon.noData.show(fn['domId'], 'dataTable');
									return;
								} 
								
								data2.map(function(item) {
									var tmpValue = OM.Comm.numToKR(item['sale_amt']);
									
									dataType3.push({
										data1: item['nm'],
										data2: tmpValue[0],
										data3: tmpValue[1] + unit
									})
								});
								
								trendon.linkData('leftLayoutType2', dataType3, fn['domId']);
						    };
						}
					},
					graph : null,
					map: {
						message: '지도',
						subMessage: '5. 유입 소비인구 거래금액 - 지도매핑',
						domId: 'layout5',
						mapId: 'map3',
						path: '/onmap/ecnmy_trnd/getTrndMap.json',
						params: {
							ctyCd: null,
							startDate : null,
							endDate : null,
							rgnClss: null
						},
						callback: function() {
							var fn = this;
							return function(result, params) {
								trendon.draw('map', result, {
									id: 'id',
									url: '/onmap/ecnmy_trnd/visitr_expndtr.json',
									params: params,
									domId: fn['domId'],
									mapId: fn['mapId'],
									subMsg: fn['subMessage'],
									unit: '원',
									title: '유입 소비인구 거래금액',
									nmKey: 'nm',
									valueKey: 'sale_amt',
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
									limitMinZoom: true
								})
							}
						}
					}
				},
				
				// 6. 유입 유동인구수(지도포함)
				{
					name: '6. 유입 유동인구수',
					data : {
						message: '데이터',
						domId: 'layout6',
						path: '/onmap/ecnmy_trnd/inflow_float_txt.json',
						params: {
							ctyCd : null,
							startDate : null,
							endDate : null
						},
						callback: function() {
							var fn = this;
							return function(result) {
							    	
						    	var data1= result['fltTxt'];
								var data2 = result['list'];
								var dataType1 = null;
								var dataType2 = null;
								var dataType3 = [];
								var unit = '명';
								
								if(data1) {
									dataType1 = OM.Comm.numToKR(data1);
									dataType2 = dataType1[1] + unit; 
								} else {
									dataType1 = '-';
									dataType2 = '';
								}
								
								trendon.linkData('leftLayoutType1', {
									dataType1: dataType1[0],
									dataType2: dataType2
								}, fn['domId']);
								
								if(!data2 || data2.length === 0) {
									trendon.noData.show(fn['domId'], 'dataTable');
									return;
								} 
								
								data2.map(function(item) {
									var tmpValue = OM.Comm.numToKR(item['total_cnt']);
									
									dataType3.push({
										data1: item['nm'],
										data2: tmpValue[0],
										data3: tmpValue[1] + unit
									})
								});
								
								trendon.linkData('leftLayoutType2', dataType3, fn['domId']);
						    };
						}
					},
					graph : null,
					map: {
						message: '지도',
						subMessage: '6. 유입 유동인구수-지도매핑',
						domId: 'layout6',
						mapId: 'map4',
						path: '/onmap/ecnmy_trnd/getTrndMap.json',
						params: {
							ctyCd: null,
							startDate : null,
							endDate : null,
							rgnClss: null
						},
						callback: function() {
							var fn = this;
							return function(result, params) {
								trendon.draw('map', result, {
									url: '/onmap/ecnmy_trnd/inflow_float_map.json',
									params: params,
									domId: fn['domId'],
									mapId: fn['mapId'],
									subMsg: fn['subMessage'],
									unit: '명',
									title: '유입 유동인구 수',
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
									limitMinZoom: true
								})
							}
						}
					}
				},
				
				// 7. 유입인구 성/연령 특성
				{
					name: '7. 유입인구 성/연령 특성',
					data: {
						message: '데이터',
						domId: 'layout7',
						path: '/onmap/ecnmy_trnd/inflow_gender_age.json',
						params: {
							ctyCd: null,
							startDate: null,
							endDate: null
						},
						callback: function() {
							var fn = this;
							return function(result) {
							    	
					    		var dataType1 = result['floatTxt']; // 유입 유동인구
								var dataType2 = result['amtTxt'] // 유입 소비인구
								
								if(!dataType1) dataType1 = '-';
								if(!dataType2) dataType2 = '-';
								
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
							domId: 'layout7',
							chartId: 'chart1',
							path: '/onmap/ecnmy_trnd/inflow_float_list.json',
							params: {
								ctyCd: null,
								startDate: null,
								endDate: null
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
							    		title: '유입 유동인구',
							    		groups: ["20대", "30대", "40대", "50대", "60대 이상"],
							    		colors: ['#e47677', '#54a7e8'],
										columns: ['여성', '남성'],
										images: ['/images/renew_v1/ic_female.png', '/images/renew_v1/ic_male.png'],
										unit: '%'
							    	})
								};
							}
						},
						{
							message: '카드사 그래프',
							domId: 'layout7',
							chartId: 'chart2',
							path: '/onmap/ecnmy_trnd/inflow_sale_list.json',
							params: {
								ctyCd: null,
								startDate: null,
								endDate: null
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
							    		title: '유입 소비인구',
							    		groups: ["20대", "30대", "40대", "50대", "60대 이상"],
							    		colors: ['#e47677', '#54a7e8'],
										columns: ['여성', '남성'],
										images: ['/images/renew_v1/ic_female.png', '/images/renew_v1/ic_male.png'],
										unit: '%'
							    	})
								};
							}
						}
					],
					map: null
				},
				
				// 8. 유입 소비인구 소비특성
				{
					name: '8. 유입 소비인구 소비특성',
					data: {
						message: '데이터',
						domId: 'layout8',
						path: '/onmap/ecnmy_trnd/ecnmy_trnd_expndtr_chart.json',
						params: {
							ctyCd: null,
							startDate: null,
							endDate: null
						},
						callback: function() {
							var fn = this;
							return function(result) {
							    	
					    		var data1 = result['mostCommonList'] ? result['mostCommonList'][0] : {}; // 활성업종 1위
								var data2 = result['mostSpecializedList'] ? result['mostSpecializedList'][0] : {}// 특화업종 1위
								
								trendon.linkData('leftLayoutType1', {
									dataType1: data1['cd_nm'] ? data1['cd_nm'] : '-',
									dataType2: data1['sale_amt'] ? OM.Comm.numToKR(data1['sale_amt'])[0] : 0,
									dataType3: data1['sale_amt'] ? OM.Comm.numToKR(data1['sale_amt'])[1] + '원' : 0,
									dataType4: data2['cd_nm'] ? data2['cd_nm'] : '-', // 주요 방문시간
									dataType5: data2['rate'] ? data2['rate'] : 0
								}, fn['domId']);
						    }
						}
					},
					graph: {
						message: '그래프(수정안함)',
						domId: 'layout8',
						chartId: ['chart1', 'chart2'],
						path: '/onmap/ecnmy_trnd/ecnmy_trnd_expndtr_chart.json',
						params: {
							ctyCd: null,
							startDate: null,
							endDate: null
						},
						callback: function() {
							var fn = this;
							return function(result) {
							    	
								Object.keys(result).map(function(key, index) {
									var options = {};
									
									if(key === 'mostCommonList') {
										options = {
											domId: fn['domId'],
											chartId: fn.chartId[0],
											name: 'cd_nm',
											value: 'sale_amt',
											color: '#fe8d75',
											x: '소비 금액',
											y: '업종',
											background: '#f8f8f8',
											format: function(value) { return OM.Comm.numToKR(value).join('') + '원' }
										}
									} else {
										options = {
											domId: fn['domId'],
											chartId: fn.chartId[1],
											name: 'cd_nm',
											value: 'rate',
											color: '#fe8d75',
											x: '소비 특화지수',
											y: '업종',
											background: '#f8f8f8',
											unit: {"form":"index","length":0}
										}
									}
									 
									trendon.draw('horizontal-bar', result[key], options)
								});
							}
						}
					},
					map: null
				},
				
				// 9. 유입인구 시간대 특성
				{
					name: '9. 유입인구 시간대 특성',
					data: {
						message: '데이터',
						domId: 'layout9',
						path: '/onmap/ecnmy_trnd/inflow_float_time.json',
						params: {
							ctyCd: null,
							startDate: null,
							endDate: null
						},
						callback: function() {
							var fn = this;
							return function(result) {
					    		var dataType1 = result['floatTxt']; // 주요 방문시간
								var dataType2 = result['amtTxt'] // 주요 소비시간
								
								if(!dataType1) dataType1 = '-';
								if(!dataType2) dataType2 = '-';
								
								trendon.linkData('leftLayoutType1', {
									dataType1: dataType1,
									dataType2: dataType2,
								}, fn['domId']);
						    }
						}
					},
					graph: {
						message: '그래프',
						domId: 'layout9',
						chartId: 'chart1',
						path: '/onmap/ecnmy_trnd/inflow_time_chart.json',
						params: {
							ctyCd: null,
							startDate: null,
							endDate: null
						},
						callback: function() {
							var fn = this;
							return function(result) {
							    	
						    	trendon.draw('grouped-bar', result['list'], {
						    		domId: fn['domId'],
						    		chartId: fn['chartId'],
						    		groups: ["00-06시","06-09시","09-12시","12-15시","15-18시","18-21시","21-24시"],
									keys:  ["1", "2", "3", "4", "5", "6", "7"],
									colors: ['#2ec5c5', '#fe8d75'],
									columns: ['유입 방문시간', '유입 소비시간'],
									valueKeys: ['inflow_rate', 'sale_rate'],
									unit: '%',
									format: function(d) { return d.toFixed(1); },
									cleanVersion: '2',
									groupKey: 'timezon_cd',
									legendType: 'text',
									margin: {
										top: 40,
										right: 0,
										bottom: 85,
										left: 70
									}
						    	})
						    }
						}
					},
					map: null
				},
				
				// 10. 유입 유동인구 유입지역(지도포함)
				{
					name: '10. 유입 유동인구 유입지역',
					data : {
						message: '데이터',
						domId: 'layout10',
						path: '/onmap/ecnmy_trnd/inflow_depart_txt.json',
						params: {
							ctyCd : null,
							startDate : null,
							endDate : null
						},
						callback: function() {
							var fn = this;
							return function(result) {
							    	
						    	var data1= result['inflowTxt'];
								var data2 = result['list'];
								var dataType1 = data1;
								var dataType2 = null;
								var dataType3 = [];
								var unit = '명';
								
								if(!data1) {
									dataType1 = '-';
								}
								
								trendon.linkData('leftLayoutType1', {
									dataType1: dataType1
								}, fn['domId']);
								
								if(!data2 || data2.length === 0) {
									trendon.noData.show(fn['domId'], 'dataTable');
									return;
								} 
								
								data2.map(function(item) {
									var tmpValue = OM.Comm.numToKR(item['in_cnt']);
									
									dataType3.push({
										data1: item['nm'],
										data2: item['in_cnt'] > 100 ? tmpValue[0] : '100',
										data3: item['in_cnt'] > 100 ? tmpValue[1] + unit : '명 이하'
									})
								});
								
								trendon.linkData('leftLayoutType2', dataType3, fn['domId']);
						    }
						}
					},
					graph : null,
					map: {
						message: '지도',
						subMessage: '10. 유입 유동인구 유입지역 - 지도매핑',
						domId: 'layout10',
						mapId: 'map5',
						path: '/onmap/ecnmy_trnd/getTrndCtyMap.json',
						params: {
							layerName: null,
							ctyCd: null,
							startDate : null,
							endDate : null,
							rgnClss: 'H3'
						},
						callback: function() {
							var fn = this;
							return function(result, params) {
								
								result['features'].sort(function(a, b) {
							        return a.properties['id'] === trendon.trnd.ctyCd ? 1 : -1; 
								});
								
								trendon.draw('map', result, {
									url: '/onmap/ecnmy_trnd/inflow_depart_map.json',
									params: params,
									domId: fn['domId'],
									mapId: fn['mapId'],
									subMsg: fn['subMessage'],
									unit: '명',
									title: '유입 유동인구 유입지역',
									valueKey: 'in_cnt',
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
									mapType: '2',
									callback: {
										mouseout: function(layers) {
											var layer = layers.getLayers().filter(function(layer) {     
											    return layer.feature.properties['id'] === trendon.trnd['ctyCd'];
											})[0];
											
											if(!layer) return;
											
											layer.bringToFront();
											
											layer.setStyle({
												fillColor: '#fff',
												weight : 3,
												color: '#000'
											});
										},
										style: function(feature, style, data) {
											// 지역 리스트 중 가장 첫 번째 지역을 강조하는 스타일
											if(feature.properties['id'] === trendon.trnd['ctyCd']) {
												style.fillColor = '#fff';
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
				}
			]
			
			return index === -1 ? configs : [configs[index]];
		},
		
		sectionFunc : {
			"firstPage" : {
				"status" : false,
				"lastValue" : "test",
				"action" : function() {
					// top 그래프 값이 변경됐을 경우에만 함수 처리하기
					
					// 선택기간이 기존과 같은 경우 실행 안함
					if(this.lastValue == trendon.trnd['startDate']+":"+trendon.trnd['endDate']){
						return;
					}
					// 1. 지역별 거래금액(지도)
					trendon.callAPI(
						trendon.trnd.getConfig(1),
						trendon.trnd.setParameter
					);
					// 2. 지역별 유동인구수(지도)
					trendon.callAPI(
						trendon.trnd.getConfig(2),
						trendon.trnd.setParameter
					);
					// 3. 성/연령별 대표인구
					trendon.callAPI(
						trendon.trnd.getConfig(3),
						trendon.trnd.setParameter
					);
					// 4. 업종별 거래금액 
					trendon.callAPI(
						trendon.trnd.getConfig(4),
						trendon.trnd.setParameter
					);
					
					// 선택 기간 저장
					this.lastValue = trendon.trnd['startDate']+":"+trendon.trnd['endDate'];
				}
			},
			"secondPage" : {
				"status" : false,
				"lastValue" : "test",
				"action" : function() {
					// top 그래프 값이 변경됐을 경우에만 함수 처리하기
					// 선택기간이 기존과 같은 경우 실행 안함
					if(this.lastValue == trendon.trnd['startDate']+":"+trendon.trnd['endDate']){
						return;
					}
					// 5. 유입 소비인구 거래금액(지도)
					trendon.callAPI(
						trendon.trnd.getConfig(5),
						trendon.trnd.setParameter
					);
					// 6. 유입 유동인구 수 (지도)
					trendon.callAPI(
						trendon.trnd.getConfig(6),
						trendon.trnd.setParameter
					);
					// 7. 유입인구 성/연령 특성 
					trendon.callAPI(
						trendon.trnd.getConfig(7),
						trendon.trnd.setParameter
					);
					// 8. 유입 소비인구 소비특성
					trendon.callAPI(
						trendon.trnd.getConfig(8),
						trendon.trnd.setParameter
					);
					
					// 선택 기간 저장
					this.lastValue = trendon.trnd['startDate']+":"+trendon.trnd['endDate'];
				}
			},
			"thirdPage" : {
				"status" : false,
				"lastValue" : "test",
				"action" : function() {
					// top 그래프 값이 변경됐을 경우에만 함수 처리하기
					// 선택기간이 기존과 같은 경우 실행 안함
					if(this.lastValue == trendon.trnd['startDate']+":"+trendon.trnd['endDate']){
						return;
					}
					// 9. 유입인구 시간대 특성
					trendon.callAPI(
						trendon.trnd.getConfig(9),
						trendon.trnd.setParameter
					);
					// 10. 유입 유동인구 유입지역(지도) 
					trendon.callAPI(
						trendon.trnd.getConfig(10),
						trendon.trnd.setParameter
					);
					
					// 선택 기간 저장
					this.lastValue = trendon.trnd['startDate']+":"+trendon.trnd['endDate'];
				}
			}
		}
}