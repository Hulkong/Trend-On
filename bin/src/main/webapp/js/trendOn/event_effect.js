var timeHandlerId = null;

/**
 * 시간 변화에 따른 callbak 함수
 * @param evt
 * @param start	왼쪽 슬라이더의 값 
 * @param end 오른쪽 슬라이더의 값 
 * @param column y축 value
 **/
function timeHandler(evt, start, end, column){
	$(".group_help").css("display","none");
	
	// 선택된 기간 저장
//	event_config.selectedStartDate = start.stdr_date;
//	event_config.selectedEndDate = end.stdr_date;
	event_config.selectedStartDate = dateFomat(start,"");
	event_config.selectedEndDate = dateFomat(end,"");

//	var sDate = start.stdr_date.substr(0,4)+". "+start.stdr_date.substr(4,2)+". "+start.stdr_date.substr(6);
//	var eDate = end.stdr_date.substr(0,4)+". "+end.stdr_date.substr(4,2)+". "+end.stdr_date.substr(6);
//	var iesDate = start.stdr_date.substr(0,4)+"-"+start.stdr_date.substr(4,2)+"-"+start.stdr_date.substr(6);
//	var ieeDate = end.stdr_date.substr(0,4)+"-"+end.stdr_date.substr(4,2)+"-"+end.stdr_date.substr(6);
	var sDate = dateFomat(start,". ");
	var eDate = dateFomat(end,". ");
//	var iesDate = dateFomat(start,"-");
//	var ieeDate = dateFomat(end,"-");

	// 선택된 기간의 전년도 기간 저장
//	var thisStartData = new Date(iesDate);
//	var thisEndData = new Date(ieeDate);
	start.setMonth(start.getMonth() - 12);
	end.setMonth(end.getMonth() - 12);
	
	event_config.selectedLastStartDate = dateFomat(start,"");
	event_config.selectedLastEndDate = dateFomat(end,"");
	
//	event_config.selectedLastStartDate = start.getFullYear()+"";
//	event_config.selectedLastStartDate += ((thisStartData.getMonth()+1) < 10 ? "0"+(thisStartData.getMonth()+1):(thisStartData.getMonth()+1))+"";
//	event_config.selectedLastStartDate += (thisStartData.getDate() < 10 ? "0"+thisStartData.getDate():thisStartData.getDate())+"";
//	
//	event_config.selectedLastEndDate = thisEndData.getFullYear()+"";
//	event_config.selectedLastEndDate += ((thisEndData.getMonth()+1) < 10 ? "0"+(thisEndData.getMonth()+1):(thisEndData.getMonth()+1))+"";
//	event_config.selectedLastEndDate += (thisEndData.getDate() < 10 ? "0"+thisEndData.getDate():thisEndData.getDate())+"";
	
	
	$(".search_period").text(sDate+" ~ "+eDate);

	if(timeHandlerId){
		clearTimeout(timeHandlerId);
	}
	timeHandlerId = setTimeout(function(){
		getUpjongOption();
		
		event_config.validateChk.status = false; // validate 초기화
		sectionFunc[lastAnchorLink].action();
    },1000);
	
	
}

/**
* datarangepicker로 달력 만들기
**/
function makeCalendar(){
	var limitSdate = new Date(event_config.limitStartDate.substr(0,4)+"-"+event_config.limitStartDate.substr(4,2)+"-"+event_config.limitStartDate.substr(6))
	var limitSyear = limitSdate.getFullYear() -1;
	limitSdate.setFullYear(limitSyear)
	var lastLimitSdate = limitSyear;
	
	if((limitSdate.getMonth()+1) < 10) lastLimitSdate += "-0"+(limitSdate.getMonth()+1);
	else  lastLimitSdate += "-"+(limitSdate.getMonth()+1);

	if(limitSdate.getDate() < 10) lastLimitSdate += "-0"+limitSdate.getDate();
	else  lastLimitSdate += "-"+limitSdate.getDate();
	
	
	// 전년도 달력 표시
	var sDatepicker = $("#sDatepicker").dateRangePicker({
		inline:true,
		container: '#sDatepicker',
		language: 'ko',
		format : "YYYY. MM. DD" ,
		separator: ' ~ ',
		startDate:lastLimitSdate,
//		startDate:event_config.limitStartDate,
		endDate:event_config.limitEndDate,
//		endDate:"20160522",
		singleMonth: true,
		alwaysOpen:true ,
		showTopbar: false,
		autoClose: true,
		minDays: 3,
		maxDays: 93,
		customArrowPrevSymbol: "<img src='/images/board/calendar_btn_prev.gif' />",
		customArrowNextSymbol: "<img src='/images/board/calendar_btn_next.gif' />",
		hoveringTooltip: false, // tooltip 사용여부
		getValue:function(){
			return $("#popSelectedLast").text();
		},
		setValue:function(s, s1, s2){
			$('#popSelectedLast').text(s);
		}
	});
	
	// 선택 기간
	var eDatepicker = $("#eDatepicker").dateRangePicker({
		inline:true,
		container: '#eDatepicker', 
		language: 'ko',
		format : "YYYY. MM. DD" ,
		separator: ' ~ ',
		startDate:event_config.limitStartDate,
		endDate:event_config.limitEndDate,
		singleMonth: true,
		alwaysOpen:true ,
		showTopbar: false,
		autoClose: true,
		minDays: 3,
		maxDays: 93,
		customArrowPrevSymbol: "<img src='/images/board/calendar_btn_prev.gif' />",
		customArrowNextSymbol: "<img src='/images/board/calendar_btn_next.gif' />",
		hoveringTooltip: false, // tooltip 사용여부
		getValue:function(){
			return $('.search_period').text();
		},
		setValue:function(s, s1, s2){
			$('#popSelectedThis').text(s);
			$("#sDatepicker").data('dateRangePicker').setMaxDate(moment(s1,"YYYY-MM-DD").subtract(1,'days'));
		}
	});
	
	event_config.chk = 1;
}	

/**
 * 기간에 따른 행정동의 매출액 혹은 거래량이 있는 업종가져오기(selectbox)
 */
function getUpjongOption(){
	$.ajax({
		url:"/onmap/event_effect/getUpjongOption.json",
		data:{
			"admiCd" : event_config.selectAmdiCd,
			"startDate" : event_config.selectedStartDate,
			"endDate" : event_config.selectedEndDate
		},
		success: function(data) {
			if(data){
				var upHtml = "";
				for(var i = 0 ; i < data.length; i++){
					upHtml += "<option value='"+data[i].code+"'>"+data[i].cd_nm+"</option>";
				}
				$("#upAmtMapSelect").html(upHtml);
				$("#upRateMapSelect").html(upHtml);
			}
		}
	});
}

/**
 * 선택된 행정동 & 주변 행정동 가져오기
 * @param callback 시군구에 대한 행정동을 가져온 후 실행할 함수.
 */
function getAdmiList(callback){
	$.ajax({
		url:"/onmap/event_effect/getAdmiList.json",
		data:{
			"ctyCd" : event_config.sessionCtyCd,
			"admiCd" : event_config.selectAmdiCd
		},
		success: function(data) {
			if(data){
				event_config.admiAround = data.admiAround;
				
			}
			
			if(callback) callback();
		}
	})
}

