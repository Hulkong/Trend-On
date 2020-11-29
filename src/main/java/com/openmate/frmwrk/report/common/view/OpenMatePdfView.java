package com.openmate.frmwrk.report.common.view;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.util.Map;

import net.sf.jasperreports.engine.JasperFillManager;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.servlet.view.jasperreports.JasperReportsPdfView;

public class OpenMatePdfView extends JasperReportsPdfView {
	private String voKey;
	
	private String dataKey;
	
	private String reportKey; 
	
	@Value("${config.report.path}")
	private String reportUrlPath;
	
	private String suffix = ".jasper";
//	private String suffix = ".jrxml";
	
	private int order = Integer.MIN_VALUE;
	
	public OpenMatePdfView() {
		super();
	}
	
	@Override
	protected net.sf.jasperreports.engine.JasperPrint fillReport(Map<String,Object> model) throws Exception {
		Map<String, Object> vo = (Map<String, Object>) model.get(voKey);
		String json = "";
		
		
		if(vo != null && model.get("jsonStr") != null ) {
			String rdKey = (String) vo.get(dataKey);
			
			System.out.println(rdKey);
			if(rdKey != null) {
				setReportDataKey(rdKey);
				String rUrl = "classpath:"+reportUrlPath + rdKey + suffix;
				setUrl(rUrl);
				json = model.get("jsonStr").toString();
			}
			
			
			initApplicationContext();
		}
		InputStream is = new ByteArrayInputStream(json.getBytes("UTF-8"));
		net.sf.jasperreports.engine.data.JsonDataSource df = new net.sf.jasperreports.engine.data.JsonDataSource (is);
		return  JasperFillManager.fillReport(getReport(), model, df);
	}

	public void setVoKey(String voKey) {
		this.voKey = voKey;
	}
	
	public void setReportKey(String reportKey) {
		this.reportKey = reportKey;
	}

	public void setDataKey(String dataKey) {
		this.dataKey = dataKey;
	}

	public void setReportUrlPath(String reportUrlPath) {
		this.reportUrlPath = reportUrlPath;
	}
	
	public void setOrder(int order) {
		this.order = order;
	}

	/**
	 * Return the order in which this {@link org.springframework.web.servlet.ViewResolver}
	 * is evaluated.
	 */
	public int getOrder() {
		return this.order;
	}
}
