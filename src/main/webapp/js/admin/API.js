/**
 * @description 서비스 지역 가져오는 함수 
 * @param params: 쿼리 파라미터, Object, [rgnClss 행정단위] 
 * @param callback: 콜백함수, Function 
 */
function getAreaSelectOption(params, callback) {
	
	// 파라미터가 비어있으면 리턴 
	if($.isEmptyObject(params)) {
		return;
	}
	
	$.ajax({
		url:'/onmap/admin/getAreaSelectOption.json',
		type: "POST",
		data: params,
		async: true,
		success: function(data) {
	
			if(callback && typeof callback === 'function') {
				callback(data);
			}
		}
	});
}

/**
 * @description 서비스유형 가져오는 함수 
 * @param params: 쿼리 파라미터, Object, [code 공통코드명]
 * @param callback: 콜백함수, Function  
 */
function getCommonCodeList(params, callback) {
	
	// 파라미터가 비어있으면 리턴 
	if($.isEmptyObject(params)) {
		return;
	}
	
	$.ajax({
		url:'/onmap/admin/getCommonCodeList.json',
		type: "POST",
		data: params,
		async: true,
		success: function(data) {
			
			if(data.length < 1) {
				return;
			}
			
			if(callback && typeof callback === 'function') {
				callback(data);
			}
		}
	});
}

/**
 * @description 기관현황 리스트 가져오는 함수
 * @param params: 쿼리 파라미터, Object, [rgnClss 행정단위] 
 * @param callback: 콜백함수, Function 
 */
function getOrgList(params, callback) {
	
	$.ajax({
		url:'/onmap/admin/getOrgList.json',
		type: "POST",
		data: params,
		async: true,
		success: function(data) {
			
			if(callback && typeof callback === 'function') {
				callback(data);
			}
		}
	});
}

/**
 * @description 기관현황 전체건수 가져오는 함수
 * @param callback: 콜백함수, Function
 */
function getTotOrgList(params, callback) {
	$.ajax({
		url:'/onmap/admin/getTotOrgList.json',
		type: "POST",
		data: params,
		async: true,
		success: function(data) {
			
			if(data.length < 1) {
				return;
			}
			
			if(callback && typeof callback === 'function') {
				callback(data);
			}
		}
	});
}

/**
 * @description 기관 수정 데이터 가져오는 함수
 * @param params: 쿼리 파라미터, Object, [orgId 기관아이디, contractId 계약아이디] 
 * @param callback: 콜백함수, Function 
 */
function getOrg(params, callback) {
	
	// 파라미터가 비어있으면 리턴 
	if($.isEmptyObject(params)) {
		return;
	}
	
	$.ajax({
		url:'/onmap/admin/getOrg.json',
		type: "POST",
		data: params,
		async: true,
		success: function(data) {
	
			if(callback && typeof callback === 'function') {
				callback(data);
			}
		}
	});
}

/**
 * @description 기관 상세보기 - 기관이미지 가져오기
 * @param params: 쿼리 파라미터, Object, [orgId 기관아이디] 
 * @param callback: 콜백함수, Function 
 */
function getOrgImages(params, callback) {
	
	// 파라미터가 비어있으면 리턴 
	if($.isEmptyObject(params)) {
		return;
	}
	
	$.ajax({
		url:'/onmap/admin/getOrgImages.json',
		type: "POST",
		data: params,
		async: true,
		success: function(data) {
			
			if(callback && typeof callback === 'function') {
				callback(data);
			}
		}
	});
}

/**
 * @description 해당 기관에 대한 계약리스트 가져오는 함수
 * @param params: 쿼리 파라미터, Object, [rgnClss 행정단위] 
 * @param callback: 콜백함수, Function 
 */
function getContractList(params, callback) {
	
	$.ajax({
		url:'/onmap/admin/getContractList.json',
		type: "POST",
		data: params,
		async: true,
		success: function(data) {
			
			if(callback && typeof callback === 'function') {
				callback(data);
			}
		}
	});
}

/**
 * @description 해당 계약 데이터 가져오는 함수 
 * @param params: 쿼리 파라미터, Object, [orgId 기관코드, contractId 계약코드]
 * @param callback: 콜백함수, Function  
 */
