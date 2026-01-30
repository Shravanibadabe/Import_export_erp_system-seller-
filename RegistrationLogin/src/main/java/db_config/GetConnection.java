package db_config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class GetConnection {

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        // ✅ Correct database name
        return DriverManager.getConnection("jdbc:mysql://localhost:3306/import_export_db", "root", "");
    }
 // Check if port_id exists
    public boolean isPortIdExist(String port_id) {
        String sql = "SELECT port_id FROM users WHERE port_id = ?";
        try (Connection con = getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {

            stmt.setString(1, port_id.trim());
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next(); // true if port_id exists
            }

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ✅ Fixed column names
    public boolean authenticate(String port_id , String password) {
        String sql = "SELECT * FROM users WHERE port_id = ? AND password = ?";
        try (Connection con = getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {

            stmt.setString(1, port_id .trim());
            stmt.setString(2, password.trim());

            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next(); // true if record exists
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
