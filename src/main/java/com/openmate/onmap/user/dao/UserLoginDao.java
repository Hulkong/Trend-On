package com.openmate.onmap.user.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.openmate.frmwrk.user.UserInfo;



@Repository(value = "userLoginDao")
public interface UserLoginDao {

	public List<Map<String, Object>> getLoginAuth(UserInfo userInfo);	// 로그인 사용자 권한 조회 

	public UserInfo getUserInfo(String userId);							// 사용자ID로 상세 조회

	public Map<String, Object> getUserInfoMap(String userId);			// 사용자 정보 조회
	
	public void updateUserLastLogin(String userId);						// 최종로그인 date 기록
	
	public void userLoginLogging(Map exUserInfo);		// 회원로그인 로그 남기기
}
