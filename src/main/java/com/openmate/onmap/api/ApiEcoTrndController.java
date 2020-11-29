package com.openmate.onmap.api;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.openmate.onmap.main.dao.EcnmyTrndDao;

/*
 * 작성자: 김용현
 * 작성일자: 2018-04-02
 * 타이틀: 경제트렌드
 * 내용:
 *  1. 파일: ecnmyTrnd-mapper.xml
 *  2. sqlId
 *   <지역별 거래금액>
 *   - getEcnmyTrndAmtTotal: - 해당 시군구 총 거래금액
 *   - getEcnmyTrndAmtRank: 해당 시군구의 행정동 총 거래금액 리스트
 *   - getEcnmyTrndSalamt: 지도에 매핑시킬 데이터
 *   
 *   <업종별 거래금액>
 *   - getEcnmyTrndIndutyRank: 업종별 거래액 순위리스트
 *   - getEcnmyTrndInduty: 해당 시군구의 모든 업종비율(treemap)
 *   
 *   <지역별 유입인구 수>
 *   - getEcnmyTrndVisitrTotal: 행정동별 유입인구 총 수
 *   - getEcnmyTrndVisitrRank: 행정동별 유입인구 수
 *   - getEcnmyTrndVisitrCo: 지도에 매핑시킬 데이터
 *   
 *   <성/연령별 대표 유입인구>
 *   - getEcnmyTrndVisitrChartr: 유입인구 특성
 *   - getEcnmyTrndCtznChartr: 상주인구 특성
 *   - getEcnmyTrndCnt: 행정동 상권을 가장 많이 이용한 유입/상주인구 비율
 *   
 *   <지역별 유입인구 소비>
 *   - getEcnmyTrndCnsmpTotal: 유입인구 소비총액
 *   - getEcnmyTrndCnsmp: 행정동별 유입인구 소비액 리스트
 *   - getEcnmyTrndVisitrExpndtr: 지도에 매핑시킬 데이터
 *   
 *   <업종별 유입인구 소비특성>
 *   - getEcnmyTrndMostCommon: 활성업종 소비금액 리스트
 *   - getEcnmyTrndMostSpecialized: 특화업종 소비 특화지수
 *   
 *   <유입인구 소비시간>
 *   - getEcnmyTrndTimeCnt: 주요 소비시간 리스트
 *   - getEcnmyTrndTimeChart: 소비시간 리스트(상주 vs 유입)
 *   
 *   <유입인구 유입지역>
 *   - getEcnmyTrndCtyInflow: 주요 유입지역 리스트
 *   - getEcnmyTrndVisitrInflow: 지도와 매핑시킬 데이터
 */
@RestController
@RequestMapping("/ecoTrend")
public class ApiEcoTrndController {
	
	@Resource(name = "ecnmyTrndDao")
	private EcnmyTrndDao ecnmyTrndDao;
	
	@Resource(name = "apiAuthCheck")
	private ApiAuthCheck apiAuthCheck;
	
