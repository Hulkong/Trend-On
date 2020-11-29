package com.openmate.onmap.user.service.impl;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.openmate.frmwrk.usemenu.UseMenuInfo;
import com.openmate.frmwrk.usemenu.UseMenuLogginSerivce;
import com.openmate.onmap.member.dao.MemberDao;
import com.openmate.onmap.user.dao.UseMenuLogginDao;

public class UseMenuLogginSerivceImpl implements UseMenuLogginSerivce {

	@Resource(name = "useMenuLogginDao")
	private UseMenuLogginDao useMenuLogginDao;
	
	private Logger logger = LoggerFactory.getLogger(UseMenuLogginSerivceImpl.class);

	@Override
	public void logging(UseMenuInfo loginfo) {
		logger.debug(">>>>>>>>>>>>>>>>>>>"+loginfo.getMenuNm());
		logger.debug(">>>>>>>>>>>>>>>>>>>"+loginfo.getUrl());
		logger.debug(">>>>>>>>>>>>>>>>>>>"+loginfo.getUserId());
		logger.debug(">>>>>>>>>>>>>>>>>>>"+loginfo.getOrgId());
		logger.debug(">>>>>>>>>>>>>>>>>>>"+loginfo.getContractId());
		useMenuLogginDao.logging(loginfo);
	}

}
