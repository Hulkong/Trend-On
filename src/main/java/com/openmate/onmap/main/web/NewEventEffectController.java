package com.openmate.onmap.main.web;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.openmate.frmwrk.mapapp.dao.FeatureInfo;
import com.openmate.frmwrk.mapapp.service.MapAppService;
import com.openmate.onmap.common.dao.CommonDao;
import com.openmate.onmap.main.dao.EventEffectDao;

@Controller
public class NewEventEffectController {
	
	@Resource(name = "eventEffectDao")
	private EventEffectDao eventEffectDao;
	
	@Resource(name = "commonDao")
	private CommonDao commonDao;

	@Resource(name = "onmapSqlSession")
	private SqlSessionFactory sessionFactory ;

	@Resource(name = "mapAppService")
	private MapAppService mapAppService;
	
	
	/**
	 * event page 연결
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = "/onmap/event_effect/main.do")
	public String eventPage( HttpServletRequest req, HttpServletResponse res
						   , Map<String,Object> map
						   , @RequestParam Map<String, Object> param){
		
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		Object obj = auth.getPrincipal();
		int serviceClss = 0;  // 서비스유형 코드
		
		if (obj != null && obj instanceof com.openmate.frmwrk.user.User) {
			com.openmate.frmwrk.user.User usr = (com.openmate.frmwrk.user.User) obj;
//			serviceClss = usr.getServiceClss();
			map.put("userId", usr.getUsername());
			Map xInfo = (Map) usr.getExtInfo();
			serviceClss = Integer.valueOf( xInfo.get("service_clss").toString() );
			map.put("serviceClss", serviceClss);
			param.put("ctyCd" , xInfo.get("cty_cd"));
			param.put("rgnClss" , "H4");
		}

		
		try{
			Map range = commonDao.getDateRange(param);
			
			SimpleDateFormat dt = new SimpleDateFormat("yyyyMMdd"); 
			Date maxDate = dt.parse((String)range.get("max_stdr_date")); 
			Calendar cal= Calendar.getInstance();
			cal.setTime(maxDate);
			
			cal.add(cal.MONTH, - 13);
			cal.add(cal.DATE, cal.getActualMaximum(cal.DAY_OF_MONTH) + 13);
			map.put("endDate", dt.format(cal.getTime()));					// 기본 선택 마지막날
			param.put("endDate", dt.format(cal.getTime()));
			
			cal.add(cal.MONTH, - 12);
			map.put("lastEndDate", dt.format(cal.getTime()));				// 기본 선택 작년 마지막날
			
			// 테스트일 때 3개월 기간 지정, 그 외는 6개월
			if(serviceClss == 3) {
				cal.setTime(dt.parse("20180715"));
				map.put("endDate", "20180715");	// top 그래프의 초기 선택 종료일
				map.put("lastEndDate","20170715");
				cal.add(cal.MONTH, - 1); 
				
				// 전체 시계열 그래프의 기준 시작일/ 종료일
				map.put("min_stdr_date", "20180101");
				map.put("max_stdr_date", "20181231");
			} else {
				cal.add(cal.MONTH, + 12);
				cal.add(cal.MONTH, - 2); 
				
				// 전체 시계열 그래프의 기준 시작일/ 종료일
				map.put("min_stdr_date", range.get("min_stdr_date"));
				map.put("max_stdr_date", range.get("max_stdr_date"));
			}
			
			
			
			cal.add(cal.DATE, +1);
			map.put("startDate", dt.format(cal.getTime()));					// 기본 선택 시작일
			param.put("startDate", dt.format(cal.getTime()));

			cal.add(cal.MONTH, - 12);
			map.put("lastStartDate", dt.format(cal.getTime()));					// 기본 선택 작년 시작일
		
			List<Map> amdiList = commonDao.getAreaSelectOption(param); 
			map.put("selectAmdi", amdiList.get(0).get("id"));	// 기본 행정동 선택(리스트의 가장 위에 있는 행정동으로 지정) - id
			map.put("selectAmdiKr", amdiList.get(0).get("nm"));	// 기본 행정동 선택(리스트의 가장 위에 있는 행정동으로 지정) - nm
			param.put("admiCd", amdiList.get(0).get("id"));

			map.put("amdiList", amdiList);						// 해당 시군구의 행정도 list 가져오기
			map.put("flg", eventEffectDao.getFlg(param));	//	동/읍(1), 면(0) 구분 값 가져오기 

		}catch(Exception e){
			e.printStackTrace();
		}
		
		
		return "onmap/event_effect/main";
	}
	
	/**
	 * [공통] 읍면동 구분 플러그 
	 * @param req
	 * @param res
	 * @param param
	 * @return
	 */
	@RequestMapping(value = "/onmap/event_effect/getAdmiFlg.json")
	@ResponseBody
	public String eventAdmiFlg( HttpServletRequest req, HttpServletResponse res
							  , @RequestParam Map<String, Object> param){
		return eventEffectDao.getFlg(param);	//	동/읍(1), 면(0) 구분 값 가져오기
	}
	