/**
 * 지역별 경제효과 순위 map 위의 select box 값 선택시
 * @param fid   레이어 아이디
 * @param value 선택 값(금액 , 비율)
 */
function amtMapChnge(fid,value){
	regionAmtChngeMap(fid,value)
}

/**
 * 업종&지역별 경제효과 순위(매출액 기준) map 위의 select box 값 선택시
 * @param value 선택 값(업종코드)
 */
function upAmtMapChnge(value){
	upjongAmtChngeMap(value);
	upjongRatechngeText1(value);
	$("#mxmAmtUpjong").text($("#upAmtMapSelect option:selected").text());
}

/**
 * 업종&지역별 경제효과 순위(거래량 기준) map 위의 select box 값 선택시
 * @param value 선택 값(업종코드)
 */
function upRateMapChnge(value){
	upjongRateChngeMap(value);
	upjongRatechngeText2(value);
	$("#mxmRateUpjong").text($("#upRateMapSelect option:selected").text());
}

/**
 * 기간직접입력 popup - 선택 버튼 클릭시
 */
function changePeriod(){
	
	var lastStartPeriod = $("#popSelectedLast").text().trim().split("~")[0].split(".");
	var lastEndPeriod = $("#popSelectedLast").text().trim().split("~")[1].split(".");
	var thisStartPeriod = $("#popSelectedThis").text().trim().split("~")[0].split(".");
	var thisEndPeriod = $("#popSelectedThis").text().trim().split("~")[1].split(".");
	
	var sLast = lastStartPeriod[0].trim()+lastStartPeriod[1].trim()+lastStartPeriod[2].trim();
	var eLast = lastEndPeriod[0].trim()+lastEndPeriod[1].trim()+lastEndPeriod[2].trim();
	var sThis = thisStartPeriod[0].trim()+thisStartPeriod[1].trim()+thisStartPeriod[2].trim();
	var eThis = thisEndPeriod[0].trim()+thisEndPeriod[1].trim()+thisEndPeriod[2].trim();


	var selectedEdate = new Date(eThis.substr(0,4)+"-"+eThis.substr(4,2)+"-"+eThis.substr(6,2));
	var selectedSdate = new Date(sThis.substr(0,4)+"-"+sThis.substr(4,2)+"-"+sThis.substr(6,2));
	
	var maxDate = new Date(selectedSdate);
	maxDate.setMonth(maxDate.getMonth()+6);
	var minDate = new Date(selectedSdate);
	minDate.setDate(minDate.getDate()+2);
	
	var maxPeriod = maxDate.getTime() - selectedSdate.getTime();
	var minPeriod = minDate.getTime() - selectedSdate.getTime();
	var selectedPeriod = selectedEdate.getTime() - selectedSdate.getTime();
	
	
	// 월수가 6개월 이상일때 / 2일보다 저게 선택했을때.
	if(selectedPeriod < minPeriod || selectedPeriod > maxPeriod){
		alert("기간을 다시 선택해주세요.");
		return false;
	}else{	// 선택된 값을 config 변수에 저장
		event_config.selectedStartDate = sThis;
		event_config.selectedEndDate = eThis;

		// 전년도 날짜를 선택했다면 config 변수에 저장 하고  / 아닐 경우에는 선택된 기간의 일년전 날짜로 저장
		if(event_config.selectedLastStartDate == sLast && event_config.selectedLastEndDate == eLast ){
			selectedSdate.setMonth(selectedSdate.getMonth()-12);
			selectedEdate.setMonth(selectedEdate.getMonth()-12);
			event_config.selectedLastStartDate = selectedSdate.getFullYear()+"";
			event_config.selectedLastStartDate += ((selectedSdate.getMonth()+1) < 10 ? "0"+(selectedSdate.getMonth()+1):(selectedSdate.getMonth()+1))+"";
			event_config.selectedLastStartDate += (selectedSdate.getDate() < 10 ? "0"+selectedSdate.getDate():selectedSdate.getDate())+"";
			
			event_config.selectedLastEndDate = selectedEdate.getFullYear()+"";
			event_config.selectedLastEndDate += ((selectedEdate.getMonth()+1) < 10 ? "0"+(selectedEdate.getMonth()+1):(selectedEdate.getMonth()+1))+"";
			event_config.selectedLastEndDate += (selectedEdate.getDate() < 10 ? "0"+selectedEdate.getDate():selectedEdate.getDate())+"";
		}else{
			event_config.selectedLastStartDate = sLast;
			event_config.selectedLastEndDate = eLast;
		}
		
		// 시계열그래프의 range slider 위치 조정
		timeChart.setVal(yyyymmddToDate(sThis),yyyymmddToDate(eThis));
		//기간직접입력 버튼옆에 있는 기간 텍스트를 조회한 기간으로 변경
		$(".search_period").text($("#popSelectedThis").text());
		//기간선택 popup 창닫음
		$(".btn_close").trigger("click");
		//주변지역 업종별 경제효과의 각 업종 
		getUpjongOption();
		// 데이터 유효성 초기화
		event_config.validateChk.status = false;
		// 현재 보고있는 부분의 내용을 reload
		sectionFunc[lastAnchorLink].action();
		//안내 메시지 숨기기
		$(".group_help").css("display","none");
	}
	
}
	
/**
 * event1-1. 총 경제효과 text / event2-1 지역별 경제효과 순위 text
 **/
