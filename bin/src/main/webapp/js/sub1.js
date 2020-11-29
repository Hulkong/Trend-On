/**
 * 서브 메인 함수정리
 * (2019.09.19) 
 */


/**
 * 배경 이미지 존재 유무 체크
 * @param imageSrc	이미지 url 
 * @param successFc	이미지 있을때 실행할 함수
 * @param falseFc	이미지 없을때 실행할 함수
 */
function chkImage(imageSrc,successFc, falseFc){
	$.ajax({
		url : imageSrc,
		type:'HEAD',
	    error: falseFc,
	    success: successFc
	});
	
}

/**
 * 서브 페이지에서 사용할 데이터 가져오기
 * @param ctyCd		기관 시군구 코드
 */
function getData(ctyCd){
	$.ajax({
		url : '/onmap/main/setTotalData.json',
		data : {
			ctyCd : ctyCd
		},
		type: 'POST',
		success : function(result){
			var txtHtml ="";
			
			if(result != null && result !== undefined){
				var toMonth;
				
				// 일등행정도 명 넣기
				if(result.admiOne){
					$('#oneAdmi').text(result.admiOne.nm);
				}
				// 일등행정도 명 넣기
				if(result.admiRate){
					var rateTxt = "% 증가";
					if(Number(result.admiRate) < 0)rateTxt = "% 감소";
					$('#admiRate').text(Math.abs(result.admiRate) + rateTxt);
				}
				// 총거래금액 데이터 넣기
				if(result.totalAmt){
					counting("#tAmt", result.totalAmt.this_amt);
					
					var rateTxt = "% 증가";
					if(Number(result.totalAmt.amt_rate) < 0) rateTxt = "% 감소";
					$('#tRate').text(Math.abs(result.totalAmt.amt_rate) + rateTxt);
				}
				// 누적데이터(2년)
				if(result.ctyTot){
					counting('#ctyTot', result.ctyTot)
//					$('#ctyTot').text(numberWithCommas(result.ctyTot));
				}
				// 누적데이터(최신)
				if(result.monTot){
					$('#monTot').text(numberWithCommas(result.monTot));
				}
			}
			
		}
	})
}
			
/**
 * 슬로건 이미지 없을때 text 적용
 * @param obj 	이미지 객체
 */ 
function changeToText(obj, nm){
	console.log(nm);
	$(obj).parent().html("<strong>"+nm+"</strong>");
}


/**
 * number에 comma 찍기
 * @param x    숫자
 * @returns
 */
function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}


/**
 * 카운팅 이벤트 
 * @param divId 카운트할 위치
 * @param value 값
 */
function counting(divId, value){
	$({ Counter: 0 }).animate({
		  Counter: value
	}, {
	  duration: 1000,
	  easing: 'swing',
	  step: function(stepValue) {
	    $(divId).text(numberWithCommas(Math.ceil(stepValue)));
	  }
	})
}