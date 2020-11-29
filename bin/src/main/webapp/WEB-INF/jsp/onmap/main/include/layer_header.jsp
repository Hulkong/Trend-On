<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page session="false" %>

<div id="mainHeader">
	<h1 class="logo"><img src="/images/common/logo.png" alt="logo" /></h1>

	<div class="gnb">
		<%@ include file="/WEB-INF/jsp/onmap/main/include/layer_user.jsp" %>
		<c:set var="length" value="${fn:length(userInfo.cty_nm)}" />
		<c:set var="ctyName" value="${userInfo.cty_nm}" />
	</div>
	
	<div id="nav">
		<ul>
			<li class="menu1"><a href="/onmap/ecnmy_24/main.do">${ctyName} 24시</a></li>
			<li class="menu2"><a href="/onmap/ecnmy_trnd/main.do">경제 트렌드</a></li>
			<li class="menu3"><a href="/onmap/event_effect/main.do">이벤트 효과</a></li>
		</ul>
	</div>
</div>