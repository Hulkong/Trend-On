package com.openmate.onmap.admin.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository(value = "adminDao")
public interface AdminDao {
	
	// 기관현황 페이지 시작
	public int getTotOrgList(Map<String, Object> param);   // 기관 현황 총 목록 개수 조회
	public List<Map<String, Object>> getOrgList(Map<String, Object> param);   // 기관 현황 목록 조회
	// 기관현황 페이지 
	
	// 기관 등록 페이지 시작
	public int checkDupUserId(Map<String, Object> param);            // 유저아이디 중복확인 
	public String getAdmiDistEngNm(Map<String, Object> param);            // 행정구역 영어명 조회 
	public String getOrgIdPk();        					 // 기관 정보 키 가져오기 
	public int setOrg(Map<String, Object> param);        // 기관정보 저장 
	public int deleteOrgRegion(Map<String, Object> param);        // 기관정보 저장 
	public int setOrgRegion(Map<String, Object> param);        // 기관정보 저장 
	public int setContract(Map<String, Object> param);   // 기관에 대한 계약정보 저장 
	public int setAuthority(Map<String, Object> param); // 사용자 권한 저장
	public void removeOrg(Map<String, Object> param); // 사용자 권한 저장
	public void removeContract(Map<String, Object> param); // 사용자 권한 저장
	public void removeAuthority(Map<String, Object> param); // 사용자 권한 저장
	// 기관 등록 페이지 끝
	
	// 기관 수정 페이지 시작 
	public Map<String, Object> getOrg(Map<String, Object> param);   // 기관 수정 데이터 조회
	public List<Map<String, Object>> getOrgImages(Map<String, Object> param);   // 기관 이미지 조회
	public void setAttachFile(Map<String, Object> param);	// 업로드 이미지 저장
	public void updateAttachFile(Map<String, Object> param);	//업로드 이미지 수정
	public Map<String, Object> getOrgImageInfo(String imageKey);   // 기관 이미지 조회
	public int modifiedOrg(Map<String, Object> param);  // 기관 정보 수정
	public List<Map<String, Object>> getContractList(Map<String, Object> param);   // 해당 기관의 계약 데이터 조회 
	public Map<String, Object> getContract(Map<String, Object> param);   // 해당 계약 데이터 조회 
	public List<Map<String, Object>> getOrgSvcStats(Map<String, Object> param);   // 해당 기관 정보 수정 서비스 사용통계 조회
	public int resetOrgPwd(Map<String, Object> param);  // 비밀번호 초기화
	public int modifiedContract(Map<String, Object> param); // 계약정보 수정 (각 계약정보 수정시)
	public int deleteFile(Map<String, Object> param); // 이미지 삭제
	// 기관 수정 페이지 끝  
	
	// 사용신청 현황 페이지 시작
	public int getTotUseApplyList(Map<String, Object> param);
	public Map<String, Object> getApplyDetail(Map<String, Object> param);
	public int modifiedUseApplyUpdt(Map<String, Object> param);
	public int modifiedUseApplyReplyUpdt(Map<String, Object> param);
	public int updateAgreService(Map<String, Object> param); // [ 정기 update ] 계약상태 update
	// 사용신청 현황 페이지 끝
	
	// 사용신청 수정 페이지 시작
	public List<Map<String, Object>> getUseApplyList(Map<String, Object> param);   // 사용신청 리스트 조회 
	public Map<String, Object> getUseApply(Map<String, Object> param);   // 사용신청 수정 데이터 조회
	public List<Map<String, Object>> getExcelUseApplyList(Map<String, Object> param);   // 엑셀 다운로드시 필요한 사용신청 리스트 조회  
	// 사용신청 수정 페이지 끝
	
	// 서비스 사용통계 페이지 시작 
	public int getTotSvcStatsList(Map<String, Object> param);
	public List<Map<String, Object>> getSvcStatsList(Map<String, Object> param);
	public List<Map<String, Object>> getExcelSvcStatsList(Map<String, Object> param);
	// 서비스 사용통계 페이지 끝 
	
	////////////////////////////////////////////////////////////////////////////////////
	// API 현황 페이지 시작
	public int getTotApiList(Map<String, Object> param);   // API 목록 전체 건수 조회
	public List<Map<String, Object>> getApiList(Map<String, Object> param);   // API 목록 조회
	public int getCntAuthInfo(Map<String, Object> param);    // API 정보 건수 조회
	// API 현황 페이지 끝
	////////////////////////////////////////////////////////////////////////////////////
	
	////////////////////////////////////////////////////////////////////////////////////
	// API 수정 페이지 시작
	public int getApiNo(Map<String, Object> param);    // API 기본키 조회
	public Map<String, Object> getApiInfo(Map<String, Object> param);    // API 정보 조회
	public List<Map<String, Object>> getApiRegion(Map<String, Object> param);    // API 지역정보 조회
	public List<Map<String, Object>> getApiDomain(Map<String, Object> param);    // API 도메인 정보 조회
	public void setApiAuth(Map<String, Object> param);	// API 인증키 저장 
	public int setApiInfo(Map<String, Object> param);   // API 인증정보 저장 
	public int setApiRegion(Map<String, Object> param);    // API 지역정보 저장 
	public int modifiedApiAuth(Map<String, Object> param);    // API 인증키 수정
	public int deleteApiAuth(Map<String, Object> param);    // API 인증 삭제
	public int deleteApiInfo(Map<String, Object> param);    // API 인증정보 삭제
	public int deleteApiRegion(Map<String, Object> param);     // API 인증 지역정보 삭제
	// API 수정 페이지 끝
	////////////////////////////////////////////////////////////////////////////////////
	
	// API 서비스 사용통계 시작
	public int getTotApiSvcStatsList(Map<String, Object> param);   // API 사용통계 총건수 조회
	public List<Map<String, Object>> getApiOrgNmList(Map<String, Object> param);  // API가 있는 기관리스트
	public List<Map<String, Object>> getApiSvcStatsList(Map<String, Object> param);   // API 사용통계 조회
	public List<Map<String, Object>> getExcelApiSvcStatsList(Map<String, Object> param);   // API 사용통계 엑셀다운로드 조회
	// API 서비스 사용통계 끝
	
	// org 다중 리스트 조회하기
	public List<Map<String, Object>> getOrgMultiList(HashMap<String, Object> mapArr);
}


