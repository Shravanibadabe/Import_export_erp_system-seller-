package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import db_config.GetConnection;
import model.User;

public class UserDAO {

    // Fetch user by portId
    public User getUserByPortId(String portId) {
        User user = null;
        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE port_id=?")) {

            ps.setString(1, portId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                user = new User();
                user.setPortId(rs.getString("port_id"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setLocation(rs.getString("location"));
            }
            rs.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    // Update user details
    public String updateUser(User updatedUser) {
        String msg = "";
        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "UPDATE users SET name=?, email=?, password=?, location=? WHERE port_id=?")) {

            ps.setString(1, updatedUser.getName());
            ps.setString(2, updatedUser.getEmail());
            ps.setString(3, updatedUser.getPassword());
            ps.setString(4, updatedUser.getLocation());
            ps.setString(5, updatedUser.getPortId());

            int row = ps.executeUpdate();
            msg = (row > 0) ? "Profile updated successfully!" : "Update failed!";
        } catch (Exception e) {
            e.printStackTrace();
            msg = "Server error: " + e.getMessage();
        }
        return msg;
    }

    // Delete user and related data
    public boolean deleteUser(String portId) {
        boolean deleted = false;
        try (Connection con = GetConnection.getConnection()) {

            try (PreparedStatement ps1 = con.prepareStatement("DELETE FROM reported_products WHERE reporter_id=?")) {
                ps1.setString(1, portId);
                ps1.executeUpdate();
            }
            try (PreparedStatement ps2 = con.prepareStatement(
                    "DELETE FROM reported_products WHERE product_id IN (SELECT product_id FROM product WHERE seller_port_id=?)")) {
                ps2.setString(1, portId);
                ps2.executeUpdate();
            }
            try (PreparedStatement ps3 = con.prepareStatement(
                    "DELETE FROM orders WHERE product_id IN (SELECT product_id FROM product WHERE seller_port_id=?)")) {
                ps3.setString(1, portId);
                ps3.executeUpdate();
            }
            try (PreparedStatement ps4 = con.prepareStatement("DELETE FROM orders WHERE buyer_id=?")) {
                ps4.setString(1, portId);
                ps4.executeUpdate();
            }
            try (PreparedStatement ps5 = con.prepareStatement("DELETE FROM product WHERE seller_port_id=?")) {
                ps5.setString(1, portId);
                ps5.executeUpdate();
            }

            try (PreparedStatement ps6 = con.prepareStatement("DELETE FROM users WHERE port_id=?")) {
                ps6.setString(1, portId);
                int row = ps6.executeUpdate();
                deleted = row > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return deleted;
    }

    // Validation methods
    public boolean isValidName(String name) {
        return name != null && name.matches("[A-Za-z ]+");
    }

    public boolean isValidEmail(String email) {
        return email != null && email.matches("[a-z0-9._%+-]+@[a-z0-9.-]+\\.[a-z]{2,}$");
    }

    public boolean isValidPassword(String password) {
        return password != null && password.matches("(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[\\W_]).{8,}");
    }

    public boolean isValidLocation(String location) {
        return location != null && location.matches("[A-Za-z ]+");
    }
}