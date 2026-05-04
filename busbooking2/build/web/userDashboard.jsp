<%@ page contentType="text/html; charset=UTF-8" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>User Dashboard</title>
</head>
<!DOCTYPE html>
<html>
<head>
    <title>User Dashboard</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #11998e, #38ef7d);
            height: 100vh;
            margin: 0;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .user-box {
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

        ul {
            list-style: none;
            padding: 0;
        }

        ul li {
            margin: 12px 0;
        }

        a {
            display: block;
            text-decoration: none;
            padding: 12px;
            background: #11998e;
            color: white;
            border-radius: 6px;
            font-size: 16px;
            transition: 0.3s;
        }

        a:hover {
            background: #0f766e;
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

<div class="user-box">
    <h2>Welcome User</h2>

    <ul>
        <li><a href="viewBus.jsp">Book Bus Ticket</a></li>
        <li><a href="myBookings.jsp">My Bookings</a></li>
        <li><a href="logout.jsp" class="logout">Logout</a></li>
    </ul>
</div>

</body>
</html>

</html>
