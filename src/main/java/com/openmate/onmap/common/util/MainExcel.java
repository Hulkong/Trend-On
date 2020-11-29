package com.openmate.onmap.common.util;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.BuiltinFormats;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFColor;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import com.openmate.onmap.admin.web.FileController;

public class MainExcel {

//	public static void makeExcelFile(String realDir, String fileName, List<Map<String, Object>> list, String ctyName) throws Exception {
		public static void makeExcelFile(String realDir, String fileName, Map<String, Object> param) throws Exception {

		// workbook create
		XSSFWorkbook workbook = new XSSFWorkbook(); // 2007 이상

		// sheet 생성
		XSSFSheet sheet = workbook.createSheet(param.get("ctyNm").toString());

		// 컬럼 너비 설정
		sheet.setColumnWidth(0, 10000);
		sheet.setColumnWidth(9, 10000);

		// Cell 스타일 생성(외곽선 생성) - 메뉴
		XSSFCellStyle cellStyle = workbook.createCellStyle();
		/* Draw a thin left border */
		cellStyle.setBorderLeft(XSSFCellStyle.BORDER_THIN);
		/* Add thin right border */
		cellStyle.setBorderRight(XSSFCellStyle.BORDER_THIN);
		/* Add thin top border */
		cellStyle.setBorderTop(XSSFCellStyle.BORDER_THIN);
		/* Add thin bottom border */
		cellStyle.setBorderBottom(XSSFCellStyle.BORDER_THIN);

		// 글자 두껍게
		XSSFFont titleFont= workbook.createFont();
//		titleFont.setFontHeightInPoints((short)10);
		titleFont.setFontName("맑은 고딕");
//		titleFont.setColor(IndexedColors.WHITE.getIndex());
		titleFont.setBold(true);
		titleFont.setItalic(false);
		cellStyle.setFont(titleFont);
		
		// 줄 바꿈
//		cellStyle.setWrapText(true);

		// 가운데 정렬
		cellStyle.setAlignment(HorizontalAlignment.CENTER);
		cellStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);

		// Cell 색깔, 무늬 채우기
		cellStyle.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
		cellStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);

		// 텍스트 서식적용1 - 일반(text) style
		XSSFCellStyle textStyle = workbook.createCellStyle();
		/* Draw a thin left border */
		textStyle.setBorderLeft(XSSFCellStyle.BORDER_THIN);
		/* Add thin right border */
		textStyle.setBorderRight(XSSFCellStyle.BORDER_THIN);
		/* Add thin top border */
		textStyle.setBorderTop(XSSFCellStyle.BORDER_THIN);
		/* Add thin bottom border */
		textStyle.setBorderBottom(XSSFCellStyle.BORDER_THIN);
		
		// 가운데 정렬
		textStyle.setAlignment(HorizontalAlignment.CENTER);
		textStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);

		
		// 텍스트 서식적용2 - 일반(number) style
		XSSFCellStyle textStyle2 = workbook.createCellStyle();
		DataFormat fmt = workbook.createDataFormat();
		/* Draw a thin left border */
		textStyle2.setBorderLeft(XSSFCellStyle.BORDER_THIN);
		/* Add thin right border */
		textStyle2.setBorderRight(XSSFCellStyle.BORDER_THIN);
		/* Add thin top border */
		textStyle2.setBorderTop(XSSFCellStyle.BORDER_THIN);
		/* Add thin bottom border */
		textStyle2.setBorderBottom(XSSFCellStyle.BORDER_THIN);
		
		// 우측 정렬
		textStyle2.setAlignment(HorizontalAlignment.RIGHT);

		// 데이터 format 지정
