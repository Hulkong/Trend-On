package com.openmate.onmap.admin.web;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.openmate.onmap.admin.dao.AdminDao;
import com.openmate.onmap.admin.service.AdminService;
import com.openmate.onmap.common.dao.CommonDao;
import com.openmate.onmap.common.util.AdminExcel;
import com.openmate.onmap.common.util.FileAPI;
import com.openmate.onmap.common.util.HashAlgorithm;
import com.openmate.onmap.member.service.MemberService;


@Controller
@RequestMapping(value = "/onmap/admin")
public class AdminController {
	
	@Autowired
	FileAPI fileAPI;
	
	@Autowired
	HashAlgorithm hashAlgorithm;
	
	@Value("${config.fileUpload.path}")
	private String fileUploadPath;
	
	@Value("${config.fileUpload.path-url}")
	private String urlUploadPath;
	
	@Resource(name = "commonDao")
	private CommonDao commonDao;
	
	@Resource(name = "adminDao")
	private AdminDao adminDao;
	
	@Resource(name="memberService")
	MemberService memberService;

	@Resource(name="adminService")
	AdminService adminService;
	
	@Value("${config.excelFile.path}")
	private String excelFilePath;
	private String excelFileName = "tempfile";
	
	/**********************************************
	 *  개요 : 관리자 메인 페이지
	 * 	@Method adminMain
	 *  @return
	 **********************************************/
	@RequestMapping(value = "/main.do")
	public String adminMain(){
		return "onmap/admin/main";
	}
	
	/**********************************************
	 *  1. 개요 : 첨부파일 보기
	 *	2. 처리내용 :
	 * 	@Method view
	 *  @param model
	 *  @param req
	 *  @param res
	 *  @throws Exception
	 **********************************************/
//	@RequestMapping(value = "/public_view.do")
//	public ResponseEntity<byte[]> getPublicView(ModelMap model, @RequestParam Map<String, Object> param, HttpServletRequest req, HttpServletResponse res) throws Exception {
//
//		Map<String, Object> map = adminService.getByteImge((String) param.get("imageKey"));
//
//		byte[] imageContent = (byte[]) map.get("image");
//
//		final HttpHeaders headers = new HttpHeaders();
//
//		headers.setContentType(MediaType.IMAGE_JPEG);
//
//		return new ResponseEntity<byte[]>(imageContent, headers, HttpStatus.OK);
//
//	}
	
	/**********************************************
	 *  개요 : 기관 현황 페이지
	 * 	@Method publicList
	 *  @return
	 **********************************************/
	@RequestMapping(value = "/org_list.do")
	public String publicList() {

		return "onmap/admin/org_list";
	}

	/**********************************************
	 *  개요 : 기관 현황 등록 페이지
	 * 	@Method publicRegist
	 *  @return
	 **********************************************/
	@RequestMapping(value = "/org_regist.do")
	public String publicRegist() {
		return "onmap/admin/org_regist";
	}
	
	/**********************************************
	 *  개요 : 기관 수정 페이지
	 * 	@Method publicUpdt
	 *  @return
	 **********************************************/
	@RequestMapping(value = "/org_updt.do")
	public String publicUpdt() {
		
		return "onmap/admin/org_updt";
	}
	
	/**********************************************
	 *  1. 개요 : 기관현황 계약 팝업(추가)
	 *	2. 처리내용 :
	 * 	@Method popContractAdd
	 *  @return
	 **********************************************/
	@RequestMapping(value = "/pop_contract_add.do")
	public String popContractAdd() {

		return "onmap/admin/pop_contract_add";
	}
	
	/**********************************************
	 *  1. 개요 : 기관현황 계약 팝업(수정)
	 *	2. 처리내용 :
	 * 	@Method popContractUpdt
	 *  @return
	 **********************************************/
	@RequestMapping(value = "/pop_contract_updt.do")
	public String popContractUpdt() {
		return "onmap/admin/pop_contract_updt";
	}
	
	/**********************************************
	 *  1. 개요 : 사용신청 리스트
	 *	2. 처리내용 :
	 * 	@Method applyListPage
	 *  @return
	 **********************************************/
	@RequestMapping(value = "/use_apply_list.do")
	public String applyListPage() {
		return "onmap/admin/use_apply_list";
	}
	
