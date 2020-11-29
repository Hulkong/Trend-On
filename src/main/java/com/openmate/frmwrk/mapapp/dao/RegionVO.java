package com.openmate.frmwrk.mapapp.dao;

import com.vividsolutions.jts.geom.Geometry;

public class RegionVO {
	private Geometry geometry;
	private String fullName ;
	public Geometry getGeometry() {
		return geometry;
	}
	public void setGeometry(Geometry geometry) {
		this.geometry = geometry;
	}
	public String getFullName() {
		return fullName;
	}
	public void setFullName(String fullName) {
		this.fullName = fullName;
	}
	
}
