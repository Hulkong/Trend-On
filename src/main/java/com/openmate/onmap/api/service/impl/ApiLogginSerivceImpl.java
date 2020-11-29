package com.openmate.onmap.api.service.impl;

import java.util.HashMap;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.openmate.onmap.api.dao.ApiLogginDao;
import com.openmate.onmap.api.service.ApiLogginSerivce;

@Service("apiLogginSerivce")
public class ApiLogginSerivceImpl implements ApiLogginSerivce {

	@Resource(name = "apiLogginDao")
	private ApiLogginDao apiLogginDao;
	
	private Logger logger = LoggerFactory.getLogger(ApiLogginSerivceImpl.class);

	@Override
	public void apiLogging(HashMap<String, Object> apiInfo) {
		apiLogginDao.apiLogging(apiInfo);
	}

}
