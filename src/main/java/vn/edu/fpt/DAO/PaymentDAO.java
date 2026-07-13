package vn.edu.fpt.DAO;

import vn.edu.fpt.common.DBConnection;
import vn.edu.fpt.model.Payment;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class PaymentDAO {
    public static final String STATUS_PENDING = "Chờ thanh toán";
    public static final String STATUS_PAID = "Đã thanh toán";
    public static final String STATUS_FAILED = "Thất bại";
    public static final String STATUS_CANCELLED = "Đã hủy";

    public Payment findByBookingID(int bookingID) {
        String sql = "SELECT TOP (1) * FROM [dbo].[Payments] WHERE bookingID = ? ORDER BY paymentID DESC";
        return findOne(sql, bookingID);
    }

    public Payment createPending(int bookingID, BigDecimal amount) {
        Payment existing = findByBookingID(bookingID);
        if (existing != null) {
            return existing;
        }

        String sql = """
                INSERT INTO [dbo].[Payments]
                    (bookingID, payment_method, totalAmount, [status], paymentType,
                     transactionCode, paymentDate, note, createdAt)
                VALUES (?, N'PayOS', ?, ?, N'Thanh toán toàn bộ', ?, NULL,
                        N'Khởi tạo thanh toán PayOS', GETDATE())
                """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, bookingID);
            ps.setBigDecimal(2, amount);
            ps.setNString(3, STATUS_PENDING);
            ps.setString(4, String.valueOf(bookingID));

            if (ps.executeUpdate() > 0) {
                return findByBookingID(bookingID);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean prepareCheckout(int bookingID) {
        String sql = """
                UPDATE [dbo].[Payments]
                SET transactionCode = ?, [status] = ?, note = N'Đã tạo liên kết PayOS'
                WHERE bookingID = ? AND [status] NOT IN (?, N'Paid')
                """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, String.valueOf(bookingID));
            ps.setNString(2, STATUS_PENDING);
            ps.setInt(3, bookingID);
            ps.setNString(4, STATUS_PAID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean markPaidByBookingID(int bookingID, String transactionCode) {
        String sql = """
                UPDATE [dbo].[Payments]
                SET [status] = ?, transactionCode = ?, paymentDate = GETDATE(),
                    note = N'PayOS xác nhận thanh toán thành công'
                WHERE bookingID = ?
                """;
        return update(sql, STATUS_PAID, transactionCode, bookingID);
    }

    public boolean markCancelledByBookingID(int bookingID, String note) {
        return updatePendingStatus(bookingID, STATUS_CANCELLED, note);
    }

    public boolean markFailedByBookingID(int bookingID, String note) {
        return updatePendingStatus(bookingID, STATUS_FAILED, note);
    }

    private boolean updatePendingStatus(int bookingID, String status, String note) {
        String sql = """
                UPDATE [dbo].[Payments]
                SET [status] = ?, note = ?
                WHERE bookingID = ? AND [status] IN (?, N'Pending')
                """;
        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setNString(1, status);
            ps.setNString(2, note);
            ps.setInt(3, bookingID);
            ps.setNString(4, STATUS_PENDING);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private boolean update(String sql, String status, String transactionCode, int bookingID) {
        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setNString(1, status);
            ps.setString(2, transactionCode);
            ps.setInt(3, bookingID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private Payment findOne(String sql, int value) {
        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, value);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapPayment(rs) : null;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    private Payment mapPayment(ResultSet rs) throws SQLException {
        Payment payment = new Payment();
        payment.setPaymentID(rs.getInt("paymentID"));
        payment.setBookingID(rs.getInt("bookingID"));
        payment.setPaymentMethod(rs.getString("payment_method"));
        payment.setTotalAmount(rs.getBigDecimal("totalAmount"));
        payment.setStatus(rs.getString("status"));
        payment.setPaymentType(rs.getString("paymentType"));
        payment.setTransactionCode(rs.getString("transactionCode"));
        payment.setPaymentDate(rs.getTimestamp("paymentDate"));
        payment.setNote(rs.getString("note"));
        payment.setCreatedAt(rs.getTimestamp("createdAt"));
        return payment;
    }
}
