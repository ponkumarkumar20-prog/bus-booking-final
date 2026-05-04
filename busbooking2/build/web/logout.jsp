<%-- 
    Document   : logout
    Created on : 3 Jan 2026, 4:50:16 pm
    Author     : ponku
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
     <%
    session.invalidate();
    response.sendRedirect("login.jsp");
%>

    </body>
</html>
