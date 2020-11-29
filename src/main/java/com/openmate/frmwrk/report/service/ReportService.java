package com.openmate.frmwrk.report.service;

import java.util.HashMap;
import java.util.Map;

import com.openmate.frmwrk.report.web.ReportParam;

public interface ReportService {

	public Map<String, Object> getJsonByDataId(ReportParam rParam) throws Exception;
	public String getJsonStrByDataId(ReportParam rParam) throws Exception;
	public int getCacheId() throws Exception;
	
}
