<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page session="false"%>
<!doctype html>
<html lang="ko">
<head>
	<%@ include file="/WEB-INF/jsp/onmap/main/include/layer_library.jsp" %>
	<link rel="stylesheet" 	href="/css/renew_v1.css?ver=${globalConfig['config.version']}" />
	<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.21/css/jquery.dataTables.css">
</head>
<body>
	<div id="fog">
		<div class="reportDataLoading">
			<div class="loadingBox">
				<p class="tit">리포트 데이터를 생성중입니다.</p>
				<p>
					<img src="/images/common/loading.gif" alt="로딩" />
				</p>
				<p class="desc">기간선택에 따라 다소 시간이 걸릴 수 있습니다.</p>
			</div>
		</div>
	</div>
	<div id="wrap" class="city-status">
		<!-- header -->
		<%@ include file="/WEB-INF/jsp/onmap/main/include/layer_header.jsp" %>
		<!-- //header -->
		
		<hr />
		
		<!-- contents -->
		<div id="contents">
			<div id="fp-nav2" class="section_top">
				<div class="left">
					<div class="layout region">
						<p class="top_title text-s-r">지역</p>
						<div onmouseenter="trendon.mouseenterComboBox('.layout.region')" onmouseleave="trendon.mouseleaveComboBox('.layout.region')">
							<p class="top_contents text-xxxl-b">
								<span class="name">마석동</span>
								<img alt="" src="/images/renew_v1/btn_drop-down-off.png">
							</p>
							<ul class="combo-box"></ul>
						</div>
					</div>
					<div class="layout date">
						<p class="top_title text-s-r">날짜</p>
						<div onmouseenter="trendon.mouseenterComboBox('.layout.date')" onmouseleave="trendon.mouseleaveComboBox('.layout.date')">
							<p class="top_contents text-xxxl-b">
								<span class="name">2020년 12월</span>
								<img alt="" src="/images/renew_v1/btn_drop-down-off.png">
							</p>
							<ul class="combo-box"></ul>
						</div>
					</div>
					<div class="layout excel" onclick="trendon.status.clickExcel()" onmouseenter="trendon.status.mouseenterExcel(event)" onmouseleave="trendon.status.mouseleaveExcel(event)">
						<div class="excel_button">
<!-- 							<img alt="" src="/images/renew_v1/btn_ex-down.png" onclick="trendon.status.clickExcel()"> -->
<!-- 							 <img alt="" src="/images/main/ic_user_open.png"> -->
							<div class="image"></div>
						 	<span class="download text-s-m" >엑셀다운</span>
						</div>
					</div>
				</div>
			
				<div class="news right">
					<p>
						<span class="title text-l-b">${userInfo.cty_nm} News</span>
