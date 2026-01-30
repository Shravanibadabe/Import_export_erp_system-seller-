<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Import Export ERP System</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
    /* Gradient background same as order.jsp */
    body {
        margin: 0;
        font-family: 'Poppins', sans-serif;
        height: 100vh;
        display: flex;
        justify-content: center;
        align-items: center;
        background: linear-gradient(120deg, #1b1b2f, #162447, #1f4068);
        overflow: hidden;
    }

    /* Floating card */
    .erp-card {
        background: rgba(0,0,0,0.6);
        border-radius: 25px;
        padding: 60px 40px;
        max-width: 500px;
        text-align: center;
        box-shadow: 0 15px 40px rgba(0,0,0,0.6);
        color: #fff;
        animation: fadeInUp 1s ease forwards;
        transform: translateY(50px);
        opacity: 0;
    }

    @keyframes fadeInUp {
        to { transform: translateY(0); opacity: 1; }
    }

    .erp-card h1 {
        font-size: 2.8rem;
        font-weight: 700;
        color: #ff4b91;
        margin-bottom: 20px;
        text-shadow: 0 2px 10px rgba(0,0,0,0.3);
    }

    .erp-card p {
        font-size: 1.2rem;
        margin-bottom: 40px;
        line-height: 1.5;
        color: #f1f1f1;
    }

    .btn-register {
        background-color: #ff4b91;
        border: none;
        padding: 15px 30px;
        font-size: 1.1rem;
        font-weight: bold;
        color: #fff;
        border-radius: 12px;
        transition: all 0.3s ease;
    }

    .btn-register:hover {
        background-color: #ff2e75;
        transform: scale(1.05);
        box-shadow: 0 8px 20px rgba(0,0,0,0.4);
    }

    /* Decorative animated dots */
    .dot {
        position: absolute;
        border-radius: 50%;
        background: rgba(255,75,145,0.2);
        animation: float 6s infinite;
    }

    @keyframes float {
        0% { transform: translateY(0) rotate(0deg);}
        50% { transform: translateY(-30px) rotate(180deg);}
        100% { transform: translateY(0) rotate(360deg);}n
    }

    .dot1 { width: 100px; height: 100px; top: 10%; left: 5%; animation-delay: 0s; }
    .dot2 { width: 150px; height: 150px; top: 70%; left: 70%; animation-delay: 2s; }
    .dot3 { width: 80px; height: 80px; top: 50%; left: 30%; animation-delay: 4s; }

</style>
</head>
<body>

<!-- Decorative Floating Dots -->
<div class="dot dot1"></div>
<div class="dot dot2"></div>
<div class="dot dot3"></div>

<!-- ERP Card -->
<div class="erp-card">
    <h1>Import Export ERP System</h1>
    <p>Manage your imports, exports, orders, products, and reports all in one place with real-time insights and analytics.</p>
    <a href="register.jsp" class="btn btn-register">Register</a>
</div>

</body>
</html>
