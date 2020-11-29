package com.openmate.onmap.main.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository(value = "ecnmy24Dao")
public interface Ecnmy24Dao {

	
	/**
	 * 공통
	 */
	public String getLastStdrDate(Map<String, Object> param);		// 최신 년월
	public String getAdmiCount(Map<String, Object> param);			// 읍면동 수
	
	
	
	/**
	 * page01
	 **/
	// 카드사 - 01
	public String getTotalAmt(Map<String, Object> param);		// 총 거래금액 - text
	public String getLastMonRate(Map<String, Object> param);	// 전월대비 거래금액 비율 - text
	public String getLastYearRate(Map<String, Object> param);	// 전년동기 대비 거래금액 비율 - text
	public List<Map> getTotalAmtChart(Map<String, Object> param);	// 최신 1년치 거래금액 그래프 - chart
	public List<Map> getTotalAmtMap(Map<String, Object> param);	// 총거래금액 주제도
	
	// 통신사 - 01
	public String getTotalFloat(Map<String, Object> param);		// 총 유동인구 수 - text
	public String getLastMonFloat(Map<String, Object> param);	// 전월대비 유동인구 비율 - text
	public String getLastYearFloat(Map<String, Object> param);	// 전년동기 대비 유동인구 비율 - text
	public List<Map> getTotalFloatChart(Map<String, Object> param);	// 최신 1년치 유동인구 그래프 - chart
	public List<Map> getTotalFloatMap(Map<String, Object> param);	// 총 유동인구 수 주제도
	
	/**
	 * page02
	 **/
	// 카드사 - 02 
	public String getAmtGenderAge(Map<String, Object> param);		// 성/연령별 대표인구 소비인구 특성 - text
	public Map<String, Object> getAmtGenderAgeChart(Map<String, Object> param);		// 성/연령별 대표인구 소비인구 특성 - chart
	
	// 통신사 - 02
	public String getFloatGenderAge(Map<String, Object> param);		// 성/연령별 대표인구 유동인구 특성 - text
	public Map<String, Object> getFloatGenderAgeChart(Map<String, Object> param);		// 성/연령별 대표인구 유동인구 특성 - chart
	
	// 카드사 & 통신사 
	public Map<String, Object> getAdmiStateTxt(Map<String, Object> param);	// 읍면동 간 비교 (주민등록인구, 총 유동인구, 총 거래금액, 총 거래량 - text)
	public Map<String, Object> getAdmiStateTxt2(Map<String, Object> param);	// 읍면동 간 비교 (주민등록인구, 총 유동인구, 총 거래금액, 총 거래량 - text2) - 시군구
	public List<Map> getAdmiStateList(Map<String, Object> param);	// 읍면동 간 비교 ( list )
	
	/**
	 * old
	 */
	public List<Map> getEcnmy24TimeGraph(Map<String, Object> param);
	public List<Map> getEcnmy24Map(Map<String, Object> param);
	public List<Map> getEcnmy24MapGraph(Map<String, Object> param);
	public List<Map> getEcnmy24MapLegend(Map<String, Object> param);
	public List<Map<String,Object>> excelData(Map<String, Object> param);	
	public List<Map<String,Object>> excelTotalData(Map<String, Object> param);
	
}
