package com.openmate.onmap.admin.service;

import java.util.Map;

public interface AdminService {
	
	public int setOrgContract(Map<String,Object> param);		// 기관 등록
	public int modifiedOrg(Map<String,Object> param);		// 기관 정보 수정
	public int delOrgImage(Map<String,Object> param);		// 기관 정보 수정 > 이미지 수정

}