//		System.out.println(BuiltinFormats.getBuiltinFormats());
//		System.out.println(BuiltinFormats.getBuiltinFormat(10));
//		textStyle2.setDataFormat(fmt.getFormat("0.0%"));
		
		// 텍스트 서식적용3 - 합계(text)style
		XSSFCellStyle textStyle3 = workbook.createCellStyle();
		/* Draw a thin left border */
		textStyle3.setBorderLeft(XSSFCellStyle.BORDER_THIN);
		/* Add thin right border */
		textStyle3.setBorderRight(XSSFCellStyle.BORDER_THIN);
		/* Add thin top border */
		textStyle3.setBorderTop(XSSFCellStyle.BORDER_THIN);
		/* Add thin bottom border */
		textStyle3.setBorderBottom(XSSFCellStyle.BORDER_THIN);
		
		textStyle3.setFillForegroundColor(new XSSFColor(new java.awt.Color(217, 225, 242))); 
		textStyle3.setFillPattern(textStyle3.SOLID_FOREGROUND);

		// 가운데 정렬
		textStyle3.setAlignment(HorizontalAlignment.CENTER);
		textStyle3.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);

		
		// 텍스트 서식적용4  - 합계(number)style
		XSSFCellStyle textStyle4 = workbook.createCellStyle();
		DataFormat fmt2 = workbook.createDataFormat();
		/* Draw a thin left border */
		textStyle4.setBorderLeft(XSSFCellStyle.BORDER_THIN);
		/* Add thin right border */
		textStyle4.setBorderRight(XSSFCellStyle.BORDER_THIN);
		/* Add thin top border */
		textStyle4.setBorderTop(XSSFCellStyle.BORDER_THIN);
		/* Add thin bottom border */
		textStyle4.setBorderBottom(XSSFCellStyle.BORDER_THIN);
		
		textStyle4.setFillForegroundColor(new XSSFColor(new java.awt.Color(217, 225, 242))); 
		textStyle4.setFillPattern(textStyle4.SOLID_FOREGROUND);
		
		// 우측 정렬
		textStyle4.setAlignment(HorizontalAlignment.RIGHT);

		// 데이터 format 지정
		textStyle4.setDataFormat(fmt2.getFormat("0.0%"));
		
		
		XSSFFont titleFont2= workbook.createFont();
		titleFont2.setFontName("맑은 고딕");
		titleFont2.setBold(true);
		titleFont2.setItalic(false);
		
		textStyle3.setFont(titleFont2);
		textStyle4.setFont(titleFont2);

		// sheet1 설정 ---------------------------------------------------------------------//
		XSSFRow row = null;
		XSSFCell cell = null;

		// 1번째 줄
		String[] title = {"지역","구분","","계","00시~06시","06시~09시","19시~12시","12시~15시","15시~18시","18시~21시","21시~24시"};
		String[] title2 = {"전체","주중","주말"};
		String[] title3 = {"상주인구","유입인구"};
		String[] gubunColumn = {"total_cnt_h","total_cnt_e","week_days_cnt_h","week_days_cnt_e","week_end_cnt_h","week_end_cnt_e"};
		int cellwidth = 3750;
		
		row = sheet.createRow(1);
		sheet.setColumnWidth(0, 750);

		row = sheet.createRow(1);
		cell = row.createCell(1);
		cell.setCellValue("1. 집계기준 : 최근 1개월 기준("+param.get("date").toString().substring(0, 4)+"년 "+param.get("date").toString().substring(4, 6)+"월)");

		row = sheet.createRow(2);
		cell = row.createCell(1);
		cell.setCellValue("2. 용어정의");

		row = sheet.createRow(3);
		cell = row.createCell(1);
		cell.setCellValue(" 1) 전체: 1주 전체를 기준(월요일~일요일)");

		row = sheet.createRow(4);
		cell = row.createCell(1);
		cell.setCellValue(" 2) 주중: 주말을 제외한 5일(월요일~금요일)");
		
		row = sheet.createRow(5);
		cell = row.createCell(1);
		cell.setCellValue(" 3) 주말: 주말 2일(토요일~일요일)");
		
		row = sheet.createRow(6);
		cell = row.createCell(1);
		cell.setCellValue(" 4) 상주인구: 카드사 고객 청구지 기준, 분석지역(시군구 단위)에 자택 또는 직장 주소를 두고 분석기간동안 분석지역에서 소비행위를 한 인구");
		
		row = sheet.createRow(7);
		cell = row.createCell(1);
		cell.setCellValue(" 5) 유입인구: 카드사 고객 청구지 기준, 분석지역(시군구 단위) 이외 지역에 거주지 주소를 두고 분석기간 동안 분석지역에서 소비행위를 한 유입소비인구");
		
		row = sheet.createRow(9);
		sheet.addMergedRegion(new CellRangeAddress(9,9,2,3));
		for (int i = 0; i < title.length; i++) {
			cell = row.createCell((i+1));
			cell.setCellValue(title[i]);
			cell.setCellStyle(cellStyle);
		}

		List<Map<String, Object>> list = (List<Map<String, Object>>) param.get("dataList");
		List<Map<String, Object>> ctyList = (List<Map<String, Object>>) param.get("totalList");
		int rowNum = 10;
		int gubunIndex = 0;	// gubunColumn[] index
		
		for(int l = 0; l < 6; l++){
			int cnt = 1;
			row = sheet.createRow(rowNum++);
			
			cell = row.createCell(cnt++);
			cell.setCellStyle(textStyle3);
			cell.setCellValue( param.get("ctyNm").toString() );
			
			cell = row.createCell(cnt++);
			cell.setCellStyle(textStyle3);
			if(l%2 == 0) cell.setCellValue( title2[((l%6)/2)] );
			
			cell = row.createCell(cnt++);
			cell.setCellStyle(textStyle3);
			cell.setCellValue( title3[(l%2)] );
			
			cell = row.createCell(cnt++);
			if((l%2) == 0) cell.setCellValue("100%");
			cell.setCellStyle(textStyle3);
			
			
			for(int n = 0; n < ctyList.size(); n++){
				cell = row.createCell(cnt++);
				cell.setCellType(Cell.CELL_TYPE_NUMERIC);
				cell.setCellValue( Double.parseDouble(ctyList.get(n).get(gubunColumn[gubunIndex]).toString()));
				cell.setCellStyle(textStyle4);
			}
			gubunIndex++;
		}
		
		
		int totalRow = (list.size()/7)*6;
		String admiNm = ""; // 지역명 저장
		for(int j = 0; j < totalRow; j++) {
			int cnt = 1;
			int remainder6 = j%6;
			int remainder2 = j%2;

			row = sheet.createRow(rowNum++);
			
			// cell(1) 에 지역명 넣기
			cell = row.createCell(cnt++);
			cell.setCellStyle(textStyle);
			if(remainder6 == 0){ 
				admiNm = (String)list.get(((j*7/6))).get("nm");
				cell.setCellValue(admiNm);	
				gubunIndex = 0;
			}
			// cell(2)에 title2[]의 값을 순서대로 넣기
			cell = row.createCell(cnt++);
			cell.setCellStyle(textStyle);
			if(remainder2 == 0) cell.setCellValue( title2[(remainder6/2)] );
			
			// 2로 나눈 나머지에 따라 cell(3)에 title3[]의 값을 순서대로 넣기
			cell = row.createCell(cnt++);
			cell.setCellStyle(textStyle);
			cell.setCellValue( title3[remainder2] );
			
			// 2로 나눈 나머지가 0일때 cell(4)에 100% 넣기
			cell = row.createCell(cnt++);
			if(remainder2 == 0) cell.setCellValue("100%");
			cell.setCellStyle(textStyle);
			
			// 7개씩 for문 써서 값 넣기
			for(int m = 0 ; m < list.size(); m++){	
				// for-j 의 nm 과 for-m의 nm 비교
				if(admiNm.equals(list.get(m).get("nm"))){
					
					cell = row.createCell(cnt);
					sheet.setColumnWidth(cnt++, cellwidth);
					cell.setCellType(Cell.CELL_TYPE_NUMERIC);
					cell.setCellValue( Double.parseDouble(list.get(m).get(gubunColumn[gubunIndex]).toString()) );
					
					cell.setCellStyle(textStyle2);
				}	
			}
			gubunIndex++;
			
		}
		
		// 행정동의 갯수 계산
		int admiLength = list.size()/7;
		
		// 셀병합
		for(int k = 0 ; k < (admiLength+1); k++){		
			int mergeStart = 10 + (k*6);
			
			sheet.addMergedRegion(new CellRangeAddress(mergeStart, (mergeStart+5),1,1));
			sheet.addMergedRegion(new CellRangeAddress(mergeStart, (mergeStart+1),2,2));
			sheet.addMergedRegion(new CellRangeAddress(mergeStart, (mergeStart+1),4,4));
			sheet.addMergedRegion(new CellRangeAddress((mergeStart+2), (mergeStart+3),2,2));
			sheet.addMergedRegion(new CellRangeAddress((mergeStart+2), (mergeStart+3),4,4));
			sheet.addMergedRegion(new CellRangeAddress((mergeStart+4), (mergeStart+5),2,2));
			sheet.addMergedRegion(new CellRangeAddress((mergeStart+4), (mergeStart+5),4,4));
			
		}
		
		// excel 파일 저장
		makeFile(workbook, realDir, fileName);

	}

		
		
	/**
	 * 지자체 현황 엑셀 파일 ( new2020 )	
	 * @param realDir
	 * @param fileName
	 * @param param
	 * @throws Exception
	 */
	public static void makeNewExcelFile(String realDir, String fileName, Map<String, Object> param) throws Exception {

		// workbook create
		XSSFWorkbook workbook = new XSSFWorkbook(); // 2007 이상

		// sheet 생성
		XSSFSheet sheet = workbook.createSheet(param.get("ctyNm").toString());

		// 컬럼 너비 설정
		sheet.setColumnWidth(0, 10000);
		sheet.setColumnWidth(9, 10000);

		/** 
		 * 글씨 스타일 지정
		 **/
		XSSFFont titleFont= workbook.createFont();
		titleFont.setFontName("맑은 고딕");	// 글씨체
		titleFont.setBold(true);			// 두껍게
		titleFont.setItalic(false);			// 이테리체
		
		XSSFFont titleFont2= workbook.createFont();
		titleFont2.setFontName("맑은 고딕");	// 글씨체
		titleFont2.setBold(false);			// 두께(보통) 
		titleFont2.setItalic(false);		// 이테리체
		
		/** 
		 * [ cellStyle ]
		 * Cell 스타일 생성1 - 메뉴(header) 
		 * Cell 스타일: 4방 얇은 테두리, 가로 가운데 정렬, 세로 가운데 정렬, cell색: 회색, 전체 채움
		 * 				, 폰트 (맑은 고딕, 두껍게)
		 **/ 
		XSSFCellStyle cellStyle = workbook.createCellStyle();
		
		// 테두리
		cellStyle.setBorderLeft(XSSFCellStyle.BORDER_THIN);		/* Add thin right border */
		cellStyle.setBorderRight(XSSFCellStyle.BORDER_THIN);	/* Add thin right border */
		cellStyle.setBorderTop(XSSFCellStyle.BORDER_THIN);		/* Add thin top border */
		cellStyle.setBorderBottom(XSSFCellStyle.BORDER_THIN);	/* Add thin bottom border */
		
		// 글자 스타일 
		
		cellStyle.setFont(titleFont);		// 폰트 적용
		
//		cellStyle.setWrapText(true);		// 줄 바꿈 허용 여부
		
		//정렬
		cellStyle.setAlignment(HorizontalAlignment.CENTER);				// 가로 가운데 정렬
		cellStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);	// 세로 가운데 정렬

		cellStyle.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);	// cell 컬러
		cellStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);			// cell 무늬

		/** 
		 * [ textStyle ]
		 * Cell 스타일 생성2 - 일반 (text)
		 * Cell 스타일: 4방 얇은 테두리, 가로 가운데 정렬, 세로 가운데 정렬, 기본 폰트 사용
		 **/ 
		// 텍스트 서식적용1 - 표 위에 적힌 일반(text) style
		XSSFCellStyle textStyle = workbook.createCellStyle();
		// 테두리
		textStyle.setBorderLeft(XSSFCellStyle.BORDER_THIN);		/* Draw a thin left border */
		textStyle.setBorderRight(XSSFCellStyle.BORDER_THIN);	/* Add thin right border */
		textStyle.setBorderTop(XSSFCellStyle.BORDER_THIN);		/* Add thin top border */
		textStyle.setBorderBottom(XSSFCellStyle.BORDER_THIN);	/* Add thin bottom border */
		
		// 가운데 정렬
		textStyle.setAlignment(HorizontalAlignment.CENTER);
		textStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);

		/** 
		 * [ textStyle2 ]
		 * Cell 스타일 생성3 - 일반 표안에 들어갈 내용(number)
		 * Cell 스타일: 4방 얇은 테두리, 가로 우측 정렬, 세로 가운데 정렬, 기본 폰트 사용
		 * 			   cell서식: 데이터 포멧 지정 (숫자! 천단위 콤마 추가)
		 **/ 
		XSSFCellStyle textStyle2 = workbook.createCellStyle();
