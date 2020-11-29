<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!doctype html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/jsp/onmap/admin/include/library.jsp" %>
<script type="text/javascript">
$(document).ready(function() {
	
	var jq = $('#contents');     				      // 기관수정 제이쿼리 루트 셀렉터
	var orgId = getUrlParameter('orgId');			  // 기관아이디 
	var contractId = getUrlParameter('contractId');   // 계약아이디 
	var megaCd = getUrlParameter('megaCd'); 	      // 시도코드
	var ctyCd =  getUrlParameter('ctyCd');			  // 시군구코드
	var initDatas = {};  				    		  // 초기화할 데이터
	
	/**
	 * @description 필수 입력값 체크하는 함수
	 */
	function validationOrg() {
		var orgNm = jq.find("#orgNm");           // 기관명
		var megaCd = jq.find("#megaCd");         // 시도코드 
		var ctyCd = jq.find("#ctyCd");           // 시군구코드 
		var userId = jq.find('#userId');         // 유저아이디 
		var mngNm = jq.find("#mngNm");           // 담당자명 
		var mngMobile = jq.find("#mngMobile");   // 담당자 연락처(mobile)
		var mngEmail = jq.find("#mngEmail");     // 담당자 이메일

		if("" == orgNm.val()) {
			alert("기관명을 입력해 주세요.");
			orgNm.focus();
			return false;
		}

		if("" == megaCd.val()) {
			alert("시도를 선택해 주세요.");
			megaCd.focus();
			return false;
		}

		if("" == ctyCd.val()) {
			alert("시군구를 선택해 주세요.");
			ctyCd.focus();
			return false;
		}
		
		if("" == userId.val()) {
			alert("아이디를 입력해 주세요.");
			userId.focus();
			return false;
		}
		
		if(jq.find('#dupUserId').text().length > 0) {
			alert("중복된 아이디입니다.");
			userId.focus();
			return false;
		}
		
		if("" == mngNm.val()) {
			alert("기관 담당자명을 입력해 주세요.");
			mngNm.focus();
			return false;
		}

		if("" == mngMobile.val()) {
			alert("기관 담당자의 연락처를 입력해 주세요.");
			mngMobile.focus();
			return false;
		}
		
		// 핸도픈번호 정규식 
		var pheonRegExp = /^\d{3}-\d{3,4}-\d{4}$/;
		if(!pheonRegExp.test(mngMobile.val())) {
			alert('000-0000-0000 형식으로 입력해 주세요.');
			mngMobile.focus();
			return false;
		}
		
		if("" == mngEmail.val()) {
			alert("기관 담당자의 이메일을 입력해 주세요.");
			mngEmail.focus();
			return false;
		}
		
		// 이메일 정규식
		var emailRule = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
		if(!emailRule.test(mngEmail.val())) {            
			alert("올바른 이메일형식으로 입력해 주세요.");
			mngEmail.focus();
			return false;
		}

		return true;
	}
	
	/**
	 * @description 메일 필수 입력값 체크하는 함수
	 */
	function validationMail() {
		var mngEmail = jq.find("#mngEmail");     // 담당자 이메일
		var orgNm = jq.find("#orgNm");           // 기관명
		var megaCd = jq.find("#megaCd");         // 시도코드 
		var ctyCd = jq.find("#ctyCd");           // 시군구코드 
		var userId = jq.find('#userId');         // 유저아이디 

		if("" == mngEmail.val()) {
			alert("기관 담당자의 이메일을 입력해 주세요.");
			mngEmail.focus();
			return false;
		}
		
		// 이메일 정규식
		var emailRule = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
		if(!emailRule.test(mngEmail.val())) {            
			alert("올바른 이메일형식으로 입력해 주세요.");
			mngEmail.focus();
			return false;
		}
		
		if("" == orgNm.val()) {
			alert("기관명을 입력해 주세요.");
			orgNm.focus();
			return false;
		}

		if("" == megaCd.val()) {
			alert("시도를 선택해 주세요.");
			megaCd.focus();
			return false;
		}

		if("" == ctyCd.val()) {
			alert("시군구를 선택해 주세요.");
			ctyCd.focus();
			return false;
		}
		
		if("" == userId.val()) {
			alert("아이디를 입력해 주세요.");
			userId.focus();
			return false;
		}
		
		if(jq.find('#dupUserId').text().length > 0) {
			alert("중복된 아이디입니다.");
			userId.focus();
			return false;
		}
		
		return true;
	}
	
	/**
	 * @description 계약현황 리스트 테이블 중 수정/메일 버튼 클릭 이벤트 바인딩하는 함수
	 */
	function setContractListTableClick() {
		
		// 계약현황 테이블의 수정버튼 클릭
		jq.find(".btn_contract_updt").click(function() {

			$("#popup").dialog({
				title : 'title',
				width : 540,
				height : 'auto',
				position : ["center", 100],  // [포지션, top픽셀]
				modal : false,
				draggable : true,
				show : 'clip',
				hide : 'clip',
				resizable : false,
				overlay : {
					background : '#FFFFFF',
					opacity : 0.5
				},
				close : function() {
					$(this).dialog("close");
				}
			});
			$("#popup").draggable().resizable();
			$(".ui-dialog-titlebar").hide();
			$("#popup").load("/onmap/admin/pop_contract_updt.do", {
				orgId: orgId,
				contractId: $(this).attr('contract_id'),
				serviceClss: $(this).attr('service_clss')
			});
		});

		// 메일버튼 클릭 
		jq.find(".btn_contract_mail").click(function() {

			if(!confirm('메일을 보내시겠습니까?')) {
				return;
			}
			
			// 필수 입력값 검증
	 		if(!validationMail()) {
				return;
			}

			$.blockUI({
				message : '<img src="/images/admin/ajax-loader.gif" />',
				css : {
					border : 'none',
					padding : '0px',
					width : '32px',
					height : '32px'
				}
			});
			
			$.ajax({
				url : '/onmap/admin/sendServiceGuide.json',
				type : "POST",
				async : true,
				data : {
					emailType: 'serviceGuide',
					email: jq.find('#mngEmail').val(),
					orgNm: jq.find('#orgNm').val(),
					orgId: orgId,
					useStrDate: jq.find('#contractListTbody tr').eq(0).find('td').eq(2).text(),
					useEndDate: jq.find('#contractListTbody tr').eq(0).find('td').eq(3).text(),
					fullName: jq.find('#megaCd option:selected').text() + ' ' + jq.find('#ctyCd option:selected').text(),
					userId: jq.find('#userId').val()
				},
				success : function(data) {
					$.unblockUI();
					
					if (data.resultCode === 1) {
						alert("서비스 정보 안내 메일을 발송했습니다.");
					} else {
						alert("서비스 정보 안내 메일 발송에 실패 했습니다.");
					}
				},
				error : function(e) {
					alert("관리자에게 문의해 주세요.");
				}
			});
		});
		
		// 계약현황 테이블의 수정버튼 클릭
// 		jq.find(".btn_contract_api").click(function() {

// 			$("#popup").dialog({
// 				title : 'title',
// 				width : 540,
// 				height : 'auto',
// 				position : ["center", 100],  // [포지션, top픽셀]
// 				modal : false,
// 				draggable : true,
// 				show : 'clip',
// 				hide : 'clip',
// 				resizable : false,
// 				overlay : {
// 					background : '#FFFFFF',
// 					opacity : 0.5
// 				},
// 				close : function() {
// 					$(this).dialog("close");
// 				}
// 			});
// 			$("#popup").draggable().resizable();
// 			$(".ui-dialog-titlebar").hide();
// 			$("#popup").load("/onmap/admin/pop_api.do", {
// 				orgId: orgId,
// 				contractId: $(this).attr('contract_id')
// 			});
// 		});
	}
	
	/**
	 * @description 계약현황 테이블 UI 생성하는 함수 
	 * @param data: 테이블생성시 필요데이터, Array  
	 */
	function makeContractListTableDOM(data) {
		
		jq.find('#contractListTbody').empty();
		
		var tbodyContents = '';
		
		if(data.length === 0) {
			tbodyContents += '<tr>';
			tbodyContents += 	'<td colspan="9">등록된 계약 정보가 없습니다.</td>';
			tbodyContents += '</tr>';
		} else {
			data.forEach(function(d, i) {
				var button = '';
					button += '<div class="brd_btn td_btn">';
					button += 	'<div class="group_cnt">';
	            		button += 		'<ul>';
	            		button += 			'<li>';
	            		button += 				'<a href="#none" contract_id="' + d['contract_id'] + '" service_clss="' + d['service_clss'] + '" class="btn_confirm btn_contract_updt">수정</a>';
	            		button += 			'</li>';
	            		
	            		// 최신계약건에 대해서만 메일버튼 활성화
	            		if(i === 0) {
		            		button += 		'<li>';
		            		button += 			'<a href="#none" contract_id="' + d['contract_id'] + '" service_clss="' + d['service_clss'] + '" class="btn_confirm btn_contract_mail">메일</a>';
		            		button += 		'</li>';
	            		}
	            		
	            		if(d['service_clss'] === '5') {
	            			button += 		'<li>';
		            		button += 			'<a href="#none" contract_id="' + d['contract_id'] + '" service_clss="' + d['service_clss'] + '" class="btn_confirm btn_contract_api">API</a>';
		            		button += 		'</li>';
	            		}
	            		
	            		button += 		'</ul>';
	            		button += 	'</div>';
	            		button += '</div>';
	            		
				tbodyContents += '<tr>';
				tbodyContents += 	'<td>' + d['contract_id'] + '</td>';
				tbodyContents += 	'<td>' + d['cd_nm'] + '</td>';
				tbodyContents += 	'<td>' + d['use_str_date'] + '</td>';
				tbodyContents += 	'<td>' + d['use_exp_date'] + '</td>';
				tbodyContents += 	'<td>' + d['cont_date'] + '</td>';
				tbodyContents += 	'<td>' + d['contract_organ'] + ' / ' + d['contract_nm'] + '</td>';
				tbodyContents += 	'<td>' + numberWithCommas(d['contract_fee']) + '</td>';
				tbodyContents += 	'<td>' + button + '</td>';
				tbodyContents += '</tr>';
			});
		}
		
		jq.find('#contractListTbody').append(tbodyContents);
		setContractListTableClick();
	}
	
	/**
	 * @description 해당 기관 서비스 사용통계 테이블 UI 생성하는 함수 
	 * @param data: 테이블생성시 필요데이터, Array  
	 */
	function makeOrgSvcStatsTableDOM(data) {
		jq.find('#orgSvcStatsTbody').empty();
		
		var tbodyContents = '';
		
		if(data.length === 0) {
			tbodyContents += '<tr>';
			tbodyContents += 	'<td colspan="11">해당 기관에 대한 서비스 사용통계가 없습니다.</td>';
			tbodyContents += '</tr>';
		} else {
			data.forEach(function(d, i) {
				tbodyContents += '<tr>';
				tbodyContents += 	'<td>' + d['contract_id'] + '</td>';
				tbodyContents += 	'<td>' + d['cd_nm'] + '</td>';
				tbodyContents += 	'<td>' + d['use_str_date'] + '</td>';
				tbodyContents += 	'<td>' + d['use_exp_date'] + '</td>';
				tbodyContents += 	'<td>' + d['access_cnt'] + '</td>';
				tbodyContents += 	'<td>' + d['ecnmy24'] + '</td>';
				tbodyContents += 	'<td>' + d['ecnmy_trnd'] + '</td>';
				tbodyContents += 	'<td>' + d['evnt_effect'] + '</td>';
				tbodyContents += '</tr>';
			});
		}
		
		jq.find('#orgSvcStatsTbody').append(tbodyContents);
	}
	
	/**
	 * @description 이미지 업로드 바인딩하는 함수
	 */
// 	function fileEventBinding(target) {
		
// 		if(!target) {
// 			alert('바인딩할 타겟이 없습니다!');
// 			return;
// 		}
		
// 		target.find('.getfile').each(function(index, file) {
			
// 			file.onchange = function () {
				
// 			    var fileList = file.files ;
// 			    var self = $(this).parent();
// 			    // 읽기
// 			    var reader = new FileReader();
// 			    reader.readAsDataURL(fileList[0]);
		
// 			    //로드 한 후
// 			    reader.onload = function  () {
			    	
// 			        //썸네일 이미지 생성
// 			        var tempImage = new Image(); //drawImage 메서드에 넣기 위해 이미지 객체화
// 			        tempImage.src = reader.result; //data-uri를 이미지 객체에 주입
// 			        tempImage.onload = function () {
// 			            //리사이즈를 위해 캔버스 객체 생성
// 			            var canvas = document.createElement('canvas');
// 			            var canvasContext = canvas.getContext("2d");
		
// 			            //캔버스 크기 설정
// 			            canvas.width = 100; //가로 100px
// 			            canvas.height = 100; //세로 100px
			            
// 			            //이미지를 캔버스에 그리기
// 			            canvasContext.drawImage(this, 0, 0, 100, 100);
		
// 			            //캔버스에 그린 이미지를 다시 data-uri 형태로 변환
// 			            var dataURI = canvas.toDataURL("image/jpeg");
		
// 			            //썸네일 이미지 보여주기
// 			            self.find('.thumbnail').attr('src', dataURI);
			            
// 			            //썸네일 이미지를 다운로드할 수 있도록 링크 설정
// 			            self.find('.download').attr('href', dataURI);
// 			    	};
// 			    };
// 			};	
// 		});
// 	}
	
	// 아이디 중복확인 
	jq.find('#userId').keydown(_.debounce(function(e) {
		var userId = $(this).val();
		
		// 입력값이 있을 경우 
		if(userId && userId.length > 0) {
			$.ajax({
				url: '/onmap/admin/checkDupUserId.json',
				type: 'POST',
				dataType: 'JSON',
				data: {
					userId: userId,
					orgId: orgId
				},
				asysc: true,
				success: function(check) {
					
					// 유저아이디가 중복인 경우 
					if(check) {
						jq.find('#dupUserId').text('* 이미 사용중인 아이디입니다.');
						
					// 유저아이디가 중복이지 않은 경우 
					} else {
						jq.find('#dupUserId').text('');
					}
				},
				error: function(a,b,c) {
					console.log(a, b, c)
				}
			});
		}
	}, 800));
	
	// 비밀번호 초기화 버튼 클릭 
	jq.find('#btnPassword').click(function() {
		
		if(!confirm('비밀번호를 초기화 하시겠습니까?')) {
			return;
		}
		
		$.ajax({
			url:'/onmap/admin/resetOrgPwd.json',
			type: "POST",
			data: {orgId: orgId},
			dataType: 'json',
			async: true,
			success: function(data) {
				
				if(data.resultCode > 0) {
					jq.find('#initPassword').text('* 비밀번호가 초기화 되었습니다.');
				} else {
					alert(data.resultMsg);
				}
			},
			error: function(a,b,c) {
				alert("에러가 발생했습니다. 관리자에게 문의하세요");
			}
		});
	});
	
	// 서비스지역 시도 변경 
	jq.find("#megaCd").change(function() {
		var megaCd = $(this).val();

		$("#ctyCd").empty();
		$("#ctyCd").append("<option value=''>::: 시군구</option>");

		$.ajax({
			url:'/common/area_select_option.json',
			type:"POST",
			data:{
				"rgnClss": "H3",
				"megaCd": megaCd
			},
			async: true,
			success: function(data){

				for(var i = 0; i < data.length; i++) {
					var dataMap = data[i];
					$("#ctyCd").append("<option value=" + dataMap.id + ">" + dataMap.nm + "</option>");
				}

				$('#refUserId').text('');   // 참고 유저아이디값 초기화 
			}
		});
	});

	// 서비스지역 시군구 변경
	// 행정구역 영어명 조회
	jq.find("#ctyCd").change(function() {
		var ctyCd = $(this).val();  								 // 선택된 시도코드
		var megaNm = jq.find("#megaCd option:selected").text();   // 선택된 시도명 
		var ctyNm = jq.find("#ctyCd option:selected").text();     // 선택된 시군구명 
		
		// 시도가 선택된 경우 
		if(megaNm && megaNm.length > 0) {
			$.ajax({
				url: '/onmap/admin/getAdmiDistEngNm.json',
				type: 'POST',
				dataType: 'JSON',
				data: {
					megaNm: megaNm,
					ctyNm: ctyNm
				},
				asysc: true,
				success: function(data) {
					
					// 해당 행정구역 영어명이 있을 경우 
					if(data['admiDistEngNm']) {
						
						// 정제된 행정구역 영어명
						var cleanNm = data['admiDistEngNm'].toLowerCase().replace('-', '').replace(/ /gi, "-");
						$('#refUserId').text(cleanNm);
						
					// 해당 행정구역 영어명이 없을 경우 
					} else {
						$('#refUserId').text('');
					}
				},
				error: function(a,b,c) {
					console.log(a, b, c)
				}
			});
		}
	});
	
	// 기관정보 수정 버튼 클릭 이벤트
	jq.find("#btn_org_save").click(function() {
		
		if(!confirm('정말 수정하시겠습니까?')) {
			return;
		}
		
		// 필수 입력값 검증
 		if(!validationOrg()) {
			return;
		}
 		
		// 이미지파일 확장자 검증
 		var fileObj1 = $("#imgFile1");
 		var fileObj2 = $("#imgFile2");
 		if(fileObj1.val() != "" && fileObj1.val().indexOf(".") != -1) {
 			var ext = fileObj1.val().split(".").pop().toLowerCase();
 			if("jpg,png,jpeg".indexOf(ext) == -1) {
 				alert("이미지 파일만 업로드 할 수 있습니다.");
 				return;
 			}
 		}
 		if(fileObj2.val() != "" && fileObj2.val().indexOf(".") != -1) {
 			var ext = fileObj2.val().split(".").pop().toLowerCase();
 			if("jpg,png,jpeg".indexOf(ext) == -1) {
 				alert("이미지 파일만 업로드 할 수 있습니다.");
 				return;
 			}
 		}

 		// orgId form태그에 추가
 		jq.find('#dataForm').append('<input type="hidden" name="orgId" value="' + orgId + '"/>');
 		jq.find('#dataForm').attr("action", "/onmap/admin/modifiedOrg.json")
 		$('#dataForm').ajaxForm({
 			success: function(data) {
				if(data.resultCode > 0) {
					alert("기관 수정을 완료 했습니다.");
					location.href = '/onmap/admin/org_list.do';
				} else {
					alert(data.resultMsg);
				}
			},
			error: function() {
				alert("에러가 발생했습니다. 관리자에게 문의하세요");
			}
 			
 		});
 		$('#dataForm').submit();
	});
	
	// 기관정보 초기화 버튼 클릭 이벤트
	jq.find("#btn_org_init").click(function() {
		jq.find('#orgNm').val(initDatas['org_nm']);
		jq.find('#userId').val(initDatas['user_id']);
		jq.find('#megaCd').val(initDatas['mega_cd']).change();
		setTimeout(function() {jq.find('#ctyCd').val(initDatas['cty_cd'])}, 300);
		jq.find('#regionTxt').val(initDatas['region_txt']);
		jq.find('#mngNm').val(initDatas['mng_nm']);
		jq.find('#mngPosition').val(initDatas['mng_position']);
		jq.find('#mngDept').val(initDatas['mng_dept']);
		jq.find('#mngMobile').val(initDatas['mng_mobile']);
		jq.find('#mngTel').val(initDatas['mng_tel']);
		jq.find('#mngEmail').val(initDatas['mng_email']);
		jq.find('#memo').val(initDatas['memo']);
		jq.find('#imgFile1').val('');
		jq.find('#imgFile2').val('');
	});
	
	// 계약현황 테이블의 추가버튼 클릭
	jq.find("#btn_contract_add").click(function() {

		$("#popup").dialog({
			title : 'title',
			width : 540,
			height : 'auto',
			position : ["center", 100],
			modal : false,
			draggable : true,
			show : 'clip',
			hide : 'clip',
			resizable : false,
			overlay : {
				background : '#FFFFFF',
				opacity : 0.5
			},
			close : function() {
				$(this).dialog("close");
			}
		});
		$("#popup").draggable().resizable();
		$(".ui-dialog-titlebar").hide();
		$("#popup").load("/onmap/admin/pop_contract_add.do", {
			orgId: orgId
		});
	});
	
	// 보기 이벤트
	jq.find("#btnView").click(function() {

		var imageKey = $("#imageKey").val();

		if ("" == imageKey) {
			alert("첨부한 이미지가 없습니다.");
			return;
		}

		$("#imgViewPop").dialog({
			title : 'title',
			width : 850,
			height : 400,
			position : "center",
			modal : true,
			show : 'clip',
			hide : 'clip',
			resizable : false,
			overlay : {
				backgroundColor : '#FFFFFF',
				opacity : 0.5
			},
			close : function() {
				$(this).dialog("close");
			}
		});
		$(".ui-dialog-titlebar").hide();
	});

	$("#btnViewCancl").click(function() {
		$('#imgViewPop').dialog('close');
	});

	// 전체 시도 리스트 DOM 생성 
	getAreaSelectOption({rgnClss: 'H1'}, function(data) {
		
		var options = '';
		var queryStrMegaCd = megaCd;   // url 쿼리스트링에서 가져온 시도코드 
		
		data.forEach(function(d, i) {
			
			if(d['id'] === queryStrMegaCd) {
				options += '<option selected value="' + d['id'] + '">' + d['nm'] + '</option>'	
			} else {
				options += '<option value="' + d['id'] + '">' + d['nm'] + '</option>';
			}
		});
		
		jq.find('#megaCd').append(options);
	});
	
	// 전체 시도 리스트 DOM 생성 
	getAreaSelectOption({
		rgnClss: 'H3',
		megaCd: megaCd
	}, function(data) {
		
		var options = '';
		var queryStrCtyCd = ctyCd;    // url 쿼리스트링에서 가져온 시군구코드 
		
		data.forEach(function(d, i) {
			
			if(d['id'] === queryStrCtyCd) {
				options += '<option selected value="' + d['id'] + '">' + d['nm'] + '</option>'	
			} else {
				options += '<option value="' + d['id'] + '">' + d['nm'] + '</option>';
			}
			
		});
		
		jq.find('#ctyCd').append(options);
	});
	
	// 기관 수정 테이블 데이터 매핑
	getOrg({
		orgId: orgId,
		contractId: contractId
	}, function(data) {
		initDatas = data;
		
		jq.find('#orgNm').val(data['org_nm']);
		jq.find('#userId').val(data['user_id']);
		jq.find('#regionTxt').val(data['region_txt']);
		jq.find('#mngNm').val(data['mng_nm']);
		jq.find('#mngPosition').val(data['mng_position']);
		jq.find('#mngDept').val(data['mng_dept']);
		jq.find('#mngMobile').val(data['mng_mobile']);
		jq.find('#mngTel').val(data['mng_tel']);
		jq.find('#mngEmail').val(data['mng_email']);
		jq.find('#memo').val(data['memo']);
	});
	
	getOrgImages({
		orgId: orgId,
	}, function(data) {
		if(data !== undefined && data != null){
			data.forEach(function(d, i){
				if(d.type == 'bg'){
					jq.find('#pastFile1').val(d.image_key);
					jq.find('#pImage1').text("* " + d.ori_name);
					//삭제 버튼 추가
					jq.find('#btnDelBg').attr("file-key",d.image_key);
					jq.find('#btnDelBg').css("display","inline-block");
					
				}else if(d.type == 'sg'){
					jq.find('#pastFile2').val(d.image_key);
					jq.find('#pImage2').text("* " + d.ori_name);
					//삭제 버튼 추가
					jq.find('#btnDelSg').attr("file-key",d.image_key);
					jq.find('#btnDelSg').css("display","inline-block");
				}
			});
		}
	});
	
	// 계약현황 리스트 테이블 DOM 생성
	getContractList({
		orgId: orgId
	}, makeContractListTableDOM);
	
	// 해당 기관 서비스 사용통계 테이블 DOM 생성 
	getOrgSvcStats({
		orgId: orgId
	}, makeOrgSvcStatsTableDOM);
	
	// 이미지 삭제 버튼클릭 
	$(".delImgBtn").click(function(){
		var fileKey = $(this).attr("file-key");
		var imgType = $(this).attr("image-type");
		
		// 이미지 삭제 시작 ( upload 폴더에 있는 이미지 삭제 , attach DB에 있는 기록 삭제)
		delOrgImage({
			fileKey : fileKey,			
		}, function(data){
			if(data.resultCode == 1){				
				// input 과거, 현재 value 초기화
				if(imgType == 'bg'){					
					// 삭제 완료시 메세지 표시 
					alert("메인 이미지가 삭제되었습니다.");
					$("#pastFile1").val("");	
					jq.find('#pImage1').text("* 가로 1921px * 세로 933px 파일을 선택해주세요.");
					jq.find('#btnDelBg').css("display","none");
				}else {						
					// 삭제 완료시 메세지 표시 
					alert("슬로건 이미지가 삭제되었습니다.");
					$("#pastFile2").val("");			
					jq.find('#pImage2').text("* 가로 676px * 세로 246px 파일을 선택해주세요.");
					jq.find('#btnDelSg').css("display","none");
				}
			}else{
				alert(data.resultMsg);
				return;
			}
		});
		
	});
});
</script>
</head>
<body>
	<div id="popup" style="background-color: white;"></div>
	<div id="popupUp" style="background-color: white;"></div>
	<div id="wrap">
		<!-- header -->
		<%@ include file="/WEB-INF/jsp/onmap/admin/include/top.jsp"%>
		<!-- //header -->

		<hr />

		<!-- container -->
		<div id="container">
			<!-- snb -->
			<%@ include file="/WEB-INF/jsp/onmap/admin/include/left.jsp"%>
			<!--//snb -->

			<hr />

			<!-- contents -->
			<div id="contents">
				<!-- 본문 ==================================================================================================== -->
				<div class="contents_body">
					<div class="section_top">
						<h3 class="tit">기관 수정</h3>
					</div>
					<form name="dataForm" id="dataForm" method="post" enctype="multipart/form-data">
							<h4 class="tit_caption">기관정보</h4>
							<table class="brd_write left_header">
								<colgroup>
									<col width="150px" />
									<col width="*" />
									<col width="150px" />
									<col width="*" />
									<col width="150px" />
									<col width="*" />
								</colgroup>
								<tr>
									<th scope="row">* 기관명</th>
									<td colspan="5">
										<input type="text" name="orgNm" id="orgNm" value="" />
									</td>
								</tr>
								<tr>
									<th scope="row">* 서비스 지역</th>
									<td colspan="5">
										<select name="megaCd" id="megaCd" style="width: 150px;">
											<option value="">::: 시도</option>
										</select> 
										<select name="ctyCd" id="ctyCd" style="width: 150px;">
											<option value="">::: 시군구</option>
										</select>
									</td>
								</tr>
								<tr>
									<th scope="row">* 아이디</th>
									<td colspan="5">
										<input type="text" name="userId" id="userId" value="" /> 
										<span id="refUserId" style="color: green; vertical-align: middle;"></span>
										<p id="dupUserId" style="color: red; margin: 6px 0 0 0;"></p>
									</td>
								</tr>
								<tr>
									<th scope="row">* 비밀번호</th>
									<td colspan="5">
										<input type="button" id="btnPassword" value="비밀번호 초기화" style="background: rgb(21, 89, 144); color:white;"/>
										<span id="initPassword" style="color: red; margin: 6px 0 0 0;"></span> 
									</td>
								</tr>
								<tr>
									<th scope="row">기관 슬로건</th>
									<td colspan="5">
										<input type="text" name="regionTxt" id="regionTxt" class="inp_full" value="" />
									</td>
								</tr>
								<tr>
									<th scope="row">메인 이미지</th>
									<td colspan="2">
										<p>										
											<input type="file" name="imgFile1" id="imgFile1"  accept="image/*" />
											<input type="hidden" name="pastFile1" id="pastFile1"  />
										</p>
										<p>
											<em id="pImage1">
												* 가로 1921px * 세로 933px 파일을 선택해주세요.
											</em>
											<input type="button" id="btnDelBg" class="delImgBtn" value="삭제" image-type="bg"/>
										</p>
									</td>
									<th scope="row">슬로건 이미지</th>
									<td colspan="2">
										<p>		
											<input type="file" name="imgFile2" id="imgFile2"  accept="image/*" />
											<input type="hidden" name="pastFile2" id="pastFile2"  />
										</p>
										<p>
											<em id="pImage2">
												* 가로 676px * 세로 246px 파일을 선택해주세요.
											</em>
											<input type="button" id="btnDelSg" class="delImgBtn" value="삭제"  image-type="sg"/>
										</p>
									</td>
								</tr>
								<tr>
									<th scope="row">* 담당자명</th>
									<td><input type="text" name="mngNm" id="mngNm" value="" /></td>
									<th scope="row">담당자 직함</th>
									<td><input type="text" name="mngPosition" id="mngPosition" value="" /></td>
									<th scope="row">담당자 부서</th>
									<td><input type="text" name="mngDept" id="mngDept" value="" /></td>
								</tr>
								<tr>
									<th scope="row">* 담당자 연락처(Mobile)</th>
									<td colspan="2"><input type="text" name="mngMobile" id="mngMobile" value="" class="inp_full" maxlength="14" /></td>
									<th scope="row">담당자 연락처(Tel)</th>
									<td colspan="2"><input type="text" name="mngTel" id="mngTel" value="" class="inp_full" maxlength="14" /></td>
								</tr>
								<tr>
									<th scope="row">* 이메일</th>
									<td colspan="5"><input type="text" name="mngEmail" id="mngEmail" value="" /></td>
								</tr>
								<tr>
									<th scope="row">비고</th>
									<td colspan="5"><textarea id="memo" name="memo" wrap="PHYSICAL" class="memoText"></textarea></td>
								</tr>
							</table>
						</div>
					</form>
						
					<!-- brd_btm -->
					<div class="brd_btn brd_btm">
						<div class="group_cnt">
							<ul>
								<li><a href="###" id="btn_org_save" class="btn_confirm">수정</a></li>
								<li><a href="###" id="btn_org_init" class="btn_cancel">초기화</a></li>
							</ul>
						</div>
					</div>
					<!-- //brd_btm -->

					<div class="brd_wrap">
						<div class="article_top">
							<h4 class="tit_caption">계약 현황</h4>
							<!-- brd_top -->
							<div class="brd_btn">
								<div class="group_rgt">
									<ul>
										<li><a href="#none" id="btn_contract_add" class="btn_confirm">추가</a></li>
									</ul>
								</div>
							</div>
							<!-- //brd_top -->
						</div>
						<div class="brd_scroll">
							<table class="brd_list">
								<colgroup>
									<col width="" />
								</colgroup>
								<thead>
									<tr>
										<th scope="col">계약 코드</th>
										<th scope="col">서비스 유형</th>
										<th scope="col">사용 시작일</th>
										<th scope="col">사용 종료일</th>
										<th scope="col">등록일</th>
										<th scope="col">계약담당자<br />(회사/담당자)</th>
										<th scope="col">계약금액<br />(원)</th>
										<th scope="col">버튼</th>
									</tr>
								</thead>
								<tbody id="contractListTbody"></tbody>
							</table>
						</div>
						
						<div class="article_top">
							<h4 class="tit_caption">서비스 사용통계</h4>
						</div>
						<div class="brd_scroll">
							<table class="brd_list">
								<colgroup>
									<col width="" />
								</colgroup>
								<thead>
									<tr>
										<th scope="col" rowspan="2">계약 코드</th>
										<th scope="col" rowspan="2">서비스 유형</th>
										<th scope="col" rowspan="2">사용 시작일</th>
										<th scope="col" rowspan="2">사용 종료일</th>
										<th scope="col" rowspan="2">접속건수</th>
										<th scope="col" colspan="6">서비스 이용건수</th>
									</tr>
									<tr>
										<th scope="col">경제24시</th>
										<th scope="col">경제트렌드</th>
										<th scope="col">이벤트효과</th>
									</tr>
								</thead>
								<tbody id="orgSvcStatsTbody"></tbody>
							</table>
						</div>

						<!-- brd_btm -->
						<div class="brd_btn brd_btm">
							<div class="group_cnt">
								<ul>
									<li><a href="/onmap/admin/org_list.do" class="btn_cancel">목록</a></li>
								</ul>
							</div>
						</div>
						<!-- //brd_btm -->
					</div>
				</div>
				<!-- //본문 ==================================================================================================== -->
			</div>
			<!-- //contents -->
		</div>
		<!-- container -->
	</div>

	<div id="imgViewPop" style="background: white; display: none;">
		<!-- header -->
		<div id="popHeader">
			<h1 class="pop_tit">첨부 이미지</h1>
			<a href="#" id="btnViewCancl" class="btn_close">닫기</a>
		</div>
		<!-- //header -->

		<div id="popContents">
			<div class="brd_wrap">
				<table class="brd_write">
					<tr>
						<td><c:if test="${!empty publicInfo.image_key }">
								<img alt=""
									src="/onmap/admin/public_view.do?imageKey=${publicInfo.image_key }"
									style="width: 768px; height: 256px;">
							</c:if></td>
					</tr>
				</table>
			</div>
		</div>
	</div>

	<div>
		<form name="paramForm" id="paramForm" method="post" action=""></form>
	</div>
</body>
</html>