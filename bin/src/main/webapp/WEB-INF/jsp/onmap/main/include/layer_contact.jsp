<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!-- 문의하기 -->
	<div id="contactDiv" class="pop_layer2 layer_login layer_div" style="display:none;">
		<div class="layer_top">
			<p class="tit">문의하기</p>
			<a href="#none" class="btn_close">닫기</a>
		</div>
		<div class="layer_con">
			<dl class="dl_write">
				<dt style="display:block;"><span>문의가 있을시 아래의 메일주소로 연락주시기 바랍니다.</span></dt>
				<dt style="display:block;"><span class="tit">sales@openmate-on.co.kr</span></dt>
			</dl>
		</div>
	</div>
<!-- // 문의하기 -->

<script type="text/javascript">
//팝업 닫기
$(".btn_close, .btn_cancel").click(function() {
	$(".layer_div").hide();
});

</script>