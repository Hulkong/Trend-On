<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<!DOCTYPE html>
<html>
 <head>
 	<title>

	</title>
 </head>
 <body>
 
 <table border="1" align="center">
       <tr>
             <td height="30" colspan="2"><tiles:insertAttribute name="header" />
             </td>
       </tr>
       <tr>
             <td height="200"><tiles:insertAttribute name="menu" /></td>
             <td width="300"><tiles:insertAttribute name="body" /></td>
       </tr>
       <tr>
             <td height="20" colspan="2"><tiles:insertAttribute name="footer" />
             </td>
       </tr>
</table>
 
 
