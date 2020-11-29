package com.openmate.onmap.common.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Calendar;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.openmate.onmap.common.dao.CommonDao;

@Service
public class FileAPI {

	// 리눅스 기준으로 파일 경로를 작성 ( 루트 경로인 /으로 시작한다. )
	// 윈도우라면 workspace의 드라이브를 파악하여 JVM이 알아서 처리해준다.
	// 따라서 workspace가 C드라이브에 있다면 C드라이브에 upload 폴더를 생성해 놓아야 한다.

	@Autowired
	HashAlgorithm hashAlgorithm;

	/**
	 * 현재 시간을 기준으로 파일이름 생성하는 메소드
	 * 
	 * @param originFilename 본 파일이름
	 * @return 새로 생성된 파일이름
	 */
	public String genSaveFileName(String originFilename) {

		// 본 파일이름이 없을 경우
		if (originFilename == null) {
			originFilename = "";
		}

		String saveFileName = "";
		String hashName = "";
		String extName = originFilename.substring(originFilename.lastIndexOf("."), originFilename.length()); // 확장자

		try {
			hashName = hashAlgorithm.getEncMD5(originFilename);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} // 새로 생성될 파일이름

		// 현재 시간을 기준으로 파일이름을 생성하는 로직
		Calendar calendar = Calendar.getInstance();
		saveFileName += calendar.get(Calendar.YEAR);
		saveFileName += calendar.get(Calendar.MONTH);
		saveFileName += calendar.get(Calendar.DATE);
		saveFileName += calendar.get(Calendar.HOUR);
		saveFileName += calendar.get(Calendar.MINUTE);
		saveFileName += calendar.get(Calendar.SECOND);
		saveFileName += calendar.get(Calendar.MILLISECOND);
		saveFileName += hashName;
		saveFileName += extName;

		System.out.println("originFilename : " + originFilename);
		System.out.println("saveFileName : " + saveFileName);

		return saveFileName;
	}

	/**
	 * 파일 삭제하는 메소드
	 * 
	 * @param {String} filePath 삭제경로
	 * @param {String} fileName 삭제할 파일이름
	 * @return {boolean, defualt false} success 성공여부
	 */
	public boolean deleteFile(String filePath, String fileName) {

		boolean success = false;

		File file = new File(filePath + fileName);

		if (file.exists()) {
			if (file.delete()) {
				System.out.println("파일삭제 성공");
				success = true;
			} else {
				System.out.println("파일삭제 실패");
			}
		} else {
			System.out.println("파일이 존재하지 않습니다.");
		}

		return success;
	}

	/**
	 * 파일 저장하는 메소드
	 * 
	 * @param {FileInputStream} fis 스트림 파일
	 * @param {String}          filePath 저장경로
	 * @param {String}          fileName 저장된 파일이름
	 * @return {boolean, default false} success 성공여부
	 * @throws IOException
	 */
	public boolean writeFile(FileInputStream fis, String filePath, String fileName) throws IOException {

		boolean success = false;
		FileOutputStream fos = null;

		try {

			fos = new FileOutputStream(filePath + fileName);

			// "FileStream.txt" 에서 읽을 수 있는 바이트 수를 반환하고
			// 그 크기만큼 byte[] 를 생성한다.
			int size = fis.available();
			byte[] buf = new byte[size];

			int readCount = fis.read(buf);
			fos.write(buf, 0, readCount);

			success = true;

		} catch (FileNotFoundException e) {

			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {

			// 마지막에 FileInputStream과 FileOutputStream을 닫아준다.
			if (fis != null)
				try {
					fis.close();
				} catch (IOException e) {
				}
			if (fos != null)
				try {
					fos.close();
				} catch (IOException e) {
				}
		}

		return success;
	}

	/**
	 * 파일 저장하는 메소드
	 * 
	 * @param {MultipartFile} multipartFile 파일
	 * @param {String}        filePath 저장경로
	 * @param {String}        fileName 저장된 파일이름
	 * @return {boolean, default false} success 성공여부
	 * @throws IOException
	 */
	public boolean writeFile(MultipartFile multipartFile, String filePath, String fileName) throws IOException {
		
		boolean success = false;
		FileOutputStream fos = null;
		byte[] data = multipartFile.getBytes();
		
		try {
			
			fos = new FileOutputStream(filePath + fileName);
			
			fos.write(data);
			
			success = true;
			
		} catch (FileNotFoundException e) {
			
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			
			// 마지막에 FileOutputStream을 닫아준다.
			if(fos != null) try{fos.close();}catch(IOException e){}
		}
		
		return success;
	}

	/**
	 * 파일 복사하는 메소드
	 * 
	 * @param {String} filePath 복사경로
	 * @param {String} originName 원래 파일이름
	 * @param {String} copyName 저장된 파일이름
	 * @return {boolean, defualt false} success 성공여부
	 */
	public boolean copyFile(String filePath, String originName, String copyName) throws IOException {

		boolean success = false;
		FileInputStream fis = null;
		FileOutputStream fos = null;

		try {

			fis = new FileInputStream(filePath + originName);
			fos = new FileOutputStream(filePath + copyName);

			// "FileStream.txt" 에서 읽을 수 있는 바이트 수를 반환하고
			// 그 크기만큼 byte[] 를 생성한다.
			int size = fis.available();
			byte[] buf = new byte[size];

			int readCount = fis.read(buf);
			fos.write(buf, 0, readCount);

			success = true;
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			// 마지막에 FileInputStream과 FileOutputStream을 닫아준다.
			if (fis != null)
				try {
					fis.close();
				} catch (IOException e) {
				}
			if (fos != null)
				try {
					fos.close();
				} catch (IOException e) {
				}
		}

		return success;
	}

	/**
	 * 디렉토리 감사하는 메소드
	 * 
	 * @param {String} filePath 검사경로
	 * @param {String} dirName 검사할 디렉토리 이름
	 * @return {boolean, defualt false} success 성공여부
	 */
	public boolean searchDirectory(String filePath, String dirName) {

		boolean success = false;
		File dir = new File(filePath + dirName);

		// 디렉토리 존재 여부 판단
		// 만약 exists() 메소드를 사용하면,
		// 000 이라는 "파일"이 있어도 OK 가 나옴
		if (dir.isDirectory()) {
			System.out.println("해당 디렉토리가 있습니다.");
			success = true;

		} else {
			dir.mkdir(); // 디렉토리 생성
			System.out.println("해당 디렉토리가 없어 생성하였습니다.");
		}

		return success;
	}

	/**
	 * 파일 검사하는 메소드
	 * 
	 * @param {String} filePath 검사경로
	 * @param {String} fileName 검사할 파일이름
	 * @return {boolean, defualt false} success 성공여부
	 */
	public boolean searchFile(String filePath, String fileName) {

		boolean success = false;
		File file = new File(filePath + fileName);

		if (file.isFile()) {
			System.out.println("파일이 있습니다.");
			success = true;
		} else {
			System.out.println("파일이 없습니다.");
		}

		return success;
	}
}