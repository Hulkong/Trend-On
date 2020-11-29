package com.openmate.onmap.api;

import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;

import com.openmate.onmap.api.dao.ApiAuthDao;

/*
 * 작성자: 김용현
 * 작성일자: 2018-05-03
 * 타이틀: API인증
 * 내용: API호출시 인증하는 로직
 *  1. 파일: api-auth-mapper.xml
 *  2. sqlId
 *   - checkApiAuth: API호출 체크
 */

@Service(value= "apiAuthCheck")
public class ApiAuthCheck {

	@Resource(name = "apiAuthDao")
	private ApiAuthDao apiAuthDao;

	/**
	 * API 정보체크
	 * 
	 * @param req
	 * @param rgnId
	 * @return rmap(String resultMsg, String status, String errorCode)
	 */
	public Map<String, Object> checkApiAuth(HttpServletRequest req, String rgnId) {
		
		Map<String, Object> rmap = new HashMap<String, Object>();
		HashMap<String, Object> checkParam = new HashMap<String, Object>();
		
		String authKey = req.getParameter("authKey");    // API 인증키
		String orgin = req.getHeader("Origin");  		 // ajax호출시 원격 도메인가져옴
		String apiDomain = "";
		
		// java url call or curl or url을 직접 호출했을 때(request정보에 domain이 없을 시 ip를 가져옴) 
		if(orgin == null || orgin.length() == 0) {
			
			String host = req.getHeader("Host");
			String regex = "^([^:\\/\\s]+)(:([^\\/]*))";
			
	        Pattern p = Pattern.compile(regex);
	        Matcher m = p.matcher(host);
	        
	        // url에 localhost가 있을 경우
	        if(m.find() && "localhost".equals(m.group(1))) {
	        	
	        	apiDomain = m.group(1);
	        	
	        } else {
	        	orgin = req.getHeader("X-Forwarded-For");
	        	
	        	if (orgin == null || orgin.length() == 0 || "unknown".equalsIgnoreCase(orgin)) { 
	        		orgin = req.getHeader("Proxy-Client-IP"); 
	        	} 
	        	
	        	if (orgin == null || orgin.length() == 0 || "unknown".equalsIgnoreCase(orgin)) { 
	        		orgin = req.getHeader("WL-Proxy-Client-IP"); 
	        	}
	        	
	        	if (orgin == null || orgin.length() == 0 || "unknown".equalsIgnoreCase(orgin)) { 
	        		orgin = req.getHeader("HTTP_CLIENT_IP"); 
	        	}
	        	
	        	if (orgin == null || orgin.length() == 0 || "unknown".equalsIgnoreCase(orgin)) { 
	        		orgin = req.getHeader("HTTP_X_FORWARDED_FOR"); 
	        	}
	        	
	        	if (orgin == null || orgin.length() == 0 || "unknown".equalsIgnoreCase(orgin)) { 
	        		orgin = req.getRemoteHost(); 
	        		
	        		if(orgin == null || orgin.length() == 0) {
	        			orgin = req.getRemoteAddr();
	        		}
	        	}
	        	
	        	apiDomain = orgin;
	        }
			
		} else {    // request정보에 domain이 있을경우(ajax로 호출할 때)
			
			String regex = "^(https?):\\/\\/([^:\\/\\s]+)(:([^\\/]*))";
			
	        Pattern p = Pattern.compile(regex);
			
	        Matcher m = p.matcher(orgin);        
	        
	        if(m.find()) apiDomain = m.group(2);
		}
		
		checkParam.put("apiDomain", apiDomain);
		checkParam.put("rgnId", rgnId);
		checkParam.put("apiKey", authKey);
		
		HashMap<String, Object> checkMap = (HashMap<String, Object>) apiAuthDao.checkApiAuth(checkParam);
		
		// 인증키가 유효하지 않을 때
		if(checkMap == null) {
			rmap.put("resultMsg", "Invalid AuthenticationKey");
			rmap.put("status", "error");
			rmap.put("errorCode", 1);
			return rmap;
		}
		
		boolean regionCheck = ((int) checkMap.get("region_check") == 0) ? true : false;
		boolean domainCheck = ((int) checkMap.get("domain_check") == 0) ? true : false;
		boolean expCheck = ((int) checkMap.get("exp_check") == 0) ? true : false;
		
		// 도메인이 다를 때
		if(domainCheck) {
			rmap.put("resultMsg", "Invalid Domain");
			rmap.put("status", "error");
			rmap.put("errorCode", 2);
			return rmap;
		}
		
		// 지역이 다를 때
		if(regionCheck) {
			rmap.put("resultMsg", "Invalid Region");
			rmap.put("status", "error");
			rmap.put("errorCode", 3);
			return rmap;
		}
				
		// 만료기간일 때
		if(expCheck) {
			rmap.put("resultMsg", "Expired");
			rmap.put("status", "error");
			rmap.put("errorCode", 4);
			return rmap;
		}

		// 인증조건이 모두 통과할 때
		rmap.put("errorCode", 0);
		return rmap;
	};
	
	// feature정보 가져올 때 인증키만 체크하는 메소드
	public boolean checkApiKeyAuth(String authKey) {
		
		boolean authFlag = false;
		
		//인증키 체크
		int cnt = apiAuthDao.checkApiKeyAuth(authKey);
		
		//인증키가 있을 때 
		if(cnt > 0) authFlag = true;
		
		return authFlag;
	};
}
