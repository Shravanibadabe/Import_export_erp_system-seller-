package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import db_config.GetConnection;
import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String port_id = req.getParameter("port_id");
        String password = req.getParameter("password");

        GetConnection getConnection = new GetConnection();

        try {
            if (!getConnection.isPortIdExist(port_id)) {
                req.setAttribute("loginError", "❌ Port ID not found!");
                req.getRequestDispatcher("login.jsp").forward(req, resp);

            } else if (!getConnection.authenticate(port_id, password)) {
                req.setAttribute("loginError", "❌ Incorrect password!");
                req.getRequestDispatcher("login.jsp").forward(req, resp);

            } else {
                // ✅ Create cookie for login
                Cookie portCookie = new Cookie("port_id", port_id);
                portCookie.setPath("/");       // accessible for all pages
                portCookie.setMaxAge(60*60);   // 1 hour
                resp.addCookie(portCookie);

                resp.sendRedirect("dashboard.jsp"); // redirect after login
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("loginError", "❌ Something went wrong!");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
        }
    }
}
