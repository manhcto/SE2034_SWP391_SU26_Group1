package vn.edu.fpt.DAO;

import vn.edu.fpt.common.DBConnection;
import vn.edu.fpt.model.Booking;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class BookingDAO {

    // Check if tour schedule exists
    public boolean isTourScheduleExist(int tourScheduleID) {
        String sql = "SELECT tourScheduleID FROM Tour_Scheduler WHERE tourScheduleID = ?";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, tourScheduleID);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (Exception e) {
            System.out.println("Lỗi kiểm tra tourScheduleID: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    // Get tour prices by schedule ID
    public double[] getTourPricesBySchedule(int tourScheduleID) {
        String sql = "SELECT COALESCE(ts.adultPrice, t.adultPrice) AS adultPrice, "
                + "COALESCE(ts.childPrice, t.childrenPrice) AS childrenPrice "
                + "FROM Tour_Scheduler ts "
                + "JOIN Tour t ON ts.tourID = t.tourID "
                + "WHERE ts.tourScheduleID = ?";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, tourScheduleID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new double[]{
                            rs.getDouble("adultPrice"),
                            rs.getDouble("childrenPrice")
                    };
                }
            }

        } catch (Exception e) {
            System.out.println("Lỗi lấy giá tour: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    // Get remaining seats of a tour schedule
    public int getRemainingSeats(int tourScheduleID) {
        String sql = "SELECT maxParticipants, quantity "
                + "FROM Tour_Scheduler "
                + "WHERE tourScheduleID = ?";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, tourScheduleID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int maxParticipants = rs.getInt("maxParticipants");
                    int quantity = rs.getInt("quantity");
                    return maxParticipants - quantity;
                }
            }

        } catch (Exception e) {
            System.out.println("Lỗi lấy số chỗ còn lại: " + e.getMessage());
            e.printStackTrace();
        }

        return -1;
    }

    // Insert booking transaction and return true if success
    public boolean insertBookingTransaction(Booking booking, int tourScheduleID, double unitPrice) {
        int bookingID = insertBookingTransactionReturnID(booking, tourScheduleID, unitPrice);
        return bookingID > 0;
    }

    // Insert booking, detail and update schedule in one transaction
    public int insertBookingTransactionReturnID(Booking booking, int tourScheduleID, double unitPrice) {
        String sqlBooking = "INSERT INTO Booking (bookingCode, bookingType, firstName, lastName, email, "
                + "phone, address, note, numberAdult, numberChildren, totalPrice, isBookedForOther, userID, "
                + "[status], bookDate) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, N'Pending', GETDATE())";

        String sqlDetail = "INSERT INTO Booking_Detail (bookingID, tourScheduleID, quantity, unitPrice, subTotal) "
                + "VALUES (?, ?, ?, ?, ?)";

        String sqlUpdateSchedule = "UPDATE Tour_Scheduler "
                + "SET quantity = quantity + ? "
                + "WHERE tourScheduleID = ? "
                + "AND quantity + ? <= maxParticipants";

        try (Connection conn = new DBConnection().getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement psBooking = conn.prepareStatement(sqlBooking, Statement.RETURN_GENERATED_KEYS)) {

                psBooking.setString(1, booking.getBookingCode());
                psBooking.setString(2, booking.getBookingType());
                psBooking.setString(3, booking.getFirstName());
                psBooking.setString(4, booking.getLastName());
                psBooking.setString(5, booking.getEmail());
                psBooking.setString(6, booking.getPhone());
                psBooking.setString(7, booking.getAddress());
                psBooking.setString(8, booking.getNote());
                psBooking.setInt(9, booking.getNumberAdult());
                psBooking.setInt(10, booking.getNumberChildren());
                psBooking.setDouble(11, booking.getTotalPrice());
                psBooking.setBoolean(12, booking.isBookedForOther());

                if (booking.getUserID() != null) {
                    psBooking.setInt(13, booking.getUserID());
                } else {
                    psBooking.setNull(13, java.sql.Types.INTEGER);
                }

                int affectedRows = psBooking.executeUpdate();

                if (affectedRows == 0) {
                    conn.rollback();
                    return -1;
                }

                int generatedBookingID;

                try (ResultSet generatedKeys = psBooking.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        generatedBookingID = generatedKeys.getInt(1);
                    } else {
                        conn.rollback();
                        return -1;
                    }
                }

                int totalQuantity = booking.getNumberAdult() + booking.getNumberChildren();

                try (PreparedStatement psDetail = conn.prepareStatement(sqlDetail)) {
                    psDetail.setInt(1, generatedBookingID);
                    psDetail.setInt(2, tourScheduleID);
                    psDetail.setInt(3, totalQuantity);
                    psDetail.setDouble(4, unitPrice);
                    psDetail.setDouble(5, booking.getTotalPrice());

                    psDetail.executeUpdate();
                }

                try (PreparedStatement psUpdateSchedule = conn.prepareStatement(sqlUpdateSchedule)) {
                    psUpdateSchedule.setInt(1, totalQuantity);
                    psUpdateSchedule.setInt(2, tourScheduleID);
                    psUpdateSchedule.setInt(3, totalQuantity);

                    int updatedRows = psUpdateSchedule.executeUpdate();

                    if (updatedRows == 0) {
                        conn.rollback();
                        return -1;
                    }
                }

                conn.commit();
                return generatedBookingID;

            } catch (Exception e) {
                conn.rollback();
                System.out.println("Lỗi Transaction, đã rollback dữ liệu: " + e.getMessage());
                e.printStackTrace();
            } finally {
                conn.setAutoCommit(true);
            }

        } catch (Exception e) {
            System.out.println("Lỗi kết nối hoặc xử lý BookingDAO: " + e.getMessage());
            e.printStackTrace();
        }

        return -1;
    }

    // Insert tour booking with identity info and optional voucher (mirrors accommodation flow).
    // Returns bookingID on success, -1 on failure, -2 when the voucher is invalid/used.
    public int insertTourBookingWithVoucherReturnID(Booking booking, int tourScheduleID,
                                                    double unitPrice, Integer userVoucherID, int userID) {

        String sqlVoucher =
                "SELECT uv.voucherID, v.percentDiscount, v.amountDiscount "
                        + "FROM [dbo].[User_Voucher] uv WITH (UPDLOCK, HOLDLOCK) "
                        + "INNER JOIN [dbo].[Voucher] v WITH (UPDLOCK, HOLDLOCK) "
                        + "ON uv.voucherID = v.voucherID "
                        + "WHERE uv.userVoucherID = ? AND uv.userID = ? "
                        + "AND UPPER(uv.[status]) = N'SAVED' AND v.[status] = N'Active' "
                        + "AND GETDATE() BETWEEN v.startDate AND v.endDate "
                        + "AND v.usedCount < v.quantity "
                        + "AND v.applicableType IN (N'All', N'Tour') "
                        + "AND ISNULL(v.minOrderAmount, 0) <= ?";

        String sqlBooking = "INSERT INTO Booking (bookingCode, bookingType, firstName, lastName, email, "
                + "phone, address, note, identityNumber, identityImageUrl, numberAdult, numberChildren, "
                + "totalPrice, isBookedForOther, userID, [status], bookDate) "
                + "VALUES (?, N'Tour', ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0, ?, N'Pending', GETDATE())";

        String sqlDetail = "INSERT INTO Booking_Detail (bookingID, tourScheduleID, quantity, unitPrice, subTotal) "
                + "VALUES (?, ?, ?, ?, ?)";

        String sqlUpdateSchedule = "UPDATE Tour_Scheduler "
                + "SET quantity = quantity + ? "
                + "WHERE tourScheduleID = ? "
                + "AND quantity + ? <= maxParticipants";

        String sqlUseUserVoucher =
                "UPDATE [dbo].[User_Voucher] SET [status] = N'USED', usedAt = GETDATE(), bookingID = ? "
                        + "WHERE userVoucherID = ? AND userID = ? AND [status] = N'SAVED'";

        String sqlIncrementVoucher =
                "UPDATE [dbo].[Voucher] SET usedCount = usedCount + 1, updatedAt = GETDATE() "
                        + "WHERE voucherID = ? AND usedCount < quantity";

        BigDecimal baseTotal = BigDecimal.valueOf(booking.getTotalPrice());

        try (Connection conn = new DBConnection().getConnection()) {
            conn.setAutoCommit(false);

            try {
                BigDecimal finalTotal = baseTotal;
                Integer selectedVoucherID = null;

                if (userVoucherID != null) {
                    try (PreparedStatement psVoucher = conn.prepareStatement(sqlVoucher)) {
                        psVoucher.setInt(1, userVoucherID);
                        psVoucher.setInt(2, userID);
                        psVoucher.setBigDecimal(3, baseTotal);

                        try (ResultSet rs = psVoucher.executeQuery()) {
                            if (!rs.next()) {
                                conn.rollback();
                                return -2;
                            }

                            selectedVoucherID = rs.getInt("voucherID");
                            finalTotal = RoomBookingDAO.calculateDiscountedTotal(
                                    baseTotal,
                                    rs.getBigDecimal("percentDiscount"),
                                    rs.getBigDecimal("amountDiscount"));
                        }
                    }
                }

                int generatedBookingID;

                try (PreparedStatement psBooking = conn.prepareStatement(sqlBooking, Statement.RETURN_GENERATED_KEYS)) {
                    psBooking.setString(1, booking.getBookingCode());
                    psBooking.setString(2, booking.getFirstName());
                    psBooking.setString(3, booking.getLastName());
                    psBooking.setString(4, booking.getEmail());
                    psBooking.setString(5, booking.getPhone());
                    psBooking.setString(6, booking.getAddress());
                    psBooking.setString(7, booking.getNote());
                    psBooking.setString(8, booking.getIdentityNumber());
                    psBooking.setString(9, booking.getIdentityImageUrl());
                    psBooking.setInt(10, booking.getNumberAdult());
                    psBooking.setInt(11, booking.getNumberChildren());
                    psBooking.setBigDecimal(12, finalTotal);
                    psBooking.setInt(13, userID);

                    if (psBooking.executeUpdate() == 0) {
                        conn.rollback();
                        return -1;
                    }

                    try (ResultSet generatedKeys = psBooking.getGeneratedKeys()) {
                        if (generatedKeys.next()) {
                            generatedBookingID = generatedKeys.getInt(1);
                        } else {
                            conn.rollback();
                            return -1;
                        }
                    }
                }

                int totalQuantity = booking.getNumberAdult() + booking.getNumberChildren();

                try (PreparedStatement psDetail = conn.prepareStatement(sqlDetail)) {
                    psDetail.setInt(1, generatedBookingID);
                    psDetail.setInt(2, tourScheduleID);
                    psDetail.setInt(3, totalQuantity);
                    psDetail.setDouble(4, unitPrice);
                    psDetail.setBigDecimal(5, finalTotal);

                    psDetail.executeUpdate();
                }

                try (PreparedStatement psUpdateSchedule = conn.prepareStatement(sqlUpdateSchedule)) {
                    psUpdateSchedule.setInt(1, totalQuantity);
                    psUpdateSchedule.setInt(2, tourScheduleID);
                    psUpdateSchedule.setInt(3, totalQuantity);

                    if (psUpdateSchedule.executeUpdate() == 0) {
                        conn.rollback();
                        return -1;
                    }
                }

                if (userVoucherID != null && selectedVoucherID != null) {
                    try (PreparedStatement psUseVoucher = conn.prepareStatement(sqlUseUserVoucher);
                         PreparedStatement psIncrementVoucher = conn.prepareStatement(sqlIncrementVoucher)) {
                        psUseVoucher.setInt(1, generatedBookingID);
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
                return generatedBookingID;

            } catch (Exception e) {
                conn.rollback();
                System.out.println("Lỗi Transaction đặt tour, đã rollback dữ liệu: " + e.getMessage());
                e.printStackTrace();
            } finally {
                conn.setAutoCommit(true);
            }

        } catch (Exception e) {
            System.out.println("Lỗi kết nối hoặc xử lý BookingDAO (tour + voucher): " + e.getMessage());
            e.printStackTrace();
        }

        return -1;
    }

    // Get booking summary by booking ID
    public Map<String, Object> getBookingSummaryByID(int bookingID) {
        String sql = "SELECT "
                + "b.bookingID, "
                + "b.bookingCode, "
                + "b.bookingType, "
                + "b.email, "
                + "b.phone, "
                + "b.numberAdult, "
                + "b.numberChildren, "
                + "b.note, "
                + "b.identityNumber, "
                + "b.identityImageUrl, "
                + "b.address, "
                + "b.firstName, "
                + "b.lastName, "
                + "b.userID, "
                + "b.status, "
                + "b.bookDate, "
                + "b.totalPrice, "
                + "bd.quantity, "
                + "bd.unitPrice, "
                + "bd.subTotal, "
                + "bd.tourScheduleID, "
                + "bd.accommodationID AS accommodationID, "
                + "bd.roomID, "
                + "bd.startDate AS detailStartDate, "
                + "bd.endDate AS detailEndDate, "
                + "t.tourID, "
                + "t.tourName, "
                + "t.startPlace, "
                + "t.endPlace, "
                + "ts.startDate AS tourStartDate, "
                + "ts.endDate AS tourEndDate, "
                + "a.[name] AS accommodationName, "
                + "r.roomType, "
                + "COALESCE(ts.startDate, bd.startDate) AS startDate, "
                + "COALESCE(ts.endDate, bd.endDate) AS endDate, "
                + "COALESCE(t.tourName, a.[name]) AS serviceName, "
                + "COALESCE(t.tourName, CONCAT(a.[name], CASE WHEN r.roomType IS NULL THEN N'' ELSE N' - ' + r.roomType END)) AS itemName "
                + "FROM Booking b "
                + "JOIN Booking_Detail bd ON b.bookingID = bd.bookingID "
                + "LEFT JOIN Tour_Scheduler ts ON bd.tourScheduleID = ts.tourScheduleID "
                + "LEFT JOIN Tour t ON ts.tourID = t.tourID "
                + "LEFT JOIN Accommodation a ON bd.accommodationID = a.accommodationID "
                + "LEFT JOIN Room r ON bd.roomID = r.roomID "
                + "WHERE b.bookingID = ?";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookingID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> summary = new HashMap<>();

                    summary.put("bookingID", rs.getInt("bookingID"));
                    summary.put("bookingCode", rs.getString("bookingCode"));
                    summary.put("bookingType", rs.getString("bookingType"));
                    summary.put("email", rs.getString("email"));
                    summary.put("phone", rs.getString("phone"));
                    summary.put("numberAdult", rs.getInt("numberAdult"));
                    summary.put("numberChildren", rs.getInt("numberChildren"));
                    summary.put("note", rs.getString("note"));
                    summary.put("identityNumber", rs.getString("identityNumber"));
                    summary.put("identityImageUrl", rs.getString("identityImageUrl"));
                    summary.put("address", rs.getString("address"));
                    summary.put("firstName", rs.getString("firstName"));
                    summary.put("lastName", rs.getString("lastName"));
                    summary.put("userID", rs.getInt("userID"));
                    summary.put("status", rs.getString("status"));
                    summary.put("bookDate", rs.getTimestamp("bookDate"));
                    summary.put("totalPrice", rs.getDouble("totalPrice"));

                    summary.put("quantity", rs.getInt("quantity"));
                    summary.put("unitPrice", rs.getDouble("unitPrice"));
                    summary.put("subTotal", rs.getDouble("subTotal"));
                    summary.put("tourScheduleID", rs.getInt("tourScheduleID"));
                    summary.put("accommodationID", rs.getInt("accommodationID"));
                    summary.put("roomID", rs.getInt("roomID"));
                    summary.put("detailStartDate", rs.getTimestamp("detailStartDate"));
                    summary.put("detailEndDate", rs.getTimestamp("detailEndDate"));

                    summary.put("tourID", rs.getInt("tourID"));
                    summary.put("tourName", rs.getString("tourName"));
                    summary.put("startPlace", rs.getString("startPlace"));
                    summary.put("endPlace", rs.getString("endPlace"));
                    summary.put("startDate", rs.getTimestamp("startDate"));
                    summary.put("endDate", rs.getTimestamp("endDate"));
                    summary.put("serviceName", rs.getString("serviceName"));
                    summary.put("accommodationName", rs.getString("accommodationName"));
                    summary.put("roomType", rs.getString("roomType"));
                    summary.put("itemName", rs.getString("itemName"));

                    return summary;
                }
            }

        } catch (Exception e) {
            System.out.println("Lỗi lấy Booking Summary: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    // Get all bookings
    public List<Booking> getAllBookings() {
        List<Booking> bookings = new ArrayList<>();

        String sql = "SELECT b.bookingID, b.bookingCode, b.bookingType, b.email, b.phone, "
                + "b.numberAdult, b.numberChildren, b.note, b.identityNumber, b.identityImageUrl, "
                + "b.address, b.firstName, b.lastName, "
                + "b.userID, b.status, b.bookDate, b.isBookedForOther, b.totalPrice, b.voucherID, "
                + "bd.accommodationID AS detailAccommodationID, bd.tourScheduleID AS detailTourScheduleID, "
                + "bd.quantity AS detailQuantity, bd.unitPrice AS detailUnitPrice, bd.subTotal AS detailSubTotal, "
                + "COALESCE(bd.startDate, ts.startDate) AS serviceStartDate, "
                + "COALESCE(bd.endDate, ts.endDate) AS serviceEndDate, "
                + "COALESCE(t.tourName, a.[name]) AS serviceName "
                + "FROM Booking b "
                + "OUTER APPLY ( "
                + "    SELECT TOP 1 * FROM Booking_Detail bdInner "
                + "    WHERE bdInner.bookingID = b.bookingID "
                + "    ORDER BY bdInner.bookingDetailID ASC "
                + ") bd "
                + "LEFT JOIN Tour_Scheduler ts ON bd.tourScheduleID = ts.tourScheduleID "
                + "LEFT JOIN Tour t ON ts.tourID = t.tourID "
                + "LEFT JOIN Accommodation a ON bd.accommodationID = a.accommodationID "
                + "ORDER BY b.bookDate DESC";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                bookings.add(mapBooking(rs));
            }

        } catch (Exception e) {
            System.out.println("Lỗi lấy danh sách booking: " + e.getMessage());
            e.printStackTrace();
        }

        return bookings;
    }

    public List<Booking> getBookingsByUserID(int userID) {
        List<Booking> bookings = new ArrayList<>();

        String sql = "SELECT b.bookingID, b.bookingCode, b.bookingType, b.email, b.phone, "
                + "b.numberAdult, b.numberChildren, b.note, b.identityNumber, b.identityImageUrl, "
                + "b.address, b.firstName, b.lastName, "
                + "b.userID, b.status, b.bookDate, b.isBookedForOther, b.totalPrice, b.voucherID, "
                + "bd.accommodationID AS detailAccommodationID, bd.tourScheduleID AS detailTourScheduleID, "
                + "bd.quantity AS detailQuantity, bd.unitPrice AS detailUnitPrice, bd.subTotal AS detailSubTotal, "
                + "COALESCE(bd.startDate, ts.startDate) AS serviceStartDate, "
                + "COALESCE(bd.endDate, ts.endDate) AS serviceEndDate, "
                + "COALESCE(t.tourName, a.[name]) AS serviceName "
                + "FROM Booking b "
                + "OUTER APPLY ( "
                + "    SELECT TOP 1 * FROM Booking_Detail bdInner "
                + "    WHERE bdInner.bookingID = b.bookingID "
                + "    ORDER BY bdInner.bookingDetailID ASC "
                + ") bd "
                + "LEFT JOIN Tour_Scheduler ts ON bd.tourScheduleID = ts.tourScheduleID "
                + "LEFT JOIN Tour t ON ts.tourID = t.tourID "
                + "LEFT JOIN Accommodation a ON bd.accommodationID = a.accommodationID "
                + "WHERE b.userID = ? "
                + "ORDER BY b.bookDate DESC";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    bookings.add(mapBooking(rs));
                }
            }

        } catch (Exception e) {
            System.out.println("Loi lay danh sach booking theo user: " + e.getMessage());
            e.printStackTrace();
        }

        return bookings;
    }

    // Get booking by ID
    public Booking getBookingByID(int bookingID) {
        String sql = "SELECT b.bookingID, b.bookingCode, b.bookingType, b.email, b.phone, "
                + "b.numberAdult, b.numberChildren, b.note, b.identityNumber, b.identityImageUrl, "
                + "b.address, b.firstName, b.lastName, "
                + "b.userID, b.status, b.bookDate, b.isBookedForOther, b.totalPrice, b.voucherID, "
                + "bd.accommodationID AS detailAccommodationID, bd.tourScheduleID AS detailTourScheduleID, "
                + "bd.quantity AS detailQuantity, bd.unitPrice AS detailUnitPrice, bd.subTotal AS detailSubTotal, "
                + "COALESCE(bd.startDate, ts.startDate) AS serviceStartDate, "
                + "COALESCE(bd.endDate, ts.endDate) AS serviceEndDate, "
                + "COALESCE(t.tourName, a.[name]) AS serviceName "
                + "FROM Booking b "
                + "OUTER APPLY ( "
                + "    SELECT TOP 1 * FROM Booking_Detail bdInner "
                + "    WHERE bdInner.bookingID = b.bookingID "
                + "    ORDER BY bdInner.bookingDetailID ASC "
                + ") bd "
                + "LEFT JOIN Tour_Scheduler ts ON bd.tourScheduleID = ts.tourScheduleID "
                + "LEFT JOIN Tour t ON ts.tourID = t.tourID "
                + "LEFT JOIN Accommodation a ON bd.accommodationID = a.accommodationID "
                + "WHERE b.bookingID = ?";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookingID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapBooking(rs);
                }
            }

        } catch (Exception e) {
            System.out.println("Lỗi lấy booking theo ID: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    private Booking mapBooking(ResultSet rs) throws Exception {
        Booking booking = new Booking();

        booking.setBookingID(rs.getInt("bookingID"));
        booking.setBookingCode(rs.getString("bookingCode"));
        booking.setBookingType(rs.getString("bookingType"));
        booking.setEmail(rs.getString("email"));
        booking.setPhone(rs.getString("phone"));
        booking.setNumberAdult(rs.getInt("numberAdult"));
        booking.setNumberChildren(rs.getInt("numberChildren"));
        booking.setNote(rs.getString("note"));
        booking.setIdentityNumber(rs.getString("identityNumber"));
        booking.setIdentityImageUrl(rs.getString("identityImageUrl"));
        booking.setAddress(rs.getString("address"));
        booking.setFirstName(rs.getString("firstName"));
        booking.setLastName(rs.getString("lastName"));

        int userID = rs.getInt("userID");
        booking.setUserID(rs.wasNull() ? null : userID);

        booking.setStatus(rs.getString("status"));
        booking.setBookDate(rs.getTimestamp("bookDate"));
        booking.setBookedForOther(rs.getBoolean("isBookedForOther"));
        booking.setTotalPrice(rs.getDouble("totalPrice"));

        int voucherID = rs.getInt("voucherID");
        booking.setVoucherID(rs.wasNull() ? null : voucherID);

        int detailAccommodationID = rs.getInt("detailAccommodationID");
        booking.setDetailAccommodationID(rs.wasNull() ? null : detailAccommodationID);

        int detailTourScheduleID = rs.getInt("detailTourScheduleID");
        booking.setDetailTourScheduleID(rs.wasNull() ? null : detailTourScheduleID);

        booking.setDetailQuantity(rs.getInt("detailQuantity"));
        booking.setDetailUnitPrice(rs.getDouble("detailUnitPrice"));
        booking.setDetailSubTotal(rs.getDouble("detailSubTotal"));
        booking.setServiceStartDate(rs.getTimestamp("serviceStartDate"));
        booking.setServiceEndDate(rs.getTimestamp("serviceEndDate"));
        booking.setServiceName(rs.getString("serviceName"));

        return booking;
    }

    // Update booking information
    public boolean updateBooking(Booking booking) {
        String sqlGetDetail = "SELECT bd.tourScheduleID, bd.quantity, bd.subTotal, "
                + "COALESCE(ts.adultPrice, t.adultPrice) AS adultPrice, "
                + "COALESCE(ts.childPrice, t.childrenPrice) AS childrenPrice "
                + "FROM Booking_Detail bd "
                + "LEFT JOIN Tour_Scheduler ts ON bd.tourScheduleID = ts.tourScheduleID "
                + "LEFT JOIN Tour t ON ts.tourID = t.tourID "
                + "WHERE bd.bookingID = ?";

        String sqlUpdateScheduleIncrease = "UPDATE Tour_Scheduler "
                + "SET quantity = quantity + ? "
                + "WHERE tourScheduleID = ? "
                + "AND quantity + ? <= maxParticipants";

        String sqlUpdateScheduleDecrease = "UPDATE Tour_Scheduler "
                + "SET quantity = CASE "
                + "WHEN quantity - ? < 0 THEN 0 "
                + "ELSE quantity - ? "
                + "END "
                + "WHERE tourScheduleID = ?";

        String sqlUpdateBooking = "UPDATE Booking "
                + "SET firstName = ?, "
                + "lastName = ?, "
                + "email = ?, "
                + "phone = ?, "
                + "address = ?, "
                + "note = ?, "
                + "numberAdult = ?, "
                + "numberChildren = ?, "
                + "isBookedForOther = ?, "
                + "status = ?, "
                + "totalPrice = ? "
                + "WHERE bookingID = ?";

        String sqlUpdateDetail = "UPDATE Booking_Detail "
                + "SET quantity = ?, "
                + "unitPrice = ?, "
                + "subTotal = ? "
                + "WHERE bookingID = ?";

        try (Connection conn = new DBConnection().getConnection()) {
            conn.setAutoCommit(false);

            int tourScheduleID = -1;
            int oldQuantity = 0;
            double adultPrice = 0;
            double childrenPrice = 0;
            double totalPrice = booking.getTotalPrice();
            boolean isTourBooking = false;

            try (PreparedStatement psGetDetail = conn.prepareStatement(sqlGetDetail)) {
                psGetDetail.setInt(1, booking.getBookingID());

                try (ResultSet rs = psGetDetail.executeQuery()) {
                    if (rs.next()) {
                        tourScheduleID = rs.getInt("tourScheduleID");
                        isTourBooking = !rs.wasNull();
                        oldQuantity = rs.getInt("quantity");
                        adultPrice = rs.getDouble("adultPrice");
                        childrenPrice = rs.getDouble("childrenPrice");
                        totalPrice = rs.getDouble("subTotal");
                    } else {
                        conn.rollback();
                        return false;
                    }
                }
            }

            int newQuantity = booking.getNumberAdult() + booking.getNumberChildren();
            int quantityDifference = newQuantity - oldQuantity;

            if (isTourBooking && quantityDifference > 0) {
                try (PreparedStatement psUpdateSchedule = conn.prepareStatement(sqlUpdateScheduleIncrease)) {
                    psUpdateSchedule.setInt(1, quantityDifference);
                    psUpdateSchedule.setInt(2, tourScheduleID);
                    psUpdateSchedule.setInt(3, quantityDifference);

                    int updatedRows = psUpdateSchedule.executeUpdate();

                    if (updatedRows == 0) {
                        conn.rollback();
                        return false;
                    }
                }
            } else if (isTourBooking && quantityDifference < 0) {
                int decreaseAmount = Math.abs(quantityDifference);

                try (PreparedStatement psUpdateSchedule = conn.prepareStatement(sqlUpdateScheduleDecrease)) {
                    psUpdateSchedule.setInt(1, decreaseAmount);
                    psUpdateSchedule.setInt(2, decreaseAmount);
                    psUpdateSchedule.setInt(3, tourScheduleID);
                    psUpdateSchedule.executeUpdate();
                }
            }

            if (isTourBooking) {
                totalPrice = booking.getNumberAdult() * adultPrice
                        + booking.getNumberChildren() * childrenPrice;
            }

            double unitPrice = newQuantity > 0 ? totalPrice / newQuantity : adultPrice;

            try (PreparedStatement psUpdateBooking = conn.prepareStatement(sqlUpdateBooking)) {
                psUpdateBooking.setString(1, booking.getFirstName());
                psUpdateBooking.setString(2, booking.getLastName());
                psUpdateBooking.setString(3, booking.getEmail());
                psUpdateBooking.setString(4, booking.getPhone());
                psUpdateBooking.setString(5, booking.getAddress());
                psUpdateBooking.setString(6, booking.getNote());
                psUpdateBooking.setInt(7, booking.getNumberAdult());
                psUpdateBooking.setInt(8, booking.getNumberChildren());
                psUpdateBooking.setBoolean(9, booking.isBookedForOther());
                psUpdateBooking.setString(10, booking.getStatus());
                psUpdateBooking.setDouble(11, totalPrice);
                psUpdateBooking.setInt(12, booking.getBookingID());

                int updatedBookingRows = psUpdateBooking.executeUpdate();

                if (updatedBookingRows == 0) {
                    conn.rollback();
                    return false;
                }
            }

            if (isTourBooking) {
                try (PreparedStatement psUpdateDetail = conn.prepareStatement(sqlUpdateDetail)) {
                    psUpdateDetail.setInt(1, newQuantity);
                    psUpdateDetail.setDouble(2, unitPrice);
                    psUpdateDetail.setDouble(3, totalPrice);
                    psUpdateDetail.setInt(4, booking.getBookingID());
                    psUpdateDetail.executeUpdate();
                }
            }

            conn.commit();
            return true;

        } catch (Exception e) {
            System.out.println("Lỗi cập nhật booking: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    public boolean updateBookingStatus(int bookingID, String status) {
        String normalizedStatus = normalizeBookingStatus(status);
        if (normalizedStatus == null) {
            return false;
        }

        String sqlGetBooking = """
                SELECT b.[status], bd.tourScheduleID, bd.roomID, bd.quantity
                FROM Booking b WITH (UPDLOCK, ROWLOCK)
                LEFT JOIN Booking_Detail bd ON b.bookingID = bd.bookingID
                WHERE b.bookingID = ?
                """;
        String sqlReleaseTour = """
                UPDATE Tour_Scheduler
                SET quantity = CASE WHEN quantity - ? < 0 THEN 0 ELSE quantity - ? END
                WHERE tourScheduleID = ?
                """;
        String sqlReserveTour = """
                UPDATE Tour_Scheduler
                SET quantity = quantity + ?
                WHERE quantity + ? <= maxParticipants AND tourScheduleID = ?
                """;
        String sqlReleaseRoom = """
                UPDATE Room
                SET roomAvailability = CASE
                    WHEN roomAvailability + ? > numberOfRooms THEN numberOfRooms
                    ELSE roomAvailability + ? END,
                    updatedAt = GETDATE()
                WHERE roomID = ?
                """;
        String sqlReserveRoom = """
                UPDATE Room
                SET roomAvailability = roomAvailability - ?, updatedAt = GETDATE()
                WHERE roomAvailability >= ? AND roomID = ?
                """;
        String sqlUpdateBooking = """
                UPDATE Booking SET [status] = ?, updatedAt = GETDATE() WHERE bookingID = ?
                """;
        String sqlPaymentStatus = """
                SELECT TOP (1) [status]
                FROM Payment
                WHERE bookingID = ?
                ORDER BY paymentID DESC
                """;

        try (Connection conn = new DBConnection().getConnection()) {
            conn.setAutoCommit(false);
            try {
                String currentStatus;
                String paymentStatus = null;
                int tourScheduleID = 0;
                int roomID = 0;
                int quantity = 0;

                try (PreparedStatement ps = conn.prepareStatement(sqlGetBooking)) {
                    ps.setInt(1, bookingID);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) {
                            conn.rollback();
                            return false;
                        }
                        currentStatus = rs.getString("status");
                        tourScheduleID = rs.getInt("tourScheduleID");
                        roomID = rs.getInt("roomID");
                        quantity = rs.getInt("quantity");
                    }
                }

                try (PreparedStatement ps = conn.prepareStatement(sqlPaymentStatus)) {
                    ps.setInt(1, bookingID);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            paymentStatus = rs.getString("status");
                        }
                    }
                }

                if (!Booking.canTransitionStatus(currentStatus, normalizedStatus)) {
                    conn.rollback();
                    return false;
                }

                boolean wasCancelled = Booking.isCancelledStatus(currentStatus);
                boolean willCancel = Booking.isCancelledStatus(normalizedStatus);
                boolean willConfirm = Booking.isApprovedStatus(normalizedStatus);

                if (wasCancelled && !willCancel) {
                    conn.rollback();
                    return false;
                }

                if (willConfirm && !PaymentDAO.STATUS_PAID.equalsIgnoreCase(paymentStatus)) {
                    conn.rollback();
                    return false;
                }

                if (!wasCancelled && willCancel) {
                    if (quantity > 0 && tourScheduleID > 0) {
                        executeQuantityUpdate(conn, sqlReleaseTour, quantity, tourScheduleID);
                    }
                    if (quantity > 0 && roomID > 0) {
                        executeQuantityUpdate(conn, sqlReleaseRoom, quantity, roomID);
                    }
                    if (!cancelPendingPayment(conn, bookingID, "Booking đã bị hủy nên payment không thể thanh toán tiếp.")) {
                        conn.rollback();
                        return false;
                    }
                    if (!restoreVoucherUsage(conn, bookingID)) {
                        conn.rollback();
                        return false;
                    }
                }

                try (PreparedStatement ps = conn.prepareStatement(sqlUpdateBooking)) {
                    ps.setNString(1, normalizedStatus);
                    ps.setInt(2, bookingID);
                    if (ps.executeUpdate() == 0) {
                        conn.rollback();
                        return false;
                    }
                }

                conn.commit();
                return true;
            } catch (Exception e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (Exception e) {
            System.out.println("Lỗi cập nhật trạng thái booking: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    private boolean executeQuantityUpdate(Connection conn,
                                          String sql,
                                          int quantity,
                                          int resourceID) throws Exception {
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, quantity);
            ps.setInt(3, resourceID);
            return ps.executeUpdate() > 0;
        }
    }

    private String normalizeBookingStatus(String status) {
        return Booking.normalizeStatus(status);
    }

    // Update customer booking, quantity and total price
    public boolean updateCustomerBooking(Booking booking) {
        String sqlGetDetail = "SELECT bd.tourScheduleID, bd.quantity, "
                + "COALESCE(ts.adultPrice, t.adultPrice) AS adultPrice, "
                + "COALESCE(ts.childPrice, t.childrenPrice) AS childrenPrice "
                + "FROM Booking_Detail bd "
                + "JOIN Tour_Scheduler ts ON bd.tourScheduleID = ts.tourScheduleID "
                + "JOIN Tour t ON ts.tourID = t.tourID "
                + "WHERE bd.bookingID = ?";

        String sqlUpdateScheduleIncrease = "UPDATE Tour_Scheduler "
                + "SET quantity = quantity + ? "
                + "WHERE tourScheduleID = ? "
                + "AND quantity + ? <= maxParticipants";

        String sqlUpdateScheduleDecrease = "UPDATE Tour_Scheduler "
                + "SET quantity = CASE "
                + "WHEN quantity - ? < 0 THEN 0 "
                + "ELSE quantity - ? "
                + "END "
                + "WHERE tourScheduleID = ?";

        String sqlUpdateBooking = "UPDATE Booking "
                + "SET firstName = ?, "
                + "lastName = ?, "
                + "email = ?, "
                + "phone = ?, "
                + "address = ?, "
                + "note = ?, "
                + "numberAdult = ?, "
                + "numberChildren = ?, "
                + "isBookedForOther = ?, "
                + "totalPrice = ? "
                + "WHERE bookingID = ? "
                + "AND status IN (N'Pending', N'Đang xử lý', N'Chờ xử lý')";

        String sqlUpdateDetail = "UPDATE Booking_Detail "
                + "SET quantity = ?, "
                + "unitPrice = ?, "
                + "subTotal = ? "
                + "WHERE bookingID = ?";

        try (Connection conn = new DBConnection().getConnection()) {
            conn.setAutoCommit(false);

            int tourScheduleID = -1;
            int oldQuantity = 0;
            double adultPrice = 0;
            double childrenPrice = 0;

            try (PreparedStatement psGetDetail = conn.prepareStatement(sqlGetDetail)) {
                psGetDetail.setInt(1, booking.getBookingID());

                try (ResultSet rs = psGetDetail.executeQuery()) {
                    if (rs.next()) {
                        tourScheduleID = rs.getInt("tourScheduleID");
                        oldQuantity = rs.getInt("quantity");
                        adultPrice = rs.getDouble("adultPrice");
                        childrenPrice = rs.getDouble("childrenPrice");
                    } else {
                        conn.rollback();
                        return false;
                    }
                }
            }

            int newQuantity = booking.getNumberAdult() + booking.getNumberChildren();
            int quantityDifference = newQuantity - oldQuantity;

            if (quantityDifference > 0) {
                try (PreparedStatement psUpdateSchedule = conn.prepareStatement(sqlUpdateScheduleIncrease)) {
                    psUpdateSchedule.setInt(1, quantityDifference);
                    psUpdateSchedule.setInt(2, tourScheduleID);
                    psUpdateSchedule.setInt(3, quantityDifference);

                    int updatedRows = psUpdateSchedule.executeUpdate();

                    if (updatedRows == 0) {
                        conn.rollback();
                        return false;
                    }
                }
            } else if (quantityDifference < 0) {
                int decreaseAmount = Math.abs(quantityDifference);

                try (PreparedStatement psUpdateSchedule = conn.prepareStatement(sqlUpdateScheduleDecrease)) {
                    psUpdateSchedule.setInt(1, decreaseAmount);
                    psUpdateSchedule.setInt(2, decreaseAmount);
                    psUpdateSchedule.setInt(3, tourScheduleID);
                    psUpdateSchedule.executeUpdate();
                }
            }

            double totalPrice = booking.getNumberAdult() * adultPrice
                    + booking.getNumberChildren() * childrenPrice;

            double unitPrice = newQuantity > 0 ? totalPrice / newQuantity : adultPrice;

            try (PreparedStatement psUpdateBooking = conn.prepareStatement(sqlUpdateBooking)) {
                psUpdateBooking.setString(1, booking.getFirstName());
                psUpdateBooking.setString(2, booking.getLastName());
                psUpdateBooking.setString(3, booking.getEmail());
                psUpdateBooking.setString(4, booking.getPhone());
                psUpdateBooking.setString(5, booking.getAddress());
                psUpdateBooking.setString(6, booking.getNote());
                psUpdateBooking.setInt(7, booking.getNumberAdult());
                psUpdateBooking.setInt(8, booking.getNumberChildren());
                psUpdateBooking.setBoolean(9, booking.isBookedForOther());
                psUpdateBooking.setDouble(10, totalPrice);
                psUpdateBooking.setInt(11, booking.getBookingID());

                int updatedBookingRows = psUpdateBooking.executeUpdate();

                if (updatedBookingRows == 0) {
                    conn.rollback();
                    return false;
                }
            }

            try (PreparedStatement psUpdateDetail = conn.prepareStatement(sqlUpdateDetail)) {
                psUpdateDetail.setInt(1, newQuantity);
                psUpdateDetail.setDouble(2, unitPrice);
                psUpdateDetail.setDouble(3, totalPrice);
                psUpdateDetail.setInt(4, booking.getBookingID());
                psUpdateDetail.executeUpdate();
            }

            conn.commit();
            return true;

        } catch (Exception e) {
            System.out.println("Lỗi cập nhật customer booking: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    public boolean cancelPendingBookingAndRelease(int bookingID) {
        return updateBookingStatus(bookingID, Booking.STATUS_CANCELLED);
    }

    public boolean syncPendingBookingFromPendingPayment(int bookingID) {
        String sql = """
                SELECT b.[status] AS bookingStatus, p.[status] AS paymentStatus
                FROM Booking b
                LEFT JOIN Payment p ON p.bookingID = b.bookingID
                WHERE b.bookingID = ?
                """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingID);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return false;
                }

                String bookingStatus = rs.getString("bookingStatus");
                String paymentStatus = rs.getString("paymentStatus");

                if (!PaymentDAO.STATUS_PENDING.equalsIgnoreCase(paymentStatus)) {
                    return false;
                }

                if (Booking.isCancelledStatus(bookingStatus)
                        || Booking.isEndedStatus(bookingStatus)) {
                    return false;
                }

                if (Booking.isProcessingStatus(bookingStatus)) {
                    return false;
                }
            }
        } catch (Exception e) {
            System.out.println("Loi dong bo booking pending tu payment pending: " + e.getMessage());
            e.printStackTrace();
            return false;
        }

        return updateBookingStatus(bookingID, Booking.STATUS_PROCESSING);
    }

    public boolean syncPendingBookingFromPaidPayment(int bookingID) {
        String sql = """
                SELECT b.[status] AS bookingStatus, p.[status] AS paymentStatus
                FROM Booking b
                LEFT JOIN Payment p ON p.bookingID = b.bookingID
                WHERE b.bookingID = ?
                """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingID);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return false;
                }

                String bookingStatus = rs.getString("bookingStatus");
                String paymentStatus = rs.getString("paymentStatus");

                if (!PaymentDAO.STATUS_PAID.equalsIgnoreCase(paymentStatus)) {
                    return false;
                }

                if (Booking.isProcessingStatus(bookingStatus)
                        || Booking.isApprovedStatus(bookingStatus)
                        || Booking.isCompletedStatus(bookingStatus)
                        || Booking.isEndedStatus(bookingStatus)) {
                    return true;
                }

                if (Booking.isCancelledStatus(bookingStatus)) {
                    return false;
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi đồng bộ booking đã thanh toán: " + e.getMessage());
            e.printStackTrace();
            return false;
        }

        return false;
    }

    public boolean hasPayableReservationForPayment(int bookingID) {
        String sql = """
                SELECT b.bookingType, b.[status], bd.quantity,
                       ts.tourScheduleID, ts.maxParticipants, ts.quantity AS bookedSeats, ts.scheduleStatus,
                       r.roomID, r.numberOfRooms, r.[status] AS roomStatus
                FROM Booking b
                INNER JOIN Booking_Detail bd ON bd.bookingID = b.bookingID
                LEFT JOIN Tour_Scheduler ts ON ts.tourScheduleID = bd.tourScheduleID
                LEFT JOIN Room r ON r.roomID = bd.roomID
                WHERE b.bookingID = ?
                """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingID);

            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return false;
                }

                String bookingStatus = rs.getString("status");
                if (Booking.isCancelledStatus(bookingStatus)
                        || Booking.isCompletedStatus(bookingStatus)
                        || Booking.isEndedStatus(bookingStatus)) {
                    return false;
                }

                String bookingType = rs.getString("bookingType");
                int quantity = rs.getInt("quantity");
                if (quantity <= 0) {
                    return false;
                }

                if ("Tour".equalsIgnoreCase(bookingType)) {
                    int tourScheduleID = rs.getInt("tourScheduleID");
                    int maxParticipants = rs.getInt("maxParticipants");
                    int bookedSeats = rs.getInt("bookedSeats");
                    String scheduleStatus = rs.getString("scheduleStatus");
                    return tourScheduleID > 0
                            && maxParticipants >= bookedSeats
                            && !"Cancelled".equalsIgnoreCase(scheduleStatus);
                }

                if ("Accommodation".equalsIgnoreCase(bookingType)) {
                    int roomID = rs.getInt("roomID");
                    int numberOfRooms = rs.getInt("numberOfRooms");
                    String roomStatus = rs.getString("roomStatus");
                    return roomID > 0
                            && numberOfRooms >= quantity
                            && ("Available".equalsIgnoreCase(roomStatus)
                            || "Active".equalsIgnoreCase(roomStatus));
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi kiểm tra slot trước khi thanh toán: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    public boolean releasePendingPaymentReservation(int bookingID,
                                                    boolean expiredOnly,
                                                    String note) {
        boolean hasCheckoutUrl = hasPaymentColumn("checkoutUrl");
        boolean hasPaymentLinkId = hasPaymentColumn("paymentLinkId");
        boolean hasDescription = hasPaymentColumn("description");
        boolean hasExpiredAt = hasPaymentColumn("expiredAt");
        String paymentTextColumn = hasDescription ? "description" : "note";
        String expirationFilter = "";
        if (hasExpiredAt) {
            expirationFilter = " AND p.expiredAt IS NOT NULL"
                    + (expiredOnly ? " AND p.expiredAt <= GETDATE()" : "");
        } else if (expiredOnly) {
            expirationFilter = " AND p.createdAt <= DATEADD(MINUTE, -15, GETDATE())";
        }

        String sqlGetReservation = """
                SELECT bd.tourScheduleID, bd.roomID, bd.quantity
                FROM Payment p WITH (UPDLOCK, HOLDLOCK)
                INNER JOIN Booking b ON b.bookingID = p.bookingID
                LEFT JOIN Booking_Detail bd ON bd.bookingID = b.bookingID
                WHERE p.bookingID = ? AND p.[status] = N'Pending'
                  AND b.[status] IN (N'Pending', N'Đang xử lý', N'Chờ xử lý')
                  AND LEFT(ISNULL(p.%s, N''), 15) <> N'[SLOT_RELEASED]'
                """.formatted(paymentTextColumn) + expirationFilter;
        String sqlReleaseTour = """
                UPDATE Tour_Scheduler
                SET quantity = CASE WHEN quantity - ? < 0 THEN 0 ELSE quantity - ? END
                WHERE tourScheduleID = ?
                """;
        String sqlReleaseRoom = """
                UPDATE Room
                SET roomAvailability = CASE
                    WHEN roomAvailability + ? > numberOfRooms THEN numberOfRooms
                    ELSE roomAvailability + ? END,
                    updatedAt = GETDATE()
                WHERE roomID = ?
                """;
        String sqlMarkReleased = """
                UPDATE Payment
                SET [status] = N'Cancelled',
                    %s%s %s = ?
                WHERE bookingID = ? AND [status] = N'Pending'
                  AND LEFT(ISNULL(%s, N''), 15) <> N'[SLOT_RELEASED]'
                """.formatted(
                hasCheckoutUrl ? "checkoutUrl = NULL, " : (hasPaymentLinkId ? "paymentLinkId = NULL, " : ""),
                hasExpiredAt ? "expiredAt = NULL, " : "",
                paymentTextColumn,
                paymentTextColumn);
        String sqlCancelBooking = """
                UPDATE Booking
                SET [status] = ?, updatedAt = GETDATE()
                WHERE bookingID = ? AND [status] IN (N'Pending', N'Đang xử lý', N'Chờ xử lý')
                """;

        try (Connection conn = new DBConnection().getConnection()) {
            conn.setAutoCommit(false);
            try {
                int tourScheduleID;
                int roomID;
                int quantity;
                try (PreparedStatement ps = conn.prepareStatement(sqlGetReservation)) {
                    ps.setInt(1, bookingID);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) {
                            conn.rollback();
                            return false;
                        }
                        tourScheduleID = rs.getInt("tourScheduleID");
                        roomID = rs.getInt("roomID");
                        quantity = rs.getInt("quantity");
                    }
                }

                if (quantity > 0 && tourScheduleID > 0
                        && !executeQuantityUpdate(conn, sqlReleaseTour, quantity, tourScheduleID)) {
                    conn.rollback();
                    return false;
                }
                if (quantity > 0 && roomID > 0
                        && !executeQuantityUpdate(conn, sqlReleaseRoom, quantity, roomID)) {
                    conn.rollback();
                    return false;
                }

                try (PreparedStatement ps = conn.prepareStatement(sqlMarkReleased)) {
                    ps.setNString(1, "[SLOT_RELEASED] " + note);
                    ps.setInt(2, bookingID);
                    if (ps.executeUpdate() == 0) {
                        conn.rollback();
                        return false;
                    }
                }

                try (PreparedStatement ps = conn.prepareStatement(sqlCancelBooking)) {
                    ps.setNString(1, Booking.STATUS_CANCELLED);
                    ps.setInt(2, bookingID);
                    if (ps.executeUpdate() == 0) {
                        conn.rollback();
                        return false;
                    }
                }

                if (!restoreVoucherUsage(conn, bookingID)) {
                    conn.rollback();
                    return false;
                }

                conn.commit();
                return true;
            } catch (Exception e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (Exception e) {
            System.out.println("Lỗi hoàn chỗ giữ thanh toán: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    private boolean cancelPendingPayment(Connection conn, int bookingID, String note) throws Exception {
        boolean hasCheckoutUrl = hasPaymentColumn("checkoutUrl");
        boolean hasPaymentLinkId = hasPaymentColumn("paymentLinkId");
        boolean hasDescription = hasPaymentColumn("description");
        boolean hasExpiredAt = hasPaymentColumn("expiredAt");
        String paymentTextColumn = hasDescription ? "description" : "note";

        String sql = """
                UPDATE Payment
                SET [status] = N'Cancelled',
                    %s%s%s = ?
                WHERE bookingID = ? AND [status] = N'Pending'
                """.formatted(
                hasCheckoutUrl ? "checkoutUrl = NULL, " : (hasPaymentLinkId ? "paymentLinkId = NULL, " : ""),
                hasExpiredAt ? "expiredAt = NULL, " : "",
                paymentTextColumn);

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setNString(1, note);
            ps.setInt(2, bookingID);
            ps.executeUpdate();
            return true;
        }
    }

    private boolean restoreVoucherUsage(Connection conn, int bookingID) throws Exception {
        String sqlSelect = """
                SELECT userVoucherID, voucherID
                FROM User_Voucher WITH (UPDLOCK, ROWLOCK)
                WHERE bookingID = ? AND UPPER([status]) = N'USED'
                """;
        String sqlResetUserVoucher = """
                UPDATE User_Voucher
                SET [status] = N'SAVED', usedAt = NULL, bookingID = NULL
                WHERE userVoucherID = ?
                """;
        String sqlRestoreVoucherCount = """
                UPDATE Voucher
                SET usedCount = CASE WHEN usedCount > 0 THEN usedCount - 1 ELSE 0 END,
                    updatedAt = GETDATE()
                WHERE voucherID = ?
                """;

        List<Integer> userVoucherIDs = new ArrayList<>();
        List<Integer> voucherIDs = new ArrayList<>();

        try (PreparedStatement ps = conn.prepareStatement(sqlSelect)) {
            ps.setInt(1, bookingID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    userVoucherIDs.add(rs.getInt("userVoucherID"));
                    voucherIDs.add(rs.getInt("voucherID"));
                }
            }
        }

        for (int i = 0; i < userVoucherIDs.size(); i++) {
            try (PreparedStatement psUserVoucher = conn.prepareStatement(sqlResetUserVoucher);
                 PreparedStatement psVoucher = conn.prepareStatement(sqlRestoreVoucherCount)) {
                psUserVoucher.setInt(1, userVoucherIDs.get(i));
                if (psUserVoucher.executeUpdate() == 0) {
                    return false;
                }

                psVoucher.setInt(1, voucherIDs.get(i));
                if (psVoucher.executeUpdate() == 0) {
                    return false;
                }
            }
        }

        return true;
    }

    private boolean hasPaymentColumn(String columnName) {
        String sql = """
                SELECT 1
                FROM INFORMATION_SCHEMA.COLUMNS
                WHERE TABLE_SCHEMA = 'dbo'
                  AND TABLE_NAME = 'Payment'
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
}
