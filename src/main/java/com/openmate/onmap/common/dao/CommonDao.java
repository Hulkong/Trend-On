package com.openmate.onmap.common.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository(value = "commonDao")
public interface CommonDao {
	
	// 해당 지역 shape 가져오기
	public List<Map> getRegion();
	
	// 공통코드 가져오기
	public List<Map<String, Object>> getCommonCodeList(Map<String,Object> param);
	
	// 지역선택 option
	public List<Map> getAreaSelectOption(Map<String, Object> param);
	
	// 업종선택 option ( api용 )
	public List<Map> getUpjong2SelectOption();
	
	// 이벤트효과 업종선택 option ( api용 )
	public List<Map> getEffUpjong2SelectOption(Map<String, Object> param);
	
	// 데이터 범위 가져오기
	public Map getDateRange(Map<String, Object> param);
	
	// 행정구역 코드 가져오기
	public List<Map<String, Object>> getRegionList(Map<String, Object> param);
		
	// 공통코드 가져오기
	public List<Map<String, Object>> getCommonCode();

	// 동/읍(1), 면(0) 구분 flag 가져오기
	public String getEvntFlg(Map<String, Object> param);
	
}
