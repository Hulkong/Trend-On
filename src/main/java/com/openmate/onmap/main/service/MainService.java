package com.openmate.onmap.main.service;

import java.util.Map;

public interface MainService {
	
	public Map<String,Object> getCrfMainData(Map<String,Object> param); // 중간대문에 필요한 데이터 가져오기
	
	public Map<String,Object> getCrfMainFloat(Map<String,Object> param); // 중간대문에 필요한 데이터 가져오기(유동인구)
	
	public Map<String,Object> getDates(Map<String,Object> param); 		// 서비스 유형가져오기

}
