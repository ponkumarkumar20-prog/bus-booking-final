<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Register</title>

<style>
body {
    font-family: Arial;
    background: linear-gradient(to right, #43cea2, #185a9d);
}
.register-box {
    width: 400px;
    margin: 100px auto;
    background: white;
    padding: 25px;
    box-shadow: 0px 0px 10px gray;
    border-radius: 5px;
}
.register-box h2 {
    text-align: center;
}
input, button {
    width: 100%;
    padding: 10px;
    margin-top: 12px;
}
button {
    background: #43cea2;
    color: white;
    border: none;
    cursor: pointer;
}
</style>

</head>
<body>

<div class="register-box">
    <h2>User Registration</h2>

    <form action="RegisterServlet" method="post">
        <input type="text" name="name" placeholder="Full Name" required>
        <input type="email" name="email" placeholder="Email" required>
        <input type="password" name="password" placeholder="Password" required>

        <button type="submit">Register</button>
    </form>

    <br>
    <p style="text-align:center;">
        Already have an account? <a href="login.jsp">Login</a>
    </p>
</div>

</body>
</html>
