package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import db_config.GetConnection;
import model.Order;

public class OrderDAO {

    public List<Order> viewOrders() {
        return getAllOrders(); // reuse
    }

    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        String query = "SELECT * FROM orders";

        try (Connection conn = GetConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Order order = extractOrderFromResultSet(rs);
                list.add(order);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Order> getOrdersBySeller(String sellerPortId) {
        List<Order> list = new ArrayList<>();
        String query = "SELECT * FROM orders WHERE seller_port_id = ?";

        try (Connection conn = GetConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, sellerPortId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order order = extractOrderFromResultSet(rs);
                    list.add(order);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Order getOrderById(int orderId) {
        Order order = null;
        String query = "SELECT * FROM orders WHERE order_id = ?";

        try (Connection conn = GetConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    order = extractOrderFromResultSet(rs);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return order;
    }

    public boolean updateOrder(Order order) {
        String sql = "UPDATE orders SET status = ?, delivery_address = ? WHERE order_id = ?";
        try (Connection conn = GetConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, order.getStatus());
            stmt.setString(2, order.getDeliveryAddress());
            stmt.setInt(3, order.getOrderId());

            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private Order extractOrderFromResultSet(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setOrderId(rs.getInt("order_id"));
        order.setBuyerId(rs.getString("buyer_id"));
        order.setSellerPortId(rs.getString("seller_port_id"));
        order.setProductId(rs.getInt("product_id"));
        order.setOrderDate(rs.getTimestamp("order_date"));
        order.setTotalAmount(rs.getDouble("total_amount"));
        order.setStatus(rs.getString("status"));
        order.setDeliveryAddress(rs.getString("delivery_address"));
        return order;
    }
}
