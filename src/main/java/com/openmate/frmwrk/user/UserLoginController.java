package com.openmate.frmwrk.user;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.context.HttpRequestResponseHolder;
import org.springframework.security.web.context.SecurityContextRepository;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.RequestCache;
import org.springframework.security.web.savedrequest.SavedRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class UserLoginController {

	@Autowired
	AuthenticationManager authenticationManager;
	
	
	@Autowired
	SecurityContextRepository securityContextRepository;


	@RequestMapping(value = "/openmate/login.json", method = RequestMethod.POST)
	@ResponseBody
	public ModelMap login(HttpServletRequest request, HttpServletResponse response,
			@RequestParam(value = "id") String username, @RequestParam(value = "password") String password) {

		ModelMap map = new ModelMap();
		org.springframework.security.web.session.SimpleRedirectInvalidSessionStrategy dfdf;
		UsernamePasswordAuthenticationToken token = new UsernamePasswordAuthenticationToken(username, password);

		try {
			// 로그인
			Authentication auth = authenticationManager.authenticate(token);
			SecurityContextHolder.getContext().setAuthentication(auth);

			HttpRequestResponseHolder requestResponseHolder = new HttpRequestResponseHolder(request, response);
			securityContextRepository.loadContext(requestResponseHolder);

			request = requestResponseHolder.getRequest();
			response = requestResponseHolder.getResponse();

			securityContextRepository.saveContext(SecurityContextHolder.getContext(), request, response);

			map.put("success", true);
			map.put("returnUrl", getReturnUrl(request, response));
		} catch (BadCredentialsException e) {
			map.put("success", false);
			map.put("message", e.getMessage());
		}catch (DisabledException e) {
			map.put("success", false);
			map.put("message", e.getMessage());
		}

		return map;
	}

	/**
	 * 로그인 하기 전의 요청했던 URL을 알아낸다.
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	private String getReturnUrl(HttpServletRequest request, HttpServletResponse response) {
		RequestCache requestCache = new HttpSessionRequestCache();
		SavedRequest savedRequest = requestCache.getRequest(request, response);
		if (savedRequest == null) {
			return request.getSession().getServletContext().getContextPath();
		}
		return savedRequest.getRedirectUrl();
	}

}
