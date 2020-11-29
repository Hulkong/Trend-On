package com.openmate.onmap.member.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository(value = "memberDao")
public interface MemberDao {


	public int getValidateMember(Map<String, Object> param);		// 회원 비밀번호 변경을 위한 유효성 검사
	public void resetPassword(Map<String, Object> param);			// 회원 비밀번호 재설정
	public int checkPassword(Map<String, Object> param);			// 회원 비밀번호 확인
	public void setUseApply(Map<String, Object> param);			// 사용신청
	public void setEmailLog(Map<String, Object> param);				// 메일 발송시 로그 남기기
}
