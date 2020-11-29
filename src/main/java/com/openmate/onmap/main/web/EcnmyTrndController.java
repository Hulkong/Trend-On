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
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.openmate.frmwrk.mapapp.dao.FeatureInfo;
import com.openmate.frmwrk.mapapp.service.MapAppService;
import com.openmate.frmwrk.report.service.ReportService;
import com.openmate.frmwrk.report.web.ReportParam;
import com.openmate.onmap.common.dao.CommonDao;
import com.openmate.onmap.main.dao.CompareTrendDao;
import com.openmate.onmap.main.dao.EcnmyTrndDao;

@Controller
public class EcnmyTrndController {

	/**
	 * 수정자: 김용현
	 * 수정일: 2018.10.15
	 * 내용: 서비스유형 추가 및 기간 세팅
	 */
	
	@Resource(name = "ecnmyTrndDao")
	private EcnmyTrndDao ecnmyTrndDao;

	@Resource(name = "compareTrendDao")
	private CompareTrendDao compareTrendDao;
	
	@Resource(name = "commonDao")
	private CommonDao commonDao;

	@Resource(name = "onmapSqlSession")
	private SqlSessionFactory sessionFactory;

	@Resource(name = "mapAppService")
	private MapAppService mapAppService;

	
	/**
	 * 경제트렌드 : 지도(행정동 경계)
	 * NewEcnmyTrndController 경제트렌드 : 지도(행정동 경계)
	 * 
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/getTrndMap.json","/onmap/public/ecnmy_trnd/getTrndMap.json"})
	public void onmapEcnmyTrndmap( HttpServletRequest req, HttpServletResponse res
								 , @RequestParam(value="layerName", required=false, defaultValue = "featureLayer") String layerName
								 , @RequestParam Map<String, Object> param) {
		
		FeatureInfo finfo = new FeatureInfo();
		
		finfo.setLayerCrs("KATEC");
		finfo.setLayerName(layerName);
		finfo.setMapperId("com.openmate.onmap.main.dao.EcnmyTrndDao.getTrndMap");
		finfo.setTargetCrs("EPSG:4326");

		mapAppService.writeFeature(req, res, mapAppService.getFeature(finfo, param, sessionFactory));

	}
	
	/**
	 * 경제트렌드 : 지도(시군구 경계)
	 * NewEcnmyTrndController 경제트렌드 : 지도(시군구 경계)
	 * 
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/getTrndCtyMap.json","/onmap/public/ecnmy_trnd/getTrndCtyMap.json"})
	public void onmapEcnmyTrndCtymap( HttpServletRequest req, HttpServletResponse res
									, @RequestParam Map<String, Object> param
									, @RequestParam(value="layerName", required=false, defaultValue = "featureLayer") String layerName) {

		FeatureInfo finfo = new FeatureInfo();
		
		finfo.setLayerCrs("KATEC");
		finfo.setLayerName(req.getParameter("layerName"));
		finfo.setMapperId("com.openmate.onmap.main.dao.EcnmyTrndDao.getTrndCtyMap");
		finfo.setTargetCrs("EPSG:4326");
		
		mapAppService.writeFeature(req, res, mapAppService.getFeature(finfo, param, sessionFactory));
		
	}

	/**
	 * 경제트렌드1-1 : 거래금액(지역별 거래금액 - 주제도)
	 * NewEcnmyTrndController 경제트렌드 : 거래금액(지역별 거래금액 - 주제도)
	 * 
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/salamt.json","/onmap/public/ecnmy_trnd/salamt.json"})
	@ResponseBody
	public Object onmapEcnmyTmdSalamt( HttpServletRequest req, HttpServletResponse res
									 , @RequestParam Map<String, Object> param) {
		
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("list", ecnmyTrndDao.getEcnmyTrndSalamt(param));
		
		return rmap;
	}

	/**
	 * 경제트렌드1-1 : 거래금액(지역별 거래금액 - 지도 범례)  -- 사용안해도 됨
	 * 
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/salamt_legend.json","/onmap/public/ecnmy_trnd/salamt_legend.json"})
	@ResponseBody
	public Object onmapEcnmyTmdSalamtLegend( HttpServletRequest req, HttpServletResponse res
										   , @RequestParam Map<String, Object> param) {

		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("legend", ecnmyTrndDao.getSalamtLegend(param));

		return rmap;
	}
	
	/**
	 * 경제트렌드1-1 : 거래금액(지역별 거래금액 -  TEXT) 
	 * NewEcnmyTrndController 경제트렌드 : 거래금액(지역별 거래금액 -  TEXT) 
	 * 
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/ecnmy_trnd_amt_text.json","/onmap/public/ecnmy_trnd/ecnmy_trnd_amt_text.json"})
	@ResponseBody
	public Object getEcnmyTrndAmtText( HttpServletRequest req, HttpServletResponse res
			 						 , @RequestParam Map<String, Object> param) {
		param.put("limitCnt", 3);
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("amtTotal", ecnmyTrndDao.getEcnmyTrndAmtTotal(param)); 		// page1. 행정동별 거래총액
		rmap.put("amtRankList", ecnmyTrndDao.getEcnmyTrndAmtRank(param)); 		// page1. 행정동별 거래총액 순위리스트
		rmap.put("indutyRankList", ecnmyTrndDao.getEcnmyTrndIndutyRank(param));	// page1. 업종별 거래액 순위리스트
		
		return rmap;
	}
		
	/**
	 * 경제트렌드1-2 : 거래금액(지역별 거래금액  - TREEMAP CHART) 
	 * NewEcnmyTrndController 경제트렌드1-2 : 거래금액(지역별 거래금액  - TREEMAP CHART) 
	 * 
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/ecnmy_trnd_amt_chart.json","/onmap/public/ecnmy_trnd/ecnmy_trnd_amt_chart.json"})
	@ResponseBody
	public Object getEcnmyTrndAmtChart( HttpServletRequest req, HttpServletResponse res
			 						  , @RequestParam Map<String, Object> param) {

		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("indutyList", ecnmyTrndDao.getEcnmyTrndInduty(param)); // page1. 업종에대한 treemap
		
		return rmap;
	}

	/**
	 * 경제트렌드2-1 : 방문객 특성(지역별 방문객 수 - 주제도)
	 * 
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/visitr_co.json","/onmap/public/ecnmy_trnd/visitr_co.json"})
	@ResponseBody
	public Object onmapEcnmyTmdVisitrCo( HttpServletRequest req, HttpServletResponse res
									   , @RequestParam Map<String, Object> param) {
		
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("list", ecnmyTrndDao.getEcnmyTrndVisitrCo(param));
		
		return rmap;

	}

	/**
	 * 경제트렌드2-1 : 방문객 특성 (지역별 방문객 수  - 지도 범례)  -- 사용안해도 됨
	 * 
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/visitr_co_legend.json","/onmap/public/ecnmy_trnd/visitr_co_legend.json"})
	@ResponseBody
	public Object onmapEcnmyTmdVisitrCoLegend( HttpServletRequest req, HttpServletResponse res
			 								 , @RequestParam Map<String, Object> param) {

		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("legend", ecnmyTrndDao.getVisitrCoLegend(param));

		return rmap;
	}
	
	/**
	 * 경제트렌드2-1 : 유입인구 특성 (지역별 유입인구 수 & 성/연령별 대표 유입인구 - TEXT)
	 * 
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/ecnmy_trnd_visitrCo_text.json","/onmap/public/ecnmy_trnd/ecnmy_trnd_visitrCo_text.json"})
	@ResponseBody
	public Object ecnmyTrndVisitrCoText( HttpServletRequest req, HttpServletResponse res
									   , @RequestParam Map<String, Object> param) {

		Map<String, Object> rmap = new HashMap<String, Object>();					
		rmap.put("visitrTotal", ecnmyTrndDao.getEcnmyTrndVisitrTotal(param));		// page2. 행정동별 방문객 총수
		rmap.put("visitrRankList", ecnmyTrndDao.getEcnmyTrndVisitrRank(param));		// page2. 행정동별 방문객수
		rmap.put("visitrChartrList", ecnmyTrndDao.getEcnmyTrndVisitrChartr(param));	// page2. 방문객 성/연령 특성
		rmap.put("ctznChartrList", ecnmyTrndDao.getEcnmyTrndCtznChartr(param));		// page2. 시민 성/연령 특성
		
		return rmap;
	}
	
	/**
	 * 경제트렌드2-2 : 유입인구 특성 (성/연령별 대표 유입인구 - 그래프)
	 * 
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/ecnmy_trnd_visitrCo_chart.json","/onmap/public/ecnmy_trnd/ecnmy_trnd_visitrCo_chart.json"})
	@ResponseBody
	public Object getEcnmyTrndVisitrCoChart( HttpServletRequest req, HttpServletResponse res
										   , @RequestParam Map<String, Object> param) {
		
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("cntList", ecnmyTrndDao.getEcnmyTrndCnt(param));		// page2. 방문객 특성 그래프
		
		return rmap;
	}


	/**
	 * 경제트렌드3-1 : 유입인구 소비 (지역별 유입인구 소비 - 주제도)
	 * NewEcnmyTrndController 경제트렌드3-1 : 유입인구 소비 (지역별 유입인구 소비 - 주제도)
	 * 
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/visitr_expndtr.json","/onmap/public/ecnmy_trnd/visitr_expndtr.json"})
	@ResponseBody
	public Object onmapEcnmyTmdVisitrExpndtr( HttpServletRequest req, HttpServletResponse res
			  								, @RequestParam Map<String, Object> param) {
		
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("list", ecnmyTrndDao.getEcnmyTrndVisitrExpndtr(param));
		
		return rmap;

	}

	/**
	 * 경제트렌드3-1 : 유입인구 소비 (지역별 유입인구 소비 - 지도 범례)  -- 사용안해도 됨
	 * 
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/visitr_expndtr_legend.json","/onmap/public/ecnmy_trnd/visitr_expndtr_legend.json"})
	@ResponseBody
	public Object onmapEcnmyTmdVisitrExpndtrLegend( HttpServletRequest req, HttpServletResponse res
												  , @RequestParam Map<String, Object> param) {

		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("legend", ecnmyTrndDao.getVisitrExpndtrLegend(param));

		return rmap;
	}

	/**
	 * 경제트렌드3-1,3-2 : 유입인구 소비 (지역별 유입인구 소비, 업종별 유입인구 소비특성 - TEXT)
	 * 
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/ecnmy_trnd_expndtr_text.json","/onmap/public/ecnmy_trnd/ecnmy_trnd_expndtr_text.json"})
	@ResponseBody
	public Object getEcnmyTrndExpndtrText( HttpServletRequest req, HttpServletResponse res
										 , @RequestParam Map<String, Object> param) {
		param.put("limitCnt", 3);
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("cnsmpTotal", ecnmyTrndDao.getEcnmyTrndCnsmpTotal(param));				// page3. 방문객 소비 총액
		rmap.put("cnsmpList", ecnmyTrndDao.getEcnmyTrndCnsmp(param));					// page3. 행정동별 소비액 리스트
		//rmap.put("cnsmpIndutycntList", ecnmyTrndDao.getEcnmyTrndCnsmpInduty(param));	// page3. 방문객 소비업종

		return rmap;
	}
	
	/**
	 * 경제트렌드3-2 : 유입인구 소비 (지역별 유입인구 소비 - CHART)
	 * 
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/ecnmy_trnd_expndtr_chart.json","/onmap/public/ecnmy_trnd/ecnmy_trnd_expndtr_chart.json"})
	@ResponseBody
	public Object getEcnmyTrndExpndtrChart( HttpServletRequest req, HttpServletResponse res
										  , @RequestParam Map<String, Object> param) {

		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("mostCommonList", ecnmyTrndDao.getEcnmyTrndMostCommon(param));				// page3. most common(활성 업종)
		rmap.put("mostSpecializedList", ecnmyTrndDao.getEcnmyTrndMostSpecialized(param));	// page3. most specialized(특화업종)
		
		return rmap;
	}
	
	/**
	 * 경제트렌드4-2 : 유입인구 유입지역 (유입인구 유입지역 - 주제도)
	 * 
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/visitr_inflow.json","/onmap/public/ecnmy_trnd/visitr_inflow.json"})
	@ResponseBody
	public Object onmapEcnmyTmdVisitrInflow( HttpServletRequest req, HttpServletResponse res
			 							   , @RequestParam Map<String, Object> param) {
		
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("list", ecnmyTrndDao.getEcnmyTrndVisitrInflow(param));

		return rmap;

	}

	/**
	 * 경제트렌드4-2 : 유입인구 소비 (유입인구 유입지역 - 지도 범례)  -- 사용안해도 됨
	 * 
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/visitr_inflow_legend.json","/onmap/public/ecnmy_trnd/visitr_inflow_legend.json"})
	@ResponseBody
	public Object onmapEcnmyTmdVisitrInflowLegend( HttpServletRequest req, HttpServletResponse res
			  									 , @RequestParam Map<String, Object> param) {

		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("legend", ecnmyTrndDao.getVisitrInflowLegend(param));

		return rmap;
	}
	
	/**
	 * 경제트렌드4-1,4-2 : 유입인구 소비 (유입 소비시간 & 유입인구 유입지역 - TEXT)
	 * 
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/ecnmy_trnd_inflow_text.json","/onmap/public/ecnmy_trnd/ecnmy_trnd_inflow_text.json"})
	@ResponseBody
	public Object getEcnmyTrndCtyInflowText( HttpServletRequest req, HttpServletResponse res
										, @RequestParam Map<String, Object> param) {
		
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("timeCntList", ecnmyTrndDao.getEcnmyTrndTimeCnt(param));	// page4. 주요 소비시간 리스트
		rmap.put("inflowList", ecnmyTrndDao.getEcnmyTrndCtyInflow(param)); 	// page4. 주요 유입지역 리스트

		return rmap;
	}
	
	/**
	 * 경제트렌드4-1 : 유입인구 소비 (유입인구 소비시간 - CHART)
	 * 
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/ecnmy_trnd_inflow_chart.json","/onmap/public/ecnmy_trnd/ecnmy_trnd_inflow_chart.json"})
	@ResponseBody
	public Object getEcnmyTrndCtyInflowChart( HttpServletRequest req, HttpServletResponse res
										 , @RequestParam Map<String, Object> param) {

		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("timeChartList", ecnmyTrndDao.getEcnmyTrndTimeChart(param));	// page4. 시간별 시민vs방문객
		
		return rmap;
	}

	
	
	/*************************************************************
	 * 지역간 비교 (2020.05.22 추가) START
	 *************************************************************/
	
