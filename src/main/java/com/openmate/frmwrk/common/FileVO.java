package com.openmate.frmwrk.common;

import java.io.InputStream;
import java.io.Serializable;

public class FileVO implements Serializable {

	/**
	*
	*/
	private static final long serialVersionUID = 5333647981802457755L;

	private String imageKey;

	byte[] file;

	private InputStream inputStream; // BLOB
	// private Reader introductionText; // CLOB


	public String getImageKey() {
		return imageKey;
	}

	public void setImageKey(String imageKey) {
		this.imageKey = imageKey;
	}

	public InputStream getInputStream() {
		return inputStream;
	}

	public void setInputStream(InputStream inputStream) {
		this.inputStream = inputStream;
	}

	public byte[] getFile() {
		return file;
	}

	public void setFile(byte[] file) {
		this.file = file;
	}


}
