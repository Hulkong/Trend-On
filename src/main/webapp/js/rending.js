/**
 * @description 렌딩페이지 설정값 
 * @descriptor 김용현 
 * @date 2020.08.20
 */

/**
 * 0. 선택 시군구의 총 매출
 * 1. 선택 시군구의 총 유동인구
 */

if(!trendon) var trendon= {};

trendon.rending = (function() {
	return {
		
		/**
		 * 카운팅 이벤트 
		 * @param divId 카운트할 위치
		 * @param value 값
		 */
		counting: function(divId, value) {
			$({ Counter: 0 }).animate({
				  Counter: value
			}, {
			  duration: 1000,
			  easing: 'swing',
			  step: function(stepValue) {
			    $(divId).text(OM.Comm.addCommaToNum(Math.ceil(stepValue)));
			  }
			})
		},
		
		/**
		 * 슬로건 이미지 없을때 text 적용
		 * @param obj 	이미지 객체
		 */ 
		changeToText: function(obj, nm){
			$(obj).parent().html("<strong>"+nm+"</strong>");
		},
		
		/**
		 * 배경 이미지 존재 유무 체크
		 * @param imageSrc	이미지 url 
		 * @param successFc	이미지 있을때 실행할 함수
		 * @param falseFc	이미지 없을때 실행할 함수
		 */
		checkImage: function(imageSrc,successFc, falseFc){
			$.ajax({
				url : imageSrc,
				type:'HEAD',
			    error: falseFc,
			    success: successFc
			});
		},
		
		getConfig: function(index) {
			
			if(!index) index = -1;
			
			var configs = [
				
				// 0. 선택 시군구의 총 매출
				{
					name: '0. 선택 시군구의 총 매출',
					data: {
						message: '데이터',
						path: '/onmap/main/setTotalData.json',
						params: {
							ctyCd: null
						},
						callback: {
							beforeSend: function() {},
							complete: function() {},
							success: function(result) {
								
								var totalObj = result['totalAmt'] ? result['totalAmt'] : {};  // 기준년월 총 거래금액 메타데이터
								var topAdmiObj = result['admiOne'] ? result['admiOne'] : {};   // 기준년월 선택 시군구 최대 소비지역 메타데이터
								var totalAmt = totalObj['this_amt'] ? totalObj['this_amt'] : 0;  // 기준년월 총 거래금액  
								var thisRate = totalObj['amt_rate'] ? totalObj['amt_rate'] : 0;  // 전월대비 총 거래금액 증감률
								var adminNm = topAdmiObj['nm'] ? topAdmiObj['nm'] : '-';  // 기준년월 선택 시군구 최대 시비지역(행정동) 
								var admiRate = result['admiRate'] ? result['admiRate'] : 0;  // 전월대비 선택 시군구의 소비지역 증감률
								var accCnt = result['ctyTot'] ? result['ctyTot'] : 0; // 현재 누적데이터(2년)
								var newCnt = result['monTot'] ? result['monTot'] : 0; // 기준년월 누적데이터(신규)
								
								var sign = Number(thisRate) >= 0 ? '증가' : '감소';
								trendon.rending.counting("#dataType1", totalAmt);  
								$('#dataType2').text([thisRate, '%', sign].join('')); 
								$('#dataType3').text(adminNm);
								
								sign = (Number(admiRate)) >= 0 ? '증가' : '감소';
								$('#dataType4').text([admiRate, '%', sign].join(''));
								trendon.rending.counting('#dataType5', accCnt)
								$('#dataType6').text(OM.Comm.addCommaToNum(newCnt));
							}
						}
					},
					graph: null,
					map: null
				},
				
				// 1. 선택 시군구의 총 유동인구
				{
					name: '1. 선택 시군구의 총 유동인구',
					data: {
						message: '데이터',
						path: '/onmap/main/setTotalFloat.json',
						params: {
							ctyCd: null
						},
						callback: {
							beforeSend: function() {},
							complete: function() {},
							success: function(result) {
								var totalObj = result['totalFloat'] ? result['totalFloat'] : {};  // 기준년월 총 유동인구
								var topAdmiObj = result['admiOne'] ? result['admiOne'] : {};   // 기준년월 선택 시군구 최대 유동인구
								var totalCnt = totalObj['this_cnt'] ? totalObj['this_cnt'] : 0;  // 기준년월 총 유동인구 수  
								var thisRate = totalObj['rate'] ? totalObj['rate'] : 0;  // 전월대비 총 유동인구수 증감률
								var adminNm = topAdmiObj['nm'] ? topAdmiObj['nm'] : '-';  // 기준년월 선택 시군구 유동인구가 가장 많은 행정동 
								var admiRate = result['admiRate'] ? result['admiRate'] : 0;  // 전월대비 선택 시군구의 유동인구의 증감률 
								
								var sign = Number(thisRate) >= 0 ? '증가' : '감소';
								trendon.rending.counting("#dataType7", totalCnt);
								$('#dataType8').text([thisRate, '%', sign].join('')); 
								$('#dataType9').text(adminNm);
								
								sign = (Number(admiRate)) >= 0 ? '증가' : '감소';
								$('#dataType10').text([admiRate, '%', sign].join(''));
							}
						}
					},
					graph: null,
					map: null
				}
			]
			
			return index === -1 ? configs : configs[index];
		}
	}
})();