<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<script type="text/javascript">
$(document).ready(function() {
	$(".btnMenu").click(function() {
		//$("#snb ul li").removeClass("on");
		$(this).parent().addClass("on");
	});
});
</script>

<!-- snb -->
<div id="snb">
	<ul>
		<li>
			<span>사용자 관리</span>
			<ul>
				<li><a href="/onmap/admin/org_list.do" class="btnMenu">기관 현황</a></li>
				<li><a href="/onmap/admin/api_list.do" class="btnMenu">API 현황</a></li>
			</ul>
		</li>
		<li>
			<span>서비스 사용통계</span>
			<ul>
				<li><a href="/onmap/admin/svc_stats.do">서비스 사용통계</a></li>
				<li><a href="/onmap/admin/api_svc_stats.do">API 사용통계</a></li>
			</ul>
		</li>
		<li>
			<span>사용신청 현황</span>
			<ul>
				<li><a href="/onmap/admin/use_apply_list.do">사용신청 현황</a></li>
			</ul>
		</li>
	</ul>
</div>
<!--//snb -->