package com.openmate.onmap.common.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import org.springframework.stereotype.Service;

@Service
public class HashAlgorithm {

	/**
	 * 문자열을 SHA-256 방식으로 암호화
	 * @param txt 암호화 하려하는 문자열
	 * @return String
	 * @throws Exception
	 */
	public String getEncSHA256(String txt) {
		
	    StringBuffer sbuf = new StringBuffer();
	    MessageDigest mDigest;
	    
		try {
			mDigest = MessageDigest.getInstance("SHA-256");
			mDigest.update(txt.getBytes());
		     
		    byte[] msgStr = mDigest.digest() ;
		     
		    for(int i=0; i < msgStr.length; i++){
		        byte tmpStrByte = msgStr[i];
		        String tmpEncTxt = Integer.toString((tmpStrByte & 0xff) + 0x100, 16).substring(1);
		         
		        sbuf.append(tmpEncTxt) ;
		    }
		} catch (NoSuchAlgorithmException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	    
	     
	    return sbuf.toString();
	}
	
	/**
	 * 문자열을 MD-5 방식으로 암호화
	 * @param txt 암호화 하려하는 문자열
	 * @return String
	 * @throws Exception
	 */
	public String getEncMD5(String txt) {
	     
	    StringBuffer sbuf = new StringBuffer();
	    MessageDigest mDigest;
	    
		try {
			mDigest = MessageDigest.getInstance("MD5");
			
			mDigest.update(txt.getBytes());
		     
		    byte[] msgStr = mDigest.digest() ;
		     
		    for(int i=0; i < msgStr.length; i++){
		        String tmpEncTxt = Integer.toHexString((int)msgStr[i] & 0x00ff) ;          
		        sbuf.append(tmpEncTxt) ;
		    }
		} catch (NoSuchAlgorithmException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	     
	    return sbuf.toString() ;
	}
}