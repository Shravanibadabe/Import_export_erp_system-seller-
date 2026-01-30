<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Order" %>
<%@ page import="model.Product" %>
<%@ page import="jakarta.servlet.http.Cookie" %>
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
<%
    Order order = (Order) request.getAttribute("order");
    Product product = (Product) request.getAttribute("product");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Order Details</title>
<style>
    /* Cinematic gradient + glow */
    @keyframes gradientShift { 0%{background-position:0% 50%} 50%{background-position:100% 50%} 100%{background-position:0% 50%} }
    body{
        margin:0; color:#fff; font-family:'Poppins',system-ui,-apple-system,Segoe UI,Roboto,Arial;
        background: linear-gradient(120deg,#0f172a,#1e293b,#0b132b,#1b2a41);
        background-size: 300% 300%; animation: gradientShift 16s ease infinite;
    }
    .container{ max-width:1100px; margin:60px auto; padding:0 18px; }
    .topbar{ display:flex; justify-content:space-between; align-items:center; margin-bottom:20px; }
    .back{ text-decoration:none; color:#ff4b91; border:1px solid #ff4b91; padding:8px 14px; border-radius:999px; transition:.25s; }
    .back:hover{ background:#ff4b91; color:#fff; box-shadow:0 8px 24px rgba(255,75,145,.35); transform: translateY(-1px); }

    .card{
        background: rgba(255,255,255,.06);
        border:1px solid rgba(255,255,255,.12);
        backdrop-filter: blur(10px);
        border-radius: 20px;
        padding: 26px;
        box-shadow: 0 10px 30px rgba(0,0,0,.35);
        animation: fadeIn .8s ease both;
    }
    @keyframes fadeIn{ from{opacity:0; transform: translateY(16px)} to{opacity:1; transform:none} }

    .headline{
        display:flex; align-items:center; gap:12px; margin:0 0 14px;
        font-size:28px; font-weight:700; color:#ff4b91; text-shadow:0 0 12px rgba(255,75,145,.4);
    }
    .grid{
        display:grid; grid-template-columns: 1.1fr .9fr; gap:22px;
    }
    .section{ padding:18px; border-radius:16px; background: rgba(255,255,255,.04); border:1px solid rgba(255,255,255,.08); }
    .section h3{ margin:0 0 10px; font-size:16px; letter-spacing:.4px; color:#cbd5e1; text-transform:uppercase }
    .kv{ display:grid; grid-template-columns: 170px 1fr; gap:10px 14px; font-size:15px; line-height:1.6 }
    .label{ color:#94a3b8; }
    .value{ color:#e2e8f0; font-weight:600 }
    .status{
        display:inline-flex; align-items:center; gap:8px; padding:6px 12px; border-radius:999px;
        background:#ffe08a; color:#111; font-weight:700; text-transform:uppercase; font-size:12px;
        box-shadow:0 0 10px rgba(255,224,138,.45);
    }
    .pill{ color:#ff4b91; font-weight:700 }
    .money{ font-size:22px; font-weight:800; color:#38f4c9; text-shadow:0 0 12px rgba(56,244,201,.4) }

    /* Product showcase card */
    .product{
        display:grid; grid-template-columns: 140px 1fr; gap:16px; align-items:center;
        background:rgba(255,255,255,.05); border:1px solid rgba(255,255,255,.08);
        padding:16px; border-radius:16px; transition:.25s;
    }
    .product:hover{ transform: translateY(-3px); box-shadow:0 12px 26px rgba(0,0,0,.35)}
    .product .thumb{
        height:140px; border-radius:14px; background:
        linear-gradient(145deg,rgba(255,75,145,.35),rgba(56,244,201,.25));
        display:flex; align-items:center; justify-content:center; font-size:40px; font-weight:900;
        color:#fff; letter-spacing:1px;
    }
    .product .name{ font-size:20px; font-weight:700; color:#f1f5f9; margin:0 0 6px }
    .product .meta{ color:#cbd5e1; font-size:14px; line-height:1.7 }
    .product .price{ margin-top:10px; font-size:18px; font-weight:800; color:#38f4c9 }

    .spacer{ height:20px }
</style>
</head>
<body>
<div class="container">

    <div class="topbar">
        <a class="back" href="ListOrdersServlet">← Back to Orders</a>
        <div></div>
    </div>

    <div class="card">
        <h2 class="headline">Order Details</h2>

        <% if (order == null) { %>
            <p>Order not found.</p>
        <% } else { %>

        <div class="grid">

            <!-- Left: Order meta -->
            <div class="section">
                <h3>Order Info</h3>
                <div class="kv">
                    <div class="label">Order ID</div>        <div class="value">#<%= order.getOrderId() %></div>
                    <div class="label">Buyer ID</div>        <div class="value"><%= order.getBuyerId() %></div>
                    <div class="label">Seller Port ID</div>  <div class="value"><%= order.getSellerPortId() %></div>
                    <div class="label">Order Date</div>      <div class="value"><%= order.getOrderDate() %></div>
                    <div class="label">Total Amount</div>    <div class="value money">₹<%= order.getTotalAmount() %></div>
                    <div class="label">Status</div>          <div class="value"><span class="status"><%= order.getStatus() %></span></div>
                </div>
            </div>

            <!-- Right: Delivery -->
            <div class="section">
                <h3>Delivery</h3>
                <div class="kv">
                    <div class="label">Address</div>
                    <div class="value"><%= order.getDeliveryAddress() %></div>
                    <div class="label">Product Ref</div>
                    <div class="value">ID: <span class="pill">#<%= order.getProductId() %></span></div>
                </div>
            </div>
        </div>

        <div class="spacer"></div>

        <!-- Product Showcase (single product from order.product_id) -->
        <div class="section">
            <h3>Product</h3>
            <% if (product != null) { %>
                <div class="product">
                    <div class="thumb">
                        <%= (product.getProduct_name() != null && !product.getProduct_name().isEmpty())
                            ? product.getProduct_name().substring(0,1).toUpperCase()
                            : "P" %>
                    </div>
                    <div>
                        <div class="name"><%= product.getProduct_name() %></div>
                        <div class="meta">
                            <div><strong>Seller Port:</strong> <%= product.getSeller_port_Id() %></div>
                            <div><strong>Description:</strong> <%= product.getDescription() %></div>
                            <div><strong>Quantity:</strong> <%= product.getQuantity() %></div>
                        </div>
                        <div class="price">Price: ₹<%= product.getPrice() %></div>
                    </div>
                </div>
            <% } else { %>
                <div class="value">No product found for this order.</div>
            <% } %>
        </div>

        <% } %>
    </div>
</div>
</body>
</html>
