package vn.edu.fpt.DAO;

import vn.edu.fpt.common.DBConnection;
import vn.edu.fpt.model.RoomBooking;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

public class RoomBookingDAO {

    private static final Logger LOGGER = Logger.getLogger(RoomBookingDAO.class.getName());

    public List<RoomBooking> getRoomBookingsByAccommodation(int accommodationID) {
        List<RoomBooking> list = new ArrayList<>();

        String sql =
                "SELECT bd.bookingDetailID AS roomBookingID, b.bookingID, bd.bookingDetailID, " +
                        "ISNULL(r.roomID, 0) AS roomID, COALESCE(r.roomType, N'Unknown') AS roomType, " +
                        "b.bookingCode, CAST(bd.startDate AS date) AS checkInDate, " +
                        "CAST(bd.endDate AS date) AS checkOutDate, bd.quantity, b.[status], " +
                        "b.bookDate AS createdAt, CAST(NULL AS datetime) AS updatedAt, " +
                        "bd.subTotal AS totalPrice " +
                        "FROM [dbo].[Booking_Detail] bd " +
                        "INNER JOIN [dbo].[Booking] b ON bd.bookingID = b.bookingID " +
                        "LEFT JOIN [dbo].[Room] r ON r.roomID = bd.roomID " +
                        "WHERE bd.accommodationID = ? " +
                        "AND b.bookingType = N'Accommodation' " +
                        "ORDER BY bd.startDate DESC, bd.bookingDetailID DESC";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, accommodationID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRoomBooking(rs));
                }
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Failed to load accommodation bookings", e);
        }

        return list;
    }

    public int createAccommodationBooking(
            int userID,
            String firstName,
            String lastName,
            String email,
            String phone,
            int accommodationID,
            int roomID,
            Date checkInDate,
            Date checkOutDate,
            int adults,
            int children,
            int totalGuests,
            int roomQuantity,
            BigDecimal unitPrice,
            BigDecimal totalPrice,
            String address,
            String identityNumber,
            String identityImageUrl,
            Integer userVoucherID,
            String note) {

        if (userID <= 0 || accommodationID <= 0 || roomID <= 0 || roomQuantity <= 0
                || adults <= 0 || children < 0 || checkInDate == null || checkOutDate == null
                || totalGuests != adults + children
                || !checkOutDate.after(checkInDate) || unitPrice == null || totalPrice == null
                || unitPrice.compareTo(BigDecimal.ZERO) < 0
                || totalPrice.compareTo(BigDecimal.ZERO) < 0) {
            return -1;
        }

        String sqlReserveRoom =
                "UPDATE [dbo].[Room] " +
                        "SET roomAvailability = roomAvailability - ?, updatedAt = GETDATE() " +
                        "WHERE roomID = ? AND accommodationID = ? " +
                        "AND [status] IN (N'Available', N'Active') AND roomAvailability >= ? " +
                        "AND maxAdults * ? >= ? AND maxChildren * ? >= ? " +
                        "AND (maxAdults + maxChildren) * ? >= ?";

        String sqlVoucher =
                "SELECT uv.voucherID, v.percentDiscount, v.amountDiscount " +
                        "FROM [dbo].[User_Voucher] uv WITH (UPDLOCK, HOLDLOCK) " +
                        "INNER JOIN [dbo].[Voucher] v WITH (UPDLOCK, HOLDLOCK) " +
                        "ON uv.voucherID = v.voucherID " +
                        "WHERE uv.userVoucherID = ? AND uv.userID = ? " +
                        "AND UPPER(uv.[status]) = N'SAVED' AND v.[status] = N'Active' " +
                        "AND GETDATE() BETWEEN v.startDate AND v.endDate " +
                        "AND v.usedCount < v.quantity " +
                        "AND v.applicableType IN (N'All', N'Accommodation') " +
                        "AND ISNULL(v.minOrderAmount, 0) <= ?";

        String sqlBooking =
                "INSERT INTO [dbo].[Booking] " +
                        "(bookingCode, bookingType, email, phone, numberAdult, numberChildren, note, " +
                        "identityNumber, identityImageUrl, [address], firstName, lastName, userID, " +
                        "[status], bookDate, isBookedForOther, totalPrice) " +
                        "VALUES (?, N'Accommodation', ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, " +
                        "N'Pending', GETDATE(), 0, ?)";

        String sqlDetail =
                "INSERT INTO [dbo].[Booking_Detail] " +
                        "(bookingID, accommodationID, roomID, quantity, unitPrice, subTotal, startDate, endDate, note) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        String sqlUseUserVoucher =
                "UPDATE [dbo].[User_Voucher] SET [status] = N'USED', usedAt = GETDATE(), bookingID = ? " +
                        "WHERE userVoucherID = ? AND userID = ? AND [status] = N'SAVED'";

        String sqlIncrementVoucher =
                "UPDATE [dbo].[Voucher] SET usedCount = usedCount + 1, updatedAt = GETDATE() " +
                        "WHERE voucherID = ? AND usedCount < quantity";

        try (Connection conn = new DBConnection().getConnection()) {
            conn.setAutoCommit(false);

            try {
                BigDecimal finalTotal = totalPrice;
                Integer selectedVoucherID = null;

                if (userVoucherID != null) {
                    try (PreparedStatement psVoucher = conn.prepareStatement(sqlVoucher)) {
                        psVoucher.setInt(1, userVoucherID);
                        psVoucher.setInt(2, userID);
                        psVoucher.setBigDecimal(3, totalPrice);

                        try (ResultSet rs = psVoucher.executeQuery()) {
                            if (!rs.next()) {
                                conn.rollback();
                                return -2;
                            }

                            selectedVoucherID = rs.getInt("voucherID");
                            finalTotal = calculateDiscountedTotal(
                                    totalPrice,
                                    rs.getBigDecimal("percentDiscount"),
                                    rs.getBigDecimal("amountDiscount"));
                        }
                    }
                }

                try (PreparedStatement psReserve = conn.prepareStatement(sqlReserveRoom)) {
                    psReserve.setInt(1, roomQuantity);
                    psReserve.setInt(2, roomID);
                    psReserve.setInt(3, accommodationID);
                    psReserve.setInt(4, roomQuantity);
                    psReserve.setInt(5, roomQuantity);
                    psReserve.setInt(6, adults);
                    psReserve.setInt(7, roomQuantity);
                    psReserve.setInt(8, children);
                    psReserve.setInt(9, roomQuantity);
                    psReserve.setInt(10, totalGuests);

                    if (psReserve.executeUpdate() == 0) {
                        conn.rollback();
                        return -1;
                    }
                }

                int bookingID;
                String bookingCode = "AC-" + UUID.randomUUID()
                        .toString().substring(0, 8).toUpperCase();

                try (PreparedStatement psBooking = conn.prepareStatement(sqlBooking, Statement.RETURN_GENERATED_KEYS)) {
                    psBooking.setString(1, bookingCode);
                    psBooking.setString(2, email);
                    psBooking.setString(3, phone);
                    psBooking.setInt(4, adults);
                    psBooking.setInt(5, children);
                    psBooking.setString(6, note);
                    psBooking.setString(7, identityNumber);
                    psBooking.setString(8, identityImageUrl);
                    psBooking.setString(9, address);
                    psBooking.setString(10, firstName);
                    psBooking.setString(11, lastName);
                    psBooking.setInt(12, userID);
                    psBooking.setBigDecimal(13, finalTotal);

                    if (psBooking.executeUpdate() == 0) {
                        conn.rollback();
                        return -1;
                    }

                    try (ResultSet keys = psBooking.getGeneratedKeys()) {
                        if (!keys.next()) {
                            conn.rollback();
                            return -1;
                        }

                        bookingID = keys.getInt(1);
                    }
                }

                try (PreparedStatement psDetail = conn.prepareStatement(sqlDetail)) {
                    psDetail.setInt(1, bookingID);
                    psDetail.setInt(2, accommodationID);
                    psDetail.setInt(3, roomID);
                    psDetail.setInt(4, roomQuantity);
                    psDetail.setBigDecimal(5, unitPrice);
                    psDetail.setBigDecimal(6, finalTotal);
                    psDetail.setDate(7, checkInDate);
                    psDetail.setDate(8, checkOutDate);
                    psDetail.setString(9, note);

                    if (psDetail.executeUpdate() == 0) {
                        conn.rollback();
                        return -1;
                    }
                }

                if (userVoucherID != null && selectedVoucherID != null) {
                    try (PreparedStatement psUseVoucher = conn.prepareStatement(sqlUseUserVoucher);
                         PreparedStatement psIncrementVoucher = conn.prepareStatement(sqlIncrementVoucher)) {
                        psUseVoucher.setInt(1, bookingID);
                        psUseVoucher.setInt(2, userVoucherID);
                        psUseVoucher.setInt(3, userID);
                        psIncrementVoucher.setInt(1, selectedVoucherID);

                        if (psUseVoucher.executeUpdate() == 0 || psIncrementVoucher.executeUpdate() == 0) {
                            conn.rollback();
                            return -2;
                        }
                    }
                }

                conn.commit();
                return bookingID;

            } catch (SQLException e) {
                rollback(conn, e);
                LOGGER.log(Level.SEVERE, "Failed to create accommodation booking", e);
            } finally {
                restoreAutoCommit(conn);
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Failed to open accommodation booking transaction", e);
        }

        return -1;
    }

    static BigDecimal calculateDiscountedTotal(
            BigDecimal totalPrice, BigDecimal percentDiscount, BigDecimal amountDiscount) {
        BigDecimal discount = BigDecimal.ZERO;

        if (amountDiscount != null && amountDiscount.compareTo(BigDecimal.ZERO) > 0) {
            discount = amountDiscount;
        } else if (percentDiscount != null && percentDiscount.compareTo(BigDecimal.ZERO) > 0) {
            discount = totalPrice.multiply(percentDiscount)
                    .divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);
        }

        return totalPrice.subtract(discount).max(BigDecimal.ZERO).setScale(2, RoundingMode.HALF_UP);
    }

    private RoomBooking mapRoomBooking(ResultSet rs) throws SQLException {
        RoomBooking booking = new RoomBooking();

        booking.setRoomBookingID(rs.getInt("roomBookingID"));
        booking.setBookingID(rs.getInt("bookingID"));

        int bookingDetailID = rs.getInt("bookingDetailID");
        booking.setBookingDetailID(rs.wasNull() ? null : bookingDetailID);

        booking.setRoomID(rs.getInt("roomID"));
        booking.setRoomType(rs.getString("roomType"));
        booking.setBookingCode(rs.getString("bookingCode"));
        booking.setCheckInDate(rs.getDate("checkInDate"));
        booking.setCheckOutDate(rs.getDate("checkOutDate"));
        booking.setQuantity(rs.getInt("quantity"));
        booking.setStatus(rs.getString("status"));
        booking.setCreatedAt(rs.getTimestamp("createdAt"));
        booking.setUpdatedAt(rs.getTimestamp("updatedAt"));

        BigDecimal totalPrice = rs.getBigDecimal("totalPrice");
        booking.setTotalPrice(totalPrice == null ? BigDecimal.ZERO : totalPrice);

        return booking;
    }

    private void rollback(Connection connection, SQLException cause) {
        try {
            connection.rollback();
        } catch (SQLException rollbackError) {
            cause.addSuppressed(rollbackError);
        }
    }

    private void restoreAutoCommit(Connection connection) {
        try {
            connection.setAutoCommit(true);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Failed to restore booking auto-commit", e);
        }
    }
}
