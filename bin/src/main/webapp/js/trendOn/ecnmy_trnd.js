function DateDiff(date1, date2) {
    var datediff = date1.getTime() - date2.getTime(); //store the getTime diff - or +
    return (datediff / (24*60*60*1000)); //Convert values to -/+ days and return value
}

/**
 * 시간 변화에 따른 callbak 함수
 * @param evt
 * @param start	왼쪽 슬라이더의 값 
 * @param end 오른쪽 슬라이더의 값 
 * @param column y축 value
 **/
function dateHandler(evt, start, end, column){
	//안내메시지 숨기기
	$(".group_help").css("display","none");
	
//	ecnmy_trnd_config.selectedStartDate = start.stdr_date;
//	ecnmy_trnd_config.selectedEndDate = end.stdr_date;
	ecnmy_trnd_config.selectedStartDate = dateFomat(start,"");
	ecnmy_trnd_config.selectedEndDate = dateFomat(end,"");

//	var sDate = start.stdr_date.substr(0,4)+". "+start.stdr_date.substr(4,2)+". "+start.stdr_date.substr(6);
//	var eDate = end.stdr_date.substr(0,4)+". "+end.stdr_date.substr(4,2)+". "+end.stdr_date.substr(6);
	var sDate = dateFomat( start, ". ")
	var eDate = dateFomat( end, ". ")
	$(".search_period").text(sDate+" ~ "+eDate);

	if(timeHandlerId){
		clearTimeout(timeHandlerId);
	}
	timeHandlerId = setTimeout(function(){
		sectionFunc[lastAnchorLink].action();
    },1000);
}

/**
 * 기간직접입력에서 확인 버튼 클릭시
 **/
function changePeriod(){
	var sPeriod = $("#popSelectedSdate").text().split(".");
	var ePeriod = $("#popSelectedEdate").text().split(".");
	var	sdate =  sPeriod[0].trim()+sPeriod[1].trim()+sPeriod[2].trim();
	var	edate =  ePeriod[0].trim()+ePeriod[1].trim()+ePeriod[2].trim();
	
	var selectedEdate = new Date(edate.substr(0,4)+"-"+edate.substr(4,2)+"-"+edate.substr(6,2));
	var selectedSdate = new Date(sdate.substr(0,4)+"-"+sdate.substr(4,2)+"-"+sdate.substr(6,2));
	
	var maxDate = new Date(selectedEdate);
//	maxDate.setMonth(maxDate.getMonth()+12);
	maxDate.setMonth(maxDate.getMonth() - ecnmy_trnd_config.maxPeriod);
	var minDate = new Date(selectedEdate);
//	minDate.setDate(minDate.getDate()+2);
	minDate.setDate(minDate.getDate()- ecnmy_trnd_config.minPeriod);
	
	
	
	var maxPeriod = selectedEdate.getTime() - maxDate.getTime();
	var minPeriod = selectedEdate.getTime() - minDate.getTime();
	var selectedPeriod = selectedEdate.getTime() - selectedSdate.getTime();
//	maxPeriod = Math.ceil(maxPeriod / (1000 * 3600 * 24)) + 1;
//	minPeriod = Math.ceil(minPeriod / (1000 * 3600 * 24)) + 1;
//	selectedPeriod = Math.ceil(selectedPeriod / (1000 * 3600 * 24)) + 1;
	
	// 2일보다 저게 선택했을때 / 월수가 선택 가능 개월 이상일때
	if(selectedPeriod < minPeriod || selectedPeriod > maxPeriod ){
		alert("기간을 다시 선택해주세요.");
		return false;
	}else{
		ecnmy_trnd_config.selectedStartDate = sdate;
		ecnmy_trnd_config.selectedEndDate = edate;

		// 시계열 그래프의 range slider 위치 변경
		timeChart.setVal(yyyymmddToDate(sdate),yyyymmddToDate(edate));
		// 기간직접입력버튼 옆의 기간 text 변경
		$(".search_period").text($("#popSelectedSdate").text() + " ~ " + $("#popSelectedEdate").text());
		// 기간직접입력 popup창 닫음
		$(".btn_close").trigger("click");
		// 현재위치의 내용 변경
		sectionFunc[lastAnchorLink].action();
		// 시계열위의 메시지창 없애기
		$(".group_help").css("display","none");
	}

}
	
/**
 * 트렌드1. 지역별 거래금액 map 주제도
 *  @param ctyCd 지역 코드
 *  @param map 주제도를 적용시킬 map	
 *  @param layer 주제도를 적용시킬 layer
 *  @param comNum 지역간 비교일 경우 좌측은 1 우측은 2 , 지역간 비교가 아닌경우 ""
 *  @param callback 지역간 비교를 위해 화면에서 처음 그려지는 data 저장
 *  @param resultData 지역간 비교의 좌측내용 호출시 callback 함수로 저장해 놓았던 data를 이용
 **/
