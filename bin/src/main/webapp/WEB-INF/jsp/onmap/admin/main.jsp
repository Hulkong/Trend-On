<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authorize access="isAuthenticated()">
<script type="text/javascript">
	location.href = "/onmap/admin/org_list.do";
</script>
</sec:authorize>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>Safe-ON 관리자</title>
 		<link rel="shortcut icon" href="/images/favicon.ico">
 		<link rel="stylesheet" type="text/css" href="/css/reset.css" />
 		<link rel="stylesheet" type="text/css" href="/css/admin.css" />
 		<script type="text/javascript" src="/js/jquery/jquery-1.11.2.min.js"></script>
 		<style type="text/css">
	 		 html, body{width:100%;height:100%;}
			.adminWrap {
			  width:100%;
			  height:100%;
			  background-color: #ff6f15;
			  color:#564b47;  
			}
			.content { 	
			  position:absolute;
			  height:450px; 
			  width:400px;
			  margin:-225px 0px 0px -200px;
			  top: 50%; 
			  left: 50%;
			  text-align: left;
			  padding: 0px;
			  background-color: #f5f5f5;
			  overflow: auto;
			  padding:15px;
			   box-shadow: 5px 5px 3px #333;
			}
			.content p {text-align:center;padding:20px;}
			.content p span {float:left;font-size:14px;}
			.content p strong{font-size:22px; font-weight:bold;}
			input.inp_full {width:100%;height:40px;}
			.btn {width:100%; height:40px;}
			.btn a{ width:100%;height:100%; background-color:#ff6f15;color:#fff;font-size:20px;padding:10px 150px;}
		</style>
 		<script type="text/javascript">
			$(document).ready(function(){
				// 로그인 실행
				$("#btnUserLogin").click(function(){
					 // validation check
					 if($("#userId").val() == ""){
						 alert("아이디를 입력해주세요.");
						 $("#userId").focus();
						 return;
					 }
					 if($("#password").val() == ""){
						 alert("비밀번호를 입력해주세요.");
						 $("#password").focus();
						 return;
					 }
					 // 사용자 id 쿠키
					 if($("#saved_id").is(":checked")) {
							$("#saved_memId").val($("#userId").val());
					 }
					 
					 // 로그인
					 $("#userLoginForm").attr("action","/onmap/login/loginProc.do");
					 $("#userLoginForm").submit();
				});
				
			});
			
			var cName = "saved_memId=";
			var cookieData = document.cookie;
			var start = cookieData.indexOf(cName);
			var cValue = '';
			if(start != -1){
			     start += cName.length;
			     var end = cookieData.indexOf(';', start);
			     if(end == -1)end = cookieData.length;
			     cValue = cookieData.substring(start, end);
			}
			cValue = cValue.replace(/\"/g,"");
			
			if(cValue != "" && null != cValue) {
				$("#userId").val(cValue);
				$("#saved_id").prop("checked", true);
			}
			
			function onKeyDown(focusId){
			    if(event.keyCode == 13){
			    	if(focusId){
			    		$("#"+focusId).focus();
			    	}else{    		
			    		$("#btnUserLogin").click();
			    	}
			    }
			}
			</script>
 	</head>
 	<body>
 		<div class="adminWrap">
			<div class="content">
				<form id="userLoginForm"  method="post" >
					<input type="hidden" name="userType" value="admin" />
					<input type="hidden" name="saved_memId" id="saved_memId" value="" />
					<p><img src="/images/common/logo.png" alt="Trend-ON"><strong> 관리자</strong></p>
					<p>
						<span>Username or Email Address</span>
						<input type="text" name="userId" id="userId" class="inp_full" onkeydown="onKeyDown('password')"/>
					</p>
					<p>
						<span>Password</span>
						<input type="password" name="password" id="password" class="inp_full"  onkeydown="onKeyDown()"/>
					</p>
					<p></p>
					<p>
						<span><input type="checkbox" id="saved_id" name="saved_id" /> Remember Me</span>
					</p>
					<p>
						<span class="btn"><a href="#none" id="btnUserLogin" class="btn_confirm">Log In</a></span>
					</p>
				</form>
			</div>
 		</div>
 	</body>
 </html>