function getContract(params, callback) {
	
	// 파라미터가 비어있으면 리턴 
	if($.isEmptyObject(params)) {
		return;
	}
	
	$.ajax({
		url:'/onmap/admin/getContract.json',
		type: "POST",
		data: params,
		async: true,
		success: function(data) {
			
			if(data.length < 1) {
				return;
			}
			
			if(callback && typeof callback === 'function') {
				callback(data);
			}
		}
	});
} 

/**
 * @description 메뉴추가 리스트 가져오는 함수 
 * @param params: 쿼리 파라미터, Object, [orgId 기관코드]
 * @param callback: 콜백함수, Function  
 */
function getMenuAddList(params, callback) {
	
	// 파라미터가 비어있으면 리턴 
	if($.isEmptyObject(params)) {
		return;
	}
	
	$.ajax({
		url:'/onmap/admin/getMenuAddList.json',
		type: "POST",
		data: params,
		async: true,
		success: function(data) {
			if(callback && typeof callback === 'function') {
				callback(data);
			}
		}
	});
} 

/**
 * @description 메뉴추가 최신시퀀스 가져오는 함수 
 * @param params: 쿼리 파라미터, Object
 * @param callback: 콜백함수, Function  
 */
function getMenuAddMaxSeq(params, callback) {
	
	$.ajax({
		url : "/onmap/admin/getMenuAddMaxSeq.json",
		async: true,   // 비동기
		success : function(data) {
			if(callback && typeof callback === 'function') {
				callback(data);
			}
		}, 
		error: function(request, status, error) {
			console.log("code: " + request['status'] + "\n" + "message: " + request['responseText'] + "\n" + "error: " + error);
		}
	});
} 

/**
 * @description 기관 정보 수정 서비스 사용통계 가져오는 함수 
 * @param params: 쿼리 파라미터, Object, [orgId 기관코드]
 * @param callback: 콜백함수, Function  
 */
function getOrgSvcStats(params, callback) {
	
	// 파라미터가 비어있으면 리턴 
	if($.isEmptyObject(params)) {
		return;
	}
	
	$.ajax({
		url:'/onmap/admin/getOrgSvcStats.json',
		type: "POST",
		data: params,
		async: true,
		success: function(data) {
			
			if(callback && typeof callback === 'function') {
				callback(data);
			}
		}
	});
} 

/**
 * @description 기관 정보 수정 > 이미지 삭제 
 * @param params: 쿼리 파라미터, Object, [fileKey 이미지 키]
 * @param callback: 콜백함수, Function  
 */
function delOrgImage(params, callback) {
	
	// 파라미터가 비어있으면 리턴 
	if($.isEmptyObject(params)) {
		return;
	}
	
	$.ajax({
		url:'/onmap/admin/delOrgImage.json',
		type: "POST",
		data: params,
		async: true,
		success: function(data) {
			
			if(callback && typeof callback === 'function') {
				callback(data);
			}
		}
	});
} 

/**
 * @description 사용신청현황 리스트 가져오는 함수
 * @param params: 쿼리 파라미터, Object, [rgnClss 행정단위] 
 * @param callback: 콜백함수, Function 
 */
function getUseApplyList(params, callback) {
	
	$.ajax({
		url:'/onmap/admin/getUseApplyList.json',
		type: "POST",
		data: params,
		async: true,
		success: function(data) {
			
			if(callback && typeof callback === 'function') {
				callback(data);
			}
		}
	});
}
 
/**
 * @description 사용신청현황 리스트 가져오는 함수
 * @param params: 쿼리 파라미터, Object, [] 
 * @param callback: 콜백함수, Function 
 */
function getTotUseApplyList(params, callback) {
	
	$.ajax({
		url:'/onmap/admin/getTotUseApplyList.json',
		type: "POST",
		data: params,
		async: true,
		success: function(data) {
			
			if(callback && typeof callback === 'function') {
				callback(data);
			}
		}
	});
}

/**
 * @description 사용신청 수정 데이터 가져오는 함수
 * @param params: 쿼리 파라미터, Object, [] 
 * @param callback: 콜백함수, Function 
 */