function amtDataMap(fid, ctyCd, comNum, callback, resultData){
	var idNum = fid.replace("trend","");
	loadingShow("trendMap"+idNum);
	if(resultData){
		mapCholopleth(resultData.map);
		getLegend();
	}else{
		$.ajax({
			type: "GET",
			dataType: 'json',
			url:"/onmap/ecnmy_trnd/salamt.json",
			data:{
				"ctyCd" : ctyCd,
				"startDate" : ecnmy_trnd_config.selectedStartDate,
				"endDate" : ecnmy_trnd_config.selectedEndDate,
				"rgnClss" : ecnmy_trnd_config.selectedRgnClss
			},
			success: function(data) {
				if(data.list && data.list.length > 0){
					for(var j = 0 ; j < data.list.length ; j++){
						var tCnt =  Math.floor(1e-12 + Math.log(data.list[j].sale_amt) / Math.LN10);
						data.list[j].sale_amt_kr = krWonRound(data.list[j].sale_amt,tCnt,1);
					}
				}
				
				mapArr[fid].popupStop = false;
				mapCholopleth (data);
				
				if(callback){
					callback("map",data);
				}
			}
		});
	
		// 지도 범례
		getLegend();
	}
	
	function mapCholopleth (data){
		var mapLayer = matchFeature2(mapArr[fid].map, data.list, fid, mapArr[fid].layer);
		doAdmiChoropleth("sale_amt",mapLayer,colorArr);
		loadingHide("trendMap"+idNum);
		
	}
	
	function getLegend(){
		var vals =[1,2,3,4,5];
		$("#ecnmyTrnd_salamt_legend"+comNum).empty();
		$("#ecnmyTrnd_salamt_legend"+comNum).append('<small> 지역별 거래금액  </small>');
		makeLengend("ecnmyTrnd_salamt_legend"+comNum,colorArr,vals);
		
	}
}

/**
 * 트렌드1. 지역별 거래금액 text / 업종별 거래금액 text
 *  @param ctyCd 지역 코드
 *  @param comNum 지역간 비교일 경우 좌측은 1 우측은 2 , 지역간 비교가 아닌경우 ""
 *  @param callback 지역간 비교를 위해 화면에서 처음 그려지는 data 저장
 *  @param resultData 지역간 비교의 좌측내용 호출시 callback 함수로 저장해 놓았던 data를 이용
 **/
function amtDataText(ctyCd, comNum, callback, resultData){
	if(resultData){
		setText(resultData);
	}else{
		$.ajax({
			url : '/onmap/ecnmy_trnd/ecnmy_trnd_amt_text.json',
			data:{
				"ctyCd" : ctyCd,
				"megaCd" : ctyCd.substr(0,2),
				"startDate" : ecnmy_trnd_config.selectedStartDate,
				"endDate" : ecnmy_trnd_config.selectedEndDate,
				"rgnClss" : ecnmy_trnd_config.selectedRgnClss
			},
			success: function(result, status) {
				setText(result);
				
				if(callback){
					callback (result);
				}
			}
		});
	}
	
	function setText(result){
		
		// ET1. 지역별 거래금액  amtRankList
		if(result.amtRankList.length > 0){
			var total = 0;
			var amtHtml = "";
			
			for(var i = 0 ; i < result.amtRankList.length; i++){
				// 값 각각의  자리수 구하기
				var tCnt =  Math.floor(1e-12 + Math.log(result.amtRankList[i].sale_amt) / Math.LN10);
				if(tCnt > 4){		    // 1000 단위 이상일 경우
					if(tCnt%4 != 0){    // 만(4), 억(8), 조(12) 단위로만 표현
						tCnt = 4 * Math.floor(tCnt/4);
					}
				}
				
				if(comNum){
					amtHtml +="<li><dl>";
					amtHtml +="<dt><em>"+(i+1)+"</em><span>"+result.amtRankList[i].admi_nm+"</span></dt>";
					amtHtml +="<dd>"+krWonRound(result.amtRankList[i].sale_amt,tCnt,1)+"</dd>";
					amtHtml +="</dl></li>";
				}else{
					amtHtml +="<tr>";
					amtHtml += "<th><em class='rank'>" + (i+1)+"</em>"+result.amtRankList[i].admi_nm + "</th>";
					amtHtml += "<td><strong>" + krWonRound(result.amtRankList[i].sale_amt,tCnt,1) + "</strong>원</td>";
					amtHtml += "</tr>";
				}
			}

			$("#amt_list"+comNum).empty();
			$("#amt_list"+comNum).append(amtHtml);
		}
		
		// ET1.지역별 거래금액 총거래금액  amtTotal
		if(result.amtTotal){		
			// 값 각각의  자리수 구하기
			var aCnt =  Math.floor(1e-12 + Math.log(result.amtTotal) / Math.LN10);
			if(aCnt > 4){		    // 1000 단위 이상일 경우
				if(aCnt%4 != 0){    // 만(4), 억(8), 조(12) 단위로만 표현
					aCnt = 4 * Math.floor(aCnt/4);
				}
			}
			$('#amtTotal_ET'+comNum).empty();
			$('#amtTotal_ET'+comNum).append("<strong>"+krWonRound(result.amtTotal,aCnt,1)+"</strong>원");
		}
		
		// ET1.업종별 거래금액  indutyRankList
		if(result.indutyRankList.length > 0){
			// 최대 판매 업종
			$('#upTotal_ET'+comNum).empty();
			$('#upTotal_ET'+comNum).append(result.indutyRankList[0].cd_nm);
			
			// 업종별 거래금액 리스트
			var upHtml = "";
			for(var i = 0; i < result.indutyRankList.length; i++){
				// 값 각각의  자리수 구하기
				var iCnt =  Math.floor(1e-12 + Math.log(result.indutyRankList[i].sale_amt) / Math.LN10);
				if(iCnt > 4){		    // 1000 단위 이상일 경우
					if(iCnt%4 != 0){    // 만(4), 억(8), 조(12) 단위로만 표현
						iCnt = 4 * Math.floor(iCnt/4);
					}
				}
				
				if(comNum){
					upHtml +="<li><dl>";
					upHtml +="<dt><em>"+(i+1)+"</em><span>"+result.indutyRankList[i].cd_nm+"</span></dt>";
					upHtml +="<dd>"+krWonRound(result.indutyRankList[i].sale_amt,iCnt,1)+"</dd>";
					upHtml +="</dl></li>";
				}else{
					upHtml += "<tr>";
					upHtml += "<th><em class='rank'>" + (i+1)+"</em>"+result.indutyRankList[i].cd_nm + " :"+"<th>";
					upHtml += "<td><strong>" + krWonRound(result.indutyRankList[i].sale_amt,iCnt,1) + "</strong>원</td>";
					upHtml += "</tr>";
				}
				
			}
			
			$("#upAmt_list"+comNum).empty();
			$("#upAmt_list"+comNum).append(upHtml);
			
		}
		
	}

}

