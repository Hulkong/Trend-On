/**
 * @description 페이지리스트 DOM 생성하는 함수 
 * @param params: 쿼리 파라미터, Object, [data 전체건수 int, currPage 현재 활성화된 페이지번호 int] 
 * @param callback: 콜백함수, Function 
 */
function makePageDOM(params, callback) {

	var totCnt = params['totCnt'];       // 전체건수
	var currPage = params['currPage'];   // 현재 활성화된 페이지번호
	
	// 전체건수 없을시 0으로 초기화 
	if(!totCnt) {
		totCnt = 0;
	}
	
	// 활성화된 페이지번호 없을시 1로 초기화 
	if(!currPage) {
		currPage = 1;
	}
	
	var postsPerPage = 10;     							     // 한 페이지에 출력될 게시글 수 
	var pagesPerScreen = 10;								 // 한 화면에 출력될 페이지 수
	var repeat = Math.ceil(currPage / pagesPerScreen) - 1;   // 반복 횟수 
	var startPage = (pagesPerScreen * repeat) + 1 ; 		 // 화면에 표현될 처음 페이지 번호 
	var endPage = pagesPerScreen * (repeat + 1);			 // 화면에 표현될 마지막 페이지 번호 
	var totalPage = Math.ceil(totCnt / pagesPerScreen);  	 // 전체건수에 대한 전체페이지 수 
	
	// 반복횟수가 음수일 경우 0 대입  
	if(repeat < 0) {
		repeat = 0;
	}
	
	// 마지막 페이지번호가 전체 페이지 수 보다 클 경우 마지막페이지는 전체페이지 수  
	if(endPage > totalPage) {
		endPage = totalPage;
	}
	
	var html = '';
	html += '<span href="#" class="firs"></span>';
	html += '<span href="#" class="prev"></span>';
	html += '<span class="pg_lst">';
	
	for(var i = startPage; i < (endPage + 1); i++) {

		// 활성화 페이지 
		if(currPage === i) {
			html += '<span id="startPage" class="nextPage on">' + currPage + '</span>';
		} else {
			
			// 마지막 페이지 
			if(i === endPage) {
				html += '<span id="endPage" class="nextPage">' + i + '</span>';
			
			// 그 외의 경우
			} else {
				html += '<span class="nextPage">' + i + '</span>';
			}
		}
	}
	
	html += '</span>';
	html += '<span href="#" class="next"></span>';
	html += '<span href="#" class="last"></span>';
	
	$('.paginate').empty();
	$('.paginate').append(html);
	
	setPageListClick(totCnt, callback);   // 페이지리스트 클릭 이벤트 바인딩
}

/**
 * @description 페이지리스트 클릭 이벤트 바인딩 하는 함수  
 * @param totCnt 전체건수, int
 * @param callback: 콜백함수, Function 
 */
