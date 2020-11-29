package com.openmate.onmap.common.util;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.List;
import java.util.Map;

import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import com.openmate.onmap.admin.web.FileController;

public class AdminExcel {

	public static void makeExcelSvcStats(String realDir, String fileName, List<Map<String, Object>> list) throws Exception {

		// workbook create
		XSSFWorkbook workbook = new XSSFWorkbook(); // 2007 이상

		// sheet 생성
		XSSFSheet sheet = workbook.createSheet("서비스 사용통계");

		// 컬럼 너비 설정
		sheet.setColumnWidth(0, 10000);
		sheet.setColumnWidth(9, 10000);

		// Cell 스타일 생성(외곽선 생성)
		XSSFCellStyle cellStyle = workbook.createCellStyle();
		DataFormat fmt = workbook.createDataFormat();
		/* Draw a thin left border */
		cellStyle.setBorderLeft(XSSFCellStyle.BORDER_THIN);
		/* Add thin right border */
		cellStyle.setBorderRight(XSSFCellStyle.BORDER_THIN);
		/* Add thin top border */
		cellStyle.setBorderTop(XSSFCellStyle.BORDER_THIN);
		/* Add thin bottom border */
		cellStyle.setBorderBottom(XSSFCellStyle.BORDER_THIN);

		// 줄 바꿈
		cellStyle.setWrapText(true);

		// 가운데 정렬
		cellStyle.setAlignment(HorizontalAlignment.CENTER);
		cellStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);

