package com.openmate.frmwrk.usemenu;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.openmate.frmwrk.user.UserInfo;
import com.openmate.frmwrk.user.UserService;

public class UseMenuInterceptor extends HandlerInterceptorAdapter {
	
	@Resource(name = "userService")
	private UserService userService;
	
	private Map<String, String> urlInfo;


	private UseMenuLogginSerivce service ;


	public UseMenuLogginSerivce getService() {
		return service;
	}

	public void setService(UseMenuLogginSerivce service) {
		this.service = service;
	}

	public Map<String, String> getUrlInfo() {
		return urlInfo;
	}

	public void setUrlInfo(Map<String, String> urlInfo) {
		this.urlInfo = urlInfo;
	}

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {


		Authentication auth = SecurityContextHolder.getContext().getAuthentication();

		String userId = "";     // 유저 아이디 
		int orgId = -1;   // 기관 아이디 
		int contractId = -1; // 계약 아이디 
		
		// 인증 값이 있을 경우 
		if(auth != null) {

			Object principal = auth.getPrincipal();
			
			if(principal != null && principal instanceof UserDetails){
				userId = ((UserDetails)principal).getUsername();
				
				UserInfo uInfo = userService.selectUserInfo(userId);
				
				if(uInfo != null) {
					orgId = uInfo.getOrgId();     // 기관 아이디 가져옴 
					contractId = uInfo.getContractId(); // 계약 아이디 가져옴 
				}
			}
		}

		if (urlInfo == null) {
			return true;
		} else {
			for (String stem : urlInfo.keySet()) {
				if (request.getRequestURI().matches(stem)) {

					UseMenuInfo menuInfo = new UseMenuInfo();
					menuInfo.setUrl(request.getRequestURI());
					menuInfo.setUserId(userId);
					menuInfo.setOrgId(orgId);
					menuInfo.setContractId(contractId);
					menuInfo.setMenuNm(urlInfo.get(stem));
					
					String ip = request.getHeader("x-forwarded-for");      
				    if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {      
				       ip = request.getHeader("Proxy-Client-IP");      
				    }      
				    if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {      
				       ip = request.getHeader("WL-Proxy-Client-IP");      
				    }      
				    if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {      
				       ip = request.getRemoteAddr();      
				    }   
					
				    menuInfo.setUserIp(ip);				
					
					if(service != null)
						service.logging(menuInfo);
				}
			}
		}

		return true;
	}

}
