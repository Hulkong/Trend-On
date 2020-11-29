package com.openmate.onmap.common.util;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import com.openmate.onmap.admin.dao.AdminDao;

@EnableScheduling
@Service
public class ScheduledUtil {
	
	@Resource(name = "adminDao")
	AdminDao adminDao;
	
	/**
	 * 매일 새벽 1시에 만료된 계약의 상태값 변경
	 */
	@Scheduled(cron="0 0 1 * * * ")
	public void setContractStatus(){
		Date d = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleDateFormat sdf2 = new SimpleDateFormat("yyyyMMdd");
		
		System.out.println("계약 상태 변경 시작 : " + sdf.format(d));
		
		// 만료일이 지난 계약(1->2), 테스트(3->4), api(5->6)에 대해서 코드 변경
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("toDate", sdf2.format(d));
		adminDao.updateAgreService(param);
		
	}
}
