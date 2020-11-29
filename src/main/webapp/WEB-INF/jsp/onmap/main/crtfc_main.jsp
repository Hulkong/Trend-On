<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<sec:authentication property="principal"  var="user" />
 
<%-- <c:out value="${user.extInfo.test}"/> --%>

<!doctype html>
<html lang="ko">
	<head>
		<%@ include file="/WEB-INF/jsp/onmap/main/include/layer_library.jsp" %>
		<script src="/js/library-common.js?ver=${globalConfig['config.version']}"></script>
		<script src="/js/rending.js?ver=${globalConfig['config.version']}"></script>
	</head>
	<body>
		<div id="wrap">
		<!-- 안내 팝업  -->
<!-- 		<div id="fog_low" style="display:block;"> -->
<!-- 			<div class="infoPop" id="infoPop"> -->
<!-- 				<a herf="#none" id="infoPop_close" class="infoPop_close" ><img src="/images/main/btn_close_modify.png" /></a>	 -->
<!-- 				<h1> 안내문 </h1> -->
<!-- 				<p> -->
<!-- 					안녕하세요.<br/> -->
<!-- 					데이터관련 업데이트 작업을 진행중입니다. <br/> -->
<!-- 					일부 데이터가 다를  수 있습니다.<br/> -->
<!-- 					<strong>9월 10일 오전 9시</strong> 이후<br/> -->
<!-- 					정상적으로 확인하실 수 있습니다.<br/> -->
<!-- 					감사합니다. -->
<!-- 				</p> -->
<!-- 			</div>	 -->
<!-- 		</div> -->
		<!-- /// 안내 팝업  -->

			<!-- header -->
			<%@ include file="/WEB-INF/jsp/onmap/main/include/layer_header.jsp" %>
			<!-- //header -->

			<!-- contents -->
			<div id="mainContents">
				<!-- 본문 ==================================================================================================== -->
				<!-- visual -->
<!-- 				<div id="motion_01" class="rolling visual"> -->
					<div class="crtfcContents"></div>
<!-- 				</div> -->
				<!-- //visual -->
				<!--  -->
				<div class="">
					<h2 class="tit_main">
						<c:choose>
							<c:when test="${!empty user.extInfo.sg_image && user.extInfo.sg_image ne ''}">
								<img src="${user.extInfo.sg_image }" onerror="javascript:src='/images/logs/region_${userInfo.cty_cd }.png'" width="450px" height="170px">
							</c:when>
							<c:otherwise>
								<img src="/images/logs/region_${userInfo.cty_cd }.png" onerror="javascript:trendon.rending.changeToText(this,'${userInfo.cty_nm }')" width="450px" height="170px">
							</c:otherwise>
						</c:choose>
