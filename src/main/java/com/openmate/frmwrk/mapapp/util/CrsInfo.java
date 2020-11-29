package com.openmate.frmwrk.mapapp.util;

import java.util.HashMap;
import java.util.Map;

import org.geotools.referencing.CRS;
import org.opengis.referencing.FactoryException;
import org.opengis.referencing.NoSuchAuthorityCodeException;
import org.opengis.referencing.crs.CoordinateReferenceSystem;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


public class CrsInfo {
	/* 공간좌표 체계 */
	public static final Map<String, CoordinateReferenceSystem> CRSMap = new HashMap<String, CoordinateReferenceSystem>();
	
	
	public static final String EPSG_4326 = "EPSG:4326";
	public static final String KATEC = "KATEC";
	public static final String EPSG_3857 = "EPSG:3857";
	public static final String EPSG_5181 = "EPSG:5181";
	public static final String EPSG_5179 = "EPSG:5179";
	public static final String EPSG_900913 = "EPSG:900913";
	public static final String CRS_84 = "CRS:84";
	
	
	private Logger logger = LoggerFactory.getLogger(CrsInfo.class);
	static {		
		String epsg4326Wkt = "GEOGCS[\"WGS 84\",DATUM[\"WGS_1984\",SPHEROID[\"WGS 84\",6378137,298.257223563,AUTHORITY[\"EPSG\",\"7030\"]],AUTHORITY[\"EPSG\",\"6326\"]],PRIMEM[\"Greenwich\",0,AUTHORITY[\"EPSG\",\"8901\"]],UNIT[\"degree\",0.0174532925199433,AUTHORITY[\"EPSG\",\"9122\"]],AUTHORITY[\"EPSG\",\"4326\"]]";
		String katechWkt = "PROJCS[\"Korean_1985_Korea_Central_Belt\",GEOGCS[\"GCS_Korean_Datum_1985\",DATUM[\"D_Korean_Datum_1985\",SPHEROID[\"Bessel_1841\" ,6377397.155,299.1528128]],PRIMEM[\"Greenwich\",0.0],UNIT[\"Degree\",0.0174532925199433]],PROJECTION[\"Transverse_Mercator\"],PARAMETER[\"False_Easting\",400000.0],PARAMETER[\"False_Northing\",600000.0],PARAMETER[\"Central_Meridian\",128.0],PARAMETER[\"Scale_Factor\",0.9999],PARAMETER[\"Latitude_Of_Origin\",38.0],UNIT[\"Meter\",1.0]]";
		String katechWkt_2 = "PROJCS[\"KATEC\",GEOGCS[\"GEO-User\",DATUM[\"User-defined\",SPHEROID[\"User-defined\",6377397.155,299.15281280001636],TOWGS84[-115.8, 474.99, 674.11, 5.623838700870617E-6, -1.1199196033630281E-5, -7.902463002085436E-6, 1.00000643]],PRIMEM[\"Greenwich\", 0.0],,AXIS[\"Geodetic longitude\", EAST],AXIS[\"Geodetic latitude\", NORTH]],PROJECTION[\"tmerc\"],PARAMETER[\"central_meridian\", 128.0],PARAMETER[\"latitude_of_origin\", 38.0],PARAMETER[\"scale_factor\", 0.9999],PARAMETER[\"false_easting\", 400000.0],PARAMETER[\"false_northing\", 600000.0],AXIS[\"Easting\", EAST],AXIS[\"Northing\", NORTH]]";
		String googleWkt = "PROJCS[\"Google Maps Global Mercator\",GEOGCS[\"WGS 84\",DATUM[\"WGS_1984\",SPHEROID[\"WGS 84\",6378137,298.257223563,AUTHORITY[\"EPSG\",\"7030\"]],AUTHORITY[\"EPSG\",\"6326\"]],PRIMEM[\"Greenwich\",0,AUTHORITY[\"EPSG\",\"8901\"]],UNIT[\"degree\",0.01745329251994328,AUTHORITY[\"EPSG\",\"9122\"]],AUTHORITY[\"EPSG\",\"4326\"]],PROJECTION[\"Mercator_2SP\"],PARAMETER[\"standard_parallel_1\",0],PARAMETER[\"latitude_of_origin\",0],PARAMETER[\"central_meridian\",0],PARAMETER[\"false_easting\",0],PARAMETER[\"false_northing\",0],UNIT[\"Meter\",1],AUTHORITY[\"EPSG\",\"900913\"]]";
		String epsg3857 = "PROJCS[\"WGS 84 / Pseudo-Mercator\",GEOGCS[\"Popular Visualisation CRS\",DATUM[\"Popular_Visualisation_Datum\",SPHEROID[\"Popular Visualisation Sphere\",6378137,0,AUTHORITY[\"EPSG\",\"7059\"]],TOWGS84[0,0,0,0,0,0,0],AUTHORITY[\"EPSG\",\"6055\"]],PRIMEM[\"Greenwich\",0,AUTHORITY[\"EPSG\",\"8901\"]],UNIT[\"degree\",0.01745329251994328,AUTHORITY[\"EPSG\",\"9122\"]],AUTHORITY[\"EPSG\",\"4055\"]],UNIT[\"metre\",1,AUTHORITY[\"EPSG\",\"9001\"]],PROJECTION[\"Mercator_1SP\"],PARAMETER[\"central_meridian\",0],PARAMETER[\"scale_factor\",1],PARAMETER[\"false_easting\",0],PARAMETER[\"false_northing\",0],AUTHORITY[\"EPSG\",\"3785\"],AXIS[\"X\",EAST],AXIS[\"Y\",NORTH]]";
		String Korea_2000_Central_Belt = "PROJCS[\"Korea 2000 / Central Belt\",GEOGCS[\"Korea 2000\",DATUM[\"Geocentric datum of Korea\",SPHEROID[\"GRS 1980\",6378137.0,298.257222101,AUTHORITY[\"EPSG\",\"7019\"]],TOWGS84[0.0,0.0,0.0,0.0,0.0,0.0,0.0],AUTHORITY[\"EPSG\",\"6737\"]],PRIMEM[\"Greenwich\",0.0,AUTHORITY[\"EPSG\",\"8901\"]],UNIT[\"degree\",0.017453292519943295],AXIS[\"Geodetic longitude\",EAST],AXIS[\"Geodetic latitude\",NORTH],AUTHORITY[\"EPSG\",\"4737\"]],PROJECTION[\"Transverse_Mercator\"],PARAMETER[\"central_meridian\",127.0],PARAMETER[\"latitude_of_origin\",38.0],PARAMETER[\"scale_factor\",1.0],PARAMETER[\"false_easting\",200000.0],PARAMETER[\"false_northing\",500000.0],UNIT[\"m\",1.0],AXIS[\"Easting\",EAST],AXIS[\"Northing\",NORTH],AUTHORITY[\"EPSG\",\"5181\"]]";
		String PCS_ITRF2000_TM = "PROJCS[\"PCS_ITRF2000_TM\",GEOGCS[\"GCS_ITRF_2000\",DATUM[\"D_ITRF_2000\",SPHEROID[\"GRS_1980\",6378137.0,298.257222101]],PRIMEM[\"Greenwich\",0.0],UNIT[\"Degree\",0.0174532925199433]],PROJECTION[\"Transverse_Mercator\"],PARAMETER[\"False_Easting\",200000.0],PARAMETER[\"False_Northing\",500000.0],PARAMETER[\"Central_Meridian\",127.0],PARAMETER[\"Scale_Factor\",1.0],PARAMETER[\"Latitude_Of_Origin\",38.0],UNIT[\"Meter\",1.0]]";
		try {
			CRSMap.put(EPSG_4326, CRS.parseWKT(epsg4326Wkt));
			CRSMap.put(KATEC, CRS.parseWKT(katechWkt));
			CRSMap.put(EPSG_3857, CRS.parseWKT(epsg3857));			
			CRSMap.put(EPSG_900913, CRS.parseWKT(googleWkt));			
			CRSMap.put(EPSG_5181, CRS.parseWKT(Korea_2000_Central_Belt));			
			CRSMap.put(EPSG_5179, CRS.parseWKT(PCS_ITRF2000_TM));			
			CRSMap.put(CRS_84, CRS.parseWKT(epsg4326Wkt));			
		} catch (NoSuchAuthorityCodeException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (FactoryException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public static boolean checkCrs(String crs){
		return CRSMap.containsKey(crs);
	} 
}
