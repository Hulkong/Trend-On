package com.openmate.onmap.report;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.openmate.onmap.report.service.OnmapReportDao;

@Controller
public class OnmapReportController {

	
	@Resource(name = "onmapReportDao")
	private OnmapReportDao onmapReportDao;
	
	
	//리포트 캐시 조회
	@RequestMapping(value = "/onmap/onmap_report/get_cache.json")
	@ResponseBody
	public Object getReportCache(HttpServletRequest req, HttpServletResponse res ,@RequestParam(value="id") String id){
		Map<String,Object> rtnMap = new HashMap<String,Object>();
		rtnMap.put("result", "ok");
		rtnMap.put("data", onmapReportDao.selectCache(id));
		return rtnMap;
	}
	
	//리포트 캐시 입력
	@RequestMapping(value = "/onmap/onmap_report/put_cache.json" )
	@ResponseBody
	public Object putReportCache(HttpServletRequest req, HttpServletResponse res,@RequestParam(value="json") String json){
		
		Map<String,Object> param = new HashMap<String,Object>();
		param.put("json", json);
		onmapReportDao.insertCache(param);
		int lastId = (Integer) param.get("id");//마지막에 인서트 된ID를 가져온다.
		
		Map<String,Object> rtnMap = new HashMap<String,Object>();
		rtnMap.put("result", "ok");
		rtnMap.put("id",lastId );
		return rtnMap;
	}
}
