package com.openmate.onmap.api;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.openmate.onmap.main.dao.EventEffectDao;

/*
 * 작성자: 김용현
 * 작성일자: 2018-04-02
 * 타이틀: 이벤트효과
 * 내용:
 *   1.파일: eventEffect-mapper.xml
 *   2.sqlId
 *    <행정동 총 경제효과>
 *   - 평상시 대비 매출액 비율 == 주변지역 총 경제효과 - 행정동 매출액 기준비율: getThisAmtChnge
 *   - 이번연도 라인차트 데이터: getEventEffectThisAmtList
 *   - 이전연도 라인차트 데이터: getEventEffectLastAmtList 
 *   
 *    <주변지역 총 경제효과>
 *   - 행정동 거래량 기준비율: getThisCntChnge
 *   - 행정동 매출액 기준 리스트: getMxmIncrsAmt
 *   - 행정동 거래량 기준 리스트: getMxmIncrsRate
 *   - 지도에 매핑시킬 데이터: getEventSalamtChnge
 *   
 *    <행정동 업종별 경제효과>
 *   - 매출액 기준: upjongAmtChnge
 *   - 거래량 기준: upjongRateChnge
 *   - 매출액 기준 hoz그래프 데이터: getUpjongAmtChngeGraph
 *   - 거래량 기준 hoz그래프 데이터: getUpjongRateChngeGraph
 *   
 *    <주변지역 업종별 경제효과>
 *   - 해당 행정동 최대 증가 업종(매출액 기준): getThisAreaUpjongAmtChnge
 *   - 매출액 기준 리스트: getAreaUpjongAmtChnge
 *   - 지도에 매핑시킬 데이터(매출액 기준), 업종코드: getEventExpndtrChnge
 *   
 *    <주변지역 업종별 경제효과>
 *   - 해당 행정동 최대 증가 업종(거리량 기준): getThisAreaUpjongRateChnge
 *   - 거래량 기준 리스트: getAreaUpjongRateChnge
 *   - 지도에 매핑시킬 데이터(거래량 기준): getEventExpndtrRateChnge
 *   
 *    <지역별 유입인구 수>
 *   - 해당 행정동 유입인구 수: getEventVisitrCnt
 *   - 지역별 유입인구 리스트: getEventVisitrCntList
 *   - 지도에 매핑시킬 데이터: getEventVisitrCntChnge
 *   
 *    <(성/연령)별 대표 유입인구>
 *   - 해당 행정동 상권을 가장 많이 이용한 유입인구: getEventVisitrChartr
 *   - 해당 행정동 상권을 가장 많이 이용한 상주인구: getEventCtznChartr
 *   - 상주인구 vs 유입인구의 수직 막대 그래프 : getEventVisitrCtznGraph
 *   
 *    <유입인구 소비시간>
 *   - 주요 소비시간: getEventVisitrCnsmpTime
 *   - 상주인구 vs 유입인구의 수직 막대 그래프: getCntTimeGraph
 *   
 *    <유입인구 유입지역>
 *   - 주요 유입지역: getEventVisitrInflow
 *   - 지도에 매핑시킬 데이터: getEventVisitrCnsmpTimeChnge
 */

@RestController
@RequestMapping("/evntEff")
public class ApiEvtEffController {
	
	@Resource(name = "eventEffectDao")
	private EventEffectDao eventEffectDao;
	
	@Resource(name = "apiAuthCheck")
	private ApiAuthCheck apiAuthCheck;
	
	/**
	 * 이벤트 효과 데이터 조회 API
	 * 
	 * /evntEff/{theme}/{admiCd}/{startDate}/{endDate}
	 * 
	 * @param theme -> all :전체, ecoEff : 경제효과, inPopProp:유입인구 특성전체, inPopCon: 유입인구 소비전체
	 * @param admiCd 행정동 코드
	 * @param startDate 기준 시작일
	 * @param endDate 기준 종료일
	 * @param authKey : 인증키
	 * @return defaultType : xml
	 */
	
