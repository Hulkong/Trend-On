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

import com.openmate.frmwrk.mapapp.dao.FeatureInfo;
import com.openmate.frmwrk.mapapp.service.MapAppService;
import com.openmate.onmap.common.dao.CommonDao;
import com.openmate.onmap.main.dao.CompareTrendDao;
import com.openmate.onmap.main.dao.EcnmyTrndDao;

@Controller
public class NewEcnmyTrndController {
	
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
	 * 경제 트렌드 page 연결
	 * 
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = "/onmap/ecnmy_trnd/main.do")
	public String ecnmy_trndPage( HttpServletRequest req, HttpServletResponse res
//								, Map<String, Object> map
								, @RequestParam Map<String, Object> param
								, ModelMap model) {
		
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		Object obj = auth.getPrincipal();
		int serviceClss = 0;   // 서비스유형코드
		
		if (obj != null && obj instanceof com.openmate.frmwrk.user.User) {
			com.openmate.frmwrk.user.User usr = (com.openmate.frmwrk.user.User) obj;
//			serviceClss = usr.getServiceClss();
			model.addAttribute("userId", usr.getUsername());
			Map xInfo = (Map) usr.getExtInfo();
			serviceClss = Integer.valueOf( xInfo.get("service_clss").toString() );
			model.addAttribute("serviceClss", serviceClss);
			param.put("ctyCd" , xInfo.get("cty_cd"));
		}
		
		try{
			Map range = commonDao.getDateRange(param); // top 그래프의 전체 범위 가져오기
			
			SimpleDateFormat dt = new SimpleDateFormat("yyyyMMdd"); 
			Date maxDate = dt.parse((String)range.get("max_stdr_date")); 
			Calendar cal= Calendar.getInstance();
			cal.setTime(maxDate);
			cal.add(cal.MONTH, - 10);
			cal.add(cal.DATE, +12);
			
			model.addAttribute("endDate", dt.format(cal.getTime()));	// top 그래프의 초기 선택 종료일
			
			// 테스트일 때 3개월 기간 지정, 그 외는 6개월
			if(serviceClss == 3) {
				cal.setTime(dt.parse("20180802"));
				model.addAttribute("endDate", "20180802");	// top 그래프의 초기 선택 종료일
				model.addAttribute("maxPeriod", "3");	// top 그래프의 초기 선택 종료일
				model.addAttribute("minPeriod", "2");	// top 그래프의 초기 선택 종료일
				cal.add(cal.MONTH, - 3); 
				
				// 전체 시계열 그래프의 기준 시작일/ 종료일
				model.addAttribute("min_stdr_date", "20180101");
				model.addAttribute("max_stdr_date", "20181231");
			} else {
				model.addAttribute("maxPeriod", "12");	// top 그래프의 초기 선택 종료일
				model.addAttribute("minPeriod", "2");	// top 그래프의 초기 선택 종료일
				cal.add(cal.MONTH, - 6);
				
				// 전체 시계열 그래프의 기준 시작일/ 종료일
				model.addAttribute("min_stdr_date", range.get("min_stdr_date"));
				model.addAttribute("max_stdr_date", range.get("max_stdr_date"));
			}
			
			cal.add(cal.DATE, cal.getActualMaximum(cal.DAY_OF_MONTH)-13);			
			model.addAttribute("startDate", dt.format(cal.getTime()));	// top 그래프의 초기 선택 시작일  
		
			
			
			param.put("rgnClss", "H1");
			List<Map> regionMegaList = commonDao.getAreaSelectOption(param); 			
			model.addAttribute("regionMegaList", regionMegaList);	// 지역  mega selectbox option 가져오기
			
			param.put("rgnClss", "H3");
			String megaCd = "11";
			if(regionMegaList.size() > 0){
				megaCd = (String) regionMegaList.get(0).get("id");
			}
			param.put("megaCd", megaCd);
			
			model.addAttribute("regionCtyList", commonDao.getAreaSelectOption(param));	// 지역 selectbox option 가져오기
			
		}catch(Exception e){
			e.printStackTrace();
		}
		
		
		return "onmap/ecnmy_trnd/main";
	}
	
	/**
	 * 지역간 비교 page가져오기
	 * @param req
	 * @param res
	 * @param regionCd
	 * @param nm
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/onmap/ecnmy_trnd/{regionCd}/compare.do")
	public String ecnmyTrndComparePage(HttpServletRequest req, HttpServletResponse res
									  ,@PathVariable String regionCd
									  ,@RequestParam(value="nm") String nm
									  ,ModelMap model) {
		
		model.addAttribute("regionCd", regionCd);
		model.addAttribute("regionNm", nm);
		
		return "onmap/ecnmy_trnd/comparePopup";
	}

	
	/**
	 * 경제트렌드 : 지도(행정동 경계) -line 60
	 * 
	 * @param req
	 * @param res
	 */

	
	/**
	 * 경제트렌드 : 지도(시군구 경계) -line 83
	 * 
	 * @param req
	 * @param res
	 */

	

	
	/***
	 * 시계열 그래프( page 상단 range bar )
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = "/onmap/ecnmy_trnd/graph_data.json")
	@ResponseBody
	public Object onmapEcnmyTmdGraphData( HttpServletRequest req
										, HttpServletResponse res
										, @RequestParam Map<String, Object> param) {
		
		Map<String,Object> rtnMap = new HashMap<String, Object>();

		try{
//			if(param.get("serviceClss") != null && param.get("serviceClss").equals("3")){
////				rtnMap.put("min_stdr_date", param.get("min_date"));
////				rtnMap.put("max_stdr_date", param.get("max_date"));
//				rtnMap.put("min_stdr_date", "20180101");
//				rtnMap.put("max_stdr_date", "20181231");
//			}else{
//				Map range = commonDao.getDateRange(param);
//				rtnMap.put("max_stdr_date", range.get("max_stdr_date"));
//				rtnMap.put("min_stdr_date", range.get("min_stdr_date"));
//				
//				if(param.get("periodMon") != null && !param.get("periodMon").equals("")){
//					int periodMon = Integer.parseInt((String)param.get("periodMon"));
//					SimpleDateFormat dt = new SimpleDateFormat("yyyyMMdd"); 
//					Date maxDate = dt.parse((String)range.get("max_stdr_date")); 
//					Calendar cal= Calendar.getInstance();
//					cal.setTime(maxDate);
//					cal.add(cal.MONTH, - periodMon);
//					cal.add(cal.DATE, 1);
//					rtnMap.put("min_stdr_date", dt.format(cal.getTime()));
//				}
//			}
			
			rtnMap.put("data", ecnmyTrndDao.getEcnmyTrndGraphData(param));
			rtnMap.put("data2", ecnmyTrndDao.getEcnmyTrndGraphData02(param));
			
		}catch(Exception e){
			e.printStackTrace();
		}
		return rtnMap;
	}
	
	
	/**
	 * 경제트렌드[page01 - 카드사] : 거래금액(지역별 거래금액 - 주제도) -line 106
	 * 
	 * @param req
	 * @param res
	 */

	
	/**
	 * 경제트렌드[page01 - 카드사] : 거래금액(지역별 거래금액 -  TEXT) - line 141
	 * 
	 * @param req
	 * @param res
	 * @return
	 */
	

	/**
	 * 경제트렌드[page01 - 통신사] : 지역별 유동인구 수(지역별 유동인구 수 - 주제도)
	 * 
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/float_cnt_map.json","/onmap/public/ecnmy_trnd/float_cnt_map.json"})
	@ResponseBody
	public Object getEcnmyTrndFloatCntMap( HttpServletRequest req, HttpServletResponse res
									 , @RequestParam Map<String, Object> param) {
		
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("list", ecnmyTrndDao.getEcnmyTrndFloat(param));
		
		return rmap;
	}
	
	/**
	 * 경제트렌드[page01 - 통신사] : 지역별 유동인구 수 (지역별 유동인구 수  -  TEXT) 
	 * 
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/ecnmy_trnd_float_txt.json","/onmap/public/ecnmy_trnd/ecnmy_trnd_float_txt.json"})
	@ResponseBody
	public Object getEcnmyTrndfloatText( HttpServletRequest req, HttpServletResponse res
			 						 , @RequestParam Map<String, Object> param) {
		param.put("limitCnt", 3);
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("total", ecnmyTrndDao.getEcnmyTrndFloatTotal(param)); 		// page1. 해당지역의 유동인구 총 수
		rmap.put("rankList", ecnmyTrndDao.getEcnmyTrndFloatRank(param)); 		// page1. 지역별 유동인구수 순위 리스트
		
		return rmap;
	}
	
	
	/**
	 * 경제트렌드[page02 - 통신사, 카드사] : 유동인구 & 소비인구 특성 (성/연령별 대표인구 - text)
	 * 
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/all_gender_age.json","/onmap/public/ecnmy_trnd/all_gender_age.json"})
	@ResponseBody
	public Object getEcnmyTrndGenderAgeTxt( HttpServletRequest req, HttpServletResponse res
									 , @RequestParam Map<String, Object> param) {
		
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("amtTxt", ecnmyTrndDao.getAllAmtChartr(param));
		rmap.put("floatTxt", ecnmyTrndDao.getAllFloatChartr(param));
		
		return rmap;
	}
	
	/**
	 * 경제트렌드[page02 - 카드사] : 소비인구 특성 (성/연령별 대표인구 - 그래프)
	 * 
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/all_sale_list.json","/onmap/public/ecnmy_trnd/all_sale_list.json"})
	@ResponseBody
	public Object getEcnmyTrndAllSaleList( HttpServletRequest req, HttpServletResponse res
									 , @RequestParam Map<String, Object> param) {
		
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("lsit", ecnmyTrndDao.getEcnmyTrndAllSaleList(param));
		
		return rmap;
	}
	
	
	/**
	 * 경제트렌드[page02 - 통신사] : 유동인구 특성 (성/연령별 대표인구 - 그래프)
	 * 
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/all_float_list.json","/onmap/public/ecnmy_trnd/all_float_list.json"})
	@ResponseBody
	public Object getEcnmyTrndAllFloatList( HttpServletRequest req, HttpServletResponse res
									 , @RequestParam Map<String, Object> param) {
		
		Map<String, Object> rmap =  new HashMap<String, Object>();
		rmap.put("list",ecnmyTrndDao.getEcnmyTrndAllFloatList(param));
		
		return rmap;
	}
	
	
	/**
	 * 경제트렌드[page02 - 카드사] : 업종별 거래금액 (업종순위 리스트 - text)
	 * 
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/upjong_amt_list.json","/onmap/public/ecnmy_trnd/upjong_amt_list.json"})
	@ResponseBody
	public Object getEcnmyTrndUpjongAmtList( HttpServletRequest req, HttpServletResponse res
									 , @RequestParam Map<String, Object> param) {
		
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("list", ecnmyTrndDao.getEcnmyTrndIndutyRank(param));
		
		return rmap;
	}

	/**
	 * 경제트렌드[page02 - 카드사] : 업종별 거래금액 (트리맵 -chart) - line 162
	 * 
	 * @param req
	 * @param res
	 */

	
	/**
	 * 경제트렌드[page03 - 카드사] : 유입 소비인구 거래금액(유입소비인구 총거래금액 & 지역별 거래금액 리스트 - text)
	 * 
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/inflow_amt_txt.json","/onmap/public/ecnmy_trnd/inflow_amt_txt.json"})
	@ResponseBody
	public Object getEcnmyTrndInflowAmtTxt( HttpServletRequest req, HttpServletResponse res
									 , @RequestParam Map<String, Object> param) {
		
		param.put("limitCnt", 3);
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("amtTxt", ecnmyTrndDao.getEcnmyTrndCnsmpTotal(param));
		rmap.put("list", ecnmyTrndDao.getEcnmyTrndCnsmp(param));
		
		return rmap;
	}
	
	
	/**
	 * 경제트렌드[page03 - 카드사] : 유입 소비인구 거래금액 (지역별 유입 소비인구 - 주제도) - line 256
	 * 
	 * @param req
	 * @param res
	 */
	
	
	
	/**
	 * 경제트렌드[page03 - 통신사] : 유입 유동인구 수(유입 유동인구 총수 & 지역별 유입 유동인구 리스트 - text)
	 * 
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/inflow_float_txt.json","/onmap/public/ecnmy_trnd/inflow_float_txt.json"})
	@ResponseBody
	public Object getEcnmyTrndInflowFloatTxt( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String, Object> param) {
		
		param.put("limitCnt", 3);
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("fltTxt", ecnmyTrndDao.getFlowFloatTxt(param));
		rmap.put("list", ecnmyTrndDao.getFlowFloatList(param));
		
		return rmap;
	}
	
	/**
	 * 경제트렌드[page03 - 통신사] : 유입 유동인구 수(지역별 유입 유동인구 리스트 - 주제도)
	 * 
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/inflow_float_map.json","/onmap/public/ecnmy_trnd/inflow_float_map.json"})
	@ResponseBody
	public Object getEcnmyTrndInflowFloatMap( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String, Object> param) {
		
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("list", ecnmyTrndDao.getFlowFloatMap(param));
		
		return rmap;
	}
	
	
	/**
	 * 경제트렌드[page04 - 카드사] : 유입인구 특성 (성/연령별 유입 소비인구 - 그래프)
	 * 
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/inflow_sale_list.json","/onmap/public/ecnmy_trnd/inflow_sale_list.json"})
	@ResponseBody
	public Object getEcnmyTrndInflowSaleList( HttpServletRequest req, HttpServletResponse res
									 , @RequestParam Map<String, Object> param) {
		
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("list", ecnmyTrndDao.getEcnmyTrndInflowSaleList(param));
		
		return rmap;
	}
	
	
	/**
	 * 경제트렌드[page04 - 통신사] : 유입인구 특성 (성/연령별 유입 유동인구 - 그래프)
	 * 
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/inflow_float_list.json","/onmap/public/ecnmy_trnd/inflow_float_list.json"})
	@ResponseBody
	public Object getEcnmyTrndInflowFloatList( HttpServletRequest req, HttpServletResponse res
									 , @RequestParam Map<String, Object> param) {
		
		Map<String, Object> rmap =  new HashMap<String, Object>();
		rmap.put("list", ecnmyTrndDao.getEcnmyTrndInflowFloatList(param));
		
		return rmap;
	}
	
	
	/**
	 * 경제트렌드[page04 - 통신사] : 유동인구 & 소비인구 특성 (성/연령별 유입인구 - text)
	 * 
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/inflow_gender_age.json","/onmap/public/ecnmy_trnd/inflow_gender_age.json"})
	@ResponseBody
	public Object getEcnmyTrndInflowGenderAge( HttpServletRequest req, HttpServletResponse res
									 , @RequestParam Map<String, Object> param) {
		
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("amtTxt", ecnmyTrndDao.getInflowAmtChartr(param));
		rmap.put("floatTxt", ecnmyTrndDao.getInflowFloatChartr(param));
		
		return rmap;
	}
	
	/**
	 * 경제트렌드[page04 - 카드사] :  유입인구 소비 (지역별 유입인구 소비특성 - CHART) -- line 311
	 * 
	 * @param req
	 * @param res
	 */
	
	
	/**
	 * 경제트렌드[page05 - 통신사, 카드사] : 유입인구 시간대 특성 (주요 방문시간, 주요 소비시간 - text)
	 * 
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/inflow_float_time.json","/onmap/public/ecnmy_trnd/inflow_float_time.json"})
	@ResponseBody
	public Object getEcnmyTrndInflowFloatTime( HttpServletRequest req, HttpServletResponse res
									 , @RequestParam Map<String, Object> param) {
		
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("floatTxt", ecnmyTrndDao.getInflowFloatTimeChartr(param));	// 주요 방문시간
		rmap.put("amtTxt", ecnmyTrndDao.getInflowAmtTimeChartr(param));	// 주요 소비시간
		
		return rmap;
	}
	
	/**
	 * 경제트렌드[page05 - 통신사, 카드사] : 유입인구 시간대 특성 (주요 방문시간, 주요 소비시간 - chart)
	 * 
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/inflow_time_chart.json","/onmap/public/ecnmy_trnd/inflow_time_chart.json"})
	@ResponseBody
	public Object getEcnmyTrndInflowTimeChart( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String, Object> param) {
		
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("list", ecnmyTrndDao.getEcnmyTrndInflowTimeChart(param));	// 주요 유입 방문 & 유입 소비 시간
		
		return rmap;
	}

	/**
	 * 경제트렌드[page05 - 통신사] : 유입 유동인구 유입지역 (주요 유입지역 text)
	 * 
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/inflow_depart_txt.json","/onmap/public/ecnmy_trnd/inflow_depart_txt.json"})
	@ResponseBody
	public Object getEcnmyTrndInflowDepartTxt( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String, Object> param) {
		
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("inflowTxt", ecnmyTrndDao.getCtyInflowChartr(param));	// 주요 유입지역 top1
		rmap.put("list", ecnmyTrndDao.getCtyInflowList(param));	// 주요 유입지역 top3 list
		
		return rmap;
	}

	/**
	 * 경제트렌드[page05 - 통신사] : 유입 유동인구 유입지역 (주요 유입지역 - 주제도)
	 * 
	 * @param req
	 * @param res
	 */
	@RequestMapping(value = {"/onmap/ecnmy_trnd/inflow_depart_map.json","/onmap/public/ecnmy_trnd/inflow_depart_map.json"})
	@ResponseBody
	public Object getEcnmyTrndInflowDepartMap( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String, Object> param) {
		
		Map<String, Object> rmap = new HashMap<String, Object>();
		rmap.put("list", ecnmyTrndDao.getCtyInflowMap(param));	// 주요 유입지역 주제도
		
		return rmap;
	}

}
