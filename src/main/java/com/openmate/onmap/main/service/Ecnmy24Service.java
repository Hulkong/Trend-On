package com.openmate.onmap.main.service;

import java.util.Map;

import org.json.simple.JSONObject;

public interface Ecnmy24Service {
	
	public JSONObject searchNewsList(String search_key, int display);	// 선택한 시군구의 기사 가져오기
	
	public Map<String, Object> getLastStdrDate(Map<String,Object> param);	// 기준 년월 가져오기

}
