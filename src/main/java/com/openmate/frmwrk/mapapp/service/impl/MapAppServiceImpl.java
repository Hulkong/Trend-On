package com.openmate.frmwrk.mapapp.service.impl;

import java.beans.IntrospectionException;
import java.beans.PropertyDescriptor;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.apache.ibatis.session.ResultContext;
import org.apache.ibatis.session.ResultHandler;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.geotools.data.simple.SimpleFeatureIterator;
import org.geotools.feature.DefaultFeatureCollection;
import org.geotools.feature.simple.SimpleFeatureBuilder;
import org.geotools.geojson.feature.FeatureJSON;
import org.opengis.feature.simple.SimpleFeature;
import org.opengis.feature.simple.SimpleFeatureType;
import org.springframework.stereotype.Service;

import com.openmate.frmwrk.common.CamelUtil;
import com.openmate.frmwrk.mapapp.dao.FeatureDataHolder;
import com.openmate.frmwrk.mapapp.dao.FeatureInfo;
import com.openmate.frmwrk.mapapp.service.MapAppService;
import com.openmate.frmwrk.mapapp.util.CrsInfo;
import com.vividsolutions.jts.geom.Coordinate;
import com.vividsolutions.jts.geom.Geometry;






@Service("mapAppService")
public class MapAppServiceImpl implements MapAppService{
	
	@Override
	public DefaultFeatureCollection getFeature(FeatureInfo fInfo , Object param, SqlSessionFactory sessionFactory) {
	   

		final String targetCrs = fInfo.getTargetCrs();
	    final String layercrs = fInfo.getLayerCrs();
	    String mapperId = fInfo.getMapperId();
	    String layerName = fInfo.getLayerName();
	    
	    Map<String,Object> featureBasic = new HashMap<String,Object>();
	    
	    featureBasic.put("typeName", layerName);
	    featureBasic.put("crs",  CrsInfo.CRSMap.get(targetCrs));
	    
	    
	    SqlSession session = sessionFactory.openSession();
	    final DefaultFeatureCollection collection = new DefaultFeatureCollection();
	    
	    
		try {
			
			FeatureDataHolder.setMetaData(featureBasic);
			session.select(mapperId,param, new ResultHandler<Object>() {

				@Override
				public void handleResult(ResultContext<?> context) {
					SimpleFeatureType featureType = (SimpleFeatureType) FeatureDataHolder.getMetaData().get("featureType");
					Object data = context.getResultObject();
					SimpleFeatureBuilder featureBuilder = new SimpleFeatureBuilder(featureType);
					for (int j = 0; j < featureType.getAttributeCount(); j++) {

						String attrName = featureType.getDescriptor(j).getLocalName();
						
						Object item = null;
						if(data instanceof Map) {
							item = ((Map)data).get(attrName);
						}else{
							try {
								item = new PropertyDescriptor(CamelUtil.convert2CamelCase(attrName),data.getClass()).getReadMethod().invoke(data);
							} catch (IllegalAccessException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							} catch (IllegalArgumentException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							} catch (InvocationTargetException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							} catch (IntrospectionException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
						}
//						Object item = data.get(attrName);
						
						
						
						
						if(item instanceof Geometry) {
							
							Geometry geo = (Geometry) item;
							
							Coordinate[] coordinates = geo.getCoordinates();
							for(int k = 0; k < coordinates.length; k++) {
								Coordinate coord = coordinates[k];
								double[] oript = new double[2];
								oript[0] = coord.x;
								oript[1] = coord.y;
								
								double[] distpt = null;
								if("KATEC".equals(layercrs)) {
									distpt = com.openmate.frmwrk.mapapp.util.OpenProjection.transXyDouble(oript, layercrs, "EPSG:4326", targetCrs);
								} else {
									distpt = com.openmate.frmwrk.mapapp.util.OpenProjection.transXyDouble(oript, layercrs, targetCrs);
								}
								coord.x = distpt[0];
								coord.y = distpt[1];
							}
						}
						featureBuilder.add(item);
					}
					SimpleFeature feature = featureBuilder.buildFeature(null);
					collection.add(feature);
				}
			}) ;
			
			
		} finally {
			session.close();
		}
	    
		FeatureDataHolder.removeMetaData();

		return collection;
	}

	public void writeFeature(HttpServletRequest req, HttpServletResponse res,DefaultFeatureCollection coll){
		ServletOutputStream out = null;
		FeatureJSON fjson = new FeatureJSON();
		res.setContentType("application/json");
		res.setCharacterEncoding("UTF-8");
		
		
		try {
			out = res.getOutputStream();
			ByteArrayOutputStream output = new ByteArrayOutputStream();
			
//		    SimpleFeatureIterator iterator = coll.features();
//		    try {
//		        while( iterator.hasNext() ){
//		            SimpleFeature feature = iterator.next();
//		            System.out.println(feature);
//		            // process feature
//		        }
//		    }
//		    finally {
//		        iterator.close();
//		    }
		    
		    
			fjson.writeFeatureCollection(coll, output);
			String outString = new String(output.toByteArray());
//			System.out.println(outString);
			IOUtils.write(outString, out,"UTF-8");
			out.flush();
			IOUtils.closeQuietly(out);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}		
	}
}
