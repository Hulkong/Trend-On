package com.openmate.onmap.user.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.openmate.frmwrk.user.UserInfo;
import com.openmate.frmwrk.user.UserService;
import com.openmate.onmap.user.dao.UserLoginDao;



@Service("userService")
public class UserServiceImpl implements UserService {
	@Resource(name = "userLoginDao")
	private UserLoginDao userLoginDao;

	@Override
	public List<String> selectAuth(UserInfo userInfo) {

		List<Map<String, Object>> authList = userLoginDao.getLoginAuth(userInfo);

		List<String> retList = new ArrayList<String>();

		for(int i = 0; i < authList.size(); i++) {
			Map<String, Object> authMap = (Map<String, Object>)authList.get(i);
			retList.add((String) authMap.get("authority"));
		}

		return retList;
	}

	@Override
	public void updateUserLastLogin(UserInfo userInfo) {
		// TODO Auto-generated method stub
		userLoginDao.updateUserLastLogin(userInfo.getUserId());
	}

	@Override
	public UserInfo selectUserInfo(String userId) {
		
		UserInfo info = userLoginDao.getUserInfo(userId);
		
		if(info != null) {
			info.setExtInfo(userLoginDao.getUserInfoMap(userId));
		}
		
		return info;
	}
	
	@Override
	public void userLoginLogging(Map exUserInfo){
		userLoginDao.userLoginLogging(exUserInfo);
	}
}