	/**
	 * [공통] 인접 행정동 리스트
	 * @param req
	 * @param res
	 * @param param
	 * @return
	 */
	@RequestMapping(value = "onmap/event_effect/getAdmiList.json")
	@ResponseBody
	public Object getAdmiList( HttpServletRequest req
							 , HttpServletResponse res
							 , @RequestParam Map<String, Object> param) {
		
		Map<String,Object> rtnMap = new HashMap<String, Object>();
		List<Map> admiAroundList = eventEffectDao.getAdmiCnt(param);	// 주변지역 id list
		
		String admiAround = "";
		if(admiAroundList.size() >= 3){
			for(Map aa : admiAroundList){
				admiAround += ",'"+aa.get("id")+"'";
			}
			admiAround = admiAround.substring(1);
		}
		rtnMap.put("admiAround", admiAround);
		
		return rtnMap; // admi id 리스트 가져오기
	}
	
	/**
	 * 이벤트 효과: 지도경계 도형가져오기(행정동)		- line 74
	 * 
	 * @param req
	 * @param res
	 */
	
	/**
	 * 이벤트 효과: 지도경계 도형가져오기2(행정동)		- line 74
	 *           (선택 행정동을 포함한 시군구의 전체 행정동 리스트 가져오기)
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/event_effect/getEventMapAll.json","/onmap/public/event_effect/getEventMapAll.json"})
	public void onmapEventEffectmap2( HttpServletRequest req, HttpServletResponse res
								   , @RequestParam(value="layerName", required=false, defaultValue = "featureLayer") String layerName
								   , @RequestParam Map<String, Object> param) {
		
		FeatureInfo finfo = new FeatureInfo();
		
		finfo.setLayerCrs("KATEC");
		finfo.setLayerName(layerName);
		finfo.setMapperId("com.openmate.onmap.main.dao.EventEffectDao.getEventMapAll");
		finfo.setTargetCrs("EPSG:4326");

		mapAppService.writeFeature(req, res, mapAppService.getFeature(finfo, param, sessionFactory));

	}
	
	
	/**
	 * 이벤트 효과 : 지도경계 도형가져오기(시군구)	- line 96
	 * 
	 * @param req
	 * @param res
	 */
	
	
	
