package com.openmate.frmwrk.report.util;

import net.sf.jasperreports.functions.annotations.Function;
import net.sf.jasperreports.functions.annotations.FunctionCategories;
import net.sf.jasperreports.functions.annotations.FunctionParameter;
import net.sf.jasperreports.functions.annotations.FunctionParameters;

@FunctionCategories({ com.openmate.frmwrk.report.util.OpenmateCategory.class })
public class OpenmateFn {

	
	public static double round(double d, int n) {
		return Math.round(d * Math.pow(10, n)) / Math.pow(10, n);
	}
	
	@Function("KR_WON_ROUND")
	@FunctionParameters({ @FunctionParameter("value"), @FunctionParameter("index"),
		@FunctionParameter("precision") })
	public static String KR_WON_ROUND(Long value, String index, String precision) {

		index = "0";
		
		if (0 == value) return "0";

		String[] prs = new String[] { "", "십", "백", "천", "만", "십만", "백만", "천만", "억", "십억", "백억", "천억", "조" };

		int i = 0;
		int pre = 0;
		String minus = "";

		long nValue = 0;
		int iPrecision = 0;
		int iIndex = 0;
		iIndex = Integer.valueOf(index);
		iPrecision = Integer.valueOf(precision);
		nValue = value;
		if (iPrecision > 0)
			pre = iPrecision;

		if (nValue < 0) {
			nValue *= -1;
			minus = "-";
		}

		if (iIndex > 0) {
			i = iIndex;
		} else {
			// Math.l
//			i = 1 + (int) (Math.floor(1e-12 + Math.log(nValue) / Math.E));
			i = (int) Math.log10(nValue);
			//i--;
			
			i = (int) (Math.floor(i/4) * 4);
		}
		
		
		if (prs.length < i)
			i = prs.length;
		
		
		if(i < 4)
			pre = 0;
		
		double trrr = round(nValue / Math.pow(10, i), pre);
		
		return minus + String.valueOf(trrr) + prs[i];
	}
}