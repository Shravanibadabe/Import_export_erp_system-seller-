package controller;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import dao.OrderDAO;
import model.Order;

@WebServlet("/ListOrdersServlet")
public class ListOrdersServlet extends HttpServlet {

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
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String portId = getPortIdFromCookies(req);
        if (portId == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        OrderDAO dao = new OrderDAO();
        List<Order> orders;

        String sellerPortId = req.getParameter("seller_port_id");
        if (sellerPortId != null && !sellerPortId.trim().isEmpty()) {
            orders = dao.getOrdersBySeller(sellerPortId);
        } else {
            orders = dao.getOrdersBySeller(portId);
        }

        req.setAttribute("orders", orders);
        req.getRequestDispatcher("vieworder.jsp").forward(req, resp);
    }
}
