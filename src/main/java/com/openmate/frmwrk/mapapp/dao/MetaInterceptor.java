package com.openmate.frmwrk.mapapp.dao;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Properties;

import org.apache.ibatis.executor.resultset.ResultSetHandler;
import org.apache.ibatis.plugin.Interceptor;
import org.apache.ibatis.plugin.Intercepts;
import org.apache.ibatis.plugin.Invocation;
import org.apache.ibatis.plugin.Plugin;
import org.apache.ibatis.plugin.Signature;
import org.geotools.feature.simple.SimpleFeatureTypeBuilder;
import org.opengis.feature.simple.SimpleFeatureType;
import org.opengis.referencing.crs.CoordinateReferenceSystem;

import com.vividsolutions.jts.geom.Geometry;


@Intercepts({ @Signature(type = ResultSetHandler.class, method = "handleResultSets", args = {Statement.class})})
public class MetaInterceptor implements Interceptor{

	@Override
	public Object plugin(Object target) {
		return Plugin.wrap(target, this);
	}
	
	@Override
	public void setProperties(Properties properties) {
		
	}
	
	
	@Override
	public Object intercept(Invocation invocation) throws Throwable {
		
		if(FeatureDataHolder.getMetaData() != null){
			Map metaBasic = FeatureDataHolder.getMetaData();
			Object[] args = invocation.getArgs();
			Statement statement = (Statement) args[0];
			FeatureDataHolder.getMetaData().put("featureType", getMetaDataFromResultSet(metaBasic,statement));
		}

		return invocation.proceed();
	}


	private Class<?> getAttrType(String type) {
		String t = type.toLowerCase();
		
		if(t.toLowerCase().matches("int|tinyint|bigint|integer|int4")) {
			return Integer.class;
		}else if(t.toLowerCase().matches("decimal|double|float|number")) {
			return Double.class;
		} else if(t.toLowerCase().matches("geometry")) {
			return Geometry.class;
		}
		
		return String.class;
	}
	private SimpleFeatureType getMetaDataFromResultSet(Map metaBasic ,Statement statement) {
		
		SimpleFeatureType featureType = null;
		
		try {
			ResultSet rs = statement.getResultSet();
			ResultSetMetaData metaData = rs.getMetaData();
			int columnCount = metaData.getColumnCount();
			
			
			String typeName = (String)metaBasic.get("typeName");
			CoordinateReferenceSystem crs = (CoordinateReferenceSystem)metaBasic.get("crs");
			
			
			SimpleFeatureTypeBuilder builder = new SimpleFeatureTypeBuilder();
			builder.setName(typeName);
			builder.setCRS(crs);
			for (int i = 1; i <= columnCount; i++) {
				builder.add(metaData.getColumnName(i),getAttrType(metaData.getColumnTypeName(i)));
			}
			featureType = builder.buildFeatureType();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return featureType;
	}
}
