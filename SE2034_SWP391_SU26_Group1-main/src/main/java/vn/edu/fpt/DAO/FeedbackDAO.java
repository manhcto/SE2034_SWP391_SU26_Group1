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
import java.util.Map;

public class FeedbackDAO {

    // Get all feedbacks
    public List<Feedback> getAllFeedbacks() {
        List<Feedback> feedbackList = new ArrayList<>();

        String sql = "SELECT feedbackID, rate, content, createDate, status, image, userID, bookingID "
                + "FROM Feedback "
                + "ORDER BY createDate DESC";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Feedback feedback = new Feedback();

                feedback.setFeedbackID(rs.getInt("feedbackID"));
                feedback.setRate(rs.getDouble("rate"));
                feedback.setContent(rs.getString("content"));
                feedback.setCreateDate(rs.getTimestamp("createDate"));
                feedback.setStatus(rs.getString("status"));
                feedback.setImage(rs.getString("image"));
                feedback.setUserID(rs.getInt("userID"));
                feedback.setBookingID(rs.getInt("bookingID"));

                feedbackList.add(feedback);
            }

        } catch (Exception e) {
            System.out.println("Lỗi lấy danh sách feedback: " + e.getMessage());
            e.printStackTrace();
        }

        return feedbackList;
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
            }

        } catch (Exception e) {
            System.out.println("Lỗi lấy feedback theo ID: " + e.getMessage());
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
                + "b.totalPrice "
                + "FROM Feedback f "
                + "JOIN [User] u ON f.userID = u.userID "
                + "JOIN Booking b ON f.bookingID = b.bookingID "
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

                    return detail;
                }
            }

        } catch (Exception e) {
            System.out.println("Lỗi lấy chi tiết feedback: " + e.getMessage());
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

    // Update feedback information
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