/**
 * @description 이벤트효과 설정값 
 * @descriptor 김용현
 * @date 2020.08.19
 */

if(!trendon) var trendon= {};

trendon.effect = {
		
	lastAnchorLink: 'firstPage',	// 현재 화면이 위치한 영역명
	admiCd: null,  // 행정동 코드
	ctyCd: null, // 시군구 코드 
	megaCd: null, // 시도 코드
	serviceClss: null, // 서비스 코드
	startDate: null, // 선택기간 시작일자
	endDate: null, // 선택기간 종료일자
	lastStartDate: null, // 비교기간 시작일자
	lastEndDate: null,  // 비교기간 종료일자
	minStdrDate: null, // 데이터존재 시작일자
	maxStdrDate: null, // 데이터존재 마지막일자
	rgnClss: null, // 행정구역 코드
	admiAround: null, // 주변지역 코드
	admiFlg: null, // 0: 면, 1: 읍/동
	charts: {},
	
	/**
	 * @description 기관과 관련된 모든 데이터 설정
	 */
	setAllWithDate: function() {
		var minStdrDate = OM.Date.getArr(trendon.effect.minStdrDate); // 데이터기준 시작일자 
		var maxStdrDate = OM.Date.getArr(trendon.effect.maxStdrDate); // 데이터기준 종료일자
		var lastStartDate = OM.Date.getArr(trendon.effect.lastStartDate);  // 비교기간 시작일자
		var lastEndDate = OM.Date.getArr(trendon.effect.lastEndDate); // 비교기간 종료일자
		var startDate = OM.Date.getArr(trendon.effect.startDate); // 선택기간 시작일자
		var endDate = OM.Date.getArr(trendon.effect.endDate); // 선택기간 죵료일자
		
		// 가이드 박스 기간 텍스트 설정
		$("#dateWarn").text([minStdrDate[0], "년 ", minStdrDate[1], "월", " ~ ", maxStdrDate[0], "년 ", maxStdrDate[1], "월"].join(''));
		
		// 기간 텍스트 설정
		$(".search_period").text(startDate.join('. ') + " ~ " + endDate.join('. '));
		
		// 기간 텍스트 설정(팝업)
		$("#standard_period").text([minStdrDate[0], "년 ", minStdrDate[1], "월", " ~ ", maxStdrDate[0], "년 ", maxStdrDate[1], "월"].join(''));
		
		// 현재 선택된 날짜의 일년전 날짜 출력(팝업)
		$("#popSelectedLast").text(lastStartDate.join('. ') + ' ~ ' + lastEndDate.join('. '));
		
		// 현재 선택된 날짜 출력(팝업)
		$("#popSelectedThis").text(startDate.join('. ') + ' ~ ' + endDate.join('. '));
		
		// 비교 기간 dateRangePicker 업데이트(팝업)
		$("#sDatepicker").data('dateRangePicker').setStart([startDate[0] - 1, startDate[1], startDate[2]].join(''));
		$("#sDatepicker").data('dateRangePicker').setEnd([endDate[0] - 1, endDate[1], endDate[2]].join(''));
		
		// 선택 기간  dateRangePicker 업데이트(팝업)
		$("#eDatepicker").data('dateRangePicker').setStart(startDate.join('-'));
		$("#eDatepicker").data('dateRangePicker').setEnd(endDate.join('-'));
	},
	
	/**
	 * @description daterangepicker 설정
	 */
	createDateRangePicker: function() {
		
		var minStdrDateArr = OM.Date.getArr(trendon.effect.minStdrDate);
		var maxStdrDateArr = OM.Date.getArr(trendon.effect.maxStdrDate);
		
		// 비교기간
		var sDatepicker = $("#sDatepicker").dateRangePicker({
			inline: true,
			container: '#sDatepicker',
			language: 'ko',
			format : "YYYY. MM. DD" ,
			separator: ' ~ ',
			startDate: [minStdrDateArr[0] - 1, minStdrDateArr[1], minStdrDateArr[2]].join(''),
			endDate: [maxStdrDateArr[0] - 1, maxStdrDateArr[1], maxStdrDateArr[2]].join(''),
			singleMonth: true,
			alwaysOpen: true ,
			showTopbar: false,
			autoClose: true,
			minDays: 3,
			maxDays: 93,
			customArrowPrevSymbol: "<img src='/images/board/calendar_btn_prev.gif' />",
			customArrowNextSymbol: "<img src='/images/board/calendar_btn_next.gif' />",
			hoveringTooltip: false, // tooltip 사용여부
			getValue:function() { return $("#popSelectedLast").text(); },
			setValue:function(s, s1, s2){ $('#popSelectedLast').text(s); }
		});
		
		// 선택 기간
		var eDatepicker = $("#eDatepicker").dateRangePicker({
			inline: true,
			container: '#eDatepicker', 
			language: 'ko',
			format : "YYYY. MM. DD" ,
			separator: ' ~ ',
			startDate: trendon.effect.minStdrDate,
			endDate: trendon.effect.maxStdrDate,
			singleMonth: true,
			alwaysOpen:true ,
			showTopbar: false,
			autoClose: true,
			minDays: 3,
			maxDays: 93,
			customArrowPrevSymbol: "<img src='/images/board/calendar_btn_prev.gif' />",
			customArrowNextSymbol: "<img src='/images/board/calendar_btn_next.gif' />",
			hoveringTooltip: false, // tooltip 사용여부
			getValue:function(){ return $('.search_period').text(); },
			setValue:function(s, s1, s2){
				$('#popSelectedThis').text(s);
				$("#sDatepicker").data('dateRangePicker').setMaxDate(moment(s1,"YYYY-MM-DD").subtract(1,'days'));
			}
		});
	},
	
	clickPeriod: function() {
		var compareDate = $('#popSelectedLast').text().replace(/ /gi, "").split('~');
		var selectDate = $('#popSelectedThis').text().replace(/ /gi, "").split('~');
		var chart = trendon.effect.charts["layout0-dateRange"];
		
		trendon.effect.lastStartDate = compareDate[0].split('.').join('');  // 비교기간 시작일자
		trendon.effect.lastEndDate = compareDate[1].split('.').join(''); // 비교기간 종료일자
		trendon.effect.startDate = selectDate[0].split('.').join(''); // 선택기간 시작일자
		trendon.effect.endDate = selectDate[1].split('.').join(''); // 선택기간 죵료일자
		
		this.setAllWithDate();

		trendon.effect.triggerDraw();
		
		trendon.closeDate();
		
		chart.update(new Date(selectDate[0].split('.').join('-')), new Date(selectDate[1].split('.').join('-')));
	},
	
	/**
	 * @description 행정동 콤보박스 리스트 클릭 이벤트
	 * @param event
	 * @param domId
	 * @returns
	 */
	clickComboBoxAdmiList: function(event, domId) {
		
		var dom = $(domId);
		var code = event.target.getAttribute('code');
		var text = event.target.textContent;
		
		dom.find('li.selected').removeClass('selected');
		
		$(event.target).addClass('selected');
		
		trendon.clickComboBox(domId);
		dom.find('.name').text(text);
		
		trendon.effect.admiNm = text ? text : '';
		trendon.effect.admiCd = code ? code : null;
		
		this.triggerDraw();
		this.setAdmiFlag();
		
		// 전체보기 버튼으로 초기화
		trendon.clickTimeserires('all');
		
		// 시계열 그래프 가져오기
		trendon.callAPI(
			trendon.effect.getConfig(0),
			trendon.effect.setParameter
		);
		
		this.setRegionNm(text);
	},
	
	/**
	 * @description real call wrapping function
	 */
	triggerDraw: function() {
		
		var secFunc = trendon.effect.sectionFunc[trendon.effect['lastAnchorLink']];
		
		if(trendon.effect['lastAnchorLink'] === 'firstPage') {
			trendon.effect.setAdmiAround(secFunc.action);
		} else {
			secFunc.action();
		}
	},
	
	/**
	 * @description set Administrative building name
	 */
	setRegionNm: function(name) {
		if(!name) name = '';
		
		$('.admiNm').text(name);
	},

	/**
	 * @description 주변지역 경제효과 지도 콤보박스 리스트 클릭 이벤트
	 * @param event
	 * @param domId
	 * @returns
	 */
	clickComboBoxMap: function(event, domId) {
		var dom = $(domId);
		var code = event.target.getAttribute('code');
		var text = event.target.textContent;
		
		dom.find('li.selected').removeClass('selected');
		
		$(event.target).addClass('selected');
		
		trendon.clickComboBox(domId);
		dom.find('.name').text(text);
		
		trendon.callAPI(
			trendon.effect.getConfig(3),
			trendon.effect.setParameter,
			['map']
		);
	},

	// event to click PDF button
	clickToPDF: function() {
		
//		if(event_config.pageError || !event_config.validateChk.result1){
//			alert("기간 혹은 지역을 변경 후 다시 선택해주세요.");
//			return false;
//		}
		
//		loadingShow('fog');
		
		startDate: 20200623
		endDate: 20200628
		lastStartDate: 20200601
		lastEndDate: 20200605
		admiAround: '47170250','47170510','47170555','47170585','47170360','47170370','47170600','47170650','47170660'
		admiCd: 47170690
		
		var fileNm = '';
		
		// 행정동이 "동/읍"일 경우
		if(trendon.effect.admiFlg === 1) {
			fileNm = '/event_effect_dong/event_effect_report/event_effect_book';
		}
		
		// 행정동이 "동/읍"일 경우 (업종예외)
		if(trendon.effect.admiFlg === 1 && trendon.effect.upjongList < 4) {
			fileNm = '/event_effect_dong/event_effect_report_excl02/event_effect_book';
		}
		
		// 행정동이 "면"일 경우
		if(trendon.effect.admiFlg === 0) {			
			fileNm = '/event_effect_small/event_effect_report/event_effect_book';
		}
		
		// 행정동이 "면"일 경우 (업종예외)
		if(trendon.effect.admiFlg === 0 && trendon.effect.upjongList < 4) {
			fileNm = '/event_effect_small/event_effect_report_excl02/event_effect_book';
		}
		
		trendon.openPDF({
			fileNm: fileNm,
			dataId:  "rpt-new-evntEff",
			ctyCd: trendon.effect.ctyCd,
			h3Cd:  trendon.effect.ctyCd,
			userNo: null,
			startDate: trendon.effect.startDate,
			endDate: trendon.effect.endDate,
			lastStartDate:  trendon.effect.lastStartDate,
			lastEndDate: trendon.effect.lastEndDate,
			admiAround: trendon.effect.admiAround,
			admiCd:  trendon.effect.admiCd
		})
	},
	
	/**
	 * @description 데이터 유효성 검사
	 */
	validation: function(parentCallback) {
		var path = '/onmap/event_effect/validateChk.json';
		var params = {
			ctyCd: this.ctyCd,
			admiCd: this.admiCd,
			startDate: this.startDate,
			endDate: this.endDate,
			rgnClss: this.rgnClss,
			admiAround: this.admiAround,
			admiFlg: this.admiFlg
		};
		var consoleMsg = '데이터유효성 검증';
		
		var callback = {
		    beforeSend: function() {},
		    complete: function() {},
		    success: function(result) {
		    	
	    		var data1 = result.thisAmtChnge ? result.thisAmtChnge : {};
				var data2 = result.thisList;
				var data3 = result.visitrTotal ? result.visitrTotal : 0;
				
				// 리스트 수 저장
				trendon.effect.upjongList = result.thisList.length;
				
				// 총경제효과의 평상시 일평균이 10만원 미만일 경우
				// 이벤트기간의 일평균이 10만원 미만일 경우
				// 유입인구 수가 100명보다 작을 경우
				if(data1.days_rate < 100000 || data1.term < 100000) {
//					if(data1.days_rate < 100000 || data1.term < 100000 || result.visitrTotal < 100) {
					$("#dataLack").show();
					$("body").css({"overflow" : "hidden"});
				
					return false;
				}else{
					$("#dataLack").css("display","");
					$("body").css({"overflow" : "auto"});
				}
					
				// 업종별 경제효과의 그래프의 업종수가 4개 미만일 경우
				if(result.thisList.length < 4) {
					$('#layout6').css('display', 'none');
				} else {
					$('#layout6').css('display', 'block');
				}
				
				if(parentCallback) parentCallback();
		    }
		}
		
		OM.Comm.getData(path, params, callback, consoleMsg);
	},
	
	/**
	 * @description 동/읍, 면 구분값 설정
	 */
	setAdmiFlag: function() {
		
		var that = this;
		var path = '/onmap/event_effect/getAdmiFlg.json';
		var params = {
			admiCd: this.admiCd
		};
		var consoleMsg = '동/읍 , 면 구분값';
		var callback = {
		    beforeSend: function() {},
		    complete: function() {},
		    success: function(result) {
		    	that.admiFlg = result;  // 동/읍 , 면 구분값 설정 
//	    		that.validation()
		    }
		}
		
		OM.Comm.getData(path, params, callback, consoleMsg);
	},
	
	/**
	 * @description 주변 행정지역코드 설정
	 */
	setAdmiAround: function(callback, startIndex) {
		if(!startIndex) startIndex = 0;
		var path = '/onmap/event_effect/getAdmiList.json';
		var params = {
			ctyCd: this.ctyCd,
			admiCd: this.admiCd
		};
		var consoleMsg = '주변 행정동 리스트';
		var cb = {
		    beforeSend: function() {},
		    complete: function() {},
		    success: function(result) {
		    	
	    		trendon.effect.admiAround = result['admiAround'];   // 주변 지역코드 설정
	    		callback();
		    }
		}
		
		OM.Comm.getData(path, params, cb, consoleMsg);
	},
	
	/**
	 * @description 행정동 콤보박스 설정 
	 */
	setAdmiComboBox: function() {
		
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
		    	
	    		var html = [];
				var domId = '.section_top';
				
				result.map(function(item, index) {
					
					if(index === 0) {
						html.push('<li class="selected" code="' + item['id'] + '" onclick="trendon.effect.clickComboBoxAdmiList(event, \' ' + domId + '\')">' + item['nm'] + '</li>');
					} else {
						html.push('<li code="' + item['id'] + '" onclick="trendon.effect.clickComboBoxAdmiList(event, \' ' + domId + '\')">' + item['nm'] + '</li>');
					}
				});
				
				$(domId + ' .combo-box').empty();
				$(domId + ' .combo-box').append(html.join(''));
				$(domId + ' .name').text(result[0]['nm']);
		    }
		}
		
		OM.Comm.getData(path, params, callback, consoleMsg);
	},
	
	/**
	 * @description 서버 요청 파라미터 설정
	 */
	setParameter: function(data) {
		var tmpData = OM.Comm.deepCloneObj(data);  // 얕은 복사
		var keys = Object.keys(tmpData);
		
		keys.map(function(key) {
			var value = tmpData[key];
			
			if(key === 'megaCd' && !value) tmpData[key] = trendon.effect.megaCd;
			if(key === 'ctyCd' && !value) tmpData[key] = trendon.effect.ctyCd;
			if(key === 'admiCd' && !value) tmpData[key] = trendon.effect.admiCd;
			if(key === 'startDate' && !value) tmpData[key] = trendon.effect.startDate;
			if(key === 'endDate' && !value) tmpData[key] = trendon.effect.endDate;
			if(key === 'lastStartDate' && !value) tmpData[key] = trendon.effect.lastStartDate;
			if(key === 'lastEndDate' && !value) tmpData[key] = trendon.effect.lastEndDate;
			if(key === 'rgnClss' && !value) tmpData[key] = trendon.effect.rgnClss;
			if(key === 'admiAround' && !value) tmpData[key] = trendon.effect.admiAround;
			if(key === 'serviceClss' && !value) tmpData[key] = trendon.effect.serviceClss;
		});
		
		return tmpData;
	},
	
	/**
	 * 0. 시계열 그래프
	 * 1. 행정동 총 경제효과
	 * 2. 행정동 유동인구 변화
	 * 3. 주변지역 경제효과(지도포함)
	 * 4. 주변지역 유동인구 변화(지도포함) 
	 * 5. 성/연령별 대표인구
	 * 6. 업종별 경제효과
	 * 7. 유입 유동인구 수(지도포함)
	 * 8. 유입인구 성/연령별 특성
	 * 9. 유입인구 시간대 특성
	 * 10. 유입 유동인구 유입지역(지도포함) 
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
					path: '/onmap/event_effect/graph_data.json',
					params: {
						serviceClss: null,
						admiCd: null
					},
					callback: function() {
						var fn = this;
						return function(result) {
					    	
							var minStdrDate = OM.Date.getArr(trendon.effect.minStdrDate); // 데이터기준 시작일자 
							var maxStdrDate = OM.Date.getArr(trendon.effect.maxStdrDate); // 데이터기준 종료일자
							
							var chart = trendon.draw('timeseries', result, {
								domId: fn['domId'],
								chartId: fn['chartId'],
								minDate: new Date(minStdrDate.join('-')),
								maxDate: new Date(maxStdrDate.join('-')),
								callback: function (evt, startDate, endDate) {
									
									var startDate = OM.Date.getArr(startDate);
									var endDate = OM.Date.getArr(endDate);
									
									 trendon.effect.startDate = startDate.join('');
									 trendon.effect.endDate = endDate.join('');
									 
									 trendon.effect.triggerDraw();
									
									 trendon.effect.setAllWithDate();
									 
									 $('.group_help').click();  // 안내박스 닫음
								},
								defaultValue:{
									'x0': new Date(OM.Date.getArr(trendon.effect.startDate).join('-')), 
									'x1': new Date(OM.Date.getArr(trendon.effect.endDate).join('-'))
								},
								title: ["거래금액(원)", "유동인구(명)"],
								standards: {'month': 3}
							});
							
							trendon.effect.charts[fn['domId'] + '-' + fn['chartId']] = chart;
					    }
					}
				},
				map: null
			},
			
			// 1. 행정동 총 경제효과
			{
				name: '1. 행정동 총 경제효과',
				data: {
					message: '데이터',
					domId: 'layout1',
					path: '/onmap/event_effect/amt_chnge_txt.json',
					params: {
						admiCd: null,
						startDate: null,
						endDate: null
					},
					callback: function() {
						var fn = this;
						return function(result) {
						    	
					    	var unit = '원';
					    	var data1 = result.thisAmtChnge ? result.thisAmtChnge['rate'] : null;
					    	var data2 = result.thisAmtChnge ? result.thisAmtChnge['days_rate'] : null;
					    	var data3 = result.thisAmtChnge ? result.thisAmtChnge['term'] : null;
					    	var dataType1 = data1 ? data1 + '%' : '-';
							var dataType2 = '';
							var dataType3 = data2 ? OM.Comm.numToKR(data2).join(' ') + unit : '-';
							var dataType4 = data3 ? OM.Comm.numToKR(data3).join(' ') + unit : '-';
								
							if(data1) dataType2 = Number(data1) < 0 ? '감소' : '증가';
								
							trendon.linkData('leftLayoutType1', {
								dataType1: dataType1,
								dataType2: dataType2,
								dataType3: dataType3,
								dataType4: dataType4
							}, fn['domId']);
					    }
					}
				},
				graph: {
					message: '그래프',
					domId: 'layout1',
					chartId: 'chart1',
					path: '/onmap/event_effect/event_effect_charts.json',
					params: {
						admiCd: null,
						startDate: null,
						endDate: null,
						lastStartDate: null,
						lastEndDate: null
					},
					callback: function() {
						var fn = this;
						return function(result) {
						    	
							trendon.draw('multi-line', [
								result['thisAmtList'] ? result['thisAmtList'][0] : null,
								result['lastAmtList'] ? result['lastAmtList'][0] : null
							], {
								domId: fn['domId'],
								chartId: fn['chartId'],
								label: {
									x:"Date",
									y:"거래총액"
								},
								attributes: [
									{"name": "선택기간", "hex":"#fe8d75", "length":8, "label": "선택기간"},
									{"name": "비교기간", "hex":'#d3d3d3', "length":8, "label": "비교기간"}
				                ]
							})
					    }
					}
				}
			},
			
			// 2. 행정동 유동인구 변화
			{
				name: '2. 행정동 유동인구 변화',
				data: {
					message: '데이터',
					domId: 'layout2',
					path: '/onmap/event_effect/float_chnge_txt.json',
					params: {
						admiCd: null,
						startDate: null,
						endDate: null
					},
					callback: function(){
						var fn = this;
						return function(result) {

					    	var unit = '명';
					    	var data1 = result.thisFloat ? result.thisFloat['rate'] : null;
					    	var data2 = result.thisFloat ? result.thisFloat['days_rate'] : null;
					    	var data3 = result.thisFloat ? result.thisFloat['term'] : null;
					    	var dataType1 = data1 ? data1 + '%' : '-';
							var dataType2 = '';
							var dataType3 = data2 ? OM.Comm.numToKR(data2).join(' ') + unit : '-';
							var dataType4 = data3 ? OM.Comm.numToKR(data3).join(' ') + unit : '-';
								
							if(data1) dataType2 = Number(data1) < 0 ? '감소' : '증가';
								
							trendon.linkData('leftLayoutType1', {
								dataType1: dataType1,
								dataType2: dataType2,
								dataType3: dataType3,
								dataType4: dataType4
							}, fn['domId']);
					    }
					}
				},
				graph: {
					message: '그래프',
					domId: 'layout2',
					chartId: 'chart1',
					path: '/onmap/event_effect/float_chnge_chart.json',
					params: {
						admiCd: null,
						startDate: null,
						endDate: null,
						lastStartDate: null,
						lastEndDate: null
					},
					callback: function() {
						var fn = this;
						return function(result) {
						    	
							trendon.draw('multi-line', [
								result['thisFloatList'] ? result['thisFloatList'][0] : null,
								result['lastFloatList'] ? result['lastFloatList'][0] : null
							], {
								domId: fn['domId'],
								chartId: fn['chartId'],
								label: {
									x:"Date",
									y:"거래총액"
								},
								attributes: [
									{"name": "선택기간", "hex":"#2ec5c5", "length":8, "label": "선택기간"},
									{"name": "비교기간", "hex":'#d3d3d3', "length":8, "label": "비교기간"}
				                ]
							})
					    }
					}
				}
			},
			
			// 3. 주변지역 경제효과(지도포함)
			{
				name: '3. 주변지역 경제효과',
				data: {
					message: '데이터',
					domId: 'layout3',
					path: '/onmap/event_effect/region_amt_chnge_text.json',
					params: {
						admiCd: null,
						startDate: null,
						endDate: null,
						admiAround: null
					},
					callback: function() {
						var fn = this;
						return function(result) {
						    	
							var data1 = result.thisAmtChnge ? result.thisAmtChnge['rate'] : null;   // input - 거래금액 기준
							var data2 = result.thisCntChnge ? result.thisCntChnge['rate'] : null;  // input - 거래량 기준
							var data3 = result['mxmIncrsAmt'];         // input - 거래금액 기준 주변지역 경제효과 비교 리스트
							var data4 = result['mxmIncrsRate'];        // input - 거래량 기준 주변지역 경제효과 비교 리스트
							var dataType1= data1 ? [OM.Comm.addSign(data1), data1, unit].join('') : '-';  // output - 거래금액 기준
							var dataType2 = data2 ? [OM.Comm.addSign(data2), data2, unit].join('') : '-'; // output - 거래량 기준
							var dataType3 = [];  // output - 거래금액 기준 주변지역 경제효과 비교 리스트
							var dataType4 = [];  // output - 거래량 기준 주변지역 경제효과 비교 리스트
							var unit = '%';
							
							trendon.linkData('leftLayoutType1', {
								dataType1: dataType1 + unit,
								dataType2: dataType2 + unit
							}, fn['domId']);
							
							if(!data3 || data3.length === 0) {
								trendon.noData.show('layout3-table1', 'dataTable');
							} else {
								
								data3.map(function(item) {
									var tmpValue = OM.Comm.numToKR(item['rate']);
									
									dataType3.push({
										data1: item['nm'],
										data2: [OM.Comm.addSign(tmpValue[0]), tmpValue[0]].join(''),
										data3: tmpValue[1] + '%'
									})
								});
								
								trendon.linkData('leftLayoutType2', dataType3, 'layout3-table1');
							}
							
							if(!data4 || data4.length === 0) {
								trendon.noData.show('layout3-table2', 'dataTable');
							} else {
								
								data4.map(function(item) {
									var tmpValue = OM.Comm.numToKR(item['rate']);
									
									dataType4.push({
										data1: item['nm'],
										data2: [OM.Comm.addSign(tmpValue[0]), tmpValue[0]].join(''),
										data3: tmpValue[1] + '%'
									})
								});
								
								trendon.linkData('leftLayoutType2', dataType4, 'layout3-table2');
							}
					    }
					}
				},
				graph : null,
				map: {
					message: '지도',
					subMessage: '주변지역 경제효과 - 지도매핑',
					domId: 'layout3',
					mapId: 'map1',
					path: '/onmap/event_effect/getEventMap.json',
					params: {
						ctyCd: null,
						admiCd: null,
						startDate : null,
						endDate : null,
						rgnClss: null,
						admiAround: null
					},
					callback: function() {
						var fn = this;
						return function(result, params) {

							result['features'].sort(function(a, b) {
						        return a.properties['id'] === trendon.effect.admiCd ? 1 : -1; 
							});
							
							var baseMap = null;
							
							if(OM.Map.checkBaseMap(fn['mapId'])) {
								baseMap = OM.Map.getBaseMap(fn['mapId']);
								
								if(OM.Map.checkLayer(fn['mapId'], baseMap)) {
									var layer = OM.Map.getLayer(fn['mapId'], baseMap);
									baseMap.removeLayer(layer, baseMap);
								}
							}
							
							trendon.draw('map', result, {
								id: 'id',
								url: '/onmap/event_effect/salamt_chnge.json',
								params: params,
								domId: fn['domId'],
								mapId: fn['mapId'],
								subMsg: fn['subMessage'],
								unit: '%',
								title: '주변지역 경제효과',
								nmKey: 'nm',
								valueKey: $('#layout3 .tit.name').text() === '거래금액' ? 'rate' : 'cnt_rate',
								limitMinZoom: true,
								defaultColor: '#e0f5f6',
								colors: function(index) {
									return [
										[ '#ff5c3c'],
								        [ '#fe8e75', '#ff5c3c'],
								        [ '#fe8e75', '#ff5c3c', '#c03c25'],
								        [ '#fecec2', '#fe8e75', '#c03c25', '#67000d'],
								        [ '#fecec2', '#fe8e75', '#ff5c3c', '#c03c25', '#67000d']
								       ][index];
								},
								callback: {
									mouseout: function(layers) {
										var layer = layers.getLayers().filter(function(layer) {     
										    return layer.feature.properties['id'] === trendon.effect.admiCd;
										})[0];
										
										if(!layer) return;
										
										layer.bringToFront();
										
										layer.setStyle({
											weight : 3,
											color: '#000'
										});
									},
									style: function(feature, style, data) {
										// 지역 리스트 중 가장 첫 번째 지역을 강조하는 스타일
										if(trendon.effect.admiCd.length === 0) return;
										
										if(feature.properties['id'] === trendon.effect.admiCd) {
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
			
			// 4. 주변지역 유동인구 변화(지도포함)
			{
				name: '4. 주변지역 유동인구 변화',
				data : {
					message: '데이터',
					domId: 'layout4',
					path: '/onmap/event_effect/region_float_txt.json',
					params: {
						ctyCd: null,
						admiCd: null,
						startDate : null,
						endDate : null,
						rgnClss: null,
						admiAround: null
					},
					callback: function() {
						var fn = this;
						return function(result) {
						    	
					    	var unit = '%';
					    	var data1 = result['thisFloat'] ? result['thisFloat']['rate'] : null;
							var data2 = result['list'];
							var dataType1 = data1 ? [OM.Comm.addSign(data1), data1, unit].join('') : '-';
							var dataType2 = [];
							
							trendon.linkData('leftLayoutType1', {
								dataType1: dataType1
							}, fn['domId']);
							
							if(!data2 || data2.length === 0) {
								trendon.noData.show(fn['domId'], 'dataTable');
								return;
							} 
							
							data2.map(function(item) {
								var tmpValue = OM.Comm.numToKR(item['rate']);
								
								dataType2.push({
									data1: item['nm'],
									data2: [OM.Comm.addSign(tmpValue[0]), tmpValue[0]].join(''),
									data3: tmpValue[1] + unit
								})
							});
							
							trendon.linkData('leftLayoutType2', dataType2, fn['domId']);
					    }
					}
				},
				graph : null,
				map: {
					message: '지도',
					subMessage: '주변지역 유동인구 변화 - 지도매핑',
					domId: 'layout4',
					mapId: 'map2',
					path: '/onmap/event_effect/getEventMap.json',
					params: {
						ctyCd: null,
						admiCd: null,
						startDate : null,
						endDate : null,
						rgnClss: null,
						admiAround: null
					},
					callback: function() {
						var fn = this;
						return function(result, params) {
							
							result['features'].sort(function(a, b) {
						        return a.properties['id'] === trendon.effect.admiCd ? 1 : -1; 
							});
							
							if(OM.Map.checkBaseMap(fn['mapId'])) {
								// 기존에 map에 레이어가 존재하면 삭제하고 다시 그림
								var baseMap = OM.Map.getBaseMap(fn['mapId']);
								
								// 기존 레이어가 있을 경우 스타일 업데이트
								if(OM.Map.checkLayer(fn['mapId'], baseMap)) {
									layer = OM.Map.getLayer(fn['mapId'], baseMap);
									baseMap.removeLayer(layer);
								}
							}
							
							trendon.draw('map', result, {
								url: '/onmap/event_effect/region_float_map.json',
								params: params,
								domId: fn['domId'],
								mapId: fn['mapId'],
								subMsg: fn['subMessage'],
								unit: '%',
								title: '주변지역 유동인구 변화',
								nmKey: 'nm',
								valueKey: 'rate',
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
								limitMinZoom: true,
								callback: {
									mouseout: function(layers) {
										var layer = layers.getLayers().filter(function(layer) {     
										    return layer.feature.properties['id'] === trendon.effect.admiCd;
										})[0];
										
										if(!layer) return;
										
										layer.bringToFront();
										
										layer.setStyle({
											weight : 3,
											color: '#000'
										});
									},
									style: function(feature, style, data) {
										// 지역 리스트 중 가장 첫 번째 지역을 강조하는 스타일
										if(trendon.effect.admiCd.length === 0) return;
										
										if(feature.properties['id'] === trendon.effect.admiCd) {
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
		
			// 5. 성/연령별 대표인구
			{
				name: '5. 성/연령별 대표인구',
				data: {
					message: '데이터',
					domId: 'layout5',
					path: '/onmap/event_effect/event_gender_age.json',
					params: {
						admiCd: null,
						startDate: null,
						endDate: null
					},
					callback: function() {
						var fn = this;
						return function(result) {
						    	
							trendon.linkData('leftLayoutType1', {
								dataType1: result['floatTxt'] ? result['floatTxt'] : '-', // 유동인구,
								dataType2: result['amtTxt'] ? result['amtTxt'] : '-' // 소비인구,
							}, fn['domId']);
					    }
					}
				},
				graph: [
					{
						message: '통신사 그래프',
						domId: 'layout5',
						chartId: 'chart1',
						path: '/onmap/event_effect/event_float_list.json',
						params: {
							admiCd: null,
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
						domId: 'layout5',
						chartId: 'chart2',
						path: '/onmap/event_effect/event_sale_list.json',
						params: {
							admiCd: null,
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
			
			// 6. 업종별 경제효과
			{
				name: '6. 업종별 경제효과',
				data: {
					message: '데이터',
					domId: 'layout6',
					path: '/onmap/event_effect/upjong_amt_chnge_text2.json',
					params: {
						admiCd: null,
						startDate: null,
						endDate: null
					},
					callback: function() {
						var fn = this;
						return function(result) {
						    	
							if(trendon.effect.upjongList < 4) return;
							
					    	var unit = '%';
				    		var data1 = result['upjongAmtChngeList'] ? result['upjongAmtChngeList'][0] : null; // 활성업종 1위
							var data2 = result['upjongRateChngeList'] ? result['upjongRateChngeList'][0] : null; // 특화업종 1위
							var data3 = data1 && data1['cd_nm'] ? data1['cd_nm'] : "-";
							var data4 = data1 && data1['rate'] ? data1['rate'] : '';
							var data5 = data1 && data1['rate'] ? OM.Comm.addSign(data1['rate'], 'korean') : '';
							var data6 = data2 && data2['cd_nm'] ? data2['cd_nm'] : "-";
							var data7 = data2 && data2['rate'] ? data2['rate'] : '';
							var data8 = data2 && data2['rate'] ? OM.Comm.addSign(data2['rate'], 'korean') : '';
							
							trendon.linkData('leftLayoutType1', {
								dataType1: [data3, data4 + unit].join(' '),
								dataType2: data5,
								dataType3: [data6, data7 + unit].join(' '),
								dataType4: data8
							}, fn['domId']);
					    }
					}
				},
				graph: [
					{
						message: '거래금액-그래프(수정안함)',
						domId: 'layout6',
						chartId: 'chart1',
						path: '/onmap/event_effect/upjong_amt_chnge_graph.json',
						params: {
							admiCd: null,
							startDate: null,
							endDate: null
						},
						callback: function() {
							var fn = this;
							return function(result) {
							    	
								if(trendon.effect.upjongList < 4) return;
								
								trendon.draw('horizontal-bar', (result['thisList'] == null ? "": result['thisList']), {
									domId: fn['domId'],
									chartId: fn['chartId'],
									name: 'cd_nm',
									value: 'rate',
									color: '#fe8d75',
									x:"거래금액",
									y:"업종",
									background: '#ffffff',
									format: function(value) { return value + '%' }
//									unit: {"form":"rate","length":0}
								})
							}
						}
					}, 
					{
						message: '거래량-그래프(수정안함)',
						domId: 'layout6',
						chartId: 'chart2',
						path: '/onmap/event_effect/upjong_rate_chnge_graph.json',
						params: {
							admiCd: null,
							startDate: null,
							endDate: null
						},
						callback: function() {
							var fn = this;
							return function(result) {
							    	
								if(trendon.effect.upjongList < 4) return;
								
								trendon.draw('horizontal-bar', result['thisList'], {
									domId: fn['domId'],
									chartId: fn['chartId'],
									name: 'cd_nm',
									value: 'rate',
									color: '#fe8d75',
									x:"거래량",
									y:"업종",
									background: '#ffffff',
									format: function(value) { return value + '%' }
//									unit: {"form":"rate","length":0}
								})
							}
						}
					}
				],
				map: null
			},
			
			// 7. 유입 유동인구 수(지도포함)
			{
				name: '7. 유입 유동인구 수',
				data : {
					message: '데이터',
					domId: 'layout7',
					path: '/onmap/event_effect/event_inflow_float.json',
					params: {
						admiCd : null,
						ctyCd: null,
						startDate : null,
						endDate : null,
						rgnClss: null
					},
					callback: function() {
						var fn = this;
						return function(result) {
						    	
					    	var unit = '명';
					    	var data1 = result['floatTxt'];
							var data2 = result['list'];
							var dataType3 = [];
							
							trendon.linkData('leftLayoutType1', {
								dataType1: data1 ? OM.Comm.numToKR(data1)[0] : '-',
								dataType2: data1 ? OM.Comm.numToKR(data1)[1] + unit : '-',
							}, fn['domId']);
							
							if(!data2 || data2.length === 0) {
								trendon.noData.show(fn['domId'], 'dataTable');
								return;
							} 
							
							trendon.linkData('leftLayoutType2', data2.map(function(item) {
								var tmpValue = OM.Comm.numToKR(item['in_cnt']);
								
								return {
									data1: item['nm'],
									data2: tmpValue[0],
									data3: tmpValue[1] + unit
								};
							}), fn['domId']);
					    }
					}
				},
				graph : null,
				map: {
					message: '지도',
					subMessage: '7. 유입 유동인구 수-지도매핑',
					domId: 'layout7',
					mapId: 'map3',
					path: '/onmap/event_effect/getEventMapAll.json',
					params: {
						ctyCd: null,
						admiCd: null,
						startDate : null,
						endDate : null,
						rgnClss: null,
						admiAround: null
					},
					callback: function() {
						var fn = this;
						return function(result, params) {
							
							result['features'].sort(function(a, b) {
								return a.properties['id'] === trendon.effect.admiCd ? 1 : -1; 
							});
							
							// 기존에 map에 레이어가 존재하면 삭제하고 다시 그림
							var baseMap = OM.Map.getBaseMap(fn['mapId']);
							if(baseMap) OM.Map.removeLayer(fn['mapId'], baseMap);
							
							
							trendon.draw('map', result, {
								id: 'id',
								url: '/onmap/event_effect/inflow_float_map.json',
								params: params,
								domId: fn['domId'],
								mapId: fn['mapId'],
								subMsg: fn['subMessage'],
								unit: '명',
								title: '유입 유동인구 수',
								nmKey: 'nm',
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
								limitMinZoom: true,
								callback: {
									mouseout: function(layers) {
										var layer = layers.getLayers().filter(function(layer) {     
										    return layer.feature.properties['id'] === trendon.effect.admiCd;
										})[0];
										
										if(!layer) return;
										
										layer.bringToFront();
										
										layer.setStyle({
											weight : 3,
											color: '#000'
										});
									},
									style: function(feature, style, data) {
										// 지역 리스트 중 가장 첫 번째 지역을 강조하는 스타일
										if(trendon.effect.admiCd.length === 0) return;
										
										if(feature.properties['id'] === trendon.effect.admiCd) {
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
			
			// 8. 유입인구 성/연령별 특성
			{
				name: '8. 유입인구 성/연령 특성',
				data: {
					message: '데이터',
					domId: 'layout8',
					path: '/onmap/event_effect/inflow_gender_age.json',
					params: {
						admiCd: null,
						startDate: null,
						endDate: null
					},
					callback: function() {
						var fn = this;
						return function(result) {
						    	
							trendon.linkData('leftLayoutType1', {
								dataType1: result['floatTxt'] ? result['floatTxt'] : '-',  // 유입 유동인구
								dataType2: result['amtTxt'] ? result['amtTxt'] : '-'   // 유입 소비인구
							}, fn['domId']);
						};
					}
				},
				graph: [
					{
						message: '통신사 그래프',
						domId: 'layout8',
						chartId: 'chart1',
						path: '/onmap/event_effect/inflow_float_chart.json',
						params: {
							admiCd: null,
							startDate: null,
							endDate: null
						},
						callback: function() {
							var fn = this;
							return	function(result) {
								
								trendon.draw('grouped-bar', result['list'] ? result['list'][0] : null, {
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
						domId: 'layout8',
						chartId: 'chart2',
						path: '/onmap/event_effect/inflow_amt_chart.json',
						params: {
							admiCd: null,
							startDate: null,
							endDate: null
						},
						callback: function() {
							var fn = this;
							return	function(result) {
								
								trendon.draw('grouped-bar', result['list'] ? result['list'][0] : null, {
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
			
			// 9. 유입인구 시간대 특성
			{
				name: '9. 유입인구 시간대 특성',
				data: {
					message: '데이터',
					domId: 'layout9',
					path: '/onmap/event_effect/inflow_time_txt.json',
					params: {
						admiCd: null,
						startDate: null,
						endDate: null
					},
					callback: function() {
						var fn = this;
						return function(result) {
						    	
							trendon.linkData('leftLayoutType1', {
								dataType1: result.floatTxt && result.floatTxt.length > 0 ? (result.floatTxt[0] == null? "-" : result.floatTxt[0]['cd_nm']) : '-', // 주요 방문시간
								dataType2: result.amtTxt && result.amtTxt.length > 0 ? result.amtTxt[0]['cd_nm'] : '-', // 주요 소비시간
							}, fn['domId']);
					    }
					}
				},
				graph: {
					message: '그래프',
					domId: 'layout9',
					chartId: 'chart1',
					path: '/onmap/event_effect/inflow_time_chart.json',
					params: {
						admiCd: null,
						startDate: null,
						endDate: null
					},
					callback: function() {
						var fn = this;
						return function(result) {
						    	
							trendon.draw('grouped-bar', result['list'] ? result['list'][0] : null, {
					    		domId: fn['domId'],
					    		chartId: fn['chartId'],
					    		sorts: [
					    			'f_t_1_cnt', 'e_t_1_cnt',
					    			'f_t_2_cnt', 'e_t_2_cnt',
					    			'f_t_3_cnt', 'e_t_3_cnt',
					    			'f_t_4_cnt', 'e_t_4_cnt',
					    			'f_t_5_cnt', 'e_t_5_cnt',
					    			'f_t_6_cnt', 'e_t_6_cnt',
					    			'f_t_7_cnt', 'e_t_7_cnt'
					    		],
					    		title: '',
					    		groups: ["00-06시","06-09시","09-12시","12-15시","15-18시","18-21시","21-24시"],
								colors: ['#2ec5c5', '#fe8d75'],
								columns: ['주요 방문시간', '주요 소비시간'],
								unit: '%',
								legendType: 'text'
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
					path: '/onmap/event_effect/inflow_region_txt.json',
					params: {
						ctyCd: null,
						admiCd: null,
						startDate : null,
						endDate : null,
						rgnClss: 'H3'
					},
					callback: function() {
						var fn = this;
						return function(result) {
						    	
					    	var unit = '명';
					    	var data1 = result['floatTxt'];
							var data2 = result['list'];
							var arr = [];
							
							trendon.linkData('leftLayoutType1', {
								dataType1: data1 ? data1 : '-'
							}, fn['domId']);
							
							if(!data2 || data2.length === 0) {
								trendon.noData.show(fn['domId'], 'dataTable');
								return;
							} 
							
							data2.map(function(item) {
								var tmpValue = OM.Comm.numToKR(item['in_cnt']);
								
								arr.push({
									data1: item['nm'],
									data2: item['in_cnt'] > 100 ? tmpValue[0] : '100',
									data3: item['in_cnt'] > 100 ? tmpValue[1] + unit : '명 이하'
								})
							});
							
							trendon.linkData('leftLayoutType2', arr, fn['domId']);
							
					    }
					}
				},
				graph : null,
				map: {
					message: '지도',
					subMessage: '10. 유입 유동인구 유입지역 - 지도매핑',
					domId: 'layout10',
					mapId: 'map4',
					path: '/onmap/event_effect/getEventCtyMap.json',
					params: {
						layerName: null,
						ctyCd: null,
						admiCd: null,
						startDate : null,
						endDate : null,
						rgnClss: 'H3'
					},
					callback: function() {
						var fn = this;
						return function(result, params) {
							
							result['features'].sort(function(a, b) {
						        return a.properties['id'] === trendon.effect.ctyCd ? 1 : -1; 
							});
							
							trendon.draw('map', result, {
								url: '/onmap/event_effect/inflow_region_map.json',
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
										    return layer.feature.properties['id'] === trendon.effect.ctyCd;
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
										if(feature.properties['id'] === trendon.effect['ctyCd']) {
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
			"lastArea" : "test",
			"action" : function() {
				// top 그래프 값이 변경됐을 경우에만 함수 처리하기
				// 선택기간이 기존과 같은 경우 실행 안함
				if( this.lastValue == trendon.effect['startDate']+":"+trendon.effect['endDate']+":"+trendon.effect['lastStartDate']+":"+trendon.effect['lastEndDate'] 
					&& this.lastArea == trendon.effect['admiCd']){
					return;
				}
				
				trendon.effect.validation(function(){
					
					// 1. 행정동 총 경제효과
					trendon.callAPI(
						trendon.effect.getConfig(1),
						trendon.effect.setParameter
					);
					// 2. 행정동 유동인구 변화
					trendon.callAPI(
						trendon.effect.getConfig(2),
						trendon.effect.setParameter
					);
					// 3. 주변지역 경제효과(지도포함)
					trendon.callAPI(
						trendon.effect.getConfig(3),
						trendon.effect.setParameter
					);
					// 4. 주변지역 유동인구 변화(지도포함)
					trendon.callAPI(
						trendon.effect.getConfig(4),
						trendon.effect.setParameter
					);
					// 5. 성/연령별 대표인구
					trendon.callAPI(
							trendon.effect.getConfig(5),
							trendon.effect.setParameter
					);
					// 6. 업종별 경제효과
					trendon.callAPI(
							trendon.effect.getConfig(6),
							trendon.effect.setParameter
					);
				});
				
				
				// 선택 기간 저장
				this.lastValue = trendon.effect['startDate']+":"+trendon.effect['endDate']+":"+trendon.effect['lastStartDate']+":"+trendon.effect['lastEndDate'];
				this.lastArea = trendon.effect['admiCd'];
			}
		},
		"secondPage" : {
			"status" : false,
			"lastValue" : "test",
			"lastArea" : "test",
			"action" : function() {
				// top 그래프 값이 변경됐을 경우에만 함수 처리하기
				// 선택기간이 기존과 같은 경우 실행 안함
				if( this.lastValue == trendon.effect['startDate']+":"+trendon.effect['endDate']+":"+trendon.effect['lastStartDate']+":"+trendon.effect['lastEndDate'] 
					&& this.lastArea == trendon.effect['admiCd']){
					return;
				}
				
				trendon.effect.validation(function(){
					// 7. 유입 유동인구 수(지도포함)
					trendon.callAPI(
						trendon.effect.getConfig(7),
						trendon.effect.setParameter
					);
					// 8. 유입인구 성/연령별 특성
					trendon.callAPI(
						trendon.effect.getConfig(8),
						trendon.effect.setParameter
					);
				});
				
				// 선택 기간 저장
				this.lastValue = trendon.effect['startDate']+":"+trendon.effect['endDate']+":"+trendon.effect['lastStartDate']+":"+trendon.effect['lastEndDate'];
				this.lastArea = trendon.effect['admiCd'];
			}
		},
		"thirdPage" : {
			"status" : false,
			"lastValue" : "test",
			"lastArea" : "test",
			"action" : function() {
				// top 그래프 값이 변경됐을 경우에만 함수 처리하기
				// 선택기간이 기존과 같은 경우 실행 안함
				if( this.lastValue == trendon.effect['startDate']+":"+trendon.effect['endDate']+":"+trendon.effect['lastStartDate']+":"+trendon.effect['lastEndDate'] 
					&& this.lastArea == trendon.effect['admiCd']){
					return;
				}
				
				trendon.effect.validation(function(){
					// 9. 유입인구 시간대 특성
					trendon.callAPI(
						trendon.effect.getConfig(9),
						trendon.effect.setParameter
					);
					// 10. 유입 유동인구 유입지역(지도) 
					trendon.callAPI(
						trendon.effect.getConfig(10),
						trendon.effect.setParameter
					);
				});
				
				
				// 선택 기간 저장
				this.lastValue = trendon.effect['startDate']+":"+trendon.effect['endDate']+":"+trendon.effect['lastStartDate']+":"+trendon.effect['lastEndDate'];
				this.lastArea = trendon.effect['admiCd'];
			}
		}
	}
	
}