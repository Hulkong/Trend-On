package com.openmate.frmwrk.user;

import java.util.List;
import java.util.Map;

public interface UserService {
	public UserInfo selectUserInfo(String userId);
	public List<String> selectAuth(UserInfo userInfo);
	public void updateUserLastLogin(UserInfo userInfo);
	public void userLoginLogging(Map exUserInfo);
}
