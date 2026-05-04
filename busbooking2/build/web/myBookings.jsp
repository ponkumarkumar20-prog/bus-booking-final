<%@ page import="util.DBConnection" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    int userId = (int) session.getAttribute("userId");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Bookings</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: linear-gradient(135deg, #ff9a9e, #fad0c4);
            min-height: 100vh;
            padding: 30px 20px;
        }

        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 25px;
            font-size: 26px;
        }

        .table-wrap {
            width: 100%;
            overflow-x: auto;
        }

        table {
            width: 100%;
            min-width: 700px;
            border-collapse: collapse;
            background: #ffffff;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }

        th {
            background: #ff6f61;
            color: white;
            padding: 14px 12px;
            font-size: 14px;
            text-align: center;
        }

        td {
            padding: 11px 12px;
            text-align: center;
            border-bottom: 1px solid #f0ddd9;
            font-size: 14px;
            color: #333;
        }

        tr:last-child td { border-bottom: none; }
        tr:hover td { background-color: #fff5f4; }

        .seat-badge {
            display: inline-block;
            background: #ff6f61;
            color: #fff;
            padding: 3px 9px;
            border-radius: 5px;
            font-size: 12px;
            font-weight: 600;
            margin: 2px;
        }

        .btn-ticket {
            display: inline-block;
            background: linear-gradient(135deg, #11998e, #38ef7d);
            color: #fff;
            text-decoration: none;
            padding: 7px 15px;
            border-radius: 7px;
            font-size: 13px;
            font-weight: 600;
            transition: all 0.3s;
            white-space: nowrap;
        }
        .btn-ticket:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(17,153,142,0.4);
        }

        .back {
            display: block;
            width: 140px;
            margin: 25px auto 0;
            text-align: center;
            text-decoration: none;
            padding: 11px;
            background: #6c5ce7;
            color: white;
            border-radius: 8px;
            font-weight: 600;
            transition: 0.3s;
        }
        .back:hover { background: #4834d4; }

        .empty-msg {
            text-align: center;
            padding: 30px;
            color: #999;
            font-size: 16px;
        }
    </style>
</head>
<body>

<h2>🎫 My Booked Tickets</h2>

<div class="table-wrap">
<table>
    <tr>
        <th>Booking ID</th>
        <th>Bus</th>
        <th>Source</th>
        <th>Destination</th>
        <th>Fare/Person</th>
        <th>Passengers</th>
        <th>Seat Numbers</th>
        <th>Date</th>
       
    </tr>

<%
    Connection con = DBConnection.getConnection();
    PreparedStatement ps = con.prepareStatement(
        "SELECT bk.booking_id, b.bus_name, b.source, b.destination, b.fare, " +
        "bk.passengers, bk.seat_numbers, bk.booking_date " +
        "FROM bookings bk " +
        "JOIN buses b ON bk.bus_id = b.bus_id " +
        "WHERE bk.user_id = ? " +
        "ORDER BY bk.booking_id DESC"
    );
    ps.setInt(1, userId);
    ResultSet rs = ps.executeQuery();

    boolean hasData = false;
    while (rs.next()) {
        hasData = true;
        int bkId     = rs.getInt("booking_id");
        String seats = rs.getString("seat_numbers");
        String date  = rs.getTimestamp("booking_date") != null
                       ? rs.getTimestamp("booking_date").toString() : "N/A";
%>
<tr>
    <td><strong>#BK<%= String.format("%06d", bkId) %></strong></td>
    <td><%= rs.getString("bus_name") %></td>
    <td><%= rs.getString("source") %></td>
    <td><%= rs.getString("destination") %></td>
    <td>₹<%= rs.getInt("fare") %></td>
    <td><%= rs.getInt("passengers") %></td>
    <td>
        <%
            if (seats != null) {
                for (String s : seats.split(",")) {
                    s = s.trim();
                    if (!s.isEmpty()) {
        %>
            <span class="seat-badge"><%= s %></span>
        <%
                    }
                }
            }
        %>
    </td>
    <td style="font-size:12px;"><%= date %></td>
 
</tr>
<%
    }
    if (!hasData) {
%>
<tr>
    <td colspan="9" class="empty-msg">No bookings found. <a href="viewBus.jsp">Book now!</a></td>
</tr>
<%
    }
    con.close();
%>
</table>
</div>

<a href="userDashboard.jsp" class="back">⬅ Back</a>

</body>
</html>
