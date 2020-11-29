package com.openmate.frmwrk.mapapp.dao;

import java.util.Map;

import org.springframework.core.NamedThreadLocal;

public class FeatureDataHolder {
	private static final ThreadLocal<Map> metaInfo = new NamedThreadLocal<Map>("feautre data");
	
	
	public static void removeMetaData() {
		metaInfo.remove();
	}

	public static void setMetaData(Map config) {
		if (config == null) {
			removeMetaData();
		}
		else {
			metaInfo.set(config);
		}
	}

	public static Map getMetaData() {
		return metaInfo.get();
	}
}
