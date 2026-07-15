package vn.edu.fpt.DAO;

import vn.edu.fpt.common.DBConnection;
import vn.edu.fpt.model.Payment;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PaymentDAO {
    public static final String STATUS_PENDING = "Pending";
    public static final String STATUS_PAID = "Paid";
    public static final String STATUS_FAILED = "Failed";
    public static final String STATUS_CANCELLED = "Cancelled";

    public Payment findByBookingID(int bookingID) {
        return findOne("SELECT TOP (1) * FROM [dbo].[Payment] WHERE bookingID = ? ORDER BY paymentID DESC",
                bookingID);
    }

    public Payment createPending(int bookingID, BigDecimal amount) {
        Payment existing = findByBookingID(bookingID);
        if (existing != null) {
            return existing;
        }

        String sql = """
                INSERT INTO [dbo].[Payment]
                    (bookingID, payosOrderCode, totalAmount, [status], transactionCode,
                     checkoutUrl, paymentDate, expiredAt, note, createdAt)
                VALUES (?, ?, ?, N'Pending', NULL, NULL, NULL, DATEADD(MINUTE, 15, GETDATE()),
                        N'Khởi tạo thanh toán PayOS', GETDATE())
                """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingID);
            ps.setLong(2, bookingID);
            ps.setBigDecimal(3, amount);
            ps.executeUpdate();
        } catch (Exception e) {
            // A concurrent request may have inserted the unique booking payment first.
            Payment concurrent = findByBookingID(bookingID);
            if (concurrent != null) {
                return concurrent;
            }
            e.printStackTrace();
            return null;
        }
        return findByBookingID(bookingID);
    }

    public boolean prepareCheckout(int bookingID, String checkoutUrl) {
        String sql = """
                UPDATE [dbo].[Payment]
                SET payosOrderCode = ?, transactionCode = ?, [status] = N'Pending',
                    checkoutUrl = ?,
                    expiredAt = DATEADD(MINUTE, 15, GETDATE()),
                    note = N'Đã tạo mã QR PayOS'
                WHERE bookingID = ? AND [status] <> N'Paid'
                """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, bookingID);
            ps.setString(2, String.valueOf(bookingID));
            ps.setString(3, checkoutUrl);
            ps.setInt(4, bookingID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean markPaidByBookingID(int bookingID, String transactionCode) {
        String sql = """
                UPDATE [dbo].[Payment]
                SET [status] = N'Paid', transactionCode = ?, paymentDate = GETDATE(),
                    checkoutUrl = NULL, expiredAt = NULL, note = N'Đã thanh toán thành công'
                WHERE bookingID = ? AND [status] = N'Pending'
                  AND LEFT(ISNULL(note, N''), 15) <> N'[SLOT_RELEASED]'
                """;
        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, transactionCode);
            ps.setInt(2, bookingID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean markCancelledByBookingID(int bookingID, String note) {
        return updatePendingStatus(bookingID, STATUS_CANCELLED, note);
    }

    public boolean markFailedByBookingID(int bookingID, String note) {
        return updatePendingStatus(bookingID, STATUS_FAILED, note);
    }

    public List<Integer> findExpiredPendingBookingIDs() {
        String sql = """
                SELECT bookingID FROM [dbo].[Payment]
                WHERE [status] = N'Pending' AND expiredAt IS NOT NULL AND expiredAt <= GETDATE()
                """;
        List<Integer> bookingIDs = new ArrayList<>();
        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                bookingIDs.add(rs.getInt("bookingID"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return bookingIDs;
    }

    private boolean updatePendingStatus(int bookingID, String status, String note) {
        String sql = """
                UPDATE [dbo].[Payment]
                SET [status] = ?, note = ?
                WHERE bookingID = ? AND [status] = N'Pending'
                """;
        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setNString(1, status);
            ps.setNString(2, note);
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
        payment.setTotalAmount(rs.getBigDecimal("totalAmount"));
        payment.setStatus(rs.getString("status"));
        long orderCode = rs.getLong("payosOrderCode");
        payment.setPayosOrderCode(rs.wasNull() ? null : orderCode);
        payment.setTransactionCode(rs.getString("transactionCode"));
        payment.setCheckoutUrl(rs.getString("checkoutUrl"));
        payment.setPaymentDate(rs.getTimestamp("paymentDate"));
        payment.setExpiredAt(rs.getTimestamp("expiredAt"));
        payment.setNote(rs.getString("note"));
        payment.setCreatedAt(rs.getTimestamp("createdAt"));
        return payment;
    }
}
