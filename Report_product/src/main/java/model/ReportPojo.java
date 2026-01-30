package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.sql.Timestamp;
import db_config.GetConnection;

public class ReportPojo {
    private int reportId;
    private int productId;
    private String reporterId;
    private String reason;
    private String status;
    private Timestamp reportedAt;  // NEW

    // Getters and Setters
    public int getReportId() { return reportId; }
    public void setReportId(int reportId) { this.reportId = reportId; }
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    public String getReporterId() { return reporterId; }
    public void setReporterId(String reporterId) { this.reporterId = reporterId; }
    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Timestamp getReportedAt() { return reportedAt; } // NEW
    public void setReportedAt(Timestamp reportedAt) { this.reportedAt = reportedAt; } // NEW

    public static List<ReportPojo> getReports(String portId, String filter) throws Exception {
        List<ReportPojo> list = new ArrayList<>();
        Connection con = GetConnection.getConnection();

        String query = "SELECT r.* FROM reported_products r " +
                       "JOIN product p ON r.product_id = p.product_id " +
                       "WHERE p.seller_port_id = ?";

        if (!"all".equalsIgnoreCase(filter)) {
            query += " AND r.status = ?";
        }

        PreparedStatement ps = con.prepareStatement(query);
        ps.setString(1, portId);
        if (!"all".equalsIgnoreCase(filter)) {
            ps.setString(2, filter);
        }

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            ReportPojo report = new ReportPojo();
            report.setReportId(rs.getInt("report_id"));
            report.setProductId(rs.getInt("product_id"));
            report.setReporterId(rs.getString("reporter_id"));
            report.setReason(rs.getString("reason"));
            report.setStatus(rs.getString("status"));
            report.setReportedAt(rs.getTimestamp("reported_at")); // NEW
            list.add(report);
        }

        rs.close();
        ps.close();
        con.close();
        return list;
    }

    public static void resolveReport(int reportId) throws Exception {
        Connection con = GetConnection.getConnection();
        PreparedStatement ps = con.prepareStatement(
            "UPDATE reported_products SET status='resolved' WHERE report_id=?"
        );
        ps.setInt(1, reportId);
        ps.executeUpdate();
        con.close();
    }
}
