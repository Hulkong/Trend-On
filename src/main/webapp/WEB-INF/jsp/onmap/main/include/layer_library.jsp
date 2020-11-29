<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<title>${globalConfig['config.trendOn.title']}</title>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="shortcut icon" type="image/x-icon"	href="/images/common/favicon.ico" />
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.7.1/dist/leaflet.css" integrity="sha512-xodZBNTC5n17Xt2atTPuE1HxjVMSvLVW9ocqUKLsCC5CXdbqCmblAshOMAS6/keqq/sMZMZ19scR4PsZChSR7A==" crossorigin=""/>
<link rel="stylesheet" 	href="/css/import.css?ver=${globalConfig['config.version']}" />
<link rel="stylesheet" 	href="/css/reset.css?ver=${globalConfig['config.version']}" />
<link rel="stylesheet" 	href="/css/common.css?ver=${globalConfig['config.version']}" />
<link rel="stylesheet" 	href="/css/style.css?ver=${globalConfig['config.version']}" />
<link rel="stylesheet" 	href="/css/dev.css?ver=${globalConfig['config.version']}" />
<link rel="stylesheet" 	href="/css/renew_v1.css?ver=${globalConfig['config.version']}" />

<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
<script type="text/javascript" src="/js/jquery/jquery.easing.1.3.js"></script>
<script type="text/javascript" src="/js/jquery/jquery-ui.js"></script>
<script type="text/javascript" src="/js/jquery/jquery.fullpage.js"></script>
<script type="text/javascript" src="/js/Leaflet-1.0.2/geostats.js"></script>
<script src="https://unpkg.com/leaflet@1.7.1/dist/leaflet.js" integrity="sha512-XQoYMqMTK8LvdxXYG3nZ448hOEQiglfqkJs1NOQV44cWnUrBc8PkAOcXy20w0vlaXaVUearIOBhiXZ5V3ynxwA==" crossorigin=""></script>
<script type="text/javascript" src="/js/d3Chart/d3.js" charset="UTF-8"></script>
<script type="text/javascript" src="/js/d3Chart/d3plus.js" charset="UTF-8"></script>
<script type="text/javascript" src="//cdn.datatables.net/1.10.21/js/jquery.dataTables.min.js"></script>
<!-- 		<script src="https://cdnjs.cloudflare.com/ajax/libs/babel-standalone/6.24.0/babel.js"></script>     -->
<!-- 		<script src="//cdn.polyfill.io/v1/polyfill.min.js" async defer></script> -->