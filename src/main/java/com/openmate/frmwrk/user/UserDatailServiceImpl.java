package com.openmate.frmwrk.user;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

public class UserDatailServiceImpl implements UserDetailsService {
	
	@Resource(name = "userService")
	private UserService userService;

	@Override
	public UserDetails loadUserByUsername(String userId) throws UsernameNotFoundException {

		UserInfo uInfo = userService.selectUserInfo(userId);

		if (uInfo == null) {
			throw new UsernameNotFoundException("등록되지않은 아이디입니다.");
		}

		List<GrantedAuthority> roles = new ArrayList<GrantedAuthority>();

		List<String> sRoleList = userService.selectAuth(uInfo);

		for(String auth : sRoleList){
			roles.add(new SimpleGrantedAuthority(  auth ));
		}

		if(roles.size() >0) {
			long orgId = uInfo.getOrgId();     // 기관 아이디 가져옴 
			long contractId = uInfo.getContractId(); // 계약 아이디 가져옴 
			userService.updateUserLastLogin(uInfo);
			com.openmate.frmwrk.user.User user = new com.openmate.frmwrk.user.User(orgId, contractId, uInfo.getUserId(), uInfo.getPassword(), roles, uInfo.getServiceClss() );
			
			user.setExtInfo(uInfo.getExtInfo());
			
			return user;
		}
		return null;
	}

	public UserService getUserService() {
		return userService;
	}

	public void setUserService(UserService userService) {
		this.userService = userService;
	}
}
