<%@ page language="java" contentType="text/html; charset=UTF-8" 	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page session="false"%> 

<div id="header">
	<h1 class="logo">
		<a href="/onmap/crfc_main.do"><img src="/images/common/logo.png" alt="logo" /></a>
	</h1>
	<div class="gnb">
		<%@ include file="/WEB-INF/jsp/onmap/main/include/layer_user.jsp"%>
		<c:set var="length" value="${fn:length(userInfo.cty_nm)}" />
		<c:set var="ctyName" value="${userInfo.cty_nm}" />
	</div>
	<div id="nav">
		<ul>
			<li><a class="text-l-m" href="/onmap/ecnmy_24/main.do">${ctyName} 현황</a></li>
			<li><a class="text-l-m" href="/onmap/ecnmy_trnd/main.do">경제 트렌드</a></li>
			<li><a class="text-l-m" href="/onmap/event_effect/main.do">이벤트 효과</a></li>
		</ul>
	</div>
</div>

<script type="text/javascript">
$(document).ready(function() {
	
	var index = -1;
		
	$('#nav li').removeClass('on');
	
	
	if(location.pathname.indexOf('ecnmy_24') >= 0) index = 0;  // 행정동 현황
	else if(location.pathname.indexOf('ecnmy_trnd') >= 0) index = 1;  // 경제트렌드
	else if(location.pathname.indexOf('event_effect') >= 0) index = 2;  // 이벤트효과 
	
	if(index < 0) return;
	
	$('#nav li').eq(index).addClass('on');
	
});
</script>