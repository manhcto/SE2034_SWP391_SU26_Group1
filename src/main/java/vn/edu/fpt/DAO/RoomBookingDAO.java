package vn.edu.fpt.DAO;

import vn.edu.fpt.common.DBConnection;
import vn.edu.fpt.model.RoomBooking;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Types;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class RoomBookingDAO {

    public List<RoomBooking> getRoomBookingsByAccommodation(int serviceID) {
        List<RoomBooking> list = new ArrayList<>();

        String sql =
                "SELECT rb.roomBookingID, rb.bookingID, rb.bookingDetailID, rb.roomID, " +
                        "r.roomType, b.bookingCode, rb.checkInDate, rb.checkOutDate, " +
                        "rb.quantity, rb.[status], rb.createdAt, rb.updatedAt, " +
                        "bd.subTotal AS totalPrice " +
                        "FROM [dbo].[Room_Booking] rb " +
                        "INNER JOIN [dbo].[Room] r ON rb.roomID = r.roomID " +
                        "INNER JOIN [dbo].[Booking] b ON rb.bookingID = b.bookingID " +
                        "LEFT JOIN [dbo].[Booking_Detail] bd ON rb.bookingDetailID = bd.bookingDetailID " +
                        "WHERE r.serviceID = ? " +
                        "ORDER BY rb.checkInDate DESC, rb.roomBookingID DESC";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, serviceID);

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
            int serviceID,
            int roomID,
            Date checkInDate,
            Date checkOutDate,
            int adults,
            int children,
            int roomQuantity,
            BigDecimal unitPrice,
            BigDecimal totalPrice) {

        String sqlAvailability =
                "SELECT r.roomAvailability - ISNULL(booked.bookedQuantity, 0) AS availableQuantity " +
                        "FROM [dbo].[Room] r " +
                        "LEFT JOIN ( " +
                        "    SELECT roomID, SUM(quantity) AS bookedQuantity " +
                        "    FROM [dbo].[Room_Booking] " +
                        "    WHERE [status] IN (N'Pending', N'Confirmed', N'CheckedIn') " +
                        "    AND checkInDate < ? " +
                        "    AND checkOutDate > ? " +
                        "    GROUP BY roomID " +
                        ") booked ON booked.roomID = r.roomID " +
                        "WHERE r.roomID = ? AND r.serviceID = ? AND r.[status] = N'Available'";

        String sqlBooking =
                "INSERT INTO [dbo].[Booking] " +
                        "(bookingCode, bookingType, email, phone, numberAdult, numberChildren, note, " +
                        "[address], firstName, lastName, userID, [status], bookDate, isBookedForOther, totalPrice) " +
                        "VALUES (?, N'Accommodation', ?, ?, ?, ?, NULL, NULL, ?, ?, ?, N'Confirmed', GETDATE(), 0, ?)";

        String sqlDetail =
                "INSERT INTO [dbo].[Booking_Detail] " +
                        "(bookingID, serviceID, quantity, unitPrice, subTotal, startDate, endDate, note) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, NULL)";

        String sqlRoomBooking =
                "INSERT INTO [dbo].[Room_Booking] " +
                        "(bookingID, bookingDetailID, roomID, checkInDate, checkOutDate, quantity, [status]) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = new DBConnection().getConnection()) {
            conn.setAutoCommit(false);

            try {
                try (PreparedStatement psAvailability = conn.prepareStatement(sqlAvailability)) {
                    psAvailability.setDate(1, checkOutDate);
                    psAvailability.setDate(2, checkInDate);
                    psAvailability.setInt(3, roomID);
                    psAvailability.setInt(4, serviceID);

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
                    psBooking.setString(6, firstName);
                    psBooking.setString(7, lastName);
                    psBooking.setInt(8, userID);
                    psBooking.setBigDecimal(9, totalPrice);

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

                int bookingDetailID;

                try (PreparedStatement psDetail = conn.prepareStatement(sqlDetail, Statement.RETURN_GENERATED_KEYS)) {
                    psDetail.setInt(1, bookingID);
                    psDetail.setInt(2, serviceID);
                    psDetail.setInt(3, roomQuantity);
                    psDetail.setBigDecimal(4, unitPrice);
                    psDetail.setBigDecimal(5, totalPrice);
                    psDetail.setDate(6, checkInDate);
                    psDetail.setDate(7, checkOutDate);

                    if (psDetail.executeUpdate() == 0) {
                        conn.rollback();
                        return -1;
                    }

                    try (ResultSet keys = psDetail.getGeneratedKeys()) {
                        if (!keys.next()) {
                            conn.rollback();
                            return -1;
                        }

                        bookingDetailID = keys.getInt(1);
                    }
                }

                try (PreparedStatement psRoomBooking = conn.prepareStatement(sqlRoomBooking)) {
                    psRoomBooking.setInt(1, bookingID);
                    psRoomBooking.setInt(2, bookingDetailID);
                    psRoomBooking.setInt(3, roomID);
                    psRoomBooking.setDate(4, checkInDate);
                    psRoomBooking.setDate(5, checkOutDate);
                    psRoomBooking.setInt(6, roomQuantity);
                    psRoomBooking.setString(7, resolveRoomBookingStatus(checkInDate, checkOutDate));
                    psRoomBooking.executeUpdate();
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

    private String resolveRoomBookingStatus(Date checkInDate, Date checkOutDate) {
        LocalDate today = LocalDate.now();
        LocalDate checkIn = checkInDate.toLocalDate();
        LocalDate checkOut = checkOutDate.toLocalDate();

        if ((today.isEqual(checkIn) || today.isAfter(checkIn)) && today.isBefore(checkOut)) {
            return "CheckedIn";
        }

        return "Confirmed";
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
