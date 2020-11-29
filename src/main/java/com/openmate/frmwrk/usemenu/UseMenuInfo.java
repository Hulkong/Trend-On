package com.openmate.frmwrk.usemenu;

import java.io.Serializable;

public class UseMenuInfo implements Serializable {

	private static final long serialVersionUID = -7609333629745972068L;
	
	
	private int orgId;      // 기관 아이디 
	private int contractId;    // 계약 아이디 
	private String userId;     // 유저 아이디 
	private String url;        // 접속 url 
	private String menuNm;     // 접근 메뉴 
	private String userIp;     // 접근 아이피
	private String logMsg;  // 로그메시지
	
	
	public String getUserId() {
		return userId;
	}
	
	public void setUserId(String userId) {
		this.userId = userId;
	}
	
	public String getUrl() {
		return url;
	}
	
	public void setUrl(String url) {
		this.url = url;
	}
	
	public String getMenuNm() {
		return menuNm;
	}
	
	public void setMenuNm(String menuNm) {
		this.menuNm = menuNm;
	}
	
	public String getUserIp() {
		return userIp;
	}
	
	public void setUserIp(String userIp) {
		this.userIp = userIp;
	}
	
	public int getOrgId() {
		return orgId;
	}
	
	public void setOrgId(int orgId) {
		this.orgId = orgId;
	}
	
	public int getContractId() {
		return contractId;
	}
	
	public void setContractId(int contractId) {
		this.contractId = contractId;
	}

	public String getLogMsg() {
		return logMsg;
	}

	public void setLogMsg(String logMsg) {
		this.logMsg = logMsg;
	}
}
