package vn.edu.fpt.DAO;

import vn.edu.fpt.common.DBConnection;
import vn.edu.fpt.model.Payment;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class PaymentDAO {
    public static final String STATUS_PENDING = "Pending";
    public static final String STATUS_PAID = "Paid";
    public static final String STATUS_FAILED = "Failed";
    public static final String STATUS_CANCELLED = "Cancelled";

    public Payment findByBookingID(int bookingID) {
        return findOne("SELECT TOP (1) * FROM [dbo].[Payments] WHERE bookingID = ? ORDER BY paymentID DESC",
                bookingID);
    }

    public Payment createPending(int bookingID, BigDecimal amount) {
        Payment existing = findByBookingID(bookingID);
        if (existing != null) {
            return existing;
        }

        boolean hasPaymentMethod = hasPaymentColumn("payment_method");
        boolean hasPaymentType = hasPaymentColumn("paymentType");
        boolean hasPayosOrderCode = hasPaymentColumn("payosOrderCode");
        boolean hasCheckoutUrl = hasPaymentColumn("checkoutUrl");
        boolean hasExpiredAt = hasPaymentColumn("expiredAt");
        StringBuilder sql = new StringBuilder("""
                INSERT INTO [dbo].[Payments]
                    (bookingID, %s totalAmount, [status], %s %s transactionCode,
                     %s paymentDate, %s note, createdAt)
                VALUES (?, %s ?, N'Pending', %s %s NULL,
                     %s NULL, %s N'Khởi tạo thanh toán PayOS', GETDATE())
                """.formatted(
                hasPaymentMethod ? "payment_method, " : "",
                hasPaymentType ? "paymentType, " : "",
                hasPayosOrderCode ? "payosOrderCode, " : "",
                hasCheckoutUrl ? "checkoutUrl, " : "",
                hasExpiredAt ? "expiredAt, " : "",
                hasPaymentMethod ? "N'PayOS', " : "",
                hasPaymentType ? "N'Online', " : "",
                hasPayosOrderCode ? "?, " : "",
                hasCheckoutUrl ? "NULL, " : "",
                hasExpiredAt ? "DATEADD(MINUTE, 15, GETDATE()), " : ""));

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setInt(1, bookingID);
            int index = 2;
            if (hasPayosOrderCode) {
                ps.setLong(index++, bookingID);
            }
            ps.setBigDecimal(index, amount);
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
        boolean hasPayosOrderCode = hasPaymentColumn("payosOrderCode");
        boolean hasCheckoutUrl = hasPaymentColumn("checkoutUrl");
        boolean hasExpiredAt = hasPaymentColumn("expiredAt");
        String sql = """
                UPDATE [dbo].[Payments]
                SET %s transactionCode = ?, [status] = N'Pending',
                    %s
                    %s
                    note = N'Đã tạo mã QR PayOS'
                WHERE bookingID = ? AND [status] <> N'Paid'
                """.formatted(
                hasPayosOrderCode ? "payosOrderCode = ?, " : "",
                hasCheckoutUrl ? "checkoutUrl = ?," : "",
                hasExpiredAt ? "expiredAt = DATEADD(MINUTE, 15, GETDATE())," : "");

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int index = 1;
            if (hasPayosOrderCode) {
                ps.setLong(index++, bookingID);
            }
            ps.setString(index++, String.valueOf(bookingID));
            if (hasCheckoutUrl) {
                ps.setString(index++, checkoutUrl);
            }
            ps.setInt(index, bookingID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean markPaidByBookingID(int bookingID, String transactionCode) {
        boolean hasCheckoutUrl = hasPaymentColumn("checkoutUrl");
        boolean hasExpiredAt = hasPaymentColumn("expiredAt");
        String sql = """
                UPDATE [dbo].[Payments]
                SET [status] = N'Paid', transactionCode = ?, paymentDate = GETDATE(),
                    %s %s note = N'Đã thanh toán thành công'
                WHERE bookingID = ? AND [status] = N'Pending'
                  AND LEFT(ISNULL(note, N''), 15) <> N'[SLOT_RELEASED]'
                """.formatted(
                hasCheckoutUrl ? "checkoutUrl = NULL, " : "",
                hasExpiredAt ? "expiredAt = NULL, " : "");
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
        boolean hasExpiredAt = hasPaymentColumn("expiredAt");
        String sql = """
                SELECT bookingID FROM [dbo].[Payments]
                WHERE [status] = N'Pending'
                  AND LEFT(ISNULL(note, N''), 15) <> N'[SLOT_RELEASED]'
                  AND %s
                """.formatted(hasExpiredAt
                ? "expiredAt IS NOT NULL AND expiredAt <= GETDATE()"
                : "createdAt <= DATEADD(MINUTE, -15, GETDATE())");
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
                UPDATE [dbo].[Payments]
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
        if (hasColumn(rs, "payosOrderCode")) {
            long orderCode = rs.getLong("payosOrderCode");
            payment.setPayosOrderCode(rs.wasNull() ? null : orderCode);
        }
        if (hasColumn(rs, "payment_method")) {
            payment.setPaymentMethod(rs.getString("payment_method"));
        }
        if (hasColumn(rs, "paymentType")) {
            payment.setPaymentType(rs.getString("paymentType"));
        }
        if (hasColumn(rs, "transactionCode")) {
            payment.setTransactionCode(rs.getString("transactionCode"));
        }
        if (hasColumn(rs, "checkoutUrl")) {
            payment.setCheckoutUrl(rs.getString("checkoutUrl"));
        }
        if (hasColumn(rs, "paymentDate")) {
            payment.setPaymentDate(rs.getTimestamp("paymentDate"));
        }
        if (hasColumn(rs, "expiredAt")) {
            payment.setExpiredAt(rs.getTimestamp("expiredAt"));
        } else if (hasColumn(rs, "createdAt") && !payment.isPaid()) {
            Timestamp createdAt = rs.getTimestamp("createdAt");
            if (createdAt != null) {
                payment.setExpiredAt(new Timestamp(createdAt.getTime() + 15L * 60L * 1000L));
            }
        }
        if (hasColumn(rs, "note")) {
            payment.setNote(rs.getString("note"));
        }
        if (hasColumn(rs, "createdAt")) {
            payment.setCreatedAt(rs.getTimestamp("createdAt"));
        }
        return payment;
    }

    private boolean hasPaymentColumn(String columnName) {
        String sql = """
                SELECT 1
                FROM INFORMATION_SCHEMA.COLUMNS
                WHERE TABLE_SCHEMA = 'dbo'
                  AND TABLE_NAME = 'Payments'
                  AND COLUMN_NAME = ?
                """;
        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, columnName);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private boolean hasColumn(ResultSet rs, String columnName) throws SQLException {
        ResultSetMetaData metaData = rs.getMetaData();
        for (int i = 1; i <= metaData.getColumnCount(); i++) {
            if (columnName.equalsIgnoreCase(metaData.getColumnLabel(i))
                    || columnName.equalsIgnoreCase(metaData.getColumnName(i))) {
                return true;
            }
        }
        return false;
    }
}
