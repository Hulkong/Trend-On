package com.openmate.frmwrk.mapapp.util;

import java.util.HashMap;
import java.util.Map;

import org.osgeo.proj4j.CRSFactory;
import org.osgeo.proj4j.CoordinateReferenceSystem;
import org.osgeo.proj4j.CoordinateTransform;
import org.osgeo.proj4j.CoordinateTransformFactory;
import org.osgeo.proj4j.ProjCoordinate;


/**
 * @author ssodabup
 *
 */
public class OpenProjection {
	private static final CoordinateTransformFactory ctFactory = new CoordinateTransformFactory() {
		@Override
		public CoordinateTransform createTransform(CoordinateReferenceSystem src, CoordinateReferenceSystem tgt) {
			return new BasicCoordinateTransform(src, tgt);
		}
	};
	private static final String middleCrs = "EPSG:4326";
	private static final String katecCrs = "KATEC";
	private static final String googleCrs = "EPSG:3857";
	private static final CRSFactory crsFactory = new CRSFactory();
	private static final Map<String, CoordinateReferenceSystem> crsMap = new HashMap<String, CoordinateReferenceSystem>();

	static {
		crsMap.put("CRS:84",    crsFactory.createFromParameters("WGS84", "+proj=longlat +ellps=WGS84 +datum=WGS84 +units=degrees"));
		crsMap.put("WGS84",     crsFactory.createFromParameters("WGS84", "+proj=longlat +ellps=WGS84 +datum=WGS84 +units=degrees"));
		crsMap.put("EPSG:4326", crsFactory.createFromParameters("long/lat:WGS84", "+proj=longlat +a=6378137.0 +b=6356752.31424518 +ellps=WGS84 +datum=WGS84 +units=degrees"));
		crsMap.put("KATEC", 	crsFactory.createFromParameters("KATEC", "+proj=tmerc +lat_0=38.0 +lon_0=128.0 +x_0=400000.0 +y_0=600000.0 +k=0.9999 +ellps=bessel +a=6377397.155 +b=6356078.9628181886 +units=m +towgs84=-115.80,474.99,674.11,1.16,-2.31,-1.63,6.43"));
		crsMap.put("EPSG:5179", crsFactory.createFromParameters("PCS_ITRF2000_TM", "+proj=tmerc +lat_0=38 +lon_0=127.5 +k=0.9996 +x_0=1000000 +y_0=2000000 +ellps=GRS80 +units=m +no_defs"));
		crsMap.put("EPSG:5181", crsFactory.createFromParameters("EPSG:5181", "+proj=tmerc +lat_0=38 +lon_0=127 +k=1 +x_0=200000 +y_0=500000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"));
		crsMap.put("WEB", 		 crsFactory.createFromParameters("Google Mercator", "+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null"));
		crsMap.put("EPSG:900913",crsFactory.createFromParameters("Google Mercator", "+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null"));
		crsMap.put("EPSG:3857",  crsFactory.createFromParameters("Google Mercator", "+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null"));
	}
	


	public static ProjCoordinate transform(String src, String target, ProjCoordinate prjcoord) {
		
		
		ProjCoordinate out = null;
		if((katecCrs.equals(src) && googleCrs.equals(target)) || (googleCrs.equals(src) && katecCrs.equals(target))){
			ProjCoordinate tmp1 = ctFactory.createTransform(crsMap.get(src), crsMap.get(middleCrs)).transform(prjcoord, new ProjCoordinate());
			out = ctFactory.createTransform(crsMap.get(middleCrs), crsMap.get(target)).transform(tmp1, new ProjCoordinate());
			
		}else{
			out = ctFactory.createTransform(crsMap.get(src), crsMap.get(target)).transform(prjcoord, new ProjCoordinate());
		}
		

		return out;
	}
	
	public static CoordinateReferenceSystem getCrs(String key){
		return crsMap.get(key);
	}
	public static String getCrsWkt(String key){
		CoordinateReferenceSystem crs  = crsMap.get(key);
		String out = new ProjWKTEncoder().encode(crs, true);
		return out;
	}
	