function getUseApply(params, callback) {
	
	$.ajax({
		url:'/onmap/admin/getUseApply.json',
		type: "POST",
		data: params,
		async: true,
		success: function(data) {
			
			if(callback && typeof callback === 'function') {
				callback(data);
			}
		}
	});
}

/**
 * @description 사용신청 현황 엑셀파일 만드는 함수
 * @param params: 쿼리 파라미터, Object, [] 
 * @param callback: 콜백함수, Function 
 */
function makeExcelUseApply(params, callback) {
	
	$.ajax({
		url:'/onmap/admin/makeExcelUseApply.json',
		type: "POST",
		data: params,
		async: true,
		success: function(data) {
			
			if(callback && typeof callback === 'function') {
				callback(data);
			}
		}
	});
}

/**
 * @description 서비스 사용통계 총건수 가져오는 함수
 * @param params: 쿼리 파라미터, Object, [] 
 * @param callback: 콜백함수, Function 
 */
function getTotSvcStatsList(params, callback) {
	
	$.ajax({
		url:'/onmap/admin/getTotSvcStatsList.json',
		type: "POST",
		data: params,
		async: true,
		success: function(data) {
			
			if(callback && typeof callback === 'function') {
				callback(data);
			}
		}
	});
}

/**
 * @description 서비스 사용통계 데이터 가져오는 함수
 * @param params: 쿼리 파라미터, Object, [] 
 * @param callback: 콜백함수, Function 
 */
function getSvcStatsList(params, callback) {
	
	$.ajax({
		url:'/onmap/admin/getSvcStatsList.json',
		type: "POST",
		data: params,
		async: true,
		success: function(data) {
			
			if(callback && typeof callback === 'function') {
				callback(data);
			}
		}
	});
}

/**
 * @description 서비스 사용통계 엑셀파일 만드는 함수
 * @param params: 쿼리 파라미터, Object, [] 
 * @param callback: 콜백함수, Function 
 */
function makeExcelSvcStats(params, callback) {
	
	$.ajax({
		url:'/onmap/admin/makeExcelSvcStats.json',
		type: "POST",
		data: params,
		async: true,
		success: function(data) {
			
			if(callback && typeof callback === 'function') {
				callback(data);
			}
		}
	});
}

////////////////////////////////////////////////////////////////////////////////////
//API 현황 페이지 시작
/**
 * @description API 목록 전체 건수 조회하는 함수
 * @param params: 쿼리 파라미터, Object, [rgnClss 행정단위] 
 * @param callback: 콜백함수, Function 
 */
function getTotApiList(params, callback) {
	
	$.ajax({
		url:'/onmap/admin/getTotApiList.json',
		type: "POST",
		data: params,
		async: true,
		success: function(data) {
			
			if(callback && typeof callback === 'function') {
				callback(data);
			}
		}
	});
}
 
/**
 * @description API 목록 조회하는 함수
 * @param params: 쿼리 파라미터, Object, [] 
 * @param callback: 콜백함수, Function 
 */
function getApiList(params, callback) {
	
	$.ajax({
		url:'/onmap/admin/getApiList.json',
		type: "POST",
		data: params,
		async: true,
		success: function(data) {
			
			if(callback && typeof callback === 'function') {
				callback(data);
			}
		}
	});
}
//API 현황 페이지 끝
////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////
//API 수정 페이지 시작
/**
 * @description API 기본키 조회하는 함수 
 * @param params: 쿼리 파라미터, Object, [orgId 기관코드]
 * @param callback: 콜백함수, Function  
 */
function getApiNo(params, callback) {
	
	// 파라미터가 비어있으면 리턴 
	if($.isEmptyObject(params)) {
		return;
	}
	
	$.ajax({
		url:'/onmap/admin/getApiNo.json',
		type: "POST",
		data: params,
		async: true,
		success: function(data) {
			
			if(callback && typeof callback === 'function') {
				callback(data);
			}
		}
	});
} 

/**
 * @description API 정보 조회하는 함수 
 * @param params: 쿼리 파라미터, Object, [orgId 기관코드]
 * @param callback: 콜백함수, Function  
 */
