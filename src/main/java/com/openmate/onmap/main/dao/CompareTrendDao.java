package com.openmate.onmap.main.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository(value = "compareTrendDao")
public interface CompareTrendDao {

	public List<Map<String, Object>> getCompareRegion(Map<String, Object> param);			// 시군구  도형가져오기
	public List<Map<String, Object>> getCompareMegaShape(Map<String, Object> param);		// 시도 도형가져오기
	
	public String getCompareAvgAmt(Map<String, Object> param);								// 1.1 시군구 평균 거래금액
	public List<Map<String, Object>> getCompareRegionLv(Map<String, Object> param);			// 1.2 시군구평균 매출 vs 선택 시군구 매출 비교 bar chart
	public String getMegaDiff(Map<String, Object> param);									// 1.3 시도평균 대비 시군구 평균
	
	public List<Map<String, Object>> getCompareBestUpjong(Map<String, Object> param);		// 2.1 시군구 평균 최대매출업종 리스트(3)
	public List<Map<String, Object>> getCompareInduty(Map<String, Object> param);			// 2.2  업종별 거래금액 treemap  그래프

	public String getCompareAvgCnt(Map<String, Object> param);								// 3.1 시군구 평균 유입인구 수 
	public List<Map<String, Object>> getCompareCntRegionLv(Map<String, Object> param);		// 3.2  시군구평균 유입인구 수 vs 선택 시군구 유입인구 수 비교 bar chart
	public String getMegaDiffCnt(Map<String, Object> param);								// 3.3  시도평균 대비 시군구 평균 유입인구 수

	public String getCompareAgeGender(Map<String, Object> param);							// 4.1  시군구 성/연령별 대표 유입, 상주인구 유형
	public Map<String, Object> getCompareManType(Map<String, Object> param);				// 4.2  시군구 성/연령별 대표 유입, 상주인구 bar 그래프	

	public String getCompareVisitAmt(Map<String, Object> param);							// 5.1  시군구 유입인구 소비총액
	public List<Map<String, Object>> getCompareAmtRegionLv(Map<String, Object> param);		// 5.2  시군구 성/연령별 대표 유입, 상주인구 bar 그래프	
	public String getMegaDiffAmt(Map<String, Object> param);								// 5.3  시도평균 대비 시군구 평균 유입인구 소비 금액

	public List<Map<String, Object>> getCompareActUpjong3(Map<String, Object> param);		// 6.1  업종별 유입인구 소비특성(활성업종 리스트)  	 	
	public List<Map<String, Object>> getCompareActUpjong10(Map<String, Object> param);		// 6.2  업종별 유입인구 소비특성(활성업종 그래프)  	 	
	
	public String getCompareBestTime(Map<String, Object> param);							// 7.1  유입인구 주요 소비시간대  	 	
	public List<Map<String, Object>> getCompareBestTimeList(Map<String, Object> param);		// 7.2  유입인구 주요 소비시간대 리스트(3) 	
	public Map<String, Object> getCompareBestTimeListAll(Map<String, Object> param);	// 7.3  유입인구 주요 소비시간대 막대그래프 	 	

	public String getCompareBestInflow(Map<String, Object> param);							// 8.1  유입인구 주요 유입지역	
	public List<Map<String, Object>> getCompareBestInflowList(Map<String, Object> param);	// 8.2  유입인구 주요 유입지역 리스트(3)  	 	
	public List<Map<String, Object>> getCompareBestInflowMap(Map<String, Object> param);	// 8.3  유입인구 주요 유입지역 지도 	
}