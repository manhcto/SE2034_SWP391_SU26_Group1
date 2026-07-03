package vn.edu.fpt.DAO;

import vn.edu.fpt.common.DBConnection;
import vn.edu.fpt.model.Booking;

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
        String sql = "SELECT t.adultPrice, t.childrenPrice "
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
                + "phone, address, note, numberAdult, numberChildren, totalPrice, isBookedForOther, userID) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

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
        String sqlGetDetail = "SELECT bd.tourScheduleID, bd.quantity, bd.subTotal, t.adultPrice, t.childrenPrice "
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
        String sql = "UPDATE Booking "
                + "SET [status] = ? "
                + "WHERE bookingID = ?";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, bookingID);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("Loi cap nhat trang thai booking: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    // Update customer booking, quantity and total price
    public boolean updateCustomerBooking(Booking booking) {
        String sqlGetDetail = "SELECT bd.tourScheduleID, bd.quantity, t.adultPrice, t.childrenPrice "
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
                + "AND status = 'Pending'";

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

    // Delete booking by ID
    public boolean deleteBookingByID(int bookingID) {
        String sqlGetDetail = "SELECT tourScheduleID, quantity "
                + "FROM Booking_Detail "
                + "WHERE bookingID = ?";

        String sqlDeleteFeedback = "DELETE FROM Feedback "
                + "WHERE bookingID = ?";

        String sqlDeleteDetail = "DELETE FROM Booking_Detail "
                + "WHERE bookingID = ?";

        String sqlUpdateSchedule = "UPDATE Tour_Scheduler "
                + "SET quantity = CASE "
                + "WHEN quantity - ? < 0 THEN 0 "
                + "ELSE quantity - ? "
                + "END "
                + "WHERE tourScheduleID = ?";

        String sqlDeleteBooking = "DELETE FROM Booking "
                + "WHERE bookingID = ?";

        try (Connection conn = new DBConnection().getConnection()) {
            conn.setAutoCommit(false);

            int tourScheduleID = -1;
            int quantity = 0;

            try (PreparedStatement psGetDetail = conn.prepareStatement(sqlGetDetail)) {
                psGetDetail.setInt(1, bookingID);

                try (ResultSet rs = psGetDetail.executeQuery()) {
                    if (rs.next()) {
                        tourScheduleID = rs.getInt("tourScheduleID");
                        quantity = rs.getInt("quantity");
                    }
                }
            }

            try (PreparedStatement psDeleteFeedback = conn.prepareStatement(sqlDeleteFeedback)) {
                psDeleteFeedback.setInt(1, bookingID);
                psDeleteFeedback.executeUpdate();
            }

            try (PreparedStatement psDeleteDetail = conn.prepareStatement(sqlDeleteDetail)) {
                psDeleteDetail.setInt(1, bookingID);
                psDeleteDetail.executeUpdate();
            }

            if (tourScheduleID > 0 && quantity > 0) {
                try (PreparedStatement psUpdateSchedule = conn.prepareStatement(sqlUpdateSchedule)) {
                    psUpdateSchedule.setInt(1, quantity);
                    psUpdateSchedule.setInt(2, quantity);
                    psUpdateSchedule.setInt(3, tourScheduleID);
                    psUpdateSchedule.executeUpdate();
                }
            }

            int deletedRows;

            try (PreparedStatement psDeleteBooking = conn.prepareStatement(sqlDeleteBooking)) {
                psDeleteBooking.setInt(1, bookingID);
                deletedRows = psDeleteBooking.executeUpdate();
            }

            if (deletedRows == 0) {
                conn.rollback();
                return false;
            }

            conn.commit();
            return true;

        } catch (Exception e) {
            System.out.println("Lỗi xóa booking: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }
}
