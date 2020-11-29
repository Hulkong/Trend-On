package com.openmate.onmap.user.dao;

import org.springframework.stereotype.Repository;

import com.openmate.frmwrk.usemenu.UseMenuInfo;

@Repository(value = "useMenuLogginDao")
public interface UseMenuLogginDao {

	void logging(UseMenuInfo loginfo);

}
