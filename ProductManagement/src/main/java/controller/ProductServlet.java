package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Product_pojo;

@WebServlet("/ProductServlet")
public class ProductServlet extends HttpServlet {

    // Get the logged-in seller port ID from cookies
    private String getLoggedPortId(HttpServletRequest req) {
        if (req.getCookies() != null) {
            for (Cookie c : req.getCookies()) {
                if ("port_id".equals(c.getName())) {
                    return c.getValue();
                }
            }
        }
        return null;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String portId = getLoggedPortId(req);
        if (portId == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        Product_pojo pojo = new Product_pojo();
        pojo.setSeller_port_id(portId);

        try {
            List<Product_pojo> products = pojo.getAllProductsBySeller();
            req.setAttribute("products", products);
        } catch (SQLException e) {
            req.setAttribute("message", "❌ Error fetching product list: " + e.getMessage());
        }

        req.getRequestDispatcher("products.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String portId = getLoggedPortId(req);
        if (portId == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        Product_pojo pojo = new Product_pojo();
        pojo.setSeller_port_id(portId);

        String message = "";
        try {
            String productName = req.getParameter("productname");
            String originalName = req.getParameter("original_productname"); // hidden field from form

            if (req.getParameter("Add") != null || req.getParameter("Update") != null) {
                pojo.setQuantity(Integer.parseInt(req.getParameter("quantity")));
                pojo.setPrice(Double.parseDouble(req.getParameter("price")));
                pojo.setDescription(req.getParameter("description"));
            }

            if (req.getParameter("Add") != null) {
                pojo.setProductname(productName);
                pojo.Add_product();
                message = "✅ Product added successfully!";
            } else if (req.getParameter("Update") != null) {
                if (originalName == null || originalName.isEmpty()) {
                    message = "❌ Error: Original product name missing!";
                } else {
                    pojo.setProductname(originalName); // Set original name for WHERE clause
                    pojo.Update_product(productName);  // Update to new name & other details
                    message = "✏️ Product updated successfully!";
                }
            } else if (req.getParameter("Delete") != null) {
                pojo.setProductname(productName);
                pojo.Delete_product();
                message = "🗑️ Product deleted successfully!";
            }
        } catch (Exception e) {
            message = "❌ Error: " + e.getMessage();
        }

        req.setAttribute("message", message);
        doGet(req, resp); // Refresh product list after any operation
    }
}
