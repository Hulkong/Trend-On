package com.openmate.onmap.api;

import java.io.ByteArrayOutputStream;
import java.util.HashMap;

import javax.annotation.Resource;

import org.apache.ibatis.session.SqlSessionFactory;
import org.geotools.geojson.feature.FeatureJSON;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.openmate.frmwrk.mapapp.dao.FeatureInfo;
import com.openmate.frmwrk.mapapp.service.MapAppService;
import com.openmate.onmap.common.dao.CommonDao;

/*
 * 작성자: 최종진
 * 작성일자: 2018-04-23
 * 타이틀: 공통 코드
 * 내용: 기초 코드 조회 API
 *  1. 파일: common-mapper.xml
 */


@RestController
@RequestMapping("/code")
public class ApiCodeController {
	
	@Resource(name = "commonDao")
	private CommonDao commonDao;
	
	@Resource(name = "mapAppService")
	private MapAppService mapAppService;
	
	@Resource(name = "onmapSqlSession")
	private SqlSessionFactory sessionFactory;
	
	@Resource(name = "apiAuthCheck")
	private ApiAuthCheck apiAuthCheck;
	
	/**
	 * 전체 공통 데이터 조회
	 * 
	 * /all
	 * 
	 * @return defaultType : xml
	 */
	@RequestMapping(value="/all", method=RequestMethod.GET)
	public Object getAllCommData(@RequestParam(defaultValue = "UPJONG2_CD") String code, @RequestParam(defaultValue = "H1") String rgnClss) {
		
		HashMap<String, Object> rmap = new HashMap<String, Object>();
		HashMap<String, Object> param = new HashMap<String, Object>();
		
		// 파라미터 세팅
		param.put("rgnClss", rgnClss);
		param.put("code", code);
		param.put("admiFlg", "1");
		
		rmap.put("CommonCodeList", commonDao.getCommonCode());
		rmap.put("CommonCodeList2", commonDao.getCommonCodeList(param));
		rmap.put("stdDate", commonDao.getDateRange(param));
		rmap.put("upjong", commonDao.getUpjong2SelectOption());
		rmap.put("effUpjong", commonDao.getEffUpjong2SelectOption(param));
		rmap.put("region", commonDao.getRegionList(param));
		
		rmap.put("resultMsg", "Success");
		rmap.put("status", "success");
		
		return rmap;
	}
	
	
	/**
	 * 코드 리스트
	 * 
	 * /codeList
	 * 
	 * @return defaultType : xml
	 */
	@RequestMapping(value="/codeList", method=RequestMethod.GET)
	public Object getCode() {
		
		HashMap<String, Object> rmap = new HashMap<String, Object>();

		rmap.put("CommonCodeList", commonDao.getCommonCode());
			
		return rmap;
	}
	
	/**
	 * 코드 리스트
	 * 
	 * /codeList/{code}
	 * 
	 * @param code: 코드 클래스
	 * @return defaultType : xml
	 */
	@RequestMapping(value="/codeList/{code}", method=RequestMethod.GET)
	public Object getCodeList(@PathVariable String code) {
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		HashMap<String, Object> rmap = new HashMap<String, Object>();
			
		param.put("code", code);				
			
		rmap.put("CommonCodeList", commonDao.getCommonCodeList(param));
			
		return rmap;
	}
	
	/**
	 * 기준년월 조회
	 * 
	 * /stdDate/
	 * 
	 * @return defaultType : xml
	 */
	@RequestMapping(value="/stdDate", method=RequestMethod.GET)
	public Object getStdDate() {
		HashMap<String, Object> param = new HashMap<String, Object>();
		HashMap<String, Object> rmap = new HashMap<String, Object>();
			
		rmap.put("stdDate", commonDao.getDateRange(param));
			
		return rmap;
	}
	
	/**
	 * 업종 중분류
	 * 
	 * /upjong/
	 * 
	 * @return defaultType : xml
	 */
	@RequestMapping(value="/upjong", method=RequestMethod.GET)
	public Object getUpjong() {
		HashMap<String, Object> rmap = new HashMap<String, Object>();
			
		rmap.put("upjong", commonDao.getUpjong2SelectOption());
			
		return rmap;
	}
	
