<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div class="inner" id="trnd-compare">
	<input id="windowSize" type="hidden" value>
	<!-- 비교 지역 1 -->
	<div class="section_compare">
		<div class="compare_tit">
			<p id="ctyNm1" class="tit originTit"></p>
		</div>
		
		<!-- left1. 지역별 거래금액 -->
		<div id="left-compare1" class="article_compare">
			<div class="article_top"  id="amt_ET1">
				<p class="tit">지역별 거래금액</p>
				<dl class="total">
					<dt><span id="ctyNm2" class="originTit">총 거래금액</span></dt>
					<dd id="amtTotal_ET1" class="dataType1"></dd>
				</dl>
				<ol id="amt_list1"></ol>
			</div>
			
			<div id="map1-left" class="group_chart map">
				<div class="legend"></div>
			</div>
		</div>
		
		<!-- left2. 지역별 유동인구 수 -->
		<div id="left-compare2" class="article_compare">
			<div class="article_top">
				<p class="tit">지역별 유동인구 수</p>
				<dl class="total">
					<dt>최대 매출 업종 </dt>
					<dd id="upTotal_ET1"></dd>
				</dl>
				<ol id="upAmt_list1"></ol>
			</div>
			<div class="group_chart chart1"></div>
		</div>
		
		<!-- left3. 지역별 유입인구 수 -->
		<div id="left-compare3" class="article_compare">
			<div class="article_top">
				<p class="tit">지역별 유입인구 수</p>
				<dl class="total">
					<dt><span id="ctyNm3" class="originTit">유입인구 총 수</span> </dt>
					<dd id="vstTotal_ET1"></dd>
				</dl>
				<ol id="vst_list1"></ol>
			</div>
			<div id="map2-left" class="group_chart map">
				<div class="legend"></div>
			</div>
		</div>
		
		<!-- left4. 성/연령별 대표 유입인구 -->
		<div id="left-compare4" class="article_compare">
			<div class="article_top">
				<p class="tit">성/연령별 대표 유입인구</p>
				<dl class="total">
					<dt>유입인구 </dt>
					<dd id="vst_char_ET1"></dd>
					<dt>상주인구 </dt>
					<dd id="ctzn_char_ET1"></dd>
				</dl>
			</div>
			<div class="group_chart" id="cntBar1"></div>
		</div>
		
		<!-- left5. 지역별 유입인구 소비 -->
		<div id="left-compare5" class="article_compare" id="anchorNav03">
			<div class="article_top">
				<p class="tit">지역별 유입인구 소비</p>
				<dl class="total">
					<dt>유입인구 소비총액 </dt>
					<dd id="cnsmpTotal_ET1"></dd>
				</dl>
				<ol id="cnsmp_list1"></ol>
			</div>
			<div id="map3-left" class="group_chart map">
				<div class="legend"></div>
			</div>
		</div>
		
		<!-- left6. 업종별 유입인구 소비특성 -->
		<div id="left-compare6" class="article_compare">
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
				<div class="chart_lft chart1"></div>
				<div class="chart_lft chart2"></div>
			</div>
		</div>
		
		<!-- left7. 유입인구 소비시간 -->
		<div id="left-compare7" class="article_compare">
			<div class="article_top">
				<p class="tit">유입인구 소비시간</p>
				<dl class="total">
					<dt>주요 소비시간 </dt>
					<dd id="cnsmpTimeTotal_ET1"></dd>
				</dl>
				<ol id="time_list1"></ol>
			</div>
			<div class="group_chart" id="inflowBar1"></div>
		</div>
		
		<!-- left8. 유입인구 유입지역 -->
		<div id="left-compare8" class="article_compare">
			<div class="article_top">
				<p class="tit">유입인구 유입지역</p>
				<dl class="total">
					<dt>주요 유입지역 </dt>
					<dd id="inflowTotal_ET1"></dd>
				</dl>
				<ol id="inflow_list1"></ol>
			</div>
			<div id="map4-left" class="group_chart map">
				<div class="legend"></div>
			</div>
		</div>
	</div>
	<!-- //비교 지역 1 -->
	
	<!-- 비교 지역 2 -->
	<div class="section_compare">
		<div class="compare_tit">
			<p id="megaNm1" class="tit">시군구</p>
		</div>
		
		<!-- right1. 광역시도 평균 거래금액 -->
		<div id="right-compare1" class="article_compare">
			<div class="article_top">
				<p id="megaNm2" class="tit">평균 거래금액</p>
				<dl class="total">
					<dt>시군구 평균 거래금액</dt>
					<dd id="amtTotal_ET2"></dd>
				</dl>
				<ol id="amt_list2">test</ol>
			</div>
			<div class="map_container">
				<div id="map1-right" class="group_chart map">
					<div class="legend"></div>
				</div>
				<div class="_bar_chart type1"></div>
				<div class="_right_text">
					<p id="megaNm3" class="_title">평균 대비</p>
					<p id="avgDiff1" class="_contents">약 108%</p>
				</div>
			</div>
		</div>
		
		<!-- right2. 광역시도 업종별 거래금액 -->
		<div id="right-compare2" class="article_compare">
			<div class="article_top">
				<p id="megaNm4" class="tit">업종별 거래금액</p>
				<dl class="total">
					<dt>최대 매출 업종 </dt>
					<dd id="upTotal_ET2"></dd>
				</dl>
				<ol id="upAmt_list2"></ol>
			</div>
			<div class="group_chart" id="amtTreemap2"></div>
		</div>
		
		<!-- right3. 광역시도 평균 유입인구 수 -->
		<div id="right-compare3" class="article_compare">
			<div class="article_top">
				<p id="megaNm5" class="tit">평균 유입인구 수</p>
				<dl class="total">
					<dt>시군구 평균 유입인구 총 수</dt>
					<dd id="vstTotal_ET2"></dd>
				</dl>
				<ol id="vst_list2">test</ol>
			</div>
			<div class="map_container">
				<div id="map2-right" class="group_chart map">
					<div class="legend"></div>
				</div>
				<div class="_bar_chart type2"></div>
				<div class="_right_text">
					<p id="megaNm6" class="_title">평균 대비</p>
					<p id="avgDiff2" class="_contents">약 108%</p>
				</div>
			</div>
		</div>

		<!-- right4. 광역시도 성/연령별 대표 유입인구 -->		
		<div id="right-compare4" class="article_compare">
			<div class="article_top">
				<p id="megaNm7" class="tit">성/연령별 대표 유입인구</p>
				<dl class="total">
					<dt>유입인구 </dt>
					<dd id="vst_char_ET2"></dd>
					<dt>상주인구 </dt>
					<dd id="ctzn_char_ET2"></dd>
				</dl>
			</div>
			<div class="group_chart" id="cntBar2"></div>
		</div>
		
		<!-- right5. 광역시도 평균 유입인구 소비 -->
		<div id="right-compare5" class="article_compare">
			<div class="article_top">
				<p id="megaNm8" class="tit">평균 유입인구 소비</p>
				<dl class="total">
					<dt>시군구 평균 유입인구 소비금액</dt>
					<dd id="cnsmpTotal_ET2"></dd>
				</dl>
				<ol id="cnsmp_list2">test</ol>
			</div>
			<div class="map_container">
				<div id="map3-right" class="group_chart map">
					<div class="legend"></div>
				</div>
				<div class="_bar_chart type3"></div>
				<div class="_right_text">
					<p id="megaNm9" class="_title">평균 대비</p>
					<p id="avgDiff3" class="_contents">약 108%</p>
				</div>
			</div>
		</div>
		
		<!-- right6. 광역시도 업종별 유입인구 소비특성 -->
		<div id="right-compare6" class="article_compare">
			<div class="article_top">
				<p id="megaNm10" class="tit">업종별 유입인구 소비특성</p>
				<dl class="total mega_up_cnsmp">
					<dt>활성업종 </dt>
					<ol id="up_cnsmpTotal_ET2" class="mega_up_cnsmp"></ol>
				</dl>
			</div>
			<div class="group_chart">
				<!-- 그래프 두개 -->
				<div class="chart_lft" id="expndtrBar12"></div>
			</div>
		</div>
		
		<!-- right7. 광역시도 유입인구 소비시간 -->
		<div id="right-compare7" class="article_compare">
			<div class="article_top">
				<p id="megaNm11" class="tit">유입인구 소비시간</p>
				<dl class="total">
					<dt>주요 소비시간 </dt>
					<dd id="cnsmpTimeTotal_ET2"></dd>
				</dl>
				<ol id="time_list2"></ol>
			</div>
			<div class="group_chart" id="inflowBar2"></div>
		</div>
		
		<!-- right8. 광역시도 유입인구 유입지역 -->
		<div id="right-compare8" class="article_compare">
			<div class="article_top">
				<p id="megaNm12" class="tit">유입인구 유입지역</p>
				<dl class="total">
					<dt>주요 유입지역 </dt>
					<dd id="inflowTotal_ET2"></dd>
				</dl>
				<ol id="inflow_list2"></ol>
			</div>
			<div id="map4-right" class="group_chart map">
				<div class="legend"></div>
			</div>
		</div>
	</div>
	<!-- //비교 지역 2 -->
</div>
<script src="/js/trendon/compare.js?ver=${globalConfig['config.version']}"></script>
<script>
$(document).ready(function() {
	console.log(trendon.compare)
	
	trendon.callAPI(
		trendon.compare.getConfig(),
		trendon.compare.setParameter
	);
});
</script>