function setPageListClick(totCnt, callback) {
	
	// 페이지리스트 다음페이지(번호) 클릭 이벤트 
	$('.paginate .nextPage').click(function() {
		
		var nextPage = parseInt($(this).text());              // 클릭한 페이지번호  
		var endPage = parseInt($('#endPage').text());   // 현재 보여지고 있는 페이지리스트의 가장 마지막 페이지번호 

		// 현재 활성화 되어있는 페이지번호 해제 
		$('.paginate .nextPage').removeClass('on' );
		
		// 클릭한 페이지번호 활성화 
		$(this).addClass('on');
		
		// 클릭한 페이지가 현재 가장 마지막 페이지보다 클 경우 페이지리스트 DOM 새로 생성  
		if(nextPage > endPage) {
			makePageDOM({
				totCnt: totCnt, 
				currPage: nextPage
			}, callback);
		}
		
		if(callback && typeof callback === 'function') {
			callback({
				limit: 10,
				offset: (nextPage - 1) * 10
			});
		}
	});
	
	// 페이지리스트 다음페이지(화살표) 클릭 이벤트 
	$('.paginate .next').click(function() {
		var pagesPerScreen = 10;                                             // 한 화면에 출력될 페이지 수
		var currPage = parseInt($('.paginate .nextPage.on').text());   // 현재 활성화된 페이지 번호
		var nextPage = currPage + 1;                  					     // 다음페이지 번호 
		var endPage = parseInt($('#endPage').text());					 // 현재 보여지고 있는 페이지리스트의 가장 마지막 페이지번호
		var totalPage = Math.round(totCnt / pagesPerScreen);				 // 기관데이터 전체건수에 대한 전체 페이지수 
		var index = currPage % pagesPerScreen;								 // 적용되어야 할 페이지리스트의 인덱스 
		
		// 다음페이지번호가 전체 페이지 수보다 클 경우 하단로직 실행 안함 
		if(nextPage > totalPage) {
			return;
		}
		
		// 다음 페이지가 현재 가장 마지막 페이지보다 클 경우 페이지리스트 DOM 새로 생성  
		if(nextPage > endPage) {
			makePageDOM({
				totCnt: totCnt, 
				currPage: nextPage
			}, callback);
		
		// 다음 페이지가 현재 가장 마지막 페이지보다 작을 경우 해당 페이지 활성화 표시
		} else {
			$('.paginate .nextPage.on').removeClass('on');
			$('.paginate .nextPage').eq(index).addClass('on');
		}
		
		if(callback && typeof callback === 'function') {
			callback({
				limit: 10,
				offset: (nextPage - 1) * 10
			});
		}
	});
	
	// 마지막 페이지(화살표) 클릭 이벤트 
	$('.paginate .last').click(function() {
		var pagesPerScreen = 10;							   				 // 한 화면에 출력될 페이지 수
		var currPage = parseInt($('.paginate .nextPage.on').text());   // 현재 활성화된 페이지 번호
		var totalPage = Math.round(totCnt / pagesPerScreen);   				 // 기관데이터 전체건수에 대한 전체 페이지수  
		
		// 현재 활성화된 페이지번호가 전체 페이지수와 같을 겨우 하단로직 실행 안함 
		if(currPage === totalPage) {
			return;
		}
		
		// 페이지리스트 DOM 새로 생성
		makePageDOM({
			totCnt: totCnt, 
			currPage: totalPage
		}, callback);
		
		if(callback && typeof callback === 'function') {
			callback({
				limit: 10,
				offset: (totalPage - 1) * 10
			});
		}
	});
	
	// 페이지리스트 이전페이지(화살표) 클릭 이벤트 
	$('.paginate .prev').click(function() {
		var pagesPerScreen = 10;										     // 한 화면에 출력될 페이지 수
		var currPage = parseInt($('.paginate .nextPage.on').text());   // 현재 활성화된 페이지 번호
		var prevPage = currPage - 1;										 // 이전페이지 번호 
		var startPage = parseInt($('#startPage').text());				 // 현재 보여지고 있는 페이지리스트의 가장 처음 페이지번호
		var index = (prevPage % pagesPerScreen) - 1;						 // 적용되어야 할 페이지리스트의 인덱스
		
		// 이전페이지가 1보다 작을 경우 하단 로직 실행안함 
		if(prevPage < 1) {
			return;
		}
		
		// 이전페이지가 현재 처음 페이지번호보다 작을 경우 페이지리스트 DOM 새로 생성  
		if(prevPage < startPage) {
			makePageDOM({
				totCnt: totCnt, 
				currPage: prevPage
			}, callback);
			
		
		// 다음 페이지가 현재 가장 마지막 페이지보다 클 경우 해당 페이지 활성화 표시
		} else {
			$('.paginate .nextPage.on').removeClass('on');
			$('.paginate .nextPage').eq(index).addClass('on');	
		}
		
		if(callback && typeof callback === 'function') {
			callback({
				limit: 10,
				offset: (prevPage - 1) * 10
			});
		}
	});
	
	// 처음 페이지(화살표) 클릭 이벤트 
	$('.paginate .firs').click(function() {

		// 페이지리스트 DOM 새로 생성
		makePageDOM({
			totCnt: totCnt
		}, callback);
		
		if(callback && typeof callback === 'function') {
			callback({
				limit: 10
			});
		}
	});
}