/**
 * 트렌드1. 업종별 거래금액 graph(treemap)
 *  @param ctyCd 지역 코드
 *  @param comNum 지역간 비교일 경우 좌측은 1 우측은 2 , 지역간 비교가 아닌경우 ""
 *  @param callback 지역간 비교를 위해 화면에서 처음 그려지는 data 저장
 *  @param resultData 지역간 비교의 좌측내용 호출시 callback 함수로 저장해 놓았던 data를 이용
 *  @param backColor d3plus 차트 이용시 차트위치의 background color에 따라 다른 color 지정
 **/
function amtDataGraph(ctyCd, comNum, callback, resultData, backColor){
	loadingShow('amtTreemap'+comNum);
	if(backColor === undefined)backColor = "#f8f8f8";backColor;
	
	if(resultData){
		getGraph(resultData, backColor);
	}else{
		$.ajax({
			url : '/onmap/ecnmy_trnd/ecnmy_trnd_amt_chart.json',
			data:{
				"ctyCd" : ctyCd,
				"startDate" : ecnmy_trnd_config.selectedStartDate,
				"endDate" : ecnmy_trnd_config.selectedEndDate
			},
			success: function(result, status) {
				getGraph(result, backColor);
				
				if(callback){
					callback(result);
				}
			}
		});
	}

	function getGraph(result, bColor){
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
			
			$("#amtTreemap"+comNum).empty();
			treemap_plus(data, "#amtTreemap"+comNum, bColor);
		}
		loadingHide('amtTreemap'+comNum);
	}
}

/**
 * 트렌드2. 지역별 유입인구수 map 주제도
 *  @param fid 주제도를 적용 시킬 layer id
 *  @param ctyCd 지역 코드
 *  @param comNum 지역간 비교일 경우 좌측은 1 우측은 2 , 지역간 비교가 아닌경우 ""
 *  @param callback 지역간 비교를 위해 화면에서 처음 그려지는 data 저장
 *  @param resultData 지역간 비교의 좌측내용 호출시 callback 함수로 저장해 놓았던 data를 이용
 **/
function visitrCoMap(fid, ctyCd, comNum, callback, resultData){
	var idNum = fid.replace("trend","");
	loadingShow("trendMap"+idNum);
	if(resultData){
		mapCholopleth(resultData.map);
		getLegend();
	}else{
		$.ajax({
			type: "GET",
			dataType: 'json',
			url:"/onmap/ecnmy_trnd/visitr_co.json",
			data:{
				"ctyCd" : ctyCd,
				"startDate" : ecnmy_trnd_config.selectedStartDate,
				"endDate" : ecnmy_trnd_config.selectedEndDate,
				"rgnClss" : ecnmy_trnd_config.selectedRgnClss
			},
			success: function(data) {
				
				if(data.list && data.list.length > 0){
					for(var j = 0 ; j < data.list.length ; j++){
						var tCnt =  Math.floor(1e-12 + Math.log(data.list[j].total_cnt) / Math.LN10);
						if(tCnt < 3){							
							data.list[j].total_cnt_kr = data.list[j].total_cnt;
						}else{							
							data.list[j].total_cnt_kr = krWonRound(data.list[j].total_cnt,tCnt,1);
						}
					}
				}
				
				mapArr[fid].popupStop = false;
				mapCholopleth(data);
				
				if(callback){
					callback('map',data);
				}
			}
		});

		// 지도 범례
		getLegend();
	}
	
	function mapCholopleth(data){
		var mapLayer = matchFeature2(mapArr[fid].map, data.list, fid, mapArr[fid].layer);
		doAdmiChoropleth("total_cnt",mapLayer,colorArr);
		loadingHide("trendMap"+idNum);
	}
	
	function getLegend(){
		var vals =[1,2,3,4,5];
		$("#ecnmyTrnd_cnt_legend"+comNum).empty();
		$("#ecnmyTrnd_cnt_legend"+comNum).append('<small>  지역별 유입인구 수  </small>');
		makeLengend("ecnmyTrnd_cnt_legend"+comNum ,colorArr ,vals);
		
	}

}

/**
 * 트렌드2. 지역별 유입인구수 text / 성/연령별 대표 유입인구 text
 *  @param ctyCd 지역 코드
 *  @param comNum 지역간 비교일 경우 좌측은 1 우측은 2 , 지역간 비교가 아닌경우 ""
 *  @param callback 지역간 비교를 위해 화면에서 처음 그려지는 data 저장
 *  @param resultData 지역간 비교의 좌측내용 호출시 callback 함수로 저장해 놓았던 data를 이용
 **/
