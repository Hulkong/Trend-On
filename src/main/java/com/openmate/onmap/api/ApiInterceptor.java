package com.openmate.onmap.api;

import java.util.HashMap;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.openmate.onmap.api.service.ApiLogginSerivce;

public class ApiInterceptor extends HandlerInterceptorAdapter {
	private HashMap<String, Object> apiInfo;
	
	@Resource(name = "apiLogginSerivce")
	private ApiLogginSerivce apiLogginSerivce;

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		
		apiInfo = new HashMap<String, Object>();
		
		String url = request.getRequestURI();
		String[] urlArr = url.split("/");
		int urlArrLen = urlArr.length;
		
		if(url.indexOf("/api/code") >= 0) {
			return true;
		}
		
		//마지막에 .위치까지 잘라준다.
		if(url.indexOf('.') > -1)
			urlArr[urlArrLen-1] = urlArr[urlArrLen-1].substring(0, urlArr[urlArrLen-1].indexOf("."));
		
		String authKey = (String) request.getParameter("authKey");
		
		apiInfo.put("url", url);
		apiInfo.put("rgnId", urlArr[urlArrLen-3]);
		apiInfo.put("fromDate", urlArr[urlArrLen-2]);
		apiInfo.put("toDate", urlArr[urlArrLen-1]);
		apiInfo.put("authKey", authKey);
		
		try {
			apiLogginSerivce.apiLogging(apiInfo);
		} catch (Exception e) {
			// TODO: handle exception
			e.getStackTrace();
		}
		
		return true;
	}

}