	public static void reload(){
		crsMap.put("WGS84",     crsFactory.createFromParameters("WGS84", "+proj=longlat +ellps=WGS84 +datum=WGS84 +units=degrees"));
		crsMap.put("EPSG:4326", crsFactory.createFromParameters("long/lat:WGS84", "+proj=longlat +a=6378137.0 +b=6356752.31424518 +ellps=WGS84 +datum=WGS84 +units=degrees"));
		crsMap.put("WEB", crsFactory.createFromParameters("Google Mercator", "+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null"));
		crsMap.put("KATEC", crsFactory.createFromParameters("KATEC", "+proj=tmerc +lat_0=38.0 +lon_0=128.0 +x_0=400000.0 +y_0=600000.0 +k=0.9999 +ellps=bessel +a=6377397.155 +b=6356078.9628181886 +units=m +towgs84=-115.80,474.99,674.11,1.16,-2.31,-1.63,6.43"));
		crsMap.put("EPSG:900913", crsFactory.createFromParameters("Google Mercator", "+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null"));
		crsMap.put("EPSG:3857", crsFactory.createFromParameters("Google Mercator", "+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null"));
		crsMap.put("EPSG:5181", crsFactory.createFromParameters("EPSG:5181",       "+proj=tmerc +lat_0=38 +lon_0=127 +k=1 +x_0=200000 +y_0=500000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"));
		crsMap.put("EPSG:5179", crsFactory.createFromParameters("PCS_ITRF2000_TM", "+proj=tmerc +lat_0=38 +lon_0=127.5 +k=0.9996 +x_0=1000000 +y_0=2000000 +ellps=GRS80 +units=m +no_defs"));
		                    
	}
	/**
	 * @param xy <br/>
	 * xy[0]  //x <br/>
	 * xy[1]  //y <br/>
	 * @param src
	 * @param dist
	 * @return
	 * double[0]  //x <br/>
	 * double[1]  //y <br/>
	 */	
	public static double[] transXyDouble(double[] xy, String src, String dist) {
		
		ProjCoordinate tmp = OpenProjection.transform(src, dist, new ProjCoordinate(xy[0], xy[1]));
		double[] rtnArr = new double[2];
		rtnArr[0] = tmp.x;
		rtnArr[1] = tmp.y;
		return rtnArr;
	}
	
	/**
	 * @param xy <br/>
	 * xy[0]  //x <br/>
	 * xy[1]  //y <br/>
	 * @param src
	 * @param dist_src
	 * @param dist
	 * @return
	 * double[0]  //x <br/>
	 * double[1]  //y <br/>
	 */
	public static double[] transXyDouble(double[] xy, String src, String dist_src , String dist) {
//		double[] rtnArr =     OpenProjection.transXyDouble( 
//				OpenProjection.transXyDouble(xy,src, dist_src)
//				,dist_src
//				, dist);
		return OpenProjection.transXyDouble(xy,src, dist);
	}
	/**
	 * @param base<br/>
	 * base[0]  //minx,left <br/>
	 * base[1]  //miny,bottom <br/>
	 * base[2]  //maxx,right <br/>
	 * base[3]  //maxy,top <br/>
	 * @param src 
	 * @param dist
	 * @return
	 * double[0]  //minx,left <br/>
	 * double[1]  //miny,bottom <br/>
	 * double[2]  //maxx,right <br/>
	 * double[3]  //maxy,top <br/>
	 */
	public static double[]  transBboxDouble(double[] base,String src, String dist){

		ProjCoordinate ll = OpenProjection.transform(src, dist, new ProjCoordinate(base[0], base[1]));
		ProjCoordinate lr = OpenProjection.transform(src, dist, new ProjCoordinate(base[2], base[1]));
		ProjCoordinate ul = OpenProjection.transform(src, dist, new ProjCoordinate(base[0], base[3]));
		ProjCoordinate ur = OpenProjection.transform(src, dist, new ProjCoordinate(base[2], base[3]));
		
		double[] bboxArr = new double[4];
		
		bboxArr[0] = Math.min(ll.x, ul.x);
		bboxArr[1] = Math.min(ll.y, lr.y);
		bboxArr[2] = Math.max(lr.x, ur.x);
		bboxArr[3] = Math.max(ul.y, ur.y);
	
		return bboxArr;
	}
	
	
	/**
	 * @param base <br/>
	 * base[0]  //minx,left <br/>
	 * base[1]  //miny,bottom <br/>
	 * base[2]  //maxx,right <br/>
	 * base[3]  //maxy,top <br/>
	 * @param src
	 * @param dist_src
	 * @param dist
	 * @return
	 * double[0]  //minx,left <br/>
	 * double[1]  //miny,bottom <br/>
	 * double[2]  //maxx,right <br/>
	 * double[3]  //maxy,top <br/>
	 */
	public static double[] transBboxDouble(double[] base,String src, String dist_src, String dist) {

//		double[] dist_Arr =     OpenProjection.transBboxDouble( 
//				OpenProjection.transBboxDouble(base,src, dist_src)
//				,dist_src
//				, dist);

		return OpenProjection.transBboxDouble(base,src, dist);
	}
	
}