function visitrCoText(ctyCd, comNum, callback, resultData){
	if(resultData){
		setText(resultData)
	}else{
		$.ajax({
			url : '/onmap/ecnmy_trnd/ecnmy_trnd_visitrCo_text.json',
			data:{
				"ctyCd" : ctyCd,
				"megaCd" : ctyCd.substr(0,2),
				"startDate" : ecnmy_trnd_config.selectedStartDate,
				"endDate" : ecnmy_trnd_config.selectedEndDate,
				"rgnClss" : ecnmy_trnd_config.selectedRgnClss
			},
			success: function(result, status) {
				setText(result);
				
				if(callback){
					callback(result);
				}
			}
		});
	}

	function setText(result){
		
		// ET2. 지역별 유입인구 visitrRankList
		var vstHtml = "";
		var vsLength = 4;
		if(result.visitrRankList.length > 0){
			for(var i = 0 ; i < result.visitrRankList.length; i++){
				// 값 각각의  자리수 구하기
				var vCnt =  Math.floor(1e-12 + Math.log(result.visitrRankList[i].total_cnt) / Math.LN10);
				if(vCnt > 4){		    // 1000 단위 이상일 경우
					if(vCnt%4 != 0){    // 만(4), 억(8), 조(12) 단위로만 표현
						vCnt = 4 * Math.floor(vCnt/4);
					}
				}
				
				if(comNum){
					vstHtml +="<li><dl>";
					vstHtml +="<dt><em>"+(i+1)+"</em><span>"+result.visitrRankList[i].nm+"</span></dt>";
					vstHtml +="<dd>"+krWonRound(result.visitrRankList[i].total_cnt,vCnt,1)+"</dd>";
					vstHtml +="</dl></li>";
				}else{
					vstHtml += "<tr>";
					vstHtml += "<th><em class='rank'>" + (i+1)+"</em>"+result.visitrRankList[i].nm + " :</th>";
					vstHtml += "<td><strong>" + krWonRound(result.visitrRankList[i].total_cnt,vCnt,1) + "</strong>명</td>";
					vstHtml += "</tr>";
				}
			}
			$("#vst_list"+comNum).empty();
			$("#vst_list"+comNum).append(vstHtml);
		}
		
		// ET2. 지역별 유입인구 총수 visitrTotal 
		if(result.visitrTotal){			
			// 값 각각의  자리수 구하기
			var tCnt =  Math.floor(1e-12 + Math.log(result.visitrTotal) / Math.LN10);
			if(tCnt > 4){		    // 1000 단위 이상일 경우
				if(tCnt%4 != 0){    // 만(4), 억(8), 조(12) 단위로만 표현
					tCnt = 4 * Math.floor(tCnt/4);
				}
			}
			
			$('#vstTotal_ET'+comNum).empty();			
			$('#vstTotal_ET'+comNum).append("<strong>" + krWonRound(result.visitrTotal,tCnt,1) + "<strong>명");			
		}
		
		// ET2. 성/연령 대표 유입인구 특성 visitrChartrList
		if(result.visitrChartrList.length > 0){
			$('#vst_char_ET'+comNum).html("<strong>"+result.visitrChartrList[0].chr+"</strong>");
		}
		// ET2. 성/연령 대표  지역주민 특성 ctznChartrList
		if(result.ctznChartrList.length > 0){
			$('#ctzn_char_ET'+comNum).html("<strong>"+result.ctznChartrList[0].chr+"</strong>");
		}
		
		
	}
}

/**
 * 트렌드2. 성/연령별 대표 유입인구 graph (stackedGroupedbar)
 *  @param ctyCd 지역 코드
 *  @param comNum 지역간 비교일 경우 좌측은 1 우측은 2 , 지역간 비교가 아닌경우 ""
 *  @param callback 지역간 비교를 위해 화면에서 처음 그려지는 data 저장
 *  @param resultData 지역간 비교의 좌측내용 호출시 callback 함수로 저장해 놓았던 data를 이용
 **/