function regionAmtChngeText(){
	$.ajax({
		url:"/onmap/event_effect/region_amt_chnge_text.json",
		data:{
			"ctyCd" : event_config.sessionCtyCd,
			"admiCd" : event_config.selectAmdiCd,
			"startDate" : event_config.selectedStartDate,
			"endDate" : event_config.selectedEndDate,
			"rgnClss" : event_config.selectedRgnClss,
			"admiAround" : event_config.admiAround
		},
		success: function(data) {
			
			
			// event1-1 총 경제효과  - 올해 매출액 변화
			var arEE = " - ";
			var arTotal = 0;
			var arCnt = 0;
			if(data.thisAmtChnge.rate || data.thisAmtChnge.rate == 0){ 
				arEE = (data.thisAmtChnge.rate).toFixed(1);
			}else{
				for(var arNum = 1; arNum < 6; arNum++){
					// 후 1~2주의 값이 없을 경우 그 외의 기간으로 일평균을 계산
					if(data.thisAmtChnge["lw"+arNum] || data.thisAmtChnge["lw"+arNum] == 0){						
						arTotal += 	data.thisAmtChnge["lw"+arNum];
						arCnt ++;
					}
				}
				arEE = ((  (Number(data.thisAmtChnge.term) - ( arTotal / arCnt ))  /  ( arTotal / arCnt )  ) * 100).toFixed(1) ;
				
			}
			$("#amt_rate1_EE").text(arEE+ "%");
			
			// event1-1 총 경제효과 ( 평상시 / 이벤트 기간 )
			if(data.thisAmtChnge){
			
				var daysRate = data.thisAmtChnge["days_rate"]; 
				if(!daysRate){
					daysRate = Math.round(arTotal/arCnt);
				}
				var tCnt =  Math.floor(1e-12 + Math.log(daysRate) / Math.LN10);
				var tCnt2 =  Math.floor(1e-12 + Math.log(data.thisAmtChnge["term"]) / Math.LN10);
				var termRate = data.thisAmtChnge["term"]; 
				
				if(tCnt > tCnt2) tCnt = tCnt2;
				
				if(tCnt >= 4){    // 1000 이상일 경우
					if(tCnt%4 != 0){ // 만(4), 억(8), 조(12) 단위로만 표현
						tCnt = 4 * Math.floor(tCnt/4);
					}
					
					daysRate = krWonRound(daysRate,tCnt,1);
					termRate = krWonRound(termRate,tCnt,1);
				}
				
				var amtListHtml ="";
				amtListHtml += "<tr>";
				amtListHtml += "<th>평상시 : </th>";
				amtListHtml += "<td><strong>" + daysRate + "원</strong>/ 일 평균</td>";
				amtListHtml += "</tr>";
				
				amtListHtml += "<tr>";
				amtListHtml += "<th><strong>이벤트 기간 : </strong></th>";
				amtListHtml += "<td><strong style='color : #f26522;'>" + termRate+"원</strong>/ 일 평균</td>";
//				amtListHtml += "<td><strong style='color : #f26522;'>" + data.thisAmtChnge.term + "원</strong>/ 일 평균</td>";
				amtListHtml += "</tr>";
				
				$("#amt_rate_list").html(amtListHtml);	

				// event1-2 주변지역 총 경제효과  - 해당 해정동 (매출액 기준)
				var sAdmiAmt =  (arEE < 0 ? arEE : "+ "+arEE);
				$("#sAdmiAmt").text(sAdmiAmt);
			}
			
			// event1-2 주변지역 총 경제효과  - 해당 해정동 (거래량 기준)
			if(data.thisCntChnge){
				
				
				var sAdmiRate = " - ";
				var sarTotal = 0;
				var sarCnt = 0;
				
				
				
				if(data.thisCntChnge.rate || data.thisCntChnge.rate == 0){
					sAdmiRate = data.thisCntChnge.rate;
				}else{
					for(var sarNum = 1; sarNum < 6; sarNum++){
						// 후 1~2주의 값이 없을 경우 그 외의 기간으로 일평균을 계산
						if(data.thisCntChnge["lw"+sarNum] || data.thisCntChnge["lw"+sarNum] == 0){	
							sarTotal += Number(data.thisCntChnge["lw"+sarNum]);
							sarCnt ++;
						}
					}
					sAdmiRate = Number(  ((  (Number(data.thisAmtChnge.term) - ( sarTotal / sarCnt ))  /  ( sarTotal / sarCnt )  ) * 100).toFixed(1)  );
					
				}
				
				var sAdmiRateText =  (sAdmiRate < 0 ? sAdmiRate.toFixed(1) : (sAdmiRate == 0 ? 0 : "+ "+sAdmiRate.toFixed(1)));
				$("#sAdmiRate").text(sAdmiRateText);
			}
			
			// evnet1-2 주변지역 총 경제효과 (매출액 기준)
			if(data.mxmIncrsAmt){
				
				$("#mxmAmt").empty();
				if(data.mxmIncrsAmt.length > 0) $("#mxmAmt").append(data.mxmIncrsAmt[0].nm);
				else $("#mxmAmt").append(" - ");
				
				var amtHtml = "";
				for(var i = 0 ; i < data.mxmIncrsAmt.length ; i++){
					var amtSign = "+";
					if(data.mxmIncrsAmt[i].rate < 0) amtSign = "-";	
					
					amtHtml +="<tr>";
					amtHtml +="<th><em class='rank'>"+(i+1)+"</em>"+data.mxmIncrsAmt[i].nm+"</th>";
					amtHtml +="<td>"+amtSign+" <strong>"+Math.abs(data.mxmIncrsAmt[i].rate).toFixed(1)+"</strong>%</td>";
					amtHtml +="</tr>";
				}
				$("#mxmAmt_list").empty();
				$("#mxmAmt_list").append(amtHtml);
			}
			
			// evnet1-2 주변지역 총 경제효과 (거래량 기준)
			if(data.mxmIncrsRate){
				
				$("#mxmRate").empty();
				if(data.mxmIncrsRate.length > 0) $("#mxmRate").append(data.mxmIncrsRate[0].nm);
				else $("#mxmRate").append(" - ");
				
				var rateHtml = "";
				for(var i = 0 ; i < data.mxmIncrsRate.length ; i++){
					var rateSign = "+";
					if(data.mxmIncrsRate[i].rate < 0) rateSign = "-";	
					
					rateHtml +="<tr>";
					rateHtml +="<th><em class='rank'>"+(i+1)+"</em>"+data.mxmIncrsRate[i].nm+"</th>";
					rateHtml +="<td>"+rateSign+" <strong>"+Math.abs(data.mxmIncrsRate[i].rate).toFixed(1)+"</strong>%</td>";
					rateHtml +="</tr>";
				}
				$("#mxmRate_list").empty();
				$("#mxmRate_list").html(rateHtml);
			}
			
		}
	});
}

/**
 * event1. 총 경제효과 graph (lineChartMulti_plus)
 **/
function regionAmtChngeGraph(){
	loadingShow('eventChart1');
	$.ajax({
		url:"/onmap/event_effect/event_effect_charts.json",
		data:{
			"ctyCd" : event_config.sessionCtyCd,
			"admiCd" : event_config.selectAmdiCd,
			"startDate" : event_config.selectedStartDate,
			"endDate" : event_config.selectedEndDate,
			"lastStartDate" : event_config.selectedLastStartDate,
			"lastEndDate" : event_config.selectedLastEndDate,
			"rgnClss" : event_config.selectedRgnClss
		},
		success: function(data) {
			var label1 = "선택기간";
			var label2 = "비교기간";
			if(event_config.selectedStartDate){
				label1 = event_config.selectedStartDate.substr(0,4);
				label2 = Number(label1)-1;
			}
			
			var title1 = event_config.selectedStartDate.substr(0,4)+"."+event_config.selectedStartDate.substr(4,6)+"."+event_config.selectedStartDate.substr(6,8)+"~";
			    title1 += event_config.selectedEndDate.substr(0,4)+"."+event_config.selectedEndDate.substr(4,6)+"."+event_config.selectedEndDate.substr(6,8);
			var title2 = event_config.selectedLastStartDate.substr(0,4)+"."+event_config.selectedLastStartDate.substr(4,6)+"."+event_config.selectedLastStartDate.substr(6,8)+"~";
			    title2 += event_config.selectedLastEndDate.substr(0,4)+"."+event_config.selectedLastEndDate.substr(4,6)+"."+event_config.selectedLastEndDate.substr(6,8);
			
			
			var label={
					x:"Date",
					y:"거래총액"
			};
			
			var attributes =[
			                 {"name": "선택기간", "hex":"#ff8166", "length":8, "label": "선택기간"},
			                 {"name": "비교기간", "hex":colorArr[1], "length":8, "label": "비교기간"}
//			                 {"name": "선택기간 "+label1+"년", "hex":"#ff8166", "length":8, "label": "선택기간 ("+title1+")"},
//			                 {"name": "비교기간 "+label2+"년", "hex":colorArr[1], "length":8, "label": "비교기간 ("+title2+")"}
			                ];
			
			
			var inputData = [];
			var xAxis = ["3주전","2주전","1주전","이벤트기간","1주후","2주후"];
			if(data.thisAmtList && data.thisAmtList[0]){
				for(var i = 1; i < 7; i++){
					var chartData = {};
					chartData.name = "선택기간";
//					chartData.name = "선택기간 "+label1+"년";
					chartData.value = data.thisAmtList[0]["law"+i];
					chartData.date = xAxis[(i-1)];
					chartData.order = i;
					
					inputData.push(chartData);
					
					var valueLen = Math.floor(1e-12 + Math.log(chartData.value) / Math.LN10);
					if(attributes[0].length > valueLen) attributes[0].length = valueLen;
					if(attributes[1].length > valueLen) attributes[1].length = valueLen;
				}
			}
			
			if(data.lastAmtList && data.lastAmtList[0]){
				for(var i = 1; i < 7; i++){
					var chartData = {};
					chartData.name = "비교기간";
//					chartData.name = "비교기간 "+label2+"년";
					chartData.value = data.lastAmtList[0]["law" + i] ? data.lastAmtList[0]["law"+i] : 0;
					chartData.date = xAxis[(i-1)];
					chartData.order = i;
					
					inputData.push(chartData);
					
					if(chartData.value > 0) {
						var valueLen = Math.floor(1e-12 + Math.log(chartData.value) / Math.LN10);
						if(attributes[0].length > valueLen) attributes[0].length = valueLen;
						if(attributes[1].length > valueLen) attributes[1].length = valueLen;
					}

				}
			}

			$("#eventChart1").empty();
			lineChartMulti_plus(inputData, "#eventChart1", label, attributes, "#f8f8f8")
			loadingHide('eventChart1');
		}
	});
}

