package com.openmate.onmap.common.util;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service("emailService")
public class EmailUtil {

	@Value("${config.service.url}")
	private String serviceUrl;
	
	protected static final Logger logger = LoggerFactory.getLogger(EmailUtil.class);
	
	/**********************************************
	 *  1. 개요 : 사용신청 등록 완료 메일
	 *	2. 처리내용 :
	 * 	@Method sendApplyInfoMsg
	 *  @param applyInfo
	 *  @return
	 **********************************************/
	public String sendApplyInfoMsg(Map<String, Object> applyInfo){
		String msg = "";
		
		msg += "<table cellpadding='0' cellspacing='0' border='0' width='100%' style='text-align:center;'>";
		msg += "<tr>";
		msg += "<td bgcolor='#2d4575' style='padding:20px 20px;'>";
		msg += "<table cellpadding='0' cellspacing='0' border='0' width='100%'>";
		msg += "<tr>";
		msg += "<td width='100'><h1 style='margin:0;'><img src='" + serviceUrl + "/images/common/logo.png' alt='logo' style='' /></h1></td>";
		msg += "<td style='padding-right:100px;text-align:center;'><h2 style='margin:0; font-size:26px; font-weight:bold; color:#333;'>사용 신청 등록 메일</h2></td>";
		msg += "</tr>";
		msg += "</table>";
		msg += "</td>";
		msg += "</tr>";
		msg += "<tr>";
		msg += "<td style='padding:50px;'>";
		msg += "<table cellpadding='0' cellspacing='0' border='0' width='700px' style='margin:0 auto;'>";
		msg += "<tr><td style='line-height:2.0; padding:40px 0 20px 0; font-size:18px; font-weight:bold; color:#555; text-align:center;'>" + applyInfo.get("orgNm") + " 사용신청 등록이 되었습니다.</br>신청 내용은 아래와 같습니다.</td></tr>";
		msg += "<tr>";
		msg += "<td style='padding:20px 50px 70px 50px; '>";
		msg += "<table cellpadding='0' cellspacing='0' border='1' width='100%' style='text-align:center;'>";
		msg += "<tr>";
		msg += "<td style='line-height:2.0; font-size:15px; font-weight:bold; color:#555;'>등록일자</td>";
		msg += "<td style='line-height:2.0; font-size:15px; font-weight:bold; color:#555;'>" + applyInfo.get("date") + "</td>";
		msg += "</tr>";
		msg += "";
		msg += "<tr>";
		msg += "<td style='line-height:2.0; font-size:15px; font-weight:bold; color:#555;'>기관명</td>";
		msg += "<td style='line-height:2.0; font-size:15px; font-weight:bold; color:#555;'>" + applyInfo.get("orgNm") + "</td>";
		msg += "</tr>";
		msg += "";
		msg += "<tr>";
		msg += "<td style='line-height:2.0; font-size:15px; font-weight:bold; color:#555;'>담당자</td>";
		msg += "<td style='line-height:2.0; font-size:15px; font-weight:bold; color:#555;'>" + applyInfo.get("name") + "</td>";
		msg += "</tr>";
		msg += "";
		msg += "<tr>";
		msg += "<td style='line-height:2.0; font-size:15px; font-weight:bold; color:#555;'>부서</td>";
		msg += "<td style='line-height:2.0; font-size:15px; font-weight:bold; color:#555;'>" + applyInfo.get("dept") + "</td>";
		msg += "</tr>";
		msg += "";
		msg += "<tr>";
		msg += "<td style='line-height:2.0; font-size:15px; font-weight:bold; color:#555;'>직함</td>";
		msg += "<td style='line-height:2.0; font-size:15px; font-weight:bold; color:#555;'>" + applyInfo.get("position") + "</td>";
		msg += "</tr>";
		msg += "";
		msg += "<tr>";
		msg += "<td style='line-height:2.0; font-size:15px; font-weight:bold; color:#555;'>연락처</td>";
		msg += "<td style='line-height:2.0; font-size:15px; font-weight:bold; color:#555;'>" + applyInfo.get("mobile") + "</td>";
		msg += "</tr>";
		msg += "";
		msg += "<tr>";
		msg += "<td style='line-height:2.0; font-size:15px; font-weight:bold; color:#555;'>이메일</td>";
		msg += "<td style='line-height:2.0; font-size:15px; font-weight:bold; color:#555;'>" + applyInfo.get("email") + "</td>";
		msg += "</tr>";
		msg += "";
		msg += "<tr>";
		msg += "<td style='line-height:2.0; font-size:15px; font-weight:bold; color:#555;'>뉴스레터</td>";
		msg += "<td style='line-height:2.0; font-size:15px; font-weight:bold; color:#555;'>" + applyInfo.get("newsletterYn") + "</td>";
		msg += "</tr>";
		msg += "";
		msg += "<tr>";
		msg += "<td style='line-height:2.0; font-size:15px; font-weight:bold; color:#555;'>신청내용</td>";
		msg += "<td style='line-height:2.0; font-size:15px; font-weight:bold; color:#555;'>" + applyInfo.get("memo") + "</td>";
		msg += "</tr>";
		msg += "</table>";
		msg += "</td>";
		msg += "</tr>";
		msg += "<tr>";
		msg += "<td style='line-height:2.0; padding:0 0 30px 0; font-size:18px; font-weight:bold; color:#333; text-align:center;'>";
		msg += "<a href='" + serviceUrl + "/onmap/admin/main.do' style='height: 50px; padding: 20px 80px; border: 1px solid #4b7311; font-family:\"malgun gothic\"; font-size: 18px; font-weight: bold; color: #FFF; background: #0099ff;' target='_blank' >"; 
		msg += "Trend-ON 서비스 접속"; 
		msg += "</a>";
		msg += "</td>";
		msg += "</tr>";
		msg += "</table>";
		msg += "</td>";
		msg += "</tr>";
		msg += "</table>";
		
		return msg;
	}
	
