package com.openmate.onmap.common.util;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

@Service
public class fileUtil {

	@Value("${config.excelFile.path}")
	private String excelFilePath;
	
	/*****************
	 *  관리자의 추가메뉴 전용 파일 업로드
	 * @param param
	 * @return
	 ****************/
	public Map<String, Object> fileUpload( Map<String, Object> param ){
		 Map<String, Object> returnObject = new HashMap<String, Object>();
		try{
			MultipartHttpServletRequest mhsr = (MultipartHttpServletRequest) param.get("files");
			
			Iterator it = mhsr.getFileNames();
			MultipartFile mfile = null;
			String fieldName = "";;
			
			while(it.hasNext()){
				fieldName = (String) it.next(); //  내용을 가져와서
				mfile = mhsr.getFile(fieldName);
				String origName;
				
				origName = new String(mfile.getOriginalFilename().getBytes("8859_1"),"UTF-8"); // 한글깨짐 방지
				
				// 파일명이 없다면
				if("".equals(origName)){
					continue;
				}
				
				// 파일명 변경
				String ext = origName.substring(origName.lastIndexOf(".")); // 확장자
				
				Date d = new Date();
				SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss", Locale.KOREA);
				
				String saveFileName = "upload_"+ sdf.format(d) + ext;
				
				// 설정한  path에 파일 저장
				String path = (String) param.get("path");
				File serverFile = new File(path + File.separator + saveFileName);
				mfile.transferTo(serverFile);
				Map<String, Object> file = new HashMap<String, Object>(); 
				file.put("origName", origName); 
				file.put("sfile", serverFile); 
				returnObject.put(mfile.getName(), param.get("pathUrl") + saveFileName);
			}
			
//			returnObject.put("params", mhsr.getParameterMap());
			
			return returnObject;
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	 * 다운로드
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	public void fileDirectDownload( Map<String, Object> param, HttpServletRequest request, HttpServletResponse response) throws Exception {
;
		//실제  디렉토리
		String realDir = (String)param.get("filePath"); 
		if(realDir == null || realDir.equals("")) realDir = excelFilePath;
		
		//서버에 저장된 파일 이름 가져옴
		String saveFileName = (String) param.get("orgFileName");

		//파일 풀경로 가져옴
		String fullFileName = realDir + (String)param.get("fileName");

		//String fullFileName = request.getParameter("fullFileName");
		System.out.println("fullFileName :: " + fullFileName);
		
		//파일을  orgFileName의 이름으로 다운로드 함
		File f = new File(fullFileName);

		if (f.exists()) {
			// 파일명 인코딩 처리
			String header = getBrowser(request);
			if (header.contains("MSIE")) {
				String docName = URLEncoder.encode(saveFileName,"EUC-KR").replaceAll("\\+", "%20");
				response.setHeader("Content-Disposition", "attachment;filename=" + docName + ";");
			} else if (header.contains("Firefox")) {
				String docName = new String(saveFileName.getBytes("EUC-KR"), "ISO-8859-1");
				response.setHeader("Content-Disposition", "attachment; filename=\"" + docName + "\"");
			} else if (header.contains("Opera")) {
				String docName = new String(saveFileName.getBytes("EUC-KR"), "ISO-8859-1");
				response.setHeader("Content-Disposition", "attachment; filename=\"" + docName + "\"");
			} else if (header.contains("Chrome")) {
				String docName = new String(saveFileName.getBytes("EUC-KR"), "ISO-8859-1");
				response.setHeader("Content-Disposition", "attachment; filename=\"" + docName + "\"");
			}
			response.setContentType("application/octet-stream");
			response.setHeader("Content-Transfer-Encoding", "binary;");
			response.setHeader("Pragma", "no-cache;");
			response.setHeader("Expires", "-1;");

			byte[] buffer = new byte[1024];
			BufferedInputStream ins = new BufferedInputStream(new FileInputStream(f));
			BufferedOutputStream outs = new BufferedOutputStream(response.getOutputStream());

			try {
				int read = 0;
				while ((read = ins.read(buffer)) != -1) {
					outs.write(buffer, 0, read);
				}
				outs.close();
				ins.close();
				
				// 파일 삭제 추가(2018.03.26) 시작 
				if(param.get("delYn") != null && param.get("delYn").equals("Y")){
					if(f.delete()) System.out.println("파일 삭제!!");
					else System.out.println("파일 삭제 실패!!");
				}
				// 파일 삭제 추가(2018.03.26) 끝
				
			} catch (IOException e) {
				System.out.println("$$$$$$$$$$$$$$$$$  : FILE DOWNLOAD ERROR : $$$$$$$$$$$$$$$$$$");
			} finally {
				if(outs!=null) {
					outs.close();
				}
				if(ins!=null) {
					ins.close();
				}
				
			}
		} else {
			throw new Exception("첨부파일이 존재하지 않습니다. 관리자에게 문의바랍니다.");
		}
	}
	
	public static boolean makeDirectories(String path) {
		if( StringUtils.isBlank(path)) {
			throw new RuntimeException("Given path parameter is blank. Thus can't make directory.");
		}

		File f = new File(path);

		if (f.exists()) {
			return false;
		} else {
			f.mkdirs();
			return true;
		}
	}
	
	private static String getBrowser(HttpServletRequest request) {

		String header =request.getHeader("User-Agent");

		if (header.contains("MSIE")) {
			return "MSIE";
		} else if(header.contains("Chrome")) {
			return "Chrome";
		} else if(header.contains("Opera")) {
			return "Opera";
		}

		return "Firefox";

	}
}
