package com.openmate.onmap.main.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository(value = "eventEffectDao")
public interface EventEffectDao {

	/** 
	 * 이벤트 효과 공통 쿼리
	 **/
	public List<Map> getAdmiCnt(Map<String, Object> param);						// 주변행정동 개수가져오기
	public String getFlg(Map<String, Object> param);							// 동/읍(1), 면(0) 구분값 가져오기
	public List<Map> admiUpjongList(Map<String, Object> param);					// 주변행정동 리스트 가져오기
	
	/** 
	 * 시계열 그래프
	 **/
	public List<Map> getEventEffectGraphData(Map<String, Object> param);	// 시계열 그래프 - 소비금액
	public List<Map> getEventEffectGraphData02(Map<String, Object> param);	// 시계열 그래프 - 유동인구
	
	/** 
	 * page01
	 **/
	// 카드 데이터 - 01
	public Map<String, Object> getThisAmtChnge(Map<String, Object> param);	// 총 경제효과 변화 ( 변화율, 평상시 평균, 이벤트기간 평균) - text
																			// page2. 선택한 행정동의 거래금액기준 경제효과 변화율  - text
	public List<Map> getEventEffectThisAmtList(Map<String, Object> param);	// 선택 이벤트기간과 앞뒤 총 5주간의 경제 변화 리스트 - chart
	public List<Map> getEventEffectLastAmtList(Map<String, Object> param);	// 선택 비교기간과 앞뒤 총 5주간의 경제 변화 리스트 - chart
	
	
	// 통신사 데이터 - 01
	public Map<String, Object> getThisFloatChnge(Map<String, Object> param);	// 유동인구 변화(총 유동인구 변화률, 평상시평균, 이벤트기간평균) - text
	public List<Map> getEventEffectThisFloatList(Map<String, Object> param);	// 선택 이벤트기간과 앞뒤 총 5주간의 유동인구 변화 리스트  - chart
	public List<Map> getEventEffectLastFloatList(Map<String, Object> param);	// 선택 비교기간과 앞뒤 총 5주간의 유동인구 변화 리스트 - chart
	
	/** 
	 * page02
	 **/
	//카드 데이터 - 02
	public List<Map> getEventSalamtChnge(Map<String,Object> param);			// 주변지역 경제효과( 거래금액/ 거래량 ) - 주제도
	//getThisAmtChnge (page01.에서 사용)	- text
	public Map<String, Object> getThisCntChnge(Map<String, Object> param);	// 주변지역 경제효과 ( 선택한 행정동의 거래량 기준 경제효과 변화율) - text
	public List<Map> getMxmIncrsAmt(Map<String, Object> param);				// 주변지역 경제효과 ( 주변지역의 거래금액 기준 경제효과 변화율 리스트) - text
	public List<Map> getMxmIncrsRate(Map<String, Object> param);			// 주변지역 경제효과 ( 주변지역의 거래량 기준 경제효과 변화율 리스트) - text

	
	// 통신사 데이터 - 02
	//getThisFloatChnge (page01.에서 사용) - text
	public List<Map> getRegionFloatTxt(Map<String, Object> param);			// 주변지역 경제효과 ( 주변지역의 유동인구 변화율 리스트3) - text
	public List<Map> getRegionFloatMap(Map<String, Object> param);			// 주변지역 경제효과 ( 주변지역의 유동인구 변화율 리스트) - 주제도
	
	
	/** 
	 * page03
	 **/
	//카드 데이터 - 03
	public String getEventAmtChartr(Map<String, Object> param);	// 소비인구 특성 (text)
	public Map<String, Object> getEventSaleList(Map<String, Object> param);	// 소비인구 특성 (chart)
	
	public List<Map> getUpjongAmtChnge(Map<String,Object> param);		// 업종별 경제효과(거래금액) top1
	public List<Map> getUpjongRateChnge(Map<String,Object> param);		// 업종별 경제효과(거래량) top1
	public List<Map> getUpjongAmtChngeGraph(Map<String,Object> param);	// 업종별 경제효과(거래금액) 그래프
	public List<Map> getUpjongRateChngeGraph(Map<String,Object> param); // 업종별 경제효과(거래량) 그래프
		
	
	// 통신사 데이터 - 03
	public String getEventFloatChartr(Map<String, Object> param);		// 유동인구 특성 (text)
	public Map<String, Object> getEventFloatList(Map<String, Object> param);	// 소비인구 특성 (chart)
	
	
	
