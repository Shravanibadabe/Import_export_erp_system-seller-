package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import db_config.GetConnection;

public class Register_pojo {
    private String port_id;
    private String name;
    private String email;
    private String password;
    private String location;

    // Getters and setters
    public String getPort_id() { return port_id; }
    public void setPort_id(String port_id) { this.port_id = port_id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    // Insert user into DB
    public void insertUser() throws Exception {
        String sql = "INSERT INTO users (port_id, name, email, password, location) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, port_id);
            ps.setString(2, name);
            ps.setString(3, email);
            ps.setString(4, password);
            ps.setString(5, location);

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new Exception("Error inserting user: " + e.getMessage());
        }
    }
}
