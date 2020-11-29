package com.openmate.onmap.report.service.impl;

import java.io.IOException;
import java.util.ArrayList;
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
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.openmate.frmwrk.report.service.ReportService;
import com.openmate.frmwrk.report.web.ReportParam;
import com.openmate.onmap.report.service.OnmapReportDao;
import com.vividsolutions.jts.util.Stopwatch;


@Service("reportService")
public class ReportServiceImpl implements ReportService {

	@Resource(name = "onmapReportDao")
	private OnmapReportDao onmapReportDao;
	
	@Autowired
	private org.springframework.security.authentication.encoding.ShaPasswordEncoder passwordEncoder;
	
	
	@Resource(name = "onmapSqlSession")
	private SqlSessionFactory onmapSqlSession ;
	
	private int cacheId = 0;
	
	
	public static Logger logger = LoggerFactory.getLogger(ReportServiceImpl.class);
	private ObjectMapper mapper = new ObjectMapper();
	
	
	@Value("${config.phantomjs.host}")
	private String phantomJsHost ;
	
	@Value("${config.service.url}")
	private String serviceUrl;
	
	@Override
	public Map<String,Object> getJsonByDataId(ReportParam rParam)  {
		
		String dataId = rParam.getRptId();
		Map<String,Object> dataBase = new HashMap<String,Object>();
		
		
		Map<String,Object> datasourceMap = new HashMap<String, Object>();
		Map<String,Object> commonMap = new HashMap<String, Object>();
		commonMap.putAll(rParam.getParam());
		
//		ctyCd : '11140',
//		dataId : "rpt-trnd",
//		startDate : "20160501",
//		endDate : "20160701"
		String rawKey =  (String)commonMap.get("ctyCd") + commonMap.get("dataId") + commonMap.get("startDate") + commonMap.get("endDate") + (String)commonMap.get("admiCd") + commonMap.get("lastStartDate") + commonMap.get("lastEndDate");
			
		String rKey = passwordEncoder.encodePassword(rawKey,null);
		
		
		commonMap.put("rptKey", rKey);
		commonMap.put("phantomJsHost", phantomJsHost);
		commonMap.put("trendOnHost", serviceUrl);
		
		datasourceMap.put("common", commonMap);
		
		Map<String,Object> cacheParam = new HashMap<String,Object>();
		cacheParam.put("id", rKey  );
	
		Map<String, Object> mm = onmapReportDao.selectCache(rKey);
		
		if(mm != null){
			String jsonString = "error";
			Map<String, Object> dfdf = null;
			try {
				dfdf = mapper.readValue( (String)mm.get("cache") ,new TypeReference<Map<String, Object>>(){} );
				jsonString = mapper.writeValueAsString(dfdf);
			} catch (JsonProcessingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			//return jsonString;
			return (Map<String, Object>) dfdf;
			
		}

		
		
		Configuration configuration = onmapSqlSession.getConfiguration();
		Collection<MappedStatement>  col = configuration.getMappedStatements();
		Iterator<MappedStatement> it = col.iterator();
		List<String> mapperIdList = new ArrayList<String>();
		while(it.hasNext()){
			
			try {
				
				MappedStatement mpp = it.next();
				
//				if( mpp.getId().contains(dataId) && (mpp.getId().contains("rpt-trnd-005-001"))   ){
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
				logger.debug( reportId + "stt>>");
//				String dddrrid=reportId.replace("-", "");
//				datasourceMap.put(dddrrid, session.selectList(id, commonMap));
				
				datasourceMap.put(reportId, session.selectList(id, commonMap));

				stopwatch.stop();
				logger.debug(reportId + "end>> : " +stopwatch.getTimeString());
				
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		
		
		dataBase.put(dataId,datasourceMap);
		
		String jsonString = "error";
		
	
		
		try {
			jsonString = mapper.writeValueAsString(dataBase.get(dataId));
		} catch (JsonProcessingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		cacheParam.put("json", jsonString);
		

		if(onmapReportDao.existCache(rKey) > 0)
			onmapReportDao.deleteCache(rKey);
		
		onmapReportDao.insertCache(cacheParam);
		
		//return jsonString;
		return (Map<String, Object>)dataBase.get(dataId);
	}
	
	@Override
	public String getJsonStrByDataId(ReportParam rParam)  {
		
		String dataId = rParam.getRptId();
		Map<String,Object> dataBase = new HashMap<String,Object>();
		
		
		Map<String,Object> datasourceMap = new HashMap<String, Object>();
		Map<String,Object> commonMap = new HashMap<String, Object>();
		commonMap.putAll(rParam.getParam());
		
//		ctyCd : '11140',
//		dataId : "rpt-trnd",
//		startDate : "20160501",
//		endDate : "20160701"
		String rawKey =  (String)commonMap.get("ctyCd") + commonMap.get("dataId") + commonMap.get("startDate") + commonMap.get("endDate") + (String)commonMap.get("admiCd") + commonMap.get("lastStartDate") + commonMap.get("lastEndDate");
			
		String rKey = passwordEncoder.encodePassword(rawKey,null);
		
		
		commonMap.put("rptKey", rKey);
		commonMap.put("phantomJsHost", phantomJsHost);
		commonMap.put("trendOnHost", serviceUrl);
		
		datasourceMap.put("common", commonMap);
		
		Map<String,Object> cacheParam = new HashMap<String,Object>();
		cacheParam.put("id", rKey  );
	
		Map<String, Object> mm = onmapReportDao.selectCache(rKey);
		
		if(mm != null){
			String jsonString = "error";
			
			try {
				Map<String, Object> dfdf = mapper.readValue( (String)mm.get("cache") ,new TypeReference<Map<String, Object>>(){} );
				jsonString = mapper.writeValueAsString(dfdf);
			} catch (JsonProcessingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			return jsonString;
		}

		
		
		Configuration configuration = onmapSqlSession.getConfiguration();
		Collection<MappedStatement>  col = configuration.getMappedStatements();
		Iterator<MappedStatement> it = col.iterator();
		List<String> mapperIdList = new ArrayList<String>();
		while(it.hasNext()){
			
			try {
				
				MappedStatement mpp = it.next();
				
//				if( mpp.getId().contains(dataId) && (mpp.getId().contains("rpt-trnd-005-001"))   ){
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
				logger.debug( reportId + "stt>>");
//				String dddrrid=reportId.replace("-", "");
//				datasourceMap.put(dddrrid, session.selectList(id, commonMap));
				
				datasourceMap.put(reportId, session.selectList(id, commonMap));

				stopwatch.stop();
				logger.debug(reportId + "end>> : " +stopwatch.getTimeString());
				
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		
		
		dataBase.put(dataId,datasourceMap);
		
		String jsonString = "error";
		
		
		try {
			jsonString = mapper.writeValueAsString(dataBase.get(dataId));
		} catch (JsonProcessingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		cacheParam.put("json", jsonString);
		

		if(onmapReportDao.existCache(rKey) > 0)
			onmapReportDao.deleteCache(rKey);
		
		onmapReportDao.insertCache(cacheParam);
		return jsonString;
	}

	@Override
	public int getCacheId() throws Exception {
		return cacheId;
	}



}