<!-- 						<img class="btn refresh" alt="" src="/images/renew_v1/ic_refresh.png" onclick="trendon.status.clickRefreshNews()"> -->
						<span class="subtitle text-s-r">2020년05월24일 11시19분(업데이트 기준)</span>
					</p>
					<div class="article">
						<a class="link" href="" target="_blank">
							<span class="news_title text-m-r">안동시 "관광지 무료입장'할인 행사"</span>
							<span class="date text-s-r">동아일보 30분 전</span>
						</a>
					</div>
					<div class="article">
						<a class="link" href="" target="_blank">
							<span class="news_title text-m-r">안동시 "관광지 무료입장'할인 행사"</span>
							<span class="date text-s-r">동아일보 30분 전</span>
						</a>
					</div>
					<div class="article">
						<a class="link" href="" target="_blank">
							<span class="news_title text-m-r">안동시 "관광지 무료입장'할인 행사"</span>
							<span class="date text-s-r">동아일보 30분 전</span>
						</a>
					</div>
					<div class="article">
						<a class="link" href="" target="_blank">
							<span class="news_title text-m-r">안동시 "관광지 무료입장'할인 행사"</span>
							<span class="date text-s-r">동아일보 30분 전</span>
						</a>
					</div>
					<div class="article">
						<a class="link" href="" target="_blank">
							<span class="news_title text-m-r">안동시 "관광지 무료입장'할인 행사"</span>
							<span class="date text-s-r">동아일보 30분 전</span>
						</a>
					</div>
					<div class="article">
						<a class="link" href="" target="_blank">
							<span class="news_title text-m-r">안동시 "관광지 무료입장'할인 행사"</span>
							<span class="date text-s-r">동아일보 30분 전</span>
						</a>
					</div>
				</div>
			</div>

			<!-- 본문 ==================================================================================================== -->
			<div id="fullpage">
				<div class="message_layer" id="dataLack">
					<div class="messageBox">
						<p>
							선택하신 기간과 지역은 표본의 크기가 작아서 서비스되지 않습니다.<br /> 다른기간 혹은 다른 지역으로
							이용해주세요.
						</p>
					</div>
				</div>

				<!-- section1 전체 보기 ============================== -->
				<div class="section" id="section1">
					<div class="inner" style="background: #fff;">
					
						<!-- 0. 거래금액 -->
						<div id="layout0" class="article_group contents-left-type1 contents-right-type1 first">
							<div class="article_lf">
								<h4 class="tit text-xxl-m">
									거래금액 
									<span class="sub_title text-l-r">카드소비액기준</span>
								</h4>
								<dl>
									<dt class="list_title text-l-r">총 거래금액</dt>
									<dd class="border-bottom font-orange-light">
										<strong class="list_value num-lm-b dataType1">00.0</strong>
										<span class="unit text-l-r dataType2">억원</span>
									</dd>
								</dl>
								<dl>
									<dt class="list_title text-l-r">전월대비</dt>
									<dd class="border-bottom">
										<strong class="list_value num-lm-b font-orange-light dataType3">00.0%</strong>
										<span class="up_or_down text-l-m font-black-light dataType4">-</span>
									</dd>
								</dl>
								<dl>
									<dt class="list_title text-l-r">전년동기대비</dt>
									<dd class="last">
										<strong class="list_value num-lm-b font-orange-light dataType5">00.0%</strong>
										<span class="up_or_down text-l-m font-black-light dataType6">-</span>
									</dd>
								</dl>
								<p class="txt_infor text-s-r">
									카드소비액은 지역경제와 밀접한 소분류 40개 업종을 기준으로 집계 <br/>
									(백화점, 할인점, 영화관 등 대형업종 제외)
								</p>
							</div>
							<div class="article_rg">
								<div class="graph chart1"></div>
								<div id="map1" class="map"></div>
							</div>
						</div>
						<!-- // -->

						<!-- 1. 유동인구 -->
						<div id="layout1" class="article_group contents-left-type1 contents-right-type1">
							<div class="article_lf">
								<h4 class="tit text-xxl-m">
									유동인구 
									<span class="sub_title text-l-r">통신사 유동인구 기준</span>
								</h4>
								<dl>
									<dt class="list_title text-l-r">총 유동인구</dt>
									<dd class="border-bottom font-green">
										<strong class="list_value num-lm-b dataType1">000.0</strong>
										<span class="unit text-l-r dataType2">만명</span>
									</dd>
								</dl>
								<dl>
									<dt class="list_title text-l-r">전월대비</dt>
									<dd class="border-bottom">
										<strong class="list_value num-lm-b font-green dataType3">00.0%</strong>
										<span class="up_or_down text-l-m font-black-light dataType4">-</span>
									</dd>
								</dl>
								<dl>
									<dt class="list_title text-l-r">전년동기대비</dt>
									<dd class="last">
										<strong class="list_value num-lm-b font-green dataType5">00.0%</strong>
										<span class="up_or_down text-l-m font-black-light dataType6">-</span>
									</dd>
								</dl>
								<p class="txt_infor text-s-r">
									통신사 유동인구는 LTE시그널 데이터로 휴대폰 사용유무와<br/>
									관계없이 집계
								</p>
							</div>
							<div class="article_rg">
								<div class="graph chart1"></div>
								<div id="map2" class="map"></div>
							</div>
						</div>
						<!-- // -->

						<!-- 2. 성/연령별 대표인구 -->
						<div id="layout2" class="article_group contents-left-type2 contents-right-type2">
							<div class="article_lf">
								<h4 class="tit text-xxl-m">성/연령별 대표인구</h4>
								<dl>
									<dt class="list_title text-l-r">유동인구</dt>
									<dd class="border-bottom">
										<strong class="list_value num-l-b font-green dataType1">-</strong>
										<span class="list_desc text-l-m">통신사 유동인구 기준</span>
									</dd>
								</dl>
								<dl>
									<dt class="list_title text-l-r">소비인구</dt>
									<dd class="last">
										<strong class="list_value num-l-b font-orange-light dataType2">-</strong>
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

						<!-- 3. 읍면동 간 비교 -->
						<div id="layout3" class="article_group contents-left-type3 contents-right-type3">
							<div class="article_lf">
								<h4 class="tit text-xxl-m">지역간 비교</h4>
								<ul>
									<li class="border-right border-bottom">
										<dl>
											<dt class="list_title text-l-r font-black-light">주민등록인구</dt>
											<dd class="font-black-light">
												<strong class="list_value num-l-b dataType1">000.0</strong>
												<span class="unit text-l-r dataType2">만명, 0위</span>
											</dd>
										</dl>
									</li>
									<li class="border-bottom">
										<dl>
											<dt class="list_title text-l-r font-black-light">총 유동인구</dt>
											<dd>
												<strong class="list_value num-l-b font-green dataType3">000.0</strong>
												<span class="unit text-l-r font-black-light dataType4">만명, 0위</span>
											</dd>
										</dl>
									</li>
									<li class="border-right">
										<dl>
											<dt class="list_title text-l-r font-black-light">총 거래금액</dt>
											<dd>
												<strong class="list_value num-l-b font-orange-light dataType5">000.0</strong>
												<span class="unit text-l-r font-black-light dataType6">억원, 0위</span>
											</dd>
										</dl>
									</li>
									<li>
										<dl>
											<dt class="list_title text-l-r font-black-light">총 거래량</dt>
											<dd>
												<strong class="list_value num-l-b font-orange-light dataType7">000.0</strong>
												<span class="unit text-l-r font-black-light dataType8">만건, 0위</span>
											</dd>
										</dl>									
									</li>
								</ul>
								<p class="txt_infor text-s-r">전체 <span id="regionTotCnt">0</span>개 읍면동</p>
							</div>
							<div class="article_rg">
								<div class="bx_graph">
									<table class="cell-border hover order-column">
										<thead>
									        <tr>
									            <th>순위</th>
									            <th>명칭</th>
									            <th>주민등록인구</th>
									            <th>총 유동인구</th>
									            <th>총 거래금액</th>
									            <th>총 거래량</th>
									        </tr>
									    </thead>
									</table>
								</div>
							</div>
						</div>
						<!-- // -->
					</div>
				</div>
				<!-- //section1 매출액 ============================== -->

			</div>
		</div>
		<!-- //본문 ==================================================================================================== -->
	</div>
	<!-- //contents -->

	<!-- footer -->
	<%@ include file="/WEB-INF/jsp/onmap/main/include/layer_footer.jsp"%>
	<!-- //footer -->
	</div>
</body>
<script src="/js/library-common.js?ver=${globalConfig['config.version']}"></script>
<script src="/js/library-date.js?ver=${globalConfig['config.version']}"></script>
<script src="/js/library-chart.js?ver=${globalConfig['config.version']}"></script>
<script src="/js/library-map.js?ver=${globalConfig['config.version']}"></script>
<script src="/js/trendon/trendon.js?ver=${globalConfig['config.version']}"></script>
<script src="/js/trendon/city-status.js?ver=${globalConfig['config.version']}"></script>
<script>
$(document).ready(function() {
	console.log("한글 확인");
	trendon.status.ctyNm = '${userInfo.cty_nm}';
	trendon.status.ctyCd = '${userInfo.cty_cd}';
	trendon.status.admiCd = '47170650';
	trendon.status.rgnClss = 'H4';
	trendon.status.dateYm = null;
	
	trendon.status.setAdmiComboBox();
	trendon.status.setNews();
});
</script>
</html>