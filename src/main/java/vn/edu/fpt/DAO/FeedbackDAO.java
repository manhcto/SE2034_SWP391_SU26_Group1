package vn.edu.fpt.DAO;

import vn.edu.fpt.common.DBConnection;
import vn.edu.fpt.model.Feedback;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

public class FeedbackDAO {

    private static final String MANAGEMENT_TARGET_APPLY =
            "OUTER APPLY (" +
                    "SELECT TOP (1) " +
                    "CASE WHEN t.tourID IS NOT NULL THEN N'Tour' " +
                    "WHEN a.accommodationID IS NOT NULL THEN N'Accommodation' " +
                    "ELSE N'Unknown' END AS serviceType, " +
                    "t.tourID, a.accommodationID, " +
                    "COALESCE(t.tourName, a.[name], N'Không xác định') AS serviceName " +
                    "FROM Booking_Detail bd " +
                    "LEFT JOIN Tour_Scheduler ts ON ts.tourScheduleID = bd.tourScheduleID " +
                    "LEFT JOIN Tour t ON t.tourID = ts.tourID " +
                    "LEFT JOIN Room r ON r.roomID = bd.roomID " +
                    "LEFT JOIN Accommodation a " +
                    "ON a.accommodationID = COALESCE(bd.accommodationID, r.accommodationID) " +
                    "WHERE bd.bookingID = f.bookingID " +
                    "ORDER BY CASE WHEN t.tourID IS NOT NULL THEN 0 " +
                    "WHEN a.accommodationID IS NOT NULL THEN 1 ELSE 2 END, bd.bookingDetailID" +
                    ") feedbackTarget ";