/**
 * event2-1. 업종별 경제효과 - 매출액기준 graph (hozBar_plus)
 **/
function upjongAmtChngeGraph2(){
	loadingShow('eventChart2');
	$.ajax({
		url:"/onmap/event_effect/upjong_amt_chnge_graph.json",
		data:{
			"ctyCd" : event_config.sessionCtyCd,
			"admiCd" : event_config.selectAmdiCd,
			"admiFlg" : event_config.admiFlg,
			"startDate" : event_config.selectedStartDate,
			"endDate" : event_config.selectedEndDate,
			"rgnClss" : event_config.selectedRgnClss
		},
		success: function(data) {
			var list = data.thisList;
			var unit ={"form":"rate","length":0}
			if(list.length > 0 ){
				var inputData = [];
				for(var i = 0; i < list.length; i++){
					var chartData = {};
					
					chartData.name = list[i].cd_nm;
					chartData.value = list[i].rate;
					chartData.y = i+1;
					chartData.hex = "#2e6695";
					
					inputData.push(chartData);	
					
				}
				
				var ticks =[];
				var tick = Number(((list[0].rate + list[(list.length-1)].rate)/6).toFixed(1));
				var tArr = 0;
				for(var i = 0; i < 7; i++){
					ticks.push(tArr);
					tArr += tick;
				}
				
				var label={
						x:"",
						y:""
				};
				
				$("#eventChart2").empty();
				hozBar_plus(inputData,"#eventChart2", label, ticks,"#f8f8f8", unit);
				loadingHide('eventChart2');
			}
			
		}
	});
}

/**
 * event2-1. 업종별 경제효과 - 거래량기준 graph (hozBar_plus)
 **/
function upjongRateChngeGraph2(){
	loadingShow('eventChart3');
	$.ajax({
		url:"/onmap/event_effect/upjong_rate_chnge_graph.json",
		data:{
			"ctyCd" : event_config.sessionCtyCd,
			"admiCd" : event_config.selectAmdiCd,
			"startDate" : event_config.selectedStartDate,
			"endDate" : event_config.selectedEndDate,
			"rgnClss" : event_config.selectedRgnClss
		},
		success: function(data) {
			var list = data.thisList;
			var unit ={"form":"rate","length":0}
			if(list.length > 0 ){
				var inputData = [];
				for(var i = 0; i < list.length; i++){
					var chartData = {};
					
					chartData.name = list[i].cd_nm;
					chartData.value = list[i].rate;
					chartData.y = i+1;
					chartData.hex = "#2e6695";
					
					inputData.push(chartData);	
				}
				
				var ticks =[];
				var tick = Number(((list[0].rate + list[(list.length-1)].rate)/6).toFixed(1));
				var tArr = 0;
				for(var i = 0; i < 7; i++){
					ticks.push(tArr);
					tArr += tick;
				}
				
				var label={
						x:"",
						y:""
				};
				
				$("#eventChart3").empty();
				hozBar_plus(inputData,"#eventChart3", label, ticks,"#f8f8f8", unit);
				loadingHide('eventChart3');
			}
			
		}
	});
}


/**
 * event1-2 & event2-1. 해당동 업종별 경제효과 text / 주변지역 경제효과 text 
 **/
function upjongAmtChngeText2(){
	$.ajax({
		url:"/onmap/event_effect/upjong_amt_chnge_text2.json",
		data:{
			"ctyCd" : event_config.sessionCtyCd,
			"admiCd" : event_config.selectAmdiCd,
			"startDate" : event_config.selectedStartDate,
			"endDate" : event_config.selectedEndDate,
			"rgnClss" : event_config.selectedRgnClss
		},
		success: function(data) {
			
			// event2-1 업종별 경제효과(매출액 기준)
			if(data.upjongAmtChngeList){
				var list = data.upjongAmtChngeList;
				if(list.length > 0 ){
					$("#upjongAmtTop").text(list[0].cd_nm);
					$("#upjongAmtTop_nm").text(list[0].cd_nm);
				}else{
					$("#upjongAmtTop").text(" - ");
					$("#upjongAmtTop_nm").text(" - ");	
				}
				
//				var amtLen = Math.floor(1e-12 + Math.log(list[0].amt) / Math.LN10);
				var amtSign = "증가";
				if(list[0].rate < 0) amtSign = "감소";
				$("#upjongAmtTop_val").html("<strong>"+(list[0].rate).toFixed(1)+"</strong>% "+amtSign);
				
				// event2-2주제도위의 selectbox값적용 (매출액 기준)
				$("#upAmtMapSelect").val(list[0].code);
				var upjongName = $("#upAmtMapSelect option:selected").text();
				$("#upAmtSelectText").text(upjongName);
				
				// event2-2 주변지역 업종별 경제효과 (매출액 기준)
				upAmtMapChnge(list[0].code);
			}
			
			// event1-2 업종별 경제효과(거래량 기준)
			if(data.upjongRateChngeList){
				var list = data.upjongRateChngeList;
				
				if(list.length > 0 ){
					$("#upjongRateTop").text(list[0].cd_nm);
					$("#upjongRateTop_nm").text(list[0].cd_nm);	
				}else{
					$("#upjongRateTop").text(" - ");
					$("#upjongRateTop_nm").text(" - ");
				}
				
				var cntLen = Math.floor(1e-12 + Math.log(list[0].amt) / Math.LN10);
				var rateSign = "증가";
				if(list[0].rate < 0) rateSign = "감소";

				$("#upjongRateTop_val").html("<strong>"+(list[0].rate).toFixed(1)+"</strong>% "+rateSign);
				
				// event2-2주제도위의 selectbox값적용 (거래량기준)
				$("#upRateMapSelect").val(list[0].code);
				var upjongName = $("#upRateMapSelect option:selected").text();
				$("#upRateSelectText").text(upjongName);
				
				// event2-2 주변지역 업종별 경제효과 (거래량 기준)
				upRateMapChnge(list[0].code);
			}
			
		}
	});
}

