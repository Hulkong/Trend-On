package com.openmate.onmap.member.web;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.bouncycastle.asn1.x509.qualified.TypeOfBiometricData;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.openmate.frmwrk.user.User;
import com.openmate.onmap.admin.dao.AdminDao;
import com.openmate.onmap.member.dao.MemberDao;
import com.openmate.onmap.member.service.MemberService;

@Controller
@RequestMapping(value = "/onmap/member")
public class MemberController {

	@Resource(name="memberService")
	MemberService memberService;
	
	@Resource(name="memberDao")
	MemberDao memberDao;
	
	@Resource(name = "adminDao")
	private AdminDao adminDao;
	
	/**********************************************
	 *  1. 개요 : 회원가입 페이지로 이동
	 *	2. 처리내용 :
	 * 	@Method goJoinForm
	 *  @param req
	 *  @param res
	 *  @return
	 **********************************************/
	@RequestMapping(value="/{pageUrl}.do")
	public String goJoinForm( HttpServletRequest req, HttpServletResponse res
							, Model model
							, @RequestParam Map<String,Object> param 
							, @PathVariable String pageUrl ){
		
		model.addAllAttributes(param);
		return "cctv/member/"+pageUrl;
	}
	
	/**********************************************
	 *  1. 개요 : 아이디 비밀번호 찾기
	 *	2. 처리내용 :
	 * 	@Method getMemberIdPwd
	 *  @param req
	 *  @param res
	 *  @return
	 **********************************************/
	@RequestMapping(value="/getMemberIdPwd.json")
	@ResponseBody
	public String getMemberIdPwd( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String,Object> param ){
		
		String data = memberService.getMemberIdPwd(param);
		return data;
	}
	
	/**********************************************
	 *  1. 개요 : 비밀번호 재설정
	 *	2. 처리내용 :
	 * 	@Method resetPassword
	 *  @param req
	 *  @param res
	 *  @return
	 **********************************************/
	@RequestMapping(value="/resetPassword.json")
	@ResponseBody
	public int resetPassword( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String,Object> param ){
		
		int data = memberService.resetPassword(param);
		return data;
	}
	
	/**********************************************
	 *  1. 개요 : 비밀번호 변경
	 *	2. 처리내용 :
	 * 	@Method updatePassword
	 *  @param req
	 *  @param res
	 *  @return
	 **********************************************/
	@RequestMapping(value="/updatePassword.json")
	@ResponseBody
	public Map<String, Object> updatePassword( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String,Object> param ){
		return memberService.updatePassword(param);
	}

	/**********************************************
	 *  1. 개요 : 테스트 사용신청서
	 *	2. 처리내용 : 테스트 사용신청서 
	 *            
	 * 	@Method useApplyProc
	 *  @param req
	 *  @param res
	 *  @return
	 **********************************************/
	@RequestMapping(value="/useApplyProc.json", method = RequestMethod.POST )
	@ResponseBody
	public int useApplyProc( HttpServletRequest req, HttpServletResponse res
			, @RequestParam Map<String,Object> param ){
		
		int result = 0;
		try {			
			result = memberService.useApply(param);
		}
		catch(Exception e){
			e.printStackTrace();
			result = -1;
		}
		
		return result;
		
	}

