package com.openmate.onmap.api.dao;

import java.util.HashMap;

import org.springframework.stereotype.Repository;

@Repository(value = "apiLogginDao")
public interface ApiLogginDao {
	void apiLogging(HashMap<String, Object> apiInfo);
}
