<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"  %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/jsp/onmap/admin/include/library.jsp" %>
<script type="text/javascript">
$(document).ready(function() {

	var jq = $('#contents');  			    // 사용신청 정보 제이쿼리 루트 셀렉터
	var no = getUrlParameter('no');   	    // 사용신청 번호
	var state = getUrlParameter('state');   // 사용신청 상태
	var initDatas = {};  				    // 초기화할 데이터
	
	/**
	 * @description 필수 입력값 체크하는 함수
	 */
	function validation() {
		
		if($("#orgNm").val().length < 1) {
			$("#orgNm").focus();
			alert("기관명을 입력해주세요.");
			return false;
		}

		if($("#name").val().length < 1) {
			$("#name").focus();
			alert("이름을 입력해주세요.");
			return false;
		}
		
		if($("#dept").val().length < 1) {
			$("#dept").focus();
			alert("담당부서를 입력해주세요.");
			return false;
		}
		
		if($("#position").val().length < 1) {
			$("#position").focus();
			alert("직함을 입력해주세요.");
			return false;
		}
		
		if($("#mobile").val().length < 1) {
			$("#mobile").focus();
			alert("연착처를 입력해주세요.");
			return false;
		}

		// 핸도픈번호 정규식 
		var pheonRegExp = /^\d{3}-\d{3,4}-\d{4}$/;
		if(!pheonRegExp.test($("#mobile").val())) {
			alert('000-0000-0000 형식으로 입력해 주세요.');
			$("#mobile").focus();
			return false;
		}
		
		if($("#email").val().length < 1) {
			$("#email").focus();
			alert("이메일을 입력해주세요.");
			return false;
		}
		
		// 이메일 정규식
		var emailRule = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
		if(!emailRule.test($("#email").val())) {            
			alert("올바른 이메일형식으로 입력해 주세요.");
			$("#email").focus();
			return false;
		}
		
		return true;
	}
	
	// 사용신청 수정버튼 클릭 이벤트
	jq.find("#btnDataSave").click(function(){
		
		if(!confirm('정말 수정하시겠습니까?')) {
			return;
		}
		
		// 필수 입력값 검증
 		if(!validation()) {
			return;
		}
		
		// 저장
		$.ajax({
			url: "/onmap/admin/modifiedUseApplyUpdt.json",
			data: $('#dataForm').serialize(),
			type: "POST",
			success: function(data) {
				if(data.resultCode > 0) {
					alert("사용신청 정보가 수정되었습니다.");
				} else {
					alert("사용신청 정보를 확인 후 다시 저장해주세요.");
				}
			}
		});	
	});
	
	// 답변내용 수정버튼 클릭 이벤트
	jq.find("#btnAdminSave").click(function() {
		
		if(!confirm('정말 수정하시겠습니까?')) {
			return;
		}
		
		if($("#state").val() == '') {
			alert("상태를 선택해주세요.");
			return false;
		}
		
		// 저장
		$.ajax({
			url: "/onmap/admin/modifiedUseApplyReplyUpdt.json",
			data: $('#dataForm').serialize(),
			type: "POST",
			success: function(data) {
				if(data.resultCode > 0) {
					alert("답변내용이 수정되었습니다.");
				} else {
					alert("답변내용을 다시 확인 후 저장해주세요.");
				}
			}
		});	
		
	});
	
	// 사용신청 정보 취소버튼 클릭 이벤트
	jq.find("#btnDataBack").click(function() {
		jq.find("#orgNm").val(initDatas['org_nm']);
		jq.find("#name").val(initDatas['name']);
		jq.find("#dept").val(initDatas['dept']);
		jq.find("#position").val(initDatas['position']);
		jq.find("#mobile").val(initDatas['mobile']);
		jq.find("#email").val(initDatas['email']);
		jq.find("#memo").val(initDatas['memo']);
		
		if(initDatas['newsletter_yn'] === 'Y') {
			jq.find('#newsletterY').prop('checked', true);
		} else {
			jq.find('#newsletterN').prop('checked', true);
		}
		
	});
	
	// 답변내용 취소버튼 클릭 이벤트
	jq.find("#btnAdminBack").click(function(){
		jq.find("#state").val(initDatas['state']);
		jq.find("#mngNm").val(initDatas['mng_nm']);
		jq.find("#mngHis").val(initDatas['mng_his']);
	});
	
	// 상태 DOM 생성 
	getCommonCodeList({code: 'USE_APPLY_CD'}, function(data) {
		
		var options = '';
		
		data.forEach(function(d, i) {
			options += '<option value="' + d['code'] + '">' + d['cd_nm'] + '</option>';
		});
		
		jq.find('#state').append(options);
		jq.find('#state').val(state);
	});
	
	// 사용신청 수정 값 세팅
	getUseApply({no: no}, function(data) {
		initDatas = data;
		jq.find("#no").val(data['no']);
		jq.find("#orgNm").val(data['org_nm']);
		jq.find("#name").val(data['name']);
		jq.find("#dept").val(data['dept']);
		jq.find("#position").val(data['position']);
		jq.find("#mobile").val(data['mobile']);
		jq.find("#email").val(data['email']);
		jq.find("#memo").val(data['memo']);
		jq.find("#mngNm").val(data['mng_nm']);
		jq.find("#mngHis").val(data['mng_his']);
		
		if(data['newsletter_yn'] === 'Y') {
			jq.find('#newsletterY').prop('checked', true);
		} else {
			jq.find('#newsletterN').prop('checked', true);
		}
	});
});
</script>	
</head>
<body>
	<div id="popup" style="background-color: white;"></div>
	<div id="popupUp" style="background-color: white;"></div>
	<div id="wrap">
		<!-- header -->
		<%@ include file="/WEB-INF/jsp/onmap/admin/include/top.jsp" %>
		<!-- //header -->

		<hr />

		<!-- container -->
		<div id="container">
			<!-- snb -->
			<%@ include file="/WEB-INF/jsp/onmap/admin/include/left.jsp" %>
			<!--//snb -->

			<hr />

			<!-- contents -->
			<div id="contents">
				<!-- 본문 ==================================================================================================== -->
				<div class="contents_body">
					<div class="section_top">
						<h3 class="tit">사용신청 현황</h3>
					</div>
					<form name="dataForm" id="dataForm" method="post">
					<input type="hidden" name="no" id="no" />
				    <div class="brd_wrap">
				    	<div class="article_top">
				    		<h4 class="tit_caption">사용신청 정보</h4>
							<!-- brd_rgt -->
							<div class="brd_btn">
								<div class="group_rgt">
									<ul>
										<li><a href="/onmap/admin/use_apply_list.do" id="btnCancl" class="btn_cancel">목록</a></li>
									</ul>
								</div>
							</div>
							<!-- //brd_rgt -->
				    	</div>
						
						<table class="brd_write left_header">
							<colgroup>
								<col width="150px" />
								<col width="*" />
							</colgroup>
							<tr>
								<th scope="row">기관명</th>
								<td>
									<input type="text" name="orgNm" id="orgNm" value="" />
								</td>
							</tr>
							<tr>
								<th scope="row">담당자/부서/직함</th>
								<td>
									<input type="text" name="name" id="name" value=""  />/
									<input type="text" name="dept" id="dept" value="" />/
									<input type="text" name="position" id="position" value=""  />
								</td>
							</tr>
							<tr>
								<th scope="row">연락처(Mobile/Tel)</th>
								<td>
									<input type="text" name="mobile" id="mobile" value="" maxlength="13"/>
								</td>
							</tr>
							<tr>
								<th scope="row">이메일</th>
								<td>
									<input type="text" name="email" id="email" value="" />
								</td>
							</tr>
							<tr>
								<th scope="row">뉴스레터 수신여부</th>
								<td>
									<input type="radio" name="newsletterYn" id="newsletterY" class="newsletter" value="Y" /> YES
									<input type="radio" name="newsletterYn" id="newsletterN" class="newsletter" value="N" /> NO
								</td>
							</tr>
							<tr>
								<th scope="row">사용신청 내용</th>
								<td>
									<textarea id="memo" name="memo" wrap="PHYSICAL" class="memoText"></textarea>
								</td>
							</tr>
						</table>
						
						<div class="brd_btn brd_btm">
							<div class="group_cnt">
								<ul>
									<li><a href="###" id="btnDataSave" class="btn_confirm">수정</a></li>
									<li><a href="###" id="btnDataBack" class="btn_cancel">취소</a></li>
								</ul>
							</div>
						</div>
					</div>
					
					<div class="brd_wrap">
						<div class="article_top">
							<h4 class="tit_caption">답변내용</h4>
						</div>
						<table class="brd_write left_header">
							<colgroup>
								<col width="150px" />
								<col width="*" />
							</colgroup>
							<tr>
								<th scope="row">상태</th>
								<td>
									<select name="state" id="state" style="width: 150px;">
											<option value="">전체</option>
									</select>
								</td>
							</tr>
							<tr>
								<th scope="row">답변 작성자</th>
								<td>
									<input type="text" name="mngNm" id="mngNm" value="" />
								</td>
							</tr>
							<tr>	
								<th scope="row">관리 <br/>History</th>
								<td>
									<textarea id="mngHis" name="mngHis" wrap="PHYSICAL" class="memoText"></textarea>
								</td>
							</tr>
						</table>
						<div class="brd_btn brd_btm">
							<div class="group_cnt">
								<ul>
									<li><a href="###" id="btnAdminSave" class="btn_confirm">수정</a></li>
									<li><a href="###" id="btnAdminBack" class="btn_cancel">취소</a></li>
								</ul>
							</div>
						</div>
					</div>
					</form>
					</div>
				</div>
				<!-- //본문 ==================================================================================================== -->
			</div>
			<!-- //contents -->
		</div>
		<!-- container -->
	</div>
	
</body>
</html>