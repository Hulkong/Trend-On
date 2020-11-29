package com.openmate.frmwrk.mapapp.service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.ibatis.session.SqlSessionFactory;
import org.geotools.feature.DefaultFeatureCollection;

import com.openmate.frmwrk.mapapp.dao.FeatureInfo;

public interface MapAppService {
	public DefaultFeatureCollection getFeature( FeatureInfo fInfo , Object param,SqlSessionFactory sessionFactory);
	public void writeFeature( HttpServletRequest req, HttpServletResponse res,DefaultFeatureCollection coll );
}