/**
 * event2-2. 주변지역 업종별 경제효과 (매출액 기준) text
 * @param upj 업종코드
 */
function upjongRatechngeText1(upj){
	$.ajax({
		url:"/onmap/event_effect/upjong_rate_chnge_text1.json",
		data:{
			"ctyCd" : event_config.sessionCtyCd,
			"admiCd" : event_config.selectAmdiCd,
			"startDate" : event_config.selectedStartDate,
			"endDate" : event_config.selectedEndDate,
			"rgnClss" : event_config.selectedRgnClss,
			"admiAround" : event_config.admiAround,
			"upjongCd" : upj
		},
		success: function(data) {
			
			// event2-2 주변지역 경제효과 list (매출액 기준)
			if(data.areaUpjongAmtChnge){
				var list = data.areaUpjongAmtChnge;
				var listHtml = "";
				for(var i = 0 ; i < list.length ; i++){
					var amtSign = "+";
					if(list[i].rate < 0) amtSign = "-";	
					listHtml +="<tr>";
					listHtml +="<th><em class='rank'>"+(i+1)+"</em>"+list[i].nm+"</th>";
					listHtml +="<td>"+amtSign+" <strong>"+Math.abs(list[i].rate).toFixed(1)+"</strong>%</td>";
					listHtml +="</tr>";
				}
				
				$("#mxmUpjongAmt_list").empty();
				$("#mxmUpjongAmt_list").append(listHtml);
				
			}
			
			if(data.upjongAmtChngeList){
				var list = data.upjongAmtChngeList;
				
				if(list.length > 0){
					var amtSign = "+";
					if(list[0].rate < 0) amtSign = "-";
					$("#mxmAmtUpjong_value").html("<strong>"+amtSign+" "+Math.abs(list[0].rate).toFixed(1)+"</strong>% <span class='temp_font'>증가</span>");
				}else{
					$("#mxmAmtUpjong_value").html("");
				}
				
			}
		}
	});
}

/**
 * event2-2. 주변지역 업종별 경제효과 (거래량 기준) text
 * @param upj 업종코드
 */
function upjongRatechngeText2(upj){
	$.ajax({
		url:"/onmap/event_effect/upjong_rate_chnge_text2.json",
		data:{
			"ctyCd" : event_config.sessionCtyCd,
			"admiCd" : event_config.selectAmdiCd,
			"startDate" : event_config.selectedStartDate,
			"endDate" : event_config.selectedEndDate,
			"rgnClss" : event_config.selectedRgnClss,
			"admiAround" : event_config.admiAround,
			"upjongCd" : upj,
		},
		success: function(data) {
			// event2-2 주변지역 경제효과 list (거래량 기준)
			if(data.rateRank){
				var list = data.rateRank;
				var listHtml = "";
				for(var i = 0 ; i < list.length ; i++){
					var rateSign = "+";
					if(list[i].rate < 0) rateSign = "-";	
					
					listHtml +="<tr>";
					listHtml +="<th><em class='rank'>"+(i+1)+"</em>"+list[i].nm+"</th>";
					listHtml +="<td>"+rateSign+" <strong>"+Math.abs(list[i].rate).toFixed(1)+"</strong>%</td>";
					listHtml +="</tr>";
				}
				$("#mxmUpjongRate_list").empty();
				$("#mxmUpjongRate_list").append(listHtml);
				
			}
			
			if(data.upjongRateChngeList){
				var list = data.upjongRateChngeList;
				
				if(list.length > 0){
					var rateSign = "+";
					if(list[0].rate < 0) rateSign = "-";
					$("#mxmRateUpjong_value").html("<strong>"+rateSign+" "+Math.abs(list[0].rate).toFixed(1)+"</strong>% <span class='temp_font'>증가</span>");	
				}else{
					$("#mxmRateUpjong_value").html("");	
				}
				
				
			}
		}
	});
}


/**
 * event1-2. 주변지역 경제효과 map 주제도
 * @param fid    레이어 아이디
 * @param column 주제도로 표현할 값 (rate, amt)
 **/
function regionAmtChngeMap(fid,column){
	loadingShow('eventMap1');
	$.ajax({
		type: "GET",
		dataType: 'json',
		url:"/onmap/event_effect/salamt_chnge.json",
		data:{
			"ctyCd" : event_config.sessionCtyCd,
			"admiCd" : event_config.selectAmdiCd,
			"startDate" : event_config.selectedStartDate,
			"endDate" : event_config.selectedEndDate,
			"rgnClss" : event_config.selectedRgnClss,
			"admiAround" : event_config.admiAround
		},
		success: function(data) {
			
//			var mapLayer = matchFeature(mapArr[fid].map, data.list, fid);
			var mapLayer = matchFeature2(mapArr[fid].map, data.list, fid, mapArr[fid].layer);
			doAdmiChoropleth3(column, mapArr[fid].layer,colorArr,event_config.selectAmdiCd,fid);

			//set center
			mapReload(fid);
			
			// 지도 범례
			var vals =[1,2,3,4,5];
			var text = "";
			if(column == "amt"){	
				text = '<small> 주변지역 경제효과 </small>';
			}else{
				text = '<small> 주변지역 경제효과 </small>';
			}
			$("#event1_legend").empty();
			$("#event1_legend").append(text);
			makeLengend("event1_legend",colorArr,vals);
			
			// 로딩바  숨기기
			loadingHide('eventMap1');
		}
	});
}

/**
 * event2-2. 주변지역 업종별 경제효과 - 매출액 기준 map 주제도
 * @param upjongCd 업종코드
 **/
function upjongAmtChngeMap(upjongCd){
	loadingShow('eventMap2');
	$.ajax({
		type: "GET",
		dataType: 'json',
		url:"/onmap/event_effect/expndtr_chnge.json",
		data:{
			"ctyCd" : event_config.sessionCtyCd,
			"admiCd" : event_config.selectAmdiCd,
			"startDate" : event_config.selectedStartDate,
			"endDate" : event_config.selectedEndDate,
			"rgnClss" : event_config.selectedRgnClss,
			"admiAround" : event_config.admiAround,
			"upjongCd" : upjongCd
		},
		success: function(data) {
			var fid = "event2";
			
			// popup column의  nm에 업종명 넣기
			mapArr[fid].popup.column[0].nm = $("#upAmtSelectText").text();
			
			var fid = "event2";
			var mapLayer = matchFeature2(mapArr[fid].map, data.list, fid, mapArr[fid].layer);
			doAdmiChoropleth3("rate",mapArr[fid].layer,colorArr,event_config.selectAmdiCd,fid);
			
			// set center
			mapReload(fid);
			
			// 지도 범례
			var vals =[1,2,3,4,5];
			$("#event2_legend").empty();
			$("#event2_legend").append('<small> 주변지역 업종별 경제효과 </small>');
			makeLengend("event2_legend",colorArr,vals);
			
			// 로딩바 숨기기
			loadingHide('eventMap2');
		}
	});
	
}

