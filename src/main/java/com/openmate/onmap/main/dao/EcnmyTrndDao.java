package com.openmate.onmap.main.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository(value = "ecnmyTrndDao")
public interface EcnmyTrndDao {
	
	/**
	 * 시계열 그래프 
	 **/
	public List<Map> getEcnmyTrndGraphData(Map<String, Object> param);	//시계열 그래프 - 소비금액
	public List<Map> getEcnmyTrndGraphData02(Map<String, Object> param);	// 시계열 그래프 - 유동인구
	
	
	/**
	 * page01
	 **/
	// 카드 데이터 - 01
	public String getEcnmyTrndAmtTotal(Map<String, Object> param);		// 지역별 거래총액
	public List<Map> getEcnmyTrndAmtRank(Map<String, Object> param);	// 지역별 거래총액 순위리스트
	public List<Map> getEcnmyTrndSalamt(Map<String, Object> param);		// 지역별 거래금액 - 주제도
	//getEcnmyTrndIndutyRank 
	
	// 통신사 데이터 - 01
	public String getEcnmyTrndFloatTotal(Map<String, Object> param);		// 지역별 유동인구 총수
	public List<Map> getEcnmyTrndFloatRank(Map<String, Object> param);	// 지역별 유동인구 순위리스트
	public List<Map> getEcnmyTrndFloat(Map<String, Object> param);		// 지역별 유동인구 수 - 주제도 
	
	
	/**
	 * page02
	 **/
	// 카드 데이터 - 02
	public String getAllAmtChartr(Map<String, Object> param);	// 소비인구 특성 (text)
	public Map<String,Object> getEcnmyTrndAllSaleList(Map<String, Object> param);	// 성/연령별 대표 소비인구 그래프(chart)
	public List<Map> getEcnmyTrndInduty(Map<String, Object> param);		// 업종별 거래금액(트리맵)
	public List<Map> getEcnmyTrndIndutyRank(Map<String, Object> param);		// 업종별 거래액 순위리스트
	
	// 통신사 데이터 - 02
	public String getAllFloatChartr(Map<String, Object> param);		// 유동인구 특성 (text)
	public Map<String,Object> getEcnmyTrndAllFloatList(Map<String, Object> param);	// 성/연령별 대표 유동인구 그래프(chart)
	 
	
	/**
	 * page03
	 **/
	// 카드 데이터 - 03
	public String getEcnmyTrndCnsmpTotal(Map<String, Object> param);	// 유입인구 소비 총액
	public List<Map> getEcnmyTrndCnsmp(Map<String, Object> param);		// 지역별 소비금액 리스트
	public List<Map> getEcnmyTrndVisitrExpndtr(Map<String, Object> param);	// 지역별 유입인구 소비 - 주제도
	
	// 통신사 데이터 - 03
	public String getFlowFloatTxt(Map<String, Object> param);		// 유입 유동인구 수 (총수)
	public List<Map> getFlowFloatList(Map<String, Object> param);	// 유입 유동인구 수 (지역별 리스트)
	public List<Map> getFlowFloatMap(Map<String, Object> param);	// 유입 유동인구 수 (지역별 리스트 - 주제도)
	
	
	/**
	 * page04
	 **/
	// 카드 데이터 - 04
	public String getInflowAmtChartr(Map<String, Object> param);	// 소비인구 특성 (text)
	public Map<String,Object> getEcnmyTrndInflowSaleList(Map<String, Object> param);	// 성/연령별 대표 소비인구 그래프(chart)
	
	public List<Map> getEcnmyTrndMostCommon(Map<String, Object> param);		// 활성업종 그래프
	public List<Map> getEcnmyTrndMostSpecialized(Map<String, Object> param);	// 특화업종
	
	// 통신사 데이터 - 04
	public String getInflowFloatChartr(Map<String, Object> param);		// 유동인구 특성 (text)
	public Map<String,Object> getEcnmyTrndInflowFloatList(Map<String, Object> param);	// 성/연령별 대표 유동인구 그래프(chart)
		
	
	/**
	 * page05
	 **/
	public String getInflowAmtTimeChartr(Map<String, Object> param);	// 주요 유입 소비시간
	public String getInflowFloatTimeChartr(Map<String, Object> param);	// 주요 유입 방문시간
	public List<Map> getEcnmyTrndInflowTimeChart(Map<String, Object> param);	// 주요 유입 방문 & 소비 시간 그래프
	
	public String getCtyInflowChartr(Map<String, Object> param);	// 주요 유입지역 top1
	public List<Map> getCtyInflowList(Map<String, Object> param);	// 주요 유입지역 top3
	public List<Map> getCtyInflowMap(Map<String, Object> param);	// 주요 유입지역 주제도
	
		
	/**
	 * 지도 범례 ( 사용안해도 됨 ) 
	 **/
	public List<Map> getSalamtLegend(Map<String, Object> param);
	public List<Map> getVisitrCoLegend(Map<String, Object> param);
	public List<Map> getVisitrExpndtrLegend(Map<String, Object> param);
	public List<Map> getVisitrInflowLegend(Map<String, Object> param);
		
	/**
	 * API에서 사용
	 **/
	public List<Map> getEcnmyTrndMegaInflow(Map<String, Object> param);	
	
	// page 02
	public String getEcnmyTrndVisitrTotal(Map<String, Object> param);		// 유입 소비인구 거래금액 총수
	public List<Map> getEcnmyTrndVisitrRank(Map<String, Object> param);		// 지역별 유입 소비인구수 리스트
	public List<Map> getEcnmyTrndVisitrCo(Map<String, Object> param);	// 지역별 유입 소비인구 수 - 주제도
	
	public List<Map> getEcnmyTrndVisitrChartr(Map<String, Object> param);	// 유입인구 성/연령 특성 (최대)
	public List<Map> getEcnmyTrndCtznChartr(Map<String, Object> param);	//  상주인구 성/연령 특성 (최대)
	public List<Map> getEcnmyTrndCnt(Map<String, Object> param);	// 유입인구 성/연령 특성그래프
	
	// page03
//	public List<Map> getEcnmyTrndCnsmpInduty(Map<String, Object> param); // (사용안함)
	
	// page 04
	public List<Map> getEcnmyTrndTimeChart(Map<String, Object> param);	// 시간별 상주인구 vs 유입인구
	public List<Map> getEcnmyTrndTimeCnt(Map<String, Object> param);	// 주요 소비시간 리스트	
	public List<Map> getEcnmyTrndCtyInflow(Map<String, Object> param);		// 주요 유입지역 리스트
	public List<Map> getEcnmyTrndVisitrInflow(Map<String, Object> param);	// 유입인구 유입지역 - 주제도

	
	
}