	/**********************************************
	 *  1. 개요 : 서비스 이용 안내 메일 
	 *	2. 처리내용 :
	 * 	@Method sendServiceGuide
	 *  @param svcInfo
	 *  @return
	 **********************************************/
	public String sendServiceGuide(Map<String,Object> svcInfo) {

		String msg = "";
		
		msg += "<table cellpadding='0' cellspacing='0' border='0' width='100%' style='text-align:center;'> ";
		msg += "<tr>";
		msg += "<td bgcolor='#2d4575' style='padding:20px 20px;'>";
		msg += "<table cellpadding='0' cellspacing='0' border='0' width='100%'> ";
		msg += "<tr>";
		msg += "<td width='100'><h1 style='margin:0;'><img src='" + serviceUrl + "/images/common/logo.png' alt='logo' style='' /></h1></td>";
		msg += "<td style='padding-right:100px;text-align:center;'><h2 style='margin:0; font-family:\"malgun gothic\"; font-size:26px; font-weight:bold; color:#FFF;'>서비스 이용 안내 메일</h2></td>";
		msg += "</tr>";
		msg += "</table>";
		msg += "</td>";
		msg += "</tr>";
		msg += "<tr>";
		msg += "<td style='padding:50px;'>";
		msg += "<table cellpadding='0' cellspacing='0' border='0' width='700px' style='margin:0 auto;'>";
		msg += "<tr>";
		msg += "<td style='line-height:2.0; padding:40px 0 20px 0; font-family:\"malgun gothic\"; font-size:18px; font-weight:bold; color:#555;'>빅데이터로 보는 쉽고 빠른 지역경제 흐름 \"트렌드온\" 서비스 등록이 완료되었습니다.</br>서비스 내용은 아래와 같습니다.</td>";
		msg += "</tr>";
		msg += "<tr>";
		msg += "<td style='padding:20px 50px 70px 50px;'>";
		msg += "<table cellpadding='0' cellspacing='0' border='0' width='100%' style='text-align:left;'>";
		msg += "<tr>";
		msg += "<td style='line-height:2.0; font-size:12px; font-weight:bold; color:#555; font-family:\"malgun gothic\";'>";
		msg += "1. 기관명 : " + svcInfo.get("orgNm") + " <br/>";
		msg += "2. 서비스 기간 : " + svcInfo.get("useStrDate") + " ~ " + svcInfo.get("useEndDate") + "<br/>";
		msg += "3. 서비스 지역 : " + svcInfo.get("fullName") + " <br/>";
		msg += "4. 접속 아이디 : " + svcInfo.get("userId") + " <br/>";
		msg += "5. 접속 비밀번호 : " + svcInfo.get("userId") + " <br/>";
		msg += "</td>";
		msg += "</tr>";
		msg += "</table>";
		msg += "</td>";
		msg += "</tr>";
		msg += "<tr>";
		msg += "<td style='line-height:2.0; padding:0 0 30px 0; font-size:18px; font-weight:bold; color:#333;'>";
		msg += "<a href='" + serviceUrl + "' target='_blank' style='text-decoration:none;'><input type='button' value='Trend-ON 서비스 접속' style='height:50px; padding:0 80px; border:1px solid #4b7311; font-family:\"malgun gothic\"; font-size:18px; font-weight:bold; color:#FFF; background:#0099ff;'/>";
		msg += "</td>";
		msg += "</tr>";
		msg += "<tr>";
		msg += "<td style='font-size:10px; font-family:\"malgun gothic\";'>";
		msg += "사이트에 정상적으로 접속이 되지 않으시면, 아래로 문의 부탁드립니다.<br/>Tel:02-395-7540~1<br/>E-mail:sales@openmate-on.co.kr";
		msg += "</td>";
		msg += "</tr>";
		msg += "</table>";
		msg += "</td>";
		msg += "</tr>";
		msg += "</table>";
		
		return msg;
	}
}