	/**********************************************
	 *  1. 개요 : 서비스 사용통계
	 *	2. 처리내용 :
	 * 	@Method getSvcStatsList
	 *  @return
	 **********************************************/
	@RequestMapping(value = "/svc_stats.do")
	public String getSvcStatsList() {
		return "onmap/admin/svc_stats";
	}
	
	/**********************************************
	 *  1. 개요 : API 사용통계
	 *	2. 처리내용 :
	 * 	@Method api_svc_stats
	 *  @return
	 **********************************************/
	@RequestMapping(value = "/api_svc_stats.do")
	public String getApiSvcStatsList() {
		return "onmap/admin/api_svc_stats";
	}
	
	/**********************************************
	 *  개요 : 기관리스트 가져옴 
	 * @Method getOrgList
	 * @param param
	 * @return
	 */
	@RequestMapping(value = "/getOrgList.json")
	@ResponseBody
	public Object getOrgList(@RequestParam Map<String, Object> param) {

		return adminDao.getOrgList(param);
	}
	
	/**********************************************
	 *  개요 : 기관에 대한 계약리스트 가져옴 
	 * @Method getContractList
	 * @param param
	 * @return
	 */
	@RequestMapping(value = "/getContractList.json")
	@ResponseBody
	public Object getContractList(@RequestParam Map<String, Object> param) {
		
		return adminDao.getContractList(param);
	}
	
	/**********************************************
	 *  개요 : 기관 수정 데이터 가져옴 
	 * @Method getOrg
	 * @param param
	 * @return
	 */
	@RequestMapping(value = "/getOrg.json")
	@ResponseBody
	public Object getOrg(@RequestParam Map<String, Object> param) {
		
		return adminDao.getOrg(param);
	}
	
	/**********************************************
	 *  개요 : 기관 수정 데이터 가져옴 
	 * @Method getOrgImages
	 * @param param
	 * @return
	 */
	@RequestMapping(value = "/getOrgImages.json")
	@ResponseBody
	public Object getOrgImages(@RequestParam Map<String, Object> param) {
		
		return adminDao.getOrgImages(param);
	}
	
	/**********************************************
	 *  개요 : 기관리스트 총 건수 가져옴 
	 * @Method getTotOrgList
	 * @param param
	 * @return
	 */
	@RequestMapping(value = "/getTotOrgList.json")
	@ResponseBody
	public Object getTotOrgList(@RequestParam Map<String, Object> param) {
		
		return adminDao.getTotOrgList(param);
	}
	
	/**********************************************
	 * 개요 : 시군구, 시도 리스트 가져옴 
	 * @Method getAreaSelectOption
	 * @param param
	 * @return
	 */
	@RequestMapping(value = "/getAreaSelectOption.json")
	@ResponseBody
	public Object getAreaSelectOption(@RequestParam Map<String, Object> param) {
		
		return commonDao.getAreaSelectOption(param); //시군구 조회
	}
	
	/**********************************************
	 * 개요 : 공통코드에 대한 리스트 가져옴
	 * @Method getCommonCodeList
	 * @param param
	 * @return
	 */
	@RequestMapping(value = "/getCommonCodeList.json")
	@ResponseBody
	public Object getCommonCodeList(@RequestParam Map<String, Object> param) {
		
		return commonDao.getCommonCodeList(param); 
	}
	
	/**********************************************
	 * 개요 : 해당 기관에 대한 계약정보 가져옴
	 * @Method getContract
	 * @param param
	 * @return
	 */
	@RequestMapping(value = "/getContract.json")
	@ResponseBody
	public Object getContract(@RequestParam Map<String, Object> param) {
		
		return adminDao.getContract(param); 
	}
	
	/**********************************************
	 * 개요 : 해당 기관 정보 수정 서비스 사용통계 조회
	 * @Method getOrgSvcStats
	 * @param param
	 * @return
	 */
	@RequestMapping(value = "/getOrgSvcStats.json")
	@ResponseBody
	public Object getOrgSvcStats(@RequestParam Map<String, Object> param) {
		
		return adminDao.getOrgSvcStats(param); 
	}
	
