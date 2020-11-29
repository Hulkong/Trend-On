<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%!
	public String fileReader(String path) throws IOException{
	    
		File file = new File(path);
	    if(!file.exists()) {
	    	  return "";
	    }
	    StringBuilder sb = new StringBuilder(); //파일 내용 저장을 위한 StringBuilder 객체 생성하기
	    char character; //File Reader에서 읽어온 문자를 저장하기 위한 char형 변수 생성하기
	    FileReader fr = new FileReader(path); //파일 읽어오기
	    while((character = (char)fr.read()) != (char)-1){ //파일 끝까지 한 문자씩 읽어오기
	        sb.append(character); //읽어온 문자를 파일 내용에 추가하기
	    }
	    fr.close(); //파일 닫기
	    
	    return sb.toString();
	}
%>
<html>
<head>
<title>Home</title>

</head>
<body>
	<h1>index page</h1>
	<div id="viewport">
		<%
			String cpath = new File(request.getServletPath()).getParent().getParent();
			String filePath = application.getRealPath(cpath);
			File f1 = new File(filePath);
			String[] list = f1.list();
			List infoList = new ArrayList();
			for (int i = 0; i < list.length; i++) {
				File f2 = new File(filePath, list[i]);
				if (f2.isDirectory()) {
					String str = fileReader( filePath+"/"+list[i]+"/info.txt"  ) ;
					if(!"".equals(str)){
						infoList.add(str);
					}
				} 
			}
		%>
	</div>
</body>
</html>
