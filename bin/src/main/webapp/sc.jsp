<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*"%>
<%@ page import="java.lang.management.*"%>
<%@ page import="java.lang.reflect.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>

<%
    response.addHeader("Access-Control-Allow-Origin", "*");

    Date today = new Date();
    SimpleDateFormat date = new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat time = new SimpleDateFormat("hh:mm:ss a");
    boolean loopFlag = false;
    File[] roots;

    StringBuffer jsonStr = new StringBuffer();
    jsonStr.append("{");

    //메모리 관련
    try {
	    long maxMemory = Runtime.getRuntime().maxMemory();   /* This will return Long.MAX_VALUE if there is no preset limit */
	    jsonStr.append("\"").append("date").append("\"").append(":").append("\"").append(date.format(today)).append(" ").append(time.format(today)).append("\","); /* now date*/
	    jsonStr.append("\"").append("activeThread").append("\"").append(":").append("\"").append(Thread.activeCount()).append("\","); /* active Threads*/
	    jsonStr.append("\"").append("availCoresJVM").append("\"").append(":").append("\"" ).append(Runtime.getRuntime().availableProcessors()).append("\",");   /* Total number of processors or cores available to the JVM */
	    jsonStr.append("\"").append("freeMemJVM").append("\"").append(":").append("\"" ).append(Runtime.getRuntime().freeMemory()).append("\",");   /* Total amount of free memory available to the JVM */
	    jsonStr.append("\"").append("maxMemJVM").append("\"").append(":").append("\"" ).append((maxMemory == Long.MAX_VALUE ? "no limit" : maxMemory)).append("\",");   /* Maximum amount of memory the JVM will attempt to use */
	    jsonStr.append("\"").append("totMemJVM").append("\"").append(":").append("\"" ).append(Runtime.getRuntime().totalMemory()).append("\",");   /* Total memory currently available to the JVM */
    } catch( Exception e) {
    	System.out.println(e.getMessage());
    }

   	//파일 관련
    try {
	    /* Get a list of all filesystem roots on this system */
	    roots = File.listRoots();

	    /* For each filesystem root, print some info */
	    jsonStr.append("\"" +"fileSystems").append("\"").append(": [");
	    for (File root : roots) {
	        if(loopFlag) jsonStr.append(","); //loopflag 가 true 면 ,추가
	        else loopFlag = !loopFlag;	//loopflag 변경

	        jsonStr.append("{");

	        if(System.getProperty("os.name").contains("Windows") || System.getProperty("os.name").contains("windows")) {   // 현재 운영체제가 윈도우일 때
	            jsonStr.append("\"" +"fileSysNm").append("\"").append(":").append("\"" ).append(root.getAbsolutePath()).append("\\\",");
	        } else {   // 현재 운영체제가 리눅스일 때
	            jsonStr.append("\"" +"fileSysNm").append("\"").append(":").append("\"" ).append(root.getAbsolutePath()).append("\",");
	        }

	        jsonStr.append("\"").append("totSpace").append("\"").append(":").append("\"" ).append(root.getTotalSpace()).append("\",");
	        jsonStr.append("\"").append("freeSpace").append("\"").append(":").append("\"" ).append(root.getFreeSpace()).append("\",");
	        jsonStr.append("\"").append("usableSpace").append("\"").append(":").append("\"" ).append(root.getUsableSpace()).append("\"}");
	    }

	    jsonStr.append("],");

    } catch(Exception e) {
    	System.out.println(e.getMessage());
    }


    loopFlag = !loopFlag;	//loopflag 초기화

    try {
	    OperatingSystemMXBean operatingSystemMXBean = ManagementFactory.getOperatingSystemMXBean();

	    for (Method method : operatingSystemMXBean.getClass().getDeclaredMethods()) {
	        method.setAccessible(true);
	        if (method.getName().startsWith("get") && Modifier.isPublic(method.getModifiers())) {
	            Object value;

	            try {
	                value = method.invoke(operatingSystemMXBean);
	            } catch (Exception e) {
	                value = e;
	            }
	            //System.out.println(method.getName() + " = " + value);

	            if(loopFlag) jsonStr.append(","); //loopflag 가 true 면 ,추가
	            else loopFlag = !loopFlag;	//loopflag 변경

	            jsonStr.append("\"").append(method.getName()).append("\"").append(":").append("\"").append(value).append("\"");
	        }
	    }
    } catch(Exception e) {
    	System.out.println(e.getMessage());
    }


	jsonStr.append("}");

    out.print(jsonStr.toString());
%>