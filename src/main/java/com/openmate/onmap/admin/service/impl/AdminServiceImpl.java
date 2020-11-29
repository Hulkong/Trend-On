package com.openmate.onmap.admin.service.impl;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.openmate.onmap.admin.dao.AdminDao;
import com.openmate.onmap.admin.service.AdminService;
import com.openmate.onmap.common.dao.CommonDao;
import com.openmate.onmap.common.util.FileAPI;
import com.openmate.onmap.common.util.HashAlgorithm;

@Service("adminService")
public class AdminServiceImpl implements AdminService{

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
	
	/**
	 * 기관 정보 수정
	 */
	public int modifiedOrg(Map<String,Object> param){
		int result = 0;
		
		MultipartFile file1 = (MultipartFile)param.get("file1");
		MultipartFile file2 = (MultipartFile)param.get("file2");		
		String orgId = (String)param.get("orgId");
		String pastFile1 = (String)param.get("pastFile1");
		String pastFile2 = (String)param.get("pastFile2");
		
		// 첨부파일 저장
		if(file1 != null && !file1.isEmpty()){
			
			// 기존에 등록한 파일이 있는 지 확인
			if(pastFile1 != null && !pastFile1.equals("")){
				Map<String,Object> fileInfo = adminDao.getOrgImageInfo(pastFile1);
				fileAPI.deleteFile((String) fileInfo.get("path"), (String) fileInfo.get("new_name"));
			}
			
			saveFile(file1, orgId, "bg", pastFile1);
		}
		if(file2 != null && !file2.isEmpty()){
			
			// 기존에 등록한 파일이 있는 지 확인
			if(pastFile2 != null && !pastFile2.equals("")){
				Map<String,Object> fileInfo = adminDao.getOrgImageInfo(pastFile2);
				fileAPI.deleteFile((String) fileInfo.get("path"), (String) fileInfo.get("new_name"));
				
			}
			
			saveFile(file2, orgId, "sg", pastFile2);
		}
		
//		System.out.println("param :::::::::::::::::::: " + param);
//		System.out.println("orgId :::::::::::::::::::: " + param.get("orgId"));
		
		result = adminDao.modifiedOrg(param);
		
		// 서비스 지역 처리
		String megaArr = (String) param.get("megaArr");
		String cityArr = (String) param.get("cityArr");
		
		String[] megaSplitArr = megaArr.split(","); 
		String[] citySplitArr = cityArr.split(","); 
		
		// 기존꺼 삭제
		result = adminDao.deleteOrgRegion(param);
		
		for(int i = 0; i < citySplitArr.length; i++) {
			
			param.put("megaCd", citySplitArr[i].substring(0, 2));
			param.put("ctyCd", citySplitArr[i]);
			result = adminDao.setOrgRegion(param);	
		}
		
		
		return result;
	}
	
	/**
	 * 기관등록
	 */
	public int setOrgContract(Map<String,Object> param){
		int result = 0;
		
		MultipartFile file1 = (MultipartFile)param.get("file1");
		MultipartFile file2 = (MultipartFile)param.get("file2");
		
		// pk값을 조회 
		
		
		String orgPkMax = adminDao.getOrgIdPk();
		param.put("orgId", orgPkMax);
		result = adminDao.setOrg(param);
		
		if(result > 0) {
			result = adminDao.setContract(param);
			
			if(result > 0) {
				result = adminDao.setAuthority(param);
				
				if(result > 0) {
					String orgId = String.valueOf(param.get("orgId"));
					// 첨부파일 저장
					if(file1 != null && !file1.isEmpty()){
						saveFile(file1, orgId, "bg", null);
					}
					if(file2 != null && !file2.isEmpty()){
						saveFile(file2, orgId, "sg", null);
					}
					
					String cityArr = (String) param.get("cityArr");
					
					String[] citySplitArr = cityArr.split(","); 
					
					for(int i = 0; i < citySplitArr.length; i++) {
						param.put("megaCd", citySplitArr[i].substring(0, 2));
						param.put("ctyCd", citySplitArr[i]);
						result = adminDao.setOrgRegion(param);	
					}
				}
			}
		}
		
		return result;
	}
	
	
	public int delOrgImage(Map<String,Object> param){
		int result = 0;
		try {
			
			// 파일 삭제
			Map<String, Object> fileInfo = adminDao.getOrgImageInfo(param.get("fileKey").toString());
			String filePath = fileInfo.get("path").toString();
			String fileName =  fileInfo.get("new_name").toString(); 
			
			if(fileAPI.deleteFile(filePath, fileName)){				
				// 디비에서 파일 정보 삭제
				result = adminDao.deleteFile(fileInfo);
				result = 1;
			}else {
				// 파일 삭제 실패
				result = -1;
			}
		} catch (Exception e){
			e.printStackTrace();
		}
		return result;
	}
	
	
	/**
	 * 이미지 등록
	 * @param file1 	파일 객체
	 * @param orgId		기관 코드
	 * @param type		파일 타입(bg, sg)
	 * @param imageKey	기존이미지 고유코드 ( 기존에 등록했던 이미지가 있으면 삭제하고 새로운 파일 등록 )
	 */
	public void saveFile(MultipartFile file1, String orgId, String type, String imageKey){
		System.out.println("save orgId :::::::::::::::::::: " + orgId);
		try{
			String originName = file1.getOriginalFilename();									   // image 원래 파일명 
			String extName = originName.substring(originName.lastIndexOf("."), originName.length());   // 확장자
			String imageFileName = fileAPI.genSaveFileName(originName);
			String realPath = "";
			String urlPath = "";
			// 폴더 확인
			if(type != null){				
				fileAPI.searchDirectory(fileUploadPath, type);
				realPath = fileUploadPath + type +"/"; 
				urlPath = urlUploadPath + type +"/"; 
			}
			
			// fileUploadPath 경로에 파일 저장
			fileAPI.writeFile(file1, realPath, imageFileName);
			
			Map<String,Object> param = new HashMap<String, Object>();
			param.put("orgId", orgId);
			param.put("oriName", originName);
			param.put("newName", imageFileName);
			param.put("path", realPath);
			param.put("pathUrl", urlPath);
			param.put("type", type);
			
			if(imageKey != null && !imageKey.equals("")){	// 업데이트
				param.put("imageKey", imageKey);
				adminDao.updateAttachFile(param);
			} else {				// 신규
				adminDao.setAttachFile(param);	
			}
			
		}catch(Exception e){
			e.printStackTrace();
		}
	}
}
