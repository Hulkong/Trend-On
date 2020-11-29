package com.openmate.onmap.admin.web;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URLEncoder;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;


/*****************************************************************************
 *
 *  @packageName : com.openmate.onmap.admin.web
 *  @fileName : FileController.java
 *  @author : JunHo Park
 *  @since 2017. 6. 29.
 *  @version 1.0
 *  @see  :
 *  @revision : 2017. 6. 29.
 *
 *  <pre>
 *  << Modification Information >>
 *    DATE	           NAME			DESC
 *     -----------	 ----------   ---------------------------------------
 *     2017. 6. 29.        JunHo Park       create FileController.java
 *  </pre>
 ******************************************************************************/
@Controller
public class FileController {

//	private String excelFilePath = "excel\\";
//	private String filePath = "C:\\";

	@Value("${config.excelFile.path}")
	private String excelFilePath ;
	/**
	 * File direct download.
	 *
	 * @param request the request
	 * @param response the response
	 * @throws Exception the exception
	 */
//	@RequestMapping("/common/fileDirectDownload.do")
	public void fileDirectDownload(HttpServletRequest request, HttpServletResponse response) throws Exception {
;
		//실제  디렉토리
//		String realDir = filePath+excelFilePath;
		String realDir = excelFilePath;

		//서버에 저장된 파일 이름 가져옴
//		String saveFileName = request.getParameter("fileName");
		String saveFileName = request.getParameter("orgFileName");

		//실제  파일 이름 가져옴
		//String orgFileName = request.getParameter("orgFileName");

		//파일 풀경로 가져옴
//		String fullFileName = realDir+saveFileName;
		String fullFileName = realDir+request.getParameter("fileName");

		//String fullFileName = request.getParameter("fullFileName");

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
				if(request.getParameter("delYn") != null && request.getParameter("delYn").equals("Y")){
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

	private String getBrowser(HttpServletRequest request) {

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