	@RequestMapping(value="/{theme}/{admiCd}/{startDate}/{endDate}", method=RequestMethod.GET)
	public Object getEvntEff(@PathVariable String theme, @PathVariable String admiCd, @PathVariable String startDate, @PathVariable String endDate, 
			  @RequestParam(defaultValue = "") String authKey, HttpServletRequest req) {
			
		HashMap<String, Object> param = new HashMap<String, Object>();
		Map<String, Object> rmap = new HashMap<String, Object>();
		
		if(admiCd.length() < 8) {
			rmap.put("resultMsg", "admiCd is too short");
			rmap.put("status", "error");
			rmap.put("errorCode", 5);
			return rmap;
		}
		
		rmap = (HashMap<String, Object>) apiAuthCheck.checkApiAuth(req, admiCd.substring(0, 5));
		
	    if((int)rmap.get("errorCode") == 0) {
	    	Calendar startCal = Calendar.getInstance();	
	    	Calendar endCal = Calendar.getInstance();
	    	int startYear =  Integer.parseInt(startDate.substring(0, 4));		// 기준 시작해
	    	int startMonth =  Integer.parseInt(startDate.substring(4, 6));		// 기준 시작월
	    	int startDay =  Integer.parseInt(startDate.substring(6, 8));		// 기준 시작일
	    	int endYear =  Integer.parseInt(endDate.substring(0, 4));			// 기준 종료해
	    	int endMonth =  Integer.parseInt(endDate.substring(4, 6));			// 기준 종료월
	    	int endDay =  Integer.parseInt(endDate.substring(6, 8));			// 기준 종료일
	    	
	    	// 기준 시작일로부터 1년을 빼는 로직
	    	startCal.set(startYear, startMonth, startDay);
	    	startCal.add(Calendar.YEAR, -1);
	    	startCal.add(Calendar.MONTH, -1);
	    	
	    	// 기준 종료일로부터 1년을 빼는 로직
	    	endCal.set(endYear, endMonth, endDay);
	    	endCal.add(Calendar.YEAR, -1);
	    	endCal.add(Calendar.MONTH, -1);
	    	
	    	String lastStartDate = new SimpleDateFormat("yyyyMMdd").format(startCal.getTime());		// 기준 시작일로부터 1년 이전 
	    	String lastEndDate = new SimpleDateFormat("yyyyMMdd").format(endCal.getTime());			// 기준 종료일로부터 1년 이전
	    	
	    	param.put("megaCd", admiCd.substring(0, 2));	// 시도 코드
	    	param.put("ctyCd", admiCd.substring(0, 5));		// 시군구 코드
	    	param.put("admiCd", admiCd);					// 행정동 코드
	    	param.put("startDate", startDate);				// 기준 시작일
	    	param.put("endDate", endDate);					// 기준 종료일
	    	param.put("lastStartDate", lastStartDate);		// 기준 시작일로부터 1년 이전
	    	param.put("lastEndDate", lastEndDate);			// 기준 종료일로부터 1년 이전
	    	param.put("dataId", "rpt-trnd"); 				
	    	param.put("rgnClss", "H4");						// 행정동단위
	    	param.put("admiAround", getAdmiList(param));	// 해당 주변 행정동 코드들
	    	
	    	
	    	// 경제효과만 조회
	    	if("all".equals(theme) || "ecoEff".equals(theme)) {		
	    		
	    		// 행정동 총 경제효과
	    		rmap.put("thisAmtList", eventEffectDao.getThisAmtChnge(param));					// 평상시 대비 매출액 비율 == 주변지역 총 경제효과 - 행정동 매출액 기준비율
	    		rmap.put("thisAmtLineData", eventEffectDao.getEventEffectThisAmtList(param));	// 이번연도 라인차트 데이터
	    		rmap.put("befAmtLineData", eventEffectDao.getEventEffectLastAmtList(param));	// 이전연도 라인차트 데이터
	    		
	    		// 주변지역 총 경제효과
	    		rmap.put("thisCntRt", eventEffectDao.getThisCntChnge(param));  					// 행정동 거래량 기준비율
	    		rmap.put("thisAmtRtList", eventEffectDao.getMxmIncrsAmt(param)); 				// 행정동 매출액 기준 리스트
	    		rmap.put("thisCntRtList", eventEffectDao.getMxmIncrsRate(param)); 				// 행정동 거래량 기준 리스트
	    		rmap.put("thisAmtCntMap", eventEffectDao.getEventSalamtChnge(param));			// 지도에 매핑시킬 데이터
	    		
	    		// 행정동 업종별 경제효과
	    		@SuppressWarnings("unchecked")
	    		Map<String,Object> upjongAmtChnge = (Map<String, Object>) eventEffectDao.getUpjongAmtChnge(param).get(0);
	    		String amtUpjongCd = (String) upjongAmtChnge.get("code");						// 매출액에 대한 업종코드
	    		
	    		@SuppressWarnings("unchecked")
	    		Map<String,Object> upjongRateChnge = (Map<String, Object>) eventEffectDao.getUpjongRateChnge(param).get(0);
	    		String rateUpjongCd = (String) upjongRateChnge.get("code");						// 비율에 대한 업종코드
	    		
	    		rmap.put("upjongAmtNm", upjongAmtChnge);										// 매출액 기준
	    		rmap.put("upjongRtNm", upjongRateChnge); 										// 거래량 기준
	    		rmap.put("upjongAmtHozData", eventEffectDao.getUpjongAmtChngeGraph(param));		// 매출액 기준 hoz그래프 데이터
	    		rmap.put("upjongRtHozData", eventEffectDao.getUpjongRateChngeGraph(param)); 	// 거래량 기준 hoz그래프 데이터
	    		
	    		rmap.put("areaUpjongList", eventEffectDao.admiUpjongList(param));				// 해당 행정동의 기준기간동안 매출이 있는 업종코드 리스트
	    		
	    		// 주변지역 업종별 경제효과
	    		param.put("upjongCd", amtUpjongCd);
	    		rmap.put("areaUpjongAmtNm", eventEffectDao.getThisAreaUpjongAmtChnge(param));	// 해당 행정동 최대 증가 업종(매출액 기준)
	    		rmap.put("areaUpjongAmtList", eventEffectDao.getAreaUpjongAmtChnge(param));  	// 매출액 기준 리스트
	    		rmap.put("areaUpjongAmtMap", eventEffectDao.getEventExpndtrChnge(param));		// 지도에 매핑시킬 데이터(매출액 기준), 업종코드
	    		
	    		// 주변지역 업종별 경제효과
	    		param.put("upjongCd", rateUpjongCd);
	    		rmap.put("areaUpjongRtNm", eventEffectDao.getThisAreaUpjongRateChnge(param)); 	// 해당 행정동 최대 증가 업종(거래량 기준)
	    		rmap.put("areaUpjongRtList", eventEffectDao.getAreaUpjongRateChnge(param));		// 거래량 기준 리스트
	    		rmap.put("areaUpjongRtMap", eventEffectDao.getEventExpndtrRateChnge(param));	// 지도에 매핑시킬 데이터(거래량 기준)
	    	}
	    	
	    	// 유입인구 특성만 조회
	    	if("all".equals(theme) || "inPopProp".equals(theme)) {
	    		
	    		// 지역별 유입인구 수
	    		rmap.put("rgnInPopCntTot", eventEffectDao.getEventVisitrCnt(param));			// 해당 행정동 유입인구 수
	    		rmap.put("rgnInPopCntList", eventEffectDao.getEventVisitrCntList(param));		// 지역별 유입인구 리스트
	    		rmap.put("rgnInPopCntMap", eventEffectDao.getEventVisitrCntChnge(param));		// 지도에 매핑시킬 데이터
	    		
	    		// (성/연령)별 대표 유입인구
	    		rmap.put("inPopSexAge", eventEffectDao.getEventVisitrChartr(param));			// 해당 행정동 상권을 가장 많이 이용한 유입인구
	    		rmap.put("citizenSexAge", eventEffectDao.getEventCtznChartr(param));			// 해당 행정동 상권을 가장 많이 이용한 상주인구
	    		rmap.put("sexAgeRtStData", eventEffectDao.getEventVisitrCtznGraph(param));		// 상주인구 vs 유입인구의 수직 막대 그래프 
	    	}
	    	
	    	// 유입인구 소비만 조회
	    	if("all".equals(theme) || "inPopCon".equals(theme)) {		
	    		
	    		// 유입인구 소비시간
	    		rmap.put("inPopCnTimeList", eventEffectDao.getEventVisitrCnsmpTime(param));		// 주요 소비시간
	    		rmap.put("inPopCtzCnTimeList", eventEffectDao.getCntTimeGraph(param));			// 상주인구 vs 유입인구의 수직 막대 그래프
	    		
	    		// 유입인구 유입지역
	    		param.put("rgnClss", "H2");		// 전국구 단위
	    		rmap.put("inPopRgnList", eventEffectDao.getEventVisitrInflow(param));			// 주요 유입지역
	    		rmap.put("inPopRgnMap", eventEffectDao.getEventVisitrCnsmpTimeChnge(param));	// 지도에 매핑시킬 데이터
	    	}
	    	
	    	rmap.put("resultMsg", "Success");
			rmap.put("status", "success");
	    }
	    
	    return rmap;
	}
	
