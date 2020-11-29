<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page session="false" %>
<!doctype html>
<html lang="ko">
	<head>
		<%@ include file="/WEB-INF/jsp/onmap/main/include/layer_library.jsp" %>
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
		<div id="fog2">
			<div class="_dataReady">
				<div class="_container">
					<div class="_header">
					<p onclick="$(fog2).css('display', 'none')">X</p>
					</div>
					<div class="_contents">
					<p class="tit">보다 나은 서비스 제공을 위한 지역간 비교 업데이트 안내</p>
					<p class="desc">지역간 비교 기능이 업데이트 중입니다.</p>
					<p class="desc">안정적인 환경을 구축하기 위해 잠시 서비스 이용이 제한되는 점, 양해부탁드립니다.</p>
					<p class="desc">빠른 시일 내에 업데이트를 완료하겠습니다.</p>
					<p class="desc">감사합니다.</p>
					</div>
				</div>
			</div>
		</div>
		<div id="wrap" class="ecnmy-trnd">
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
					<div class="compare_area _top_button">
<!-- 						<a href="#none" class="btn_compare layer_open" onclick="clickToCompare()"></a> -->
						<!-- 레이어 팝업 ==================================================================================================== -->
						<div class="pop_layer">
							<div class="layer_compare">
								<!-- 상단 -->
								<div class="compare_header">
									<p class="tit_compare">지역간 비교</p>
									<div class="txt_period">
										2017.10.10 ~ 2017.10.10
									</div>
									<ul class="menu_compare">
										<li class="active"  page-id="anchorNav01"><a href="#none">거래금액</a></li> 
										<li page-id="anchorNav02"><a href="#none">유입인구 특성</a></li>
										<li page-id="anchorNav03"><a href="#none">유입인구 소비</a></li>
									</ul>
									<a href="#none" class="btn_close region_close">닫기</a>
								</div>
								<!-- //상단 -->
								<!-- 본문 - 선택 ============================== -->
								<div class="compare_body">
									<div class="article_select">
										<div class="group_select">
											<p class="tit"><em>시/도</em>를 선택하세요</p>
											<div class="group_scroll" id="regionGroup1">
												<ul>
													<c:if test="${!empty regionMegaList }">
														<c:forEach var="item" items="${regionMegaList }">
																<li class="regionGroup1"><a href="#none" data-id="${item.id }" >${item.nm }</a></li>
														</c:forEach>
													</c:if>
												</ul>
											</div>
										</div>
										<div class="group_select">
											<p class="tit"><em>군/구</em>를 선택하세요</p>
											<div class="group_scroll" id="regionGroup2">
												<ul>
													<c:if test="${!empty regionCtyList }">
														<c:forEach var="item" items="${regionCtyList }">
																<li><a href="#none" data-id="${item.id }" >${item.nm }</a></li>
														</c:forEach>
													</c:if>
													<c:if test="${empty regionCtyList }">
														<li>시/도를 선택해주세요.</li>
													</c:if>
												</ul>
											</div>
										</div>
									</div>
									<div class="compare_btm">
										<ul>
											<li><button class="btn_confirm btn_show_compare" id="select_confirm">확인</button></li>
											<li><button class="btn_cancel btn_close compare_close">취소</button></li>
										</ul>
									</div>
								</div>
								<!-- //본문 - 선택 ============================== -->

								<!-- 본문 - 선택결과비교 ============================== -->
								<div class="compare_result"></div>
								<!-- //본문 - 선택결과비교 ============================== -->
							</div>
						</div>
						<!-- //레이어 팝업 ==================================================================================================== -->
					</div>
					<div class="article_rgt">
						<div class="group_period">
							<span class="search_period">2017. 06. 15 ~ 2017. 07. 26</span>
							<div id="layerPeriod" class="layer_period">
								<div class="pop_header">
									<p class="tit">기간 직접 입력</p>
									<p class="pop_period_txt">
										(데이터 기준일자 : <strong 	id="standard_period">2017년 01월 ~ 2017년 12월</strong>)<br/>
										(조회가능 범위 : 
										<c:choose> 
											<c:when test="${serviceClss ne 3 }">최대 1년</c:when>
											<c:when test="${serviceClss eq 3 }">최대 3개월</c:when>
										</c:choose>
										, 최소 3일)
									</p>
									<a href="##" class="btn_close" onclick="trendon.closeDate()">닫기</a>
								</div>
								<div class="pop_contents">
									<div class="article_calendar">
										<div class="group_lft">
											<p class="tit">시작일</p>
											<p class="txt" id="popSelectedSdate">2017.7.5</p>
											<div id="sDatepicker"></div>
										</div>
										<div class="group_rgt">
											<p class="tit">종료일</p>
											<p class="txt" id="popSelectedEdate">2017.7.5</p>
											<div id="eDatepicker"></div>
										</div>
									</div>
								</div>
								<div class="pop_footer">
									<button type="button" class="btn_confirm" onclick="trendon.trnd.clickPeriod()">선택</button>
								</div>
							</div>
						</div>
						<div class="btn_list">
							<ul>
								<li class="_btn _date"><a href="#none" onclick="trendon.openDate('trendon')">기간 직접 입력</a></li>
								<li class="_btn _compare hidden"><a class="btn_compare" href="###">VS ${megaName}</a></li>
								<li class="_btn _pdf"><a href="#none" onclick="trendon.trnd.clickToPDF()">PDF 다운</a></li>
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
								(조회가능 범위 :
								<c:choose> 
									<c:when test="${serviceClss ne 3 }">최대 1년</c:when>
									<c:when test="${serviceClss eq 3 }">최대 3개월</c:when>
								</c:choose>
								, 최소 3일)
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
					<!-- section1 전체 보기 ============================== -->
					<div class="section" id="section1">
						<div class="inner">
							<h3 class="hide">전체 보기</h3>
							
							<!-- 1. 지역별 거래금액 -->
							<div id='layout1' class="article_group contents-left-type4 contents-right-type3 first">
								<div class="article_lf">
									<h4 class="tit text-xxl-m">지역별 거래금액</h4>
									<dl>
										<dt class="total text-l-r">${ctyName} 총 거래금액</dt>
										<dd class="total font-orange-light">
											<strong class="list_value num-l-b dataType1">0000.0</strong>
											<span class="text-l-r dataType2">억원</span>
										</dd>
									</dl>
									<table class="brd_dl dataTable">
										<tbody>
											<tr>
												<th class="text-l-r"><em class="rank num-m-t font-black-light">1</em>화곡1동</th>
												<td class="text-l-b"><strong>0000.0억</strong>원</td>
											</tr>
											<tr>
												<th class="text-l-r"><em class="rank num-m-t font-black-light">2</em>화곡2동</th>
												<td class="text-l-b"><strong>0000.0억</strong>원</td>
											</tr>
											<tr>
												<th class="text-l-r"><em class="rank num-m-t font-black-light">3</em>화곡3동</th>
												<td class="text-l-b"><strong>0000.0억</strong>원</td>
											</tr>
										</tbody>
									</table>
									<p class="txt_infor text-s-r">거래금액은 신용카드 사용실적 빅데이터를 기반으로<br/> 
														 현금거래 비율을 적용하여 추정</p>
								</div>
								<div class="article_rg">
									<div id="map1" class="bx_graph map"></div>
								</div>
							</div>
							<!-- // -->
							
							<!-- 2. 지역별 유동인구 수 -->
							<div id="layout2" class="article_group contents-left-type4 contents-right-type3">
								<div class="article_lf">
									<h4 class="tit text-xxl-m">지역별 유동인구 수</h4>
									<dl>
										<dt class="total text-l-r">${ctyName} 유동인구 총 수</dt>
										<dd class="total font-green">
											<strong class="list_value num-l-b dataType1">0000.0</strong>
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
										해당 지역에 거주하거나 업무, 관광, 쇼핑 등<br/>
										일시적으로 지역을 찾아 행정수요를 유발하는 생활인구<br/>
										(이동통신사 LTE 시그널 데이터를 기반으로 집계)
									</p>
								</div>
								<div class="article_rg">
									<div id="map2" class="bx_graph map"></div>
								</div>
							</div>
							<!-- // -->

							<!-- 3. 성/연령별 대표인구 -->
							<div id="layout3" class="article_group contents-left-type2 contents-right-type2">
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

							<!-- 4. 업종별 거래금액 -->
							<div id="layout4" class="article_group contents-left-type4 contents-right-type3">
								<div class="article_lf">
									<h4 class="tit text-xxl-m">업종별 거래금액</h4>
									<dl>
										<dt class="total text-l-r">최대 매출 업종</dt>
										<dd class="total"><strong class="num-l-b font-orange-light dataType1">피자/피자</strong></dd>
									</dl>
									<table class="brd_dl dataTable">
										<tbody>
											<tr>
												<th class="text-l-r"><em class="rank num-m-t font-black-light">1</em>피자/피자</th>
												<td class="text-l-b"><strong>0000.0억</strong>원</td>
											</tr>
											<tr>
												<th class="text-l-r"><em class="rank num-m-t font-black-light">2</em>피자/피자</th>
												<td class="text-l-b"><strong>0000.0억</strong>원</td>
											</tr>
											<tr>
												<th class="text-l-r"><em class="rank num-m-t font-black-light">3</em>피자/피자</th>
												<td class="text-l-b"><strong>0000.0억</strong>원</td>
											</tr>
										</tbody>
									</table>
									<p class="txt_infor text-s-r">
										분석업종은 지역경제와 밀접한 소분류 업종을 업종간<br/>
										연관성을 고려하여 40개로 그룹화(백화점, 할인점, 예식장,<br/>
										호텔, 영화관 등의 대형업종은 분석대상에서 제외)
			   						</p>
									</div>
									<div class="article_rg">
										<div class="bx_graph chart1"></div>
									</div>
								</div>
								<!-- // -->
							</div>
						</div>
						<!-- //section1 전체 보기 -->

					<!-- section2 카드 소비 ============================== -->
					<div class="section" id="section2">
						<div class="inner">
							<h3 class="hide">카드 소비</h3>
							<!-- 5. 지역별 유입 소비인구 소비금액 -->
							<div id="layout5" class="article_group contents-left-type4 contents-right-type3">
								<div class="article_lf">
									<h4 class="tit text-xxl-m">유입 소비인구 거래금액</h4>
									<dl>
										<dt class="total text-l-r">유입소비인구 거래금액</dt>
										<dd class="total font-orange-light">
											<strong class="list_value num-l-b dataType1">0000.0</strong>
											<span class="unit text-l-r dataType2">억원</span>
										</dd>
									</dl>
									<table class="brd_dl dataTable">
										<tbody>
											<tr>
												<th class="text-l-r"><em class="rank num-m-t font-black-light">1</em>화곡1동</th>
												<td class="text-l-b"><strong>000</strong>천명</td>
											</tr>
											<tr>
												<th class="text-l-r"><em class="rank num-m-t font-black-light">2</em>화곡2동</th>
												<td class="text-l-b"><strong>000</strong>천명</td>
											</tr>
											<tr>
												<th class="text-l-r"><em class="rank num-m-t font-black-light">3</em>화곡3동</th>
												<td class="text-l-b"><strong>000</strong>천명</td>
											</tr>
										</tbody>
									</table>
									<p class="txt_infor text-s-r">
										청구지 주소를 기반으로 분석지역(시군구) 외에서 유입된<br/>
										소비인구가 소비한 금액을 계산
									</p>
								</div>
								<div class="article_rg">
									<div id="map3" class="bx_graph map"></div>
								</div>
							</div>
							<!-- // -->
							
							<!-- 6. 지역별 유입 유동인구 -->
							<div id="layout6" class="article_group contents-left-type4 contents-right-type3">
								<div class="article_lf">
									<h4 class="tit text-xxl-m">유입 유동인구 수</h4>
									<dl>
										<dt class="total text-l-r">유입 유동인구 수</dt>
										<dd class="total font-green">
											<strong class="list_value num-l-b dataType1">0000.0</strong>
											<span class="unit text-l-r dataType2">억원</span>
										</dd>
									</dl>
									<table class="brd_dl dataTable">
										<tbody>
											<tr>
												<th class="text-l-r"><em class="rank num-m-t font-black-light">1</em>화곡1동</th>
												<td class="text-l-b"><strong>000</strong>천명</td>
											</tr>
											<tr>
												<th class="text-l-r"><em class="rank num-m-t font-black-light">2</em>화곡2동</th>
												<td class="text-l-b"><strong>000</strong>천명</td>
											</tr>
											<tr>
												<th class="text-l-r"><em class="rank num-m-t font-black-light">3</em>화곡3동</th>
												<td class="text-l-b"><strong>000</strong>천명</td>
											</tr>
										</tbody>
									</table>
									<p class="txt_infor text-s-r">
										유입 유동인구는 기간 내 해당 지역에서 집계된 유동인구 중<br/>
										거주지가 해당 시군구가 아닌 유동인구
									</p>
								</div>
								<div class="article_rg">
									<div  id="map4" class="bx_graph map"></div>
								</div>
							</div>
							<!-- // -->
							
							<!-- 7. 유입인구 성/연령 특성 -->
							<div id="layout7" class="article_group contents-left-type2 contents-right-type2">
								<div class="article_lf">
									<h4 class="tit text-xxl-m">유입인구 성/연령 특성</h4>
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

							<!-- 8. 업종별 유입 소비인구 소비특성 -->
							<div id="layout8" class="article_group contents-left-type2 contents-right-type2">
								<div class="article_lf">
									<h4 class="tit text-xxl-m">유입 소비인구 소비특성</h4>
									<dl class="border-bottom">
										<dt class="total text-l-r">활성업종</dt>
										<dd class="total num-l-b font-orange-light">
											<strong class="list_value num-l-b">
												<span class="dataType1">피자</span>
												<span class="dataType2">000.0</span>
												<span class="unit text-l-r dataType3">억원</span>
											</strong>
										</dd>
									</dl>
									
									<dl>
										<dt class="total text-l-r">특화업종</dt>
										<dd class="total font-orange-light">
											<strong class="list_value num-l-b">
												<span class="dataType4">피자</span>
												<span class="dataType5">000.0</span>
											</strong>
										</dd>
									</dl>
									
									<p class="txt_infor text-s-r">
										소비특화지수: C = A/B *100<br/>
										시군구 T업종 매출액 비율(%): A<br/>
										시도 T업종 매출액 비율(%): B
									</p>
								</div>
								<div class="article_rg">
									<div class="bx_graph left">
										<h5 class="tit">활성업종</h5>
										<div class="chart1"></div>
									</div>
									<div class="bx_graph right">
										<h5 class="tit">특화업종</h5>
										<div class="chart2"></div>
									</div>
								</div>
							</div>
							<!-- // -->
						</div>
					</div>
					<!-- //section2 카드 소비 ============================== -->

					<!-- section3 유동 인구 ============================== -->
					<div class="section" id="section3">
						<div class="inner">
							<h3 class="hide">유동 인구</h3>
							<!-- 9. 시간대별 유입 소비/유동인구 -->
							<div id="layout9" class="article_group contents-left-type5 contents-right-type3">
								<div class="article_lf">
									<h4 class="tit text-xxl-m">유입인구 시간대 특성</h4>
									<dl>
										<dt class="total text-l-r">주요 방문시간</dt>
										<dd class="total"><strong id="" class="num-l-b font-green dataType1">00 ~ 00시</strong></dd>
									</dl>
									<p class="txt_sub_dl text-s-r border-bottom">${ctyName} 상권을 가장 많이 방문한 시간대</p>
									<dl>
										<dt class="total text-l-r">주요 소비시간</dt>
										<dd class="total"><strong id="" class="num-l-b font-orange-light dataType2">00 ~ 00시</strong></dd>
									</dl>
									<p class="txt_sub_dl text-s-r">${ctyName} 상권을 가장 많이 이용한 시간대</p>
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
									<div id="map5" class="bx_graph map"></div>
								</div>
							</div>
							<!-- // -->
						</div>
					</div>
					<!-- //section3 유동 인구 ============================== -->
					</div>
				</div>
				<!-- //본문 ==================================================================================================== -->
			</div>
			<!-- //contents -->

			<!-- footer -->
			<%@ include file="/WEB-INF/jsp/onmap/main/include/layer_footer.jsp" %>
			<!-- //footer -->
		</div>
	</body>
	<script src="/js/library-common.js?ver=${globalConfig['config.version']}"></script>
	<script src="/js/library-date.js?ver=${globalConfig['config.version']}"></script>
	<script src="/js/library-chart.js?ver=${globalConfig['config.version']}"></script>
	<script src="/js/library-map.js?ver=${globalConfig['config.version']}"></script>
	<script src="/js/trendon/trendon.js?ver=${globalConfig['config.version']}"></script>
	<script src="/js/trendon/ecnmy-trnd.js?ver=${globalConfig['config.version']}"></script>
	<script type="text/javascript">
	$(document).ready(function() {
		
		trendon.trnd['ctyCd'] = '${userInfo.cty_cd}';  // 시군구 코드
		trendon.trnd['megaCd'] = trendon.trnd.ctyCd.substring(0, 2); // 광역시도 코드
		trendon.trnd['serviceClss'] = '${userInfo.service_clss}';
		trendon.trnd['startDate'] = '${startDate}';  // 선택 시작일
		trendon.trnd['endDate'] = '${endDate}'; // 선택 종료일
		trendon.trnd['minStdrDate'] = '${min_stdr_date}'; // 데이터 기준일자 시작일
		trendon.trnd['maxStdrDate'] = '${max_stdr_date}'; // 데이터 기준일자 종료일
		trendon.trnd['minPeriod'] = '${minPeriod}'; // 선택가능한 최소 기간
		trendon.trnd['maxPeriod'] = '${maxPeriod}'; // 선택가능한 최대 기간 [ 테스트 계정: 3, 계약 계정: 12 ]
		trendon.trnd['rgnClss'] = 'H4'; // 행정구역 코드
		
		// 시계열 그래프 그리기
		trendon.callAPI(
 			trendon.trnd.getConfig(0),
 			trendon.trnd.setParameter
 		);
		
		// 처음에 fristPage 가져오기 
		var secFunc = trendon.trnd.sectionFunc[trendon.trnd['lastAnchorLink']];
		secFunc.action();
		
		//현재보고있는 section가져오기
		window.anchorLinkCallBack = function(anchorLink, index){
			trendon.trnd['lastAnchorLink'] = anchorLink;
			var secFunc = trendon.trnd.sectionFunc[anchorLink];
			secFunc.action();
		};
		
// 		trendon.callAPI(
// 			trendon.trnd.getConfig(),
// 			trendon.trnd.setParameter
// 		);
		
		trendon.trnd.createDateRangePicker();  // dateRangePicker 생성
		trendon.trnd.setAllWithDate(); // 기관과 관련된 모든 데이터 설정
	});
	</script>
</html>
