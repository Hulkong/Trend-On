<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>

<script type="text/javascript" src='<c:url value="/js/jquery/jquery-1.11.2.min.js"/>'></script>

<script type="text/javascript">
$(document).ready(function() {

	// 시군구 조회 ajax
	$(".megaCd").change(function() {
		var megaCd = $(this).val();
		var obj = $(this).parents("td").contents(".ctyCd");

		obj.empty();
		obj.append("<option value=''>::: 시군구</option>");

		$.ajax({
			url:'/common/area_select_option.json',
			type:"POST",
			data:{
				"rgnClss":"H3",
				"megaCd":megaCd
			},
			async: false,
			success: function(data){
 				for(var i = 0; i < data.length; i++) {
					var dataMap = data[i];
					obj.append("<option value=" + dataMap.id + ">" + dataMap.nm + "</option>");
				}

			}
		});
	});

	//사용자 아이디
	$("#btnUserId").click(function() {
		var userNm = $("#searchIdTb #userNm").val();
		var megaCd = $("#searchIdTb #megaCd").val();
		var ctyCd = $("#searchIdTb #ctyCd").val();

		getMberInfo( "id", "", userNm, megaCd, ctyCd );
	});

	$("#btnPw").click(function() {
		var userId = $("#searchPwTb #userId").val();
		var userNm = $("#searchPwTb #userNm").val();
		var megaCd = $("#searchPwTb #megaCd").val();
		var ctyCd = $("#searchPwTb #ctyCd").val();

		getMberInfo( "pw", userId, userNm, megaCd, ctyCd );
	});
});

function getMberInfo( type, userId, userNm, megaCd, ctyCd ) {

	$.ajax({
		url:'/onmap/public/getmber_info.json',
		type:"POST",
		data:{ "type": type
			 , "userId": userId
			 , "userNm": userNm
			 , "megaCd": megaCd
			 , "ctyCd": ctyCd
		},
		async: false,
		success: function(data){
			if(null != data.userId) {
				if("id" == type) {
					alert("고객님의 아이디는 '" + data.userId + "' 입니다.");
				} else {
					alert("고객님의 아이디는 '" + data.userId + "'로 임시 비밀번호가 발송 되었습니다.");
				}
			} else {
				alert("입력하신 정보에 해당하는 고객정보가 없습니다.");
			}

		},
		error: function(e){
			alert("에러가 발생했습니다. 관리자에게 문의 하세요");
		}
	});

}

</script>


</head>
<body>
	<div>
		<div>
			<h3><span>아이디 찾기</span></h3>
		</div>
		<div>
			<form action="">
				<table id="searchIdTb" border="1">
					<caption></caption>
					<tr>
						<th>사용자 이름</th>
						<td>
							<input type="text" name="userNm" id="userNm" />
						</td>
					</tr>
					<tr>
						<th>관할 시군구</th>
						<td>
							<select name="megaCd" id="megaCd" class="megaCd" style="width: 150px;">
									<option value="">::: 시도</option>
	<c:forEach var="dataList" items="${dataList }" varStatus="status">
								<option value="${dataList.id }">${dataList.nm }</option>
	</c:forEach>
							</select>
							<select name="ctyCd" id="ctyCd" class="ctyCd" style="width: 150px;">
								<option value="">::: 시군구</option>
							</select>
						</td>
					</tr>
				</table>
			</form>
		</div>
		<div>
			<span id="btnUserId" style="cursor: pointer;">확인</span>
			<span style="cursor: pointer;">취소</span>
		</div>
	</div>
	<div style="padding-top: 50px;">
		<div>
			<h3><span>비밀번호 찾기</span></h3>
		</div>
		<div>
			<form action="">
				<table id="searchPwTb" border="1">
					<caption></caption>
					<tr>
						<th>사용자 아이디</th>
						<td>
							<input type="text" name="userId" id="userId" />
						</td>
					</tr>
					<tr>
						<th>사용자 이름</th>
						<td>
							<input type="text" name="userNm" id="userNm" />
						</td>
					</tr>
					<tr>
						<th>관할 시군구</th>
						<td>
							<select name="megaCd" id="megaCd" class="megaCd" style="width: 150px;">
								<option value="">::: 시도</option>
	<c:forEach var="dataList" items="${dataList }" varStatus="status">
								<option value="${dataList.id }">${dataList.nm }</option>
	</c:forEach>
							</select>
							<select name="ctyCd" id="ctyCd" class="ctyCd" style="width: 150px;">
								<option value="">::: 시군구</option>
							</select>
						</td>
					</tr>
				</table>
			</form>
		</div>
		<div>
			<span id="btnPw" style="cursor: pointer;">확인</span>
			<span style="cursor: pointer;">취소</span>
		</div>
	</div>
</body>
</html>