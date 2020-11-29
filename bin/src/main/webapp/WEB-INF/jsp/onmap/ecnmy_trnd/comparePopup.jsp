<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div class="inner">
	<!-- 비교 지역 1 -->
	<div class="section_compare">
		<div class="compare_tit">
			<p class="tit originTit"></p>
		</div>
		
		<div class="article_compare" id="anchorNav01">
			<div class="article_top"  id="amt_ET1">
				<p class="tit">지역별 거래금액</p>
				<dl class="total">
					<dt><span class="originTit"></span> 총 거래금액 </dt>
					<dd id="amtTotal_ET1"></dd>
				</dl>
				<ol id="amt_list1">
				
				</ol>
			</div>
			<div class="group_chart" id="trendMap2_1">
				<div id="ecnmyTrnd_salamt_legend1" class="map legend"></div>
										
			</div>
		</div>
		
		<div class="article_compare">
			<div class="article_top">
				<p class="tit">업종별 거래금액</p>
				<dl class="total">
					<dt>최대 매출 업종 </dt>
					<dd id="upTotal_ET1"></dd>
				</dl>
				<ol id="upAmt_list1">
	
				</ol>
			</div>
			<div class="group_chart" id="amtTreemap1">
	
			</div>
		</div>
		
		<div class="article_compare" id="anchorNav02">
			<div class="article_top">
				<p class="tit">지역별 유입인구 수</p>
				<dl class="total">
					<dt><span class="originTit"></span> 유입인구 총 수 </dt>
					<dd id="vstTotal_ET1"></dd>
				</dl>
				<ol id="vst_list1">
					
				</ol>
			</div>
			<div class="group_chart" id="trendMap2_2">
				<div id="ecnmyTrnd_cnt_legend1" class="map legend"></div>
	
			</div>
		</div>
		
		<div class="article_compare">
			<div class="article_top">
				<p class="tit">성/연령별 대표 유입인구</p>
				<dl class="total">
					<dt>유입인구 </dt>
					<dd id="vst_char_ET1"></dd>
					<dt>상주인구 </dt>
					<dd id="ctzn_char_ET1"></dd>
				</dl>
			</div>
			<div class="group_chart" id="cntBar1">
				
			</div>
		</div>
		
		<div class="article_compare" id="anchorNav03">
			<div class="article_top">
				<p class="tit">지역별 유입인구 소비</p>
				<dl class="total">
					<dt>유입인구 소비총액 </dt>
					<dd id="cnsmpTotal_ET1"></dd>
				</dl>
				<ol id="cnsmp_list1">
					
				</ol>
			</div>
			<div class="group_chart" id="trendMap2_3">
					<div id="ecnmyTrnd_expndtr_legend1" class="map legend"></div>
	
			</div>
		</div>
		
		<div class="article_compare">
			<div class="article_top">
				<p class="tit">업종별 유입인구 소비특성</p>
				<dl class="total">
					<dt>활성업종 </dt>
					<dd id="up_cnsmpTotal_ET1"></dd>
					<dt>특화업종 </dt>
					<dd id="up_spacialTotal_ET1"></dd>
				</dl>
			</div>
			<div class="group_chart">
				<!-- 그래프 두개 -->
				<div class="chart_lft" id="expndtrBar11">
	
				</div>
				<div class="chart_lft" id="expndtrBar21">
	
				</div>
			</div>
		</div>
		
		<div class="article_compare">
			<div class="article_top">
				<p class="tit">유입인구 소비시간</p>
				<dl class="total">
					<dt>주요 소비시간 </dt>
					<dd id="cnsmpTimeTotal_ET1"></dd>
				</dl>
				<ol id="time_list1">
					
				</ol>
			</div>
			<div class="group_chart" id="inflowBar1">
	
			</div>
		</div>
		
		<div class="article_compare">
			<div class="article_top">
				<p class="tit">유입인구 유입지역</p>
				<dl class="total">
					<dt>주요 유입지역 </dt>
					<dd id="inflowTotal_ET1"></dd>
				</dl>
				<ol id="inflow_list1">
					
				</ol>
			</div>
			<div class="group_chart" id="trendMap2_4">
				<div id="ecnmyTrnd_inflow_legend1" class="map legend"></div>
			</div>
		</div>
	</div>
	<!-- //비교 지역 1 -->
	
	<!-- 비교 지역 2 -->
	<div class="section_compare">
		<div class="compare_tit">
			<p class="tit"><c:out value="${regionNm }" /></p>
		</div>
		<div class="article_compare">
			<div class="article_top">
				<p class="tit">지역별 거래금액</p>
				<dl class="total">
					<dt><c:out value="${regionNm }" /> 총 거래금액 </dt>
					<dd id="amtTotal_ET2"></dd>
				</dl>
				<ol  id="amt_list2">
				
				</ol>
			</div>
			<div class="group_chart" id="trendMap3_1">
				<div id="ecnmyTrnd_salamt_legend2" class="map legend"></div>
										
			</div>
		</div>
		
		<div class="article_compare">
			<div class="article_top">
				<p class="tit">업종별 거래금액</p>
				<dl class="total">
					<dt>최대 매출 업종 </dt>
					<dd id="upTotal_ET2"></dd>
				</dl>
				<ol id="upAmt_list2">
					
				</ol>
			</div>
			<div class="group_chart" id="amtTreemap2">
	
			</div>
		</div>
		
		<div class="article_compare">
			<div class="article_top">
				<p class="tit">지역별 유입인구 수</p>
				<dl class="total">
					<dt><c:out value="${regionNm }" /> 유입인구 총 수 </dt>
					<dd id="vstTotal_ET2"></dd>
				</dl>
				<ol id="vst_list2">
				
				</ol>
			</div>
			<div class="group_chart" id="trendMap3_2">
				<div id="ecnmyTrnd_cnt_legend2" class="map legend"></div>
	
			</div>
		</div>
		
		<div class="article_compare">
			<div class="article_top">
				<p class="tit">성/연령별 대표 유입인구</p>
				<dl class="total">
					<dt>유입인구 </dt>
					<dd id="vst_char_ET2"></dd>
					<dt>상주인구 </dt>
					<dd id="ctzn_char_ET2"></dd>
				</dl>
			</div>
			<div class="group_chart" id="cntBar2">
				
			</div>
		</div>
		
		<div class="article_compare">
			<div class="article_top">
				<p class="tit">지역별 유입인구 소비</p>
				<dl class="total">
					<dt>유입인구 소비총액 </dt>
					<dd id="cnsmpTotal_ET2"></dd>
				</dl>
				<ol id="cnsmp_list2">
					
				</ol>
			</div>
			<div class="group_chart" id="trendMap3_3">
					<div id="ecnmyTrnd_expndtr_legend2" class="map legend"></div>
	
			</div>
		</div>
		
		<div class="article_compare">
			<div class="article_top">
				<p class="tit">업종별 유입인구 소비특성</p>
				<dl class="total">
					<dt>활성업종 </dt>
					<dd id="up_cnsmpTotal_ET2"></dd>
					<dt>특화업종 </dt>
					<dd id="up_spacialTotal_ET2"></dd>
				</dl>
			</div>
			<div class="group_chart">
				<!-- 그래프 두개 -->
				<div class="chart_lft" id="expndtrBar12">
				
				</div>
				<div class="chart_lft" id="expndtrBar22">
				
				</div>
			</div>
		</div>
		
		<div class="article_compare">
			<div class="article_top">
				<p class="tit">유입인구 소비시간</p>
				<dl class="total">
					<dt>주요 소비시간 </dt>
					<dd id="cnsmpTimeTotal_ET2"></dd>
				</dl>
				<ol id="time_list2">
					
				</ol>
			</div>
			<div class="group_chart" id="inflowBar2">
	
			</div>
		</div>
		
		<div class="article_compare">
			<div class="article_top">
				<p class="tit">유입인구 유입지역</p>
				<dl class="total">
					<dt>주요 유입지역 </dt>
					<dd id="inflowTotal_ET2"></dd>
				</dl>
				<ol id="inflow_list2">
				
				</ol>
			</div>
			<div class="group_chart" id="trendMap3_4">
				<div id="ecnmyTrnd_inflow_legend2" class="map legend"></div>
			</div>
		</div>
	</div>
	<!-- //비교 지역 2 -->