//		DataFormat fmt = workbook.createDataFormat();	// 데이터 포멧 지정
		
		textStyle2.setBorderLeft(XSSFCellStyle.BORDER_THIN);	/* Draw a thin left border */
		textStyle2.setBorderRight(XSSFCellStyle.BORDER_THIN);	/* Add thin right border */
		textStyle2.setBorderTop(XSSFCellStyle.BORDER_THIN);		/* Add thin top border */
		textStyle2.setBorderBottom(XSSFCellStyle.BORDER_THIN);	/* Add thin bottom border */
		
		// 우측 정렬
		textStyle2.setAlignment(HorizontalAlignment.RIGHT);

		// 데이터 format 지정
		textStyle2.setDataFormat(HSSFDataFormat.getBuiltinFormat("#,##0"));
//		textStyle2.setDataFormat(fmt.getFormat("0.0%"));
		
//		System.out.println(HSSFDataFormat.getBuiltinFormat("#,##0"));
//		System.out.println(BuiltinFormats.getBuiltinFormat(10));
		
		
		/** 
		 * [ textStyle3 ]
		 * Cell 스타일 생성4 - 선택한 시군구 혹은 읍면동 (지역명)
		 * Cell 스타일: 4방 얇은 테두리, 가로 가운데 정렬, 세로 가운데 정렬, 기본 폰트 사용, cell색상: #fce4d6
		 * 			   cell서식: 데이터 포멧 지정 (숫자! 천단위 콤마 추가)
		 **/ 
		XSSFCellStyle textStyle3 = workbook.createCellStyle();
		// 테두리
		textStyle3.setBorderLeft(XSSFCellStyle.BORDER_THIN);	/* Draw a thin left border */
		textStyle3.setBorderRight(XSSFCellStyle.BORDER_THIN);	/* Add thin right border */
		textStyle3.setBorderTop(XSSFCellStyle.BORDER_THIN);		/* Add thin top border */
		textStyle3.setBorderBottom(XSSFCellStyle.BORDER_THIN);	/* Add thin bottom border */
		// 셀 색상 지정
		textStyle3.setFillForegroundColor(new XSSFColor(new java.awt.Color(252, 228, 214))); 
		textStyle3.setFillPattern(textStyle3.SOLID_FOREGROUND);
		// 가운데 정렬
		textStyle3.setAlignment(HorizontalAlignment.CENTER);
		textStyle3.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		// 글씨 스타일 지정
		textStyle3.setFont(titleFont2);
		
		/** 
		 * [ textStyle3 ]
		 * Cell 스타일 생성4 - 선택한 시군구 혹은 읍면동 (지역명외 숫자들)
		 * Cell 스타일: 4방 얇은 테두리, 가로 우측 정렬, 세로 가운데 정렬, 기본 폰트 사용, cell색상: #fce4d6
		 * 			   cell서식: 데이터 포멧 지정 (숫자! 천단위 콤마 추가)
		 **/ 
		XSSFCellStyle textStyle4 = workbook.createCellStyle();
		DataFormat fmt2 = workbook.createDataFormat();
		// 테두리
		textStyle4.setBorderLeft(XSSFCellStyle.BORDER_THIN);	/* Draw a thin left border */
		textStyle4.setBorderRight(XSSFCellStyle.BORDER_THIN);	/* Add thin right border */
		textStyle4.setBorderTop(XSSFCellStyle.BORDER_THIN);		/* Add thin top border */
		textStyle4.setBorderBottom(XSSFCellStyle.BORDER_THIN);	/* Add thin bottom border */
		// 색상지정
		textStyle4.setFillForegroundColor(new XSSFColor(new java.awt.Color(252, 228, 214))); 
		textStyle4.setFillPattern(textStyle4.SOLID_FOREGROUND);
		// 우측 정렬
		textStyle4.setAlignment(HorizontalAlignment.RIGHT);
		// 데이터 format 지정
		textStyle4.setDataFormat(fmt2.getFormat("#,##0"));
		// 글씨 스타일 지정
		textStyle4.setFont(titleFont2);

		// sheet1 설정 ---------------------------------------------------------------------//
		XSSFRow row = null;
		XSSFCell cell = null;

		// 1번째 줄
		String[] title = {"명칭","주민등록인구(명)","총 유동인구(명)","총 거래금액(천원)","총 거래량(건)"};
		int cellwidth = 3750;
		
		row = sheet.createRow(1);
		sheet.setColumnWidth(0, 750);

		row = sheet.createRow(1);
		cell = row.createCell(1);
		cell.setCellValue("1. 집계기준: "+param.get("dateYm").toString().substring(0, 4)+"년 "+param.get("dateYm").toString().substring(4, 6)+"월(1개월 기준)");

		row = sheet.createRow(2);
		cell = row.createCell(1);
		cell.setCellValue("2. 용어정의");

		row = sheet.createRow(3);
		cell = row.createCell(1);
		cell.setCellValue(" 1) 주민등록 인구: 행정안전부에서 제공하는 주민등록 인구 및 세대현황 데이터");

		row = sheet.createRow(4);
		cell = row.createCell(1);
		cell.setCellValue(" 2) 유동인구: 기간 내 해당 시군구에서 활동한 인구로, 이동통신사의 정의에 따른 생활 인구를 뜻함(이동통신사 LTE시그널 데이터를 기반으로 집계)");
		
		row = sheet.createRow(5);
		cell = row.createCell(1);
		cell.setCellValue(" 3) 거래 금액: 기간 내 카드 거래정보를 기반으로 추정한 카드 결제 금액(카드사 거래정보를 기초로 시장점유율/업종별 현금 결제비율을 감안한 보정계수를 적용하여 산출)");
		
		row = sheet.createRow(6);
		cell = row.createCell(1);
		cell.setCellValue(" 4) 거래량: 기간 내 카드 거래정보를 기반으로 추정한 카드 사용에 따른 결제 건 수(카드사 거래정보를 기초로 시장점유율/업종별 현금 결제비율을 감한한 보정계수를 적용하여 산출)");
		
		row = sheet.createRow(7);
		cell = row.createCell(1);
		cell.setCellValue("3. 정렬기준 : 읍면동 이름 가나다 순");
		
		row = sheet.createRow(8);
		cell = row.createCell(1);
		cell.setCellValue("* 본 자료에 수록된 내용은 신뢰할 수 있는 자료 및 분석 프로그램을 통해 얻어진 결과입니다. 그러나 어떠한 경우에도 본 자료는 법적 책임소재에 대한 증빙자료로 사용될 수 없습니다.");
		
		row = sheet.createRow(10);
