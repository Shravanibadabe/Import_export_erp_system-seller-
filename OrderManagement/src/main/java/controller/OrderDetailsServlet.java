package controller;

import java.io.IOException;
import java.sql.SQLException;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import dao.OrderDAO;
import dao.ProductDAO;
import model.Order;
import model.Product;

@WebServlet("/OrderDetailsServlet")
public class OrderDetailsServlet extends HttpServlet {

    private String getPortIdFromCookies(HttpServletRequest req) {
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("port_id")) {
                    return cookie.getValue();
                }
            }
        }
        return null;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String portId = getPortIdFromCookies(request);
        if (portId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Order ID is missing.");
            return;
        }

        int orderId;
        try {
            orderId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Order ID.");
            return;
        }

        OrderDAO orderDAO = new OrderDAO();
        ProductDAO productDAO = new ProductDAO();

        Order order = orderDAO.getOrderById(orderId);
        if (order == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Order not found.");
            return;
        }

        Product product = null;
        try {
            product = productDAO.getProductById(order.getProductId());
        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.setAttribute("order", order);
        request.setAttribute("product", product);
        request.getRequestDispatcher("orderDetails.jsp").forward(request, response);
    }
}