	/** 
	 * page04
	 **/
	// 카드사 데이터 - 04
	public String getEventVisitrChartr(Map<String,Object> param);	// 유입 소비인구 성/연령별 특성 (text)
	public List<Map> getInflowSaleList(Map<String, Object> param);	// 유입 소비인구 성/연령별 특성 (chart)
	
	
	// 통신사 데이터 - 04
	public String getEventInflowFloatCnt(Map<String, Object> param);	// 선택한 행정동의 유입 유동인구 수 (text) 
	public List<Map> getEventInflowFloatList(Map<String, Object> param);	// 주변 행정동의 유입 유동인구 수 (list) 
	public List<Map> getEventInflowFloatMap(Map<String, Object> param);	// 주변 행정동의 유입 유동인구 수 (주제도) 

	public String getEventInflowFloatTxt(Map<String, Object> param);	// 유입 유동인구 성/연령별 특성 (text)
	public List<Map> getInflowFloatList(Map<String, Object> param);		// 유입 유동인구 성/연령별 특성 (chart)
	
	
	/** 
	 * page05
	 **/
	// 카드사 데이터 - 05
	public List<Map> getEventVisitrCnsmpTime(Map<String,Object> param);	// 유입인구 소비시간 특성 (text)
	
	// 통신사 데이터 - 05
	public List<Map> getInflowTimeText(Map<String,Object> param);	// 유입인구 유동시간 특성 (text)
	public List<Map> getInflowTimeChart(Map<String,Object> param);	// 유입인구 유동시간 특성 (chart)

	public String getInflowRegionTxt(Map<String, Object> param);	// 유입 유동인구 유입지역 (text)
	public List<Map> getInflowRegionList(Map<String, Object> param);		// 유입 유동인구 유입지역 (list)
	public List<Map> getInflowRegionMap(Map<String, Object> param);		// 유입 유동인구 유입지역 (주제도)
	
	
	/** 
	 * 지도 범례 ( 사용안해도 됨 ) 
	 **/
	public List<Map> getSalamtChngeLegend(Map<String, Object> param);			
	public List<Map> getExpndtrChngeLegend(Map<String, Object> param);
	public List<Map> getExpndtrRateChngeLegend(Map<String, Object> param);
	public List<Map> getVisitrCntChngeLegend(Map<String, Object> param);
	public List<Map> getVisitrCnsmpTimeChngeLegend(Map<String, Object> param);
	
	
	
	
	
	/**
	 * API에서 사용
	 **/
	// 2page
	public List<Map> getAreaUpjongAmtChnge(Map<String,Object> param);		// 주변지역 업종별 변화 (매출액 기준) list
	public List<Map> getThisAreaUpjongAmtChnge(Map<String,Object> param);	// 주변지역 업종별 - 해당지역  (매출액 기준)
	public List<Map> getThisAreaUpjongRateChnge(Map<String,Object> param);	// 주변지역 업종별 - 해당지역 (거래량 기준)
	public List<Map> getAreaUpjongRateChnge(Map<String,Object> param);	// 주변지역 업종별 변화 (거래량 기준) list
	public List<Map> getEventExpndtrChnge(Map<String,Object> param);	// 거래액(금액) - 지도
	
	// 3page
	public List<Map> getEventExpndtrRateChnge(Map<String,Object> param);	// 거래액(비율) - 지도
	
	// 4page
	public int getEventVisitrCnt(Map<String,Object> param);	// 방문객 총 수
	public List<Map> getEventVisitrCntList(Map<String,Object> param);	// 방문객 순위
	public String getEventCtznChartr(Map<String,Object> param);	// 시민 특성
	public List<Map> getEventVisitrCtznGraph(Map<String,Object> param);	// 지역시민 vs 방문객 그래프
	public List<Map> getEventVisitrCntChnge(Map<String,Object> param);	// 방문객수 - 지도
	
	
	// 6page
	public List<Map> getEventVisitrInflow(Map<String,Object> param); // 방문객 유입지역
	public List<Map> getCntTimeGraph(Map<String,Object> param);	// 방문객 vs 시민 그래프
	public List<Map> getEventVisitrCnsmpTimeChnge(Map<String,Object> param);	// 방문객 소비시간 - 지도
	
	// 사용안함
	public Map getEventEffectGraphDateRange(Map<String, Object> param);	// 시계열 그래프 범위 가져오기
	
}