/**
 * event2-2. 주변지역 업종별 경제효과 - 거래량 기준 map 주제도
 * @param upjongCd 업종코드
 **/
function upjongRateChngeMap(upjongCd){
	loadingShow('eventMap3');
	$.ajax({
		type: "GET",
		dataType: 'json',
		url:"/onmap/event_effect/expndtr_rate_chnge.json",
		data:{
			"ctyCd" : event_config.sessionCtyCd,
			"admiCd" : event_config.selectAmdiCd,
			"startDate" : event_config.selectedStartDate,
			"endDate" : event_config.selectedEndDate,
			"rgnClss" : event_config.selectedRgnClss,
			"admiAround" : event_config.admiAround,
			"upjongCd" : upjongCd
		},
		success: function(data) {
			var fid = "event3";
			
			// popup column의  nm에 업종명 넣기 
			mapArr[fid].popup.column[0].nm = $("#upRateSelectText").text();
			
			var mapLayer = matchFeature2(mapArr[fid].map, data.list, fid, mapArr[fid].layer);
			doAdmiChoropleth3("cnt_rate",mapArr[fid].layer,colorArr, event_config.selectAmdiCd,fid);
			
			// set center
			mapReload(fid);
			
			// 지도 범례
			var vals =[1,2,3,4,5];
			$("#event3_legend").empty();
			$("#event3_legend").append('<small> 주변지역 업종별 경제효과 </small>');
			makeLengend("event3_legend",colorArr,vals);
			
			// 로딩바 숨기기
			loadingHide('eventMap3');
		}
	});

}



/**
 * event3-1. 지역별 유입인구 수 map 주제도
 **/
function eventVisitrMap(){
	loadingShow('eventMap4');
	$.ajax({
		type: "GET",
		dataType: 'json',
		url:"/onmap/event_effect/visitr_cnt_chnge.json",
		data:{
			"ctyCd" : event_config.sessionCtyCd,
			"admiCd" : event_config.selectAmdiCd,
			"startDate" : event_config.selectedStartDate,
			"endDate" : event_config.selectedEndDate,
			"admiAround" : event_config.admiAround,
			"rgnClss" : event_config.selectedRgnClss
		},
		success: function(data) {
			var fid = "event4";
			
			if(data.list && data.list.length > 0){
				for(var j = 0 ; j < data.list.length ; j++){
					var tCnt =  Math.floor(1e-12 + Math.log(data.list[j].in_cnt) / Math.LN10);
					data.list[j].in_cnt_kr = krWonRound(data.list[j].in_cnt,tCnt,1);
				}
			}
			
			var mapLayer = matchFeature(mapArr[fid].map, data.list, fid);
			doAdmiChoropleth3("in_cnt",mapArr[fid].layer,colorArr,event_config.selectAmdiCd,fid);
			
			//set center
			mapReload(fid);
			
			// 지도 범례
			var vals =[1,2,3,4,5];
			$("#event4_legend").empty();
			$("#event4_legend").append('<small> 지역별 유입인구 수 </small>');
			makeLengend("event4_legend",colorArr,vals);
			
			//로딩바 숨기기
			loadingHide('eventMap4');
			
		}
	});
	
}

/**
 * event3-1. 지역별 유입인구 수 text / event3-2. 성/연령별 대표 유입인구 text
 **/
function eventVisitrText(){
	$.ajax({
		url:"/onmap/event_effect/event_visitr_text.json",
		data:{
			"ctyCd" : event_config.sessionCtyCd,
			"admiCd" : event_config.selectAmdiCd,
			"startDate" : event_config.selectedStartDate,
			"endDate" : event_config.selectedEndDate,
			"admiAround" : event_config.admiAround,
			"rgnClss" : event_config.selectedRgnClss
		},
		success: function(data) {
			
			// 지역별 유입소비인구 순위 - 종수
			var visitrTot = 0;
			if(data.visitrTotal){
				// data.visitrTotal의 자리수 구하기
				var tCnt =  Math.floor(1e-12 + Math.log(data.visitrTotal) / Math.LN10);
				
				if(tCnt < 4){  // 1000 이하일 경우
					visitrTot = data.visitrTotal;
				}else{   // 1000 이상일 경우
					if(tCnt%4 != 0){ // 만(4), 억(8), 조(12) 단위로만 표현
						tCnt = 4 * Math.floor(tCnt/4);
					}
					
					visitrTot = krWonRound(data.visitrTotal,tCnt,1);
				}
			}
			$("#visitrTotal").text(visitrTot);
			
			// 지역별 유입소비인구 순위 - 리스트
			if(data.visitrCntList){	
				var visitrHtml = "";
				for(var i = 0; i < data.visitrCntList.length; i++){
					// data.visitrCntList 값 각각의  자리수 구하기
					var vCnt =  Math.floor(1e-12 + Math.log(data.visitrCntList[i].in_cnt) / Math.LN10);
					
					visitrHtml += "<tr>";
					visitrHtml += "<th><em class='rank'>"+(i+1)+"</em>"+data.visitrCntList[i].nm+" :</th>";
					if(vCnt < 4){			// 1000 단위 이하일 경우			
						visitrHtml += "<td><strong>"+data.visitrCntList[i].in_cnt+"</strong>명</td>";
					}else{					// 1000 단위 이상일 경우
						if(vCnt%4 != 0){    // 만(4), 억(8), 조(12) 단위로만 표현
							vCnt = 4 * Math.floor(vCnt/4);
						}
						
						visitrHtml += "<td><strong>"+krWonRound(data.visitrCntList[i].in_cnt,vCnt,1)+"</strong>명</td>";
					}
					visitrHtml += "</tr>";
				}
				$("#visitrCnt").html(visitrHtml);
			}
			
			// 성/연령별 대표 유입소비인구 
			if(data.visitrChartr) $("#visitrChar").text(data.visitrChartr);
			else $("#visitrChar").text(" - ");
			
			if(data.visitrCtznChartr) $("#ctznChar").text(data.visitrCtznChartr);
			else  $("#ctznChar").text(" - ");
		}
	});
}

/**
 * event3-2. 성/연령별 대표 유입인구 graph (stackedGroupedbar)
 **/