<%-- 						 <c:if test="${empty userInfo.region_txt }">아름다운 기억이 머무는 곳, 행복한 도시</c:if> --%>
<%-- 						 <c:if test="${!empty userInfo.region_txt }">${userInfo.region_txt }</c:if> --%>
<%-- 						 <strong>${userInfo.cty_nm }</strong> --%>
					</h2>
					<div class="navi_menu">
						<ul id="data_area">
							<!-- 총 거래금액 -->
							<li class="menu1">
								<p>${thisMonth}월 총 거래금액</p>
								<p class="mCenter"><span id="dataType1">0</span> 원</p>
								<c:if test="${user.extInfo.service_clss ne '3' }">
									<p class="mLast">전월 대비 <span id="dataType2">0</span></p>
								</c:if>
							</li>
							
							<!-- 최대 소비지역 -->
							<li class="menu2">
								<p>${thisMonth}월 최대 소비지역</p>
								<p class="mCenter"><span id="dataType3"></span></p>
								<c:if test="${user.extInfo.service_clss ne '3' }">
									<p class="mLast">전월 대비 <span id="dataType4">0</span></p>
								</c:if>
							</li>
							
							<!-- 현재 누적데이터 -->
							<li class="menu3">
								<div>
									<p>${thisMonth}월 현재 누적데이터</p>
									<p class="mCenter"><span id="dataType5">0</span> 건</p>
									<c:if test="${user.extInfo.service_clss ne '3' }">
										<p class="mLast">${thisMonth}월 신규 + <span id="dataType6">0</span> 건</p>
									</c:if>
								</div>
							</li>
							
							<!-- 총 유동인구 -->
							<li class="menu4">
								<p>${thisMonth}월 총 유동인구</p>
								<p class="mCenter"><span id="dataType7">0</span> 명</p>
								<c:if test="${user.extInfo.service_clss ne '3' }">
									<p class="mLast">전월 대비 <span id="dataType8">0</span></p>
								</c:if>
							</li>
							
							<!-- 최대 유동인구 -->
							<li class="menu5">
								<p>${thisMonth}월 최대 유동인구</p>
								<p class="mCenter"><span id="dataType9"></span></p>
								<c:if test="${user.extInfo.service_clss ne '3' }">
									<p class="mLast">전월 대비 <span id="dataType10">0</span></p>
								</c:if>
							</li>
						</ul>
					</div>
					<div class="bottomBtn">
						<span class="contents_btn"><a href="###"> 더 알아보기 </a></span>
					</div>
				</div>
				<!-- // -->
				<!-- //본문 ==================================================================================================== -->
			</div>
			<!-- //contents -->
			<!-- footer -->
			<%@ include file="/WEB-INF/jsp/onmap/main/include/layer_footer.jsp" %>
			<!-- /// footer -->
		</div>

		<script type="text/javascript">
			$(document).ready(function() {
				
				var ctyCd = "${userInfo.cty_cd}";
				var requestKeys = ['data', 'graph', 'map']; // 실제 서버에 요청할 키값들(횟수)
				trendon.rending.getConfig().reduce(function(acc, v, i) {
					
					if(!v) return;
					
					requestKeys.map(function(key) {
						
						if(!v[key] || v[key].length === 0) return;
						
						var realKeys =  Array.isArray(v[key]) ? v[key] : [v[key]] ;
						
						realKeys.map(function(data) {
							var path = data['path'];
							var params = setParameter(data['params']);
							var callback = data['callback'];
							var title = v['name'];
							var message = data['message'];
							var consoleMsg = [
								[title, message].join('-'), 
								true
							]
							
							OM.Comm.getData(path, params, callback, consoleMsg);
						});
					});
					
				}, []);
				
				/**
				 * @description 서버 요청 파라미터 설정
				 */
				function setParameter(data) {
					var tmpData = OM.Comm.deepCloneObj(data);  // 얕은 복사
					var keys = Object.keys(tmpData);
					
					keys.map(function(key) {
						var value = tmpData[key];
						
						if(key === 'ctyCd' && !value) tmpData[key] = ctyCd;
					});
					
					return tmpData;
				}
				
				$('.contents_btn').click(function() {
					location.href = '/onmap/ecnmy_24/main.do' ;
				});
				
				var infopopW = ($(document).width() - 450)/2;
				var infopopH = ($(document).height() - 400)/2;
				var mainImgeH = ($(document).height() - 79);
				var bgImage =  "${user.extInfo.bg_image}";
				var serviceClss =  "${user.extInfo.service_clss}";
				
				if(bgImage == null || bgImage === undefined || bgImage == ''){
					bgImage = "/images/background/bg_"+"${userInfo.cty_cd}"+".jpg";
				}
				
				trendon.rending.checkImage( bgImage,
					function() { $(".crtfcContents").css("backgroundImage", "url("+bgImage+")"); },   // 이미지 있음 
					function() {  // 이미지 없음		
						bgImage = "/images/main/visual_bg_01.jpg";
						$(".crtfcContents").css("backgroundImage", "url("+bgImage+")");
					}
				);
				
				$(".crtfcContents").height(mainImgeH);
				$(".crtfcContents").css("backgroundSize", "cover");
				
				// 안내 팝업 크기 변경
				$("#infoPop").css("left", infopopW);
				$("#infoPop").css("top", infopopH);
				
				// 안내 팝업에 닫기 버튼
				$("#infoPop_close").click(function(){
					$("#fog").hide();
				});	
			});	
		</script>
	</body>
</html>
