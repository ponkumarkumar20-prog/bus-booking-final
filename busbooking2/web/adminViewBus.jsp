<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<%
    HttpSession session1 = request.getSession(false);
    if (session1 == null || session1.getAttribute("role") == null ||
        !"ADMIN".equals(session1.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin View Bus</title>

<style>
table {
    width: 80%;
    margin: 50px auto;
    border-collapse: collapse;
}
th, td {
    border: 1px solid black;
    padding: 10px;
    text-align: center;
}
th {
    background-color: #4facfe;
    color: white;
}
</style>
</head>

<body>

<h2 style="text-align:center;">Admin - View Buses</h2>

<table>
<tr>
    <th>ID</th>
    <th>Bus Name</th>
    <th>Source</th>
    <th>Destination</th>
    <th>Fare</th>
    <th>Action</th>
</tr>

<%
    Connection con = DBConnection.getConnection();
    Statement st = con.createStatement();
    ResultSet rs = st.executeQuery("SELECT * FROM buses");

    while (rs.next()) {
%>
<tr>
    <td><%= rs.getInt("bus_id") %></td>
    <td><%= rs.getString("bus_name") %></td>
    <td><%= rs.getString("source") %></td>
    <td><%= rs.getString("destination") %></td>
    <td><%= rs.getInt("fare") %></td>
    <td>
        <a href="DeleteBusServlet?id=<%= rs.getInt("bus_id") %>"
   onclick="return confirm('Are you sure?');">
   Delete
</a>

    </td>
</tr>
<%
    }
%>

</table>

</body>
</html>
