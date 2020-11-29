package com.openmate.frmwrk.mapapp.dao;

import java.io.Serializable;

public class FeatureInfo implements Serializable{
	
	private static final long serialVersionUID = -4066802678420572403L;
	
	
	
	private String layerCrs = "";
	private String targetCrs = "";
	private String mapperId = "";
	private String layerName = "";
	

	public String getLayerCrs() {
		return layerCrs;
	}

	public void setLayerCrs(String layerCrs) {
		this.layerCrs = layerCrs;
	}

	public String getTargetCrs() {
		return targetCrs;
	}

	public void setTargetCrs(String targetCrs) {
		this.targetCrs = targetCrs;
	}

	public String getMapperId() {
		return mapperId;
	}

	public void setMapperId(String mapperId) {
		this.mapperId = mapperId;
	}

	public String getLayerName() {
		return layerName;
	}

	public void setLayerName(String layerName) {
		this.layerName = layerName;
	}
	
	
	
}
