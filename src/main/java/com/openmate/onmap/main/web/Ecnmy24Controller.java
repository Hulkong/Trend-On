package com.openmate.onmap.main.web;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.openmate.frmwrk.mapapp.dao.FeatureInfo;
import com.openmate.frmwrk.mapapp.service.MapAppService;
import com.openmate.onmap.common.dao.CommonDao;
import com.openmate.onmap.common.util.MainExcel;
import com.openmate.onmap.main.dao.Ecnmy24Dao;
import com.openmate.onmap.main.service.MainService;

@Controller
public class Ecnmy24Controller {

	@Resource(name = "ecnmy24Dao")
	private Ecnmy24Dao ecnmy24Dao;

	@Resource(name = "commonDao")
	private CommonDao commonDao;
	
	@Resource(name = "mainService")
	private MainService mainService;

	@Resource(name = "onmapSqlSession")
	private SqlSessionFactory sessionFactory ;



	@Resource(name = "mapAppService")
	private MapAppService mapAppService;
	
	
	/**
	 * 경제 24 시간 그래프 top
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = "/onmap/ecnmy_24/timeGraph.json")
	@ResponseBody
	public Object getEcnmy24TimeGraph(HttpServletRequest req, HttpServletResponse res){
		Map<String,Object> param = new HashMap<String,Object>();
		param.put("ctyCd", req.getParameter("ctyCd"));
		param.put("date", req.getParameter("date"));
		param.put("rgnClss", req.getParameter("rgnClss"));
		
		System.out.println("data ::: " + req.getParameter("date"));
		System.out.println("data ::: " + req.getParameter("date"));
		System.out.println("data ::: " + req.getParameter("date"));
		System.out.println("data ::: " + req.getParameter("date"));
		System.out.println("data ::: " + req.getParameter("date"));
		System.out.println("data ::: " + req.getParameter("date"));
		System.out.println("data ::: " + req.getParameter("date"));
		
		Map<String,Object> rmap = new HashMap<String,Object>();
		try{
			
//			Map range = commonDao.getDateRange(param);
//			SimpleDateFormat dt = new SimpleDateFormat("yyyyMMdd"); 
//			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM"); 
//			Date maxDate = dt.parse((String)range.get("max_stdr_date")); 
//			param.put("date", sdf.format(maxDate));
//			rmap.put("date", sdf.format(maxDate));
		
		
			List<Map> timeGraph = ecnmy24Dao.getEcnmy24TimeGraph(param);
			rmap.put("timeGraph", timeGraph);
			
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return rmap;
	}
	
	@RequestMapping(value = "/onmap/ecnmy_24/main_sub.do")
	public String ecnmy_trndPage_sub(HttpServletRequest req, HttpServletResponse res, Map<String,Object> map){
		Map<String,Object> param = new HashMap<String,Object>();
		param.put("ctyCd", "11680");
		param.put("date", "201612");
		param.put("rgnClss", "H4");
//		param.put("ctyCd", req.getParameter("ctyCd"));
//		param.put("date", req.getParameter("date"));
//		param.put("rgnClss", req.getParameter("rgnClss"));
		
		List<Map> timeGraph = ecnmy24Dao.getEcnmy24TimeGraph(param);
		
		ObjectMapper mapper = new ObjectMapper();
		
		try {
			map.put("timeGraph", mapper.writeValueAsString(timeGraph));
		} catch (JsonProcessingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return "onmap/ecnmy_24/main_sub";
	}
	
	/**
	 * 경제 24 지도 (admi)
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = "/onmap/ecnmy_24/ecnmy_24_admi.json")
	public void onmapEcnmy24AdmiMap(HttpServletRequest req, HttpServletResponse res){
		Map<String,String> param = new HashMap<String,String>();
		param.put("ctyCd", req.getParameter("ctyCd"));
		param.put("rgnClss", req.getParameter("rgnClss"));
		FeatureInfo finfo = new FeatureInfo();
		
		finfo.setLayerCrs("KATEC");
		finfo.setLayerName("ecnmy24");
		finfo.setMapperId("com.openmate.onmap.main.dao.Ecnmy24Dao.getAdmi24Map");
		finfo.setTargetCrs("EPSG:4326");
		
		mapAppService.writeFeature(req, res, mapAppService.getFeature(finfo, param, sessionFactory));
		
	}
	
	/**
	 * 경제 24 지도 (block)
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = "/onmap/ecnmy_24/ecnmy_24_block.json")
	public void onmapEcnmy24BlockMap(HttpServletRequest req, HttpServletResponse res){
		Map<String,String> param = new HashMap<String,String>();
		param.put("ctyCd", req.getParameter("ctyCd"));
		param.put("period", req.getParameter("period"));
		param.put("rgnClss", req.getParameter("rgnClss"));
		FeatureInfo finfo = new FeatureInfo();
		
		finfo.setLayerCrs("KATEC");
		finfo.setLayerName("ecnmy24");
		finfo.setMapperId("com.openmate.onmap.main.dao.Ecnmy24Dao.getBlockMap");
		finfo.setTargetCrs("EPSG:4326");
		
		mapAppService.writeFeature(req, res, mapAppService.getFeature(finfo, param, sessionFactory));
		
	}
	
	/**
	 * 경제 24 지도 (주제도)
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = "/onmap/ecnmy_24/ecnmy_24_map.json")
	@ResponseBody
	public Object onmapEcnmy24Map(HttpServletRequest req, HttpServletResponse res){
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("ctyCd", req.getParameter("ctyCd"));
		param.put("date", req.getParameter("date"));
		param.put("period", req.getParameter("period"));
		
		List<Map> list = ecnmy24Dao.getEcnmy24Map(param);
		Map<String,Object> rmap = new HashMap<String,Object>();
		rmap.put("list", list);
		
		return rmap;

	}
	
	/**
	 * 경제 24 지도 범례
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = "/onmap/ecnmy_24/ecnmy_24_map_legend.json")
	@ResponseBody
	public Object getEcnmy24MapLegend(HttpServletRequest req, HttpServletResponse res){
		Map<String,Object> param = new HashMap<String,Object>();
		param.put("ctyCd", req.getParameter("ctyCd"));
		param.put("date", req.getParameter("date"));
		param.put("period", req.getParameter("period"));
		param.put("rgnClss", req.getParameter("rgnClss"));
		param.put("valColumn", req.getParameter("valColumn"));
		
		List<Map> legend = ecnmy24Dao.getEcnmy24MapLegend(param);
		Map<String,Object> rmap = new HashMap<String,Object>();
		rmap.put("legend", legend);
		
		return rmap;
	}
	
	/**
	 * 경제24 : CHART(IN MAP) DATA
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = "/onmap/ecnmy_24/ecnmy_24_map_graph_data.json")
	@ResponseBody
	public Object getEcnmy24MapGraphData(HttpServletRequest req, HttpServletResponse res){
		Map<String,Object> param = new HashMap<String,Object>();
		param.put("ctyCd", req.getParameter("ctyCd"));
		param.put("date", req.getParameter("date"));
		param.put("period", req.getParameter("period"));
		param.put("rgnClss", req.getParameter("rgnClss"));

		List<Map> mapGraph = ecnmy24Dao.getEcnmy24MapGraph(param);				//

		Map<String,Object> rmap = new HashMap<String,Object>();
		rmap.put("mapGraph", mapGraph);
		
		return rmap;
	}
	
	
	private String excelFileName = "지자체 현황";
	
	@Value("${config.excelFile.path}")
	private String excelFilePath ;

	@RequestMapping(value = "/onmap/ecnmy_24/makeExcel.json")
	@ResponseBody
	public Object makeExcel( HttpServletRequest req, HttpServletResponse res
						   , ModelMap model
						   , @RequestParam Map<String, Object> param) throws Exception {

		Map<String, Object> rmap = new HashMap<String, Object>();

		Date d = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss", Locale.KOREA);

		//실제  디렉토리
		String ctyName = (String) param.get("ctyNm");
		String realDir = excelFilePath;
		String oriFileName = ctyName +"_"+ excelFileName+".xlsx";
		String fileName = "tempfile_"+sdf.format(d)+".xlsx";

		try{
		//  - old -
			
//			List<Map<String,Object>> list = ecnmy24Dao.excelData(param);
//			List<Map<String,Object>> tlist = ecnmy24Dao.excelTotalData(param);
//			param.put("dataList", list);
//			param.put("totalList", tlist);
//			MainExcel.makeExcelFile(realDir, fileName, param);	
			
		//  - new -
			List<Map> list = ecnmy24Dao.getAdmiStateList(param);
			if(list.size() > 0) {				
				param.put("dataList", list);
				MainExcel.makeNewExcelFile(realDir, fileName, param);
				
				rmap.put("resultCnt", 1);
			} else {
				rmap.put("resultCnt", 0);				
			}

		}catch(Exception e){
			e.printStackTrace();
			rmap.put("resultCnt", 0);
		}

		rmap.put("fileName", fileName);				// 실제 파일명
		rmap.put("oriFileName", oriFileName);		// 한글 파일명
		rmap.put("realDir", realDir);

		return rmap;
	}
	
}
