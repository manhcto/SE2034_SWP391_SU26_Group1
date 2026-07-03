package vn.edu.fpt.DAO;

import vn.edu.fpt.common.DBConnection;
import vn.edu.fpt.model.RoomBooking;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class RoomBookingDAO {

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

        } catch (Exception e) {
            e.printStackTrace();
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
            int roomQuantity,
            BigDecimal unitPrice,
            BigDecimal totalPrice,
            String address,
            String identityNumber,
            String identityImageUrl,
            String note) {

        String sqlAvailability =
                "SELECT r.roomAvailability - ISNULL(booked.bookedQuantity, 0) AS availableQuantity " +
                        "FROM [dbo].[Room] r " +
                        "LEFT JOIN ( " +
                        "    SELECT bd.roomID, SUM(bd.quantity) AS bookedQuantity " +
                        "    FROM [dbo].[Booking_Detail] bd " +
                        "    INNER JOIN [dbo].[Booking] b ON bd.bookingID = b.bookingID " +
                        "    WHERE bd.roomID = ? " +
                        "    AND bd.accommodationID = ? " +
                        "    AND b.bookingType = N'Accommodation' " +
                        "    AND b.[status] IN (N'Pending', N'Confirmed') " +
                        "    AND bd.startDate < ? " +
                        "    AND bd.endDate > ? " +
                        "    GROUP BY bd.roomID " +
                        ") booked ON booked.roomID = r.roomID " +
                        "WHERE r.roomID = ? AND r.accommodationID = ? AND r.[status] = N'Available'";

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

        try (Connection conn = new DBConnection().getConnection()) {
            conn.setAutoCommit(false);

            try {
                try (PreparedStatement psAvailability = conn.prepareStatement(sqlAvailability)) {
                    psAvailability.setInt(1, roomID);
                    psAvailability.setInt(2, accommodationID);
                    psAvailability.setDate(3, checkOutDate);
                    psAvailability.setDate(4, checkInDate);
                    psAvailability.setInt(5, roomID);
                    psAvailability.setInt(6, accommodationID);

                    try (ResultSet rs = psAvailability.executeQuery()) {
                        if (!rs.next() || rs.getInt("availableQuantity") < roomQuantity) {
                            conn.rollback();
                            return -1;
                        }
                    }
                }

                int bookingID;
                String bookingCode = "AC-" + System.currentTimeMillis() % 1000000;

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
                    psBooking.setBigDecimal(13, totalPrice);

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
                    psDetail.setBigDecimal(6, totalPrice);
                    psDetail.setDate(7, checkInDate);
                    psDetail.setDate(8, checkOutDate);
                    psDetail.setString(9, note);

                    if (psDetail.executeUpdate() == 0) {
                        conn.rollback();
                        return -1;
                    }
                }

                conn.commit();
                return bookingID;

            } catch (Exception e) {
                conn.rollback();
                e.printStackTrace();
            } finally {
                conn.setAutoCommit(true);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return -1;
    }

    private RoomBooking mapRoomBooking(ResultSet rs) throws Exception {
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
}
