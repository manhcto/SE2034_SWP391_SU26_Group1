package vn.edu.fpt.DAO;

import vn.edu.fpt.common.DBConnection;
import vn.edu.fpt.model.Booking;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

public class BookingDAO {

    /**
     * Dùng Transaction để lưu đồng thời vào bảng Booking và Booking_Detail
     */
    public boolean insertBookingTransaction(Booking booking, int tourScheduleID, double unitPrice) {

        String sqlBooking = "INSERT INTO Booking (bookingCode, bookingType, firstName, lastName, email, "
                + "phone, address, note, numberAdult, numberChildren, totalPrice, isBookedForOther, userID) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        String sqlDetail = "INSERT INTO Booking_Detail (bookingID, tourScheduleID, quantity, unitPrice, subTotal) "
                + "VALUES (?, ?, ?, ?, ?)";

        // Lấy connection từ file DBConnection của bạn
        try (Connection conn = new DBConnection().getConnection()) {

            // TẮT CHẾ ĐỘ TỰ ĐỘNG LƯU ĐỂ BẮT ĐẦU TRANSACTION
            conn.setAutoCommit(false);

            // 1. Lưu vào bảng Booking
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

                // 2. Lấy BookingID vừa được tự động sinh ra
                int generatedBookingID = 0;
                try (ResultSet generatedKeys = psBooking.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        generatedBookingID = generatedKeys.getInt(1);
                    } else {
                        conn.rollback();
                        return false; // Không lấy được ID -> hủy giao dịch
                    }
                }

                // 3. Lưu tiếp vào bảng Booking_Detail
                try (PreparedStatement psDetail = conn.prepareStatement(sqlDetail)) {
                    int totalQuantity = booking.getNumberAdult() + booking.getNumberChildren();

                    psDetail.setInt(1, generatedBookingID); // Truyền ID lấy được ở trên vào đây
                    psDetail.setInt(2, tourScheduleID);
                    psDetail.setInt(3, totalQuantity);
                    psDetail.setDouble(4, unitPrice);
                    psDetail.setDouble(5, booking.getTotalPrice()); // Subtotal bằng luôn TotalPrice cho dễ

                    psDetail.executeUpdate();
                }

                // 4. Nếu CẢ 2 bước đều trơn tru -> CHỐT LƯU XUỐNG DATABASE
                conn.commit();
                return true;

            } catch (Exception e) {
                // NẾU CÓ BẤT KỲ LỖI NÀO XẢY RA, LẬP TỨC THU HỒI LẠI TOÀN BỘ
                conn.rollback();
                System.out.println("Lỗi Transaction, đã rollback dữ liệu: " + e.getMessage());
                e.printStackTrace();
            } finally {
                // Trả lại cài đặt mặc định cho Connection
                conn.setAutoCommit(true);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}