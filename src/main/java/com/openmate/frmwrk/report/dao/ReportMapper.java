package com.openmate.frmwrk.report.dao;

import java.util.List;
import java.util.Map;

//@Repository("ReportMapper")
public interface ReportMapper {
	public List<Map<String, Object>> getTestList(Map<String, Object> vo);
	
	public List<Map<String, Object>> getTestList1(Map<String, Object> vo);
	
	public List<Map<String, Object>> getTestList2(Map<String, Object> vo);
	
}