	/**
	 * 경제트랜드 데이터 조회 API
	 * 
	 * /ecoTrend/{theme}/{ctyCd}/{startDate}/{endDate}
	 * 
	 * @param theme -> all :전체, tradeAmt : 거래금액 전체, inPopProp:유입인구 특성전체, inPopCon: 유입인구 소비전체
	 * @param ctyCd 시군구 코드
	 * @param startDate 기준 시작일
	 * @param endDate 기준 종료일
	 * @param authKey : 인증키 
	 * @return defaultType : xml
	 */
	@RequestMapping(value="/{theme}/{ctyCd}/{startDate}/{endDate}", method=RequestMethod.GET)
	public Object getEcoTrend(@PathVariable String theme, @PathVariable String ctyCd, @PathVariable String startDate, @PathVariable String endDate, 
							  @RequestParam(defaultValue = "") String authKey, HttpServletRequest req) {
		
			Map<String, Object> rmap = new HashMap<String, Object>();
			HashMap<String, Object> param = new HashMap<String, Object>();
		    
			rmap = (HashMap<String, Object>) apiAuthCheck.checkApiAuth(req, ctyCd);
		    
			if((int)rmap.get("errorCode") == 0) {
				param.put("megaCd", ctyCd.substring(0, 2));		// 시도 코드
				param.put("ctyCd", ctyCd);						// 시군구 코드
				param.put("startDate", startDate);				// 기준 시작일
				param.put("endDate", endDate);					// 기준 종료일
				param.put("dataId", "rpt-trnd"); 				
				param.put("rgnClss", "H4");						// 행정동단위
				
				// 거래금액만 조회
				if("all".equals(theme) || "tradeAmt".equals(theme)) {	
					param.put("limitCnt", 10);
					rmap.put("rgnAmtTot", ecnmyTrndDao.getEcnmyTrndAmtTotal(param));				// 지역별 거래금액 - 해당 시군구 총 거래금액
					rmap.put("rgnAmtList", ecnmyTrndDao.getEcnmyTrndAmtRank(param));				// 지역별 거래금액 - 해당 시군구의 행정동 총 거래금액 리스트
					rmap.put("rgnAmtMap", ecnmyTrndDao.getEcnmyTrndSalamt(param));					// 지역별 거래금액 - 지도에 매핑시킬 데이터
					rmap.put("indutyAmtList", ecnmyTrndDao.getEcnmyTrndIndutyRank(param));			// 업종별 거래금액 - 업종별 거래액 순위리스트
					rmap.put("indutyAllAmtLate", ecnmyTrndDao.getEcnmyTrndInduty(param));			// 업종별 거래금액 - 해당 시군구의 모든 업종비율(treemap)
				}
				
				// 유입인구 특성만 조회
				if("all".equals(theme) || "inPopProp".equals(theme)) {		 
					rmap.put("rgnInPopCntTot", ecnmyTrndDao.getEcnmyTrndVisitrTotal(param));		// 지역별 유입인구 수 - 행정동별 유입인구 총 수
					rmap.put("rgnInPopCntList", ecnmyTrndDao.getEcnmyTrndVisitrRank(param));		// 지역별 유입인구 수 - 행정동별 유입인구 수
					rmap.put("rgnInPopCntMap", ecnmyTrndDao.getEcnmyTrndVisitrCo(param));			// 지역별 유입인구 수 - 지도에 매핑시킬 데이터
					
					rmap.put("inPopSexAge", ecnmyTrndDao.getEcnmyTrndVisitrChartr(param));			// 성/연령별 대표 유입인구 - 유입인구 특성
					rmap.put("citizenSexAge", ecnmyTrndDao.getEcnmyTrndCtznChartr(param));			// 성/연령별 대표 유입인구 - 상주인구 특성
					rmap.put("sexAgeRate", ecnmyTrndDao.getEcnmyTrndCnt(param));					// 성/연령별 대표 유입인구 - 행정동 상권을 가장 많이 이용한 유입/상주인구 비율 
				}
				
				// 유입인구 소비만 조회
				if("all".equals(theme) || "inPopCon".equals(theme)) {
					param.put("limitCnt", 10);
					rmap.put("rgnInPopCnsTot", ecnmyTrndDao.getEcnmyTrndCnsmpTotal(param));			// 지역별 유입인구 소비 - 유입인구 소비총액
					rmap.put("rgnInPopCnsList", ecnmyTrndDao.getEcnmyTrndCnsmp(param));				// 지역별 유입인구 소비 - 행정동별 유입인구 소비액 리스트
					rmap.put("rgnInPopCnsMap", ecnmyTrndDao.getEcnmyTrndVisitrExpndtr(param));		// 지역별 유입인구 소비 - 지도에 매핑시킬 데이터
					
					rmap.put("indutyInPopCommList", ecnmyTrndDao.getEcnmyTrndMostCommon(param));	// 업종별 유입인구 소비특성 - 활성업종 소비금액 리스트
					rmap.put("indutySpecGrd", ecnmyTrndDao.getEcnmyTrndMostSpecialized(param));		// 업종별 유입인구 소비특성 - 특화업종 소비 특화지수
					
					rmap.put("inPopCnTimeList", ecnmyTrndDao.getEcnmyTrndTimeCnt(param));			// 유입인구 소비시간 - 주요 소비시간 리스트
					rmap.put("inPopCtzCnTimeList", ecnmyTrndDao.getEcnmyTrndTimeChart(param));		// 유입인구 소비시간 - 상주인구 vs 유입인구의 수직 막대 그래프
					
					param.put("rgnClss", "H2");
					rmap.put("inPopRgnList", ecnmyTrndDao.getEcnmyTrndCtyInflow(param)); 				// 유입인구 유입지역 - 주요 유입지역 리스트
					rmap.put("inPopRgnMap", ecnmyTrndDao.getEcnmyTrndVisitrInflow(param));			// 유입인구 유입지역 - 지도와 매핑시킬 데이터
				}
				
				rmap.put("resultMsg", "Success");
				rmap.put("status", "success");
			}
		    return rmap;
	}
	
