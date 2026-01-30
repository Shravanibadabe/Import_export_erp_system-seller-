package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import db_config.GetConnection;
import model.Product;

public class ProductDAO {

    public List<Product> viewProduct() throws SQLException {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM product";

        try (Connection conn = GetConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Product product = new Product();
                product.setProduct_Id(rs.getInt("product_id"));
                product.setSeller_port_Id(rs.getString("seller_port_id"));
                product.setProduct_name(rs.getString("product_name"));
                product.setDescription(rs.getString("description"));
                product.setQuantity(rs.getInt("quantity"));
                product.setPrice(rs.getDouble("price"));
                list.add(product);
            }
        }
        return list;
    }

    public Product getProductById(int productId) throws SQLException {
        String sql = "SELECT * FROM product WHERE product_id = ?";
        Product product = null;

        try (Connection conn = GetConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    product = new Product();
                    product.setProduct_Id(rs.getInt("product_id"));
                    product.setSeller_port_Id(rs.getString("seller_port_id"));
                    product.setProduct_name(rs.getString("product_name"));
                    product.setDescription(rs.getString("description"));
                    product.setQuantity(rs.getInt("quantity"));
                    product.setPrice(rs.getDouble("price"));
                }
            }
        }
        return product;
    }
}
