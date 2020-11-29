package com.openmate.frmwrk.mapapp.dao;

import java.util.Map;

import org.apache.ibatis.session.ResultContext;
import org.apache.ibatis.session.ResultHandler;

public class FeatureLayerResultHandler<Map>  implements ResultHandler<Map> {

	
	
	@Override
	public void handleResult(ResultContext resultContext) {
		resultContext.getResultObject();
		
	}

}