	/**********************************************
	 * 개요 : 사용신청 리스트 가져옴
	 * @Method getUseApplyList
	 * @param param
	 * @return
	 */
	@RequestMapping(value = "/getUseApplyList.json")
	@ResponseBody
	public Object getUseApplyList(@RequestParam Map<String, Object> param) {
		
		return adminDao.getUseApplyList(param); 
	}
	
	/**********************************************
	 * 개요 : 사용신청 리스트 총건수 가져옴
	 * @Method getTotUseApplyList
	 * @param param
	 * @return
	 */
	@RequestMapping(value = "/getTotUseApplyList.json")
	@ResponseBody
	public Object getTotUseApplyList(@RequestParam Map<String, Object> param) {
		
		return adminDao.getTotUseApplyList(param); 
	}
	
	/**********************************************
	 * 개요 : 사용신청 수정 데이터 가져옴
	 * @Method getTotUseApplyList
	 * @param param
	 * @return
	 */
	@RequestMapping(value = "/getUseApply.json")
	@ResponseBody
	public Object getUseApply(@RequestParam Map<String, Object> param) {
		
		return adminDao.getUseApply(param); 
	}
	
	/**********************************************
	 * 개요 : 서비스 사용통계 총건수 가져옴
	 * @Method getTotSvcStatsList
	 * @param param
	 * @return
	 */
	@RequestMapping(value = "/getTotSvcStatsList.json")
	@ResponseBody
	public Object getTotSvcStatsList(@RequestParam Map<String, Object> param) {
		
		return adminDao.getTotSvcStatsList(param); 
	}
	
	/**********************************************
	 * 개요 : 서비스 사용통계 데이터 가져오는 함수
	 * @Method getSvcStatsList
	 * @param param
	 * @return
	 */
	@RequestMapping(value = "/getSvcStatsList.json")
	@ResponseBody
	public Object getSvcStatsList(@RequestParam Map<String, Object> param) {
		
		return adminDao.getSvcStatsList(param); 
	}
	/**********************************************
	 * 개요 : API 기본키 조회
	 * @Method getApiNo
	 * @param param
	 * @return
	 */
	@RequestMapping(value = "/getApiNo.json")
	@ResponseBody
	public Object getApiNo(@RequestParam Map<String, Object> param) {
		
		return adminDao.getApiNo(param); 
	}
	/**********************************************
	 * 개요 : API 정보 조회
	 * @Method getApiInfo
	 * @param param
	 * @return
	 */
	@RequestMapping(value = "/getApiInfo.json")
	@ResponseBody
	public Object getApiInfo(@RequestParam Map<String, Object> param) {
		
		return adminDao.getApiInfo(param); 
	}
	
	/**********************************************
	 * 개요 : API 도메인 정보 조회
	 * @Method getApiDomain
	 * @param param
	 * @return
	 */
	@RequestMapping(value = "/getApiDomain.json")
	@ResponseBody
	public Object getApiDomain(@RequestParam Map<String, Object> param) {
		
		return adminDao.getApiDomain(param); 
	}
	
	/**********************************************
	 * 개요 : API 지역 정보 조회
	 * @Method getApiRegion
	 * @param param
	 * @return
	 */
	@RequestMapping(value = "/getApiRegion.json")
	@ResponseBody
	public Object getApiRegion(@RequestParam Map<String, Object> param) {
		
		return adminDao.getApiRegion(param); 
	}
	
	/**********************************************
	 * 개요 : API가 있는 기관리스트 조회
	 * @Method getApiOrgNmList
	 * @param param
	 * @return
	 */
	@RequestMapping(value = "/getApiOrgNmList.json")
	@ResponseBody
	public Object getApiOrgNmList(@RequestParam Map<String, Object> param) {
		
		return adminDao.getApiOrgNmList(param); 
	}
	
	/**********************************************
	 * 개요 : API 사용통계 총건수 조회
	 * @Method getTotApiSvcStatsList
	 * @param param
	 * @return
	 */
	@RequestMapping(value = "/getTotApiSvcStatsList.json")
	@ResponseBody
	public Object getTotApiSvcStatsList(@RequestParam Map<String, Object> param) {
		
		return adminDao.getTotApiSvcStatsList(param); 
	}
	
