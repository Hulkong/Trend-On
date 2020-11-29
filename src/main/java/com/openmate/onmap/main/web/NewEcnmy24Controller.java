package com.openmate.onmap.main.web;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.ibatis.session.SqlSessionFactory;
import org.json.simple.JSONObject;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.openmate.frmwrk.mapapp.dao.FeatureInfo;
import com.openmate.frmwrk.mapapp.service.MapAppService;
import com.openmate.onmap.common.dao.CommonDao;
import com.openmate.onmap.main.dao.Ecnmy24Dao;
import com.openmate.onmap.main.service.Ecnmy24Service;
import com.openmate.onmap.main.service.MainService;

@Controller
public class NewEcnmy24Controller {

	@Resource(name = "ecnmy24Dao")
	private Ecnmy24Dao ecnmy24Dao;

	@Resource(name = "commonDao")
	private CommonDao commonDao;
	
	@Resource(name = "mainService")
	private MainService mainService;

	@Resource(name = "onmapSqlSession")
	private SqlSessionFactory sessionFactory ;



	@Resource(name = "ecnmy24Service")
	private Ecnmy24Service ecnmy24Service;
	
	@Resource(name = "mapAppService")
	private MapAppService mapAppService;
	
	/**
	 * 경제 24 page 연결
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = "/onmap/ecnmy_24/main.do")
	public String ecnmy_trndPage(HttpServletRequest req, HttpServletResponse res, Map<String,Object> map){
		
		
		Authentication auth = SecurityContextHolder.getContext().getAuthentication(); 
		
		Object obj = auth.getPrincipal();
		try{
			if(obj != null && obj instanceof com.openmate.frmwrk.user.User){
				com.openmate.frmwrk.user.User usr = (com.openmate.frmwrk.user.User)obj;
				System.out.println("경제24메뉴!!");
				
				map.put("userId", usr.getUsername());
//				
				int serviceClss = 1;
				Object extInfo = usr.getExtInfo();
				Map xInfo = (Map) usr.getExtInfo();
				serviceClss = Integer.valueOf( xInfo.get("service_clss").toString() );
				
				map.put("serviceClss", serviceClss);   // 서비스유형코드
				
				// 테스트일때 기간설정
				if(serviceClss == 3){
					map.put("date", "201812");
				}else{
					Map<String,Object> param = new HashMap<String,Object>();
					Map range = commonDao.getDateRange(param);
					SimpleDateFormat dt = new SimpleDateFormat("yyyyMMdd"); 
					SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM"); 
					Date maxDate = dt.parse((String)range.get("max_stdr_date")); 
					map.put("date", sdf.format(maxDate));
				}
				
			}else{
				System.out.println("로그인 필요!!");
			}
			
			
			
		}catch(Exception e){
			e.printStackTrace();
		}
		
		
		return "onmap/ecnmy_24/main";
	}
	
	
	/**
	 * 지자체 현황 : 지도(행정동 경계)
	 * 
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/ecnmy_24/getStateMap.json","/onmap/public/ecnmy_24/getStateMap.json"})
	public void onmapEcnmyTrndmap( HttpServletRequest req, HttpServletResponse res
								 , @RequestParam(value="layerName", required=false, defaultValue = "featureLayer") String layerName
								 , @RequestParam Map<String, Object> param) {
		
		FeatureInfo finfo = new FeatureInfo();
		
		finfo.setLayerCrs("KATEC");
		finfo.setLayerName(layerName);
		finfo.setMapperId("com.openmate.onmap.main.dao.Ecnmy24Dao.getStateMap");
		finfo.setTargetCrs("EPSG:4326");

		mapAppService.writeFeature(req, res, mapAppService.getFeature(finfo, param, sessionFactory));

	}
	
	
	/**
	 * 지자체 현황[공통] : 최신 년월 
	 * 
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/ecnmy_24/last_stdr_date.json","/onmap/public/ecnmy_24/last_stdr_date.json"})
	@ResponseBody
	public Object onmapEcnmy24LastStdrDate( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String, Object> param) {
		
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap = ecnmy24Service.getLastStdrDate(param);
//		rmap.put("stdrDate", ecnmy24Dao.getLastStdrDate(param));
		
		return rmap;
	}
	
	
	/**
	 * 지자체 현황[공통] : 읍면동 수
	 * 
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/ecnmy_24/admi_count.json","/onmap/public/ecnmy_24/admi_count.json"})
	@ResponseBody
	public Object onmapEcnmy24AdmiCount( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String, Object> param) {
		
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("admiCnt", ecnmy24Dao.getAdmiCount(param));
		
		return rmap;
	}
	
	/**
	 * 지자체 기사 가져오기 (naver api)
	 * @param req
	 * @param res
	 * @param param
	 * @return
	 */
	@RequestMapping(value = {"/onmap/ecnmy_24/cty_news.json","/onmap/public/ecnmy_24/cty_news.json"})
	@ResponseBody
	public Map<String, Object> getNewsList ( HttpServletRequest req, HttpServletResponse res
			 								, @RequestParam Map<String, Object> param){
		Map<String, Object> rmap = new HashMap<String, Object>();
		try {
			String search_key = (String) param.get("ctyNm");
			int display = 0;
			if(param.get("num") != null && !param.get("num").equals("")) {
				display = Integer.parseInt(param.get("num").toString());
			}
			
			JSONObject json = ecnmy24Service.searchNewsList(search_key, display);
			rmap.put("list", json.get("items"));
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return rmap;
	}
	

	/**
	 * 지자체 현황[page01-01 - 카드사] : 거래금액(텍스트)
	 * 
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/ecnmy_24/total_amt_txt.json","/onmap/public/ecnmy_24/total_amt_txt.json"})
	@ResponseBody
	public Object onmapEcnmy24AmtTxt( HttpServletRequest req, HttpServletResponse res
									 , @RequestParam Map<String, Object> param) {
		
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("totalAmt", ecnmy24Dao.getTotalAmt(param));
		rmap.put("lastMonRate", ecnmy24Dao.getLastMonRate(param));
		rmap.put("lastYearRate", ecnmy24Dao.getLastYearRate(param));
		
		return rmap;
	}
	
	/**
	 * 지자체 현황[page01-01 - 카드사] : 최신 1년치 유입/상주 거래금액 (chart)
	 * 
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/ecnmy_24/total_amt_chart.json","/onmap/public/ecnmy_24/total_amt_chart.json"})
	@ResponseBody
	public Object onmapEcnmy24AmtChart( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String, Object> param) {
		
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("list", ecnmy24Dao.getTotalAmtChart(param));
		
		return rmap;
	}
	
	/**
	 * 지자체 현황[page01-01 - 카드사] : 총 거래금액 (주제도)
	 * 
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/ecnmy_24/total_amt_map.json","/onmap/public/ecnmy_24/total_amt_map.json"})
	@ResponseBody
	public Object onmapEcnmy24AmtMap( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String, Object> param) {
		
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("list", ecnmy24Dao.getTotalAmtMap(param));
		
		return rmap;
	}
	
	/**
	 * 지자체 현황[page01-02 - 통신사] : 유동인구 (text)
	 * 
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/ecnmy_24/total_float_txt.json","/onmap/public/ecnmy_24/total_float_txt.json"})
	@ResponseBody
	public Object onmapEcnmy24FloatTxt( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String, Object> param) {
		
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("totalFloat", ecnmy24Dao.getTotalFloat(param));
		rmap.put("lastMonRate", ecnmy24Dao.getLastMonFloat(param));
		rmap.put("lastYearRate", ecnmy24Dao.getLastYearFloat(param));
		
		return rmap;
	}
	
	/**
	 * 지자체 현황[page01-02 - 통신사] : 유동인구 (chart)
	 * 
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/ecnmy_24/total_float_chart.json","/onmap/public/ecnmy_24/total_float_chart.json"})
	@ResponseBody
	public Object onmapEcnmy24FloatChart( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String, Object> param) {
		
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("list", ecnmy24Dao.getTotalFloatChart(param));
		
		return rmap;
	}
	
	/**
	 * 지자체 현황[page01-02 - 통신사] : 유동인구 (주제도)
	 * 
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/ecnmy_24/total_float_map.json","/onmap/public/ecnmy_24/total_float_map.json"})
	@ResponseBody
	public Object onmapEcnmy24FloatMap( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String, Object> param) {
		
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("list", ecnmy24Dao.getTotalFloatMap(param));
		
		return rmap;
	}
	
	
	/**
	 * 지자체 현황[page02-01 - 카드사, 통신사] : 성/연령별 대표인구 (유동인구,소비인구 특성 - text)
	 * 
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/ecnmy_24/all_gender_age.json","/onmap/public/ecnmy_24/all_gender_age.json"})
	@ResponseBody
	public Object onmapEcnmy24AllGenderAge( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String, Object> param) {
		
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("amtTxt", ecnmy24Dao.getAmtGenderAge(param));
		rmap.put("floatTxt", ecnmy24Dao.getFloatGenderAge(param));
		
		return rmap;
	}
	
	/**
	 * 지자체 현황[page02-01 - 카드사] : 성/연령별 대표인구 (소비인구 특성 - chart)
	 * 
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/ecnmy_24/amt_gender_age.json","/onmap/public/ecnmy_24/amt_gender_age.json"})
	@ResponseBody
	public Object onmapEcnmy24AmtGenderAge( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String, Object> param) {
		
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("list", ecnmy24Dao.getAmtGenderAgeChart(param));
		
		return rmap;
	}
	
	/**
	 * 지자체 현황[page02-01 - 통신사] : 성/연령별 대표인구 (유동인구 특성 - chart)
	 * 
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/ecnmy_24/float_gender_age.json","/onmap/public/ecnmy_24/float_gender_age.json"})
	@ResponseBody
	public Object onmapEcnmy24FloatGenderAge( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String, Object> param) {
		
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("list", ecnmy24Dao.getFloatGenderAgeChart(param));
		
		return rmap;
	}
	
	/**
	 * 지자체 현황[page02-02 - 카드사, 통신사] : 읍면동 간 비교 (주민등록인구, 총 유동인구, 총 거래금액, 총 거래량 - text)
	 * 
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/ecnmy_24/admi_state_txt.json","/onmap/public/ecnmy_24/admi_state_txt.json"})
	@ResponseBody
	public Object onmapEcnmy24AdmiStateTxet( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String, Object> param) {
		
		Map<String, Object> rmap = new HashMap<String, Object>();
		if ( param.get("admiCd") != null && !param.get("admiCd").equals("") ) {			
			rmap.put("list",ecnmy24Dao.getAdmiStateTxt(param));
		}else {
			rmap.put("list",ecnmy24Dao.getAdmiStateTxt2(param));
		}
		
		return rmap;
	}
	
	/**
	 * 지자체 현황[page02-02 - 카드사, 통신사] : 읍면동 간 비교 (list)
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/ecnmy_24/admi_state_list.json","/onmap/public/ecnmy_24/admi_state_list.json"})
	@ResponseBody
	public Object onmapEcnmy24AdmiStateList( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String, Object> param) {
		
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("list", ecnmy24Dao.getAdmiStateList(param));
		
		return rmap;
	}
	
}
