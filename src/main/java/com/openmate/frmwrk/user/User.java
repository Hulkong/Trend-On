package com.openmate.frmwrk.user;

import java.util.Collection;
import java.util.List;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

public class User implements UserDetails{

	/**
	 *
	 */
	private static final long serialVersionUID = -3641926958153468496L;


	private long orgId = 0;
	private long contractId = 0;
	private String userId;
	private String password;
	private int serviceClss = 0;   // 서비스유형


	private List<GrantedAuthority> authorities;
	private boolean accountNonExpired = true;
	private boolean accountNonLocked = true;
	private boolean credentialsNonExpired = true;
	private boolean enabled = true;

	private boolean isInitPasswd = false;
	private Object extInfo = null;
	
	public User(Long orgId, Long contractId, String userId , String pw, List<GrantedAuthority> gList, int serviceClss) {
        this.setUserId(userId);
        this.orgId = orgId;
    		this.contractId = contractId;
		this.password = pw;
		this.authorities = gList;
		this.serviceClss = serviceClss;
	}
	
	public Object getExtInfo() {
		return extInfo;
	}

	public void setExtInfo(Object extInfo) {
		this.extInfo = extInfo;
	}

	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {
		// TODO Auto-generated method stub
		return  this.authorities;
	}

	@Override
	public String getPassword() {
		return password;
	}

	@Override
	public String getUsername() {
		return userId;
	}

	@Override
	public boolean isAccountNonExpired() {
		return this.accountNonExpired;
	}

	@Override
	public boolean isAccountNonLocked() {
		return this.accountNonLocked;
	}

	@Override
	public boolean isCredentialsNonExpired() {
		return this.credentialsNonExpired;
	}

	@Override
	public boolean isEnabled() {
		return this.enabled;
	}

	public void setUsername(String userId) {
		this.userId = userId;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public void setAuthorities(List<GrantedAuthority> authorities) {
		this.authorities = authorities;
	}

	public void setAccountNonExpired(boolean accountNonExpired) {
		this.accountNonExpired = accountNonExpired;
	}

	public void setAccountNonLocked(boolean accountNonLocked) {
		this.accountNonLocked = accountNonLocked;
	}

	public void setCredentialsNonExpired(boolean credentialsNonExpired) {
		this.credentialsNonExpired = credentialsNonExpired;
	}

	public void setEnabled(boolean enabled) {
		this.enabled = enabled;
	}

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

	public boolean isInitPasswd() {
		return isInitPasswd;
	}

	public void setInitPasswd(boolean isInitPasswd) {
		this.isInitPasswd = isInitPasswd;
	}
	
	public long getOrgId() {
		return orgId;
	}
	
	public void setOrgId(long orgId) {
		this.orgId = orgId;
	}
	
	public long getContractId() {
		return contractId;
	}
	
	public void setContractId(long contractId) {
		this.contractId = contractId;
	}

	public int getServiceClss() {
		return serviceClss;
	}
	
	public void setServiceClss(int serviceClss) {
		this.serviceClss = serviceClss;
	}
}
