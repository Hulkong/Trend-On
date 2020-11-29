package com.openmate.frmwrk.report.common.view;

import java.util.Map;

import org.springframework.web.servlet.view.jasperreports.JasperReportsCsvView;

public class OpenMateCsvView extends JasperReportsCsvView {
	private String voKey;
	
	private String dataKey;
	
	private String reportUrlPath;
	
	private String suffix = ".jrxml";
	
	public OpenMateCsvView() {
		super();
	}
	
	@Override
	protected net.sf.jasperreports.engine.JasperPrint fillReport(Map<String,Object> model) throws Exception {
		Map<String, Object> vo = (Map<String, Object>) model.get(voKey);
		
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
}
