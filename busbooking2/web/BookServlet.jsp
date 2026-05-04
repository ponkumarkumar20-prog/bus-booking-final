<%-- 
    Document   : BookServlet
    Created on : 2 Jan 2026, 3:37:29 pm
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
       int busId = Integer.parseInt(request.getParameter("busId"));
int userId = (int) request.getSession().getAttribute("userId");

Connection con = DBConnection.getConnection();
PreparedStatement ps = con.prepareStatement(
 "INSERT INTO bookings(user_id,bus_id) VALUES(?,?)");
ps.setInt(1, userId);
ps.setInt(2, busId);
ps.executeUpdate();

// Send Email here
response.sendRedirect("success.jsp");
    </body>
</html>
