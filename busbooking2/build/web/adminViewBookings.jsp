<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<%
HttpSession session1 = request.getSession(false);
if (session1 == null || !"ADMIN".equals(session1.getAttribute("role"))) {
    response.sendRedirect("login.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Admin - View Bookings</title>

<style>

/* ===== ROOT ===== */
:root {
    --bg: #0f172a;
    --card: #111827;
    --row1: #1f2937;
    --row2: #111827;
    --hover: #374151;

    --primary: #3b82f6;
    --accent: #22c55e;

    --text: #f9fafb;
    --muted: #9ca3af;
}

/* ===== BODY ===== */
body {
    margin: 0;
    font-family: 'Segoe UI', sans-serif;
    background: linear-gradient(135deg, #0f172a, #020617);
    color: var(--text);
}

/* ===== HEADER ===== */
.header {
    text-align: center;
    padding: 25px;
    font-size: 30px;
    font-weight: bold;
    color: var(--primary);
}

/* ===== CONTAINER ===== */
.container {
    width: 90%;
    margin: auto;
    margin-top: 20px;

    background: var(--card);
    padding: 20px;
    border-radius: 15px;

    box-shadow: 0 10px 30px rgba(0,0,0,0.6);
}

/* ===== TABLE ===== */
table {
    width: 100%;
    border-collapse: collapse;
}

/* Header */
th {
    background: linear-gradient(45deg, #3b82f6, #06b6d4);
    color: white;
    padding: 14px;
    font-size: 15px;
}

/* Rows */
td {
    padding: 14px;
}

/* Zebra rows */
tr:nth-child(even) {
    background: var(--row1);
}

tr:nth-child(odd) {
    background: var(--row2);
}

/* Hover */
tr:hover {
    background: var(--hover);
    transition: 0.3s;
}

/* Empty */
.empty {
    text-align: center;
    color: var(--muted);
    padding: 20px;
}

/* Button */
.back-btn {
    display: inline-block;
    margin: 25px;
    padding: 12px 22px;
    background: linear-gradient(45deg, #22c55e, #4ade80);
    color: black;
    text-decoration: none;
    border-radius: 8px;
    font-weight: bold;
    transition: 0.3s;
}

.back-btn:hover {
    transform: scale(1.05);
}

/* Animation */
.container {
    animation: fadeIn 0.6s ease;
}

@keyframes fadeIn {
    from { opacity: 0; transform: translateY(20px); }
    to { opacity: 1; transform: translateY(0); }
}

</style>

</head>

<body>

<div class="header">🛠️ Admin - Booked Tickets</div>

<div class="container">

<table>
    <tr>
        <th>User Name</th>
        <th>Seat Numbers</th>
        <th>Passengers</th>
    </tr>

<%
try {
    Connection con = DBConnection.getConnection();

    PreparedStatement ps = con.prepareStatement(
        "SELECT u.name, b.seat_numbers, b.passengers " +
        "FROM users u JOIN bookings b ON u.id = b.user_id"
    );

    ResultSet rs = ps.executeQuery();
    boolean hasData = false;

    while (rs.next()) {
        hasData = true;
%>
    <tr>
        <td><%= rs.getString("name") %></td>
        <td><%= rs.getString("seat_numbers") %></td>
        <td><%= rs.getInt("passengers") %></td>
    </tr>
<%
    }

    if (!hasData) {
%>
    <tr>
        <td colspan="3" class="empty">No bookings found</td>
    </tr>
<%
    }

    con.close();
} catch (Exception e) {
%>
    <tr>
        <td colspan="3" style="color:red;">Error: <%= e.getMessage() %></td>
    </tr>
<%
}
%>

</table>

</div>

<center>
    <a href="adminDashboard.jsp" class="back-btn">⬅ Back to Dashboard</a>
</center>

</body>
</html>