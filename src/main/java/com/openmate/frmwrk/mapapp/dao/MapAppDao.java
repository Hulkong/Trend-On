package com.openmate.frmwrk.mapapp.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository(value = "mapAppDao")
public interface MapAppDao {
	public List<Map>getRegion();
	public List<Map>getQ001();
	public List<Map>getQ002();
}