	/**
	 * 
	 * /{theme}/{sTheme}/{ctyCd}/{startDate}/{endDate}
	 * 
	 * @param theme -> tradeAmt: 거래금액 전체, inPopProp: 유입인구 특성전체, inPopCon: 유입인구 소비전체
	 * @param sTheme -> region: 지역별, induty: 업종별, sexAge: 성/연령별, time: 시간별, inRegion: 유입지역별
	 * @param ctyCd 시군구 코드
	 * @param startDate 기준 시작일
	 * @param endDate 기준 종료일
	 * @param authKey : 인증키 
	 * @return defaultType : xml
	 */
		
	@RequestMapping(value="/{theme}/{sTheme}/{ctyCd}/{startDate}/{endDate}", method=RequestMethod.GET)
	public Object getEcoTrendSub(@PathVariable String theme, @PathVariable String sTheme, @PathVariable String ctyCd, @PathVariable String startDate, @PathVariable String endDate, 
			  @RequestParam(defaultValue = "") String authKey, HttpServletRequest req) {
		
			HashMap<String, Object> param = new HashMap<String, Object>();
			Map<String, Object> rmap = new HashMap<String, Object>();
			
			rmap = (HashMap<String, Object>) apiAuthCheck.checkApiAuth(req, ctyCd);
		    
			if((int)rmap.get("errorCode") == 0) {
				param.put("megaCd", ctyCd.substring(0, 2));		// 시도 코드
				param.put("ctyCd", ctyCd);						// 시군구 코드
				param.put("startDate", startDate);				// 기준 시작일
				param.put("endDate", endDate);					// 기준 종료일
				param.put("dataId", "rpt-trnd"); 				
				param.put("rgnClss", "H4");						// 행정동단위
				
				if("tradeAmt".equals(theme) && "region".equals(sTheme)) {							// 지역별 거래금액만 조회
					rmap.put("rgnAmtTot", ecnmyTrndDao.getEcnmyTrndAmtTotal(param));				// 지역별 거래금액 - 해당 시군구 총 거래금액
					rmap.put("rgnAmtList", ecnmyTrndDao.getEcnmyTrndAmtRank(param));				// 지역별 거래금액 - 해당 시군구의 행정동 총 거래금액 리스트
					rmap.put("rgnAmtMap", ecnmyTrndDao.getEcnmyTrndSalamt(param));					// 지역별 거래금액 - 지도에 매핑시킬 데이터
				} else if("tradeAmt".equals(theme) && "induty".equals(sTheme)) {					// 업종별 거래금액만 조회
					param.put("limitCnt", 10);
					rmap.put("indutyAmtList", ecnmyTrndDao.getEcnmyTrndIndutyRank(param));			// 업종별 거래금액 - 업종별 거래액 순위리스트
					rmap.put("indutyAllAmtLate", ecnmyTrndDao.getEcnmyTrndInduty(param));			// 업종별 거래금액 - 해당 시군구의 모든 업종비율(treemap)
				} else if("inPopProp".equals(theme) && "region".equals(sTheme)) {					// 지역별 유입인구 수만 조회		 
					rmap.put("rgnInPopCntTot", ecnmyTrndDao.getEcnmyTrndVisitrTotal(param));		// 지역별 유입인구 수 - 행정동별 유입인구 총 수
					rmap.put("rgnInPopCntList", ecnmyTrndDao.getEcnmyTrndVisitrRank(param));		// 지역별 유입인구 수 - 행정동별 유입인구 수
					rmap.put("rgnInPopCntMap", ecnmyTrndDao.getEcnmyTrndVisitrCo(param));			// 지역별 유입인구 수 - 지도에 매핑시킬 데이터
				} else if("inPopProp".equals(theme) && "sexAge".equals(sTheme)) {					// (성/연령)별 대표 유입인구만 조회		 
					rmap.put("inPopSexAge", ecnmyTrndDao.getEcnmyTrndVisitrChartr(param));			// 성/연령별 대표 유입인구 - 유입인구 특성
					rmap.put("citizenSexAge", ecnmyTrndDao.getEcnmyTrndCtznChartr(param));			// 성/연령별 대표 유입인구 - 상주인구 특성
					rmap.put("sexAgeRate", ecnmyTrndDao.getEcnmyTrndCnt(param));					// 성/연령별 대표 유입인구 - 행정동 상권을 가장 많이 이용한 유입/상주인구 비율 
				} else if("inPopCon".equals(theme) && "region".equals(sTheme)) {					// 지역별 유입인구 소비만 조회		
					param.put("limitCnt", 10);
					rmap.put("rgnInPopCnsTot", ecnmyTrndDao.getEcnmyTrndCnsmpTotal(param));			// 지역별 유입인구 소비 - 유입인구 소비총액
					rmap.put("rgnInPopCnsList", ecnmyTrndDao.getEcnmyTrndCnsmp(param));				// 지역별 유입인구 소비 - 행정동별 유입인구 소비액 리스트
					rmap.put("rgnInPopCnsMap", ecnmyTrndDao.getEcnmyTrndVisitrExpndtr(param));		// 지역별 유입인구 소비 - 지도에 매핑시킬 데이터
				} else if("inPopCon".equals(theme) && "induty".equals(sTheme)) {					// 업종별 유입인구 소비특성만 조회		
					rmap.put("indutyInPopCommList", ecnmyTrndDao.getEcnmyTrndMostCommon(param));	// 업종별 유입인구 소비특성 - 활성업종 소비금액 리스트
					rmap.put("indutySpecGrd", ecnmyTrndDao.getEcnmyTrndMostSpecialized(param));		// 업종별 유입인구 소비특성 - 특화업종 소비 특화지수
				} else if("inPopCon".equals(theme) && "time".equals(sTheme)) {						// 유입인구 소비시간만 조회		
					rmap.put("inPopCnTimeList", ecnmyTrndDao.getEcnmyTrndTimeCnt(param));			// 유입인구 소비시간 - 주요 소비시간 리스트
					rmap.put("allInPopCnTimeList", ecnmyTrndDao.getEcnmyTrndTimeChart(param));		// 유입인구 소비시간 - 소비시간 리스트(상주 vs 유입)
				} else if("inPopCon".equals(theme) && "inRegion".equals(sTheme)) {					// 유입인구 유입지역만 조회		
					param.put("rgnClss", "H2");
					rmap.put("inPopRgnList", ecnmyTrndDao.getEcnmyTrndCtyInflow(param)); 				// 유입인구 유입지역 - 주요 유입지역 리스트
					rmap.put("inPopRgnMegaList", ecnmyTrndDao.getEcnmyTrndMegaInflow(param)); 				// 유입인구 유입지역 - 주요 유입지역 리스트
					rmap.put("inPopRgnMap", ecnmyTrndDao.getEcnmyTrndVisitrInflow(param));			// 유입인구 유입지역 - 지도와 매핑시킬 데이터
				} else {																			// 잘못된 url 호출일 때
					rmap.put("resultMsg", "Invalid URL Call");
					rmap.put("errorCode", 4);
				}
				
				rmap.put("resultMsg", "Success");
				rmap.put("status", "success");
			}
		    
		    return rmap;
	}
	
}
