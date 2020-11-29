package com.openmate.frmwrk.common;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;

@ControllerAdvice
public class CommonHtmlExceptionAdvice {
	
	private static final Logger logger = LoggerFactory.getLogger(CommonHtmlExceptionAdvice.class);

	@ExceptionHandler(Exception.class)
	public ModelAndView common(Exception e) {
		logger.info(e.toString());

    ModelAndView mv = new ModelAndView();
    mv.setViewName("index");
    mv.addObject("exception", e);

		return mv;
	}
}