	/**
	 * 이벤트 효과 데이터 조회 API
	 * 
	 * /evntEff/{theme}/{sTheme}/{ctyCd}/{startDate}/{endDate}
	 * 
	 * @param theme -> tradeAmt : 거래금액 전체, inPopProp:유입인구 특성전체, inPopCon: 유입인구 소비전체
	 * @param sTheme -> region: 지역별, induty: 업종별, sexAge: 성/연령별, time: 시간별, inRegion: 유입지역별
	 * @param admiCd 행정동 코드
	 * @param startDate 기준 시작일
	 * @param endDate 기준 종료일
	 * @param authKey : 인증키
	 * @return defaultType : xml
	 */
	
	@RequestMapping(value="/{theme}/{sTheme}/{admiCd}/{startDate}/{endDate}", method=RequestMethod.GET)
	public Object getEvntEffSub(@PathVariable String theme, @PathVariable String sTheme, @PathVariable String admiCd, @PathVariable String startDate, @PathVariable String endDate, 
			  @RequestParam(defaultValue = "") String authKey, @RequestParam(defaultValue = "") String upjongCd, @RequestParam(defaultValue = "") String lastStartDate, 
			  @RequestParam(defaultValue = "") String lastEndDate, @RequestParam(defaultValue = "") String limitOff, HttpServletRequest req) {
			
		HashMap<String, Object> param = new HashMap<String, Object>();
		Map<String, Object> rmap = new HashMap<String, Object>();
		
		if(admiCd.length() < 8) {
			rmap.put("resultMsg", "admiCd is too short");
			rmap.put("status", "error");
			rmap.put("errorCode", 5);
			return rmap;
		}
		
		rmap = (HashMap<String, Object>) apiAuthCheck.checkApiAuth(req, admiCd.substring(0, 5));
	   
	    if((int)rmap.get("errorCode") == 0) {
	    	Calendar startCal = Calendar.getInstance();	
	    	Calendar endCal = Calendar.getInstance();
	    	int startYear =  Integer.parseInt(startDate.substring(0, 4));		// 기준 시작해
	    	int startMonth =  Integer.parseInt(startDate.substring(4, 6));		// 기준 시작월
	    	int startDay =  Integer.parseInt(startDate.substring(6, 8));		// 기준 시작일
	    	int endYear =  Integer.parseInt(endDate.substring(0, 4));			// 기준 종료해
	    	int endMonth =  Integer.parseInt(endDate.substring(4, 6));			// 기준 종료월
	    	int endDay =  Integer.parseInt(endDate.substring(6, 8));			// 기준 종료일
	    	
	    	// 이전날짜를 파라미터로 받지 못했을 경우 default로 1년이전!
	    	if("".equals(lastStartDate) || "".equals(lastEndDate)) {
	    		// 기준 시작일로부터 1년을 빼는 로직
	    		startCal.set(startYear, startMonth, startDay);
	    		startCal.add(Calendar.YEAR, -1);
	    		startCal.add(Calendar.MONTH, -1);
	    		
	    		// 기준 종료일로부터 1년을 빼는 로직
	    		endCal.set(endYear, endMonth, endDay);
	    		endCal.add(Calendar.YEAR, -1);
	    		endCal.add(Calendar.MONTH, -1);
	    		
	    		lastStartDate = new SimpleDateFormat("yyyyMMdd").format(startCal.getTime());		// 기준 시작일로부터 1년 이전 
	    		lastEndDate = new SimpleDateFormat("yyyyMMdd").format(endCal.getTime());			// 기준 종료일로부터 1년 이전
	    	}
	    	
	    	param.put("megaCd", admiCd.substring(0, 2));		// 시도 코드
	    	param.put("ctyCd", admiCd.substring(0, 5));			// 시군구 코드
	    	param.put("admiCd", admiCd);						// 행정동 코드
	    	param.put("startDate", startDate);					// 기준 시작일
	    	param.put("endDate", endDate);						// 기준 종료일
	    	param.put("lastStartDate", lastStartDate);			// 기준 시작일로부터 1년 이전
	    	param.put("lastEndDate", lastEndDate);				// 기준 종료일로부터 1년 이전
	    	param.put("dataId", "rpt-trnd"); 				
	    	param.put("rgnClss", "H4");							// 행정동단위
	    	param.put("admiAround", getAdmiList(param));		// 해당 주변 행정동 코드들
	    	param.put("upjongCd", upjongCd);
	    	
	    	// limit 값을 사용하지 않을 때(즉, 전 데이터를 가져오고 싶을 때)
	    	if(!limitOff.equals("")) {
	    		param.put("limitOff", limitOff);
	    	}
	    	
	    	if("ecoEff".equals(theme) && "region".equals(sTheme)) {								// 행정동 총 경제효과만 조회
	    		rmap.put("thisAmtList", eventEffectDao.getThisAmtChnge(param));					// 평상시 대비 매출액 비율 == 주변지역 총 경제효과 - 행정동 매출액 기준비율
	    		rmap.put("thisAmtLineData", eventEffectDao.getEventEffectThisAmtList(param));	// 이번연도 라인차트 데이터
	    		rmap.put("befAmtLineData", eventEffectDao.getEventEffectLastAmtList(param));	// 이전연도 라인차트 데이터
	    	} else if("ecoEff".equals(theme) && "near".equals(sTheme)) {						// 행정동 총 경제효과만 조회
	    		rmap.put("thisCntRt", eventEffectDao.getThisCntChnge(param)); 					// 행정동 거래량 기준비율
	    		rmap.put("thisAmtRtList", eventEffectDao.getMxmIncrsAmt(param));				// 행정동 매출액 기준 리스트
	    		rmap.put("thisCntRtList", eventEffectDao.getMxmIncrsRate(param)); 				// 행정동 거래량 기준 리스트
	    		rmap.put("thisAmtCntMap", eventEffectDao.getEventSalamtChnge(param));			// 지도에 매핑시킬 데이터
	    		
	    	} else if("ecoEff".equals(theme) && "regionUpjong".equals(sTheme)) {				// 행정동 업종별 경제효과만 조회
	    		
	    		rmap.put("upjongAmtNm", eventEffectDao.getUpjongAmtChnge(param).get(0));										// 매출액 기준
	    		rmap.put("upjongRtNm", eventEffectDao.getUpjongRateChnge(param).get(0)); 										// 거래량 기준
	    		rmap.put("upjongAmtHozData", eventEffectDao.getUpjongAmtChngeGraph(param));		// 매출액 기준 hoz그래프 데이터
	    		rmap.put("upjongRtHozData", eventEffectDao.getUpjongRateChngeGraph(param)); 	// 거래량 기준 hoz그래프 데이터
	    	} else if("ecoEff".equals(theme) && "nearUpjong".equals(sTheme)) {					// 주변지역 업종별 경제효과만 조회
	    		
	    		@SuppressWarnings("rawtypes")
				List<Map> areaUpjongList = eventEffectDao.admiUpjongList(param);
	    		rmap.put("areaUpjongList", areaUpjongList);										// 해당 행정동의 기준기간동안 매출이 있는 업종코드 리스트
	    		
	    		// 매출액과 거래량 각각의 증감률이 가장 높은 업종 을 구해서 parameter에 적용
	    		String amtUpjongCd = upjongCd;
	    		String rateUpjongCd = upjongCd;
	    		
	    		if(upjongCd.equals("")) {
	    			
	    			if(areaUpjongList.size() > 0) {
	    				
	    				// 해당 시간 , 행정동에 매출이 있는 업종코드 리스트가 존재할 경우	
	    				@SuppressWarnings("rawtypes")
						List<Map> upjongAmtList = eventEffectDao.getUpjongAmtChnge(param);				// 해당 행정동의 기준기간동안 매출액 기준 증감률이 가장 높은 업종
	    				
	    	    		@SuppressWarnings("rawtypes")
						List<Map> upjongRtList = eventEffectDao.getUpjongRateChnge(param);				// 해당 행정동의 기준기간동안 거래량 기준 증감률이 가장 높은 업종
	    				
	    				// 매출액 기준 증감률이 가장 높은 업종 구하기
	    				if(upjongAmtList.size() > 0 ) {
	    					amtUpjongCd = (String) upjongAmtList.get(0).get("code");
	    				}
	    				
	    				// 거래량 기준 증감률이 가장 높은 업종 구하기
	    				if(upjongRtList.size() > 0 ) {
	    					rateUpjongCd = (String) upjongRtList.get(0).get("code");
	    				}
	    				
	    			} 
	    		}
	    		
	    		param.put("upjongCd", amtUpjongCd);
	    		rmap.put("areaUpjongAmtNm", eventEffectDao.getThisAreaUpjongAmtChnge(param));	// 해당 행정동 최대 증가 업종(매출액 기준)
	    		rmap.put("areaUpjongAmtList", eventEffectDao.getAreaUpjongAmtChnge(param));  	// 매출액 기준 리스트
	    		rmap.put("areaUpjongAmtMap", eventEffectDao.getEventExpndtrChnge(param));		// 지도에 매핑시킬 데이터(매출액 기준), 업종코드
	    		
	    		param.put("upjongCd", rateUpjongCd);
	    		rmap.put("areaUpjongRtNm", eventEffectDao.getThisAreaUpjongRateChnge(param)); 	// 해당 행정동 최대 증가 업종(거래량 기준)
	    		rmap.put("areaUpjongRtList", eventEffectDao.getAreaUpjongRateChnge(param)); 	// 거래량 기준 리스트
	    		rmap.put("areaUpjongRtMap", eventEffectDao.getEventExpndtrRateChnge(param));	// 지도에 매핑시킬 데이터(거래량 기준)
	    		
	    	} else if("inPopProp".equals(theme) && "region".equals(sTheme)) {					// 지역별 유입인구 수만 조회
	    		rmap.put("rgnInPopCntTot", eventEffectDao.getEventVisitrCnt(param));			// 해당 행정동 유입인구 수
	    		rmap.put("rgnInPopCntList", eventEffectDao.getEventVisitrCntList(param));		// 지역별 유입인구 리스트
	    		rmap.put("rgnInPopCntMap", eventEffectDao.getEventVisitrCntChnge(param));		// 지도에 매핑시킬 데이터
	    		
	    	} else if("inPopProp".equals(theme) && "sexAge".equals(sTheme)) {					// (성/연령)별 대표 유입인구만 조회
	    		rmap.put("inPopSexAge", eventEffectDao.getEventVisitrChartr(param));			// 해당 행정동 상권을 가장 많이 이용한 유입인구
	    		rmap.put("citizenSexAge", eventEffectDao.getEventCtznChartr(param));			// 해당 행정동 상권을 가장 많이 이용한 상주인구
	    		rmap.put("sexAgeRtStData", eventEffectDao.getEventVisitrCtznGraph(param));		// 상주인구 vs 유입인구의 수직 막대 그래프
	    	} else if("inPopCon".equals(theme) && "time".equals(sTheme)) {						// 유입인구 소비시간만 조회
	    		rmap.put("inPopCnTimeList", eventEffectDao.getEventVisitrCnsmpTime(param));		// 주요 소비시간
	    		rmap.put("inPopCtzCnTimeList", eventEffectDao.getCntTimeGraph(param));			// 상주인구 vs 유입인구의 수직 막대 그래프
	    	} else if("inPopCon".equals(theme) && "inRegion".equals(sTheme)) {					// 유입인구 유입지역만 조회
	    		param.put("rgnClss", "H2");														// 전국구 단위
	    		rmap.put("inPopRgnList", eventEffectDao.getEventVisitrInflow(param));
	    		rmap.put("inPopRgnMap", eventEffectDao.getEventVisitrCnsmpTimeChnge(param));	// 지도에 매핑시킬 데이터
	    	} else {// 잘못된 url 호출일 때
				rmap.put("resultMsg", "Invalid URL Call");
				rmap.put("errorCode", 4);
			}
	    	
	    	rmap.put("resultMsg", "Success");
			rmap.put("status", "success");
	    }
	    
	    return rmap;
	}
	
	/**
	 * 선택 행정동 주변 지역코드 가져옴 
	 * @param param
	 * @return
	 */
	public String getAdmiList(Map<String, Object> param) {
		@SuppressWarnings("unused")
		Map<String,Object> rtnMap = new HashMap<String, Object>();
		@SuppressWarnings("rawtypes")
		List<Map> admiAroundList = eventEffectDao.getAdmiCnt(param);		// 주변지역 id list
		
		String admiAround = "";
		if(admiAroundList.size() >= 3) {
			for(@SuppressWarnings("rawtypes") Map aa : admiAroundList) {
				admiAround += ",'"+aa.get("id")+"'";
			}
			admiAround = admiAround.substring(1);
		}
		
		return admiAround;		// admi id 리스트 가져오기
	}

}
