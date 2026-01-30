package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import db_config.GetConnection;

@WebServlet("/Registerserv")
public class Registerserv extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String portId = req.getParameter("port_id");
        String password = req.getParameter("password");
        String location = req.getParameter("location");
        String name = req.getParameter("name");
        String email = req.getParameter("email");

        System.out.println("Received Data -> Port ID: " + portId + ", Email: " + email);

        try (Connection con = GetConnection.getConnection()) {

            // Check if port_id exists
            PreparedStatement checkPort = con.prepareStatement("SELECT port_id FROM users WHERE port_id=?");
            checkPort.setString(1, portId);
            ResultSet rsPort = checkPort.executeQuery();
            if (rsPort.next()) {
                req.setAttribute("portIdError", "❌ Port ID already exists!");
                req.getRequestDispatcher("register.jsp").forward(req, resp);
                return;
            }

            // Check if email exists
            PreparedStatement checkEmail = con.prepareStatement("SELECT email FROM users WHERE email=?");
            checkEmail.setString(1, email);
            ResultSet rsEmail = checkEmail.executeQuery();
            if (rsEmail.next()) {
                req.setAttribute("emailError", "❌ Email already registered!");
                req.getRequestDispatcher("register.jsp").forward(req, resp);
                return;
            }

            // Validate password (8+ chars, uppercase, lowercase, number, special char)
            if (!password.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@#$%^&+=!]).{8,}$")) {
                req.setAttribute("passwordError", "❌ Password must be 8+ chars with uppercase, lowercase, number & special char!");
                req.getRequestDispatcher("register.jsp").forward(req, resp);
                return;
            }

            // Insert user into database
            PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO users (port_id, password, location, name, email) VALUES (?, ?, ?, ?, ?)");
            ps.setString(1, portId);
            ps.setString(2, password); // plain password for now
            ps.setString(3, location);
            ps.setString(4, name);
            ps.setString(5, email);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                resp.sendRedirect("login.jsp"); // successful registration
            } else {
                req.setAttribute("errorMsg", "❌ Registration failed. Try again.");
                req.getRequestDispatcher("register.jsp").forward(req, resp);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("errorMsg", "❌ SQL Error: " + e.getMessage());
            req.getRequestDispatcher("register.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMsg", "❌ Something went wrong: " + e.getMessage());
            req.getRequestDispatcher("register.jsp").forward(req, resp);
        }
    }
}