    // Get all feedbacks
    public List<Feedback> getAllFeedbacks() {
        List<Feedback> feedbackList = new ArrayList<>();

        String sql = "SELECT f.feedbackID, f.rate, f.content, f.createDate, f.status, "
                + "f.image, f.userID, f.bookingID, feedbackTarget.serviceType, "
                + "COALESCE(feedbackTarget.tourID, feedbackTarget.accommodationID, 0) AS serviceID, "
                + "feedbackTarget.serviceName "
                + "FROM Feedback f "
                + MANAGEMENT_TARGET_APPLY
                + "ORDER BY f.createDate DESC";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                feedbackList.add(mapManagedFeedback(rs));
            }

        } catch (Exception e) {
            System.out.println("Lỗi lấy danh sách đánh giá: " + e.getMessage());
            e.printStackTrace();
        }

        return feedbackList;
    }

    public List<Feedback> getFeedbacksForManagement(
            String serviceType, String status, String keyword) {
        String normalizedType = normalizeManagementServiceType(serviceType);
        String normalizedStatus = normalizeManagementStatus(status);
        String normalizedKeyword = keyword == null ? "" : keyword.trim();

        StringBuilder sql = new StringBuilder(
                "SELECT f.feedbackID, f.rate, f.content, f.createDate, f.status, "
                        + "f.image, f.userID, f.bookingID, feedbackTarget.serviceType, "
                        + "COALESCE(feedbackTarget.tourID, feedbackTarget.accommodationID, 0) AS serviceID, "
                        + "feedbackTarget.serviceName "
                        + "FROM Feedback f "
                        + "LEFT JOIN Booking b ON b.bookingID = f.bookingID "
                        + "LEFT JOIN [User] u ON u.userID = f.userID "
                        + MANAGEMENT_TARGET_APPLY
                        + "WHERE 1 = 1 ");

        List<Object> parameters = new ArrayList<>();

        if (!normalizedType.isEmpty()) {
            sql.append("AND feedbackTarget.serviceType = ? ");
            parameters.add(normalizedType);
        }

        if (!normalizedStatus.isEmpty()) {
            sql.append("AND f.status = ? ");
            parameters.add(normalizedStatus);
        }

        if (!normalizedKeyword.isEmpty()) {
            String keywordPattern = "%" + normalizedKeyword.toLowerCase(Locale.ROOT) + "%";
            sql.append("AND ("
                    + "LOWER(COALESCE(feedbackTarget.serviceName, N'')) LIKE ? "
                    + "OR LOWER(COALESCE(f.content, N'')) LIKE ? "
                    + "OR LOWER(COALESCE(b.bookingCode, N'')) LIKE ? "
                    + "OR LOWER(CONCAT(COALESCE(u.firstName, N''), N' ', COALESCE(u.lastName, N''))) LIKE ? "
                    + "OR LOWER(CONCAT(COALESCE(b.firstName, N''), N' ', COALESCE(b.lastName, N''))) LIKE ? "
                    + "OR CAST(f.feedbackID AS NVARCHAR(20)) LIKE ? "
                    + "OR CAST(f.bookingID AS NVARCHAR(20)) LIKE ?"
                    + ") ");

            for (int i = 0; i < 7; i++) {
                parameters.add(keywordPattern);
            }
        }

        sql.append("ORDER BY f.createDate DESC, f.feedbackID DESC");

        List<Feedback> feedbackList = new ArrayList<>();

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int index = 0; index < parameters.size(); index++) {
                ps.setObject(index + 1, parameters.get(index));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    feedbackList.add(mapManagedFeedback(rs));
                }
            }

        } catch (Exception e) {
            System.out.println("Lỗi tìm kiếm và lọc đánh giá: " + e.getMessage());
            e.printStackTrace();
        }

        return feedbackList;
    }

    private String normalizeManagementServiceType(String serviceType) {
        if ("Tour".equalsIgnoreCase(serviceType == null ? "" : serviceType.trim())) {
            return "Tour";
        }
        if ("Accommodation".equalsIgnoreCase(serviceType == null ? "" : serviceType.trim())) {
            return "Accommodation";
        }
        return "";
    }

    private String normalizeManagementStatus(String status) {
        if ("Visible".equalsIgnoreCase(status == null ? "" : status.trim())) {
            return "Visible";
        }
        if ("Hidden".equalsIgnoreCase(status == null ? "" : status.trim())) {
            return "Hidden";
        }
        return "";
    }

    // Get feedbacks by tourID (Feedback -> Booking -> Booking_Detail -> Tour_Scheduler -> Tour)
    public List<Feedback> getFeedbacksByTourID(int tourID) {
        List<Feedback> feedbackList = new ArrayList<>();

        String sql = "SELECT DISTINCT f.feedbackID, f.rate, f.content, f.createDate, f.status, f.image, f.userID, f.bookingID "
                + "FROM Feedback f "
                + "JOIN Booking b ON f.bookingID = b.bookingID "
                + "JOIN Booking_Detail bd ON b.bookingID = bd.bookingID "
                + "JOIN Tour_Scheduler ts ON bd.tourScheduleID = ts.tourScheduleID "
                + "WHERE ts.tourID = ? "
                + "ORDER BY f.createDate DESC";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, tourID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    feedbackList.add(mapFeedback(rs));
                }
            }

        } catch (Exception e) {
            System.out.println("Lỗi lấy đánh giá theo tour: " + e.getMessage());
            e.printStackTrace();
        }

        return feedbackList;
    }

    // Get feedbacks by accommodationID (Feedback -> Booking -> Booking_Detail)
    public List<Feedback> getFeedbacksByAccommodationID(int accommodationID) {
        List<Feedback> feedbackList = new ArrayList<>();

        String sql = "SELECT DISTINCT f.feedbackID, f.rate, f.content, f.createDate, f.status, f.image, f.userID, f.bookingID "
                + "FROM Feedback f "
                + "JOIN Booking b ON f.bookingID = b.bookingID "
                + "JOIN Booking_Detail bd ON b.bookingID = bd.bookingID "
                + "WHERE bd.accommodationID = ? "
                + "ORDER BY f.createDate DESC";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, accommodationID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    feedbackList.add(mapFeedback(rs));
                }
            }

        } catch (Exception e) {
            System.out.println("Lỗi lấy đánh giá theo lưu trú: " + e.getMessage());
            e.printStackTrace();
        }

        return feedbackList;
    }

    // ==========================================================
    // CÁC METHOD MỚI CHO LUỒNG FEEDBACK CỦA CUSTOMER
    // ==========================================================

    // Lấy các feedback ĐÃ DUYỆT (Visible) của 1 tour, kèm tên người đánh giá
    public List<Map<String, Object>> getVisibleFeedbacksByTourID(int tourID) {
        String sql = "SELECT DISTINCT f.feedbackID, f.rate, f.content, f.createDate, f.image, "
                + "u.firstName, u.lastName "
                + "FROM Feedback f "
                + "JOIN [User] u ON f.userID = u.userID "
                + "JOIN Booking b ON f.bookingID = b.bookingID "
                + "JOIN Booking_Detail bd ON b.bookingID = bd.bookingID "
                + "JOIN Tour_Scheduler ts ON bd.tourScheduleID = ts.tourScheduleID "
                + "WHERE ts.tourID = ? AND f.status = 'Visible' "
                + "ORDER BY f.createDate DESC";

        return getVisibleFeedbacksWithUser(sql, tourID);
    }

    // Lấy các feedback ĐÃ DUYỆT (Visible) của 1 nơi lưu trú, kèm tên người đánh giá
    public List<Map<String, Object>> getVisibleFeedbacksByAccommodationID(int accommodationID) {
        String sql = "SELECT DISTINCT f.feedbackID, f.rate, f.content, f.createDate, f.image, "
                + "u.firstName, u.lastName "
                + "FROM Feedback f "
                + "JOIN [User] u ON f.userID = u.userID "
                + "JOIN Booking b ON f.bookingID = b.bookingID "
                + "JOIN Booking_Detail bd ON b.bookingID = bd.bookingID "
                + "WHERE bd.accommodationID = ? AND f.status = 'Visible' "
                + "ORDER BY f.createDate DESC";

        return getVisibleFeedbacksWithUser(sql, accommodationID);
    }

    // Dùng chung cho 2 method phía trên
    private List<Map<String, Object>> getVisibleFeedbacksWithUser(String sql, int filterID) {
        List<Map<String, Object>> feedbackList = new ArrayList<>();

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, filterID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> item = new HashMap<>();

                    item.put("feedbackID", rs.getInt("feedbackID"));
                    item.put("rate", rs.getDouble("rate"));
                    item.put("content", rs.getString("content"));
                    item.put("createDate", rs.getTimestamp("createDate"));
                    item.put("image", rs.getString("image"));

                    String firstName = rs.getString("firstName");
                    String lastName = rs.getString("lastName");
                    String userName = ((firstName == null ? "" : firstName) + " "
                            + (lastName == null ? "" : lastName)).trim();

                    item.put("userName", userName.isEmpty() ? "Khách hàng" : userName);

                    feedbackList.add(item);
                }
            }

        } catch (Exception e) {
            System.out.println("Lỗi lấy đánh giá đã duyệt: " + e.getMessage());
            e.printStackTrace();
        }

        return feedbackList;
    }

    // Chỉ booking đã kết thúc dịch vụ mới được phép gửi đánh giá.
    public int getLatestEndedBookingIDByTour(int userID, int tourID) {
        String sql = "SELECT TOP 1 b.bookingID "
                + "FROM Booking b "
                + "JOIN Booking_Detail bd ON b.bookingID = bd.bookingID "
                + "JOIN Tour_Scheduler ts ON bd.tourScheduleID = ts.tourScheduleID "
                + "WHERE b.userID = ? AND ts.tourID = ? "
                + "AND b.status IN (N'End', N'Ended', N'Tour kết thúc', N'Đã kết thúc') "
                + "AND NOT EXISTS (SELECT 1 FROM Feedback existing WHERE existing.bookingID = b.bookingID) "
                + "ORDER BY b.bookDate DESC, b.bookingID DESC";

        return getLatestEndedBookingID(sql, userID, tourID);
    }

    public int getLatestEndedBookingIDByAccommodation(int userID, int accommodationID) {
        String sql = "SELECT TOP 1 b.bookingID "
                + "FROM Booking b "
                + "JOIN Booking_Detail bd ON b.bookingID = bd.bookingID "
                + "WHERE b.userID = ? AND bd.accommodationID = ? "
                + "AND b.status IN (N'End', N'Ended', N'Tour kết thúc', N'Đã kết thúc') "
                + "AND NOT EXISTS (SELECT 1 FROM Feedback existing WHERE existing.bookingID = b.bookingID) "
                + "ORDER BY b.bookDate DESC, b.bookingID DESC";

        return getLatestEndedBookingID(sql, userID, accommodationID);
    }

    private int getLatestEndedBookingID(String sql, int userID, int filterID) {
        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userID);
            ps.setInt(2, filterID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("bookingID");
                }
            }

        } catch (Exception e) {
            System.out.println("Lỗi tìm booking đã kết thúc: " + e.getMessage());
            e.printStackTrace();
        }

        return -1;
    }

    public String getTourNameByID(int tourID) {
        return getServiceName("SELECT tourName FROM Tour WHERE tourID = ?", tourID);
    }

    public String getAccommodationNameByID(int accommodationID) {
        return getServiceName("SELECT [name] FROM Accommodation WHERE accommodationID = ?", accommodationID);
    }

    private String getServiceName(String sql, int serviceID) {
        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, serviceID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String name = rs.getString(1);
                    return name == null ? "" : name.trim();
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi lấy tên dịch vụ: " + e.getMessage());
            e.printStackTrace();
        }
        return "";
    }

    // ==========================================================

    // Map a ResultSet row to a Feedback object
    private Feedback mapFeedback(ResultSet rs) throws Exception {
        Feedback feedback = new Feedback();

        feedback.setFeedbackID(rs.getInt("feedbackID"));
        feedback.setRate(rs.getDouble("rate"));
        feedback.setContent(rs.getString("content"));
        feedback.setCreateDate(rs.getTimestamp("createDate"));
        feedback.setStatus(rs.getString("status"));
        feedback.setImage(rs.getString("image"));
        feedback.setUserID(rs.getInt("userID"));
        feedback.setBookingID(rs.getInt("bookingID"));

        return feedback;
    }

    private Feedback mapManagedFeedback(ResultSet rs) throws Exception {
        Feedback feedback = mapFeedback(rs);
        feedback.setServiceType(rs.getString("serviceType"));
        feedback.setServiceID(rs.getInt("serviceID"));
        feedback.setServiceName(rs.getString("serviceName"));
        return feedback;
    }

    // Get feedback by ID
    public Feedback getFeedbackByID(int feedbackID) {
        String sql = "SELECT feedbackID, rate, content, createDate, status, image, userID, bookingID "
                + "FROM Feedback "
                + "WHERE feedbackID = ?";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, feedbackID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapFeedback(rs);
                }
            }

        } catch (Exception e) {
            System.out.println("Lỗi lấy đánh giá theo ID: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    // Get feedback detail with user and booking information
    public Map<String, Object> getFeedbackDetailByID(int feedbackID) {
        String sql = "SELECT "
                + "f.feedbackID, "
                + "f.rate, "
                + "f.content, "
                + "f.createDate, "
                + "f.status, "
                + "f.image, "
                + "f.userID, "
                + "f.bookingID, "
                + "u.firstName, "
                + "u.lastName, "
                + "u.email, "
                + "b.bookingCode, "
                + "b.bookingType, "
                + "b.totalPrice, "
                + "feedbackTarget.serviceType, "
                + "COALESCE(feedbackTarget.tourID, feedbackTarget.accommodationID, 0) AS serviceID, "
                + "feedbackTarget.serviceName "
                + "FROM Feedback f "
                + "LEFT JOIN [User] u ON f.userID = u.userID "
                + "JOIN Booking b ON f.bookingID = b.bookingID "
                + MANAGEMENT_TARGET_APPLY
                + "WHERE f.feedbackID = ?";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, feedbackID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> detail = new HashMap<>();

                    detail.put("feedbackID", rs.getInt("feedbackID"));
                    detail.put("rate", rs.getDouble("rate"));
                    detail.put("content", rs.getString("content"));
                    detail.put("createDate", rs.getTimestamp("createDate"));
                    detail.put("status", rs.getString("status"));
                    detail.put("image", rs.getString("image"));
                    detail.put("userID", rs.getInt("userID"));
                    detail.put("bookingID", rs.getInt("bookingID"));

                    detail.put("firstName", rs.getString("firstName"));
                    detail.put("lastName", rs.getString("lastName"));
                    detail.put("email", rs.getString("email"));
                    detail.put("bookingCode", rs.getString("bookingCode"));
                    detail.put("bookingType", rs.getString("bookingType"));
                    detail.put("totalPrice", rs.getDouble("totalPrice"));
                    detail.put("serviceType", rs.getString("serviceType"));
                    detail.put("serviceID", rs.getInt("serviceID"));
                    detail.put("serviceName", rs.getString("serviceName"));

                    return detail;
                }
            }

        } catch (Exception e) {
            System.out.println("Lỗi lấy chi tiết đánh giá: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    // Insert feedback and return generated feedback ID
    public int insertFeedback(Feedback feedback) {
        String sql = "INSERT INTO Feedback (rate, content, status, image, userID, bookingID) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setDouble(1, feedback.getRate());
            ps.setString(2, feedback.getContent());
            ps.setString(3, feedback.getStatus());
            ps.setString(4, feedback.getImage());
            ps.setInt(5, feedback.getUserID());
            ps.setInt(6, feedback.getBookingID());

            int affectedRows = ps.executeUpdate();

            if (affectedRows == 0) {
                return -1;
            }

            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }

        } catch (Exception e) {
            System.out.println("Lỗi thêm feedback: " + e.getMessage());
            e.printStackTrace();
        }

        return -1;
    }

    // Update feedback information (chỉ còn dùng cho staff duyệt trạng thái)
    public boolean updateFeedback(Feedback feedback) {
        String sql = "UPDATE Feedback "
                + "SET rate = ?, "
                + "content = ?, "
                + "status = ?, "
                + "image = ? "
                + "WHERE feedbackID = ?";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDouble(1, feedback.getRate());
            ps.setString(2, feedback.getContent());
            ps.setString(3, feedback.getStatus());
            ps.setString(4, feedback.getImage());
            ps.setInt(5, feedback.getFeedbackID());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("Lỗi cập nhật feedback: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    // Check if booking exists
    public boolean isBookingExist(int bookingID) {
        String sql = "SELECT bookingID FROM Booking WHERE bookingID = ?";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookingID);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (Exception e) {
            System.out.println("Lỗi kiểm tra bookingID: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    // Check if user exists
    public boolean isUserExist(int userID) {
        String sql = "SELECT userID FROM [User] WHERE userID = ?";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userID);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (Exception e) {
            System.out.println("Lỗi kiểm tra userID: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }
}
