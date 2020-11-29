package com.openmate.frmwrk.user;

import java.util.Collection;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.authentication.encoding.ShaPasswordEncoder;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.web.authentication.WebAuthenticationDetails;
public class UserAuthenticationProvider implements AuthenticationProvider{
	@Autowired
	ShaPasswordEncoder passwordEncoder;	
	
	@Value("${config.auth.login.url}")
	private String loginUrl;
	
	@Autowired
	private UserService loginService;
	
	private UserDetailsService userService;
	
	public UserDetailsService getUserService() {
		return userService;
	}

	public void setUserService(UserDetailsService userService) {
		this.userService = userService;
		
//		UserDetails dfdf  ;
	}

	@Override
	public Authentication authenticate(Authentication authentication) throws AuthenticationException {

		String username = authentication.getName();
		String password = (String) authentication.getCredentials();
		User user;
		Collection<? extends GrantedAuthority> authorities;
		try {
			user = (User) userService.loadUserByUsername(username);
			String hashedPassword = passwordEncoder.encodePassword(password,null);
			Object details = authentication.getDetails();                            // 사용자 접속 아이피 가져오기 위한 객체 
			String remoteAddress = null;           
			// 사용자 접속 아이피 
			Map xInfo = (Map) user.getExtInfo();
			
			// 원격 접속 아이피 할당 
			if (details instanceof WebAuthenticationDetails) {
	            remoteAddress = ((WebAuthenticationDetails) details).getRemoteAddress(); 
	        }
			
			xInfo.put("userId", username);         // 사용자 이름 
			xInfo.put("userIp", remoteAddress);     // 사용자 접속 아이피 
			xInfo.put("url", loginUrl);              // 접속 url 
			xInfo.put("menuNm", "로그인");            // 접속페이지 이름 
			xInfo.put("orgId", user.getOrgId());            // 메뉴버튼 이름 
			xInfo.put("contractId", user.getContractId());            // 메뉴버튼 이름 
			
			
			if (!hashedPassword.equals(user.getPassword())) {
				throw new BadCredentialsException("비밀번호가 일치하지 않습니다.");
			}
			
			authorities = user.getAuthorities();
			
			if(xInfo.get("contract_id") == null){
				throw new DisabledException("계약이 만료된 아이디입니다.<br/><br/><span>02-6956-7541 이나 sales@openmate-on.co.kr로 <br/>문의해주시기 바랍니다.</span>");	
			}
			
			if(xInfo.get("service_clss") != null && ("2".equals(xInfo.get("service_clss"))  || "4".equals(xInfo.get("service_clss")))){
				throw new DisabledException("계약이 만료된 아이디입니다.<br/><br/><span>02-6956-7541 이나 sales@openmate-on.co.kr로 <br/>문의해주시기 바랍니다.</span>");		
			}
			
			// 계약이 만료됐을때, 오늘이 기간안에 포함되어있지않을 경우
			if((String)xInfo.get("use_str_date") != null && ( ( Integer.parseInt((String)xInfo.get("today")) - Integer.parseInt((String)xInfo.get("use_str_date")) ) < 0 )) {
				throw new DisabledException("사용기간이 아닙니다.<br/><br/><span>02-6956-7541 이나 sales@openmate-on.co.kr로 <br/>문의해주시기 바랍니다.</span>");		
			}
			
			// 계약이 만료됐을때, 오늘이 기간안에 포함되어있지않을 경우
			if(xInfo.get("use_exp_date") != null && ( ( Integer.parseInt((String)xInfo.get("use_exp_date")) - Integer.parseInt((String)xInfo.get("today"))  < 0 ))) {
				throw new DisabledException("계약이 만료된 아이디입니다.<br/><br/><span>02-6956-7541 이나 sales@openmate-on.co.kr로 <br/>문의해주시기 바랍니다.</span>");		
			}
			
//			if("E".equals(xInfo.get("suv_staus_cd"))){
//				throw new DisabledException("계약이 만료된 아이디입니다.<br/><br/><span>02-6956-7541 이나 sales@openmate-on.co.kr로 <br/>문의해주시기 바랍니다.</span>");		
//			}
			
			xInfo.put("logMsg", "로그인 완료");
			loginService.userLoginLogging(xInfo);
			
		} catch (UsernameNotFoundException e) {
			throw new UsernameNotFoundException(e.getMessage());
		} catch (BadCredentialsException e) {
			throw new BadCredentialsException(e.getMessage());
		} catch (DisabledException e) {
			throw new DisabledException(e.getMessage());
		} catch (Exception e) {
			throw new RuntimeException(e.getMessage());
		}
		return new UsernamePasswordAuthenticationToken(user, password, authorities);

	}

	@Override
	public boolean supports(Class<?> authentication) {
		return true;
	}

}
