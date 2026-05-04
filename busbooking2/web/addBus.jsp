<%-- 
    Document   : addBus
    Created on : 2 Jan 2026, 3:39:30?pm
    Author     : ponku
--%>

<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    HttpSession session1 = request.getSession(false);
    if (session1 == null || session1.getAttribute("role") == null ||
        !session1.getAttribute("role").equals("ADMIN")) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Bus</title>

<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: 'Segoe UI', sans-serif;
}

/* Animated gradient background */
body {
    height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
    background: linear-gradient(-45deg, #667eea, #764ba2, #43e97b, #38f9d7);
    background-size: 400% 400%;
    animation: bgMove 12s ease infinite;
}

/* Background animation */
@keyframes bgMove {
    0% { background-position: 0% 50%; }
    50% { background-position: 100% 50%; }
    100% { background-position: 0% 50%; }
}

/* 3D Glass Container */
.container {
    width: 400px;
    padding: 30px;
    border-radius: 20px;

    background: rgba(255, 255, 255, 0.15);
    backdrop-filter: blur(15px);

    box-shadow: 
        0 10px 30px rgba(0,0,0,0.3),
        inset 0 1px 2px rgba(255,255,255,0.3);

    transform: perspective(1000px) rotateX(6deg);
    transition: 0.4s;
    animation: fadeIn 1s ease;
}

/* Hover 3D effect */
.container:hover {
    transform: perspective(1000px) rotateX(0deg) scale(1.03);
}

/* Fade animation */
@keyframes fadeIn {
    from {
        opacity: 0;
        transform: translateY(40px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

/* Title */
.container h2 {
    text-align: center;
    color: white;
    margin-bottom: 20px;
}

/* Inputs */
input {
    width: 100%;
    padding: 12px;
    margin-top: 12px;
    border-radius: 10px;
    border: none;
    outline: none;

    background: rgba(255,255,255,0.85);
    transition: 0.3s;
}

/* Input focus glow */
input:focus {
    background: white;
    box-shadow: 0 0 10px #764ba2;
}

/* Button */
button {
    width: 100%;
    padding: 12px;
    margin-top: 15px;
    border: none;
    border-radius: 10px;

    background: linear-gradient(45deg, #43e97b, #38f9d7);
    color: black;
    font-size: 16px;
    font-weight: bold;
    cursor: pointer;

    transition: 0.3s;
    box-shadow: 0 5px 15px rgba(0,0,0,0.2);
}

/* Hover effect */
button:hover {
    transform: translateY(-3px) scale(1.05);
    box-shadow: 0 10px 25px rgba(0,0,0,0.4);
}

/* Click effect */
button:active {
    transform: scale(0.95);
}

/* Back link */
a {
    display: block;
    text-align: center;
    margin-top: 15px;
    color: white;
    text-decoration: none;
    font-weight: bold;
}

a:hover {
    text-decoration: underline;
}
</style>

</head>
<body>

<div class="container">
    <h2>Admin ? Add Bus</h2>

    <form action="AddBusServlet" method="post">
        <input type="text" name="busName" placeholder="Bus Name" required>
        <input type="text" name="source" placeholder="Source" required>
        <input type="text" name="destination" placeholder="Destination" required>
        <input type="number" name="fare" placeholder="Fare" required>

        <button type="submit">Add Bus</button>
    </form>

    <br>
    <a href="adminDashboard.jsp">Back</a>
</div>

</body>
</html>
