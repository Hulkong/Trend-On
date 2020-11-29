<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authorize access="!hasRole('ROLE_ADMIN')">
<script type="text/javascript">
	location.href = "/onmap/main.do"; 
</script>
</sec:authorize>
<link rel="shortcut icon" type="image/x-icon" href="/images/common/favicon.ico" />
<link rel="stylesheet" href='<c:url value="/css/admin.css?ver=${globalConfig['config.version']}"/>' />
<script type="text/javascript" src='<c:url value="/js/jquery/jquery-1.11.2.min.js"/>'></script>
<script type="text/javascript" src='<c:url value="/js/jquery/jquery-ui.js"/>'></script>
<script type="text/javascript" src='<c:url value="/js/jquery/forms/jquery.form.js"/>'></script>
<script type="text/javascript" src='<c:url value="/js/jquery/jquery.blockUI.js"/>'></script>
<script type="text/javascript" src='<c:url value="/js/admin/common.js?ver=${globalConfig['config.version']}"/>'></script>
<script type="text/javascript" src='<c:url value="/js/admin/API.js?ver=${globalConfig['config.version']}"/>'></script>
<script type="text/javascript" src='<c:url value="/js/admin/page.js?ver=${globalConfig['config.version']}"/>'></script>
<script type="text/javascript" src='<c:url value="/js/underscore/underscore-min.js"/>'></script>
<title>${globalConfig['config.trendOn.title']}</title>