		// Cell 색깔, 무늬 채우기
		cellStyle.setFillForegroundColor(HSSFColor.TURQUOISE.index);
		cellStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);

		// 텍스트 서식적용
		XSSFCellStyle textStyle = workbook.createCellStyle();
		textStyle.setAlignment(HorizontalAlignment.CENTER);
		textStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);

		XSSFCellStyle textStyle2 = workbook.createCellStyle();
		textStyle2.setAlignment(HorizontalAlignment.RIGHT);

		textStyle.setDataFormat(fmt.getFormat("@"));

		// sheet1 설정 ---------------------------------------------------------------------//
		XSSFRow row = null;
		XSSFCell cell = null;

		// 1번째 줄
		String[] title1 = {"이용기관","기간","사용자 접속건수","서비스 이용건수"};
		String[] title2 = {"경제24시","경제 트랜드","이벤트 효과분석"};
		int[] cellwidth = {15,15,15,15,15,15};

		row = sheet.createRow(0);

		for(int i = 0; i < 6; i++) {
			cell = row.createCell(i);
			cell.setCellStyle(cellStyle);
		}

		for (int i = 0; i < title1.length; i++) {
			cell = row.createCell(i);
			cell.setCellValue(title1[i]);
			cell.setCellStyle(cellStyle);
			sheet.setColumnWidth(i, cellwidth[i]*100*5);
			// 기본 텍스트형태로 스타일 지정
			sheet.setDefaultColumnStyle(i, textStyle);
		}

		row = sheet.createRow(1);

		for(int i = 0; i < 6; i++) {
			cell = row.createCell(i);
			cell.setCellStyle(cellStyle);
		}

		for (int i = 0; i < title2.length; i++) {
			cell = row.createCell(i+3);
			cell.setCellValue(title2[i]);
			cell.setCellStyle(cellStyle);
			sheet.setColumnWidth(i+3, cellwidth[i]*100*5);
			// 기본 텍스트형태로 스타일 지정
			sheet.setDefaultColumnStyle(i+3, textStyle);
		}

		sheet.addMergedRegion(new CellRangeAddress(0,1,0,0)); //이용기관
		sheet.addMergedRegion(new CellRangeAddress(0,1,1,1)); //기간
		sheet.addMergedRegion(new CellRangeAddress(0,1,2,2)); //사용자 접속건수
		sheet.addMergedRegion(new CellRangeAddress(0,0,3,5)); //서비스 이용건수

		int cnt = 0;

		for(int j = 0; j < list.size(); j++) {

			row = sheet.createRow(j+2);

			cnt = 0;

			cell = row.createCell((cnt++));
			cell.setCellValue(String.valueOf((list.get(j)).get("org_nm")));
			cell.setCellStyle(textStyle);
			cell = row.createCell((cnt++));
			cell.setCellValue(String.valueOf((list.get(j)).get("time")));
			cell.setCellStyle(textStyle);
			cell = row.createCell((cnt++));
			cell.setCellValue(String.valueOf((list.get(j)).get("access_cnt")));
			cell.setCellStyle(textStyle2);
			cell = row.createCell((cnt++));
			cell.setCellValue(String.valueOf((list.get(j)).get("ecnmy24")));
			cell.setCellStyle(textStyle2);
			cell = row.createCell((cnt++));
			cell.setCellValue(String.valueOf((list.get(j)).get("ecnmy_trnd")));
			cell.setCellStyle(textStyle2);
			cell = row.createCell((cnt++));
			cell.setCellValue(String.valueOf((list.get(j)).get("evnt_effect")));
			cell.setCellStyle(textStyle2);
		}
		
		// excel 파일 저장
		makeFile(workbook, realDir, fileName);

	}
	
	public static void makeApiExcelFile(String realDir, String fileName, List<Map<String, Object>> list) throws Exception {

		// workbook create
		XSSFWorkbook workbook = new XSSFWorkbook(); // 2007 이상

		// sheet 생성
		XSSFSheet sheet = workbook.createSheet("API사용통계");

		// 컬럼 너비 설정
		sheet.setColumnWidth(0, 10000);
		sheet.setColumnWidth(9, 10000);

		// Cell 스타일 생성(외곽선 생성)
		XSSFCellStyle cellStyle = workbook.createCellStyle();
		DataFormat fmt = workbook.createDataFormat();
		/* Draw a thin left border */
		cellStyle.setBorderLeft(XSSFCellStyle.BORDER_THIN);
		/* Add thin right border */
		cellStyle.setBorderRight(XSSFCellStyle.BORDER_THIN);
		/* Add thin top border */
		cellStyle.setBorderTop(XSSFCellStyle.BORDER_THIN);
		/* Add thin bottom border */
		cellStyle.setBorderBottom(XSSFCellStyle.BORDER_THIN);

		// 줄 바꿈
		cellStyle.setWrapText(true);

		// 가운데 정렬
		cellStyle.setAlignment(HorizontalAlignment.CENTER);
		cellStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);

		// Cell 색깔, 무늬 채우기
		cellStyle.setFillForegroundColor(HSSFColor.TURQUOISE.index);
		cellStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);

		// 텍스트 서식적용
		XSSFCellStyle textStyle = workbook.createCellStyle();
		textStyle.setAlignment(HorizontalAlignment.CENTER);
		textStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);

		XSSFCellStyle textStyle2 = workbook.createCellStyle();
		textStyle2.setAlignment(HorizontalAlignment.RIGHT);

		textStyle.setDataFormat(fmt.getFormat("@"));

		// sheet1 설정 ---------------------------------------------------------------------//
		XSSFRow row = null;
		XSSFCell cell = null;

		// 1번째 줄
		String[] title1 = {"API명(이용기관)", "기간", "전체", "이용건수"};
		String[] title2 = {"경제 트랜드","이벤트 효과분석"};
		String[] title3 = {"전체", "거래금액", "유입인구특성", "유입인구소비", "전체", "경제효과", "유입인구특성", "유입인구소비"};
		
		int[] cellwidth = {15, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8};

		//첫번재 줄 생성
		row = sheet.createRow(0);

		for(int i = 0; i < 11; i++) {
			cell = row.createCell(i);
			cell.setCellStyle(cellStyle);
		}

		for (int i = 0; i < title1.length; i++) {
			cell = row.createCell(i);
			cell.setCellValue(title1[i]);
			cell.setCellStyle(cellStyle);
			sheet.setColumnWidth(i, cellwidth[i]*100*5);
			// 기본 텍스트형태로 스타일 지정
			sheet.setDefaultColumnStyle(i, textStyle);
		}

		row = sheet.createRow(1);

		for(int i = 0; i < 11; i++) {
			cell = row.createCell(i);
			cell.setCellStyle(cellStyle);
		}

		for (int i = 0; i < title2.length; i++) {
			cell = row.createCell( 3 + (i * 4));
			cell.setCellValue(title2[i]);
			cell.setCellStyle(cellStyle);
			sheet.setColumnWidth( 3 + (i * 4), cellwidth[i]*100*5);
			// 기본 텍스트형태로 스타일 지정
			sheet.setDefaultColumnStyle( 3 + (i * 4), textStyle);
		}
		
		row = sheet.createRow(2);

		for(int i = 0; i < 4; i++) {
			cell = row.createCell(i);
			cell.setCellStyle(cellStyle);
		}

		for (int i = 0; i < title3.length; i++) {
			cell = row.createCell(i+3);
			cell.setCellValue(title3[i]);
			cell.setCellStyle(cellStyle);
			sheet.setColumnWidth(i+3, cellwidth[i]*100*5);
			// 기본 텍스트형태로 스타일 지정
			sheet.setDefaultColumnStyle(i+3, textStyle);
		}
		

		sheet.addMergedRegion(new CellRangeAddress(0,2,0,0)); //이용기관
		sheet.addMergedRegion(new CellRangeAddress(0,2,1,1)); //기간
		sheet.addMergedRegion(new CellRangeAddress(0,2,2,2)); //사용자 접속건수
		sheet.addMergedRegion(new CellRangeAddress(0,0,3,10)); //서비스 이용건수
		sheet.addMergedRegion(new CellRangeAddress(1,1,3,6)); //서비스 이용건수
		sheet.addMergedRegion(new CellRangeAddress(1,1,7,10)); //서비스 이용건수
		

		int cnt = 0;

		for(int j = 0; j < list.size(); j++) {

			row = sheet.createRow(j+3);

			cnt = 0;

			cell = row.createCell((cnt++));
			cell.setCellValue(String.valueOf((list.get(j)).get("api_nm")) + "(" + String.valueOf((list.get(j)).get("org_nm")) + ")");
			cell.setCellStyle(textStyle);
			cell = row.createCell((cnt++));
			cell.setCellValue(String.valueOf((list.get(j)).get("log_time")));
			cell.setCellStyle(textStyle);
			cell = row.createCell((cnt++));
			cell.setCellValue((long)((list.get(j)).get("tot_cnt")));
			cell.setCellStyle(textStyle2);
			
			cell = row.createCell((cnt++));
			cell.setCellValue((long)((list.get(j)).get("eco_cnt")));
			cell.setCellStyle(textStyle2);
			cell = row.createCell((cnt++));
			cell.setCellValue((long)((list.get(j)).get("ecotradeamt_cnt")));
			cell.setCellStyle(textStyle2);
			cell = row.createCell((cnt++));
			cell.setCellValue((long)((list.get(j)).get("ecoinpopprop_cnt")));
			cell.setCellStyle(textStyle2);
			cell = row.createCell((cnt++));
			cell.setCellValue((long)((list.get(j)).get("ecoinpopcon_cnt")));
			cell.setCellStyle(textStyle2);
			
			cell = row.createCell((cnt++));
			cell.setCellValue((long)((list.get(j)).get("event_cnt")));
			cell.setCellStyle(textStyle2);
			cell = row.createCell((cnt++));
			cell.setCellValue((long)((list.get(j)).get("evtecoeff_cnt")));
			cell.setCellStyle(textStyle2);
			cell = row.createCell((cnt++));
			cell.setCellValue((long)((list.get(j)).get("evtinpopprop_cnt")));
			cell.setCellStyle(textStyle2);
			cell = row.createCell((cnt++));
			cell.setCellValue((long)((list.get(j)).get("evtinpopcon_cnt")));
			cell.setCellStyle(textStyle2);
		}
		
		int mRow = 2;
		for(int m = 0; m < list.size(); m++) {
			
			int rowCnt = Integer.parseInt(list.get(m).get("cnt").toString()) ;
			//sheet.addMergedRegion(new CellRangeAddress(mRow,(mRow+rowCnt-1),0,0));
			
			mRow += rowCnt;
			m += rowCnt;
		}

		// excel 파일 저장
		makeFile(workbook, realDir, fileName);

	}
	
	/**
	 * @description 사용신청 엑셀파일 만드는 메소드
	 * @param realDir
	 * @param fileName
	 * @param list
	 * @throws Exception
	 */
	public static void makeExcelUseApplyFile(String realDir, String fileName, List<Map<String, Object>> list) throws Exception {
		
		// workbook create
		XSSFWorkbook workbook = new XSSFWorkbook(); // 2007 이상
		
		// sheet 생성
		XSSFSheet sheet = workbook.createSheet("사용신청 현황");
		
		// 컬럼 너비 설정
		sheet.setColumnWidth(0, 10000);
		sheet.setColumnWidth(9, 10000);
		
		// Cell 스타일 생성(외곽선 생성)
		XSSFCellStyle cellStyle = workbook.createCellStyle();
		DataFormat fmt = workbook.createDataFormat();
		/* Draw a thin left border */
		cellStyle.setBorderLeft(XSSFCellStyle.BORDER_THIN);
		/* Add thin right border */
		cellStyle.setBorderRight(XSSFCellStyle.BORDER_THIN);
		/* Add thin top border */
		cellStyle.setBorderTop(XSSFCellStyle.BORDER_THIN);
		/* Add thin bottom border */
		cellStyle.setBorderBottom(XSSFCellStyle.BORDER_THIN);
		
		// 줄 바꿈
		cellStyle.setWrapText(true);
		
		// 가운데 정렬
		cellStyle.setAlignment(HorizontalAlignment.CENTER);
		cellStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		
		// Cell 색깔, 무늬 채우기
		cellStyle.setFillForegroundColor(HSSFColor.TURQUOISE.index);
		cellStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
		
		// 텍스트 서식적용
		XSSFCellStyle textStyle = workbook.createCellStyle();
		textStyle.setAlignment(HorizontalAlignment.CENTER);
		textStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		
		XSSFCellStyle textStyle2 = workbook.createCellStyle();
		textStyle2.setAlignment(HorizontalAlignment.RIGHT);
		
		textStyle.setDataFormat(fmt.getFormat("@"));
		
		// sheet1 설정 ---------------------------------------------------------------------//
		XSSFRow row = null;
		XSSFCell cell = null;
		
		// 1번째 줄
		String[] title = {"중복여부","기관명","담당부서","직함","이름","연락처","이메일","뉴스레터 동의","사용신청 등록일","상태"};
		int[] cellwidth = {15,15,15,15,15,15,15,15,15,15,15};
		
		row = sheet.createRow(0);
		
		for(int i = 0; i < title.length; i++) {
			cell = row.createCell(i);
			cell.setCellStyle(cellStyle);
		}
		
		for (int i = 0; i < title.length; i++) {
			cell = row.createCell(i);
			cell.setCellValue(title[i]);
			cell.setCellStyle(cellStyle);
			sheet.setColumnWidth(i, cellwidth[i]*100*5);
			// 기본 텍스트형태로 스타일 지정
			sheet.setDefaultColumnStyle(i, textStyle);
		}
		
		row = sheet.createRow(1);
		
		for(int i = 0; i < title.length; i++) {
			cell = row.createCell(i);
			cell.setCellStyle(cellStyle);
		}
		
		
		
		int cnt = 0;
		
		for(int j = 0; j < list.size(); j++) {
			
			row = sheet.createRow(j+1);
			
			cnt = 0;
			
			cell = row.createCell((cnt++));
			cell.setCellValue(String.valueOf((list.get(j)).get("cnt")));
			cell.setCellStyle(textStyle2);
			cell = row.createCell((cnt++));
			cell.setCellValue(String.valueOf((list.get(j)).get("org_nm")));
			cell.setCellStyle(textStyle);
			cell = row.createCell((cnt++));
			cell.setCellValue(String.valueOf((list.get(j)).get("dept")));
			cell.setCellStyle(textStyle);
			cell = row.createCell((cnt++));
			cell.setCellValue(String.valueOf((list.get(j)).get("position")));
			cell.setCellStyle(textStyle);
			cell = row.createCell((cnt++));
			cell.setCellValue(String.valueOf((list.get(j)).get("name")));
			cell.setCellStyle(textStyle);
			cell = row.createCell((cnt++));
			cell.setCellValue(String.valueOf((list.get(j)).get("mobile")));
			cell.setCellStyle(textStyle);
			cell = row.createCell((cnt++));
			cell.setCellValue(String.valueOf((list.get(j)).get("email")));
			cell.setCellStyle(textStyle);
			cell = row.createCell((cnt++));
			cell.setCellValue(String.valueOf((list.get(j)).get("newsletter_yn")));
			cell.setCellStyle(textStyle);
			cell = row.createCell((cnt++));
			cell.setCellValue(String.valueOf((list.get(j)).get("reg_date")));
			cell.setCellStyle(textStyle);
			cell = row.createCell((cnt++));
			cell.setCellValue(String.valueOf((list.get(j)).get("state")));
			cell.setCellStyle(textStyle2);
		}
		
		
		// excel 파일 저장
		makeFile(workbook, realDir, fileName);
		
	}

	private static void makeFile(Workbook workbook,String realDir, String fileName) throws IOException {

		FileOutputStream fileOut  = null; 

		try {

			FileController.makeDirectories(realDir);
			File xlsFile = new File(realDir+fileName);
			System.err.println(realDir);


			System.err.println(realDir+fileName);
			fileOut = new FileOutputStream(xlsFile);
			workbook.write(fileOut);

		} catch (FileNotFoundException e) {
			//            e.printStackTrace();
		} catch (IOException e) {
			//            e.printStackTrace();
		} finally {
			fileOut.close();
		}

	}
}