	/**********************************************
	 * 개요 :API 사용통계 조회
	 * @Method getApiOrgNmList
	 * @param param
	 * @return
	 */
	@RequestMapping(value = "/getApiSvcStatsList.json")
	@ResponseBody
	public Object getApiSvcStatsList(@RequestParam Map<String, Object> param) {
		
		return adminDao.getApiSvcStatsList(param); 
	}
	/**********************************************
	 * 개요 : API 목록 전체 건수 조회
	 * @Method getTotApiList
	 * @param param
	 * @return
	 */
	@RequestMapping(value = "/getTotApiList.json")
	@ResponseBody
	public Object getTotApiList(@RequestParam Map<String, Object> param) {
		
		return adminDao.getTotApiList(param); 
	}
	/**********************************************
	 * 개요 : API 목록 조회
	 * @Method getApiList
	 * @param param
	 * @return
	 */
	@RequestMapping(value = "/getApiList.json")
	@ResponseBody
	public Object getApiList(@RequestParam Map<String, Object> param) {
		
		return adminDao.getApiList(param); 
	}
	
	/**********************************************
	 *  1. 개요 : 기관/계약 등록 
	 *	2. 처리내용 :
	 * 	@Method setOrgContract
	 *  @param param
	 *  @return
	 **********************************************/
	@RequestMapping(value = "/setOrgContract.json")
	@ResponseBody
	public Object setOrgContract(  @RequestParam Map<String, Object> param
								 , @RequestParam(value = "imgFile1", required = false) MultipartFile file1
								 , @RequestParam(value = "imgFile2", required = false) MultipartFile file2) {
	
		Map<String, Object> rte = new HashMap<String, Object>();
		int success = 0;
		
		try {
			param.put("file1",file1);
			param.put("file2",file2);
			success = adminService.setOrgContract(param);
			
			if(success > 0) {
				rte.put("resultMsg", "success of insertion to table");
				rte.put("resultCode", 1);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			rte.put("resultMsg", "failed of insertion to table");
			rte.put("resultCode", 0);
			
			// 기관정보 테이블에 데이터가 삽입된 경우
			if(param.get("orgId") != null) {
				adminDao.removeOrg(param);
				adminDao.removeContract(param);
				adminDao.removeAuthority(param);
			}
		}
		
		return rte;
	}
	
	/**********************************************
	 *  1. 개요 : 기관등록에 대한 권한 생성
	 *	2. 처리내용 :
	 * 	@Method setOrgContract
	 *  @param param
	 *  @return
	 **********************************************/
	@RequestMapping(value = "/setAuthority.json")
	@ResponseBody
	public Object setAuthority(@RequestParam Map<String, Object> param) {
		
		Map<String, Object> rte = new HashMap<String, Object>();
		int success = 0;
		
		rte.put("resultMsg", "failure of insertion to TBCOM_AUTHORITY_BAK table");
		rte.put("resultCode", 0);		
		
		success = adminDao.setAuthority(param);
		
		if(success > 0) {
			rte.put("resultMsg", "success of insertion to TBCOM_AUTHORITY_BAK table");
			rte.put("resultCode", 1);
		}
		
		return rte;
	}
	
	/**********************************************
	 *  1. 개요 : 기관수정 페이지 > 이미지 삭제 기능
	 *	2. 처리내용 :	bg혹은 sg 이미지 삭제 처리
	 * 	@Method setOrgContract
	 *  @param param
	 *  @return
	 **********************************************/
	@RequestMapping(value = "/delOrgImage.json")
	@ResponseBody
	public Object delOrgImage(@RequestParam Map<String, Object> param) {
		
		Map<String, Object> rte = new HashMap<String, Object>();
		int success = 0;
		
		rte.put("resultMsg", "failure of insertion to TBCOM_IMAGES table");
		rte.put("resultCode", 0);		
		
		success = adminService.delOrgImage(param);
		
		if(success > 0) {
			rte.put("resultMsg", "success of insertion to TBCOM_IMAGES table");
			rte.put("resultCode", 1);
		}else if(success < 0 ){
			rte.put("resultMsg", "이미지가 존재하지않습니다.");
			rte.put("resultCode", -1);			
		}
		
		return rte;
	}
	
	/**********************************************
	 *  1. 개요 : 기관 수정 
	 *	2. 처리내용 :
	 * 	@Method modifiedOrg
	 *  @param param
	 *  @return
	 **********************************************/
	@RequestMapping(value = "/modifiedOrg.json", method = RequestMethod.POST)
	@ResponseBody
	public Object modifiedOrg( @RequestParam Map<String, Object> param
							 , @RequestParam(value = "imgFile1", required = false) MultipartFile file1
							 , @RequestParam(value = "imgFile2", required = false) MultipartFile file2) {
		
		Map<String, Object> rte = new HashMap<String, Object>();
		int success = 0;
		
		rte.put("resultMsg", "failure of modified to TBCOM_ORG_BAK table");
		rte.put("resultCode", 0);		
		
		try{
			
			param.put("file1",file1);
			param.put("file2",file2);
			success = adminService.modifiedOrg(param);
			
			//success = adminDao.modifiedOrg(param);
			
		}catch(Exception e){
			e.printStackTrace();
		}

		
		if(success > 0) {
			rte.put("resultMsg", "success of modified to TBCOM_ORG_BAK table");
			rte.put("resultCode", 1);
		}
		
		return rte;
	}
	
	/**********************************************
	 *  1. 개요 : 비밀번호 초기화 
	 *	2. 처리내용 :
	 * 	@Method initOrgPwd
	 *  @param param
	 *  @return
	 **********************************************/
	@RequestMapping(value = "/resetOrgPwd.json")
	@ResponseBody
	public Object initOrgPwd(@RequestParam Map<String, Object> param) {
		
		Map<String, Object> rte = new HashMap<String, Object>();
		int success = 0;
		
		rte.put("resultMsg", "failure of reset password");
		rte.put("resultCode", 0);		
		
		success = adminDao.resetOrgPwd(param);
		
		if(success > 0) {
			rte.put("resultMsg", "success of reset password");
			rte.put("resultCode", 1);
		}
		
		return rte;
	}

	/**********************************************
	 *  1. 개요 : 기관/계약 등록 
	 *	2. 처리내용 :
	 * 	@Method setOrgContract
	 *  @param param
	 *  @return
	 **********************************************/
	@RequestMapping(value = "/setContract.json")
	@ResponseBody
	public Object setContract(@RequestParam Map<String, Object> param) {
	
		Map<String, Object> rte = new HashMap<String, Object>();
		int success = 0;
		
		rte.put("resultMsg", "failure of insertion to TBCOM_CONTRACT_BAK table");
		rte.put("resultCode", 0);		
		
		success = adminDao.setContract(param);
			
		if(success > 0) {
			rte.put("resultMsg", "success of insertion to TBCOM_CONTRACT_BAK table");
			rte.put("resultCode", 1);
			rte.put("contractId", param.get("contractId"));
		}
		
		return rte;
	}
	
	/**********************************************
	 *  1. 개요 : 기관/계약 수정 
	 *	2. 처리내용 :
	 * 	@Method modifiedContract
	 *  @param param
	 *  @return
	 **********************************************/
	@RequestMapping(value = "/modifiedContract.json")
	@ResponseBody
	public Object modifiedContract(@RequestParam Map<String, Object> param) {
		
		Map<String, Object> rte = new HashMap<String, Object>();
		int success = 0;
		
		rte.put("resultMsg", "failure of modified to TBCOM_CONTRACT_BAK table");
		rte.put("resultCode", 0);		
		
		success = adminDao.modifiedContract(param);
		
		if(success > 0) {
			rte.put("resultMsg", "success of modified to TBCOM_CONTRACT_BAK table");
			rte.put("resultCode", 1);
		}
		
		return rte;
	}
	
	/**********************************************
	 *  1. 개요 : 기관/계약 수정 
	 *	2. 처리내용 :
	 * 	@Method modifiedContract
	 *  @param param
	 *  @return
	 **********************************************/
	@RequestMapping(value = "/sendServiceGuide.json")
	@ResponseBody
	public Object sendServiceGuide(@RequestParam Map<String, Object> param) {
		
		Map<String, Object> rte = new HashMap<String, Object>();
		
		rte.put("resultMsg", "Email sent successfully");
		rte.put("resultCode", 1);
		
		try {			
			memberService.serviceGuide(param);
		} catch(Exception e){
			e.printStackTrace();
			rte.put("resultMsg", "Email failed to send");
			rte.put("resultCode", 0);
		}
		
		return rte;
	}
	
	/**********************************************
	 *  1. 개요 : 사용신청서 정보 수정 
	 *	2. 처리내용 :
	 * 	@Method modifiedUseApplyUpdt
	 *  @param param
	 *  @return
	 **********************************************/
	@RequestMapping(value = "/modifiedUseApplyUpdt.json")
	@ResponseBody
	public Object modifiedUseApplyUpdt(@RequestParam Map<String, Object> param) {
		
		Map<String, Object> rte = new HashMap<String, Object>();
		int success = 0;
		
		rte.put("resultMsg", "failure of modified to TBCOM_APPLY_BAK table");
		rte.put("resultCode", 0);		
		
		success = adminDao.modifiedUseApplyUpdt(param);
		
		if(success > 0) {
			rte.put("resultMsg", "success of modified to TBCOM_APPLY_BAK table");
			rte.put("resultCode", 1);
		}
		
		return rte;
	}
	
	/**********************************************
	 *  1. 개요 : 사용신청서 답변 수정 
	 *	2. 처리내용 :
	 * 	@Method modifiedUseApplyReplyUpdt
	 *  @param param
	 *  @return
	 **********************************************/
	@RequestMapping(value = "/modifiedUseApplyReplyUpdt.json")
	@ResponseBody
	public Object modifiedUseApplyReplyUpdt(@RequestParam Map<String, Object> param) {
		
		Map<String, Object> rte = new HashMap<String, Object>();
		int success = 0;
		
		rte.put("resultMsg", "failure of modified to TBCOM_APPLY_BAK table");
		rte.put("resultCode", 0);		
		
		success = adminDao.modifiedUseApplyReplyUpdt(param);
		
		if(success > 0) {
			rte.put("resultMsg", "success of modified to TBCOM_APPLY_BAK table");
			rte.put("resultCode", 1);
		}
		
		return rte;
	}
	
	/**********************************************
	 *  1. 개요 : 사용신청 수정
	 *	2. 처리내용 :
	 * 	@Method use_apply_updt
	 *  @return
	 **********************************************/
	@RequestMapping(value = "/use_apply_updt.do")
	public String applyUpdtPage() {
		return "onmap/admin/use_apply_updt";
	}

	/**********************************************
	 *  1. 개요 : 유저아이디 중복확인 
	 *	2. 처리내용 :
	 * 	@Method checkDupUserId
	 *  @param param
	 *  @return
	 **********************************************/
	@RequestMapping(value = "/checkDupUserId.json")
	@ResponseBody
	public boolean checkDupUserId(@RequestParam Map<String, Object> param) {

		boolean check = false;
		int searchCnt = adminDao.checkDupUserId(param);
		
		if(searchCnt > 0) {
			check = true;
		}

		return check;
	}
	
	/**********************************************
	 *  1. 개요 : 행정구역 영어명 조회 
	 *	2. 처리내용 :
	 * 	@Method getAdmiDistEngNm
	 *  @param param
	 *  @return
	 **********************************************/
	@RequestMapping(value = "/getAdmiDistEngNm.json")
	@ResponseBody
	public Object getAdmiDistEngNm(@RequestParam Map<String, Object> param) {
		
		Map<String, Object> rte = new HashMap<String, Object>();
		String admiDistEngNm = adminDao.getAdmiDistEngNm(param);
		rte.put("admiDistEngNm", admiDistEngNm);
		return rte;
	}
	
	/**********************************************
	 *  1. 개요 : API 인증키 생성
	 *	2. 수정자 : 김용현
	 *  3. 수정일자 : 2018.04.24 
	 * 	@Method createAuthKey
	 *  @param param(String orgId)
	 *  @return authKey
	 **********************************************/
	@RequestMapping(value = "/createAuthKey.json")
	@ResponseBody
	public Object createAuthKey(@RequestParam Map<String, Object> param) {
		String orgId = (String) param.get("orgId");    // 기관번호
		String contractId = (String) param.get("contractId");    // 기관번호
		String inputText = orgId + contractId;    // 해쉬함수를 통한 인증키 생성시 필요한 INPUT값
		
		return hashAlgorithm.getEncSHA256(inputText);    // API 인증키 생성
	}
	
	/**********************************************
	 *  1. 개요 : API 신청양식(추가)
	 *	2. 수정자 : 김용현
	 *  3. 수정일자 : 2018.05.08 
	 * 	@Method popApiView
	 **********************************************/
	@RequestMapping(value = "/pop_api.do")
	public String popApiView() {
		return "onmap/admin/pop_api";
	}
	
	/**********************************************
	 *  1. 개요 : API 등록
	 *	2. 수정자 : 김용현
	 *  3. 수정일자 : 2018.04.19 
	 * 	@Method popApiRegist
	 *  @param param(String orgId, String publicSeq, String apiNm, String apiDesc, String domain, String ctyCd)
	 *  @return resultMsg
	 **********************************************/
	@RequestMapping(value = "/pop_api_regist.json")
	@ResponseBody
	public Object popApiRegist(@RequestParam Map<String, Object> param) {
		String orgId = (String) param.get("orgId");    // 기관번호
		String contractId = (String) param.get("contractId");  // 기관 계약 번호
		String domains = (String) param.get("domains");     // 도메인
		String ctyCds = (String) param.get("ctyCds");     // 도메인
		int cnt = 0;
		
		Map<String, Object> rte = new HashMap<String, Object>();           // 리턴정보
		
		String inputText = orgId + contractId;    // 해쉬함수를 통한 인증키 생성시 필요한 INPUT값
		String apiKey = hashAlgorithm.getEncSHA256(inputText);    // API 인증키 생성
		
		// TBCOM_API 테이블에 데이터 저장할 파라미터 세팅 
		param.put("apiKey", apiKey);
		
		adminDao.setApiAuth(param);
		
		// TBCOM_API_INFO 테이블에 데이터 저장할 파라미터 세팅
		String[] splitDomains = domains.split(",");
		
		// 여러개의 도메인 및 ip별로 테이블에 저장
		for(String domain : splitDomains) {
			param.put("apiDomain", domain);
			adminDao.setApiInfo(param);
		}
		
		String[] splitCtyCds = ctyCds.split(",");
		
		
		// 여러개의 지역코드별로 테이블에 저장
		for(String ctyCd : splitCtyCds) {
			param.put("rgnId", ctyCd);
			cnt = adminDao.setApiRegion(param);
		}

		// 삽입결과의 정상여부에 따른 메시지 처리
		if(0 != cnt) {
			rte.put("apiKey", apiKey);
			rte.put("resultMsg", "ok");
		} else {
			rte.put("resultMsg", "error");
		}
		
		return rte;
	}
	
	/**********************************************
	 *  1. 개요 : API 수정
	 *	2. 수정자 : 김용현
	 *  3. 수정일자 : 2018.04.19 
	 * 	@Method popApiUpdate
	 *  @param param(String orgId, String publicSeq, String apiNm, String apiDesc, String domain, String ctyCd)
	 *  @return resultMsg
	 **********************************************/
	@RequestMapping(value = "/pop_api_update.json")
	@ResponseBody
	public Object popApiUpdate(@RequestParam Map<String, Object> param) {
		String domains = (String) param.get("domains");     // 도메인
		String ctyCds = (String) param.get("ctyCds");          // 행정동코드
		int cnt = 0;
		Map<String, Object> rte = new HashMap<String, Object>();           // 리턴정보
		
		// TBCOM_API 테이블에 데이터 수정할 파라미터 세팅 
		adminDao.modifiedApiAuth(param);
		
		// TBCOM_API_INFO 테이블에 데이터 저장할 파라미터 세팅
		int apiNo = adminDao.getApiNo(param);
		
		param.put("apiNo", apiNo);
		
		adminDao.deleteApiInfo(param);
		
		String[] splitDomains = domains.split(",");
		
		// 여러개의 도메인 및 ip별로 테이블에 저장
		for(String domain : splitDomains) {
			param.put("apiDomain", domain);
			adminDao.setApiInfo(param);
		}
		
		// TBCOM_API_REGION 테이블에 데이터 저장할 파라미터 세팅
		adminDao.deleteApiRegion(param);
		
		String[] splitCtyCds = ctyCds.split(",");
		
		// 여러개의 지역코드별로 테이블에 저장
		for(String ctyCd : splitCtyCds) {
			param.put("rgnId", ctyCd);
			cnt = adminDao.setApiRegion(param);
		}

		// 삽입결과의 정상여부에 따른 메시지 처리
		if(0 != cnt) {
			rte.put("resultMsg", "ok");
		} else {
			rte.put("resultMsg", "error");
		}
		
		return rte;
	}
	
	/**********************************************
	 *  1. 개요 : API 삭제
	 *	2. 수정자 : 김용현
	 *  3. 수정일자 : 2018.04.19 
	 * 	@Method popApiDelete
	 *  @param param(String orgId, String publicSeq)
	 *  @return resultMsg
	 **********************************************/
	@RequestMapping(value = "/pop_api_delete.json")
	@ResponseBody
	public Object popApiDelete(@RequestParam Map<String, Object> param) {
		Map<String, Object> rte = new HashMap<String, Object>();           // 리턴정보
		
		adminDao.deleteApiAuth(param);
		adminDao.deleteApiInfo(param);
		int cnt = adminDao.deleteApiRegion(param);
		
		// 삭제결과의 정상여부에 따른 메시지 처리
		if(0 != cnt) {
			rte.put("resultMsg", "ok");
		} else {
			rte.put("resultMsg", "error");
		}
		
		return rte;
	}
	
	/**********************************************
	 *  1. 개요 : API 정보 목록 조회
	 *	2. 처리내용 :
	 * 	@Method publicApiListPage
	 *  @return
	 **********************************************/
	@RequestMapping(value = "/api_list.do")
	public String publicApiListPage() {
		return "onmap/admin/api_list";
	}
	
	@RequestMapping(value = "/makeExcelSvcStats.json")
	@ResponseBody
	public Object makeExcel(@RequestParam Map<String, Object> param) {

		Map<String, Object> rte = new HashMap<String, Object>();

		Date d = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss", Locale.KOREA);

		//실제  디렉토리
		String realDir = excelFilePath;
		String fileName = excelFileName+sdf.format(d)+".xlsx";

		try{
			List<Map<String, Object>> list = adminDao.getExcelSvcStatsList(param);

			AdminExcel.makeExcelSvcStats(realDir, fileName, list);
			rte.put("resultCnt", 1);

		}catch(Exception e){
			e.printStackTrace();
			rte.put("resultCnt", 0);
		}

		rte.put("fileName", fileName);

		return rte;
	}

	@RequestMapping(value = "/makeApiExcel.json")
	@ResponseBody
	public Object makeApiExcel(@RequestParam Map<String, Object> param) throws Exception {

		Map<String, Object> rte = new HashMap<String, Object>();

		Date d = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss", Locale.KOREA);

		//실제  디렉토리
		String realDir = excelFilePath;
		String fileName = excelFileName+sdf.format(d)+".xlsx";

		try{
			List<Map<String, Object>> list = adminDao.getExcelApiSvcStatsList(param);

			AdminExcel.makeApiExcelFile(realDir, fileName, list);
			rte.put("resultCnt", 1);

		}catch(Exception e){
			e.printStackTrace();
			rte.put("resultCnt", 0);
		}

		rte.put("fileName", fileName);

		return rte;
	}
	
	@RequestMapping(value = "/makeExcelUseApply.json")
	@ResponseBody
	public Object makeExcelUseApply(ModelMap model, @RequestParam Map<String, Object> param, HttpServletRequest req, HttpServletResponse res) throws Exception {
		
		Map<String, Object> rte = new HashMap<String, Object>();
		
		Date d = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss", Locale.KOREA);
		
		//실제  디렉토리
		String realDir = excelFilePath;
		String fileName = excelFileName+sdf.format(d)+".xlsx";
		
		try{
			List<Map<String, Object>> list = adminDao.getExcelUseApplyList(param);
			AdminExcel.makeExcelUseApplyFile(realDir, fileName, list);
			rte.put("resultCnt", 1);
			
		}catch(Exception e){
			e.printStackTrace();
			rte.put("resultCnt", 0);
		}
		
		rte.put("fileName", fileName);
		
		return rte;
	}
}
