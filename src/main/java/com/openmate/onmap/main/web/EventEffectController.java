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
public class EventEffectController {
	/**
	 * 수정자: 김용현
	 * 수정일: 2018.10.15
	 * 내용: 서비스유형 추가 및 기간 세팅
	 */
	
	@Resource(name = "eventEffectDao")
	private EventEffectDao eventEffectDao;
	
	@Resource(name = "commonDao")
	private CommonDao commonDao;

	@Resource(name = "onmapSqlSession")
	private SqlSessionFactory sessionFactory ;



	@Resource(name = "mapAppService")
	private MapAppService mapAppService;

	

	
	@RequestMapping(value = "/onmap/event_effect/main_sub.do")
	public String eventSubPage( HttpServletRequest req, HttpServletResponse res
							  , Map<String,Object> map
							  , @RequestParam Map<String, Object> param){
		
		param.put("ctyCd", "1168");
		param.put("startDate", "20161230");
		param.put("endDate", "20161231");
		param.put("rgnClss",  "H4");
//		param.put("ctyCd", req.getParameter("ctyCd"));
//		param.put("startDate", req.getParameter("startDate"));
//		param.put("endDate", req.getParameter("endDate"));
//		param.put("rgnClss", req.getParameter("rgnClss"));
		
		

		return "onmap/event_effect/main_sub";
	}
	
	
	/**
	 * 이벤트 효과: 지도(행정동)
	 * 
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/event_effect/getEventMap.json","/onmap/public/event_effect/getEventMap.json"})
	public void onmapEventEffectmap( HttpServletRequest req, HttpServletResponse res
								   , @RequestParam(value="layerName", required=false, defaultValue = "featureLayer") String layerName
								   , @RequestParam Map<String, Object> param) {
		
		FeatureInfo finfo = new FeatureInfo();
		
		finfo.setLayerCrs("KATEC");
		finfo.setLayerName(layerName);
		finfo.setMapperId("com.openmate.onmap.main.dao.EventEffectDao.getEventMap");
		finfo.setTargetCrs("EPSG:4326");

		mapAppService.writeFeature(req, res, mapAppService.getFeature(finfo, param, sessionFactory));

	}
	
	/**
	 * 경제트렌드 : 지도(시군구)
	 * 
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/event_effect/getEventCtyMap.json","/onmap/public/event_effect/getEventCtyMap.json"})
	public void onmapEcnmyTrndCtymap( HttpServletRequest req, HttpServletResponse res
			 						, @RequestParam Map<String, Object> param) {
		
		FeatureInfo finfo = new FeatureInfo();
		
		finfo.setLayerCrs("KATEC");
		finfo.setLayerName(req.getParameter("layerName"));
		finfo.setMapperId("com.openmate.onmap.main.dao.EventEffectDao.getEventCtyMap");
		finfo.setTargetCrs("EPSG:4326");
		
		mapAppService.writeFeature(req, res, mapAppService.getFeature(finfo, param, sessionFactory));
		
	}
	
	
	/**
	 * 이벤트1 : 매출액 - 지도
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/event_effect/salamt_chnge.json","/onmap/public/event_effect/salamt_chnge.json"})
	@ResponseBody
	public Object onmapEventSalamtChnge( HttpServletRequest req, HttpServletResponse res
									   , @RequestParam Map<String, Object> param ){
		
		Map<String,Object> rmap = new HashMap<String,Object>();
		rmap.put("list", eventEffectDao.getEventSalamtChnge(param));
		
		
		return rmap;
	}
	
	/**
	 * 이벤트1 : 매출액 - 지도 범례
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/event_effect/salamt_chnge_legend.json","/onmap/public/event_effect/salamt_chnge_legend.json"})
	@ResponseBody
	public Object getSalamtChngeLegend( HttpServletRequest req, HttpServletResponse res
									  , @RequestParam Map<String, Object> param ){
		
		Map<String,Object> rmap = new HashMap<String,Object>();
		rmap.put("legend", eventEffectDao.getSalamtChngeLegend(param));
		
		return rmap;
	}
	
	/**
	 * 이벤트 2: 거래액(금액) - 지도
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/event_effect/expndtr_chnge.json","/onmap/public/event_effect/expndtr_chnge.json"})
	@ResponseBody
	public Object onmapEventExpndtrChnge( HttpServletRequest req, HttpServletResponse res
										, @RequestParam Map<String, Object> param ){
		
		Map<String,Object> rmap = new HashMap<String,Object>();
		rmap.put("list", eventEffectDao.getEventExpndtrChnge(param));
		
		return rmap;
		
	}
	
	/**
	 * 이벤트 2: 거래액(금액) - 지도  범례
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/event_effect/expndtr_chnge_legend.json","/onmap/public/event_effect/expndtr_chnge_legend.json"})
	@ResponseBody
	public Object getExpndtrChngeLegend(  HttpServletRequest req, HttpServletResponse res
										, @RequestParam Map<String, Object> param ){
		
		Map<String,Object> rmap = new HashMap<String,Object>();
		rmap.put("legend", eventEffectDao.getExpndtrChngeLegend(param));
		
		return rmap;
	}
	
	/**
	 * 이벤트 3: 거래액(비율) - 지도
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/event_effect/expndtr_rate_chnge.json","/onmap/public/event_effect/expndtr_rate_chnge.json"})
	@ResponseBody
	public Object onmapEventExpndtrRateChnge( HttpServletRequest req, HttpServletResponse res
											, @RequestParam Map<String, Object> param ){
		
		Map<String,Object> rmap = new HashMap<String,Object>();
		rmap.put("list", eventEffectDao.getEventExpndtrRateChnge(param));
		
		return rmap;
		
	}
	
	/**
	 * 이벤트 3: 거래액(비율) - 지도 범례
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/event_effect/expndtr_rate_chnge_legend.json","/onmap/public/event_effect/expndtr_rate_chnge_legend.json"})
	@ResponseBody
	public Object getExpndtrRateChngeLegend(  HttpServletRequest req, HttpServletResponse res
											, @RequestParam Map<String, Object> param ){
		
		Map<String,Object> rmap = new HashMap<String,Object>();
		rmap.put("legend", eventEffectDao.getExpndtrRateChngeLegend(param));
		
		return rmap;
	}
	
	/**
	 * 이벤트 4: 방문객수 - 지도
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/event_effect/visitr_cnt_chnge.json","/onmap/public/event_effect/visitr_cnt_chnge.json"})
	@ResponseBody
	public Object onmapEventVisitrCntChnge( HttpServletRequest req, HttpServletResponse res
										  , @RequestParam Map<String, Object> param ){
		
		Map<String,Object> rmap = new HashMap<String,Object>();
		rmap.put("list", eventEffectDao.getEventVisitrCntChnge(param));
		
		return rmap;
	}
	
	/**
	 * 이벤트 4: 방문객수 - 지도 범례
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/event_effect/visitr_cnt_chnge_legend.json","/onmap/public/event_effect/visitr_cnt_chnge_legend.json"})
	@ResponseBody
	public Object onmapEventVisitrCntChngeLegend( HttpServletRequest req, HttpServletResponse res
												, @RequestParam Map<String, Object> param ){
	
		Map<String,Object> rmap = new HashMap<String,Object>();
		rmap.put("legend", eventEffectDao.getVisitrCntChngeLegend(param));
		
		return rmap;
	}
	
	
	/**
	 * 이벤트 6: 방문객 소비시간 - 지도
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/event_effect/visitr_cnsmp_time_chnge.json","/onmap/public/event_effect/visitr_cnsmp_time_chnge.json"})
	@ResponseBody
	public Object onmapEventVisitrCnsmpTimeChnge( HttpServletRequest req, HttpServletResponse res
												, @RequestParam Map<String, Object> param ){
		
		Map<String,Object> rmap = new HashMap<String,Object>();
		rmap.put("list", eventEffectDao.getEventVisitrCnsmpTimeChnge(param));
		
		return rmap;	
	}
	
	/**
	 * 이벤트 6: 방문객 소비시간  - 지도 범례
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/event_effect/visitr_cnsmp_time_chnge_legend.json","/onmap/public/event_effect/visitr_cnsmp_time_chnge_legend.json"})
	@ResponseBody
	public Object onmapEventVisitrCnsmpTimeChngeLegend( HttpServletRequest req, HttpServletResponse res
													  , @RequestParam Map<String, Object> param ){
		
		Map<String,Object> rmap = new HashMap<String,Object>();
		rmap.put("legend", eventEffectDao.getVisitrCnsmpTimeChngeLegend(param));
		
		return rmap;
	}
	
	/**
	 * 이벤트1-1 : Line CHART DATA
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = {"/onmap/event_effect/event_effect_charts.json","/onmap/public/event_effect/event_effect_charts.json"})
	@ResponseBody
	public Object getEventEffectChartData( HttpServletRequest req, HttpServletResponse res
										 , @RequestParam Map<String, Object> param ){
		
		Map<String,Object> rmap = new HashMap<String,Object>();
		
		rmap.put("thisAmtList", eventEffectDao.getEventEffectThisAmtList(param));	// page1.line chart - 이번연도
		rmap.put("lastAmtList", eventEffectDao.getEventEffectLastAmtList(param));	// page1.line chart - 이전연도
		
		return rmap;
	}
	
	/**
	 * 이벤트1-1, 이벤트 2-1 : 총 경제 효과, 주변지역 경제효과 text
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/event_effect/region_amt_chnge_text.json","/onmap/public/event_effect/region_amt_chnge_text.json"})
	@ResponseBody
	public Object getRegionAmtChnge(  HttpServletRequest req, HttpServletResponse res
									, @RequestParam Map<String, Object> param){
		
		Map<String,Object> rmap = new HashMap<String,Object>();
		
		rmap.put("thisAmtChnge", eventEffectDao.getThisAmtChnge(param));	// page1-1. 총 경제효과 - 현재
		rmap.put("thisCntChnge", eventEffectDao.getThisCntChnge(param)); // page2-1. 주변지역 경제효과 : 해당행정동 (거래량기준)
		rmap.put("mxmIncrsAmt", eventEffectDao.getMxmIncrsAmt(param)); // page2-1. 주변지역 경제효과 : 매출액 기준
		rmap.put("mxmIncrsRate", eventEffectDao.getMxmIncrsRate(param)); // page2-1. 주변지역 경제효과 : 거래량 기준
		
		
		return rmap;
	}
	
	/**
	 * 이벤트2-1 (version 2): 경제 효과 순위 text
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/event_effect/upjong_amt_chnge_text2.json","/onmap/public/event_effect/upjong_amt_chnge_text2.json"})
	@ResponseBody
	public Object getUpjongAmtChnge2( HttpServletRequest req, HttpServletResponse res
									 , @RequestParam Map<String, Object> param ){
		
		Map<String,Object> rmap = new HashMap<String,Object>();
		
		rmap.put("upjongAmtChngeList", eventEffectDao.getUpjongAmtChnge(param));	// page2-1. 업종별 경제효과 (매출액 기준)
		rmap.put("upjongRateChngeList", eventEffectDao.getUpjongRateChnge(param)); // page2-1. 업종별 거래금액 (거래량 기준)
		
		return rmap;
	}
	
	/**
	 * 이벤트2-2 : 주변지역 업종별 경제효과 text ( 매출액 기준 )
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/event_effect/upjong_rate_chnge_text1.json","/onmap/public/event_effect/upjong_rate_chnge_text1.json"})
	@ResponseBody
	public Object getUpjongRateChnge1( HttpServletRequest req, HttpServletResponse res
									, @RequestParam Map<String, Object> param ){
		
		Map<String,Object> rmap = new HashMap<String,Object>();
		
		rmap.put("areaUpjongAmtChnge", eventEffectDao.getAreaUpjongAmtChnge(param));  //page2-2.주변지역 업종별 변화 (매출액 기준) list
		rmap.put("upjongAmtChngeList", eventEffectDao.getThisAreaUpjongAmtChnge(param));	// page2-2. 주변지역 업종별 - 해당지역  (매출액 기준)
		
			
		return rmap;
	}
	
	/**
	 * 이벤트2-2 : 주변지역 업종별 경제효과 text ( 거래량 기준 )
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/event_effect/upjong_rate_chnge_text2.json","/onmap/public/event_effect/upjong_rate_chnge_text2.json"})
	@ResponseBody
	public Object getUpjongRateChnge2( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String, Object> param ){
		
		Map<String,Object> rmap = new HashMap<String,Object>();
		
		rmap.put("rateRank", eventEffectDao.getAreaUpjongRateChnge(param)); //page2-2. 주변지역 업종별 변화 (거래량 기준) list
		rmap.put("upjongRateChngeList", eventEffectDao.getThisAreaUpjongRateChnge(param)); // page2-2. 주변지역 업종별 - 해당지역 (거래량 기준)
		
		return rmap;
	}
	
	
	/**
	 * 이벤트2 : 업종별 거래금액 그래프
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/event_effect/upjong_amt_chnge_graph.json","/onmap/public/event_effect/upjong_amt_chnge_graph.json"})
	@ResponseBody
	public Object getUpjongAmtChngeGraph( HttpServletRequest req, HttpServletResponse res
										, @RequestParam Map<String, Object> param ){
		
		Map<String,Object> rmap = new HashMap<String,Object>();
		rmap.put("thisList", eventEffectDao.getUpjongAmtChngeGraph(param));
		
		return rmap;
	}
	
	/**
	 * 이벤트2 : 업종별 거래금액 text ( 현재 사용 하지 않고 있음  - 이벤트 2 version 2 에 포함된 내용 )
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/event_effect/upjong_amt_chnge_text.json","/onmap/public/event_effect/upjong_amt_chnge_text.json"})
	@ResponseBody
	public Object getUpjongAmtChnge(  HttpServletRequest req, HttpServletResponse res
									, @RequestParam Map<String, Object> param ){
		
		Map<String,Object> rmap = new HashMap<String,Object>();
		
		List<Map> upjongAmtChngeList = eventEffectDao.getUpjongAmtChnge(param); 				// page2. 업종별 거래금액 변화 
		if(upjongAmtChngeList.size() > 0){
			int i = 1; 
			for(Map result:upjongAmtChngeList){
				param.put("upjong", result.get("code"));
				rmap.put("areaUpjongAmtChnge"+i, eventEffectDao.getAreaUpjongAmtChnge(param));  //page2. 지역별 업종별 변화 (거래금액)
				i++;
			}
		}
		rmap.put("upjongAmtChngeList", upjongAmtChngeList);	
		

		return rmap;
	}
	
	/**
	 * 이벤트3 : 업종별 거래변화율 그래프
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/event_effect/upjong_rate_chnge_graph.json","/onmap/public/event_effect/upjong_rate_chnge_graph.json"})
	@ResponseBody
	public Object getUpjongRateChngeGraph( HttpServletRequest req, HttpServletResponse res
										 , @RequestParam Map<String, Object> param ){

		Map<String,Object> rmap = new HashMap<String,Object>();
		rmap.put("thisList", eventEffectDao.getUpjongRateChngeGraph(param));
		
		return rmap;
	}
	
	/**
	 * 이벤트4 : 방문객 text
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/event_effect/event_visitr_text.json","/onmap/public/event_effect/event_visitr_text.json"})
	@ResponseBody
	public Object getEventVisitrText( HttpServletRequest req, HttpServletResponse res
									, @RequestParam Map<String, Object> param ){
		
		Map<String,Object> rmap = new HashMap<String,Object>();
		rmap.put("visitrTotal", eventEffectDao.getEventVisitrCnt(param));			// page4. 방문객 총 수
		rmap.put("visitrCntList", eventEffectDao.getEventVisitrCntList(param));		// page4. 방문객 순위
		rmap.put("visitrChartr", eventEffectDao.getEventVisitrChartr(param));		// page4. 방문객 특성
		rmap.put("visitrCtznChartr", eventEffectDao.getEventCtznChartr(param));		// page4. 시민 특성
		
		return rmap;
	}
	
	/**
	 * 이벤트4 : 지역시민 vs 방문객 그래프
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/event_effect/visitr_ctzn_graph.json","/onmap/public/event_effect/visitr_ctzn_graph.json"})
	@ResponseBody
	public Object getVisitrCtznGraph( HttpServletRequest req, HttpServletResponse res
									, @RequestParam Map<String, Object> param ){
		
		Map<String,Object> rmap = new HashMap<String,Object>();
		rmap.put("list", eventEffectDao.getEventVisitrCtznGraph(param));
		
		return rmap;
	}
	
	
	/**
	 * 이벤트6 : 방문객 소비시간 text
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/event_effect/event_cnsmp_time_text.json","/onmap/public/event_effect/event_cnsmp_time_text.json"})
	@ResponseBody
	public Object getEventCnsmpTimeText(  HttpServletRequest req, HttpServletResponse res
										, @RequestParam Map<String, Object> param ){
		
		Map<String,Object> rmap = new HashMap<String,Object>();

		List<Map> visitrCnsmpTime = eventEffectDao.getEventVisitrCnsmpTime(param); 				// page6. 방문객 소비시간
		List<Map> visitrInflow = eventEffectDao.getEventVisitrInflow(param); 				// page6. 방문객 유입지역

		rmap.put("visitrCnsmpTime", visitrCnsmpTime);
		rmap.put("visitrInflow", visitrInflow);
		
		return rmap;
	}
	
	/**
	 * 이벤트6 : 방문객 vs 시민 그래프
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/event_effect/event_cnt_time_graph.json","/onmap/public/event_effect/event_cnt_time_graph.json"})
	@ResponseBody
	public Object getEventCntTimeGraph( HttpServletRequest req, HttpServletResponse res
									  , @RequestParam Map<String, Object> param ){
		
		Map<String,Object> rmap = new HashMap<String,Object>();
		
		List<Map> cntTime = eventEffectDao.getCntTimeGraph(param);		
		rmap.put("cntTime", cntTime);
		
		return rmap;
	}
	

	
	@RequestMapping(value = "onmap/event_effect/getUpjongOption.json")
	@ResponseBody
	public Object getUpjongOption( HttpServletRequest req
								 , HttpServletResponse res
								 , @RequestParam Map<String, Object> param) {
		
		return  eventEffectDao.admiUpjongList(param); // 업종 selectbox option 가져오기
	}
	

	
	/**
	 * 유효성 검사 - 너무 작은 데이터는 나오지않게 하기 위한 검사
	 * @param req
	 * @param res
	 * @param param
	 * @return
	 */
	@RequestMapping(value = {"/onmap/event_effect/validateChk.json","/onmap/public/event_effect/validateChk.json"})
	@ResponseBody
	public Object validateChk(  HttpServletRequest req, HttpServletResponse res
									, @RequestParam Map<String, Object> param){
		
		Map<String,Object> rmap = new HashMap<String,Object>();
		
		rmap.put("thisAmtChnge", eventEffectDao.getThisAmtChnge(param));	        // page1-1. 총 경제효과 - 현재( 이벤트 기간 일평균과 평상시 일평균이 각각 10만원 이하일 경우)
		rmap.put("thisList", eventEffectDao.getUpjongAmtChngeGraph(param));         // page2-1. 해당지역의 업종별 경제효과 - 해당지역에서 나타나는 업종이 3개 미만일 경우
		rmap.put("visitrTotal", eventEffectDao.getEventVisitrCnt(param));			// page4. 유입인구 총 수 - 유입인구 총수가 100명 이하일 경우
		
		return rmap;
	}
}
