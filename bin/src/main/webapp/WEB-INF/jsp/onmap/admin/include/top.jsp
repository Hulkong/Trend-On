<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<!-- header -->
<div id="header">
	<div class="inner">
		<div class="logo">
			<h1>
				<span class="tit"><img src="/images/common/logo.png" alt="logo" /></span>
				<span class="txt">관리자</span>
			</h1>
		</div>
		<div class="gnb">
			<span class="user"><em><sec:authentication property="principal.username"/></em>님 반갑습니다.</span>
			<span class="log"><a href="/onmap/ecnmy_24/main.do" target="_blank">뷰어바로가기</a></span>
			<span class="log"><a href="/onmap/login/logout.do">로그아웃</a></span>
		</div>
	</div>
</div>
<!-- //header -->
