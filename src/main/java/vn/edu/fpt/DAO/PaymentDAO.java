package vn.edu.fpt.DAO;

import vn.edu.fpt.common.DBConnection;
import vn.edu.fpt.model.Payment;
import vn.edu.fpt.service.PayOSService;

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
        return findOne(
                "SELECT TOP (1) * FROM [dbo].[Payment] WHERE bookingID = ? ORDER BY paymentID DESC",
                bookingID
        );
    }

    public Payment createPending(int bookingID, BigDecimal amount) {
        Payment existing = findByBookingID(bookingID);
        if (existing != null) {
            return existing;
        }

        String sql = """
                INSERT INTO [dbo].[Payment]
                    (bookingID, payment_method, totalAmount, [status], paymentDate,
                     [description], transactionReference, paymentLinkId, createdAt, expiredAt, paymentType)
                VALUES (?, N'PayOS', ?, N'Pending', NULL,
                        N'Khoi tao thanh toan PayOS', NULL, NULL, GETDATE(),
                        DATEADD(MINUTE, 15, GETDATE()), N'Online')
                """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingID);
            ps.setBigDecimal(2, amount);
            ps.executeUpdate();
        } catch (Exception e) {
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
                SET [status] = N'Pending',
                    expiredAt = DATEADD(MINUTE, 15, GETDATE()),
                    [description] = N'Da tao ma QR PayOS'
                WHERE bookingID = ? AND [status] <> N'Paid'
                """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean markPaidByBookingID(int bookingID, String transactionCode) {
        String sql = """
                UPDATE [dbo].[Payment]
                SET [status] = N'Paid',
                    transactionReference = ?,
                    paymentDate = GETDATE(),
                    expiredAt = NULL,
                    [description] = N'Da thanh toan thanh cong'
                WHERE bookingID = ? AND [status] = N'Pending'
                  AND LEFT(ISNULL([description], N''), 15) <> N'[SLOT_RELEASED]'
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

    public List<Integer> findPaidBookingIDs() {
        String sql = """
                SELECT bookingID FROM [dbo].[Payment]
                WHERE [status] = N'Paid'
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

    public List<Payment> findPendingPayments() {
        String sql = """
                SELECT * FROM [dbo].[Payment]
                WHERE [status] = N'Pending'
                  AND LEFT(ISNULL([description], N''), 15) <> N'[SLOT_RELEASED]'
                ORDER BY paymentID DESC
                """;
        List<Payment> payments = new ArrayList<>();
        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                payments.add(mapPayment(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return payments;
    }

    public boolean synchronizeBookingState(int bookingID) {
        Payment payment = findByBookingID(bookingID);
        if (payment == null) {
            return false;
        }

        BookingDAO bookingDAO = new BookingDAO();
        if (payment.isPaid()) {
            return bookingDAO.syncCompletedBookingFromPaidPayment(bookingID);
        }

        if (payment.isReservationReleased()
                || !STATUS_PENDING.equalsIgnoreCase(payment.getStatus())) {
            return false;
        }

        if (payment.isExpired()) {
            return bookingDAO.releasePendingPaymentReservation(
                    bookingID,
                    true,
                    "Het thoi gian giu cho thanh toan 15 phut."
            );
        }

        BigDecimal amount = payment.getTotalAmount();
        if (amount == null || amount.signum() <= 0) {
            return false;
        }

        PayOSService payOSService = new PayOSService();
        if (!payOSService.isPaymentPaid(bookingID, amount)) {
            return false;
        }

        if (!markPaidByBookingID(bookingID, "PAYOS-SYNC-" + bookingID)) {
            return false;
        }

        bookingDAO.syncCompletedBookingFromPaidPayment(bookingID);
        return true;
    }

    public void synchronizeBookingStates() {
        BookingDAO bookingDAO = new BookingDAO();

        for (Payment payment : findPendingPayments()) {
            synchronizeBookingState(payment.getBookingID());
        }

        for (int bookingID : findPaidBookingIDs()) {
            bookingDAO.syncCompletedBookingFromPaidPayment(bookingID);
        }
    }

    private boolean updatePendingStatus(int bookingID, String status, String note) {
        String sql = """
                UPDATE [dbo].[Payment]
                SET [status] = ?, [description] = ?
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
        } else if (hasColumn(rs, "transactionReference")) {
            payment.setTransactionCode(rs.getString("transactionReference"));
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
        if (hasColumn(rs, "description")) {
            payment.setNote(rs.getString("description"));
        } else if (hasColumn(rs, "note")) {
            payment.setNote(rs.getString("note"));
        }
        if (hasColumn(rs, "createdAt")) {
            payment.setCreatedAt(rs.getTimestamp("createdAt"));
        }
        return payment;
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
