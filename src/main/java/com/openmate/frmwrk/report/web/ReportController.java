package com.openmate.frmwrk.report.web;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.openmate.frmwrk.report.service.ReportService;

@Controller
public class ReportController {
    @Resource(name = "reportService")
    private ReportService svc;
    
//	@Autowired
//	private Properties globalConfig;
	
	
	@Value("${config.report.path}")
	private String reportPath ;// globalConfig.getProperty("config.report.path");
	
	
	@Value("${config.phantomjs.host}")
	private String phantomJsHost ;
	
	private ObjectMapper mapper = new ObjectMapper();
	@RequestMapping(value = "/report/index")
	public String index(HttpServletRequest request, ModelMap model) {


		ClassLoader classLoader = getClass().getClassLoader();
		File folder = new File(classLoader.getResource(reportPath).getFile());

		// File folder = new File( reportPath );

		File[] listFiles = folder.listFiles();

		List<String> fileList = new ArrayList<String>();

		for (File file : listFiles) {
			fileList.add(file.getName().replace(".jasper", ""));
		}

		model.addAttribute("fileList", fileList);

		model.addAttribute("test", "test");

		return "report/index";
	}
    
	
    @RequestMapping(value="report")
    public Map<String, Object> report(HttpServletRequest req, HttpServletResponse res, @RequestParam HashMap<String,Object> p) {
    	
    	String dataId = (String) p.get("dataId");
    	String fileNm = (String) p.get("fileNm");
    	
    	Map<String, Object> m = new HashMap<String, Object>();
    	try {
    			ReportParam rParam= new ReportParam();
    			rParam.setRptId(dataId);
    			rParam.setParam(p);
        	m.put("dataId", fileNm);
       		m.put("jsonStr", svc.getJsonStrByDataId(rParam));	// EcnmyTrndController에서 한번 생성해놓은 데이터를 가져와서 사용
        	m.put("vo", m);
		} catch (Exception e) {
			e.getStackTrace();
		}
    	return m;
    }
    
    @RequestMapping(value="/report/viewer")
    public String reportViewer() {
    	return "report/viewer";
    }
    

}

