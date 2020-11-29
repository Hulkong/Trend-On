package com.openmate.onmap.api.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository(value = "apiAuthDao")
public interface ApiAuthDao {
	
	public Map<String, Object> checkApiAuth(Map<String, Object> param);
	public int checkApiKeyAuth(String authKey);
}