function visitrCtznGraph(){
	loadingShow('eventChart4');
	$.ajax({
		url:"/onmap/event_effect/visitr_ctzn_graph.json",
		data:{
			"ctyCd" : event_config.sessionCtyCd,
			"admiCd" : event_config.selectAmdiCd,
			"startDate" : event_config.selectedStartDate,
			"endDate" : event_config.selectedEndDate,
			"rgnClss" : event_config.selectedRgnClss
		},
		success: function(data) {
			var attributes = {
				  "h" : ["manCtzn", "womanCtzn"],
				  "e" : ["manVisitr","womanVisitr"]
			};
			var attributes_ko = {
					  "h" : ["상주인구 남성", "상주인구 여성"],
					  "e" : ["유입인구 남성","유입인구 여성"]
			};
			var legend = [{"value" : "상주인구 남성" , "color" : "#828282", "rate":0}
						 ,{"value" : "상주인구 여성" , "color" : "#d3d3d3", "rate":0}
						 ,{"value" : "유입인구 남성" , "color" : "#2e6695", "rate":0}
						 ,{"value" : "유입인구 여성" , "color" : "#ff8166", "rate":0}];
			
			var inputData =[];
			for(var i = 2; i < 7; i++){
				var chartData = {};
				var detailsArr =[];
				
				chartData.manVisitr = data.list[0]['e_m_'+(i*10)+'_rate'];
				chartData.womanVisitr = data.list[0]['e_f_'+(i*10)+'_rate'];
				chartData.manCtzn = data.list[0]['h_m_'+(i*10)+'_rate'];
				chartData.womanCtzn = data.list[0]['h_f_'+(i*10)+'_rate'];
				chartData.name = (i*10)+"대";
				chartData.total = Math.max((chartData.manVisitr + chartData.womanVisitr) , (chartData.manCtzn + chartData.womanCtzn));
				for(var j = 0 ; j < 2; j++){
					var column = "e";
					if(j > 0) column = "h";
					for(var k = 0 ; k < 2; k++){
						var detailsData = {};
						detailsData.column = column;
						detailsData.name = attributes[column][k];
						detailsData.name_ko = attributes_ko[column][k];
						detailsData.realValue = chartData[attributes[column][k]];
						if(k == 0){
							detailsData.yBegin = 0;
							detailsData.yEnd = chartData[attributes[column][k]];
						}else{
							detailsData.yBegin = chartData[attributes[column][k-1]];
							detailsData.yEnd = chartData[attributes[column][k]] + chartData[attributes[column][k-1]];
						}
						detailsArr.push(detailsData);
						
						//총 비율 계산
						for(var m = 0 ; m < legend.length; m++){
							if(attributes_ko[column][k] == legend[m].value){
								legend[m].rate += chartData[attributes[column][k]];
							}
						}
					}
				}
				
				chartData.columnDetails = detailsArr;
				inputData.push(chartData);
			}	
			
			$("#eventChart4").empty();
			stackedGroupedbar(inputData,"#eventChart4",attributes,legend,6);
			loadingHide('eventChart4');
		}
	});
}

/**
 * event4-2. 유입소비인구 유입지역 순위 Map 주제도 
 **/
function eventCnsmpTimeMap(){
	loadingShow('eventMap6');
	mapUrl = "/onmap/event_effect/getEventCtyMap.json";
	
	if(mapArr["event6"].layer == null || mapArr["event6"].layer === undefined){		
		makeMap(mapUrl, event_config, 'event6', "H2", getData );
	} else {
		getData();
	}
	
	function getData(){
		$.ajax({
			type: "GET",
			dataType: 'json',
			url:"/onmap/event_effect/visitr_cnsmp_time_chnge.json",
			data:{
				"ctyCd" : event_config.sessionCtyCd,
				"admiCd" : event_config.selectAmdiCd,
				"startDate" : event_config.selectedStartDate,
				"endDate" : event_config.selectedEndDate,
				"rgnClss" : "H2"
			},
			success: function(data) {
				var fid="event6";
				
				if(data.list && data.list.length > 0){
					mapArr[fid].popupStop = false;
					for(var i = 0; i < data.list.length; i++){
						data.list[i].rate_kr = data.list[i].rate.toFixed(1);
					}
					
					var mapLayer = matchFeature2(mapArr[fid].map, data.list, fid, mapArr[fid].layer);
					doAdmiChoropleth("rate",mapArr[fid].layer,colorArr,event_config.sessionCtyCd);
					
					
					setConfigBound(fid,event_config.sessionCtyCd, function(){
						// move map 
						mapReload(fid);
					});
				}else{
//					removeLayer(fid);
					mapArr[fid].popupStop =true;
					initStyle(fid, mapArr[fid].layer, event_config.sessionCtyCd)
				}
				
				// 지도 범례
				var vals =[1,2,3,4,5];
				$("#event6_legend").empty();
				$("#event6_legend").append('<small> 유입인구 유입지역 </small>');
				makeLengend("event6_legend",colorArr,vals);
				
				// 로딩바 숨기기
				loadingHide('eventMap6');
				
			}
		});
	}

}

/**
 * event4-1. 유입인구 소비시간 순위 text / event4-2. 유입인구 유입지역 순위 text
 **/
function eventCnsmpTimeText(){
	$.ajax({
		url:"/onmap/event_effect/event_cnsmp_time_text.json",
		data:{
			"ctyCd" : event_config.sessionCtyCd,
			"admiCd" : event_config.selectAmdiCd,
			"startDate" : event_config.selectedStartDate,
			"endDate" : event_config.selectedEndDate,
			"rgnClss" : event_config.selectedRgnClss
		},
		success: function(data) {
			
			// 유입소비인구 소비시간 순위 
			var cnsmpTimeHtml = "";
			var cnsmpTimeTop = "";
			if(data.visitrCnsmpTime.length > 0){	
				cnsmpTimeTop = data.visitrCnsmpTime[0].cd_nm;
				for(var i = 0 ; i < data.visitrCnsmpTime.length; i++){
					cnsmpTimeHtml += "<tr>";
					cnsmpTimeHtml += "<th><em class='rank'>"+(i+1)+"</em>"+data.visitrCnsmpTime[i].cd_nm+" :</th>";
					cnsmpTimeHtml += "<td><strong>"+data.visitrCnsmpTime[i].rate.toFixed(1)+"</strong>%</td>";
					cnsmpTimeHtml += "<tr>";
				}
			}
			$("#cnsmpTimeTop").text(cnsmpTimeTop);
			$("#cnsmpTimeList").html(cnsmpTimeHtml);

			// 유입소비인구 유입지역 순위
			var vInflowHtml = "";
			var vInflowTop = "-";
			if(data.visitrInflow.length > 0){	
				vInflowTop = data.visitrInflow[0].nm;
				for(var i = 0 ; i < data.visitrInflow.length; i++){
					vInflowHtml += "<tr>"
					vInflowHtml += "<th><em class='rank'>"+(i+1)+"</em>"+data.visitrInflow[i].nm+" :</th>";
					vInflowHtml += "<td><strong>"+data.visitrInflow[i].rate.toFixed(1)+"</strong>%</td>";
					vInflowHtml += "</tr>"
				}
			}
			$("#visitrInflowTop").text(vInflowTop);
			$("#visitrInflowList").html(vInflowHtml);
		}
	});
}

/**
 * event4-1. 유입인구 소비시간 graph ( barChart_plus )
 **/
