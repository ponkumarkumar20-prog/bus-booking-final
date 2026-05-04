<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BusGo — Bus Ticket Booking</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        :root {
            navy: #0d1b2a;
            navy-mid: #1b2d42;
            gold: #e8a020;
            gold-light: #f5c842;
            cream: #fdf6ec;
            white: #ffffff;
            text-muted: #8a9ab0;
        }

        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'DM Sans', sans-serif;
            background: var(--navy);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }

        /* Animated background */
        .bg-scene {
            position: fixed;
            inset: 0;
            z-index: 0;
            overflow: hidden;
        }
        .road {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            height: 180px;
            background: var(--navy-mid);
            clip-path: polygon(0 40%, 100% 20%, 100% 100%, 0 100%);
        }
        .road::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            height: 3px;
            background: repeating-linear-gradient(90deg, var(--gold) 0, var(--gold) 60px, transparent 60px, transparent 120px);
            animation: roadScroll 2s linear infinite;
        }
        @keyframes roadScroll {
            from { transform: translateX(0); }
            to   { transform: translateX(-120px); }
        }
        .stars {
            position: absolute;
            inset: 0;
            background-image:
                radial-gradient(1px 1px at 20% 15%, rgba(255,255,255,0.6) 0%, transparent 100%),
                radial-gradient(1px 1px at 60% 8%,  rgba(255,255,255,0.5) 0%, transparent 100%),
                radial-gradient(1.5px 1.5px at 80% 20%, rgba(255,255,255,0.7) 0%, transparent 100%),
                radial-gradient(1px 1px at 40% 5%,  rgba(255,255,255,0.4) 0%, transparent 100%),
                radial-gradient(1px 1px at 90% 35%, rgba(255,255,255,0.5) 0%, transparent 100%),
                radial-gradient(1.5px 1.5px at 10% 40%, rgba(255,255,255,0.6) 0%, transparent 100%),
                radial-gradient(1px 1px at 70% 50%, rgba(255,255,255,0.3) 0%, transparent 100%),
                radial-gradient(2px 2px at 50% 25%, rgba(232,160,32,0.8) 0%, transparent 100%);
        }
        .glow-orb {
            position: absolute;
            border-radius: 50%;
            filter: blur(80px);
            opacity: 0.15;
        }
        .orb1 { width: 400px; height: 400px; background: var(--gold); top: -100px; right: -100px; }
        .orb2 { width: 300px; height: 300px; background: #3a7bd5; bottom: 50px; left: -80px; }

        /* Main content */
        main {
            position: relative;
            z-index: 1;
            flex: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 40px 20px 200px;
            text-align: center;
        }

        .logo-mark {
            display: inline-flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 16px;
            animation: fadeDown 0.8s ease both;
        }
        .bus-emoji { font-size: 48px; filter: drop-shadow(0 4px 20px rgba(232,160,32,0.5)); }
        .brand-name {
            font-family: 'Playfair Display', serif;
            font-size: 52px;
            font-weight: 900;
            color: var(--white);
            letter-spacing: -1px;
        }
        .brand-name span { color: var(--gold); }

        .tagline {
            font-size: 17px;
            color: var(--text-muted);
            font-weight: 300;
            letter-spacing: 2px;
            text-transform: uppercase;
            margin-bottom: 50px;
            animation: fadeDown 0.8s 0.15s ease both;
        }

        .card {
            background: rgba(255,255,255,0.04);
            border: 1px solid rgba(255,255,255,0.08);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border-radius: 24px;
            padding: 44px 48px;
            width: 100%;
            max-width: 400px;
            animation: fadeUp 0.8s 0.3s ease both;
            box-shadow: 0 40px 80px rgba(0,0,0,0.4);
        }

        .card-title {
            font-family: 'Playfair Display', serif;
            font-size: 24px;
            color: var(--white);
            margin-bottom: 8px;
        }
        .card-sub {
            font-size: 14px;
            color: var(--text-muted);
            margin-bottom: 32px;
        }

        .divider {
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 18px 0;
            color: var(--text-muted);
            font-size: 12px;
            letter-spacing: 1px;
        }
        .divider::before, .divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background: rgba(255,255,255,0.08);
        }

        .btn {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            width: 100%;
            padding: 16px 24px;
            border-radius: 14px;
            font-family: 'DM Sans', sans-serif;
            font-size: 16px;
            font-weight: 600;
            text-decoration: none;
            cursor: pointer;
            border: none;
            transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
        }
        .btn:hover { transform: translateY(-3px); }
        .btn-primary {
            background: linear-gradient(135deg, var(--gold), var(--gold-light));
            color: var(--navy);
            box-shadow: 0 8px 30px rgba(232,160,32,0.35);
        }
        .btn-primary:hover { box-shadow: 0 16px 40px rgba(232,160,32,0.5); }
        .btn-outline {
            background: transparent;
            color: var(--white);
            border: 1.5px solid rgba(255,255,255,0.2);
        }
        .btn-outline:hover { background: rgba(255,255,255,0.06); border-color: rgba(255,255,255,0.35); }

        .features {
            display: flex;
            gap: 24px;
            margin-top: 48px;
            animation: fadeUp 0.8s 0.5s ease both;
        }
        .feature {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 6px;
            color: var(--text-muted);
            font-size: 12px;
            letter-spacing: 0.5px;
        }
        .feature-icon {
            width: 40px; height: 40px;
            border-radius: 12px;
            background: rgba(232,160,32,0.1);
            border: 1px solid rgba(232,160,32,0.2);
            display: flex; align-items: center; justify-content: center;
            font-size: 18px;
        }

        footer {
            position: relative;
            z-index: 1;
            text-align: center;
            padding: 16px;
            color: rgba(255,255,255,0.2);
            font-size: 12px;
        }

        @keyframes fadeDown { from { opacity: 0; transform: translateY(-20px); } to { opacity: 1; transform: none; } }
        @keyframes fadeUp   { from { opacity: 0; transform: translateY(24px);  } to { opacity: 1; transform: none; } }
    </style>
</head>
<body>
<div class="bg-scene">
    <div class="stars"></div>
    <div class="glow-orb orb1"></div>
    <div class="glow-orb orb2"></div>
    <div class="road"></div>
</div>

<main>
    <div class="logo-mark">
        <span class="bus-emoji">🚌</span>
        <span class="brand-name">Bus<span>Booking</span></span>
    </div>
    <p class="tagline">Your journey, simplified</p>

    <div class="card">
        <p class="card-title">Start Your Journey</p>
        <p class="card-sub">Book tickets quickly & securely</p>

        <a href="login.jsp" class="btn btn-primary">
            <span>🔑</span> Login to Account
        </a>
        <div class="divider">or</div>
        <a href="register.jsp" class="btn btn-outline">
            <span>✨</span> Create Account
        </a>
    </div>

    <div class="features">
        <div class="feature">
            <div class="feature-icon">⚡</div>
            <span>Instant Booking</span>
        </div>
        <div class="feature">
            <div class="feature-icon">🎫</div>
            <span>E-Tickets</span>
        </div>
        <div class="feature">
            <div class="feature-icon">🛡️</div>
            <span>Secure & Safe</span>
        </div>
    </div>
</main>

<footer>© 2026 Bus Booking System</footer>
</body>
</html>
