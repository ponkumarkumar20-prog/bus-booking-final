<%@ page import="util.DBConnection" %>
<%@ page import="java.sql.*" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Book Bus</title>
</head>
<!DOCTYPE html>
<html>
<head>
<title>Available Buses</title>

<style>
    body {
        font-family: Arial, sans-serif;
        background: linear-gradient(135deg, #8360c3, #2ebf91);
        min-height: 100vh;
        margin: 0;
        padding: 30px;
    }

    h2 {
        text-align: center;
        color: #fff;
        margin-bottom: 25px;
    }

    table {
        width: 95%;
        margin: auto;
        border-collapse: collapse;
        background: #fff;
        border-radius: 10px;
        overflow: hidden;
        box-shadow: 0 10px 25px rgba(0,0,0,0.2);
    }

    th {
        background: #2ebf91;
        color: white;
        padding: 12px;
        font-size: 15px;
    }

    td {
        padding: 10px;
        text-align: center;
        border-bottom: 1px solid #ddd;
    }

    tr:hover {
        background-color: #f5f5f5;
    }

    input[type="number"],
    input[type="text"] {
        width: 90%;
        padding: 6px;
        border-radius: 5px;
        border: 1px solid #ccc;
        outline: none;
    }

    input:focus {
        border-color: #2ebf91;
    }

    button {
        background: #6c5ce7;
        color: white;
        border: none;
        padding: 8px 14px;
        border-radius: 5px;
        cursor: pointer;
        transition: 0.3s;
    }

    button:hover {
        background: #4834d4;
        transform: scale(1.05);
    }

    .back {
        display: block;
        width: 120px;
        margin: 25px auto;
        text-align: center;
        text-decoration: none;
        padding: 10px;
        background: #d63031;
        color: white;
        border-radius: 6px;
        transition: 0.3s;
    }

    .back:hover {
        background: #b71c1c;
    }
</style>
</head>

<body>

<h2>Available Buses</h2>

<table>
<tr>
    <th>Bus ID</th>
    <th>Source</th>
    <th>Destination</th>
    <th>Fare</th>
    <th>Passengers</th>
    <th>Seat Numbers</th>
    <th>Action</th>
</tr>

<%
    Connection con = DBConnection.getConnection();
    Statement st = con.createStatement();
    ResultSet rs = st.executeQuery("SELECT * FROM buses");

    while (rs.next()) {
%>
<tr>
<form action="UserBookServlet" method="post">
    <td><%= rs.getInt("bus_id") %></td>
    <td><%= rs.getString("source") %></td>
    <td><%= rs.getString("destination") %></td>
    <td><%= rs.getInt("fare") %></td>

    <td>
        <input type="number" name="passengers" min="1" required>
    </td>

    <td>
        <input type="text" name="seatNumbers" placeholder="Ex: 1,2,3" required>
    </td>

    <td>
        <input type="hidden" name="busId" value="<%= rs.getInt("bus_id") %>">
        <button type="submit">Book</button>
    </td>
</form>
</tr>
<%
    }
%>

</table>

<a href="userDashboard.jsp" class="back">Back</a>

</body>
</html>

