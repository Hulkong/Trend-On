package com.openmate.frmwrk.mapapp.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.openmate.frmwrk.mapapp.dao.FeatureInfo;
import com.openmate.frmwrk.mapapp.dao.MapAppDao;
import com.openmate.frmwrk.mapapp.service.MapAppService;



@Controller
public class MapAppController {
	
	
	
	@Resource(name = "mapAppService")
	private MapAppService mapAppService;
	
	
	@Resource(name = "mapAppDao")
	private MapAppDao mapAppDao;
	
	
	@Resource(name = "frmwrkSqlSession")
	private SqlSessionFactory sessionFactory ;
	
	
	@RequestMapping(value = "/mapapp/get-q1.json")
	@ResponseBody 
	public Object getQ1(HttpServletRequest req, HttpServletResponse res ) throws Exception {
		
		return mapAppDao.getQ002();
	}
	
	
	@RequestMapping(value = "/mapapp/get-region.json")
	@ResponseBody 
	public void getRegionFeature(HttpServletRequest req, HttpServletResponse res ) throws Exception {
		
		FeatureInfo finfo = new FeatureInfo();
		
		
		final String targetCrs = "EPSG:3857";
	    final String layercrs = "KATEC";
	    String mapperId = "com.openmate.frmwrk.mapapp.dao.MapAppDao.getRegion";
	    String layerName = "tbregion";
	    
	    finfo.setTargetCrs(targetCrs);
	    finfo.setLayerCrs(layercrs);
	    finfo.setMapperId(mapperId);
	    finfo.setLayerName(layerName);
	    
	    
	    mapAppService.writeFeature(req , res ,mapAppService.getFeature(finfo,null, this.sessionFactory));
	}
	
	

}
