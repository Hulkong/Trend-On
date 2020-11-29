<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%!
	public String fileReader(String path) throws IOException{
	    
		File file = new File(path);
	    if(!file.exists()) {
	    	  return "";
	    }
	    StringBuilder sb = new StringBuilder(); 
	    char character; 
	    FileReader fr = new FileReader(path); 
	    while((character = (char)fr.read()) != (char)-1){ 
	        sb.append(character); 
	    }
	    fr.close(); 
	    return sb.toString();
	}
%>
<%
	String cpath = new File(request.getServletPath()).getParentFile().getParentFile().getName();
	String filePath = application.getRealPath(cpath);
	File f1 = new File(filePath);
	String[] list = f1.list();
	List infoList = new ArrayList();
	List infoMapList = new ArrayList();
	
	for (int i = 0; i < list.length; i++) {
		File f2 = new File(filePath, list[i]);
		if (f2.isDirectory()) {
			String str = fileReader( filePath+"/"+list[i]+"/info.txt"  ) ;
			if(!"".equals(str)){
				
				if(list[i].indexOf("map") == 0){ // 지도 예제
					Map info = new HashMap();
					String[] infos = str.split("0x707");
					info.put("no",infos[0]);//번호
					info.put("name",infos[1]);//이름
					info.put("pageUrl",list[i]);//페이지 번호
					infoMapList.add(info);
				}else{   // 차트 예제
					Map info = new HashMap();
					String[] infos = str.split("0x707");
					info.put("no",infos[0]);//번호
					info.put("name",infos[1]);//이름
					info.put("pageUrl",list[i]);//페이지 번호
					infoList.add(info);
				}
				
				
			}
		} 
	}
	// 차트 예제 정렬
	for (int i = 0; i < infoList.size() - 1; i++) {
		for (int k = i + 1; k < infoList.size(); k++) {
			HashMap b1 = (HashMap)infoList.get(i);
			HashMap b2 = (HashMap)infoList.get(k);
			if(  Integer.parseInt(  b1.get("no").toString()  ) >  Integer.parseInt( b2.get("no").toString() )  ){
				infoList.set(i, b2);
				infoList.set(k, b1);
			}
		}
	}
	
	// 지도 예제 정렬
	for (int i = 0; i < infoMapList.size() - 1; i++) {
		for (int k = i + 1; k < infoMapList.size(); k++) {
			HashMap b1 = (HashMap)infoMapList.get(i);
			HashMap b2 = (HashMap)infoMapList.get(k);
			if(  Integer.parseInt(  b1.get("no").toString()  ) >  Integer.parseInt( b2.get("no").toString() )  ){
				infoMapList.set(i, b2);
				infoMapList.set(k, b1);
			}
		}
	}
	
	pageContext.setAttribute("infoList", infoList);
	pageContext.setAttribute("infoMapList", infoMapList);
%><!doctype>
<html>
<head>
<link rel="stylesheet" type="text/css" href="./css/docGnb.css">
<link rel="stylesheet" type="text/css" href="./css/submenu.css">
<link rel="stylesheet" type="text/css" href="./css/viewer.css">
<link rel="stylesheet" type="text/css" href="//highlightjs.org/static/demo/styles/vs.css">
<script src="//cdn.jsdelivr.net/highlight.js/9.10.0/highlight.min.js" type="text/javascript"></script>
<script src="./jquery-1.11.2.min.js" type="text/javascript"></script>
<style type="text/css">
@import url("//fonts.googleapis.com/earlyaccess/nanumgothic.css");
body{font-family:'Nanum Gothic',NanumGothic,'Nanum gothic',"Helvetica",verdana,sans-serif;}

.index-pop {
  position: absolute;
  right: 50px;
  margin-top: 1em;
  line-height: 1.5em;
}
a { text-decoration: none;}

a:link, a:visited {
  color: #3182bd;
  fill: #3182bd;
}
.index-pop svg {
  text-decoration: none !important;
  margin-left: 0.3em;
  position: relative;
  top: 3px;
}
</style>
</head>
<script type="text/javascript">