	/**********************************************
	 *  1. 개요 : 화면 지역변경(관리자) 
	 *            
	 * 	@Method tempSetCty
	 *  @param Authentication
	 *  @return Map
	 **********************************************/
	@RequestMapping(value = "/tmp-set-cty.json")
	@ResponseBody
	public Object tempSetCty(Authentication authentication
			, @RequestParam(value = "cty_cd") String ctyCd
			, @RequestParam(value = "cty_nm") String ctyNm
			, @RequestParam(value = "mega_cd") String megaCd
			, @RequestParam(value = "mega_nm") String megaNm
			) throws Exception {
		
		User nnr = (User) authentication.getPrincipal();
		Map info = (HashMap)nnr.getExtInfo();
		
		
		// db에서 가져온 값
		Map<String, Object> orgList = (HashMap)adminDao.getOrg(info);
		String megaList =  (String) orgList.get("mega_list");
		String ctyList =  (String) orgList.get("cty_list");
		String[] megaArray = megaList.split(",");
		String[] ctyArray = ctyList.split(",");
		
		
		// 일치x 기본값
		int count = 1;
		
		for(String x : ctyArray) {
			if( (ctyCd.substring(0, 2)+"000").equals(x) ) {
				count = 0;
				break;
			} else if( ctyCd.equals(x) ) {
				count = 0;
				break;
			} 
		}
		
		Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities(); 
		Iterator<? extends GrantedAuthority> iter = authorities.iterator();
		
		boolean isAdmin = false;
		while (iter.hasNext()) { 
			GrantedAuthority auth = iter.next(); 
			if(auth.getAuthority().equals("ROLE_ADMIN")) {
				isAdmin = true; 
			}
		}
		
		if( isAdmin ||  count == 0) { 
			// 일치 하는게 있을 때  
			info.put("cty_cd", ctyCd);
			info.put("cty_nm", ctyNm);
			info.put("mega_cd", megaCd);
			info.put("mega_nm", megaNm);
		} else {
			// 일치하는게 없어서 어떤값으로 대체
			info.put("cty_cd", ctyArray[0]);
			info.put("cty_nm", ctyNm);
			info.put("mega_cd", megaArray[0]);
			info.put("mega_nm", megaNm);
			
				
		}
		
		return info;
	}
	
	
	/**********************************************
	 *  1. 개요 : 화면 지역 선택 (유저) 
	 *            
	 * 	@Method getMega
	 *  @param Authentication
	 *  @return Map
	 **********************************************/
	@RequestMapping(value = "/getMega.json")
	@ResponseBody
	public Object getMega(Authentication authentication) throws Exception {
		
		User nnr = (User) authentication.getPrincipal();
		Map info = (HashMap)nnr.getExtInfo();
		
		// 계약된 mega_list구하기
		Map<String, Object> orgList = (HashMap)adminDao.getOrg(info);
		HashMap<String, Object> mapArr = new HashMap<String, Object>();
		
		String megaList =  (String) orgList.get("mega_list");
		String ctyList =  (String) orgList.get("cty_list");
		String[] megaArray = megaList.split(",");
		String[] ctyArray = ctyList.split(",");

		// mega_list 조회
		mapArr.put("orgArray", megaArray);
		mapArr.put("rgnClss", "H1");
		List<Map<String, Object>> orgMultiList = adminDao.getOrgMultiList(mapArr);
		info.put("mega_list", orgMultiList);
		
		// cty_list 조회
		mapArr.put("orgArray", ctyArray);
		mapArr.put("rgnClss", "H3");
		List<Map<String, Object>> orgCtyMultiList = adminDao.getOrgMultiList(mapArr);
		info.put("cty_list", orgCtyMultiList);
		
		// ctyArray안에 000으로 끝나는 게 있으면 뺴기
		// ctyArray 중에서 000으로 끝나면 조회해서 전체를 넣고 아니면 그대로 넣어서 리스트 만들기
		List<Map<String, Object>> ctyListAll1 = new ArrayList<Map<String,Object>>();
		
		for(String x : ctyArray) {
			//   
			if( x.length() == 5 && x.substring(2, 5).equals("000")) {
				mapArr.put("parentId", x.substring(0, 2));
				mapArr.remove("orgArray");
				ctyListAll1.addAll(adminDao.getOrgMultiList(mapArr));
			} else {
				mapArr.put("parentId", null);
				mapArr.put("orgArray", null);
				mapArr.put("id", x);
				ctyListAll1.addAll(adminDao.getOrgMultiList(mapArr));
			}
		}   
		info.put("cty_list", ctyListAll1);
		
		// 첫번째 값이 전체이면
		String infoCtyCd = (String) info.get("cty_cd");
		if( infoCtyCd.length() == 5 && infoCtyCd.substring(2, 5).equals("000") ) {
			List<Map<String, Object>> ctyListInfo = (List<Map<String, Object>>) info.get("cty_list");
			info.put("cty_cd", ctyListInfo.get(0).get("id"));
		}
		
		return info;
	}
	
}
