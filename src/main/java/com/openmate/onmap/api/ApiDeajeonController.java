package com.openmate.onmap.api;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.ibatis.mapping.MappedStatement;
import org.apache.ibatis.session.Configuration;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.openmate.frmwrk.report.web.ReportParam;
import com.openmate.onmap.main.dao.EcnmyTrndDao;
import com.openmate.onmap.report.service.impl.ReportServiceImpl;
import com.vividsolutions.jts.util.Stopwatch;

/*
 * 작성자: 김용현
 * 작성일자: 2018-04-02
 * 타이틀: 경제트렌드
 * 내용:
 *  1. 파일: ecnmyTrnd-mapper.xml
 *  2. sqlId
 *   - getEcnmyTrndVisitrChartr: 유입인구 성/연령 통계 - 유입인구 특성
 *   - getEcnmyTrndCtznChartr: 유입인구 성/연령 통계 - 상주인구 특성
 *   - getEcnmyTrndCnt: 유입인구 성/연령 통계 - 행정동 상권을 가장 많이 이용한 유입/상주인구 비율 
 */

@RestController
@RequestMapping("/deajeon")
public class ApiDeajeonController {
	
	@Resource(name = "ecnmyTrndDao")
	private EcnmyTrndDao ecnmyTrndDao;
	
	@Resource(name = "onmapSqlSession")
	private SqlSessionFactory onmapSqlSession ;
	
	public static Logger logger = LoggerFactory.getLogger(ReportServiceImpl.class);
	
	/**
	 * 대전 경제트랜드 유입인구 성/연령 통계 데이터 조회 API
	 * 
	 * /allRegion/{startDate}/{endDate}
	 * 
	 * @param startDate: 기준 시작일
	 * @param endDate: 기준 종료일
	 * @param authKey: 인증키 
	 * @return defaultType : xml
	 */
	
	@RequestMapping(value="/allRegPop/{startDate}/{endDate}", method=RequestMethod.GET)
	public Object getDeajeonAllPop(@PathVariable String startDate, @PathVariable String endDate, @RequestParam HashMap<String, Object> data) {
		
			//to-do: 인증키 체크 로직 만들어서 체크(false일때 바로 return!, 데이터형식 json으로)
		
			HashMap<String, Object> param = new HashMap<String, Object>();
			HashMap<String, Object> rmap = new HashMap<String, Object>();
			
			param.put("startDate", startDate);				// 기준 시작일
			param.put("endDate", endDate);					// 기준 종료일
			param.put("rgnClss", "H4");						// 행정동단위
			
			String ctyCd = "";

			//대전
			ctyCd = "30";
			param.put("ctyCd", ctyCd);
			rmap.putAll(getSexAgeAllPop(ctyCd, param));

			//공주
			ctyCd = "44150";
			param.put("ctyCd", ctyCd);
			rmap.putAll(getSexAgeAllPop(ctyCd, param));

			//부여
			ctyCd = "44760";
			param.put("ctyCd", ctyCd);
			rmap.putAll(getSexAgeAllPop(ctyCd, param));

			//익산
			ctyCd = "45140";
			param.put("ctyCd", ctyCd);
			rmap.putAll(getSexAgeAllPop(ctyCd, param));

			rmap.put("resultMsg", "Success");
			rmap.put("status", "success");
			
			return rmap;
	}
	