	/**
	 * 지역간비교 : 지역경계(시군구)
	 * 
	 * @param req
	 * @param res
	 * @param param [cty_cd, ]
	 * @return
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/compareRegion.json","/onmap/public/ecnmy_trnd/compareRegion.json"})
	public void getCompareRegion( HttpServletRequest req, HttpServletResponse res
								 , @RequestParam(value="layerName", required=false, defaultValue = "featureLayer") String layerName
								 , @RequestParam Map<String, Object> param) {
		
		FeatureInfo finfo = new FeatureInfo();
		
		finfo.setLayerCrs("KATEC");
		finfo.setLayerName(layerName);
		finfo.setMapperId("com.openmate.onmap.main.dao.CompareTrendDao.getCompareRegion");
		finfo.setTargetCrs("EPSG:4326");

		mapAppService.writeFeature(req, res, mapAppService.getFeature(finfo, param, sessionFactory));

	}
	
	/**
	 * 지역간비교 : 지역경계(시도)
	 * 
	 * @param req
	 * @param res
	 * @param param [cty_cd, ]
	 * @return
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/getCompareMegaShape.json","/onmap/public/ecnmy_trnd/getCompareMegaShape.json"})
	public void getCompareMegaShape( HttpServletRequest req, HttpServletResponse res
									, @RequestParam(value="layerName", required=false, defaultValue = "featureLayer") String layerName
									, @RequestParam Map<String, Object> param) {
		
		FeatureInfo finfo = new FeatureInfo();
		
		finfo.setLayerCrs("KATEC");
		finfo.setLayerName(layerName);
		finfo.setMapperId("com.openmate.onmap.main.dao.CompareTrendDao.getCompareMegaShape");
		finfo.setTargetCrs("EPSG:4326");
		
		mapAppService.writeFeature(req, res, mapAppService.getFeature(finfo, param, sessionFactory));
		
	}
	
	/**
	 * 지역간비교 : 시군구 평균 거래금액 
	 * 
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/getCompareAvgAmt.json","/onmap/public/ecnmy_trnd/getCompareAvgAmt.json"})
	@ResponseBody
	public Object getCompareAvgAmt( HttpServletRequest req, HttpServletResponse res
										 , @RequestParam Map<String, Object> param) {

		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("ctyAvgAmt", compareTrendDao.getCompareAvgAmt(param));	// 시군구 평균 거래금액
		
		return rmap;
	}
	
	/**
	 * 지역간비교 : 시도평균 대비 시군구 평균 거래금액
	 * 
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/getMegaDiff.json","/onmap/public/ecnmy_trnd/getMegaDiff.json"})
	@ResponseBody
	public Object getMegaDiff( HttpServletRequest req, HttpServletResponse res
							 , @RequestParam Map<String, Object> param) {

		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("megaDiff", compareTrendDao.getMegaDiff(param));	// 시도평균 대비 시군구 평균
		
		return rmap;
	}
	
	
	/**
	 * 지역간비교: 시군구평균 매출 vs 선택 시군구 매출 비교 bar chart
	 * 
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/getCompareRegionLv.json","/onmap/public/ecnmy_trnd/getCompareRegionLv.json"})
	@ResponseBody
	public Object getCompareRegionLv( HttpServletRequest req, HttpServletResponse res
										 , @RequestParam Map<String, Object> param) {

		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("avgAmtList", compareTrendDao.getCompareRegionLv(param));	// 시군구 평균 거래금액
		
		return rmap;
	}

	/**
	 * 지역간비교: 업종별 거래금액 최대 매출 업종리스트 (3)
	 * 
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/getCompareBestUpjong.json","/onmap/public/ecnmy_trnd/getCompareBestUpjong.json"})
	@ResponseBody
	public Object getCompareBestUpjong( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String, Object> param) {
		
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("upjongList", compareTrendDao.getCompareBestUpjong(param));	// 최대매출업종리스트
		
		return rmap;
	}

	/**
	 * 지역간비교: 업종별 거래금액 treemap  그래프
	 * 
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/getCompareInduty.json","/onmap/public/ecnmy_trnd/getCompareInduty.json"})
	@ResponseBody
	public Object getCompareInduty( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String, Object> param) {
		
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("list", compareTrendDao.getCompareInduty(param));	// 업종별 거래금액 treemap  그래프
		
		return rmap;
	}
	
	/**
	 * 지역간비교: 시군구 평균 유입인구 수
	 * 
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/getCompareAvgCnt.json","/onmap/public/ecnmy_trnd/getCompareAvgCnt.json"})
	@ResponseBody
	public Object getCompareAvgCnt( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String, Object> param) {
		
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("avgCnt", compareTrendDao.getCompareAvgCnt(param));	// 시군구 평균 유입인구 수
		
		return rmap;
	}
	
	/**
	 * 지역간비교:  시군구평균 유입인구 수 vs 선택 시군구 유입인구 수 비교 bar chart
	 * 
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/getCompareCntRegionLv.json","/onmap/public/ecnmy_trnd/getCompareCntRegionLv.json"})
	@ResponseBody
	public Object getCompareCntRegionLv( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String, Object> param) {
		
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("list", compareTrendDao.getCompareCntRegionLv(param));	// 시군구 평균 유입인구 수
		
		return rmap;
	}
	
	/**
	 * 지역간비교:  시도 대비 평균 유입인구 수
	 * 
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/getMegaDiffCnt.json","/onmap/public/ecnmy_trnd/getMegaDiffCnt.json"})
	@ResponseBody
	public Object getMegaDiffCnt( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String, Object> param) {
		
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("rate", compareTrendDao.getMegaDiffCnt(param));	// 시도 대비 평균 유입인구 수
		
		return rmap;
	}
	
	/**
	 * 지역간비교:  시군구 성/연령별 대표 유입, 상주인구 유형 
	 * 
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/getCompareAgeGender.json","/onmap/public/ecnmy_trnd/getCompareAgeGender.json"})
	@ResponseBody
	public Object getCompareAgeGender( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String, Object> param) {
		
		Map<String, Object> rmap = new HashMap<String, Object>();
		
		param.put("locCd", "R");
		rmap.put("resident", compareTrendDao.getCompareAgeGender(param));	// 시군구 성/연령 대표 상주인구 유형
		
		param.put("locCd", "E");
		rmap.put("visitor", compareTrendDao.getCompareAgeGender(param));		// 시군구 성/연령 대표 유입인구 유형
		
		return rmap;
	}
	
	/**
	 * 지역간비교:  시군구 성/연령별 대표 유입, 상주인구 bar 그래프
	 * 
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/getCompareManType.json","/onmap/public/ecnmy_trnd/getCompareManType.json"})
	@ResponseBody
	public Object getCompareManType( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String, Object> param) {
		
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("data", compareTrendDao.getCompareManType(param));	// 시군구 성/연령 대표 상주인구 유형
		
		return rmap;
	}

	/**
	 * 지역간비교:  시군구 평균 유입인구 소비 총액
	 * 
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/getCompareVisitAmt.json","/onmap/public/ecnmy_trnd/getCompareVisitAmt.json"})
	@ResponseBody
	public Object getCompareVisitAmt( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String, Object> param) {
		
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("saleAmt", compareTrendDao.getCompareVisitAmt(param));	// 시군구 평균 유입인구 소비 총액
		
		return rmap;
	}
	
	/**
	 * 지역간비교:  시군구 평균 유입인구 소비금액 vs 선택 시군구 유입인구 소비금액 비교 bar chart
	 * 
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/getCompareAmtRegionLv.json","/onmap/public/ecnmy_trnd/getCompareAmtRegionLv.json"})
	@ResponseBody
	public Object getCompareAmtRegionLv( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String, Object> param) {
		
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("saleAmt", compareTrendDao.getCompareAmtRegionLv(param));	// 시군구 평균 유입인구 소비금액 vs 선택 시군구 유입인구 소비금액
		
		return rmap;
	}
	
	/**
	 * 지역간비교:  시도 대비 평균 유입인구 소비금액
	 * 
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/getMegaDiffAmt.json","/onmap/public/ecnmy_trnd/getMegaDiffAmt.json"})
	@ResponseBody
	public Object getMegaDiffAmt( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String, Object> param) {
		
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("rate", compareTrendDao.getMegaDiffAmt(param));	// 시도 대비 평균 유입인구 소비금액
		
		return rmap;
	}
	
	/**
	 * 지역간비교:  업종별 유입인구 소비특성(활성업종 리스트)
	 * 
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/getCompareActUpjong3.json","/onmap/public/ecnmy_trnd/getCompareActUpjong3.json"})
	@ResponseBody
	public Object getCompareActUpjong3( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String, Object> param) {
		
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("list", compareTrendDao.getCompareActUpjong3(param));	// 업종별 유입인구 소비특성(활성업종 리스트 )
		
		return rmap;
	}
	
	/**
	 * 지역간비교:  업종별 유입인구 소비특성( 활성업종 막대그래프)
	 * 
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/getCompareActUpjong10.json","/onmap/public/ecnmy_trnd/getCompareActUpjong10.json"})
	@ResponseBody
	public Object getCompareActUpjong10( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String, Object> param) {
		
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("list", compareTrendDao.getCompareActUpjong10(param));	// 업종별 유입인구 소비특성(활성업종 막대그래프)
		
		return rmap;
	}	
	
	/**
	 * 지역간비교:  유입인구 주요 소비시간
	 * 
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/getCompareBestTime.json","/onmap/public/ecnmy_trnd/getCompareBestTime.json"})
	@ResponseBody
	public Object getCompareBestTime( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String, Object> param) {
		
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("time_nm", compareTrendDao.getCompareBestTime(param));	// 유입인구 주요 소비시간
		
		return rmap;
	}
	
	/**
	 * 지역간비교:  유입인구 주요 소비시간 리스트
	 * 
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/getCompareBestTimeList.json","/onmap/public/ecnmy_trnd/getCompareBestTimeList.json"})
	@ResponseBody
	public Object getCompareBestTimeList( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String, Object> param) {
		
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("list", compareTrendDao.getCompareBestTimeList(param));	// 유입인구 주요 소비시간 리스트
		
		return rmap;
	}
	
	
	/**
	 * 지역간비교:  유입인구 주요 소비시간 막대그래프
	 * 
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/getCompareBestTimeListAll.json","/onmap/public/ecnmy_trnd/getCompareBestTimeListAll.json"})
	@ResponseBody
	public Object getCompareBestTimeListAll( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String, Object> param) {
		
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("list", compareTrendDao.getCompareBestTimeListAll(param));	// 유입인구 주요 소비시간 막대그래프
		
		return rmap;
	}
	
	
	/**
	 * 지역간비교:  유입인구 주요 유입지역
	 * 
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/getCompareBestInflow.json","/onmap/public/ecnmy_trnd/getCompareBestInflow.json"})
	@ResponseBody
	public Object getCompareBestInflow( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String, Object> param) {
		
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("flow_nm", compareTrendDao.getCompareBestInflow(param));	// 유입인구 주요 유입지역
		
		return rmap;
	}
	
	/**
	 * 지역간비교:  유입인구 주요 유입지역 리스트(3)
	 * 
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/getCompareBestInflowList.json","/onmap/public/ecnmy_trnd/getCompareBestInflowList.json"})
	@ResponseBody
	public Object getCompareBestInflowList( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String, Object> param) {
		
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("list", compareTrendDao.getCompareBestInflowList(param));	// 유입인구 주요 유입지역
		
		return rmap;
	}
	
	/**
	 * 지역간비교:  유입인구 주요 유입지역 지도
	 * 
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/getCompareBestInflowMap.json","/onmap/public/ecnmy_trnd/getCompareBestInflowMap.json"})
	@ResponseBody
	public Object getCompareBestInflowMap( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String, Object> param) {
		
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("list", compareTrendDao.getCompareBestInflowMap(param));	// 유입인구 주요 유입지역
		
		return rmap;
	}
	
	/*************************************************************
	 *****************  지역간 비교 (2020.05.22 추가) END
	 *************************************************************/
	
	
    @Resource(name = "reportService")
    private ReportService svc;
    