$(document).ready(function(){
	$('.tab').click(function(){
		$('.tab,.tabBody').toggleClass('off');
	});
	
	function loadExample(pageurl){
		$("#viewframe").attr("src","../"+pageurl+"/index.jsp");
		$(".index-pop.orign a").attr("href","../"+pageurl+"/index.jsp");
		
		if($('.tab').eq(0).hasClass("off"))
			$('.tab').eq(0).trigger('click');
		
		$.ajax({
			url : "../"+pageurl+"/index.jsp",			
			success: function(result, status) {
				$("#srcpage").text(result);
				hljs.highlightBlock($("#srcpage").get(0));
				
			}
		});
		$.ajax({
			url : "../"+pageurl+"/data.jsp",			
			success: function(result, status) {
				$("#datapage").text(result);
				hljs.highlightBlock($("#datapage").get(0));
			}
		});
		
	}
	$("#sampleList .submenu").eq(0).find("a").each(function(){
		$(this).click(function(){
			$("#viewTit").text($(this).text());
			loadExample($(this).attr("pageurl"));
		});
	});
	$("#openPhantom").click(function(){
// 		var phur = "http://trend-on.co.kr:48000";
		var phur = $("#phantomjsUrl").val();
		console.log(phur);
		var targetUrl = document.location.href.substr(0,document.location.href.lastIndexOf("/")+1) + $("#viewframe").attr("src");
		$("#openPhantom").attr("href",phur+"/?url="+targetUrl);
	});
	
	
	var initPage = $("#sampleList .submenu").eq(0).find("a").eq(0);
	$("#viewTit").text(initPage.text());
	loadExample(initPage.attr("pageurl"));
});

</script>
<body>
	<div class="docGnb">
		<h1 class="logo">
			<a href="###">오픈메이트온<br/>챠트 예제</a>
		</h1>
	</div>
	<div id="sampleList" class="subMenu">
		
		<div class="panel_search">
			<strong >phantomjs url :</strong>
			<div class="boxSearch">
				<input type="text" id="phantomjsUrl" class="searchQuery" title="phantomjs url 입력" placeholder="http://trend-on.co.kr:48000/" value="http://trend-on.co.kr:48000" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false">
			</div>
		</div>
		
		<div class="submenu">
			<div depth1="챠트">
				<strong >챠트 예제</strong>
				<ul>
					<c:forEach var="info" items="${infoList}" >
					<li depth2="" >
						<a href="#top" pageUrl="<c:out value="${info.pageUrl}" escapeXml="false"/>"><c:out value="${info.name}" escapeXml="false"/></a>
					</li>
       				</c:forEach>
				</ul>
			</div>
			<div depth1="지도">
				<strong >지도 예제</strong>
				<ul>
					<c:forEach var="infoMap" items="${infoMapList}" >
					<li depth2="" >
						<a href="#top" pageUrl="<c:out value="${infoMap.pageUrl}" escapeXml="false"/>"><c:out value="${infoMap.name}" escapeXml="false"/></a>
					</li>
       				</c:forEach>
				</ul>
			</div>
		</div>
	</div>
	<div id="sampleContents" class="contents">
	
		<div class="viewer">
			<h2 id="viewTit" name="top" >...</h2>
	
			<iframe id="viewframe" sandbox="allow-popups allow-scripts allow-forms allow-same-origin" src="about:blank;" marginwidth="0" marginheight="0" 
			style="width:100%;height:600px;border:none;" scrolling="no"></iframe>


			<div class="index-pop" style="left:50px;">
			    <a id="openPhantom" target="_blank" title="새창으로 열기" href="about:blank;">Open Phantomjs<svg height="16" width="12"><path d="M11 10h1v3c0 0.55-0.45 1-1 1H1c-0.55 0-1-0.45-1-1V3c0-0.55 0.45-1 1-1h3v1H1v10h10V10zM6 2l2.25 2.25-3.25 3.25 1.5 1.5 3.25-3.25 2.25 2.25V2H6z"></path></svg></a>
			</div>					
			<div class="index-pop orign">
			    <a target="_blank" title="새창으로 열기" href="about:blank;">Open<svg height="16" width="12"><path d="M11 10h1v3c0 0.55-0.45 1-1 1H1c-0.55 0-1-0.45-1-1V3c0-0.55 0.45-1 1-1h3v1H1v10h10V10zM6 2l2.25 2.25-3.25 3.25 1.5 1.5 3.25-3.25 2.25 2.25V2H6z"></path></svg></a>
			</div>				
			<div class="wrap_tab">
				<h4 class="tab">src</h4>
				<div class="tabBody">
					<figure class="highlight">
						<pre>
							<code class="html" id="srcpage">
								...
								<br/>
							</code>
						</pre>
					</figure>
				</div>
				<h4 class="tab off">data</h4>
				<div class="tabBody off">
					<figure class="highlight">
						<pre>
							<code class="json" id="datapage">
								...	
							</code>
						</pre>
					</figure>
				</div>
			</div>
		</div>

	</div>
</body>
</html>

