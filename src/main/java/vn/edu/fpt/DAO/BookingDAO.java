package vn.edu.fpt.DAO;

import vn.edu.fpt.common.DBConnection;
import vn.edu.fpt.model.Booking;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

public class BookingDAO {

    /**
     * Kiểm tra tourScheduleID có tồn tại hay không.
     */
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

    /**
     * Lấy giá người lớn và giá trẻ em từ database dựa vào tourScheduleID.
     * Không lấy giá từ form để tránh người dùng sửa giá bằng F12.
     *
     * return double[0] = adultPrice
     *        double[1] = childrenPrice
     */
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

    /**
     * Lấy số chỗ còn lại của lịch trình tour.
     * Nếu không tìm thấy tourScheduleID thì trả về -1.
     */
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

    /**
     * Dùng Transaction để lưu đồng thời:
     * 1. Booking
     * 2. Booking_Detail
     * 3. Cập nhật Tour_Scheduler.quantity
     *
     * Nếu một bước lỗi thì rollback toàn bộ.
     */
    public boolean insertBookingTransaction(Booking booking, int tourScheduleID, double unitPrice) {

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
                    return false;
                }

                int generatedBookingID;

                try (ResultSet generatedKeys = psBooking.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        generatedBookingID = generatedKeys.getInt(1);
                    } else {
                        conn.rollback();
                        return false;
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
                        return false;
                    }
                }

                conn.commit();
                return true;

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

        return false;
    }
}