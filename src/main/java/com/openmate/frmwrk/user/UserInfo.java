package com.openmate.frmwrk.user;

public class UserInfo {
	/**
	 * 수정자: 김용현
	 * 수정일: 2018.10.15
	 * 내용: 서비스 유형 추가
	 */
	private int orgId = 0;       // 기관 아이디
	private int contractId = 0;       // 기관 아이디
	private int serviceClss = 0;       // 서비스 유형 
	private String userId ;         // 유저 아이디 
	private String userName ;       // 유저명 
	private String password;        // 비밀번호
	private Object extInfo = null;  // 세부정부 

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public Object getExtInfo() {
		return extInfo;
	}

	public void setExtInfo(Object extInfo) {
		this.extInfo = extInfo;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
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

	public int getServiceClss() {
		return serviceClss;
	}

	public void setServiceClss(int serviceClss) {
		this.serviceClss = serviceClss;
	}

	
}
