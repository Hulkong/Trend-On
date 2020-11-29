<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="ko">
	<head>
		<meta http-equiv="Expires" content="-1">

		<%@ include file="/WEB-INF/jsp/onmap/main/include/layer_library.jsp" %>
		<link rel="stylesheet" href="/css/renew.css?ver=${globalConfig['config.version']}" />
		
		<script src="/js/jquery/jquery.cookie.js"></script>
		<script src="/js/library-common.js?ver=${globalConfig['config.version']}"></script>
		<script src="/js/main.js?ver=${globalConfig['config.version']}"></script>
		<script type="text/javascript">
		//수정
			$(document).ready(function() {
				
				$("#applyDiv").draggable();
				$("#loginDiv").draggable();
				$("#regist01Div, #regist02Div").draggable();
				$("#findDiv").draggable();
				
				// 로그인버튼 클릭
				$("#btnLogin").click(function() {
					$(".layer_div").hide();
					$("#loginDiv").show();
				});
				
				// 문의하기버튼 클릭
// 				$("#btnContact").click(function() {
// 					$(".layer_div").hide();
// 					$("#contactDiv").show();
// 				});
				
				// 사용 신청하기 버튼 클릭
				$("#btnApply").click(function() {
					if(deviceChk()){
						location.href = "/app.m";
					}else{						
						$(".layer_div").hide();
						$("#applyDiv").show();
					}
				});
				
				// 아이디/비번 찾기 버튼 클릭
				$("#btnUser").click(function() {
					$(".layer_div").hide();
					$("#findDiv").show();
				});

				$(".btn_close, .btn_cancel").click(function() {
					$(this).parents(".layer_div").hide();
					$('#useApply').css({ 'pointer-events': '' });
					//location.reload();
				});
				
				if($("#crtfcTpye").val() != null && $("#crtfcTpye").val() != "" ) {
					$("#regist04Div").show();
				}
				
				$("#fullpage2").fullpage({
					anchors: ["firstPage", "secondPage", "thirdPage", "fourthPage", "fifthPage"],
					menu: "#menu",
					loopHorizontal: false,
					navigation: false,

					//Scrolling
					autoScrolling: false,
					fitToSection: true,
					scrollBar: false,
					easing: "easeInOutCubic",

// 					paddingTop: "10px",
// 					paddingBottom: "33px",
					
			        onLeave: function(index, nextIndex, direction){
			            if(nextIndex == 5 && direction == 'down'){
			            	$.fn.fullpage.setFitToSection(false);
			            }else{
			            	$.fn.fullpage.setFitToSection(true);
			            }
			        }

					

				});

				// 동영상 팝업 닫기
				$("#mediaClose").click(function(){
					$(".pop_layer3").hide();
				});
				
				// 다시보이지않기 텍스트 클릭시
				$("#check_tit").on("click",function(){
					$("#check_noView").click();
				});
				
				// 다시보이지않기 체크박스 클릭시
				$("#check_noView").on("click", function(){ //다시보지않기 체크박스 클릭시
					if($(this).is(":checked")){    //체크되었다면
						$.cookie("main_0001_Cookie", "Y", 365);   //365일 후 만료되는 main_0001_Cookie라는 이름의 Y값을 같은 쿠키를 생성 
					}
					$("#mediaLayer").hide();
				});

				// 쿠키값이 없으면 동영상 play
				if ($.cookie("main_0001_Cookie") != "Y") {  //쿠키 값이 Y가 아니면(체크하지 않았다면) 
					$("#mediaLayer").show();					
				}
				
				var errorMsg = '${sessionScope["SPRING_SECURITY_LAST_EXCEPTION"].message}';
				
				if(errorMsg != ''){
					//$("#userLoginForm .layer_btm").before("<span class='login_err_msg'>"+errorMsg+'</span>');
					$("#userLoginForm .login_err_msg").html(errorMsg);
					$("#btnLogin").click();
					$(".pop_layer3").hide();
				}
				
			});
		
			// scroll 이벤트시 화면 가장자리 위로 올라가는 버튼 표시/숨김
			$(window).scroll(function (e) {
				
				// chrome과 ie 스크롤 속성이 다름
				var scrollpos = window.scrollY || window.pageYOffset;
				
				if ($('#goTop').is(':visible')) {
					if (scrollpos === 0) {
						$('#goTop').hide();
					}
				} else {
					if (scrollpos > 0) {
						$('#goTop').show();
					}
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
			});
		</script>
	</head>
	<body>
		<div id="wrap">
			<!-- header -->
			<div id="mainHeader2">
				<h1 class="logo"><a href="#firstPage"><img src="/images/main_n/hdlogo.png" alt="logo" /></a></h1>
				<div class="gnb">
					<ul>
						<li><a href="#" id="btnLogin">로그인</a></li>
					</ul>
					<input type="hidden" id="crtfcTpye" value="${param.user }">	
					<!-- 사용신청 -->
					<%@ include file="/WEB-INF/jsp/onmap/main/include/layer_apply.jsp" %>
					<!-- //사용신청 -->
					<!-- 로그인 -->
					<%@ include file="/WEB-INF/jsp/onmap/main/include/layer_login.jsp" %>
					<!-- //로그인 -->
					<!-- 아이디비밀번호 찾기 -->
					<%@ include file="/WEB-INF/jsp/onmap/main/include/layer_user_info_find.jsp" %>
					<!-- //아이디비밀번호 찾기 -->
					<!-- 문의하기 -->
					<%@ include file="/WEB-INF/jsp/onmap/main/include/layer_contact.jsp" %>
					<!-- //문의하기 -->
					<!-- 로그인 -->
					<div class="pop_layer2 layer_login">
						<div class="layer_top">
							<p class="tit">로그인</p>
							<a href="#" class="btn_close">닫기</a>
						</div>
						<div class="layer_con">
							<dl class="dl_write">
								<dt><span class="tit">아이디(이메일주소)</span></dt>
								<dd><input type="text" class="inp_full" /></dd>
							</dl>
							<dl class="dl_write">
								<dt><span class="tit">비밀번호</span></dt>
								<dd><input type="password" class="inp_full" /></dd>
							</dl>
						</div>
						<div class="layer_btm">
							<ul>
								<li><a href="#" class="btn_confirm">확인</a></li>
								<li><a href="#" class="btn_cancel">취소</a></li>
							</ul>
						</div>
					</div>
					<!-- //로그인 -->

					<!-- 아이디비밀번호 찾기 -->
					<div class="pop_layer2 layer_find" >
						<div class="layer_top non_boder">
							<p class="tit">아이디/비밀번호 찾기</p>
							<a href="#" class="btn_close">닫기</a>
						</div>

						<div class="tab_wrap tab_find tab1">
							<div class="tab_tit">
								<ul>
									<li class="btn_id on"><a href="#">아이디 찾기</a></li>
									<li class="btn_pw "><a href="#">비밀번호 찾기</a></li>
								</ul>
							</div>
							<!-- tab_con : 아이디찾기 -->
							<div class="tab_con on">
								<div class="layer_con">
									<div class="layer_con_top">
										<p class="tit">본인 확인을 위해 가입 시 입력하신 사용자 이름과 관할 시군구를 입력해주세요.</p>
									</div>
									<dl class="dl_write">
										<dt><span class="tit">사용자 이름</span></dt>
										<dd><input type="text" class="inp_full" /></dd>
									</dl>
									<dl class="dl_write">
										<dt><span class="tit">관할 시/군/구</span></dt>
										<dd>
											<div class="select_box select_ty1">
												<select>
													<option selected="selected">시/도</option>
												</select>
												<span class="tit"></span>
											</div>
											<div class="select_box select_ty1">
												<select>
													<option selected="selected">시/군/구</option>
												</select>
												<span class="tit"></span>
											</div>
										</dd>
									</dl>
								</div>
								<div class="layer_btm">
									<ul>
										<li><a href="#" class="btn_confirm">확인</a></li>
										<li><a href="#" class="btn_cancel">취소</a></li>
									</ul>
								</div>
								<div class="find_result">
									고객님의 아이디는 <strong>aaa@aaa.com</strong> 입니다.
								</div>
							</div>
							<!-- //tab_con : 아이디찾기 -->

							<!-- tab_con : 비밀번호찾기 -->
							<div class="tab_con">
								<div class="layer_con">
									<div class="layer_con_top">
										<p class="tit">사용자 아이디와 이름, 관할 시군구를 입력하시면 이메일주소로 새로운 비밀번호가 발송됩니다.<br />새롭게 발송된 비밀번호는 로그인 후에 변경해주셔야 합니다.</p>
									</div>
									<dl class="dl_write">
										<dt><span class="tit">사용자 아이디</span></dt>
										<dd>
											<input type="text" /> @
											<div class="select_box select_ty1">
												<select>
													<option selected="selected">직접입력</option>
												</select>
												<span class="tit"></span>
											</div>
										</dd>
									</dl>
									<dl class="dl_write">
										<dt><span class="tit">사용자 이름</span></dt>
										<dd><input type="text" class="inp_full" /></dd>
									</dl>
									<dl class="dl_write">
										<dt><span class="tit">관할 시/군/구</span></dt>
										<dd>
											<div class="select_box select_ty1">
												<select>
													<option selected="selected">시/도</option>
												</select>
												<span class="tit"></span>
											</div>
											<div class="select_box select_ty1">
												<select>
													<option selected="selected">시/군/구</option>
												</select>
												<span class="tit"></span>
											</div>
										</dd>
									</dl>
								</div>
								<div class="layer_btm">
									<ul>
										<li><a href="#" class="btn_confirm">확인</a></li>
										<li><a href="#" class="btn_cancel">취소</a></li>
									</ul>
								</div>
								<div class="find_result">
									고객님께서 등록하신 이메일로 새로운 비밀번호가 발송 되었습니다.
								</div>
							</div>
							<!-- //tab_con : 비밀번호찾기 -->
						</div>
					</div>
					<!-- //아이디비밀번호 찾기 -->

					<!-- 회원가입 01 -->
					<div class="pop_layer2  layer_join">
						<div class="layer_top non_boder">
							<p class="tit">회원가입</p>
							<a href="#" class="btn_close">닫기</a>
						</div>
						<div class="join_step">
							<p>
								<img src="/images/common/join_step_01.gif" alt="약관동의" />
							</p>
						</div>
						<div class="layer_con">
							<div class="layer_con_top txt_rg">
								<label class="term_chk"><input type="checkbox" />이용회원 약관 및 개인정보 수집 및 이용에 모두 동의합니다.</label>
							</div>
							<div class="article_agree">
								<div class="group_top">
									<div class="tit">
										이용회원 약관
									</div>
									<div class="bx_rgt">
										<label><input type="checkbox" />동의합니다.</label>
									</div>
								</div>
								<div class="bx_term">
									<iframe src=""></iframe>
									<!-- 
									<textarea cols="10" rows="10"></textarea>
									-->
								</div>
							</div>

							<div class="article_agree">
								<div class="group_top">
									<div class="tit">
										개인정보수집 및 이용에 대한 안내
									</div>
									<div class="bx_rgt">
										<label><input type="checkbox" />동의합니다.</label>
									</div>
								</div>
								<div class="bx_term">
									<iframe src=""></iframe>
								</div>
							</div>
						</div>
						<div class="layer_btm">
							<ul>
								<li><a href="#" class="btn_confirm">네! 동의합니다.</a></li>
								<li><a href="#" class="btn_cancel">아니요! 동의하지 않습니다.</a></li>
							</ul>
						</div>
					</div>
					<!-- //회원가입 01 -->

					<!-- 회원가입 02 -->
					<div class="pop_layer2 layer_join">
						<div class="layer_top non_boder">
							<p class="tit">회원가입</p>
							<a href="#" class="btn_close">닫기</a>
						</div>
						<div class="join_step">
							<p>
								<img src="/images/common/join_step_02.gif" alt="정보입력" />
							</p>
						</div>
						<div class="layer_con">
							<dl class="dl_write">
								<dt><span class="tit">사용자 아이디(이메일주소)</span></dt>
								<dd>
									<input type="text" /> @
									<div class="select_box select_ty1">
										<select>
											<option selected="selected">직접입력</option>
										</select>
										<span class="tit"></span>
									</div>
									<button class="btn_side">중복체크</button>
									<p class="txt_sub">※ 영문, 기호, 숫자를 혼합하여 10자리 이상으로 입력해 주세요.</p>
								</dd>
							</dl>
							<dl class="dl_write">
								<dt><span class="tit">사용자 이름</span></dt>
								<dd><input type="text" class="" /></dd>
							</dl>
							<dl class="dl_write">
								<dt><span class="tit">비밀번호</span></dt>
								<dd>
									<input type="password" class="inp_full" />
									<p class="txt_sub">※ 영문, 기호, 숫자를 혼합하여 10자리 이상으로 입력해 주세요.</p>
								</dd>
							</dl>
							<dl class="dl_write">
								<dt><span class="tit">비밀번호 확인</span></dt>
								<dd><input type="password" class="inp_full" /></dd>
							</dl>
							<dl class="dl_write">
								<dt><span class="tit">관할 시/군/구</span></dt>
								<dd>
									<div class="select_box select_ty1">
										<select>
											<option selected="selected">시/도</option>
										</select>
										<span class="tit"></span>
									</div>
									<div class="select_box select_ty1">
										<select>
											<option selected="selected">시/군/구</option>
										</select>
										<span class="tit"></span>
									</div>
									<ul class="list_txt">
										<li>- 본 서비스의 사용을 위해서는 사용기관으로 먼저 등록되어야 합니다.</li>
										<li>- <em>“아직 사용기관으로 등록되지 않은 상태입니다”</em> 메시지가 나오는 경우 02-395-7540 이나 admin@onmap.co.kr로 사용기관 등록을 해주시기 바랍니다.</li>
									</ul>
								</dd>
							</dl>
						</div>
						<div class="layer_btm">
							<ul>
								<li><a href="#" class="btn_confirm">회원가입</a></li>
								<li><a href="#" class="btn_cancel">취소</a></li>
							</ul>
						</div>
					</div>
					<!-- //회원가입 02-->

					<!-- 회원가입 03 -->
					<div class="pop_layer2 layer_join">
						<div class="layer_top non_boder">
							<p class="tit">회원가입</p>
							<a href="#" class="btn_close">닫기</a>
						</div>
						<div class="join_step">
							<p>
								<img src="/images/common/join_step_03.gif" alt="메일확인" />
							</p>
						</div>
						<div class="layer_con">
							<div class="article_join_mail">
								<p>입력해주신 이메일주소로 사용자 승인을 위한 확인 주소를 발송하였습니다.<br />(이메일 발송에는 5~10분 정도 소요됩니다)<br /><br /><em>이메일로 전송된 주소를 클릭하시면 승인절차가 마무리되며 즉시 사용이 가능</em>합니다.<br />이메일이 오지 않는 경우 아래의 “승인메일 재발송＂ 버튼을 클릭하시면 재발송됩니다.</p>
							</div>
						</div>
						<div class="layer_btm">
							<ul>
								<li><a href="#" class="btn_confirm">승인메일 재발송</a></li>
							</ul>
						</div>
					</div>
					<!-- //회원가입 03-->

					<!-- 회원가입 04 -->
					<div class="pop_layer2 layer_join">
						<div class="layer_top non_boder">
							<p class="tit">회원가입</p>
							<a href="#" class="btn_close">닫기</a>
						</div>
						<div class="join_step">
							<p>
								<img src="/images/common/join_step_04.gif" alt="가입완료" />
							</p>
						</div>
						<div class="layer_con">
							<div class="article_join_complete">
								<p><em>이메일 확인이 완료되었습니다.</em><br />회원가입시에 입력하신 이메일 주소(아이디)와 비밀번호를 이용하여 로그인 하시면 즉시 사용이 가능합니다.<br /><br />감사합니다.</p>
							</div>
						</div>
						<div class="layer_btm">
							<ul>
								<li><a href="#" class="btn_confirm">로그인 하러 가기</a></li>
							</ul>
						</div>
					</div>
					<!-- //회원가입 04-->
				</div>
				<div id="nav">
					<ul>
						<li class="menu1"><a href="#secondPage">지역 현황</a></li>
						<li class="menu2"><a href="#thirdPage">경제 트렌드</a></li>
						<li class="menu3"><a href="#fourthPage">이벤트 효과</a></li>
<!-- 						<li class="menu3"><a href="#fifthPage">이벤트 효과</a></li> -->
					</ul>
				</div>
			</div>
			<!-- //header -->
			
			<hr />
			<div class="top_btn">
				<a href="#firstPage" id="goTop" style="display:none;"><img src="/images/main_n/top_btn.png" alt="GO TO TOP!!"></a>
			</div>
			<!-- 본문 ==================================================================================================== -->
			<!--  -->
			<div id="fullpage2">
				<!-- section1 -->
				<article class="section" id="section1">
					<div class="inner">
						<p class="tit"><span class="fb">돈과 사람</span>의 <span class="fb">흐름</span>을 분석하는<br /> <span class="scolorOrange fb">지역경제 모니터링</span><span class="fb">서비스</span></p>
<!-- 						<p class="tit"><strong>빅데이터</strong>로  보는  쉽고  빠른 <br /> 지역경제  흐름</p> -->
						<a href="#none" id="btnApply" class="apy_btn">무료! 테스트 계정 신청하기</a>
					<iframe class="main_video"
						src="https://www.youtube.com/embed/Zxrecv7GaVg?autoplay=1&mute=1&controls=1&playlist=Zxrecv7GaVg&loop=1"
						frameborder="0"
						allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
						allowfullscreen></iframe>
				</div>
				</article>
				<!-- //section1 -->
				<!--gif-->
<!-- 				<article class="section" id="section5"> -->
<!-- 					<div class="gif"> -->
<!-- 						<img class="ser_01" src="/images/01.gif" alt="service01" style="width: 30%;"> -->
<!-- 						<img class="ser_02" src="/images/02.gif" alt="service02" style="width: 30%;"> -->
<!-- 						<img class="ser_03" src="/images/03.gif" alt="service03" style="width: 30%;"> -->
<!-- 						<div class="ser_con"> -->
<!-- 							<img class="gif_text" src="/images/gif_text.png" alt="서비스 장점" style="width: 83%;"> -->
<!-- 						</div> -->
<!-- 					</div> -->
<!-- 				</article> -->
				<!--///gif-->
				<!-- section2 -->
				<article class="section" id="section2">
					<div class="inner">
						<p class="tit_sub">summary</p>
						<h2 class="tit">지역 현황</h2>
						<p class="txt">우리 지역의 경제는 어떻게 변했을까요? <br /><br />소비매출과 유동인구의 빅데이터를<br />통해 우리 지역의 진짜 모습을<br />발견할 수 있습니다.</p>
					</div>
				</article>
				<!-- //section2 -->
				
				<!-- section3 -->
				<article class="section" id="section3">
					<div class="inner">
						<p class="tit_sub">trend</p>
						<h2 class="tit">경제 트렌드</h2>
						<p class="txt">최근 2년간 우리 지역경제는 어떻게 변해왔을까요?<br />원하는 기간만 설정하면 경제 변화를 빠르게 확인 할 수 있습니다.<br /><br /><em>일자별로 다양한 정책, 이슈에 대한 지역경제 데이터를 자세히 확인</em> 할 수 있습니다.</p>
					</div>
				</article>
				<!-- //section3 -->

				<!-- section4 -->
				<article class="section" id="section4">
					<div class="inner">
						<p class="tit_sub">event</p>
						<h2 class="tit">이벤트 효과</h2>
						<p class="txt">우리 지역이 함께 기뻐하고 슬퍼한 이벤트는 <br />언제였나요?<br />그 시기에 우리 지역은 어땠는지 <br />데이터를 통해 확인 할 수 있습니다.<br /><br /><em>지역축제 기간 전·후 비교를 통해 <br />경제파급 효과를 가늠</em>해 볼 수 있습니다.</p>
					</div>
				</article>
				<!-- //section4 -->
			</div>
			<!-- // -->
			<!-- //본문 ==================================================================================================== -->

			<!-- footer -->
			<div id="footer" class="footer_main">
			<div class="inner">
				<span><a href="/common/policy.html?page=0" target="_blank">서비스 약관</a></span>
				<span><a href="/common/policy.html?page=1" target="_blank">개인정보 취급방침</a></span>
				<span><a href="https://www.openmate-on.co.kr/" target="_blank">회사소개</a></span>
				<br>
				<p class="adress">서울특별시 중구 청계천로 100, 시그니쳐타워 서관 11층 (주)오픈메이트온<br>
						사업자번호: 763-88-01165 TEL: 02-6956-7541 FAX: 0505-055-7522 EMAIL: sales@openmate-on.co.kr</p>
				<p class="company_logo" style="display: block;">
					<img src="/images/main/mateon_footer_logo.png" alt="OPENmate_ON">
					<img src="/images/main/NICE_gray.png" alt="nice">
					<img src="/images/renew_v1/kt-logo.png" alt="kt"/>
				</p>
				<p class="copyright">Copyright ⓒ OPENmate_ON All rights reserved.</p>
			</div>
		</div>
			<!-- //footer -->
		</div>
	</body>
</html>
