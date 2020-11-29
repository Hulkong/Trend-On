package com.openmate.frmwrk.user;

import java.io.IOException;
import java.util.Iterator;

import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.DefaultRedirectStrategy;
import org.springframework.security.web.RedirectStrategy;
import org.springframework.security.web.WebAttributes;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.RequestCache;
import org.springframework.security.web.savedrequest.SavedRequest;

public class UserAuthenticationSuccessHandler implements AuthenticationSuccessHandler{


	private Logger logger = LoggerFactory.getLogger(UserAuthenticationSuccessHandler.class);

	private RedirectStrategy redirectStrategy = new DefaultRedirectStrategy();

	private String defaultTargetUrl;

	private String targetUrlName;

	private RequestCache requestCache = new HttpSessionRequestCache();

	private String loginpage ;

	@Value("${config.service.type}")
	private String serviceType;


	static final String REQUEST_PARAM_NAME = "saved_username";
	static final String COOKIE_NAME = "saved_username";
	static final int DEFAULT_MAX_AGE = 60 * 60 * 24 * 7;

	private int maxAge = DEFAULT_MAX_AGE;
	public String getLoginpage() {
		return loginpage;
	}

	public void setLoginpage(String loginpage) {
		this.loginpage = loginpage;
	}

	@Override
	public void onAuthenticationSuccess(HttpServletRequest req, HttpServletResponse res, Authentication auth)
			throws IOException, ServletException {
		handle(req, res, auth);
		clearAuthenticationAttributes(req);

	}

	protected void handle(HttpServletRequest req, HttpServletResponse res, Authentication auth) throws IOException {

		System.out.println("로그인 성공!!");
		User uu = (User)auth.getPrincipal();
		System.out.println("?>>>>>>>>>"+uu.getUsername());
		System.out.println(">>?>>>????>>????"+uu.isInitPasswd());
		System.out.println("<<<<<<<<<<<<<<<<<"+uu.getOrgId());
		System.out.println("<<<<<<<<<<<<<<<<<"+uu.getContractId());
		System.out.println("<>>>>>>>><><><<>><" + req.getRequestURI());
		System.out.println("<>>>>>>>><><><<>><" + req.getScheme());
		System.out.println("<>>>>>>>><><><<>><" + req.getServerName());
		System.out.println("<>>>>>>>><><><<>><" + req.getServerPort());
		System.out.println("<>>>>>>>><><><<>><" + auth.getAuthorities());
		System.out.println("<serviceType>>>>>>>><><><<>><" + serviceType);

		String remember = req.getParameter(REQUEST_PARAM_NAME);

		if (remember != null) {

			String username = (uu).getUsername();

			Cookie cookie = new Cookie(COOKIE_NAME, username);
			cookie.setMaxAge(maxAge);
			cookie.setPath("/");
			res.addCookie(cookie);

		} else {
			Cookie cookie = new Cookie(COOKIE_NAME, "");
			cookie.setMaxAge(0);
			res.addCookie(cookie);
		}

		String targetUrl = null;
//		if (targetUrlName != null) {
//			targetUrl = req.getParameter(targetUrlName);
//			System.out.println(targetUrl);
//			if (targetUrl == null)
//				targetUrl = defaultTargetUrl;
//		}

		SavedRequest savedRequest = requestCache.getRequest(req, res);
		String savedRequestUrl = (savedRequest == null) ? null : savedRequest.getRedirectUrl();
		String refererUrl = req.getHeader("REFERER");


		if(this.loginpage != null && refererUrl != null){

			if(  refererUrl.indexOf(this.loginpage) > -1){
				refererUrl = defaultTargetUrl;
			}
		}
//		System.out.println("savedRequestUrl = "+savedRequestUrl);
//		System.out.println("refererUrl = "+refererUrl);

		targetUrl = (savedRequestUrl == null) ? ((refererUrl == null) ? defaultTargetUrl : refererUrl) : savedRequestUrl;

		String lpu = req.getRequestURI();

		if("/onmap/login/loginProc.do".equals(lpu) ) {
			if(serviceType!= null && serviceType.equals("release")){
				targetUrl = req.getScheme()+"://"+req.getServerName()+"/onmap/crfc_main.do";
			}else{
				targetUrl = req.getScheme()+"://"+req.getServerName()+":"+req.getServerPort()+"/onmap/crfc_main.do";
			}
		}

//		if (targetUrl == null) {
//			targetUrl = savedRequest.getRedirectUrl();
//			if (targetUrl == null)
//				targetUrl = req.getHeader("REFERER");
//		}

		if (res.isCommitted()) {
			logger.debug("Response has already been committed. Unable to redirect to " + targetUrl);
			return;
		}

//		System.out.println("targetUrl ::: "+ targetUrl);
		String userType = req.getParameter("userType");

		if(userType != null && userType.equals("admin")) {
			targetUrl = req.getScheme()+"s://"+req.getServerName()+":"+req.getServerPort()+"/onmap/admin/main.do";	
		}

		redirectStrategy.sendRedirect(req, res, targetUrl);
	}

	protected String determineTargetUrl(Authentication auth) {
		System.out.println("OpenmateAuthenticationSuccessHandler determineTargetUrl");
		return defaultTargetUrl;
	}

	protected void clearAuthenticationAttributes(HttpServletRequest request) {
		System.out.println("OpenmateAuthenticationSuccessHandler clearAuthenticationAttributes");
		HttpSession session = request.getSession(false);
		if (session == null) {
			return;
		}
		session.removeAttribute(WebAttributes.AUTHENTICATION_EXCEPTION);
	}

	public void setRedirectStrategy(RedirectStrategy redirectStrategy) {
		this.redirectStrategy = redirectStrategy;
	}

	protected RedirectStrategy getRedirectStrategy() {
		return redirectStrategy;
	}

	public String getDefaultTargetUrl() {
		return defaultTargetUrl;
	}

	public void setDefaultTargetUrl(String defaultTargetUrl) {
		this.defaultTargetUrl = defaultTargetUrl;
	}

	public String getTargetUrlName() {
		return targetUrlName;
	}

	public void setTargetUrlName(String targetUrlName) {
		this.targetUrlName = targetUrlName;
	}



}