function getApiInfo(params, callback) {
	
	// 파라미터가 비어있으면 리턴 
	if($.isEmptyObject(params)) {
		return;
	}
	
	$.ajax({
		url:'/onmap/admin/getApiInfo.json',
		type: "POST",
		data: params,
		async: true,
		success: function(data) {
			
			if(callback && typeof callback === 'function') {
				callback(data);
			}
		}
	});
} 

/**
 * @description API 지역정보 조회하는 함수 
 * @param params: 쿼리 파라미터, Object, [orgId 기관코드]
 * @param callback: 콜백함수, Function  
 */
function getApiRegion(params, callback) {
	
	// 파라미터가 비어있으면 리턴 
	if($.isEmptyObject(params)) {
		return;
	}
	
	$.ajax({
		url:'/onmap/admin/getApiRegion.json',
		type: "POST",
		data: params,
		async: true,
		success: function(data) {
			
			if(callback && typeof callback === 'function') {
				callback(data);
			}
		}
	});
} 

/**
 * @description API 도메인 조회하는 함수 
 * @param params: 쿼리 파라미터, Object, [orgId 기관코드]
 * @param callback: 콜백함수, Function  
 */
function getApiDomain(params, callback) {
	
	// 파라미터가 비어있으면 리턴 
	if($.isEmptyObject(params)) {
		return;
	}
	
	$.ajax({
		url:'/onmap/admin/getApiDomain.json',
		type: "POST",
		data: params,
		async: true,
		success: function(data) {
			
			if(callback && typeof callback === 'function') {
				callback(data);
			}
		}
	});
} 
//API 수정 페이지 끝
////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////
// API 서비스 사용통계 페이지 시작
/**
 * @description API가 있는 기관리스트 조회하는 함수 
 * @param params: 쿼리 파라미터, Object, [orgId 기관코드]
 * @param callback: 콜백함수, Function  
 */
function getApiOrgNmList(params, callback) {
	
	$.ajax({
		url:'/onmap/admin/getApiOrgNmList.json',
		type: "POST",
		data: params,
		async: true,
		success: function(data) {
			
			if(callback && typeof callback === 'function') {
				callback(data);
			}
		}
	});
} 

/**
 * @description API 사용통계 총건수 조회하는 함수 
 * @param params: 쿼리 파라미터, Object, [orgId 기관코드]
 * @param callback: 콜백함수, Function  
 */
function getTotApiSvcStatsList(params, callback) {
	
	// 파라미터가 비어있으면 리턴 
	if($.isEmptyObject(params)) {
		return;
	}
	
	$.ajax({
		url:'/onmap/admin/getTotApiSvcStatsList.json',
		type: "POST",
		data: params,
		async: true,
		success: function(data) {
			
			if(callback && typeof callback === 'function') {
				callback(data);
			}
		}
	});
} 

/**
 * @description API 사용통계 조회하는 함수 
 * @param params: 쿼리 파라미터, Object, [orgId 기관코드]
 * @param callback: 콜백함수, Function  
 */
function getApiSvcStatsList(params, callback) {
	
	// 파라미터가 비어있으면 리턴 
	if($.isEmptyObject(params)) {
		return;
	}
	
	$.ajax({
		url:'/onmap/admin/getApiSvcStatsList.json',
		type: "POST",
		data: params,
		async: true,
		success: function(data) {
			
			if(callback && typeof callback === 'function') {
				callback(data);
			}
		}
	});
} 

/**
 * @description API 사용통계 엑셀다운로드 조회하는 함수 
 * @param params: 쿼리 파라미터, Object, [orgId 기관코드]
 * @param callback: 콜백함수, Function  
 */
function makeApiExcel(params, callback) {
	
	// 파라미터가 비어있으면 리턴 
	if($.isEmptyObject(params)) {
		return;
	}
	
	$.ajax({
		url:'/onmap/admin/makeApiExcel.json',
		type: "POST",
		data: params,
		async: true,
		success: function(data) {
			
			if(callback && typeof callback === 'function') {
				callback(data);
			}
		}
	});
} 
// API 서비스 사용통계 페이지 끝
////////////////////////////////////////////////////////////////////////////////////