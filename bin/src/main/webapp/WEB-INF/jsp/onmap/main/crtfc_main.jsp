<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<sec:authentication property="principal"  var="user" />
 
<%-- <c:out value="${user.extInfo.test}"/> --%>

<!doctype html>
<html lang="ko">
	<head>
		<title>${globalConfig['config.trendOn.title']}</title>
		<meta charset="utf-8" />
		<link rel="shortcut icon" type="image/x-icon" href="/images/common/favicon.ico" />
		<link rel="stylesheet" href="/css/import.css?ver=${globalConfig['config.version']}" />
		<link rel="stylesheet" href="/css/reset.css?ver=${globalConfig['config.version']}"  />
		<link rel="stylesheet" href="/css/common.css?ver=${globalConfig['config.version']}"  />
		<link rel="stylesheet" href="/css/style.css?ver=${globalConfig['config.version']}"  />
		<link rel="stylesheet" href="/css/dev.css?ver=${globalConfig['config.version']}"  />
		<script src="/js/jquery/jquery-1.11.2.min.js"></script>
		<script src="/js/jquery/jquery.easing.1.3.js"></script>
		<script src="/js/jquery/jquery-ui.js"></script>
		<script src="/js/jquery/jquery.fullpage.min.js"></script>
		<script src="/js/common.js?ver=${globalConfig['config.version']}"></script>
		<script src="/js/sub1.js?ver=${globalConfig['config.version']}"></script>
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
								<img src="/images/logs/region_${userInfo.cty_cd }.png" onerror="javascript:changeToText(this,'${userInfo.cty_nm }')" width="450px" height="170px">
							</c:otherwise>
						</c:choose>
<%-- 						 <c:if test="${empty userInfo.region_txt }">아름다운 기억이 머무는 곳, 행복한 도시</c:if> --%>
<%-- 						 <c:if test="${!empty userInfo.region_txt }">${userInfo.region_txt }</c:if> --%>
<%-- 						 <strong>${userInfo.cty_nm }</strong> --%>
					</h2>
					<div class="navi_menu">
						<ul id="data_area">
							<li class="menu1">
								<p>${thisMonth}월 총 거래금액</p>
								<p class="mCenter"><span id="tAmt">0</span> 원</p>
								<c:if test="${user.extInfo.service_clss ne '3' }">
									<p class="mLast">전월 대비 <span id="tRate">0</span></p>
								</c:if>
							</li>
							<li class="menu2">
								<p>${thisMonth}월 최대 소비지역</p>
								<p class="mCenter"><span id="oneAdmi"></span></p>
								<c:if test="${user.extInfo.service_clss ne '3' }">
									<p class="mLast">전월 대비 <span id="admiRate">0</span></p>
								</c:if>
							</li>
							<li class="menu3">
								<p>${thisMonth}월 현재 누적데이터</p>
								<p class="mCenter"><span id="ctyTot">0</span> 건</p>
								<c:if test="${user.extInfo.service_clss ne '3' }">
									<p class="mLast">${thisMonth}월 신규 + <span id="monTot">0</span> 건</p>
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
			$(document).ready(function(){
				
				$('.contents_btn').click(function() {
					location.href = '/onmap/ecnmy_24/main.do' ;
				});
				
				getData("${userInfo.cty_cd}");
				var infopopW = ($(document).width() - 450)/2;
				var infopopH = ($(document).height() - 400)/2;
				var mainImgeH = ($(document).height() - 79);
				var bgImage =  "${user.extInfo.bg_image}";
				var serviceClss =  "${user.extInfo.service_clss}";
				console.log(serviceClss)
				if(bgImage == null || bgImage === undefined || bgImage == ''){
					bgImage = "/images/background/bg_"+"${userInfo.cty_cd}"+".jpg";
				}
				chkImage( bgImage
				, function(){		// 이미지 있음
					$(".crtfcContents").css("backgroundImage", "url("+bgImage+")");
				}, function(){		// 이미지 없음
					bgImage = "/images/main/visual_bg_01.jpg";
					$(".crtfcContents").css("backgroundImage", "url("+bgImage+")");
				});
				
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
