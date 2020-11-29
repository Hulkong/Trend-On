<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page session="false" %>
<!doctype html>
<html lang="ko">
	<head>
		<link rel="stylesheet" href="/css/daterangepicker.css?ver=${globalConfig['config.version']}" />
		<%@ include file="/WEB-INF/jsp/onmap/main/include/layer_library.jsp" %>
		<script type="text/javascript" src="/js/daterangepicker/moment.js"></script>
		<script type="text/javascript" src="/js/daterangepicker/daterangepicker.js"></script>
	</head>
	<body>
		<div id="fog">
			<div class="reportDataLoading">
				<div class="loadingBox">
					<p class="tit">리포트 데이터를 생성중입니다.</p>
					<p><img src="/images/common/loading.gif" alt="로딩"/></p>
					<p class="desc">기간선택에 따라 다소 시간이 걸릴 수 있습니다.</p>
				</div>
			</div>
		</div>
		<div id="wrap" class="event-effect">
			<!-- header -->
			<%@ include file="/WEB-INF/jsp/onmap/main/include/layer_header.jsp" %>
			<!-- //header -->

			<hr />

			<!-- contents -->
			<div id="contents">
				<div id="fp-nav2" class="section_top">
					<ul class="menu_anchor">
						<li class="_btn _allview active"><a href="###" onclick="trendon.clickTimeserires('all')">전체 보기</a></li>
						<li class="_btn _card"><a href="###" onclick="trendon.clickTimeserires('type1')"><div class="line"></div>카드 소비</a></li>
						<li class="_btn _pop"><a href="###" onclick="trendon.clickTimeserires('type2')"><div class="line"></div>유동 인구</a></li>
					</ul>
					<div class="select_box select_ty2">
						<div onmouseenter="trendon.mouseenterComboBox('.section_top')" onmouseleave="trendon.mouseleaveComboBox('.section_top')">
							<span class="tit sAmdiTit thisAmdi name">${ selectAmdiKr }</span>
							<ul class="combo-box"></ul>
						</div>
					</div>
					<div class="article_rgt">
						<div class="group_period">
							<span class="search_period">2017. 06. 15 ~ 2017. 07. 26</span>
							<div id="layerPeriod" class="layer_period">
								<div class="pop_header">
									<p class="tit">기간 직접 입력</p>
									<p class="pop_period_txt">
										(데이터 기준일자 : <strong 	id="standard_period">2016년 10월 ~ 2017년 9월</strong>)<br/>
										(조회가능 범위 : 최대 3개월, 최소 3일)
									</p>
									<a href="##" class="btn_close" onclick="trendon.closeDate()">닫기</a>
								</div>
								<div class="pop_contents">
									<div class="article_calendar">
										<div class="group_lft">
											<p class="tit">비교기간 </p>
											<p class="txt" id="popSelectedLast">${lastStartDate } ~ ${lastEndDate }</p>
											<div id="sDatepicker"></div>

										</div>
										<div class="group_rgt">
											<p class="tit">선택기간</p>
											<p class="txt" id="popSelectedThis">2017.7.5 ~ 2017.7.15</p>
											<div id="eDatepicker"></div>
										</div>
									</div>
								</div>
								<div class="pop_footer">
									<button type="button" class="btn_confirm" onclick="trendon.effect.clickPeriod()">선택</button>
								</div>
							</div>
						</div>
						<div class="btn_list">
							<ul>
								<li class="_btn _date"><a href="#layerPeriod" onclick="trendon.openDate()">기간 직접 입력</a></li>
								<li class="_btn _pdf"><a href="#none" onclick="trendon.effect.clickToPDF()">PDF 다운</a></li>
							</ul>
						</div>
					</div>
					<!-- 상단 고정 그래프 -->
					<div class="top_graph">
						<!-- 도움말 -->
						<div class="group_help" onclick="trendon.closeHelp()">
							<p class="fs13">
								조회를 원하시는 시간대에 따라 스크롤을 움직여 보세요.<br/>
								<span class="fs11">
								(데이터 기준일자 : <span id="dateWarn"></span>)<br/>
								<c:if test="${userInfo.service_clss eq '3'}">
								(조회가능 범위 : 최대 1개월, 최소 3일)
								</c:if>
								<c:if test="${userInfo.service_clss ne '3'}">
								(조회가능 범위 : 최대 3개월, 최소 3일)
								</c:if>
								</span>
							</p>
						</div>
						<!-- //도움말 -->
					
						<!-- 0. 지역별 거래금액 -->
						<div id="layout0">
							<div id="rangeChart" class="bx_graph dateRange"></div>
						</div>
					</div>
					<!-- //상단 고정 그래프 -->
				</div>

				<!-- 본문 ==================================================================================================== -->
				<div id="fullpage">
					<div class="message_layer" id="dataLack">
						<div class="messageBox">
							<p>
								선택하신 기간과 지역은 표본의 크기가 작아서 서비스되지 않습니다.<br/>
								다른기간 혹은 다른 지역으로 이용해주세요.
							</p>
						</div>
					</div>
					
					<!-- section1 전체 보기 ============================== -->
					<div class="section" id="section1">
						<div class="inner">
							<h3 class="hide">전체 보기</h3>
							
							<!-- 1. 행정동 총 경제효과 -->
							<div id="layout1" class="article_group contents-left-type4 contents-right-type3 first">
								<div class="article_lf">
									<h4 class="tit text-xxl-m"><span class="admiNm">${selectAmdiKr}</span> 총 경제효과</h4>
									<dl>
										<dt class="total text-l-r">평상시 대비 매출액 변화</dt>
										<dd class="total font-orange-light">
											<strong id="" class="num-l-b dataType1">0.0%</strong>
											<span class="text-l-r dataType2">증가</span>
										</dd>
									</dl>
									<table class="brd_dl">
										<tbody>
											<tr>
												<th class="text-l-r">평상시</th>
												<td class="text-l-b"><span class="dataType3">0.0억원</span>/ 일 평균</td>
											</tr>
											<tr>
												<th class="text-l-r">이벤트 기간</th>
												<td class="text-l-b"><span class="dataType4">2.2억원</span>/ 일 평균</td>
											</tr>
										</tbody>
									</table>
									<p class="txt_infor text-s-r">
										경제효과는 평상시(이벤트 전1~3주, 후1~2주) 일평균 매출액 대비<br/>
										이벤트 기간의 일평균 매출액을 비교<br/>
										평상시(이벤트 전 3주, 후 2주, 총 5주) 데이터가 없을 경우<br/>
										그래프에 표현된 기간동안의 일평균 매출액 데이터를 계산
									</p>
								</div>
								<div class="article_rg">
									<div class="bx_graph chart1"></div>
								</div>
							</div>
							<!-- // -->
							
							<!-- 2. 행정동 유동인구 변화 -->
							<div id="layout2" class="article_group contents-left-type4 contents-right-type3">
								<div class="article_lf">
									<h4 class="tit text-xxl-m"><span class="admiNm">${selectAmdiKr}</span> 유동인구 변화</h4>
									<dl>
										<dt class="total text-l-r">평상시 대비 유동인구 변화</dt>
										<dd class="total font-green">
											<strong id="" class="num-l-b dataType1">0.0%</strong>
											<span class="text-l-r dataType2">증가</span>
										</dd>
									</dl>
									<table class="brd_dl" id="">
										<tbody>
											<tr>
												<th class="text-l-r">평상시</th>
												<td class="text-l-b"><span class="dataType3">0.0억원</span>/ 일 평균</td>
											</tr>
											<tr>
												<th class="text-l-r">이벤트 기간</th>
												<td class="text-l-b"><span class="dataType4">2.2억원</span>/ 일 평균</td>
											</tr>
										</tbody>
									</table>
									<p class="txt_infor text-s-r">
										유동인구 변화는 평상시(이벤트 전 3주부터 후2주)의<br/>
										일평균 유동인구 수 대비 이벤트 기간의 일평균 유동인구 수를 비교<br/>
										평상시의 데이터가 없을 경우 그래프에 표현된 기간동안의<br/>
										일평균 유동인구 수 데이터로 계산
									</p>
								</div>
								<div class="article_rg">
									<div class="bx_graph chart1"></div>
								</div>
							</div>
							<!-- // -->
							
							<!-- 3. 주변지역 경제효과 -->
							<div id="layout3" class="article_group contents-left-type6 contents-right-type3">
								<div class="article_lf">
									<h4 class="tit text-xxl-m">주변지역 경제효과</h4>
									<div id="layout3-table1" class="container border-bottom">
										<div class="left">
											<h5 class="tit_dl_black text-l-r">거래금액 기준</h5>
											<h3 class="num-l-b font-orange-light">
												<span class="admiNm">${selectAmdiKr}</span> 
												<span class="dataType1">+0.0%</span>
											</h3>
										</div>
										<div class="right">
											<table class="brd_dl dataTable">
												<tbody>
													<tr>
														<th class="text-l-r"><em class="rank num-m-t font-black-light">1</em>화곡1동</th>
														<td class="text-l-b">+<strong>00.0</strong>%</td>
													</tr>
													<tr>
														<th class="text-l-r"><em class="rank num-m-t font-black-light">2</em>화곡2동</th>
														<td class="text-l-b">+<strong>00.0</strong>%</td>
													</tr>
													<tr>
														<th class="text-l-r"><em class="rank num-m-t font-black-light">3</em>화곡3동</th>
														<td class="text-l-b">+<strong>00.0</strong>%</td>
													</tr>
												</tbody>
											</table>
										</div>
									</div>
									<div id="layout3-table2" class="container">
										<div class="left">
											<h5 class="tit_dl_black text-l-r">거래량 기준</h5>
											<h3 class="num-l-b font-orange-light">
												<span class="admiNm">${selectAmdiKr}</span> 
												<span class="dataType2">+0.0%</span>
											</h3>
										</div>
										<div class="right" >
											<table class="brd_dl dataTable">
												<tbody>
													<tr>
														<th class="text-l-r"><em class="rank num-m-t font-black-light">1</em>화곡1동</th>
														<td class="text-l-b">+<strong>00.0</strong>%</td>
													</tr>
													<tr>
														<th class="text-l-r"><em class="rank num-m-t font-black-light">2</em>화곡2동</th>
														<td class="text-l-b">+<strong>00.0</strong>%</td>
													</tr>
													<tr>
														<th class="text-l-r"><em class="rank num-m-t font-black-light">3</em>화곡3동</th>
														<td class="text-l-b">+<strong>00.0</strong>%</td>
													</tr>
												</tbody>
											</table>
										</div>
									</div>
									
									<p class="txt_infor text-s-r">주변지역은 해당 시군구 내 분석지역(선택한 행정동)에 인접한 읍면동</p>
								</div>
								
								<div class="article_rg">
									<div class="bx_graph box_pos pos_ty2">
									
										<div class="select_box select_ty2">
										
											<div onmouseenter="trendon.mouseenterComboBox('#layout3')" onmouseleave="trendon.mouseleaveComboBox('#layout3')">
												<span class="tit name">거래금액</span>
												<ul class="combo-box">
													<li class="selected" code="rate" onclick="trendon.effect.clickComboBoxMap(event, '#layout3')">거래금액</li>
													<li code="cnt_rate" onclick="trendon.effect.clickComboBoxMap(event, '#layout3')">거래량</li>
												</ul>
											</div>
										</div>
										<div id="map1" class="bx_graph map"></div>
									</div>
								</div>
							</div>
							<!-- // -->
							
							<!-- 4. 주변지역 유동인구 변화 -->
							<div id="layout4" class="article_group contents-left-type4 contents-right-type3">
								<div class="article_lf">
									<h4 class="tit text-xxl-m">주변지역 유동인구 변화</h4>
									<dl>
										<dt class="total text-l-r">유동인구 기준</dt>
										<dd class="total font-green">
											<strong class="list_value num-l-b admiNm">${selectAmdiKr}<span class="dataType1">+0.0%</span></strong>
										</dd>
									</dl>
									<table class="brd_dl dataTable">
										<tbody>
											<tr>
												<th class="text-l-r"><em class="rank num-m-t font-black-light">1</em>화곡1동</th>
												<td class="text-l-b"><strong>0000.0억</strong>만명</td>
											</tr>
											<tr>
												<th class="text-l-r"><em class="rank num-m-t font-black-light">2</em>화곡2동</th>
												<td class="text-l-b"><strong>0000.0억</strong>만명</td>
											</tr>
											<tr>
												<th class="text-l-r"><em class="rank num-m-t font-black-light">3</em>화곡3동</th>
												<td class="text-l-b"><strong>0000.0억</strong>만명</td>
											</tr>
										</tbody>
									</table>
									<p class="txt_infor text-s-r">주변지역은 해당 시군구 내 분석지역(선택한 행정동)에 인접한 읍면동</p>
								</div>
								<div class="article_rg">
									<div id="map2" class="bx_graph map"></div>
								</div>
							</div>
							<!-- // -->

							<!-- 5. 성/연령별 대표인구 -->
							<div id="layout5" class="article_group contents-left-type2 contents-right-type2">
								<div class="article_lf">
									<h4 class="tit text-xxl-m">성/연령별 대표인구</h4>
									<dl class="border-bottom">
										<dt class="list_title text-l-r">유동인구</dt>
										<dd>
											<strong class="list_value num-l-b font-green dataType1">00대 남성</strong>
											<span class="list_desc text-l-m">통신사 유동인구 기준</span>
										</dd>
									</dl>
									<dl>
										<dt class="list_title text-l-r">소비인구</dt>
										<dd class="last">
											<strong class="list_value num-l-b font-orange-light dataType2">00대 여성</strong>
											<span class="list_desc text-l-m">카드소비액 기준</span>
										</dd>
									</dl>
									<p class="txt_infor text-s-r">성/연령별 특성은 가입자의 성/연령 정보를 바탕으로 함</p>
								</div>
								<div class="article_rg">
									<div class="bx_graph left chart1"></div>
									<div class="bx_graph right chart2"></div>
								</div>
							</div>
							<!-- // -->
							
							<!-- 6. 업종별 경제효과 -->
							<div id="layout6" class="article_group contents-left-type2 contents-right-type2">
								<div class="article_lf">
									<h4 class="tit text-xxl-m">업종별 경제효과</h4>
									<dl class="border-bottom">
										<dt class="total text-l-r">거래금액 기준</dt>
										<dd class="total num-l-b font-orange-light">
											<strong class="list_value num-l-b dataType1">피자 00.0%</strong>
											<span class="unit text-l-r dataType2">증가</span>
										</dd>
									</dl>
									
									<dl>
										<dt class="total text-l-r">거래량 기준</dt>
										<dd class="total font-orange-light">
											<strong class="list_value num-l-b dataType3">피자 00.0%</strong>
											<span class="unit text-l-r dataType4">증가</span>
										</dd>
									</dl>
									
									<p class="txt_infor text-s-r">
										업종별 경제효과는 평상시 대비 이벤트기간의 일평균 매출액,<br/>
										거래량을 기준으로 가장 변화율이 높은 업종을 표현
									</p>
								</div>
								<div class="article_rg">
									<div class="bx_graph left">
										<h5 class="tit">거래금액 기준</h5>
										<div class="chart1"></div>
									</div>
									<div class="bx_graph right">
										<h5 class="tit">거래량 기준</h5>
										<div class="chart2"></div>
									</div>
								</div>
							</div>
							<!-- // -->
						</div>
					</div>
					<!-- //section1 매출액 ============================== -->

					<!-- section2 유입소비인구 특성 ============================== -->
					<div class="section eResult3" id="section2">
						<div class="inner">
							<h3 class="hide">유입인구 특성</h3>
							
							<!-- 7. 유입 유동인구 수 -->
							<div id="layout7" class="article_group contents-left-type4 contents-right-type3">
								<div class="article_lf">
									<h4 class="tit text-xxl-m">유입 유동인구 수</h4>
									<dl>
										<dt class="total text-l-r"><span class="admiNm">${selectAmdiKr}</span> 유입 유동인구 수</dt>
										<dd class="total font-green">
											<strong class="list_value num-l-b dataType1">00.0</strong>
											<span class="unit text-l-r dataType2">만명</span>
										</dd>
									</dl>
									<table class="brd_dl dataTable">
										<tbody>
											<tr>
												<th class="text-l-r"><em class="rank num-m-t font-black-light">1</em>화곡1동</th>
												<td class="text-l-b"><strong>0000.0억</strong>만명</td>
											</tr>
											<tr>
												<th class="text-l-r"><em class="rank num-m-t font-black-light">2</em>화곡2동</th>
												<td class="text-l-b"><strong>0000.0억</strong>만명</td>
											</tr>
											<tr>
												<th class="text-l-r"><em class="rank num-m-t font-black-light">3</em>화곡3동</th>
												<td class="text-l-b"><strong>0000.0억</strong>만명</td>
											</tr>
										</tbody>
									</table>
									<p class="txt_infor text-s-r">
										 유입 유동인구는 기간 내 해당 지역에서 집계된 유동인구 중<br/> 
										 거주지가 해당 시군구 외에 위치한 유동인구
									</p>
								</div>
								<div class="article_rg">
									<div id="map3" class="bx_graph map"></div>
								</div>
							</div>
							<!-- // -->
							
							<!-- 8. 유입인구 성/연령별 특성 -->
							<div id="layout8" class="article_group contents-left-type2 contents-right-type2">
								<div class="article_lf">
									<h4 class="tit text-xxl-m">유입인구 성/연령별 특성</h4>
									<dl class="border-bottom">
										<dt class="list_title text-l-r">유입 유동인구</dt>
										<dd>
											<strong class="list_value num-l-b font-green dataType1">00대 남성</strong>
											<span class="list_desc text-l-m">통신사 유동인구 기준</span>
										</dd>
									</dl>
									<dl>
										<dt class="list_title text-l-r">유입 소비인구</dt>
										<dd class="last">
											<strong class="list_value num-l-b font-orange-light dataType2">00대 여성</strong>
											<span class="list_desc text-l-m">카드소비액 기준</span>
										</dd>
									</dl>
									<p class="txt_infor text-s-r">성/연령별 특성은 가입자의 성/연령 정보를 바탕으로 함</p>
								</div>
								<div class="article_rg">
									<div class="bx_graph left chart1"></div>
									<div class="bx_graph right chart2"></div>
								</div>
							</div>
							<!-- // -->
						</div>
					</div>
					<!-- //section2 ============================== -->

					<!-- section3 ============================== -->
					<div class="section eResult3" id="section3">
						<div class="inner">
							<h3 class="hide">유입인구 소비</h3>
							
							<!-- 9. 유입인구 시간대 특성 -->
							<div id="layout9" class="article_group contents-left-type5 contents-right-type3">
								<div class="article_lf">
									<h4 class="tit text-xxl-m">유입인구 시간대 특성</h4>
									<dl>
										<dt class="total text-l-r">주요 방문시간</dt>
										<dd class="total"><strong class="num-l-b font-green dataType1">00 ~ 00시</strong></dd>
									</dl>
									<p class="txt_sub_dl text-s-r border-bottom"><span class="admiNm">${selectAmdiKr}</span> 상권을 가장 많이 방문한 시간대</p>
									<dl>
										<dt class="total text-l-r">주요 소비시간</dt>
										<dd class="total"><strong class="num-l-b font-orange-light dataType2">00 ~ 00시</strong></dd>
									</dl>
									<p class="txt_sub_dl text-s-r"><span class="admiNm">${selectAmdiKr}</span> 상권을 가장 많이 이용한 시간대</p>
								</div>
								<div class="article_rg">
									<div class="bx_graph chart1"></div>
								</div>
							</div>
							<!-- // -->

							<!-- 10. 유입 유동인구 유입지역  -->
							<div id="layout10" class="article_group contents-left-type4 contents-right-type3">
								<div class="article_lf">
									<h4 class="tit text-xxl-m">유입 유동인구 유입지역</h4>
									<dl>
										<dt class="total text-l-r">주요 유입지역</dt>
										<dd class="total num-l-b font-green dataType1">서울특별시 강서구</dd>
									</dl>
									<table class="brd_dl dataTable">
										<tbody>
											<tr>
												<th class="text-l-r"><em class="rank num-m-t font-black-light">1</em>서울특별시 강서구</th>
												<td class="text-l-b"><strong>0.0</strong>%</td>
											</tr>
											<tr>
												<th class="text-l-r"><em class="rank num-m-t font-black-light">2</em>서울특별시 강남구</th>
												<td class="text-l-b"><strong>0.0</strong>%</td>
											</tr>
											<tr>
												<th class="text-l-r"><em class="rank num-m-t font-black-light">3</em>서울특별시 강북구</th>
												<td class="text-l-b"><strong>0.0</strong>%</td>
											</tr>
										</tbody>
									</table>
									<p class="txt_infor text-s-r">유입지역은 전국 236개 시군구 대상 </p>
								</div>
								<div class="article_rg">
									<div id="map4" class="bx_graph map"></div>
								</div>
							</div>
							<!-- // -->
						</div>
					</div>
					<!-- //section3 유입소비인구 지출 ============================== -->
					</div>
				</div>
				<!-- //본문 ==================================================================================================== -->
			</div>
			<!-- //contents -->

			<!-- footer -->
			<%@ include file="/WEB-INF/jsp/onmap/main/include/layer_footer.jsp" %>
			<!-- //footer -->
	</body>
	<script src="/js/library-common.js?ver=${globalConfig['config.version']}"></script>
	<script src="/js/library-date.js?ver=${globalConfig['config.version']}"></script>
	<script src="/js/library-chart.js?ver=${globalConfig['config.version']}"></script>
	<script src="/js/library-map.js?ver=${globalConfig['config.version']}"></script>
	<script src="/js/trendon/trendon.js?ver=${globalConfig['config.version']}"></script>
	<script src="/js/trendon/event-effect.js?ver=${globalConfig['config.version']}"></script>
	<script>
	$(document).ready(function() {
		
		trendon.effect['admiCd'] =  '${selectAmdi}';  // 행정동 코드
		trendon.effect['ctyCd'] =  '${userInfo.cty_cd}';  // 시군구 코드
		trendon.effect['megaCd'] = trendon.effect.ctyCd.substring(0, 2); // 광역시도 코드
		trendon.effect['serviceClss'] = '${userInfo.service_clss}';
		trendon.effect['startDate'] =  '${startDate}';  // 선택한 기간의 시작일
		trendon.effect['endDate'] =  '${endDate}';  // 선택한 기간의 종료일
		trendon.effect['lastStartDate'] =  '${lastStartDate}';  // 선택한 기간의 전년도 시작일
		trendon.effect['lastEndDate'] =  '${lastEndDate}';  // 선택한 기간의 전년도 종료일
		trendon.effect['minStdrDate'] = '${min_stdr_date}'; // 데이터 기준일자 시작일
		trendon.effect['maxStdrDate'] = '${max_stdr_date}'; // 데이터 기준일자 종료일
		trendon.effect.rgnClss =  'H4';  // 행정구역 코드
		trendon.effect.admiAround =  null;  // 선택한 행정동 주변 행정동
		
		trendon.effect.setAdmiComboBox();  // 행정동 콤보박스 설정
		trendon.effect.setAdmiFlag(); // 동/읍, 면 구분값 설정
		trendon.effect.createDateRangePicker();  // dateRangePicker 생성
		trendon.effect.setAllWithDate(); // 기관과 관련된 모든 데이터 설정
		trendon.effect.triggerDraw();
		
		// 시계열 그래프 그리기
		trendon.callAPI(
 			trendon.effect.getConfig(0),
 			trendon.effect.setParameter
 		);
		
		//현재보고있는 section가져오기
		window.anchorLinkCallBack = function(anchorLink, index){
			trendon.effect['lastAnchorLink'] = anchorLink;
			var secFunc = trendon.effect.sectionFunc[anchorLink];
			secFunc.action();
		};
	});
	</script>
</html>
