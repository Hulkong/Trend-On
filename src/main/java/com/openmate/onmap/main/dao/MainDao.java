package com.openmate.onmap.main.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository(value = "mainDao")
public interface MainDao {

	public Map<String,Object> getDates(Map<String, Object> param); 		// 마지막 데이터의 날짜 와 지난달가져오기
	public Map<String,Object> getTotalAmt(Map<String, Object> param); 	// 전체 매출액 가져오기
	public Map<String,Object> getNoOneDong(Map<String, Object> param); 	// 일등 행정동 찾기 
	public String getadmiRate(Map<String, Object> param); 				// 일등 행정동의 전월 대비
	public String getCtyTotData(Map<String, Object> param); 			// 해당 시군구의 전체 누적 데이터 수
	public String getMonTotData(Map<String, Object> param); 			// 해당 시군구의 마지막 업뎃 데이터 수
	
	
	public Map<String,Object> getTotalFloat(Map<String, Object> param); // 전체 유동인구 수 가져오기
	public Map<String,Object> getFloatDong(Map<String, Object> param); 	// 선택 시군구중 가장 유동인구 수가 많은 행정동
	public String getAdmiFloatRate(Map<String, Object> param); 			// 선택 시군구중 가장 유동인구 수가 많은 행정동의 전월대비 유동인구 비율
	
}