</div>

<script type="text/javascript">
$(document).ready(function(){
	
	$(".originTit").text(ecnmy_trnd_config.sessionCtyNm);
	var regionCd = '<c:out value="${regionCd}" />';
	
	// 경제트렌드  지도
	mapUrl = "/onmap/ecnmy_trnd/getTrndMap.json";
	
	for(var i = 2 ; i < 4 ; i++){
		for(var j = 1 ; j < 5 ; j++){	
			var fid = "trend"+i+"_"+j;
			mapArr[fid].map = loadMap("trendMap"+i+"_"+j);
			if(i == 3){ // 오른쪽 지역 경계 가져오기
				if(j == 4){ 
					mapUrl = "/onmap/ecnmy_trnd/getTrndCtyMap.json";
					makeMap(mapUrl, ecnmy_trnd_config, fid, "H2", regionCd);
				}else{
					makeMap(mapUrl, ecnmy_trnd_config, fid, "H4", regionCd);	
				}
			}else{	 // 왼쪽 지역 경계 가져오기
				if(j == 4 && mapArr["trend1_"+j].data == null){ 
// 					console.log(fid);
				}else{					
					mapArr[fid].layer = L.geoJSON(mapArr["trend1_"+j].data).bindPopup(L.popup({closeButton:false,autoPan:false}));
					mapArr[fid].layer._fid = fid;
					ecnmy_trnd_config.layerFid[fid] = fid;
					mapArr[fid].layer.addTo(mapArr[fid].map);
					
					layerPopupSetting2(mapArr[fid].layer, mapArr[fid].map, fid, mapArr[fid].init, mapArr[fid].popup.column,mapArr[fid].popup.tit,mapArr[fid].popup.unit);

					var bounds = mapArr[fid].layer.getBounds();
					mapArr[fid].map.fitBounds(bounds);
				}
				
			}
		}
	}

	// 지역간 비교 1 (왼쪽)
	// 경제 트렌드 화면에서 로드한 값과 같으므로 화면에서 데이터를 로드할때 dataStore에 저장한 데이터를 가져옴.
	// dataStore에 데이터가 없을 경우 (Object로 담았기때문에 key의 갯수로 데이터 존재유무를 확인) null 체크후 데이터 가져오기.
	var firstDataArr = null;
	if(Object.keys(sectionFunc.firstPage.dataStore) > 0){
		firstDataArr = {"map" : sectionFunc.firstPage.dataStore.map,"legend" : sectionFunc.firstPage.dataStore.legend};
	}
	amtDataMap("trend2_1", ecnmy_trnd_config.sessionCtyCd, "1", null, firstDataArr);
	amtDataText(ecnmy_trnd_config.sessionCtyCd,"1",null,(firstDataArr == null ? null : sectionFunc.firstPage.dataStore.amtDataText));
	amtDataGraph(ecnmy_trnd_config.sessionCtyCd,"1",null,(firstDataArr == null ? null : sectionFunc.firstPage.dataStore.amtDataGraph), "#fff");

	var secondDataArr = null;
	if(Object.keys(sectionFunc.secondPage.dataStore) > 0){
		secondDataArr = {"map" : sectionFunc.secondPage.dataStore.map,"legend" : sectionFunc.secondPage.dataStore.legend};
	}
	visitrCoMap("trend2_2",ecnmy_trnd_config.sessionCtyCd,"1",null,secondDataArr);
	visitrCoText(ecnmy_trnd_config.sessionCtyCd,"1",null,(secondDataArr == null ? null : sectionFunc.secondPage.dataStore.visitrCoText));
	visitrCoGraph(ecnmy_trnd_config.sessionCtyCd,"1",null,(secondDataArr == null ? null : sectionFunc.secondPage.dataStore.visitrCoGraph), "#fff");
	
	var visitrExpndtrDataArr = null;
	var visitrInflowDataArr = null;
	if(Object.keys(sectionFunc.thirdPage.dataStore) > 0){
		visitrExpndtrDataArr = {"map" : sectionFunc.thirdPage.dataStore.visitrExpndtrMap,"legend" : sectionFunc.thirdPage.dataStore.visitrExpndtrLegend};
		visitrInflowDataArr = {"map" : sectionFunc.thirdPage.dataStore.visitrInflowMap,"legend" : sectionFunc.thirdPage.dataStore.visitrInflowLegend};
	}
	visitrExpndtrMap("trend2_3",ecnmy_trnd_config.sessionCtyCd,"1",null,visitrExpndtrDataArr);
	visitrExpndtrText(ecnmy_trnd_config.sessionCtyCd,"1",null,(visitrExpndtrDataArr == null ? null : sectionFunc.thirdPage.dataStore.visitrExpndtrText));
	visitrExpndtrGraph(ecnmy_trnd_config.sessionCtyCd,"1",null,(visitrExpndtrDataArr == null ? null : sectionFunc.thirdPage.dataStore.visitrExpndtrGraph), "#fff");
	
	visitrInflowMap("trend2_4",ecnmy_trnd_config.sessionCtyCd,"1",null,visitrInflowDataArr);
	visitrInflowText(ecnmy_trnd_config.sessionCtyCd,"1",null,(visitrInflowDataArr == null ? null : sectionFunc.thirdPage.dataStore.visitrInflowText));
	visitrInflowGraph(ecnmy_trnd_config.sessionCtyCd,"1",null,(visitrInflowDataArr == null ? null : sectionFunc.thirdPage.dataStore.visitrInflowGraph), "#fff");
	
	//지역간 비교 2
	amtDataText(regionCd,"2");
	amtDataGraph(regionCd,"2",null,null, "#fff");
	amtDataMap("trend3_1",regionCd,"2");
	
	visitrCoMap("trend3_2",regionCd,"2");
	visitrCoText(regionCd,"2");
	visitrCoGraph(regionCd,"2",null,null, "#fff");
	
	visitrExpndtrMap("trend3_3",regionCd,"2");
	visitrExpndtrText(regionCd,"2");
	visitrExpndtrGraph(regionCd,"2",null,null, "#fff");
	
	visitrInflowMap("trend3_4",regionCd,"2");
	visitrInflowText(regionCd,"2");
	visitrInflowGraph(regionCd,"2",null,null, "#fff");

	

	

	
	// 지역간비교 - 메뉴 이동
	var changeAllow = true;
	$('.menu_compare').on("click","li", function(){
		changeAllow =false;
		var pageId = $(this).attr("page-id");
		var moveHeight = $("#"+pageId).offset().top;
		
	    $('.compare_result').animate({
            scrollTop: '+=' + (moveHeight - 120) + 'px'
        }, 'slow');
	    
	    $(this).parent().find("li").each(function(index, item){
			$(item).removeClass("active");	
		});
		$(this).addClass("active");
		
	});
	
	// 스크롤시 메뉴이동
	$('.compare_result').scroll(function(){ 
		var actId = "";
		var minHeight = 0;
		if(changeAllow){
			$('.menu_compare').find("li").each(function(index, item){
				var id = $(item).attr("page-id");
				var thisHeight = Math.abs($("#"+id).offset().top);
				
				if(index > 0){
					if(minHeight > thisHeight){
						actId = id;
						minHeight = thisHeight;
					}
				}else{
					actId = id;
					minHeight = thisHeight;
				}
				
				$(item).removeClass("active");	
			});
			
			$('.menu_compare li[page-id='+actId+']').addClass("active");
		}
		clearTimeout( $.data( this, "scrollCheck" ) );
		$.data( this, "scrollCheck", setTimeout(function() {
			changeAllow =true;
		}, 250) );
	});
});

</script>
