package com.openmate.onmap.member.service.impl;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.mail.internet.MimeMessage;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.security.authentication.encoding.ShaPasswordEncoder;
import org.springframework.stereotype.Service;

import com.openmate.onmap.common.util.EmailUtil;
import com.openmate.onmap.member.dao.MemberDao;
import com.openmate.onmap.member.service.MemberService;

@Service("memberService")
public class MemberServiceImpl implements MemberService{

	protected static final Logger logger = LoggerFactory.getLogger(MemberServiceImpl.class);
	
	@Autowired
	private JavaMailSender mailSender;
	
	@Autowired
	private EmailUtil emailUtil;
	
	@Autowired
	ShaPasswordEncoder passwordEncoder;
	
	@Resource(name="memberDao")
	MemberDao memberDao;
	
	@Value("${config.email.salesId}")
	private String receiverAddress;
	
	@Value("${config.email.senderAddress}")
	private String fromAddress;
	
	/**
	 * @description 회원 아이디 / 비밀번호 찾기 
	 */
	@Override
	public String getMemberIdPwd(Map<String, Object> param){
		
		return String.valueOf(memberDao.getValidateMember(param));
	}
	
	/**
	 * @description 로그인페이지 -> 비밀번호 찾기 -> 비밀번호 재설정 
	 */
	@Override
	public int resetPassword(Map<String, Object> param){
		int result = 0;
		try{
			String password = (String) param.get("pwd"); 						// 사용자 비밀번호
			String epassword = passwordEncoder.encodePassword(password,null); 	// 비밀번호 암호화
			
			param.put("pwd", epassword);
			memberDao.resetPassword(param);										// 비밀번호 변경
			result = 1;
		}catch(Exception e){
			result = -1;
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * @description 로그인 후 페이지 -> 비밀번호 변경 
	 */
	@Override
	public Map<String, Object> updatePassword(Map<String, Object> param){
		Map<String, Object> rtMap = new HashMap<String, Object>();
		try{
			String beforePassword = (String) param.get("beforePassword"); 					// 현재 사용자 비밀번호		
			String password = (String) param.get("password"); 								// 변경할 비밀번호
			String repassword = (String) param.get("repassword"); 							// 변경할 비밀번호 확인
			String ebeforePassword = passwordEncoder.encodePassword(beforePassword,null); 	// 현재 사용자 비밀번호 암호화
			String epassword = passwordEncoder.encodePassword(password,null); 				// 변경할 비밀번호 암호화
			String erepassword = passwordEncoder.encodePassword(repassword,null); 				// 변경할 비밀번호 확인 암호화
			
			// 사용자 비밀번호 유효성검사
			param.put("password", ebeforePassword);
			int chPwdCnt = memberDao.checkPassword(param);
			if(chPwdCnt == 0){
				rtMap.put("resultCode", "01");
				rtMap.put("resultMsg", "현재 비밀번호가 유효하지않습니다.");
				return rtMap;
			}
			
			// 변경할 비밀번호와  현재 비밀번호가 다른건지 확인
			if(ebeforePassword.equals(epassword)){
				rtMap.put("resultCode", "02");
				rtMap.put("resultMsg", "변경할 비밀번호와  현재 비밀번호가 같습니다.\n다른 비밀번호로 변경해주세요.");
				return rtMap;
			}
			
			// 비밀번호 업데이트
			param.put("pwd", epassword);
			memberDao.resetPassword(param);										// 비밀번호 변경
			rtMap.put("resultCode", "10");
			rtMap.put("resultMsg", "비밀번호가 변경되었습니다.");
			
		}catch(Exception e){
			rtMap.put("resultCode", "00");
			rtMap.put("resultMsg", "처리중 오류가 발생했습니다./n관리자에게 문의해주세요.");
			
			e.printStackTrace();
		}
		return rtMap;
	}
	
	/**
	 * @description 사용신청 메일
	 */
	@Override
	public int useApply(Map<String, Object> param){
		int resultCode = 0;
		
		memberDao.setUseApply(param);      // 사용신청서 등록
		memberDao.setEmailLog(param);      // 메일 기록 남기기
		
		// 멀티 수신자 세팅
		if(receiverAddress.indexOf(";") != -1) {
			param.put("to", receiverAddress.split(";"));
		} 
		
		// TODO 메일 포트 활성화후 주석해제해주세요
		sendMail(param);   // 이메일 전송
		
		resultCode = 1;
		return resultCode;
	}
	
	/**
	 * @description 서비스 이용안내 메일
	 */
	@Override
	public int serviceGuide(Map<String, Object> param){
		int resultCode = 0;
		String to[] = {(String)param.get("email")};
		
		memberDao.setEmailLog(param);   // 메일 기록 남김
		
		param.put("to", to);   // 수신자 세팅 
		sendMail(param);       // 이메일전송 
		
		resultCode = 1;        // 성공코드
		return resultCode;
	}
	
	/**
	 * @description 메일전송 메소드 
	 */
	public void sendMail(Map<String, Object> param){
		
		String subject = "[Trend-On] 사용 신청이 등록되었습니다.";
		String emailType = (String) param.get("emailType");
		String msg = "";

		try{
			
			// 사용신청 메일 
			if("useApply".equals(emailType)) {
				msg = emailUtil.sendApplyInfoMsg(param);
			
			// 서비스 이용안내 메일
			} else if("serviceGuide".equals(emailType)) {
				subject = "[Trend-On] 서비스 이용 등록이 완료 되었습니다.";
				msg = emailUtil.sendServiceGuide(param);
			}  
			
			logger.debug("[[ sandMail - " + subject + " 메일 발송 시작 ]]");
			
			MimeMessage mimeMessage = mailSender.createMimeMessage();
			MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, false, "utf-8");
			
			mimeMessage.setContent(msg, "text/html; charset=utf-8");
			helper.setFrom(fromAddress);
			helper.setTo((String [])param.get("to"));
			helper.setSubject(subject);
			
			mailSender.send(mimeMessage);
		}catch(Exception e){
			e.printStackTrace();
		}
	}
}
