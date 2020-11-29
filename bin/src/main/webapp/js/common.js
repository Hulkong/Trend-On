(function($){
	$.fn.select=function(){
		$(this).find(".tit").text($(this).find("option:selected").text());
		$(this).find("select").on("change", function(){
			$(this).siblings(".tit").text($(this).find("option:selected").text());
		});
	};
	$(function(){
		$(".select_box").each(function(index){
			$(this).select();
		});
	});
})(jQuery);

$(function(){
	$.fn.motion = function(o){
		o = $.extend({
			width : 10,
			height: 10,
			speed : 1000,
			delay : 1000,
			minWidth : 980
		}, o || {});

		return this.each(function(j){
			$(this).attr("idx", j);
			var n = $(this).attr("idx");

			num = 0;
			maxnum = $(this).find("li").length;

			var e = $(this);
			var n_h = e.find('ul.page').height();
			var pause = false;
			var no = 1, ext;
			var len = e.find('ul.list li').length-1;
			/*
			var replace_img = function(o, s, ext){
				if(s) o.attr('src', o.attr('src').replace('off.'+ext, 'on.'+ext));
				else o.attr('src', o.attr('src').replace('on.'+ext, 'off.'+ext));
			}
			
			var find_ext = function(imgE){
				var xt = imgE.find('img').attr('src').lastIndexOf('.') + 1;
				xt = imgE.find('img').attr('src').substr(xt);
				return xt;
			}
			*/
			e.css({
				position : 'relative',
				overflow : 'hidden',
				width : o.width,
				minWidth : o.minWidth
				
			}).find('ul.list').css({
				position : 'relative',
				'z-index' : 0,
				height : o.height
			}).find('li').css({
				position : 'absolute'
			});
			e.find('ul.list > li:not(:eq(0))').hide();
			e.find('ul.page').css({
				'z-index' : 1,
				'text-align' : 'center',
				'margin-top' : -(n_h)
			}).find('span').css('cursor', 'pointer');
			e.find('ul.list li:eq(0)').addClass('on');
			e.find('ul.page li:eq(0)').addClass('on');
			e.find('ul.page li:eq(0)').animate({"width" : "28px"});

			var ani = function(num, m){
				if(!e.find('ul.page li:eq(' + num + ')').hasClass('on')){
					if(e.find('ul.page li.on').length > 0){
						e.find('ul.page li.on').animate({"width" : "14px"});
						e.find('ul.page li.on').removeClass('on');
					}
					e.find('ul.page li:eq(' + num + ')').addClass('on');
					e.find('ul.page li:eq(' + num + ')').animate({"width" : "28px"});
					if(m){
						e.find('ul.list li').fadeOut('fast');
						e.find('ul.list li').removeClass('on');
						e.find('ul.list li:eq(' + num + ')').queue( function(){
							$(this).addClass('on');
							$(this).clearQueue();
							$(this).fadeIn('fast');
						});
					}else{
						e.find('ul.list li.on').fadeOut(o.speed);
						e.find('ul.list li.on').removeClass('on');
						e.find('ul.list li:eq(' + num + ')').fadeIn(o.speed);
						e.find('ul.list li:eq(' + num + ')').addClass('on');
					}
					if(num >= len) no = 0;
					else{ no = num; no++; }
				}
			}
			e.find('ul.page li').each(function(i){
				$(this).mouseover( function(){
					ani(i, true);
				});
			});
			e.mouseover( function(){ pause = true; }).mouseleave( function(){ pause = false; }); //마우스오버시 정지
			setInterval(function(){ if(pause == false) ani(no, false); }, o.delay);
			
			e.find('ul.ctrl li .next').on("click", function(){
				if (no >= maxnum){
					no = 0;
				};
				ani(no , true);
			});
			e.find('ul.ctrl li .prev').on("click", function(){
				if (no <= 0){
					no = maxnum;
					//console.log(num);
				};
				no--;
				no = no-1;
				ani(no, true);
			});
		});
	}
});
//
$(function(){
	$("#fullpage").fullpage({
		anchors: ["firstPage", "secondPage", "thirdPage"],
		menu: "#menu",

		navigation: false,
		navigationPosition: "custom",


		//Scrolling
		autoScrolling: false,
		fitToSection: false,
		scrollBar: true,
		easing: "easeInOutCubic",

		paddingTop: "170px",
		paddingBottom: "0",



		//events
		afterRender: function(){
		},
		afterLoad: function(anchorLink, index){
			var loadedSlide = $(this);
			if(anchorLink == "firstPage" && index == 1){
				//alert("1");
				$(".menu_anchor li").removeClass("active");
				$(".menu_anchor li").eq(index-1).addClass("active");
            };
            if(anchorLink == "secondPage" && index == 2){
				//alert("2");
				$(".menu_anchor li").removeClass("active");
				$(".menu_anchor li").eq(index-1).addClass("active");
            };
			 if(anchorLink == "thirdPage" && index == 3){
				//alert("3");
				$(".menu_anchor li").removeClass("active");
				$(".menu_anchor li").eq(index-1).addClass("active");
            };


            if(   window.anchorLinkCallBack  ){
            	window.anchorLinkCallBack(anchorLink, index);
            }
		}
	});
	
	//menu_anchor
	$(".menu_anchor li").eq("0").addClass("active");
	$(".menu_anchor li").on("click", function(){
		$(".menu_anchor li").removeClass("active");
		$(this).addClass("active");
	});

	//tab1
	$(".tab_wrap .tab_tit li").each(function (i) {
		$(this).attr("idx", i);
	}).click(function(){
		var n = $(this).attr("idx");
		$(this).siblings("li").removeClass("on");
		$(this).addClass("on");

		$(this).parents(".tab_wrap").find(".tab_con").removeClass("on");
		$(this).parents(".tab_wrap").find(".tab_con").eq(n).addClass("on");
	});
	
	$("#footer .inner .toggle_footer").on("click", function(){
		if ($(this).parents(".inner").hasClass("on")){
			$(this).parents(".inner").removeClass("on");
			$(this).parents(".inner").addClass("off");
			$("address, .f_menu, .company_logo").slideUp("fast");
		} else if ($(this).parents(".inner").hasClass("off")){
			$(this).parents(".inner").removeClass("off");
			$(this).parents(".inner").addClass("on");
			$("address, .f_menu, .company_logo").slideDown("fast");
		}
	});

	$(window).on("load resize",function(){
		var winWdh = $(this).innerWidth();
		//alert(winWdh);
		if(winWdh <= 1320){
			$("#wrap").addClass("device_tb");
		}else{
			$("#wrap").removeClass("device_tb");
		}
		/*
		if(winWdh <= 1024){
			$("#wrap").addClass("device_tb");
			$("#wrap").removeClass("device_st2");
		}else{
			$("#wrap").removeClass("device_tb");
		}
		*/
	});
});

