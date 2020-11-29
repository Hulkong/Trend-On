package com.openmate.frmwrk.mapapp.web;

import org.springframework.beans.factory.InitializingBean;

import com.bedatadriven.jackson.datatype.jts.JtsModule;
import com.fasterxml.jackson.core.JsonFactory;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.deser.DefaultDeserializationContext;
import com.fasterxml.jackson.databind.ser.DefaultSerializerProvider;

public class JtsObjectMapper extends ObjectMapper implements InitializingBean {

	   /**
	 * 
	 */
	private static final long serialVersionUID = -5363543875797294661L;

	public JtsObjectMapper() {
	   }

	   public JtsObjectMapper(JsonFactory jf) {
	       super(jf);
	   }

	   public JtsObjectMapper(ObjectMapper src) {
	       super(src);
	   }

	   public JtsObjectMapper(JsonFactory jf, DefaultSerializerProvider sp, DefaultDeserializationContext dc) {
	       super(jf, sp, dc);
	   }

	   @Override
	   public void afterPropertiesSet() throws Exception {
	       this.registerModule(new JtsModule());
	   }

}
