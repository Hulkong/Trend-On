package com.openmate.frmwrk.report.common.view;

import java.util.Map;

import org.springframework.web.servlet.view.jasperreports.JasperReportsHtmlView;

public class OpenMateHtmlView extends JasperReportsHtmlView {
	private String voKey;
	
	private String dataKey;
	
	private String reportUrlPath;
	
	private String suffix = ".jrxml";
	
	public OpenMateHtmlView() {
		super();
	}
	
	@Override
	protected net.sf.jasperreports.engine.JasperPrint fillReport(Map<String,Object> model) throws Exception {
		Map<String, Object> vo = (Map<String, Object>) model.get(voKey);
		
		System.out.println("1111111111:test");
		
		System.out.println("map ::::: " + vo.toString());
		
		if(vo != null) {
			String rdKey = (String) vo.get(dataKey);
			if(rdKey != null) {
				setReportDataKey(rdKey);
				String rUrl = reportUrlPath + rdKey + suffix;
				setUrl(rUrl);
			}
			
			initApplicationContext();
		}
		return super.fillReport(model);
	}

	public void setVoKey(String voKey) {
		this.voKey = voKey;
	}


	public void setDataKey(String dataKey) {
		this.dataKey = dataKey;
	}

	public void setReportUrlPath(String reportUrlPath) {
		this.reportUrlPath = reportUrlPath;
	}
}
