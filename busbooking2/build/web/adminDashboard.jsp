<%-- 
    Document   : adminDashboard
    Created on : 2 Jan 2026, 3:38:59 pm
    Author     : ponku
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
  <!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #1e3c72, #2a5298);
            height: 100vh;
            margin: 0;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .dashboard {
            background: #ffffff;
            padding: 30px 40px;
            border-radius: 10px;
            width: 300px;
            text-align: center;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
        }

        h2 {
            margin-bottom: 25px;
            color: #333;
        }

        a {
            display: block;
            text-decoration: none;
            margin: 12px 0;
            padding: 12px;
            background: #2a5298;
            color: white;
            border-radius: 6px;
            font-size: 16px;
            transition: 0.3s;
        }

        a:hover {
            background: #1e3c72;
            transform: scale(1.03);
        }

        .logout {
            background: #d63031;
        }

        .logout:hover {
            background: #b71c1c;
        }
    </style>
</head>

<body>

<div class="dashboard">
    <h2>Admin Dashboard</h2>

    <a href="addBus.jsp">Add Bus</a>
    <a href="adminViewBookings.jsp">View Booking Details</a>
    <a href="adminViewBus.jsp">View Buses</a>
    <a href="logout.jsp" class="logout">Logout</a>
</div>

</body>
</html>

</html>