	/**
	 * 시계열 그래프( page 상단 range bar )
	 * @param req
	 * @param res
	 * @param param
	 * @return
	 */
	@RequestMapping(value = "/onmap/event_effect/graph_data.json")
	@ResponseBody
	public Object eventEffectGraphData( HttpServletRequest req
										, HttpServletResponse res
										, @RequestParam Map<String, Object> param) {
		
		Map<String,Object> rtnMap = new HashMap<String, Object>();

		try{
			rtnMap.put("data", eventEffectDao.getEventEffectGraphData(param));	// 시계열 그래프 - 소비인구
			rtnMap.put("data2", eventEffectDao.getEventEffectGraphData02(param));	// 시계열 그래프 - 유동인구
		}catch(Exception e){
			e.printStackTrace();
		}
		return rtnMap;
	}
	
	
	/**
	 * 이벤트효과[page01-01 - 카드사] : 행정동의 경제효과 변화 ( 총 경제효과 변화률, 평상시평균, 이벤트기간평균 - text)
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = {"/onmap/event_effect/amt_chnge_txt.json","/onmap/public/event_effect/amt_chnge_txt.json"})
	@ResponseBody
	public Object eventAmtChangeText( HttpServletRequest req, HttpServletResponse res
							  		, @RequestParam Map<String, Object> param){
		
		Map<String,Object> rmap = new HashMap<String,Object>();
		rmap.put("thisAmtChnge", eventEffectDao.getThisAmtChnge(param));	// page01. 총 경제효과 변화
		return rmap;
	}
	
	/**
	 * 이벤트효과[page01-01 - 카드사] : 행정동의 경제효과 변화 ( 총 경제효과 변화 - chart)  -- line 282
	 * @param req
	 * @param res
	 * @return
	 */

	/**
	 * 이벤트효과[page01-02 - 통신사] : 행정동의 유동인구 변화 ( 총 유동인구 변화률, 평상시평균, 이벤트기간평균 - text)
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = {"/onmap/event_effect/float_chnge_txt.json","/onmap/public/event_effect/float_chnge_txt.json"})
	@ResponseBody
	public Object eventFloatChangeText( HttpServletRequest req, HttpServletResponse res
									  , @RequestParam Map<String, Object> param){
		
		Map<String,Object> rmap = new HashMap<String,Object>();
		rmap.put("thisFloat", eventEffectDao.getThisFloatChnge(param));	// page01. 유동인구 변화(총 유동인구 변화률, 평상시평균, 이벤트기간평균)
		
		return rmap;
	}
	
	/**
	 * 이벤트효과[page01-02 - 카드사] : 행정동의 유동인구 변화 ( 주별 유동인구 변화 - chart)
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = {"/onmap/event_effect/float_chnge_chart.json","/onmap/public/event_effect/float_chnge_chart.json"})
	@ResponseBody
	public Object eventFloatchangeChart( HttpServletRequest req, HttpServletResponse res
										 , @RequestParam Map<String, Object> param ){
		
		Map<String,Object> rmap = new HashMap<String,Object>();
		rmap.put("thisFloatList", eventEffectDao.getEventEffectThisFloatList(param));	// 선택 이벤트기간과 앞뒤 총 5주간의 유동인구 변화 리스트
		rmap.put("lastFloatList", eventEffectDao.getEventEffectLastFloatList(param));	// 선택 비교기간과 앞뒤 총 5주간의 유동인구 변화 리스트
		
		return rmap;
	}
	
	
	/**
	 * 이벤트효과[page02-01 - 카드사] : 주변지역 경제효과 ( 거래금액, 거래량 기준별 경제효과 - text)  - line 301
	 * @param req
	 * @param res
	 */
	
	
	
