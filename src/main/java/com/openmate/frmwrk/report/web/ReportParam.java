package com.openmate.frmwrk.report.web;

import java.io.Serializable;
import java.util.Map;

public class ReportParam  implements Serializable{
	
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1685618996294030166L;
	private String rptId ;
	private Map<String,Object> param;
	public String getRptId() {
		return rptId;
	}
	public void setRptId(String rptId) {
		this.rptId = rptId;
	}
	public Map<String, Object> getParam() {
		return param;
	}
	public void setParam(Map<String, Object> param) {
		this.param = param;
	}
	public String getKey(){
		return this.rptId + this.param.toString();
	}
	
}