	/**
	 * 이벤트효과 업종 중분류
	 * 
	 * /upjong/
	 * 
	 * @return defaultType : xml
	 */
	@RequestMapping(value="/effUpjong", method=RequestMethod.GET)
	public Object getEffUpjong() {
		HashMap<String, Object> rmap = new HashMap<String, Object>();
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("admiFlg", "1");
		// 업종리스트 가져오기
		rmap.put("upjong", commonDao.getEffUpjong2SelectOption(param));
			
		return rmap;
	}
	
	/**
	 * 이벤트효과 업종 중분류 (읍면동 분류)
	 * 
	 * /upjong/
	 * 
	 * @return defaultType : xml
	 */
	@RequestMapping(value="/effUpjong/{admiCd}", method=RequestMethod.GET)
	public Object getEffUpjongflg(@PathVariable String admiCd) {
		HashMap<String, Object> rmap = new HashMap<String, Object>();
		HashMap<String, Object> param = new HashMap<String, Object>();
		
		// 동/읍(1), 면(0) 구분 flag 가져오기
		param.put("admiCd", admiCd);
		String admiFlg = commonDao.getEvntFlg(param);
		param.put("admiFlg", admiFlg);
		
		// 업종리스트 가져오기
		rmap.put("upjong", commonDao.getEffUpjong2SelectOption(param));
		
		return rmap;
	}
	
	/**
	 * 지역 조회
	 * 
	 * /region/{rgnClss}
	 * 
	 * @return defaultType : xml
	 */
	@RequestMapping(value="/region/{rgnClss}", method=RequestMethod.GET)
	public Object getRegion(@PathVariable String rgnClss, @RequestParam HashMap<String, Object> param) {
		HashMap<String, Object> rmap = new HashMap<String, Object>();
		
		param.put("rgnClss", rgnClss);
		
		rmap.put("region", commonDao.getRegionList(param));
			
		return rmap;
	}
	
	
	/**
	 * feature 정보 리턴
	 * 
	 * /feature/{pCtyCd}/{rgnClss}
	 * @param pCtyCd	상위 지역 코드 
	 * @param rgnClss	H1: 광역시도 H2: 시군구, H4: 행정동 
	 * @param authKey	권한
	 * @param coord		좌표계 기본 EPSG:4326
	 * @return defaultType : xml
	 */
	@RequestMapping(value="/feature/{pCtyCd}/{rgnClss}", method=RequestMethod.GET)
	public Object getRegion(@PathVariable String pCtyCd, @PathVariable String rgnClss,
							@RequestParam(defaultValue="EPSG:4326") String coord, @RequestParam(defaultValue = "") String authKey) {
		
		HashMap<String, Object> param = new HashMap<String, Object>();
	    FeatureInfo finfo = new FeatureInfo();
	    FeatureJSON fjson = new FeatureJSON();
	    JSONParser parser = new JSONParser();
		JSONObject json = new JSONObject();
		ByteArrayOutputStream output = new ByteArrayOutputStream();
		
		if(apiAuthCheck.checkApiKeyAuth(authKey)) {
			param.put("ctyCd", pCtyCd);					// 시군구 코드 // H1일때 다 가져 오려면 ALL로 입력

			param.put("dataId", "rpt-trnd"); 				
			param.put("rgnClss", rgnClss);				// 행정동단위
			
			finfo.setLayerCrs("KATEC");					// 레이어의 좌표계 세팅 
			finfo.setMapperId("com.openmate.onmap.main.dao.EcnmyTrndDao.getTrndMap");	// 특정데이터를 가져오기 위한 쿼리 세팅
			finfo.setTargetCrs(coord);					// 실제로 보여질 화면의 레이어 좌표계 세팅

			// 행정동별 지도데이터 가져옴 기본(공통)
			try {

				fjson.writeFeatureCollection(mapAppService.getFeature(finfo, param, sessionFactory), output);
				String outString = new String(output.toByteArray());
				json = (JSONObject) parser.parse(outString);
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		return json;
	}
	
}
