<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
	<script type="text/javascript" src='https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js'></script>
	<script type="text/javascript">
	
	var fullUrl = location.protocol+'//'+location.hostname+( (location.port)  ? ":"+location.port : '' );
	var chart_config = {
			ctyCd : '11140',
			h3Cd : '11140',
			dataId : "rpt-trnd",
			startDate : "20160501",
			endDate : "20160701"
	};
	
	$(document).ready(function() {
		$("body").on('click', "button[id^=btn]", function(e) {
			var fileNm = $(this).attr("data");
			var type = $(":radio[name=type]:checked").val();
			
			
			$.ajax({
				type : "GET",
				dataType : 'json',
				url : fullUrl+"/onmap/public/ecnmy_trnd/pdf/data_root.json",
				data : {
					"dataId" : chart_config.dataId,
					"ctyCd": chart_config.ctyCd,
					"h3Cd": chart_config.h3Cd,
					"startDate":chart_config.startDate,
					"endDate":chart_config.endDate
				},
				success : function(json) {
					if(confirm(fileNm + "를 " + type + "로 여시겠습니까?")){
						window.open("/report/viewer.do?file=/report.pdf?fileNm%3D"+fileNm+"%26dataId%3Drpt-trnd%26ctyCd%3D"+chart_config.ctyCd+"%26h3Cd%3D"+chart_config.ctyCd+"%26startDate%3D"+chart_config.startDate+"%26endDate%3D"+chart_config.endDate+"");
					}
				},
				error : function(request,status,error){
					console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
				}
			});
			

		});	
	})
	</script>
</head>
<body>

	<input type="radio" name="type" value="pdf" checked="checked" id="pdf"><label for="pdf">pdf</label>
	<!-- 
	<input type="radio" name="type" value="ppt" id="ppt"><label for="ppt">PPT</label>
	<input type="radio" name="type" value="xls" id="xls"><label for="xls">xls</label>
	 -->
	<br/>
	<c:forEach items="${fileList}" var="fileNm">
		<button id="btn${fileNm}" data="${fileNm}">${fileNm} 출력</button>
		<%-- <a id="btn${fileNm}" data="${fileNm}">${fileNm} 출력</a><br/> --%>
	</c:forEach>
</body>
</html>