function visitrCoGraph(ctyCd, comNum, callback, resultData){
	loadingShow("cntBar"+comNum);
	if(resultData){
		getGraph(resultData);
	}else{
		$.ajax({
			url : '/onmap/ecnmy_trnd/ecnmy_trnd_visitrCo_chart.json',
			data:{
				"ctyCd" : ctyCd,
				"megaCd" : ctyCd.substr(0,2),
				"startDate" : ecnmy_trnd_config.selectedStartDate,
				"endDate" : ecnmy_trnd_config.selectedEndDate,
				"rgnClss" : ecnmy_trnd_config.selectedRgnClss
			},
			success: function(result, status) {
				getGraph(result);
			}
		});
	}

	function getGraph(result){
		var cntBarData = result.cntList;
		
		if(cntBarData){
			var attributes = {
					  "h" : ["manCtzn", "womanCtzn"],
					  "e" : ["manVisitr","womanVisitr"]
			};
			var attributes_ko = {
					  "h" : ["상주인구 남성", "상주인구 여성"],
					  "e" : ["유입인구 남성","유입인구 여성"]
			};
			var legend = [{"value" : "상주인구 남성" , "color" : "#9b9b9b", "rate":0}
						 ,{"value" : "상주인구 여성" , "color" : "#d3d3d3", "rate":0}
						 ,{"value" : "유입인구 남성" , "color" : "#2e6695", "rate":0}
						 ,{"value" : "유입인구 여성" , "color" : "#ff8166", "rate":0}];
			
			var inputData =[];
			for(var i = 2; i < 7; i++){
				var chartData = {};
				var detailsArr =[];
				
				chartData.manVisitr = cntBarData[0]['e_m_'+(i*10)+'_rate'];
				chartData.womanVisitr = cntBarData[0]['e_f_'+(i*10)+'_rate'];
				chartData.manCtzn = cntBarData[0]['h_m_'+(i*10)+'_rate'];
				chartData.womanCtzn = cntBarData[0]['h_f_'+(i*10)+'_rate'];
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
			
			$("#cntBar"+comNum).empty();
			if(comNum){
				stackedGroupedbar(inputData,"#cntBar"+comNum,attributes,legend, 3);				
			}else{				
				stackedGroupedbar(inputData,"#cntBar"+comNum,attributes,legend, 6);
			}
			loadingHide("cntBar"+comNum);
		}
		
		if(callback){
			callback(result);
		}
	}
}

/**
 * 트렌드3. 지역별 유입인구 소비 map 주제도
 *  @param fid 주제도를 적용시킬 레이어 id
 *  @param ctyCd 지역 코드
 *  @param comNum 지역간 비교일 경우 좌측은 1 우측은 2 , 지역간 비교가 아닌경우 ""
 *  @param callback 지역간 비교를 위해 화면에서 처음 그려지는 data 저장
 *  @param resultData 지역간 비교의 좌측내용 호출시 callback 함수로 저장해 놓았던 data를 이용
 **/
function visitrExpndtrMap(fid, ctyCd, comNum, callback, resultData){
	var idNum = fid.replace("trend","");
	loadingShow("trendMap"+idNum);
	if(resultData){
		 mapCholopleth(resultData.map);
		 getLegend();
	}else{
		$.ajax({
			type: "GET",
			dataType: 'json',
			url:"/onmap/ecnmy_trnd/visitr_expndtr.json",
			data:{
				"ctyCd" : ctyCd,
				"startDate" : ecnmy_trnd_config.selectedStartDate,
				"endDate" : ecnmy_trnd_config.selectedEndDate,
				"rgnClss" : ecnmy_trnd_config.selectedRgnClss
			},
			success: function(data) {
				
				if(data.list && data.list.length > 0){
					for(var j = 0 ; j < data.list.length ; j++){
						var tCnt =  Math.floor(1e-12 + Math.log(data.list[j].sale_amt) / Math.LN10);
						data.list[j].sale_amt_kr = krWonRound(data.list[j].sale_amt,tCnt,1);
					}
				}
				
				mapArr[fid].popupStop = false;
				mapCholopleth(data);
			}
		});

		// 지도 범례
		getLegend();
	}
	
	function mapCholopleth(data){
		var mapLayer = matchFeature2(mapArr[fid].map, data.list, fid, mapArr[fid].layer);
		doAdmiChoropleth("sale_amt",mapLayer,colorArr);
		loadingHide("trendMap"+idNum);
		
		if(callback){
			callback("visitrExpndtrMap", data);
		}
	}
	
	function getLegend(){
		var vals =[1,2,3,4,5];
		$("#ecnmyTrnd_expndtr_legend"+comNum).empty();
		$("#ecnmyTrnd_expndtr_legend"+comNum).append('<small> 지역별 유입인구 소비금액 </small>');
		makeLengend("ecnmyTrnd_expndtr_legend"+comNum,colorArr,vals);
		
	}

}

/**
 * 트렌드3. 지역별 유입인구 소비 text 
 *  @param ctyCd 지역 코드
 *  @param comNum 지역간 비교일 경우 좌측은 1 우측은 2 , 지역간 비교가 아닌경우 ""
 *  @param callback 지역간 비교를 위해 화면에서 처음 그려지는 data 저장
 *  @param resultData 지역간 비교의 좌측내용 호출시 callback 함수로 저장해 놓았던 data를 이용
 **/
function visitrExpndtrText(ctyCd, comNum, callback, resultData){
	
	if(resultData){
		setText(resultData);
	}else{
		$.ajax({
			url : '/onmap/ecnmy_trnd/ecnmy_trnd_expndtr_text.json',
			data:{
				"ctyCd" : ctyCd,
				"megaCd" : ctyCd.substr(0,2),
				"startDate" : ecnmy_trnd_config.selectedStartDate,
				"endDate" : ecnmy_trnd_config.selectedEndDate,
				"rgnClss" : ecnmy_trnd_config.selectedRgnClss
			},
			success: function(result, status) {
				setText(result);
			}
		});
	}
	
	function setText(result){
		
		// ET3. 지역별 유입인구 소비 cnsmpList
 		var cnsmpHtml = "";
		if(result.cnsmpList.length > 0){
			for(var i = 0 ; i < result.cnsmpList.length; i++){
				// 값 각각의  자리수 구하기
				var tCnt =  Math.floor(1e-12 + Math.log(result.cnsmpList[i].sale_amt) / Math.LN10);
				if(tCnt > 4){		    // 1000 단위 이상일 경우
					if(tCnt%4 != 0){    // 만(4), 억(8), 조(12) 단위로만 표현
						tCnt = 4 * Math.floor(tCnt/4);
					}
				}
				
				if(comNum){
					cnsmpHtml +="<li><dl>";
					cnsmpHtml +="<dt><em>"+(i+1)+"</em><span>"+result.cnsmpList[i].nm+"</span></dt>";
					cnsmpHtml +="<dd>"+krWonRound(result.cnsmpList[i].sale_amt,tCnt,1)+"</dd>";
					cnsmpHtml +="</dl></li>";
				}else{
					cnsmpHtml += "<tr>";
					cnsmpHtml += "<th><em class='rank'>" + (i+1)+"</em>"+result.cnsmpList[i].nm + " :</th>";
					cnsmpHtml += "<td><strong>" + krWonRound(result.cnsmpList[i].sale_amt,tCnt,1) + "</strong>원</td>";
					cnsmpHtml += "</tr>";
				}
			}
			
			$('#cnsmp_list'+comNum).empty();
			$('#cnsmp_list'+comNum).append(cnsmpHtml);
		}
		
		// ET3. 지역별 유입인구 소비 총액 cnsmpTotal
 		if(result.cnsmpTotal){
 			// 값 각각의  자리수 구하기
			var cCnt =  Math.floor(1e-12 + Math.log(result.cnsmpTotal) / Math.LN10);
			if(cCnt > 4){		    // 1000 단위 이상일 경우
				if(cCnt%4 != 0){    // 만(4), 억(8), 조(12) 단위로만 표현
					cCnt = 4 * Math.floor(cCnt/4);
				}
			}
			
 			$('#cnsmpTotal_ET'+comNum).empty(); 			
 			$('#cnsmpTotal_ET'+comNum).append("<strong>" + krWonRound(result.cnsmpTotal,cCnt,1) + "</strong>원"); 			
 		}
		
		if(callback){
			callback(result);
		}
	}

}

/**
 * 트렌드3. 유입인구 소비특성 graph (hozBar_plus) / 유입인구 소비특성 text
 *  @param ctyCd 지역 코드
 *  @param comNum 지역간 비교일 경우 좌측은 1 우측은 2 , 지역간 비교가 아닌경우 ""
 *  @param callback 지역간 비교를 위해 화면에서 처음 그려지는 data 저장
 *  @param resultData 지역간 비교의 좌측내용 호출시 callback 함수로 저장해 놓았던 data를 이용
 *  @param backColor d3plus 차트 이용시 차트위치의 background color에 따라 다른 color 지정
 **/
function visitrExpndtrGraph(ctyCd, comNum, callback, resultData, backColor){
	loadingShow("expndtrBar1"+comNum);  
	loadingShow("expndtrBar2"+comNum);
	if(backColor === undefined)backColor = "#f8f8f8";
	
	if(resultData){
		getGraph(resultData, backColor);
	}else{
		$.ajax({
			url : '/onmap/ecnmy_trnd/ecnmy_trnd_expndtr_chart.json',
			data:{
				"ctyCd" : ctyCd,
				"megaCd" : ctyCd.substr(0,2),
				"startDate" : ecnmy_trnd_config.selectedStartDate,
				"endDate" : ecnmy_trnd_config.selectedEndDate
			},
			success: function(result, status) {
				getGraph(result, backColor);
				
				if(callback){
					callback(result);
				}
			}
		});
	}
	
	function getGraph(result, bColor){
		var mostCommonData = result.mostCommonList;
		var mostSpecializedData = result.mostSpecializedList;
		
		if(mostCommonData){
			var data =[];
			var mcUnit ={"form":"won","length":8}
			for(var i = 0; i < mostCommonData.length; i++){
				var chartData = {};
				chartData.name = mostCommonData[i].cd_nm;
				chartData.value = mostCommonData[i].sale_amt;
				chartData.y = i+1;
				chartData.hex = '#2e6695';
				
				data.push(chartData);
				
				var valueLen = Math.floor(1e-12 + Math.log(chartData.value) / Math.LN10);
				if(mcUnit.length > valueLen) mcUnit.length = valueLen;
			}
			var ticks =[];
			var tick = Number(((mostCommonData[0].sale_amt + mostCommonData[(mostCommonData.length-1)].sale_amt)/6).toFixed(1));
			var tArr = 0;
			for(var i = 0; i < 7; i++){
				ticks.push(tArr);
				tArr += tick;
			}
			
			// 유입인구 소비특성 text (활성업종)
			$('#up_cnsmpTotal_ET'+comNum).html(mostCommonData[0].cd_nm);
			$('#up_cnsmp_nm_ET'+comNum).html(mostCommonData[0].cd_nm+":");
			
			// 값 각각의  자리수 구하기
			var mCnt =  Math.floor(1e-12 + Math.log(mostCommonData[0].sale_amt) / Math.LN10);
			if(mCnt > 4){		    // 1000 단위 이상일 경우
				if(mCnt%4 != 0){    // 만(4), 억(8), 조(12) 단위로만 표현
					mCnt = 4 * Math.floor(mCnt/4);
				}
			}
			$('#up_cnsmp_val_ET'+comNum).html("<strong>"+krWonRound(mostCommonData[0].sale_amt,mCnt,1)+"</strong>원");
			
			var label={
					x:"소비 금액",
					y:"업종"
			};
			
			$("#expndtrBar1"+comNum).empty();
			hozBar_plus(data, "#expndtrBar1"+comNum, label, ticks, bColor, mcUnit);
			
		}
		
		if(mostSpecializedData){
			var data =[];
			var msUnit ={"form":"index","length":0}
			for(var i = 0; i < mostSpecializedData.length; i++){
				var chartData = {};
				chartData.name = mostSpecializedData[i].cd_nm;
				chartData.value = mostSpecializedData[i].rate;
				chartData.y = i+1;
				chartData.hex = '#2e6695';
				
				data.push(chartData);
			}
			
			var ticks =[];
			var tick = Number(((mostSpecializedData[0].rate + mostSpecializedData[(mostSpecializedData.length-1)].rate)/6).toFixed(1));
			var tArr = 0;
			for(var i = 0; i < 7; i++){
				ticks.push(tArr);
				tArr += tick;
			}
			
			// 유입인구 소비특성 text (특화업종)
			$('#up_spacialTotal_ET'+comNum).html(mostSpecializedData[0].cd_nm);
			$('#up_spacial_nm_ET'+comNum).html(mostSpecializedData[0].cd_nm+":");
			$('#up_spacial_val_ET'+comNum).html("<strong>"+mostSpecializedData[0].rate+"</strong>");
			
			var label={
					x:"소비 특화지수",
					y:"업종"
			};
			
			$("#expndtrBar2"+comNum).empty();
			hozBar_plus(data, "#expndtrBar2"+comNum ,label, ticks, bColor, msUnit);
		}
		
		loadingHide("expndtrBar1"+comNum);
		loadingHide("expndtrBar2"+comNum);
	}
}

/**
 * 트렌드4. 유입인구 유입지역 순위 map 주제도
 *  @param fid 주제도를 적용시킬 layer id 
 *  @param ctyCd 지역 코드
 *  @param comNum 지역간 비교일 경우 좌측은 1 우측은 2 , 지역간 비교가 아닌경우 ""
 *  @param callback 지역간 비교를 위해 화면에서 처음 그려지는 data 저장
 *  @param resultData 지역간 비교의 좌측내용 호출시 callback 함수로 저장해 놓았던 data를 이용
 **/
function visitrInflowMap(fid, ctyCd, comNum, callback, resultData){
	var idNum = fid.replace("trend","");
	loadingShow("trendMap"+idNum);
	if(resultData){
		mapCholopleth(resultData.map);
		getLegend();
	}else{
		mapUrl = "/onmap/ecnmy_trnd/getTrndCtyMap.json"; 
		if(mapArr["trend1_4"].layer == null || mapArr["trend1_4"].layer === undefined){
			makeMap(mapUrl, ecnmy_trnd_config, 'trend1_4', "H2", getData);	
		}else if(mapArr["trend2_4"].layer == null || mapArr["trend2_4"].layer === undefined){
			makeMap(mapUrl, ecnmy_trnd_config, 'trend2_4', "H2", getData);	
		}else{
			getData();
		}
	}
	
	function getData(){
		$.ajax({
			type: "GET",
			dataType: 'json',
			url:"/onmap/ecnmy_trnd/visitr_inflow.json",
			data:{
				"ctyCd" : ctyCd,
				"startDate" : ecnmy_trnd_config.selectedStartDate,
				"endDate" : ecnmy_trnd_config.selectedEndDate,
				"rgnClss" : "H2"
			},
			success: function(data) {
				
				if(data.list && data.list.length > 0){
					for(var j = 0 ; j < data.list.length ; j++){
						data.list[j].rate_kr = data.list[j].rate.toFixed(1);
						data.list[j].rate = data.list[j].rate.toFixed(1);
					}
					mapArr[fid].popupStop = false;
					
					if(fid == 'trend1_4'){
						mapArr['trend2_4'].popupStop = false;
					}
				}
				
				mapCholopleth(data);
				
				if(callback){
					callback("visitrInflowMap",data);
				}
			}
		});
		
		// 지도 범례
		getLegend();
	}
	
	function mapCholopleth(data){
		var mapLayer = matchFeature2(mapArr[fid].map, data.list, fid, mapArr[fid].layer);
//		doAdmiChoropleth("rate",mapLayer,colorArr);
		doAdmiChoropleth("rate",mapLayer,colorArr,ctyCd);
//		mapArr[fid].zoom = mapArr[fid].map.getZoom();
		
		
		setConfigBound(fid,ctyCd, function(){
			// move map 
			mapReload(fid);
			
		});
		
		loadingHide("trendMap"+idNum);  
	}
	
	function getLegend(){
		var vals =[1,2,3,4,5];
		$("#ecnmyTrnd_inflow_legend"+comNum).empty();
		$("#ecnmyTrnd_inflow_legend"+comNum).append('<small> 유입지역별 유입인구 비율 </small>');
		makeLengend("ecnmyTrnd_inflow_legend"+comNum,colorArr,vals);
	}
	
}

/**
 * 트렌드4. 유입인구 소비시간 text / 유입인구 유입지역 text
 *  @param ctyCd 지역 코드
 *  @param comNum 지역간 비교일 경우 좌측은 1 우측은 2 , 지역간 비교가 아닌경우 ""
 *  @param callback 지역간 비교를 위해 화면에서 처음 그려지는 data 저장
 *  @param resultData 지역간 비교의 좌측내용 호출시 callback 함수로 저장해 놓았던 data를 이용
 **/
function visitrInflowText(ctyCd, comNum, callback, resultData){
	
	if(resultData){
		setText(resultData);
	}else{
		$.ajax({
			url : '/onmap/ecnmy_trnd/ecnmy_trnd_inflow_text.json',
			data:{
				"ctyCd" : ctyCd,
				"megaCd" : ctyCd.substr(0,2),
				"startDate" : ecnmy_trnd_config.selectedStartDate,
				"endDate" : ecnmy_trnd_config.selectedEndDate,
				"rgnClss" : ecnmy_trnd_config.selectedRgnClss
			},
			success: function(result, status) {
				setText(result);
				
				if(callback){
					callback(result);
				}
			}
		});
	}
	
	function setText(result){
		
		// ET4. 유입인구 소비시간 timeCntList
		if(result.timeCntList.length > 0){
			$('#cnsmpTimeTotal_ET'+comNum).empty();
			$('#cnsmpTimeTotal_ET'+comNum).append("<strong>"+result.timeCntList[0].cd_nm+"</strong>");

			var timeHtml = "";
			for(var i = 0 ; i < result.timeCntList.length; i++){
				if(comNum){
					timeHtml +="<li><dl>";
					timeHtml +="<dt><em>"+(i+1)+"</em><span>"+result.timeCntList[i].cd_nm+"</span></dt>";
					timeHtml +="<dd>"+result.timeCntList[i].rate.toFixed(1)+"%</dd>";
					timeHtml +="</dl></li>";
				}else{
					timeHtml += "<tr>";
					timeHtml += "<th><em class='rank'>" + (i+1)+"</em>"+result.timeCntList[i].cd_nm + " :</th>";
					timeHtml += "<td><strong>" + result.timeCntList[i].rate.toFixed(1) + "</strong>%</td>";
//					timeHtml += "<td><strong>" + result.timeCntList[i].rate + "</strong>%(<strong>" + krWonRound(result.timeCntList[i].total_cnt,4,1) + "</strong>명)</td>";
					timeHtml += "</tr>";
				}
			}
			$("#time_list"+comNum).empty();
			$("#time_list"+comNum).append(timeHtml);
		}
		
		// ET4. 유입인구 유입지역 순위 inflowList
		if(result.inflowList.length > 0){
			
			$('#inflowTotal_ET'+comNum).empty();
			$('#inflowTotal_ET'+comNum).append("<strong>"+result.inflowList[0].nm+"</strong>");

			var inflowHtml = "";
			for(var i = 0 ; i < result.inflowList.length; i++){
				if(comNum){
					inflowHtml +="<li><dl>";
					inflowHtml +="<dt><em>"+(i+1)+"</em><span>"+result.inflowList[i].nm+"</span></dt>";
					inflowHtml +="<dd>"+result.inflowList[i].rate.toFixed(1)+"%</dd>";
					inflowHtml +="</dl></li>";
				}else{
					inflowHtml += "<tr>";
					inflowHtml += "<th><em class='rank'>" + (i+1)+"</em>"+result.inflowList[i].nm + " :</th>";
					inflowHtml += "<td><strong>"+result.inflowList[i].rate.toFixed(1)+"</strong>%</td>";
					inflowHtml += "</tr>";
				}
			}
			$("#inflow_list"+comNum).empty();
			$("#inflow_list"+comNum).append(inflowHtml);
		}
	}
	
}

/**
 * 트렌드4. 유입인구 소비시간 순위 graph (barChart_plus)
 *  @param ctyCd 지역 코드
 *  @param comNum 지역간 비교일 경우 좌측은 1 우측은 2 , 지역간 비교가 아닌경우 ""
 *  @param callback 지역간 비교를 위해 화면에서 처음 그려지는 data 저장
 *  @param resultData 지역간 비교의 좌측내용 호출시 callback 함수로 저장해 놓았던 data를 이용
 *  @param backColor d3plus 차트 이용시 차트위치의 background color에 따라 다른 color 지정
 **/
function visitrInflowGraph(ctyCd, comNum, callback, resultData, backColor){
	loadingShow("inflowBar"+comNum);  
	if(backColor === undefined)backColor = "#f8f8f8";
	
	if(resultData){
		getGraph(resultData,backColor);
	}else{
		$.ajax({
			url : '/onmap/ecnmy_trnd/ecnmy_trnd_inflow_chart.json',
			data:{
				"ctyCd" : ctyCd,
				"startDate" : ecnmy_trnd_config.selectedStartDate,
				"endDate" : ecnmy_trnd_config.selectedEndDate
			},
			success: function(result, status) {
				getGraph(result, backColor);
				
				if(callback){
					callback(result);
				}
			}
		});
	}
	
	function getGraph(result, bColor){
		var timeChartData = result.timeChartList;
		
		if(timeChartData){
			var timeArr = ["00-06","06-09","09-12","12-15","15-18","18-21","21-24"];
			var data =[];
			var groupData =[];
			for(var i = 0; i < 2 ; i++){
				var type = "e";
				if(i > 0) type = "h";
				var groupArr =[];
				for(var j = 1; j < 8; j++){
					var chartData = {};
					
					if(type == 'e') chartData.name = "유입 인구";
					else chartData.name = "상주 인구";
					
					chartData.value = timeChartData[0][type+'_'+j+'_rate'];
					chartData.x = j;
					chartData.time = timeArr[j-1];
					data.push(chartData);
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
			$("#inflowBar"+comNum).empty();
			barChart_plus(data.reverse(), "#inflowBar"+comNum, attributes,timeArr, label, bColor);
			loadingHide("inflowBar"+comNum);  
		}
	}
	
}
