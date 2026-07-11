package vn.edu.fpt.DAO;

import vn.edu.fpt.common.DBConnection;
import vn.edu.fpt.model.Payment;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class PaymentDAO {

    // Lấy bản ghi thanh toán theo bookingID.
    public Payment findByBookingID(int bookingID) {
        return findOne("SELECT * FROM Payment WHERE bookingID = ?", bookingID);
    }

    // Lấy bản ghi thanh toán theo mã đơn PayOS.
    public Payment findByOrderCode(long orderCode) {
        return findOne("SELECT * FROM Payment WHERE payosOrderCode = ?", orderCode);
    }

    // Tạo payment ở trạng thái chờ nếu booking chưa có payment.
    public Payment createPending(int bookingID, BigDecimal amount) {
        Payment existing = findByBookingID(bookingID);
        if (existing != null) {
            return existing;
        }

        String sql = """
            INSERT INTO Payment (bookingID, payosOrderCode, totalAmount, status, note)
            VALUES (?, ?, ?, N'Pending', N'PayOS pending payment')
            """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookingID);
            ps.setLong(2, bookingID);
            ps.setBigDecimal(3, amount);

            if (ps.executeUpdate() > 0) {
                return findByBookingID(bookingID);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // Chuẩn bị phiên checkout mới cho booking chưa thanh toán.
    public boolean prepareCheckout(int bookingID) {
        String sql = """
            UPDATE Payment
            SET
                payosOrderCode = ?,
                expiredAt = DATEADD(MINUTE, 15, GETDATE()),
                status = N'Pending',
                note = N'PayOS checkout created'
            WHERE bookingID = ?
              AND status <> N'Paid'
            """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, bookingID);
            ps.setInt(2, bookingID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // Đánh dấu thanh toán thành công theo mã đơn PayOS.
    public boolean markPaidByOrderCode(long orderCode, String transactionCode) {
        String sql = """
            UPDATE Payment
            SET
                status = N'Paid',
                transactionCode = ?,
                paymentDate = GETDATE()
            WHERE payosOrderCode = ?
            """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, transactionCode);
            ps.setLong(2, orderCode);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // Đánh dấu thanh toán thành công theo bookingID.
    public boolean markPaidByBookingID(int bookingID, String transactionCode) {
        String sql = """
            UPDATE Payment
            SET
                status = N'Paid',
                transactionCode = ?,
                paymentDate = GETDATE()
            WHERE bookingID = ?
            """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, transactionCode);
            ps.setInt(2, bookingID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // Đánh dấu giao dịch thất bại theo mã đơn PayOS.
    public boolean markFailedByOrderCode(long orderCode, String note) {
        String sql = """
            UPDATE Payment
            SET status = N'Failed', note = ?
            WHERE payosOrderCode = ?
              AND status = N'Pending'
            """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, note);
            ps.setLong(2, orderCode);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // Đánh dấu payment pending của booking là đã hủy.
    public boolean markCancelledByBookingID(int bookingID, String note) {
        return updatePendingStatusByBookingID(bookingID, "Cancelled", note, false);
    }

    // Đánh dấu payment pending của booking là thất bại.
    public boolean markFailedByBookingID(int bookingID, String note) {
        return updatePendingStatusByBookingID(bookingID, "Failed", note, false);
    }

    // Đánh dấu payment pending đã hết hạn theo booking.
    public boolean markExpiredByBookingID(int bookingID, String note) {
        return updatePendingStatusByBookingID(bookingID, "Failed", note, true);
    }

    // Chạy query lấy một payment duy nhất theo tham số đầu vào.
    private Payment findOne(String sql, long value) {
        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, value);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapPayment(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // Map một dòng ResultSet thành đối tượng Payment.
    private Payment mapPayment(ResultSet rs) throws SQLException {
        Payment payment = new Payment();
        payment.setPaymentID(rs.getInt("paymentID"));
        payment.setBookingID(rs.getInt("bookingID"));

        long orderCode = rs.getLong("payosOrderCode");
        payment.setPayosOrderCode(rs.wasNull() ? null : orderCode);

        payment.setTotalAmount(rs.getBigDecimal("totalAmount"));
        payment.setStatus(rs.getString("status"));
        payment.setTransactionCode(rs.getString("transactionCode"));
        payment.setExpiredAt(rs.getTimestamp("expiredAt"));
        payment.setPaymentDate(rs.getTimestamp("paymentDate"));
        payment.setNote(rs.getString("note"));
        payment.setCreatedAt(rs.getTimestamp("createdAt"));
        return payment;
    }

    // Cập nhật trạng thái pending theo booking, có thể kèm điều kiện hết hạn.
    private boolean updatePendingStatusByBookingID(int bookingID,
                                                   String status,
                                                   String note,
                                                   boolean expiredOnly) {
        String sql = """
            UPDATE Payment
            SET status = ?, note = ?
            WHERE bookingID = ?
              AND status = N'Pending'
            """
                + (expiredOnly ? " AND expiredAt IS NOT NULL AND expiredAt <= GETDATE()" : "");

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setString(2, note);
            ps.setInt(3, bookingID);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}
