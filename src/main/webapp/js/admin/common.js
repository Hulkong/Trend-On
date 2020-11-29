/**
 *
 */

//달력 ================================================================================
$(function(){
	$(".pop_calendar").datepicker({
		showOn: "button" ,
		showButtonPanel: true ,
		buttonImage : "../../images/board/calendar_btn_open.gif" ,
		buttonImageOnly : true ,
		buttonText: "달력",
		closeText : "닫기" ,
		currentText : "오늘" ,
		dateFormat : "yymmdd" ,
		dayNamesMin: ["월","화","수","목","금","토","일"],
		firstDay : 0 ,
		gotoCurrent : true ,
		monthNames : [ "1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월" ] ,
		nextText : "차월" ,
		numberOfMonths : 1 ,
		prevText : "전월" ,
		selectOtherMonths : true ,
		showOtherMonths : true ,
		stepMonths : 1 ,
		showMonthAfterYear: true ,
		yearSuffix : "년"
	});
});

function numberCheck2(event, type){
    event = event || window.event;
    var keyID = (event.which) ? event.which : event.keyCode;

    if(type == "A"){
        if((keyID >= 48 && keyID <= 57) || keyID == 8 || keyID == 9 || keyID == 46 || (keyID >= 37 && keyID <= 40) || (keyID >= 96 && keyID <= 105 || keyID == 18) ){
            return true;
        }else{
            return false;
        }
    }else{
        if((keyID >= 48 && keyID <= 57) || keyID == 8 || keyID == 9 || keyID == 46 || keyID == 189 || (keyID >= 37 && keyID <= 40) || (keyID >= 96 && keyID <= 105) || keyID == 109 || keyID == 18){
            return true;
        }else{
            return false;
        }
    }

}


function getStringDt(dt, type) {
	
    var year = dt.getYear();
    var month = dt.getMonth() + 1;
	var day = dt.getDate();
	
    if(year < 2000){
        year += 1900;
    }
    
    if(type === 'month') {
	    	if(month < 10 ) {
	    		month = "0" + month;
	    	}
	    	
	    	return year + "" + month;
    }
    
    if(type === 'day') {
    	
	    	if(month < 10 ){
	    		month = "0" + month;
	    	}
    	
	    	if(day < 10){
	    		day = "0" + day;
	    	}
	    	
	    	return year + "" + month + "" + day;
    }
    
    return year += "";
}

//?일전 설정
function setDate(stObj, edObj, val){
    var dt = new Date();
    var v = new Date(Date.parse(dt) - 1*1000*60*60*24);
    $("#"+stObj).val(getStringDt(dt, 'day'));
    $("#"+edObj).val(getStringDt(v, 'day'));
}

//?개월 설정
function setMonth(stObj, edObj, val, sDate) {
	var dt = new Date();
	var v = new Date();
	if(sDate != undefined){
		v.setFullYear(sDate.substr(0,4), sDate.substr(4,2), sDate.substr(6,2));
		v.setMonth(v.getMonth() + val -1);
		$("#"+edObj).val(getStringDt(v, 'day'));
	}else{		
		
		v.setMonth(v.getMonth() + val);
		
		$("#"+stObj).val(getStringDt(dt, 'day'));
		$("#"+edObj).val(getStringDt(v, 'day'));
	}
}

/**
 * 파일다운로드
 * @param orgFileName   파일 한글명
 * @param realFileName  실제 파일명
 * @param delYn			다운로드 후 파일 삭제 여부
 */
function fileDown(orgFileName, realFileName, delYn, filePath) {

	$("#direct-download-form").remove();
	$("body").append("<form id=\"direct-download-form\" name=\"direct-download-form\" method=\"post\" style=\"display:none;\"></form>");
	var form = $("#direct-download-form");

	form.append("<input type=\"hidden\" name=\"filePath\" id=\"filePath\">");
	form.append("<input type=\"hidden\" name=\"orgFileName\" id=\"orgFileName\">");
	form.append("<input type=\"hidden\" name=\"fileName\" id=\"fileName\">");
	form.append("<input type=\"hidden\" name=\"delYn\" id=\"delYn\">");

	$('#orgFileName').val(orgFileName);
	$('#fileName').val(realFileName);
	if(filePath) $('#filePath').val(filePath);
	$('#delYn').val(delYn);

	form.attr("action", "/common/fileDirectDownload.do");

	form.submit();
}

/**
 * @description url querystring에서 해당 키에대한 값을 가져오는 함수 
 * @param name: 키값, String
 */
function getUrlParameter(name) {
    name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]');
    var regex = new RegExp('[\\?&]' + name + '=([^&#]*)');
    var results = regex.exec(location.search);
    return results === null ? '' : decodeURIComponent(results[1].replace(/\+/g, ' '));
}

/**
 * @description 화폐단위로 변경
 * @param won: 화폐, Number
 */
function numberWithCommas(won) {
    return won.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

/**
 * @description 날짜포맷 변경 (yyyy-mm-dd)
 * @param date 날짜
 */
function formatDate(date) {
	var d = new Date(date), 
		month = '' + (d.getMonth() + 1), 
		day = '' + d.getDate(), 
		year = d.getFullYear();
	
	if (month.length < 2) {
		month = '0' + month;
	}
	
	if (day.length < 2) {
		day = '0' + day;
	}
	
	return [ year, month, day ].join('-');
}

