<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page session="false" %>

<!-- footer -->
<div id="footer">
	<div class="inner off">
		<button type="button" class="toggle_footer" onclick="clickFooter()">열기</button>
		<ul class="f_menu">
			<li><a href="/common/policy.html?page=0" target="_blank">서비스 약관</a></li>
			<li><a href="/common/policy.html?page=1" target="_blank">개인정보 취급방침</a></li>
			<li><a href="http://www.openmate-on.co.kr/" target="_blank">회사소개</a></li>
		</ul>
		<address>
			서울특별시 중구 청계천로 100, 시그니쳐타워 서관 11층 (주)오픈메이트온<br />
			사업자번호: 763-88-01165    TEL: 02-6956-7541     FAX: 0505-055-7522    EMAIL: sales@openmate-on.co.kr
		</address>
		<p class="company_logo">
			<img src="/images/main/mateon_footer_logo.png" alt="OPENmate_ON"/>
			<img src="/images/main/NICE_gray.png" alt="nice"/>
			<img src="/images/renew_v1/kt-logo.png" alt="kt"/>
		</p>
		<p class="copyright">Copyright ⓒ OPENmate_ON All rights reserved.</p>
	</div>
</div>
<!-- //footer -->

<script>
function clickFooter() {
	var target = event.target;
	if ($(target).parents(".inner").hasClass("on")){
		$(target).parents(".inner").removeClass("on");
		$(target).parents(".inner").addClass("off");
		$("address, .f_menu, .company_logo").slideUp("fast");
	} else if ($(target).parents(".inner").hasClass("off")){
		$(target).parents(".inner").removeClass("off");
		$(target).parents(".inner").addClass("on");
		$("address, .f_menu, .company_logo").slideDown("fast");
	}
}
</script>