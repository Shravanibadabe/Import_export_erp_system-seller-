<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="jakarta.servlet.http.Cookie" %>
<%@ page import="model.Order" %>

<%
    // ✅ Cookie-based login check
    Cookie[] cookies = request.getCookies();
    String portId = null;
    if (cookies != null) {
        for (Cookie c : cookies) {
            if ("port_id".equals(c.getName())) {
                portId = c.getValue();
                break;
            }
        }
    }
    if (portId == null || portId.isEmpty()) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Order Management</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;500;700&display=swap" rel="stylesheet">

    <!-- Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <!-- SweetAlert2 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        body {
            margin: 0;
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
            color: white;
            min-height: 100vh;
            padding: 0;
        }
        .wrapper { width: 100%; max-width: 600px; margin: 30px auto; }
        .card {
            background: rgba(255,255,255,0.05);
            border-radius: 20px;
            padding: 20px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.4);
            backdrop-filter: blur(12px);
        }
        h2 {
            font-weight: 700;
            font-size: 1.4em;
            margin-bottom: 15px;
            background: linear-gradient(90deg, #ff9966, #ff5e62);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .order-detail-item {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid rgba(255,255,255,0.15);
        }
        label { margin-top: 12px; display: block; font-weight: 500; }
        input, select {
            width: 100%; padding: 12px; border-radius: 8px; border: none;
            margin-top: 6px; font-size: 0.95em; outline: none;
        }
        .update-btn {
            margin-top: 20px; padding: 14px; border: none; border-radius: 10px;
            width: 100%;
            background: linear-gradient(90deg, #ff512f, #dd2476);
            color: white; font-size: 1.1em; font-weight: 600; cursor: pointer;
            transition: all 0.3s ease;
        }
        .update-btn:hover {
            transform: scale(1.05);
            background: linear-gradient(90deg, #dd2476, #ff512f);
        }
        .back-btn {
            margin-top: 15px;
            padding: 12px;
            border: none;
            border-radius: 10px;
            width: 100%;
            background: linear-gradient(90deg, #2193b0, #6dd5ed);
            color: white;
            font-size: 1em;
            font-weight: 600;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
        }
        .back-btn:hover {
            transform: scale(1.05);
            background: linear-gradient(90deg, #6dd5ed, #2193b0);
        }

        /* Navbar */
        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: linear-gradient(90deg, #2a1a5e, #451952);
            padding: 20px 50px;
            height: 100px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.4);
        }
        .navbar .logo { display: flex; align-items: center; font-size: 2rem; font-weight: 700; color: #ff4b91; }
        .navbar .logo img {
            height: 75px; width: 75px; margin-right: 15px; border-radius: 50%;
            box-shadow: 0 4px 15px rgba(255, 75, 145, 0.6);
            border: 2px solid rgba(255,255,255,0.4);
        }
        .nav-links { display: flex; gap: 50px; }
        .nav-links a {
            color: #f8f8f8; text-decoration: none; font-weight: 500;
            font-size: 1.1rem; position: relative; transition: all 0.3s ease;
        }
        .nav-links a:hover { color: #ff4b91; }
        .profile-btn {
            background: #ff4b91; color: white; padding: 12px 20px; border-radius: 30px;
            font-weight: bold; text-decoration: none; display: flex; align-items: center; gap: 8px;
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <div class="navbar">
        <div class="logo">
            <img src="image/logo.png" alt="Logo">
            <span>ImportExportERP</span>
        </div>
        <div class="nav-links">
            <a href="products.jsp">Products</a>
            <a href="ListOrdersServlet">Orders</a>
            <a href="reportedProducts.jsp">Reported Products</a>
        </div>
        <a href="profile.jsp" class="profile-btn"><i class="fas fa-user"></i> Profile</a>
    </div>

    <div class="wrapper">
        <%
            Order orderToUpdate = (Order) request.getAttribute("order");
            if (orderToUpdate != null) {
        %>
        <div class="card">
            <h2><i class="fas fa-edit"></i> Update Order</h2>

            <div class="order-detail-item">
                <span><i class="fas fa-receipt"></i> Order ID</span>
                <span>#<%= orderToUpdate.getOrderId() %></span>
            </div>
            <div class="order-detail-item">
                <span><i class="fas fa-user"></i> Buyer ID</span>
                <span><%= orderToUpdate.getBuyerId() %></span>
            </div>
            <div class="order-detail-item">
                <span><i class="fas fa-store"></i> Seller Port ID</span>
                <span><%= orderToUpdate.getSellerPortId() %></span>
            </div>
            <div class="order-detail-item">
                <span><i class="fas fa-box"></i> Product ID</span>
                <span><%= orderToUpdate.getProductId() %></span>
            </div>
            <div class="order-detail-item">
                <span><i class="fas fa-calendar"></i> Ordered On</span>
                <span><%= orderToUpdate.getOrderDate() %></span>
            </div>
            <div class="order-detail-item">
                <span><i class="fas fa-dollar-sign"></i> Total Amount</span>
                <span>$<%= orderToUpdate.getTotalAmount() %></span>
            </div>
            <div class="order-detail-item">
                <span><i class="fas fa-map-marker-alt"></i> Address</span>
                <span><%= orderToUpdate.getDeliveryAddress() %></span>
            </div>

            <!-- Update Form -->
            <form action="UpdateOrderServlet" method="post">
                <input type="hidden" name="orderId" value="<%= orderToUpdate.getOrderId() %>">

                <label><i class="fas fa-info-circle"></i> Order Status</label>
                <select name="status" required>
                    <option value="Pending"   <%= "Pending".equalsIgnoreCase(orderToUpdate.getStatus()) ? "selected" : "" %>>Pending</option>
                    <option value="Shipped"   <%= "Shipped".equalsIgnoreCase(orderToUpdate.getStatus()) ? "selected" : "" %>>Shipped</option>
                    <option value="Delivered" <%= "Delivered".equalsIgnoreCase(orderToUpdate.getStatus()) ? "selected" : "" %>>Delivered</option>
                    <option value="Cancelled" <%= "Cancelled".equalsIgnoreCase(orderToUpdate.getStatus()) ? "selected" : "" %>>Cancelled</option>
                </select>

                <label><i class="fas fa-map-marker-alt"></i> Delivery Address</label>
                <input type="text" name="deliveryAddress" value="<%= orderToUpdate.getDeliveryAddress() %>">

                <button type="submit" class="update-btn">
                    <i class="fas fa-save"></i> Save Changes
                </button>
            </form>

            <!-- Back to Orders Button -->
            <a href="ListOrdersServlet" class="back-btn"><i class="fas fa-arrow-left"></i> Back to Orders</a>
        </div>
        <% } %>
    </div>

    <!-- SweetAlert2 Popup Messages -->
    <script>
    (function () {
        const urlParams = new URLSearchParams(window.location.search);
        const message = urlParams.get('message');
        const error = urlParams.get('error');

        if (message) {
            Swal.fire({
                icon: 'success',
                title: 'Updated!',
                text: decodeURIComponent(message),
                timer: 2000,
                showConfirmButton: false
            });
        }

        if (error) {
            Swal.fire({
                icon: 'error',
                title: 'Update Failed',
                text: decodeURIComponent(error)
            });
        }
    })();
    </script>
</body>
</html>