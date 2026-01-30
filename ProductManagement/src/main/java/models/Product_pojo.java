package models;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import db_config.GetConnection;

public class Product_pojo {

    private int productId;
    private String seller_port_id;
    private String productname;
    private String description;
    private int quantity;
    private double price;

    // Getters & Setters
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public String getSeller_port_id() { return seller_port_id; }
    public void setSeller_port_id(String seller_port_id) { this.seller_port_id = seller_port_id; }

    public String getProductname() { return productname; }
    public void setProductname(String productname) { this.productname = productname; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    // Fetch all products for this seller
    public List<Product_pojo> getAllProductsBySeller() throws SQLException {
        List<Product_pojo> list = new ArrayList<>();
        String sql = "SELECT * FROM product WHERE seller_port_id=?";
        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, seller_port_id);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product_pojo p = new Product_pojo();
                p.setProductId(rs.getInt("product_id"));
                p.setSeller_port_id(rs.getString("seller_port_id"));
                p.setProductname(rs.getString("product_name"));
                p.setDescription(rs.getString("description"));
                p.setQuantity(rs.getInt("quantity"));
                p.setPrice(rs.getDouble("price"));
                list.add(p);
            }
        }
        return list;
    }

    // Add product
 // Add this method inside Product_pojo class
    public void Add_product() throws SQLException {
        String sql = "INSERT INTO product (seller_port_id, product_name, description, quantity, price) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, seller_port_id);
            ps.setString(2, productname);
            ps.setString(3, description);
            ps.setInt(4, quantity);
            ps.setDouble(5, price);
            ps.executeUpdate();
        }
    }

 // Update product (product_name can now be updated)
    public void Update_product(String newProductName) throws SQLException {
        String sql = "UPDATE product SET product_name=?, description=?, quantity=?, price=? WHERE seller_port_id=? AND product_name=?";
        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, newProductName);      // New product name
            ps.setString(2, description);
            ps.setInt(3, quantity);
            ps.setDouble(4, price);
            ps.setString(5, seller_port_id);
            ps.setString(6, productname);         // Original product name
            ps.executeUpdate();
        }
    }


    // Update product
    public void Update_product() throws SQLException {
        String sql = "UPDATE product SET description=?, quantity=?, price=? WHERE seller_port_id=? AND product_name=?";
        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, description);
            ps.setInt(2, quantity);
            ps.setDouble(3, price);
            ps.setString(4, seller_port_id);
            ps.setString(5, productname);
            ps.executeUpdate();
        }
    }

    // Delete product along with its reported entries
    public void Delete_product() throws SQLException {
        String deleteReports = "DELETE FROM reported_products WHERE product_id = ?";
        String deleteOrders  = "DELETE FROM orders WHERE product_id = ?";
        String deleteProduct = "DELETE FROM product WHERE seller_port_id=? AND product_name=?";

        try (Connection con = GetConnection.getConnection()) {
            // 1. Get product_id of this product
            int pid = -1;
            String getIdSQL = "SELECT product_id FROM product WHERE seller_port_id=? AND product_name=?";
            try (PreparedStatement psGet = con.prepareStatement(getIdSQL)) {
                psGet.setString(1, seller_port_id);
                psGet.setString(2, productname);
                try (ResultSet rs = psGet.executeQuery()) {
                    if (rs.next()) pid = rs.getInt("product_id");
                }
            }

            if (pid != -1) {
                // 2. Delete related reported_products entries
                try (PreparedStatement psDelReports = con.prepareStatement(deleteReports)) {
                    psDelReports.setInt(1, pid);
                    psDelReports.executeUpdate();
                }

                // 3. Delete related orders
                try (PreparedStatement psDelOrders = con.prepareStatement(deleteOrders)) {
                    psDelOrders.setInt(1, pid);
                    psDelOrders.executeUpdate();
                }

                // 4. Delete the product itself
                try (PreparedStatement psDelProduct = con.prepareStatement(deleteProduct)) {
                    psDelProduct.setString(1, seller_port_id);
                    psDelProduct.setString(2, productname);
                    psDelProduct.executeUpdate();
                }
            }
        }
    }


    }