//달력 ================================================================================
$(function(){
	$(".pop_calendar").datepicker({
		showOn: "button" ,
		showButtonPanel: true ,
		buttonImage : "../../webapp/images/board/calendar_btn_open.gif" ,
		buttonImageOnly : true ,
		buttonText: "달력",
		closeText : "닫기" ,
		currentText : "오늘" ,
		dateFormat : "yy-mm-dd" ,
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


/**
 *  지역 검색 selectBox의 option 가져오기
 * @param rgnClss {H1 : 광역시도, H2 : 시군구(4), H3 :시군구(5), H4 : 행정동}
 * @param megaCd  시군구 혹은 행정동 검색시 이전 검색에서 가져오는 값
 */
function getAreaSelectOption(rgnClss, megaCd, ctyCd){

	if(megaCd === undefined) megaCd ='';

	$.ajax({
		url:'/common/area_select_option.json',
		data:'rgnClss='+rgnClss+'&megaCd='+megaCd+'&ctyCd='+ctyCd,
		success: function(data){
//			console.log(data);
			return data;
		}
	});
}

/**
 * 파일 다운로드
 * @param orgFileName   파일 한글명
 * @param realFileName  실제 파일명
 * @param delYn			다운로드 후 파일 삭제 여부
 */
function fileDown(orgFileName, realFileName, delYn) {

	$("#direct-download-form").remove();
	$("body").append("<form id=\"direct-download-form\" name=\"direct-download-form\" method=\"post\" style=\"display:none;\"></form>");
	var form = $("#direct-download-form");

	form.append("<input type=\"hidden\" name=\"orgFileName\" id=\"orgFileName\">");
	form.append("<input type=\"hidden\" name=\"fileName\" id=\"fileName\">");
	form.append("<input type=\"hidden\" name=\"delYn\" id=\"delYn\">");

	$('#orgFileName').val(orgFileName);
	$('#fileName').val(realFileName);
	$('#delYn').val(delYn);

	form.attr("action", "/common/fileDirectDownload.do");

	form.submit();
}

/**
 * 로딩바 활성화 ( background : black )
 * @param divId 로딩바를 활성화 시킬 위치의 id
 */
function loadingShow(divId){
	
	// 배경 색 넣기
	if(divId == 'fog'){
		$('#fog').show();
		$("body").css({"overflow" : "hidden"});
	}else{		
		$("#"+divId).css("background","rgba(0, 0, 0, 0.3)");
		
		var loadW = $("#"+divId).width();
		var loadH = $("#"+divId).height();
		
		// loading 이미지 로드
		if($("#"+divId).find(".loadingImg").length > 0){
			$("#"+divId+" .loadingImg").show();
		}else{		
			if(divId.indexOf("Map") == -1){			
				$("#"+divId).html("<div class='loadingImg' style='width:"+loadW+"px;height:"+loadH+";'><img src='/images/common/loading.gif' style='width:32px;height:32px;'></div>");
			}else{
				$("#"+divId).append("<div class='loadingImg' style='width:"+loadW+"px;height:"+loadH+";'><img src='/images/common/loading.gif' style='width:32px;height:32px;'></div>");			
			}
		}
	}
}

/**
 * 로딩바 활성화 (background : white)
 * @param divId 로딩바를 활성화 시킬 위치의 id
 */
function loadingShow2(divId){
	
	// 배경 색 넣기
	$("#"+divId).css("background","rgb(248, 248, 248)");
	
	var loadW = $("#"+divId).width();
	var loadH = $("#"+divId).height();
	
	// loading 이미지 로드
	if($("#"+divId).find(".loadingImg").length > 0){
		$("#"+divId+" .loadingImg").show();
	}else{				
		$("#"+divId).html("<div class='loadingImg' style='background:rgba(248, 248, 248, 1);border:none;width:"+loadW+"px;height:"+loadH+";'><img src='/images/common/loading.gif' style='width:32px;height:32px;'></div>");
	}
}

/**
 * 로딩바 비활성화
 * @param divId 로딩바를 비활성화 시킬 위치의 id
 */
function loadingHide(divId){
	
	// 배경 색 빼기
	if(divId == 'fog'){
		$('#fog').hide();
		$("body").css({"overflow" : "auto"});
	}else{		
		$("#"+divId).css("background","rgba(0, 0, 0, 0)");
		// 이미지 빼기
		$("#"+divId).find(".loadingImg").hide();
	}
	
//	$("#"+divId).css("background","rgba(0, 0, 0, 0)");
}

/**
 * 숫자를 한글화
 * @param value 변경할 숫자
 * @param index 몇자리 수
 * @param precision 소수점 몇자리
 * @returns
 */
function krWonRound(value,index,precision){
	
	if(value == 0 )
		return 0;
	var prs = ["일","십","백","천","만","십만","백만","천만","억","십억","백억","천억","조"];
	var i = 0;
	var pre = 0;
	var minus = "";
	if(precision) pre = precision;
	if (value < 0){
		value *= -1;
		minus = "-"
	} 
	
	if(index) {
		if(index < prs.length) i = index;
		else i = prs.length - 1;
	}else{
		i = 1 + Math.floor(1e-12 + Math.log(value) / Math.LN10);
		i--;
	}
	if(prs.length < i) i = prs.length;
//	return minus+d3.round(value/Math.pow(10,i) , pre) + prs[i];		
	return minus+(value/Math.pow(10,i)).toFixed(pre) + prs[i];		
}

/**
 * 몇자리 수인지 찾아줌 (만 / 억 / 조 단위만) 
 * @param value 숫자
 * @returns {Number} 몇자리 수 인지 return
 */
function getIndexNumber(num){
	var cnt =  Math.floor(1e-12 + Math.log(num) / Math.LN10);
	
	if(cnt >= 4){  // 1000 이상일 경우
		if(cnt%4 != 0){ // 만(4), 억(8), 조(12) 단위로만 표현
			cnt = 4 * Math.floor(cnt/4);
		}		
	}
	
	return cnt;
}

/**
 * 몇자리 수인지 찾아줌
 * @param value 숫자
 * @returns {Number} 몇자리 수 인지 return
 */
function krWonRoundIndex(value){
	var prs = ["일","십","백","천","만","십만","백만","천만","억"];
	var i = 0;
	if (value < 0) value *= -1;
	i = 1 + Math.floor(1e-12 + Math.log(value) / Math.LN10);
	if(prs.length < i) i = prs.length;
	i--;
	return i;
}

/**
 * 날짜 포멧
 * @param dateObj	데이트 객체(DATE)
 * @param gbn		날짜 사이 구분값 ('.' , '-' , '/' )
 * @returns {String}
 */
function dateFomat( dateObj, gbn){
	var stringDate = "";
	stringDate += dateObj.getFullYear() + gbn;
	
	if((dateObj.getMonth()+1) >= 10) stringDate += (dateObj.getMonth()+1) + gbn;
	else stringDate += "0" + (dateObj.getMonth()+1) + gbn;
	
	if(dateObj.getDate() >= 10) stringDate += dateObj.getDate();
	else stringDate += "0" + dateObj.getDate();
	
	return stringDate;

}

(function($) {
	 
    $.ajaxSetup({
         error: function(xhr, status, err) {
            if (xhr.status == 901) {
                  location.href="/";
            }else if(xhr.status == 0){
            	return;
            } 
            else {
                alert("예외가 발생했습니다. 관리자에게 문의하세요.");
            }
        }
    });

})(jQuery);
