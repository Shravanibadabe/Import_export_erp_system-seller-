package model;

import java.sql.Timestamp;

public class Order {

    private int orderId;                // order_id
    private String buyerId;             // buyer_id
    private String sellerPortId;        // seller_port_id
    private Timestamp orderDate;        // order_date
    private double totalAmount;         // total_amount
    private String status;              // status (pending/shipped/delivered/cancelled)
    private String deliveryAddress;     // delivery_address
    private int productId;              // product_id

    // Default constructor
    public Order() {}

    // Parameterized constructor
    public Order(int orderId, String buyerId, String sellerPortId, Timestamp orderDate,
                 double totalAmount, String status, String deliveryAddress, int productId) {
        this.orderId = orderId;
        this.buyerId = buyerId;
        this.sellerPortId = sellerPortId;
        this.orderDate = orderDate;
        this.totalAmount = totalAmount;
        this.status = status;
        this.deliveryAddress = deliveryAddress;
        this.productId = productId;
    }

    // Getters and Setters
    public int getOrderId() {
        return orderId;
    }
    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public String getBuyerId() {
        return buyerId;
    }
    public void setBuyerId(String buyerId) {
        this.buyerId = buyerId;
    }

    public String getSellerPortId() {
        return sellerPortId;
    }
    public void setSellerPortId(String sellerPortId) {
        this.sellerPortId = sellerPortId;
    }

    public Timestamp getOrderDate() {
        return orderDate;
    }
    public void setOrderDate(Timestamp orderDate) {
        this.orderDate = orderDate;
    }

    public double getTotalAmount() {
        return totalAmount;
    }
    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }

    public String getDeliveryAddress() {
        return deliveryAddress;
    }
    public void setDeliveryAddress(String deliveryAddress) {
        this.deliveryAddress = deliveryAddress;
    }

    public int getProductId() {
        return productId;
    }
    public void setProductId(int productId) {
        this.productId = productId;
    }
}
