package com.openmate.onmap.main.web;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.openmate.frmwrk.mapapp.dao.FeatureInfo;
import com.openmate.frmwrk.mapapp.service.MapAppService;
import com.openmate.onmap.common.dao.CommonDao;
import com.openmate.onmap.common.util.RemoteAddress;
import com.openmate.onmap.common.util.fileUtil;
import com.openmate.onmap.main.dao.MainDao;
import com.openmate.onmap.main.service.MainService;

@Controller
public class MainController {

	@Resource(name = "commonDao")
	private CommonDao commonDao;
	
	@Resource(name = "mainDao")
	private MainDao mainDao;
	
	@Resource(name = "mainService")
	private MainService mainService;

	@Resource(name = "onmapSqlSession")
	private SqlSessionFactory sessionFactory ;

	@Resource(name = "mapAppService")
	private MapAppService mapAppService;
	
	@Autowired
	RemoteAddress remoteAddress;
	
	@Autowired
	fileUtil fileUtil;

	@RequestMapping(value = "/mapapp/get-tbregion.json")
	public void getTbRegion(HttpServletRequest req, HttpServletResponse res){
		FeatureInfo finfo = new FeatureInfo();

		finfo.setLayerCrs("KATEC");
		finfo.setLayerName("TBREGION");
		finfo.setMapperId("com.openmate.onmap.main.service.MainDao.getRegion");
		finfo.setTargetCrs("EPSG:3857");
		mapAppService.writeFeature(req, res, mapAppService.getFeature(finfo,null, sessionFactory));

	}

	/**********************************************
	 *  1. 개요 : 로그인 화면으로 이동
	 *	2. 처리내용 :
	 * 	@Method loginPage
	 *  @param req
	 *  @param res
	 *  @return
	 **********************************************/
	@RequestMapping(value = "/onmap/login/login.do")
	public String loginPage(HttpServletRequest req, HttpServletResponse res) {
		return "onmap/login";
	}


	@Autowired
	org.springframework.security.authentication.encoding.ShaPasswordEncoder passwordEncoder;

	/**
	 * main page 연결
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = "/onmap/main.do")
	public String mainPage(ModelMap model, HttpServletRequest req, HttpServletResponse res)  throws Exception {
//		System.out.println(passwordEncoder.encodePassword("openmate", null));
		return "onmap/main";
	}

	@RequestMapping(value = "/app.m")
	public String mApplyPage(ModelMap model, HttpServletRequest req, HttpServletResponse res)  throws Exception {
		return "mobile/apply";
	}
	
	/**********************************************
	 *  1. 개요 : 로그인 후 메인
	 *	2. 처리내용 :
	 * 	@Method crfcMainPage
	 *  @param model
	 *  @param req
	 *  @param res
	 *  @return
	 **********************************************/
	@RequestMapping(value = "/onmap/crfc_main.do")
	public String crfcMainPage(ModelMap model, HttpServletRequest req, HttpServletResponse res) {

		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("code", "REASON_CD");		
		
		try{
			
			List<Map<String, Object>> codeList = commonDao.getCommonCodeList(param); //서비스 유형 조회
			model.addAttribute("codeList", codeList);
			
			
			
//			Map<String,Object> getDates = mainDao.getDates(param);
			Map<String,Object> getDates = mainService.getDates(param);
			model.addAttribute("thisMonth", Integer.parseInt(getDates.get("this_date").toString()));
			
		}catch(Exception e){
			e.printStackTrace();
		}
		
		
		return "onmap/main/crtfc_main";
	}
	
	/**********************************************
	 *  1. 개요 : 로그인 후 메인 - 통계 데이터 가져오기
	 *	2. 처리내용 :
	 * 	@Method crfcMainData
	 *  @param model
	 *  @param req
	 *  @param res
	 *  @return
	 **********************************************/
	@RequestMapping(value = "/onmap/main/setTotalData.json")
	@ResponseBody
	public Object crfcMainData(@RequestParam Map<String, Object> param) {
		
		return mainService.getCrfMainData(param);
		
	}
	
	/**********************************************
	 *  1. 개요 : 로그인 후 메인 - 통계 데이터 가져오기(유동인구)
	 *	2. 처리내용 :
	 * 	@Method crfcMainFloat
	 *  @param model
	 *  @param req
	 *  @param res
	 *  @return
	 **********************************************/
	@RequestMapping(value = "/onmap/main/setTotalFloat.json")
	@ResponseBody
	public Object crfcMainFloat(@RequestParam Map<String, Object> param) {
		return mainService.getCrfMainFloat(param);
		
	}

	/**********************************************
	 *  1. 개요 : 로그인 전 메인
	 *	2. 처리내용 :
	 * 	@Method publicMainPage
	 *  @param model
	 *  @param param
	 *  @param req
	 *  @param res
	 *  @return
	 **********************************************/
	@RequestMapping(value = "/onmap/public_main.do")
	public String publicMainPage(ModelMap model, @RequestParam Map<String, Object> param, HttpServletRequest req, HttpServletResponse res) {

		param.put("rgnClss", "H1");
		List<Map> dataList = commonDao.getAreaSelectOption(param);//시군구 조회
		model.addAttribute("dataList", dataList);//

		model.addAttribute("param", param);

		return "onmap/main/public_main";

	}

	@RequestMapping(value = "/mapapp/test-json.json")
	@ResponseBody
	public Object testJson(HttpServletRequest req, HttpServletResponse res){
		Map<String,String> rtnData = new HashMap<String,String>();
		return rtnData;
	}


	/**
	 * 지역선택 selectbox의 객체 가져오기
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = "/common/area_select_option.json")
	@ResponseBody
	public Object areaSelectOption(HttpServletRequest req, HttpServletResponse res){
		Map<String,Object> param = new HashMap<String,Object>();
		param.put("rgnClss", req.getParameter("rgnClss"));
		param.put("megaCd", req.getParameter("megaCd"));
		param.put("ctyCd", req.getParameter("ctyCd"));
		param.put("type", req.getParameter("type"));
		param.put("type2", req.getParameter("type2"));

		List<Map> dataList = commonDao.getAreaSelectOption(param);

		return dataList;
	}

	/**
	 * 업종 중분류 선택 selectbox의 객체 가져오기 ( 화면에서 사용 안함 )
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = "/common/upjong2_select_option.json")
	@ResponseBody
	public Object upjong2SelectOption(HttpServletRequest req, HttpServletResponse res){
		List<Map> dataList = commonDao.getUpjong2SelectOption();

		return dataList;
	}

	@RequestMapping("/common/fileDirectDownload.do")
	public void fileDownload(HttpServletRequest req, HttpServletResponse res, @RequestParam Map<String, Object> param){
		try{
			fileUtil.fileDirectDownload(param, req, res);
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	@RequestMapping("/common/setClickMenuLog.json")
	public void setClickMenuLog(HttpServletRequest req, HttpServletResponse res, @RequestParam Map<String, Object> param) {
		
		
		param.put("userIp", remoteAddress.getRemoteAddress(req));     // 사용자 접속 아이피 
		param.put("url", req.getRequestURI());                        // 접속 url 
//		commonDao.setClickMenuLog(param);
	}
}
