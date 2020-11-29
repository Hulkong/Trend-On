package com.openmate.frmwrk.mapapp.handlers;

import java.beans.PropertyDescriptor;
import java.lang.reflect.Method;
import java.util.Map;

import org.apache.ibatis.session.ResultContext;
import org.apache.ibatis.session.ResultHandler;
import org.geotools.feature.simple.SimpleFeatureBuilder;
import org.opengis.feature.simple.SimpleFeature;
import org.opengis.feature.simple.SimpleFeatureType;

import com.openmate.frmwrk.mapapp.dao.FeatureDataHolder;
import com.vividsolutions.jts.geom.Coordinate;
import com.vividsolutions.jts.geom.Geometry;

public class FeatureResultHandler<T> implements ResultHandler<T> {

	@Override
	public void handleResult(ResultContext<? extends T> context){
		SimpleFeatureType featureType = (SimpleFeatureType) FeatureDataHolder.getMetaData().get("featureType");
		T data = context.getResultObject();
		SimpleFeatureBuilder featureBuilder = new SimpleFeatureBuilder(featureType);
//		for (int j = 0; j < featureType.getAttributeCount(); j++) {
//
//			String attrName = featureType.getDescriptor(j).getLocalName();
//			Object item = null;
//			if(data instanceof Map) {
//				item = ((Map)data).get(attrName);
//			}else{
//				item = new PropertyDescriptor(attrName,data.getClass()).getReadMethod().invoke(data);
//			}
//			
//			if(item instanceof Geometry) {
//				
//				Geometry geo = (Geometry) item;
//				
//				Coordinate[] coordinates = geo.getCoordinates();
//				for(int k = 0; k < coordinates.length; k++) {
//					Coordinate coord = coordinates[k];
//					double[] oript = new double[2];
//					oript[0] = coord.x;
//					oript[1] = coord.y;
//					
//					double[] distpt = null;
//					if("KATEC".equals(layercrs)) {
//						distpt = com.openmate.frmwrk.mapapp.util.OpenProjection.transXyDouble(oript, layercrs, "EPSG:4326", targetCrs);
//					} else {
//						distpt = com.openmate.frmwrk.mapapp.util.OpenProjection.transXyDouble(oript, layercrs, targetCrs);
//					}
//					coord.x = distpt[0];
//					coord.y = distpt[1];
//				}
//			}
//			featureBuilder.add(item);
//		}
//		SimpleFeature feature = featureBuilder.buildFeature(null);
//		collection.add(feature);
	}

}