	/**
	 *  이벤트효과[page02-01 - 카드사] : 주변지역 경제효과 ( 거래금액, 거래량 기준별 경제효과 - 주제도)  - line 118
	 * @param req
	 * @param res
	 */
	

	
	/**
	 * 이벤트효과[page02-02 - 통신사] : 주변지역 유동인구 변화 ( 선택한 행정동의 유동인구 변화, 주변지역 유동인구 변화리스트 - text) 
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = {"/onmap/event_effect/region_float_txt.json","/onmap/public/event_effect/region_float_txt.json"})
	@ResponseBody
	public Object eventRegionFloatText( HttpServletRequest req, HttpServletResponse res
										 , @RequestParam Map<String, Object> param ){
		
		Map<String,Object> rmap = new HashMap<String,Object>();
		rmap.put("thisFloat", eventEffectDao.getThisFloatChnge(param));	// page01. 유동인구 변화(총 유동인구 변화률, 평상시평균, 이벤트기간평균)
		rmap.put("list", eventEffectDao.getRegionFloatTxt(param));			// 주변지역 유동인구 변화리스트
		
		return rmap;
	}
	
	/**
	 * 이벤트효과[page02-02 - 통신사] : 주변지역 유동인구 변화 ( 주변지역 유동인구 변화리스트 - 주제도) 
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = {"/onmap/event_effect/region_float_map.json","/onmap/public/event_effect/region_float_map.json"})
	@ResponseBody
	public Object eventRegionFloatMap( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String, Object> param ){
		
		Map<String,Object> rmap = new HashMap<String,Object>();
		rmap.put("list", eventEffectDao.getRegionFloatMap(param));		// 주변지역 유동인구 변화리스트
		
		return rmap;
	}
	
	
	/**
	 *  이벤트효과[page03-01 - 카드사, 통신사] : 성/연령별 대표인구 ( 유동인구, 소비인구 - text)
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/event_effect/event_gender_age.json","/onmap/public/event_effect/event_gender_age.json"})
	@ResponseBody
	public Object eventAllGenderAge( HttpServletRequest req, HttpServletResponse res
										 , @RequestParam Map<String, Object> param ){
		
		Map<String,Object> rmap = new HashMap<String,Object>();
		rmap.put("amtTxt", eventEffectDao.getEventAmtChartr(param));
		rmap.put("floatTxt", eventEffectDao.getEventFloatChartr(param));
		
		return rmap;
	}
	
	/**
	 *  이벤트효과[page03-01 - 카드사] : 성/연령별 대표인구 ( 소비인구 - chart)
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/event_effect/event_sale_list.json","/onmap/public/event_effect/event_sale_list.json"})
	@ResponseBody
	public Object eventSaleList( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String, Object> param ){
		
		Map<String,Object> rmap = new HashMap<String, Object>();
		rmap.put("list", eventEffectDao.getEventSaleList(param));
		
		return rmap;
	}
	
	/**
	 *  이벤트효과[page03-01 - 통신사] : 성/연령별 대표인구 ( 유동인구 - chart)
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/event_effect/event_float_list.json","/onmap/public/event_effect/event_float_list.json"})
	@ResponseBody
	public Object eventFloatList( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String, Object> param ){
		
		Map<String,Object> rmap = new HashMap<String, Object>();
		rmap.put("list", eventEffectDao.getEventFloatList(param));
		
		return rmap;
	}
	
	/**
	 * 이벤트효과[page03-02 - 카드사] : 업종별 경제효과 ( 거래금액, 거래량 - text)	-- line 322
	 * @param req
	 * @param res
	 */

	
	/**
	 * 이벤트효과[page03-02 - 카드사] : 업종별 거래금액 그래프  - line 378
	 * @param req
	 * @param res
	 */
	
	
	/**
	 * 이벤트효과[page03-02 - 카드사] : 업종별 거래변화율 그래프 - line 421
	 * @param req
	 * @param res
	 */
	
	
	/**
	 *  이벤트효과[page04-01 - 통신사] : 유입 유동인구 수 ( 선택행정동 유입유동인구 수, 주변행정동 유입유동인구 수 리스트 - text)
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/event_effect/event_inflow_float.json","/onmap/public/event_effect/event_inflow_float.json"})
	@ResponseBody
	public Object getEventInflowFloat( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String, Object> param ){
		
		Map<String,Object> rmap = new HashMap<String,Object>();
		rmap.put("floatTxt", eventEffectDao.getEventInflowFloatCnt(param));
		rmap.put("list", eventEffectDao.getEventInflowFloatList(param));
		
		return rmap;
	}
	
	/**
	 *  이벤트효과[page04-01 - 통신사] : 유입 유동인구 수 ( 주제도 )
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/event_effect/inflow_float_map.json","/onmap/public/event_effect/inflow_float_map.json"})
	@ResponseBody
	public Object getEventInflowFloatMap( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String, Object> param ){
		
		Map<String,Object> rmap = new HashMap<String,Object>();
		rmap.put("list", eventEffectDao.getEventInflowFloatMap(param));
		
		return rmap;
	}
	
	/**
	 *  이벤트효과[page04-02 - 카드사, 통신사] : 유입인구 성/연령별 특성 ( 유입유동인구, 유입 소비인구 특성 -text )
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/event_effect/inflow_gender_age.json","/onmap/public/event_effect/inflow_gender_age.json"})
	@ResponseBody
	public Object getInflowGenderAge( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String, Object> param ){
		
		Map<String,Object> rmap = new HashMap<String,Object>();
		rmap.put("amtTxt", eventEffectDao.getEventVisitrChartr(param));
		rmap.put("floatTxt", eventEffectDao.getEventInflowFloatTxt(param));
		
		return rmap;
	}
	
	
	/**
	 *  이벤트효과[page04-02 - 카드사] : 유입 소비인구 성/연령별 특성 ( chart )
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/event_effect/inflow_amt_chart.json","/onmap/public/event_effect/inflow_amt_chart.json"})
	@ResponseBody
	public Object getInflowAmtChart( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String, Object> param ){
		
		Map<String,Object> rmap = new HashMap<String,Object>();
		rmap.put("list", eventEffectDao.getInflowSaleList(param));
		
		return rmap;
	}
	
	/**
	 *  이벤트효과[page04-02 - 통신사] : 유입 유동인구 성/연령별 특성 ( chart )
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/event_effect/inflow_float_chart.json","/onmap/public/event_effect/inflow_float_chart.json"})
	@ResponseBody
	public Object getInflowFloatChart( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String, Object> param ){
		
		Map<String,Object> rmap = new HashMap<String,Object>();
		rmap.put("list", eventEffectDao.getInflowFloatList(param));
		
		return rmap;
	}
	
	
	/**
	 *  이벤트효과[page05-01 - 통신사, 카드사] : 유입인구 시간대 특성 ( text )
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/event_effect/inflow_time_txt.json","/onmap/public/event_effect/inflow_time_txt.json"})
	@ResponseBody
	public Object getInflowTimeTxt( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String, Object> param ){
		
		Map<String,Object> rmap = new HashMap<String,Object>();
		rmap.put("amtTxt", eventEffectDao.getEventVisitrCnsmpTime(param));
		rmap.put("floatTxt", eventEffectDao.getInflowTimeText(param));
		
		return rmap;
	}
	
	/**
	 *  이벤트효과[page05-01 - 통신사, 카드사] : 유입인구 시간대 특성 ( chart )
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/event_effect/inflow_time_chart.json","/onmap/public/event_effect/inflow_time_chart.json"})
	@ResponseBody
	public Object getInflowTimeChart( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String, Object> param ){
		
		Map<String,Object> rmap = new HashMap<String,Object>();
		rmap.put("list", eventEffectDao.getInflowTimeChart(param));
		
		return rmap;
	}
	
	/**
	 *  이벤트효과[page05-02 - 통신사] : 유입 유동인구 유입지역 ( text )
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/event_effect/inflow_region_txt.json","/onmap/public/event_effect/inflow_region_txt.json"})
	@ResponseBody
	public Object getInflowFloatRegion( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String, Object> param ){
		
		Map<String,Object> rmap = new HashMap<String,Object>();
		rmap.put("floatTxt", eventEffectDao.getInflowRegionTxt(param));
		rmap.put("list", eventEffectDao.getInflowRegionList(param));
		
		return rmap;
	}
	
	/**
	 *  이벤트효과[page05-02 - 통신사] : 유입 유동인구 유입지역 ( 주제도 )
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/event_effect/inflow_region_map.json","/onmap/public/event_effect/inflow_region_map.json"})
	@ResponseBody
	public Object getInflowRegionMap( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String, Object> param ){
		
		Map<String,Object> rmap = new HashMap<String,Object>();
		rmap.put("list", eventEffectDao.getInflowRegionMap(param));
		
		return rmap;
	}
}
