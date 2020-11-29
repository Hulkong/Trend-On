package com.openmate.onmap.report.service;

import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository(value = "onmapReportDao")
public interface OnmapReportDao {
	public int insertCache(java.util.Map param);
	public int deleteCache(String id);
	public int existCache(String id);
	public Map<String,Object> selectCache(String id);	
}
