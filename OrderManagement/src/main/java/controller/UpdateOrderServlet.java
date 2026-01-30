package controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import dao.OrderDAO;
import model.Order;

@WebServlet("/UpdateOrderServlet")
public class UpdateOrderServlet extends HttpServlet {

    private String getPortIdFromCookies(HttpServletRequest req) {
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("port_id".equals(cookie.getName())) {
                    return cookie.getValue();
                }
            }
        }
        return null;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String portId = getPortIdFromCookies(req);
        if (portId == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        try {
            String orderIdStr = req.getParameter("id");
            OrderDAO dao = new OrderDAO();

            if (orderIdStr != null && !orderIdStr.isBlank()) {
                int orderId = Integer.parseInt(orderIdStr);

                Order order = dao.getOrderById(orderId);
                if (order != null) {
                    req.setAttribute("order", order);
                } else {
                    resp.sendRedirect(req.getContextPath() + "/updateOrders.jsp?message=Order%20not%20found");
                    return;
                }
            }

            // Load seller-specific orders
            List<Order> orders = dao.getOrdersBySeller(portId);
            req.setAttribute("orders", orders);

            req.getRequestDispatcher("updateOrders.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/updateOrders.jsp?message=Error%20loading%20order");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String portId = getPortIdFromCookies(req);
        if (portId == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        try {
            int orderId = Integer.parseInt(req.getParameter("orderId"));
            String status = req.getParameter("status");
            String deliveryAddress = req.getParameter("deliveryAddress");

            Order order = new Order();
            order.setOrderId(orderId);
            order.setStatus(status);
            order.setDeliveryAddress(deliveryAddress);

            OrderDAO dao = new OrderDAO();
            boolean updated = dao.updateOrder(order);

            String ctx = req.getContextPath();
            if (updated) {
                resp.sendRedirect(ctx + "/UpdateOrderServlet?id=" + orderId + "&message=Order%20updated%20successfully");
            } else {
                resp.sendRedirect(ctx + "/UpdateOrderServlet?id=" + orderId + "&message=Failed%20to%20update%20order");
            }

        } catch (Exception e) {
            e.printStackTrace();
            String ctx = req.getContextPath();
            resp.sendRedirect(ctx + "/updateOrders.jsp?message=Error%20updating%20order");
        }
    }
}