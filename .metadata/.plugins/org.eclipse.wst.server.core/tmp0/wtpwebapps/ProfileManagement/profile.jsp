<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
    User user = (User) request.getAttribute("user");
    String msg = (String) request.getAttribute("msg");

    if(user == null){
        // If someone tries to access JSP directly, redirect to servlet
        response.sendRedirect("ProfileController");
        return;
    }

    String portId = user.getPortId();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Profile Management</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;500;700&display=swap" rel="stylesheet">
<style>
/* Body and Background */
body {
    margin: 0;
    font-family: 'Poppins', sans-serif;
    background: linear-gradient(135deg, #1b1b2f, #162447 40%, #1f4068 75%);
    color: white;
    min-height: 100vh;
    display: flex;
    flex-direction: column;
}

/* Navbar */
.navbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    background: linear-gradient(90deg, #2a1a5e, #451952);
    padding: 20px 50px;
    height: 100px;
    position: sticky;
    top: 0;
    z-index: 1000;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.6);
    font-weight: 600;
    letter-spacing: 1.2px;
}
.navbar .logo {
    display: flex;
    align-items: center;
    font-size: 2.2rem;
    color: #ff4b91;
    letter-spacing: 1px;
    user-select: none;
}
.navbar .logo img {
    height: 75px;
    width: 75px;
    margin-right: 15px;
    border-radius: 50%;
    box-shadow: 0 4px 20px rgba(255, 75, 145, 0.8);
    border: 2px solid rgba(255, 255, 255, 0.4);
    transition: transform 0.3s ease;
}
.navbar .logo img:hover {
    transform: rotate(10deg) scale(1.1);
}
.nav-links {
    display: flex;
    gap: 50px;
}
.nav-links a {
    color: #f8f8f8;
    text-decoration: none;
    font-weight: 500;
    font-size: 1.15rem;
    position: relative;
    transition: all 0.3s ease;
    padding: 8px 0;
}
.nav-links a::after {
    content: '';
    position: absolute;
    width: 0%;
    height: 3px;
    background: #ff4b91;
    left: 0;
    bottom: -8px;
    transition: all 0.3s ease;
    border-radius: 2px;
}
.nav-links a:hover {
    color: #ff4b91;
}
.nav-links a:hover::after {
    width: 100%;
}
.btn-profile { 
    padding: 10px 20px; 
    border-radius: 12px; 
    font-weight: 700; 
    font-size: .95rem; 
    cursor: pointer;
    text-decoration: none; 
    border: none; 
    background: linear-gradient(135deg, #ff00cc, #3333ff); 
    color: #fff;
    display: flex; 
    align-items: center; 
    gap: 8px;
    box-shadow: 0 0 12px rgba(255,0,204,0.6); 
    transition: all 0.35s ease;
}
.btn-profile:hover { 
    transform: scale(1.07); 
    box-shadow: 0 6px 25px rgba(255,0,204,0.6); 
}

/* Container */
.container {
    max-width: 620px;
    margin: 70px auto 80px;
    padding: 35px 40px 45px;
    background: rgba(255, 255, 255, 0.07);
    backdrop-filter: blur(20px);
    border-radius: 25px;
    border: 1.5px solid rgba(255, 255, 255, 0.15);
    box-shadow: 0 10px 35px rgba(0, 0, 0, 0.5);
    user-select: none;
}

/* Profile picture */
.profile-pic {
    text-align: center;
    margin-bottom: 30px;
}
.profile-pic img {
    width: 130px;
    height: 130px;
    border-radius: 50%;
    border: 4px solid #ff4b91;
    box-shadow:
        0 0 20px #ff4b91,
        0 0 40px #ff4b91,
        0 0 70px #ff4b91;
    transition: transform 0.35s ease;
}
.profile-pic img:hover {
    transform: scale(1.12) rotate(5deg);
    box-shadow:
        0 0 25px #ff72a3,
        0 0 50px #ff72a3,
        0 0 85px #ff72a3;
}

/* Title */
h2 {
    text-align: center;
    color: #ff4b91;
    margin-bottom: 28px;
    font-size: 2.25rem;
    font-weight: 700;
    text-shadow: 0 3px 12px rgba(0, 0, 0, 0.35);
}

/* Table & Inputs */
table {
    width: 100%;
    color: #fff;
    border-collapse: separate;
    border-spacing: 0 15px;
}
td {
    padding: 12px 10px 12px 0;
    font-weight: 600;
    vertical-align: middle;
    font-size: 1.05rem;
}
input[type="text"],
input[type="email"],
input[type="password"] {
    width: 100%;
    padding: 12px 15px;
    border-radius: 12px;
    border: none;
    outline: none;
    font-size: 1rem;
    background: rgba(255, 255, 255, 0.12);
    color: #fff;
    box-shadow: inset 0 0 7px rgba(0, 0, 0, 0.25);
    transition: all 0.3s ease;
    font-weight: 500;
}
input:hover,
input:focus {
    background: rgba(255, 255, 255, 0.22);
    animation: glowPulse 2s infinite;
    transform: scale(1.05);
    color: #ffdde1;
    box-shadow:
        0 0 8px #ff4b91,
        0 0 20px #ff4b91,
        0 0 30px #ff72a3;
}

/* Glow animation */
@keyframes glowPulse {
    0%, 100% {
        box-shadow: 0 0 8px #ff4b91, 0 0 20px #ff4b91, 0 0 30px #ff72a3;
    }
    50% {
        box-shadow: 0 0 12px #ff72a3, 0 0 28px #ff72a3, 0 0 40px #ff4b91;
    }
}

/* Password toggle icon */
.password-container {
    position: relative;
}
.password-container i {
    position: absolute;
    right: 12px;
    top: 50%;
    transform: translateY(-50%);
    cursor: pointer;
    color: #ff4b91;
    font-size: 1.2rem;
    transition: color 0.3s ease;
}
.password-container i:hover {
    animation: iconPulse 1.5s infinite;
}

/* Buttons */
.btn {
    padding: 13px 28px;
    border: none;
    border-radius: 35px;
    font-size: 1rem;
    cursor: pointer;
    color: white;
    font-weight: 700;
    transition: all 0.35s ease;
    margin: 8px;
    box-shadow: 0 6px 18px rgba(0, 0, 0, 0.25);
}
.update {
    background: linear-gradient(90deg, #28a745, #218838);
}
.update:hover {
    background: linear-gradient(90deg, #218838, #28a745);
    transform: translateY(-4px) scale(1.06);
    animation: shadowPulse 1.5s infinite;
}
.delete {
    background: linear-gradient(90deg, #dc3545, #c82333);
}
.delete:hover {
    background: linear-gradient(90deg, #c82333, #dc3545);
    transform: translateY(-4px) scale(1.06);
    animation: shadowPulse 1.5s infinite;
}

/* Back button */
.back-btn {
    display: inline-block;
    margin: 35px auto 0;
    padding: 12px 26px;
    background: #ff4b91;
    color: white;
    border-radius: 25px;
    text-decoration: none;
    font-weight: bold;
    transition: all 0.3s ease;
    box-shadow: 0 6px 15px rgba(255, 75, 145, 0.5);
    user-select: none;
    font-size: 1.1rem;
}
.back-btn i {
    margin-right: 8px;
}
.back-btn:hover {
    background: #ff2e75;
    transform: scale(1.08);
    animation: shadowPulse 1.8s infinite;
}

/* Animations */
@keyframes shadowPulse {
    0%, 100% {
        box-shadow: 0 6px 18px rgba(255, 75, 145, 0.6);
    }
    50% {
        box-shadow: 0 12px 25px rgba(255, 114, 163, 0.9);
    }
}
@keyframes iconPulse {
    0%, 100% { color: #ff4b91; }
    50% { color: #ff72a3; }
}

/* Responsive */
@media (max-width: 700px) {
    .navbar {
        padding: 20px 25px;
        flex-wrap: wrap;
        height: auto;
    }
    .nav-links {
        gap: 30px;
        margin-top: 10px;
        width: 100%;
        justify-content: center;
    }
    .container {
        margin: 40px 20px 60px;
        padding: 30px 25px 35px;
    }
}
</style>
</head>
<body>

<div class="navbar">
    <div class="logo">
       <img src="image/logo.png" alt="Logo">
       <span>ImportExportERP</span>
    </div>
       <div class="nav-links">
        <a href="http://localhost:8080/RegistrationLogin/dashboard.jsp?port_id=<%= portId %>" class="nav-link">Home</a>
       <a href="http://localhost:8080/ProductManagement/ProductServlet" class="nav-link">
    Product Management
</a>
        <a href="http://localhost:8080/OrderManagement/ListOrdersServlet?seller_port_id=<%= portId%>" class="nav-link">
    Order Management
</a>
        <a href="http://localhost:8080/Report_product/ReportedProductsServlet?port_id=<%= portId%>" class="nav-link">
    Reported Products
</a>
    </div>
    <div class="nav-cta">
        <a href="http://localhost:8080/ProfileManagement/ProfileController?port_id=<%= portId %>" class="btn btn-profile">Profile</a>
    </div>
</div>

<div class="container">
    <div class="profile-pic">
        <img src="https://cdn-icons-png.flaticon.com/512/8184/8184175.png" alt="Profile Icon">
    </div>
    <h2>Profile Management</h2>
    <% if(msg != null){ %>
        <div class="msg"><%= msg %></div>
    <% } %>

    <form method="post" action="ProfileController">
        <table>
            <tr>
                <td>Port Id</td>
                <td><input type="text" name="portid" value="<%= user.getPortId() %>" readonly></td>
            </tr>
            <tr>
                <td>Seller Name</td>
                <td><input type="text" name="sname" value="<%= user.getName() %>" pattern="[A-Za-z ]+" required></td>
            </tr>
            <tr>
                <td>Seller Email</td>
                <td><input type="email" name="semail" value="<%= user.getEmail() %>" required></td>
            </tr>
            <tr>
                <td>Password</td>
                <td>
                    <div class="password-container">
                        <input type="password" name="spassword" value="<%= user.getPassword() %>" id="password">
                        <i class="fas fa-eye" id="togglePass" style="cursor:pointer;"></i>
                    </div>
                </td>
            </tr>
            <tr>
                <td>Location</td>
                <td><input type="text" name="slocation" value="<%= user.getLocation() %>" pattern="[A-Za-z ]+" required></td>
            </tr>
            <tr>
                <td colspan="2" style="text-align:center;">
                    <input type="submit" name="update" value="Update" class="btn update">
                    <input type="submit" name="delete" value="Delete" class="btn delete">
                </td>
            </tr>
        </table>
    </form>
</div>

<script>
const toggle = document.getElementById('togglePass');
const password = document.getElementById('password');
toggle.addEventListener('click', () => {
    if(password.type === "password") {
        password.type = "text";
        toggle.classList.add('fa-eye-slash');
    } else {
        password.type = "password";
        toggle.classList.remove('fa-eye-slash');
    }
});
</script>

</body>
</html>
