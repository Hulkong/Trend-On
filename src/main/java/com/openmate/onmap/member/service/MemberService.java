package com.openmate.onmap.member.service;

import java.util.Map;

public interface MemberService {
	public String getMemberIdPwd(Map<String, Object> param);					// 회원 아이디 / 비밀번호 찾기
	public int resetPassword(Map<String, Object> param);						// 로그인페이지 -> 비밀번호 찾기 -> 비밀번호 재설정 
	public Map<String, Object> updatePassword(Map<String, Object> param);		// 로그인 후 페이지 -> 비밀번호 변경
	public int useApply(Map<String, Object> param);						        // 사용신청 메일
	public int serviceGuide(Map<String, Object> param);						    // 서비스 이용안내 메일
}