function eventCnsmpTimeGraph(){
	loadingShow('eventChart6');
	$.ajax({
		url:"/onmap/event_effect/event_cnt_time_graph.json",
		data:{
			"ctyCd" : event_config.sessionCtyCd,
			"admiCd" : event_config.selectAmdiCd,
			"startDate" : event_config.selectedStartDate,
			"endDate" : event_config.selectedEndDate,
			"rgnClss" : event_config.selectedRgnClss
		},
		success: function(data) {
			var timeArr = ["00-06","06-09","09-12","12-15","15-18","18-21","21-24"];
			var inputData =[];
			var groupData =[];
			for(var i = 0; i < 2 ; i++){
				var type = "e";
				if(i > 0) type = "h";
				var groupArr =[];
				for(var j = 1; j < 8; j++){
					var chartData = {};
					
					if(type == 'e') chartData.name = "유입 인구";
					else chartData.name = "상주 인구";
					
					if(data.cntTime[0])	chartData.value = data.cntTime[0][type+'_t_'+j+'_cnt'];
					if(data.cntTime[1])	chartData.value = data.cntTime[1][type+'_t_'+j+'_cnt'];
					chartData.x = j;
					chartData.time = timeArr[j-1];
					
					inputData.push(chartData);
					groupArr.push(chartData);
				}	
				groupData.push(groupArr);
			}
			
			var attributes =[
			                 {"name": "유입 인구", "hex": "#ff8166"},
			                 {"name": "상주 인구", "hex": "#d3d3d3"}
			                ];
			
			var label={
					x:"시간대",
					y:"고객수"
			};
			
			inputData.reverse();
			
			$("#eventChart6").empty();
			barChart_plus(inputData, "#eventChart6",attributes,timeArr,label, "#f8f8f8");
			loadingHide('eventChart6');
		}
	});
}

/**
 * 데이터 유효성검사 
 * ( 총경제효과의 평상시 일평균과 이벤트기간의 일평균이 10만원 이하거나  : thisAmtChnge
 * , 업종별 경제효과의 그래프의 업종수가 3개미만 이거나  : thisList
 * , 유입인구 총 수가 100명 이하일 경우 체크 : visitrTotal)
 * @param callback
 */
function validateChk(callback){
//	console.log("1231231231 :::: " + event_config.validateChk.status);
	if(event_config.validateChk.status){
		callback();
	}else{
		
		$.ajax({
			url:"/onmap/event_effect/validateChk.json",
			async : false,
			data:{
				"ctyCd" : event_config.sessionCtyCd,
				"admiCd" : event_config.selectAmdiCd,
				"startDate" : event_config.selectedStartDate,
				"endDate" : event_config.selectedEndDate,
				"rgnClss" : event_config.selectedRgnClss,
				"admiAround" : event_config.admiAround,
				"admiFlg" : event_config.admiFlg
			},
			success: function(data) {
				// 화면 초기화
				$(".eResult1").show();
				$(".eResult2").show();
				$(".eResult3").show();
				event_config.pageError = false;
				event_config.validateChk.result1 = false;
				event_config.validateChk.result2 = false;
				event_config.validateChk.result3 = false;
				
				// 기준 1 비교
				if(data.thisAmtChnge){
					if(data.thisAmtChnge.days_rate && data.thisAmtChnge.term){
						if(data.thisAmtChnge.days_rate >= 100000 && data.thisAmtChnge.term >= 100000){
							event_config.validateChk.result1 = true;
						}
					}
				}
				// 기준 2 비교
				if(data.thisList && data.thisList.length > 3){
					event_config.validateChk.result2 = true;
				}
				// 기준 3 비교
				if(data.visitrTotal && data.visitrTotal >= 100){
					event_config.validateChk.result3 = true;
				}
				
//				console.log(
//						"경제효과 : " + event_config.validateChk.result1 
//						,  data.thisAmtChnge
//						, "업종 수: " + event_config.validateChk.result2
//						, "(업종 수 : " + data.thisList.length +", 기준: 3 )"
//						, "방문객 수: " + event_config.validateChk.result3
//						, "( 방문객 수 : " + data.visitrTotal +", 기준: 100 )"
//				);
				
				// 기준값이 3개 모두 미달일때
				if(!event_config.validateChk.result1 && !event_config.validateChk.result2 && !event_config.validateChk.result3){
					
					event_config.pageError = true;
					$("#dataLack").show();
					$("body").css({"overflow" : "hidden"});
					
					// 총 경제 효과
					$("#amt_rate1_EE").text(" - ");	// 평상시 대비 매출액 변화
					$("#amt_rate_list").empty();    // 평상시 , 이벤트 기간
					$("#eventChart1").empty();      // 그래프
					
					//주변지역 총 경제효과
					$("#sAdmiAmt").text(" - ");		// 매출액기준 해당지역의 비율
					$("#mxmAmt_list").empty();		// 매출액 기준 리스트
					$("#sAdmiRate").text(" - ");	// 거래량 기준 해당지역의 비율
					$("#mxmRate_list").empty();		// 거래량 기준 리스트
					
					//업종별 경제효과
					$("#upjongAmtTop").text(" - ");		 // 매출액 기준 업종명
					$("#upjongAmtTop_nm").text(" - ");	 // 매출액 기준 업종명 
					$("#upjongAmtTop_val").text(" - ");	 // 매출액 기준 업종 증가율
					$("#upjongRateTop").text(" - ");	 // 거래량 기준 업종명
					$("#upjongRateTop_nm").text(" - ");	 // 거래량 기준 업종명
					$("#upjongRateTop_val").text(" - "); // 거래량 기준 업종 증가율
					$("#eventChart2").empty();
					$("#eventChart3").empty();
					
					// 주변지역 업종별 경제효과
					$("#mxmAmtUpjong").text(" - ");			// 매출액 기준 업종명
					$("#mxmAmtUpjong_value").text(" - ");	// 매출액 기준 업종 증가율
					$("#mxmUpjongAmt_list").empty();		// 매출액 기준 리스트
					$("#mxmRateUpjong").text(" - ");		// 거래량 기준 업종명
					$("#mxmRateUpjong_value").text(" - ");	// 거래량 기준 업종 증가율
					$("#mxmUpjongRate_list").empty();		// 거래량 기준 리스트
					
					// 지역별 유입인구 수
					$("#visitrTotal").text(" - ");	// 유입인구 총수
					$("#visitrCnt").empty();		// 유입인구 리스트
					
					// 성/연령별 대표 유동인구
					$("#visitrChar").text(" - ");	// 유입인구 특성
					$("#ctznChar").text(" - ");		// 상주인구 특성
					$("#eventChart4").empty();		// 그래프
					
					// 유입인구 소비시간
					$("#cnsmpTimeTop").text(" - ");	// 유입인구 주요 소비시간대
					$("#cnsmpTimeList").empty();	// 유입인구 리스트
					$("#eventChart6").empty();	// 그래프
					
					//유입인구 유입지역
					$("#visitrInflowTop") .text(" - ");	// 유입인구  주요  유입지역
					$("#visitrInflowList").empty();	// 유입인구 유입지역  리스트
					
//				} else if(event_config.validateChk.result1 && event_config.validateChk.result2 && event_config.validateChk.result3) {
//				// 기준값이 3개 모두 만족일때
//					event_config.pageError = false;
//					callback();
				} else {
					event_config.pageError = false;
					callback();
				}
				
				event_config.validateChk.status = true;
			},
			error: function(e){
				$("#dataLack").show();
				$("body").css({"overflow" : "hidden"});
			}
		});
	}
}