//		sheet.addMergedRegion(new CellRangeAddress(9,9,2,3));
		for (int i = 0; i < title.length; i++) {
			cell = row.createCell((i+1));
			cell.setCellValue(title[i]);
			cell.setCellStyle(cellStyle);
		}

		List<Map<String, Object>> list = (List<Map<String, Object>>) param.get("dataList");
//		List<Map<String, Object>> ctyList = (List<Map<String, Object>>) param.get("totalList");
		if(list.size() > 0) {
			for(int l = 0; l < list.size(); l++){
				row = sheet.createRow(11+l);
				int cnt = 1;
				Map<String, Object> listData = list.get(l);
				XSSFCellStyle cStyle = textStyle;
				
				if(param.get("admiCd") != null && !param.get("admiCd").equals("")) {
					if(listData.get("id").toString().equals(param.get("admiCd").toString())) {
						cStyle = textStyle3;
					}
				}else {
					if(listData.get("id").toString().equals(param.get("ctyCd").toString())) {
						cStyle = textStyle3;
					}
				}
				
				// 명칭
				cell = row.createCell(cnt++);
				cell.setCellStyle(cStyle);
				cell.setCellValue( listData.get("nm").toString() );
				
				
				cStyle = textStyle2;
				if(param.get("admiCd") != null && !param.get("admiCd").equals("")) {
					if(listData.get("id").toString().equals(param.get("admiCd").toString())) {
						cStyle = textStyle4;
					}
				}else {
					if(listData.get("id").toString().equals(param.get("ctyCd").toString())) {
						cStyle = textStyle4;
					}
				}
				
				
				// 주민등록인구
				cell = row.createCell(cnt++);
				cell.setCellStyle(cStyle);
				cell.setCellValue( Float.parseFloat(listData.get("pop").toString()) );
				
				// 총 유동인구
				cell = row.createCell(cnt++);
				cell.setCellStyle(cStyle);
				cell.setCellValue( Float.parseFloat(listData.get("float_cnt").toString()) );
				
				// 총 거래금액
				cell = row.createCell(cnt++);
				cell.setCellStyle(cStyle);
				cell.setCellValue( Float.parseFloat(listData.get("tot_amt").toString()) );
				
				// 총 거래량
				cell = row.createCell(cnt++);
				cell.setCellStyle(cStyle);
				cell.setCellValue( Float.parseFloat(listData.get("tot_cnt").toString()) );
				
			}
		}
		
		// excel 파일 저장
		makeFile(workbook, realDir, fileName);

	}		
		
	/**
	 * 엑셀 파일 만들기	
	 * @param workbook
	 * @param realDir
	 * @param fileName
	 * @throws IOException
	 */
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
