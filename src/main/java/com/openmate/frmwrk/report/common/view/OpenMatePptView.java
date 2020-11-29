package com.openmate.frmwrk.report.common.view;

import java.util.Map;

import net.sf.jasperreports.engine.JRExporter;
import net.sf.jasperreports.engine.export.ooxml.JRPptxExporter;

import org.springframework.web.servlet.view.jasperreports.AbstractJasperReportsSingleFormatView;

public class OpenMatePptView extends AbstractJasperReportsSingleFormatView {
	private String voKey;
	
	private String dataKey;
	
	private String reportUrlPath;
	
	private String suffix = ".jrxml";
	
	public OpenMatePptView() {
		super();
		this.setContentType("application/vnd.ms-powerpoint");
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

	public void setReportUrlPath(String reportUrlPath) {
		this.reportUrlPath = reportUrlPath;
	}

	@Override
	protected JRExporter createExporter() {
		return new JRPptxExporter();
	}

	@Override
	protected boolean useWriter() {
		return false;
	}
}
