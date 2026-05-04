<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login</title>

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
    background: linear-gradient(-45deg, #4facfe, #00f2fe, #43e97b, #38f9d7);
    background-size: 400% 400%;
    animation: bgMove 10s ease infinite;
}

/* Background animation */
@keyframes bgMove {
    0% { background-position: 0% 50%; }
    50% { background-position: 100% 50%; }
    100% { background-position: 0% 50%; }
}

/* 3D Glass Login Box */
.login-box {
    width: 350px;
    padding: 30px;
    border-radius: 20px;

    /* Glass effect */
    background: rgba(255, 255, 255, 0.15);
    backdrop-filter: blur(15px);

    /* 3D shadow */
    box-shadow: 
        0 10px 30px rgba(0,0,0,0.2),
        inset 0 1px 1px rgba(255,255,255,0.3);

    transform: perspective(1000px) rotateX(5deg);
    transition: 0.4s;
    animation: fadeIn 1s ease;
}

/* Hover 3D effect */
.login-box:hover {
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
.login-box h2 {
    text-align: center;
    color: white;
    margin-bottom: 20px;
}

/* Inputs */
input {
    width: 100%;
    padding: 12px;
    margin-top: 12px;
    border: none;
    border-radius: 10px;
    outline: none;

    background: rgba(255,255,255,0.8);
    transition: 0.3s;
}

/* Input focus glow */
input:focus {
    background: white;
    box-shadow: 0 0 10px #00f2fe;
}

/* Button */
button {
    width: 100%;
    padding: 12px;
    margin-top: 15px;
    border: none;
    border-radius: 10px;
    background: linear-gradient(45deg, #4facfe, #00f2fe);
    color: white;
    font-size: 16px;
    cursor: pointer;

    transition: 0.3s;
    box-shadow: 0 5px 15px rgba(0,0,0,0.2);
}

/* Button hover */
button:hover {
    transform: translateY(-3px) scale(1.05);
    box-shadow: 0 10px 20px rgba(0,0,0,0.3);
}

/* Button click */
button:active {
    transform: scale(0.95);
}

/* Register text */
p {
    text-align: center;
    color: white;
}

/* Link */
a {
    color: #fff;
    font-weight: bold;
    text-decoration: none;
}

a:hover {
    text-decoration: underline;
}
</style>
</head>

<body>

<div class="login-box">
    <h2>Bus Booking Login</h2>

    <form action="LoginServlet" method="post">
        <input type="email" name="email" placeholder="Email" required>
        <input type="password" name="password" placeholder="Password" required>

        <button type="submit">Login</button>
    </form>

    <br>
    <p style="text-align:center;">
        New user? <a href="register.jsp">Register</a>
    </p>
</div>

</body>
</html>
