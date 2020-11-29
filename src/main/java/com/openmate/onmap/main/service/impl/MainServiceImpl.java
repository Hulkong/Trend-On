package com.openmate.onmap.main.service.impl;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import com.openmate.onmap.common.dao.CommonDao;
import com.openmate.onmap.main.dao.MainDao;
import com.openmate.onmap.main.service.MainService;

@Service("mainService")
public class MainServiceImpl implements MainService{
	
	@Resource(name = "commonDao")
	private CommonDao commonDao;
	
	@Resource(name = "mainDao")
	private MainDao mainDao;
	
	/**
	 * 중간대문에 필요한 데이터 가져오기
	 */
	public Map<String,Object> getCrfMainData(Map<String,Object> param){
		Map<String,Object> rsltMap = new HashMap<String,Object>();
		// 계정 상태를 확인 ( 테스트일 경우 특정 날짜로 고정 )
		// 계약 상태인 계정일 경우에는 디비의 가장 최신 날짜 가져오기
		Map<String,Object> getDates = getDates(param);
		
		// 가장 최신 year & month 가져오기
		param.put("thisDate", getDates.get("this_month"));
		param.put("lastDate", getDates.get("last_month"));
		rsltMap.put("lastDate",getDates.get("this_month"));
		rsltMap.put("toDate",getDates.get("this_date"));

		// 전체 매출액
		rsltMap.put("totalAmt", mainDao.getTotalAmt(param));
		
		// 일등 지역찾기
		Map<String,Object> noOneDong = mainDao.getNoOneDong(param);
		rsltMap.put("admiOne", noOneDong);
		
		if( noOneDong != null ) {
			param.put("admiCd", noOneDong.get("admi_cd"));	
		}
		
		// 일등 행정동의 전월대비 매출액 가져오기
		rsltMap.put("admiRate", mainDao.getadmiRate(param));
		
		// 전체 데이터 수 가져오기
		rsltMap.put("ctyTot", mainDao.getCtyTotData(param));
		rsltMap.put("monTot", mainDao.getMonTotData(param));
		
		return rsltMap;
	}
	
	/**
	 * 중간대문에 필요한 데이터 가져오기(유동인구)
	 */
	public Map<String,Object> getCrfMainFloat(Map<String,Object> param){
		Map<String,Object> rsltMap = new HashMap<String,Object>();
		// 계정 상태를 확인 ( 테스트일 경우 특정 날짜로 고정 )
		// 계약 상태인 계정일 경우에는 디비의 가장 최신 날짜 가져오기
		Map<String,Object> getDates = getDates(param);
		
		// 가장 최신 year & month 가져오기
		param.put("thisDate", getDates.get("this_month"));
		param.put("lastDate", getDates.get("last_month"));
		rsltMap.put("lastDate",getDates.get("this_month"));
		rsltMap.put("toDate",getDates.get("this_date"));

		// 전체 유동인구수
		rsltMap.put("totalFloat", mainDao.getTotalFloat(param));
		
		// 일등 지역찾기
		Map<String,Object> noOneDong = mainDao.getFloatDong(param);
		rsltMap.put("admiOne", noOneDong);
		
		if(noOneDong == null) {			
			// 일등 행정동의 전월대비 유동인구수 가져오기
			rsltMap.put("admiRate", "0");	
		}else {
			param.put("admiCd", noOneDong.get("admi_cd"));
			
			// 일등 행정동의 전월대비 유동인구수 가져오기
			rsltMap.put("admiRate", mainDao.getAdmiFloatRate(param));
		}
		
		System.out.println(rsltMap.toString());
		
		return rsltMap;
	}
	
	
	public Map<String, Object> getDates(Map<String,Object> param){
		Map<String,Object> rsltMap = new HashMap<String,Object>();
		
		// 세션에 있는 사용자 정보 가져오기 
		Authentication auth = SecurityContextHolder.getContext().getAuthentication(); 
		Object obj = auth.getPrincipal();
		
		try{
			int serviceClss = 1;
			
			if(obj != null && obj instanceof com.openmate.frmwrk.user.User){
				com.openmate.frmwrk.user.User usr = (com.openmate.frmwrk.user.User)obj;
				Object extInfo = usr.getExtInfo();
				Map xInfo = (Map) usr.getExtInfo();
				serviceClss = Integer.valueOf( xInfo.get("service_clss").toString() );
			} 
			
			if(serviceClss == 3){
				 rsltMap.put("date", "201812");
				 rsltMap.put("this_month", "201812");
				 rsltMap.put("last_month", "201812");
				 rsltMap.put("this_date", "12");
			}else{				
				rsltMap = mainDao.getDates(param);
			}
			
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return rsltMap;
	}
	
}
