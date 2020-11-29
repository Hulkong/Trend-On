package com.openmate.frmwrk.mapapp.web;

import java.io.IOException;

import org.geotools.data.simple.SimpleFeatureCollection;
import org.springframework.http.HttpInputMessage;
import org.springframework.http.HttpOutputMessage;
import org.springframework.http.converter.AbstractHttpMessageConverter;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.http.converter.HttpMessageNotWritableException;

public class FeatureCollectionConverter  extends AbstractHttpMessageConverter<org.geotools.data.simple.SimpleFeatureCollection>{

	@Override
	protected boolean supports(Class<?> clazz) {
		// TODO Auto-generated method stub
		return org.geotools.data.simple.SimpleFeatureCollection.class.equals(clazz);
	}

	@Override
	protected SimpleFeatureCollection readInternal(Class<? extends SimpleFeatureCollection> clazz,
			HttpInputMessage inputMessage) throws IOException, HttpMessageNotReadableException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	protected void writeInternal(SimpleFeatureCollection t, HttpOutputMessage outputMessage)
			throws IOException, HttpMessageNotWritableException {
		// TODO Auto-generated method stub
		
	}



}
