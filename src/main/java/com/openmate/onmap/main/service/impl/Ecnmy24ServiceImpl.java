package com.openmate.onmap.main.service.impl;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import com.openmate.onmap.main.dao.Ecnmy24Dao;
import com.openmate.onmap.main.service.Ecnmy24Service;

@Service("ecnmy24Service")
public class Ecnmy24ServiceImpl implements Ecnmy24Service{

	@Resource(name = "ecnmy24Dao")
	private Ecnmy24Dao ecnmy24Dao;
	
	@Value("${config.naverApi.clientId}")
	private String clientId ;	//애플리케이션 클라이언트 아이디값"
	@Value("${config.naverApi.clientSecret}")
	private String clientSecret ;	 //애플리케이션 클라이언트 시크릿값"

	
	/**
	 *	신문기사 가져오기
	 */
    public JSONObject searchNewsList(String search_key, int display) {
        String text = null;
        if(display <= 0) {
        	display = 4;
        }
        
        try {
            text = URLEncoder.encode(search_key, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            throw new RuntimeException("검색어 인코딩 실패",e);
        }

        String apiURL = "https://openapi.naver.com/v1/search/news.json?query=" + text+"&display="+display;    // json 결과
        //String apiURL = "https://openapi.naver.com/v1/search/blog.xml?query="+ text; // xml 결과

        Map<String, String> requestHeaders = new HashMap<>();
        requestHeaders.put("X-Naver-Client-Id", clientId);
        requestHeaders.put("X-Naver-Client-Secret", clientSecret);
        
        JSONObject responseBody = getNews(apiURL,requestHeaders);
        
        return responseBody;
    }

    /**
     * api url 연결 해서 내용을 정상적으로 읽어오는 확인! 
     * @param apiUrl
     * @param requestHeaders
     * @return	json 형식의 뉴스 기사 리스트 
     */
    private JSONObject getNews(String apiUrl, Map<String, String> requestHeaders){
        HttpURLConnection con = connect(apiUrl);
        try {
            con.setRequestMethod("GET");
            for(Map.Entry<String, String> header :requestHeaders.entrySet()) {
                con.setRequestProperty(header.getKey(), header.getValue());
            }

            int responseCode = con.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) { // 정상 호출
                return readBody(con.getInputStream());
            } else { // 에러 발생
                return readBody(con.getErrorStream());
            }
        } catch (IOException e) {
            throw new RuntimeException("API 요청과 응답 실패", e);
        } finally {
            con.disconnect();
        }
    }

    /**
     * 네이버   api 연결
     * @param apiUrl
     * @return
     */
    private HttpURLConnection connect(String apiUrl){
        try {
            URL url = new URL(apiUrl);
            return (HttpURLConnection)url.openConnection();
        } catch (MalformedURLException e) {
            throw new RuntimeException("API URL이 잘못되었습니다. : " + apiUrl, e);
        } catch (IOException e) {
            throw new RuntimeException("연결이 실패했습니다. : " + apiUrl, e);
        }
    }

    /**
     * 결과 내용 읽어오기
     * @param body
     * @return
     */
    private JSONObject readBody(InputStream body){
        InputStreamReader streamReader = new InputStreamReader(body);
        
        try {
        	JSONParser jsonParser = new JSONParser();
            JSONObject jsonObject = (JSONObject) jsonParser.parse(
                  new InputStreamReader(body, "UTF-8"));
       
            return jsonObject;
        }catch(Exception e) {
        	 throw new RuntimeException("API 응답을 읽는데 실패했습니다.", e);
        }
        
    }
    
    public Map<String, Object> getLastStdrDate(Map<String,Object> param){
    	Map<String, Object> result = new HashMap<String, Object>();
    	
    	Authentication auth = SecurityContextHolder.getContext().getAuthentication(); 
		Object obj = auth.getPrincipal();
    	
		try {
			if(obj != null && obj instanceof com.openmate.frmwrk.user.User){
				com.openmate.frmwrk.user.User usr = (com.openmate.frmwrk.user.User)obj;
				
				int serviceClss = 1;
				Map xInfo = (Map) usr.getExtInfo();
				serviceClss = Integer.valueOf( xInfo.get("service_clss").toString() );
				
				
				// 테스트일때 기간설정
				if(serviceClss == 3){
					result.put("stdrDate", "201812");
				}else{					
					result.put("stdrDate", ecnmy24Dao.getLastStdrDate(param));
				}
			}
    	}catch(Exception e) {
    		e.printStackTrace();
    		result.put("stdrDate", "201812");
    	}
    	return result;
    }
}