    private ObjectMapper mapper = new ObjectMapper();
    
    
	/**
	 * PDF 보고서 내 데이터 출력 및 보고서 생성
	 * @param req
	 * @param res
	 * @param p
	 * @return
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/pdf/data_root.json","/onmap/public/ecnmy_trnd/pdf/data_root.json"})
	@ResponseBody
	public Object onmapEcnmyTmdReportData( HttpServletRequest req, HttpServletResponse res
										 , @RequestParam HashMap<String,Object> p) {

		Map<String, Object> hashmap = new HashMap<String, Object>();
		String dataId = (String) p.get("dataId");
		String jsonString = "error";
		
		jsonString = "error";
		
		ReportParam rParam= new ReportParam();
		rParam.setRptId(dataId);
		rParam.setParam(p);
		
		try {
			hashmap = svc.getJsonByDataId(rParam); // 리포터 생성할때, 리포터의 그래프를 그릴때마다 사용되는 데이터 (map)
												   // ReportController에서 str형태의 데이로 사용. (리포터내의 text 혹은 표 데이터)
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return hashmap;
	}
	
	
	/**
	 *  pdf 보고서 내 데이터 출력 테스트
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/pdf/chart1.json","/onmap/ecnmy_trnd/graph_111dat111a.json"})
	@ResponseBody
	public Object onmapEcnmyTmdGraphDa111ta(HttpServletRequest req, HttpServletResponse res) {
		
		Map<String,Object> rtnMap = new HashMap<String, Object>();
		return rtnMap;
	}

	
}