	// 유입인구 성/연령 통계 데이터 가져오는 함수
	public HashMap<String, Object> getSexAgeAllPop(String ctyCd, HashMap<String, Object> params) {

		HashMap<String, Object> rMap = new HashMap<String, Object>();
		
		rMap.put("inPopSexAge_" + ctyCd, 	ecnmyTrndDao.getEcnmyTrndVisitrChartr(params));			// 유입인구 성/연령 통계 - 유입인구 특성
		rMap.put("citizenSexAge_" + ctyCd, 	ecnmyTrndDao.getEcnmyTrndCtznChartr(params));			// 유입인구 성/연령 통계 - 상주인구 특성
		rMap.put("sexAgeRate_" + ctyCd, 	ecnmyTrndDao.getEcnmyTrndCnt(params));					// 유입인구 성/연령 통계 - 행정동 상권을 가장 많이 이용한 유입/상주인구 비율
		
		return rMap;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/report/rpt-trnd-deajeon/{ctyCd}/{startDate}/{endDate}", method=RequestMethod.GET)
	public Map<String,Object> getJsonByTrndRpt(@PathVariable String ctyCd, @PathVariable String startDate
			, @PathVariable String endDate, @RequestParam HashMap<String, Object> param)  {
		
		ReportParam rParam= new ReportParam();
		
		param.put("startDate", startDate);
		param.put("endDate", endDate);
		
		param.put("ctyCd", ctyCd);
		
		String dataId = "rpt-trnd-deajeon";
		
		rParam.setRptId(dataId);
		rParam.setParam(param);
		
		Map<String,Object> dataBase = new HashMap<String,Object>();
		
		
		Map<String,Object> datasourceMap = new HashMap<String, Object>();
		Map<String,Object> commonMap = new HashMap<String, Object>();
		commonMap.putAll(rParam.getParam());
		
		Configuration configuration = onmapSqlSession.getConfiguration();
		Collection<MappedStatement>  col = configuration.getMappedStatements();
		Iterator<MappedStatement> it = col.iterator();
		List<String> mapperIdList = new ArrayList<String>();
		
		while(it.hasNext()){
			
			try {
				
				MappedStatement mpp = it.next();
				
				if( mpp.getId().contains(dataId) ){
					mapperIdList.add(mpp.getId());	
				}
			} catch (Exception e) {
				// TODO: handle exception
			}
		}
		
		SqlSession session = onmapSqlSession.openSession();
		
		try {
			Stopwatch stopwatch = new Stopwatch();
			
			for (String id : mapperIdList) {
				
				String reportId = id.substring(id.lastIndexOf(".") + 1);
				
				stopwatch.reset();
				stopwatch.start();
				
				String dddrrid=reportId.replace("rpt-trnd-deajeon-", "");
				
				logger.debug( dddrrid + "stt>>");
				
				datasourceMap.put(dddrrid, session.selectList(id, commonMap));

				stopwatch.stop();
				logger.debug(dddrrid + "end>> : " +stopwatch.getTimeString());
				
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		
		dataBase.put(dataId,datasourceMap);
		
//		System.out.println(dataBase.get(dataId).toString());

		//return jsonString;
		return (Map<String, Object>)dataBase.get(dataId);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/report/rpt-evntEff-deajeon/{admiCd}/{startDate}/{endDate}", method=RequestMethod.GET)
	public Map<String,Object> getJsonByDataId(@PathVariable String admiCd, @PathVariable String startDate
			, @PathVariable String endDate, @RequestParam(defaultValue = "") String lastStartDate
			, @RequestParam(defaultValue = "") String lastEndDate, @RequestParam HashMap<String, Object> param)  {
		
		ReportParam rParam= new ReportParam();
		
		param.put("startDate", startDate);
		param.put("endDate", endDate);
		param.put("admiCd", admiCd);
		param.put("ctyCd", admiCd.substring(0, 5));
		
		// 이전날짜를 파라미터로 받지 못했을 경우 default로 1년이전!
    	if("".equals(lastStartDate) || "".equals(lastEndDate)) {
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
    		
    		lastStartDate = new SimpleDateFormat("yyyyMMdd").format(startCal.getTime());		// 기준 시작일로부터 1년 이전 
    		lastEndDate = new SimpleDateFormat("yyyyMMdd").format(endCal.getTime());			// 기준 종료일로부터 1년 이전
    		
    		param.put("lastStartDate", lastStartDate);
    		param.put("lastEndDate", lastEndDate);
    	}
    	
    	
    	String dataId = "rpt-evntEff-deajeon";
    	
		rParam.setRptId(dataId);
		rParam.setParam(param);
		
		Map<String,Object> dataBase = new HashMap<String,Object>();
		
		
		Map<String,Object> datasourceMap = new HashMap<String, Object>();
		Map<String,Object> commonMap = new HashMap<String, Object>();
		commonMap.putAll(rParam.getParam());
		
		Configuration configuration = onmapSqlSession.getConfiguration();
		Collection<MappedStatement>  col = configuration.getMappedStatements();
		Iterator<MappedStatement> it = col.iterator();
		List<String> mapperIdList = new ArrayList<String>();
		
		while(it.hasNext()){
			
			try {
				
				MappedStatement mpp = it.next();
				
				if( mpp.getId().contains(dataId) ){
					mapperIdList.add(mpp.getId());	
				}
			} catch (Exception e) {
				// TODO: handle exception
			}
		}
		
		SqlSession session = onmapSqlSession.openSession();
		
		try {
			Stopwatch stopwatch = new Stopwatch();
			
			for (String id : mapperIdList) {
				
				String reportId = id.substring(id.lastIndexOf(".") + 1);
				
				stopwatch.reset();
				stopwatch.start();
				
				String dddrrid = "";
				
				if(reportId.indexOf("rpt-trnd-deajeon") >= 0) {
					dddrrid=reportId.replace("rpt-trnd-deajeon-", "");
				} else {
					dddrrid=reportId.replace("rpt-evntEff-deajeon-", "");
				}
				
				logger.debug( dddrrid + "stt>>");
				
				datasourceMap.put(dddrrid, session.selectList(id, commonMap));

				stopwatch.stop();
				logger.debug(dddrrid + "end>> : " +stopwatch.getTimeString());
				
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		
		dataBase.put(dataId,datasourceMap);
		
//		System.out.println(dataBase.get(dataId).toString());

		//return jsonString;
		return (Map<String, Object>)dataBase.get(dataId);
	}
		
}
