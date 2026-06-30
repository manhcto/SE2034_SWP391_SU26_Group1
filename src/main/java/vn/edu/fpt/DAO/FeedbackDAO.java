package vn.edu.fpt.DAO;

import vn.edu.fpt.common.DBConnection;
import vn.edu.fpt.model.Feedback;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class FeedbackDAO {

    public List<Feedback> getAllFeedbacks() {
        return getFeedbacksByType("All");
    }

    public List<Feedback> getFeedbacksByType(String type) {
        List<Feedback> feedbackList = new ArrayList<>();

        String serviceType = normalizeServiceType(type);

        StringBuilder sql = new StringBuilder();
        sql.append(getFeedbackSummarySelect());
        sql.append(" FROM Feedback f ");
        sql.append(" JOIN [User] u ON f.userID = u.userID ");
        sql.append(" JOIN Booking b ON f.bookingID = b.bookingID ");
        sql.append(" OUTER APPLY ( ");
        sql.append("     SELECT TOP 1 bd.* ");
        sql.append("     FROM Booking_Detail bd ");
        sql.append("     WHERE bd.bookingID = b.bookingID ");
        sql.append("     ORDER BY bd.bookingDetailID DESC ");
        sql.append(" ) bd ");
        sql.append(" LEFT JOIN Service s ON bd.serviceID = s.serviceID ");
        sql.append(" LEFT JOIN Accommodation a ON bd.serviceID = a.serviceID ");
        sql.append(" LEFT JOIN Vehicle v ON bd.serviceID = v.serviceID ");
        sql.append(" LEFT JOIN Tour_Scheduler ts ON bd.tourScheduleID = ts.tourScheduleID ");
        sql.append(" LEFT JOIN Tour t ON ts.tourID = t.tourID ");

        if (!"All".equals(serviceType)) {
            sql.append(" WHERE ");
            sql.append(getServiceTypeCondition(serviceType));
        }

        sql.append(" ORDER BY f.createDate DESC, f.feedbackID DESC ");

        try (Connection connection = new DBConnection().getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql.toString());
             ResultSet resultSet = preparedStatement.executeQuery()) {

            while (resultSet.next()) {
                feedbackList.add(mapFeedbackSummary(resultSet, null));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return feedbackList;
    }

    public List<Feedback> getFeedbacksByService(String type, int serviceID) {
        return getFeedbacksByService(type, serviceID, null);
    }

    public List<Feedback> getFeedbacksByService(String type, int serviceID, Integer currentUserID) {
        List<Feedback> feedbackList = new ArrayList<>();

        String serviceType = normalizeServiceType(type);

        StringBuilder sql = new StringBuilder();
        sql.append(getFeedbackSummarySelect());
        sql.append(" FROM Feedback f ");
        sql.append(" JOIN [User] u ON f.userID = u.userID ");
        sql.append(" JOIN Booking b ON f.bookingID = b.bookingID ");
        sql.append(" JOIN Booking_Detail bd ON b.bookingID = bd.bookingID ");
        sql.append(" LEFT JOIN Service s ON bd.serviceID = s.serviceID ");
        sql.append(" LEFT JOIN Accommodation a ON bd.serviceID = a.serviceID ");
        sql.append(" LEFT JOIN Vehicle v ON bd.serviceID = v.serviceID ");
        sql.append(" LEFT JOIN Tour_Scheduler ts ON bd.tourScheduleID = ts.tourScheduleID ");
        sql.append(" LEFT JOIN Tour t ON ts.tourID = t.tourID ");
        sql.append(" WHERE bd.serviceID = ? ");

        if (!"All".equals(serviceType)) {
            sql.append(" AND ");
            sql.append(getServiceTypeCondition(serviceType));
        }

        if (currentUserID != null && currentUserID > 0) {
            sql.append(" AND (f.status = 'Visible' OR f.userID = ?) ");
        } else {
            sql.append(" AND f.status = 'Visible' ");
        }

        sql.append(" ORDER BY f.createDate DESC, f.feedbackID DESC ");

        try (Connection connection = new DBConnection().getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql.toString())) {

            preparedStatement.setInt(1, serviceID);

            if (currentUserID != null && currentUserID > 0) {
                preparedStatement.setInt(2, currentUserID);
            }

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                while (resultSet.next()) {
                    feedbackList.add(mapFeedbackSummary(resultSet, currentUserID));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return feedbackList;
    }

    public Feedback getFeedbackByID(int feedbackID) {
        String sql = "SELECT feedbackID, rate, content, createDate, status, image, userID, bookingID "
                + "FROM Feedback "
                + "WHERE feedbackID = ?";

        try (Connection connection = new DBConnection().getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, feedbackID);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    return mapBasicFeedback(resultSet);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public Map<String, Object> getFeedbackDetailByID(int feedbackID) {
        return getFeedbackDetailByID(feedbackID, null);
    }

    public Map<String, Object> getFeedbackDetailByID(int feedbackID, Integer currentUserID) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT ");
        sql.append(" f.feedbackID, f.rate, f.content, f.createDate, f.status, f.image, ");
        sql.append(" f.userID, f.bookingID, ");
        sql.append(" u.firstName, u.lastName, u.email, ");
        sql.append(" b.bookingCode, b.bookingType, b.totalPrice, b.status AS bookingStatus, b.bookDate, ");
        sql.append(" bd.bookingDetailID, bd.serviceID, bd.tourScheduleID, bd.quantity, ");
        sql.append(" bd.unitPrice, bd.subTotal, bd.startDate, bd.endDate, bd.note AS bookingDetailNote, ");
        sql.append(" COALESCE(a.name, v.vehicleModel, t.tourName, s.serviceName, N'Dịch vụ') AS serviceName, ");
        sql.append(" COALESCE(a.image, v.image, t.image, NULL) AS serviceImage, ");
        sql.append(getServiceTypeCase());
        sql.append(" AS serviceType ");
        sql.append(" FROM Feedback f ");
        sql.append(" JOIN [User] u ON f.userID = u.userID ");
        sql.append(" JOIN Booking b ON f.bookingID = b.bookingID ");
        sql.append(" OUTER APPLY ( ");
        sql.append("     SELECT TOP 1 bd.* ");
        sql.append("     FROM Booking_Detail bd ");
        sql.append("     WHERE bd.bookingID = b.bookingID ");
        sql.append("     ORDER BY bd.bookingDetailID DESC ");
        sql.append(" ) bd ");
        sql.append(" LEFT JOIN Service s ON bd.serviceID = s.serviceID ");
        sql.append(" LEFT JOIN Accommodation a ON bd.serviceID = a.serviceID ");
        sql.append(" LEFT JOIN Vehicle v ON bd.serviceID = v.serviceID ");
        sql.append(" LEFT JOIN Tour_Scheduler ts ON bd.tourScheduleID = ts.tourScheduleID ");
        sql.append(" LEFT JOIN Tour t ON ts.tourID = t.tourID ");
        sql.append(" WHERE f.feedbackID = ? ");

        try (Connection connection = new DBConnection().getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql.toString())) {

            preparedStatement.setInt(1, feedbackID);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    Map<String, Object> detail = new HashMap<>();

                    int userID = resultSet.getInt("userID");
                    String status = resultSet.getString("status");
                    String serviceType = resultSet.getString("serviceType");
                    String firstName = resultSet.getString("firstName");
                    String lastName = resultSet.getString("lastName");

                    detail.put("feedbackID", resultSet.getInt("feedbackID"));
                    detail.put("rate", resultSet.getDouble("rate"));
                    detail.put("content", resultSet.getString("content"));
                    detail.put("createDate", resultSet.getTimestamp("createDate"));
                    detail.put("status", status);
                    detail.put("statusText", convertStatusToVietnamese(status));
                    detail.put("image", resultSet.getString("image"));

                    detail.put("userID", userID);
                    detail.put("firstName", firstName);
                    detail.put("lastName", lastName);
                    detail.put("email", resultSet.getString("email"));
                    detail.put("customerName", buildFullName(firstName, lastName));
                    detail.put("customerEmail", resultSet.getString("email"));

                    detail.put("bookingID", resultSet.getInt("bookingID"));
                    detail.put("bookingCode", resultSet.getString("bookingCode"));
                    detail.put("bookingType", resultSet.getString("bookingType"));
                    detail.put("bookingStatus", resultSet.getString("bookingStatus"));
                    detail.put("bookDate", resultSet.getTimestamp("bookDate"));
                    detail.put("totalPrice", resultSet.getDouble("totalPrice"));

                    detail.put("bookingDetailID", getNullableInt(resultSet, "bookingDetailID"));
                    detail.put("serviceID", getNullableInt(resultSet, "serviceID"));
                    detail.put("tourScheduleID", getNullableInt(resultSet, "tourScheduleID"));
                    detail.put("quantity", resultSet.getInt("quantity"));
                    detail.put("unitPrice", resultSet.getDouble("unitPrice"));
                    detail.put("subTotal", resultSet.getDouble("subTotal"));
                    detail.put("startDate", resultSet.getTimestamp("startDate"));
                    detail.put("endDate", resultSet.getTimestamp("endDate"));
                    detail.put("bookingDetailNote", resultSet.getString("bookingDetailNote"));

                    detail.put("serviceType", serviceType);
                    detail.put("serviceTypeText", convertServiceTypeToVietnamese(serviceType));
                    detail.put("serviceName", resultSet.getString("serviceName"));
                    detail.put("serviceImage", resultSet.getString("serviceImage"));

                    detail.put("owner", currentUserID != null && currentUserID == userID);

                    return detail;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public int insertFeedback(Feedback feedback) {
        String sql = "INSERT INTO Feedback "
                + "(rate, content, createDate, status, image, userID, bookingID) "
                + "VALUES (?, ?, GETDATE(), ?, ?, ?, ?)";

        try (Connection connection = new DBConnection().getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            preparedStatement.setDouble(1, feedback.getRate());
            preparedStatement.setString(2, feedback.getContent());
            preparedStatement.setString(3, normalizeStatus(feedback.getStatus()));
            preparedStatement.setString(4, normalizeEmptyToNull(feedback.getImage()));
            preparedStatement.setInt(5, feedback.getUserID());
            preparedStatement.setInt(6, feedback.getBookingID());

            int affectedRows = preparedStatement.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet generatedKeys = preparedStatement.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return -1;
    }

    public boolean updateFeedback(Feedback feedback) {
        String sql = "UPDATE Feedback "
                + "SET rate = ?, content = ?, status = ?, image = ? "
                + "WHERE feedbackID = ?";

        try (Connection connection = new DBConnection().getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setDouble(1, feedback.getRate());
            preparedStatement.setString(2, feedback.getContent());
            preparedStatement.setString(3, normalizeStatus(feedback.getStatus()));
            preparedStatement.setString(4, normalizeEmptyToNull(feedback.getImage()));
            preparedStatement.setInt(5, feedback.getFeedbackID());

            return preparedStatement.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean updateFeedbackByCustomer(Feedback feedback, int userID) {
        String sql = "UPDATE Feedback "
                + "SET rate = ?, content = ?, image = ?, status = 'Hidden' "
                + "WHERE feedbackID = ? AND userID = ?";

        try (Connection connection = new DBConnection().getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setDouble(1, feedback.getRate());
            preparedStatement.setString(2, feedback.getContent());
            preparedStatement.setString(3, normalizeEmptyToNull(feedback.getImage()));
            preparedStatement.setInt(4, feedback.getFeedbackID());
            preparedStatement.setInt(5, userID);

            return preparedStatement.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean updateFeedbackStatus(int feedbackID, String status) {
        String sql = "UPDATE Feedback SET status = ? WHERE feedbackID = ?";

        try (Connection connection = new DBConnection().getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setString(1, normalizeStatus(status));
            preparedStatement.setInt(2, feedbackID);

            return preparedStatement.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean deleteFeedback(int feedbackID) {
        String sql = "DELETE FROM Feedback WHERE feedbackID = ?";

        try (Connection connection = new DBConnection().getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, feedbackID);
            return preparedStatement.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean isBookingExist(int bookingID) {
        String sql = "SELECT bookingID FROM Booking WHERE bookingID = ?";

        try (Connection connection = new DBConnection().getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, bookingID);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                return resultSet.next();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean isUserExist(int userID) {
        String sql = "SELECT userID FROM [User] WHERE userID = ?";

        try (Connection connection = new DBConnection().getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, userID);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                return resultSet.next();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean isFeedbackOwner(int feedbackID, int userID) {
        String sql = "SELECT feedbackID FROM Feedback WHERE feedbackID = ? AND userID = ?";

        try (Connection connection = new DBConnection().getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, feedbackID);
            preparedStatement.setInt(2, userID);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                return resultSet.next();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public int findUserBookingIDForService(int userID, String type, int serviceID) {
        String serviceType = normalizeServiceType(type);

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT TOP 1 b.bookingID ");
        sql.append("FROM Booking b ");
        sql.append("JOIN Booking_Detail bd ON b.bookingID = bd.bookingID ");
        sql.append("LEFT JOIN Accommodation a ON bd.serviceID = a.serviceID ");
        sql.append("LEFT JOIN Vehicle v ON bd.serviceID = v.serviceID ");
        sql.append("LEFT JOIN Tour_Scheduler ts ON bd.tourScheduleID = ts.tourScheduleID ");
        sql.append("LEFT JOIN Tour t ON ts.tourID = t.tourID ");
        sql.append("WHERE b.userID = ? AND bd.serviceID = ? ");

        if (!"All".equals(serviceType)) {
            sql.append(" AND ");
            sql.append(getServiceTypeCondition(serviceType));
        }

        sql.append(" ORDER BY b.bookDate DESC, b.bookingID DESC ");

        try (Connection connection = new DBConnection().getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql.toString())) {

            preparedStatement.setInt(1, userID);
            preparedStatement.setInt(2, serviceID);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getInt("bookingID");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return -1;
    }

    public boolean hasUserFeedbackForService(int userID, String type, int serviceID) {
        String serviceType = normalizeServiceType(type);

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT TOP 1 f.feedbackID ");
        sql.append("FROM Feedback f ");
        sql.append("JOIN Booking b ON f.bookingID = b.bookingID ");
        sql.append("JOIN Booking_Detail bd ON b.bookingID = bd.bookingID ");
        sql.append("LEFT JOIN Accommodation a ON bd.serviceID = a.serviceID ");
        sql.append("LEFT JOIN Vehicle v ON bd.serviceID = v.serviceID ");
        sql.append("LEFT JOIN Tour_Scheduler ts ON bd.tourScheduleID = ts.tourScheduleID ");
        sql.append("LEFT JOIN Tour t ON ts.tourID = t.tourID ");
        sql.append("WHERE f.userID = ? AND bd.serviceID = ? ");

        if (!"All".equals(serviceType)) {
            sql.append(" AND ");
            sql.append(getServiceTypeCondition(serviceType));
        }

        try (Connection connection = new DBConnection().getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql.toString())) {

            preparedStatement.setInt(1, userID);
            preparedStatement.setInt(2, serviceID);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                return resultSet.next();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public Feedback getUserFeedbackForService(int userID, String type, int serviceID) {
        String serviceType = normalizeServiceType(type);

        StringBuilder sql = new StringBuilder();
        sql.append(getFeedbackSummarySelect());
        sql.append(" FROM Feedback f ");
        sql.append(" JOIN [User] u ON f.userID = u.userID ");
        sql.append(" JOIN Booking b ON f.bookingID = b.bookingID ");
        sql.append(" JOIN Booking_Detail bd ON b.bookingID = bd.bookingID ");
        sql.append(" LEFT JOIN Service s ON bd.serviceID = s.serviceID ");
        sql.append(" LEFT JOIN Accommodation a ON bd.serviceID = a.serviceID ");
        sql.append(" LEFT JOIN Vehicle v ON bd.serviceID = v.serviceID ");
        sql.append(" LEFT JOIN Tour_Scheduler ts ON bd.tourScheduleID = ts.tourScheduleID ");
        sql.append(" LEFT JOIN Tour t ON ts.tourID = t.tourID ");
        sql.append(" WHERE f.userID = ? AND bd.serviceID = ? ");

        if (!"All".equals(serviceType)) {
            sql.append(" AND ");
            sql.append(getServiceTypeCondition(serviceType));
        }

        sql.append(" ORDER BY f.createDate DESC, f.feedbackID DESC ");

        try (Connection connection = new DBConnection().getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql.toString())) {

            preparedStatement.setInt(1, userID);
            preparedStatement.setInt(2, serviceID);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    return mapFeedbackSummary(resultSet, userID);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public Map<String, Object> getServiceInfo(String type, int serviceID) {
        String serviceType = normalizeServiceType(type);
        String sql;

        if ("Accommodation".equals(serviceType)) {
            sql = "SELECT serviceID, name AS serviceName, image AS serviceImage, "
                    + "province, district, ward, address, rate, type AS detailType, "
                    + "'Accommodation' AS serviceType "
                    + "FROM Accommodation "
                    + "WHERE serviceID = ?";
        } else if ("Vehicle".equals(serviceType)) {
            sql = "SELECT serviceID, vehicleModel AS serviceName, image AS serviceImage, "
                    + "pickup_province AS province, pickup_district AS district, pickup_ward AS ward, "
                    + "pickup_address AS address, NULL AS rate, vehicle_type AS detailType, "
                    + "'Vehicle' AS serviceType "
                    + "FROM Vehicle "
                    + "WHERE serviceID = ?";
        } else {
            sql = "SELECT tourID AS serviceID, tourName AS serviceName, image AS serviceImage, "
                    + "startPlace AS province, endPlace AS district, NULL AS ward, "
                    + "endPlace AS address, rate, N'Tour' AS detailType, "
                    + "'Tour' AS serviceType "
                    + "FROM Tour "
                    + "WHERE tourID = ?";
        }

        try (Connection connection = new DBConnection().getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, serviceID);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    Map<String, Object> serviceInfo = new HashMap<>();

                    String realServiceType = resultSet.getString("serviceType");

                    serviceInfo.put("serviceID", resultSet.getInt("serviceID"));
                    serviceInfo.put("serviceName", resultSet.getString("serviceName"));
                    serviceInfo.put("serviceImage", resultSet.getString("serviceImage"));
                    serviceInfo.put("province", resultSet.getString("province"));
                    serviceInfo.put("district", resultSet.getString("district"));
                    serviceInfo.put("ward", resultSet.getString("ward"));
                    serviceInfo.put("address", resultSet.getString("address"));
                    serviceInfo.put("rate", resultSet.getObject("rate"));
                    serviceInfo.put("detailType", resultSet.getString("detailType"));
                    serviceInfo.put("serviceType", realServiceType);
                    serviceInfo.put("serviceTypeText", convertServiceTypeToVietnamese(realServiceType));

                    return serviceInfo;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean isServiceExist(String type, int serviceID) {
        return getServiceInfo(type, serviceID) != null;
    }

    private Feedback mapBasicFeedback(ResultSet resultSet) throws Exception {
        Feedback feedback = new Feedback();

        feedback.setFeedbackID(resultSet.getInt("feedbackID"));
        feedback.setRate(resultSet.getDouble("rate"));
        feedback.setContent(resultSet.getString("content"));

        Timestamp createDate = resultSet.getTimestamp("createDate");
        if (createDate != null) {
            feedback.setCreateDate(createDate);
        }

        feedback.setStatus(resultSet.getString("status"));
        feedback.setImage(resultSet.getString("image"));
        feedback.setUserID(resultSet.getInt("userID"));
        feedback.setBookingID(resultSet.getInt("bookingID"));

        return feedback;
    }

    private Feedback mapFeedbackSummary(ResultSet resultSet, Integer currentUserID) throws Exception {
        Feedback feedback = mapBasicFeedback(resultSet);

        String firstName = resultSet.getString("firstName");
        String lastName = resultSet.getString("lastName");
        String serviceType = resultSet.getString("serviceType");
        int userID = resultSet.getInt("userID");

        feedback.setCustomerName(buildFullName(firstName, lastName));
        feedback.setCustomerEmail(resultSet.getString("email"));
        feedback.setBookingCode(resultSet.getString("bookingCode"));
        feedback.setBookingType(resultSet.getString("bookingType"));
        feedback.setServiceID(getNullableInt(resultSet, "serviceID"));
        feedback.setServiceType(serviceType);
        feedback.setServiceName(resultSet.getString("serviceName"));
        feedback.setServiceImage(resultSet.getString("serviceImage"));
        feedback.setStatusText(convertStatusToVietnamese(feedback.getStatus()));
        feedback.setOwner(currentUserID != null && currentUserID == userID);

        return feedback;
    }

    private String getFeedbackSummarySelect() {
        StringBuilder sql = new StringBuilder();

        sql.append("SELECT ");
        sql.append(" f.feedbackID, f.rate, f.content, f.createDate, f.status, f.image, ");
        sql.append(" f.userID, f.bookingID, ");
        sql.append(" u.firstName, u.lastName, u.email, ");
        sql.append(" b.bookingCode, b.bookingType, ");
        sql.append(" bd.serviceID, ");
        sql.append(" COALESCE(a.name, v.vehicleModel, t.tourName, s.serviceName, N'Dịch vụ') AS serviceName, ");
        sql.append(" COALESCE(a.image, v.image, t.image, NULL) AS serviceImage, ");
        sql.append(getServiceTypeCase());
        sql.append(" AS serviceType ");

        return sql.toString();
    }

    private String getServiceTypeCase() {
        return " CASE "
                + " WHEN a.serviceID IS NOT NULL THEN 'Accommodation' "
                + " WHEN v.serviceID IS NOT NULL THEN 'Vehicle' "
                + " WHEN t.tourID IS NOT NULL THEN 'Tour' "
                + " WHEN LOWER(b.bookingType) LIKE '%accommodation%' THEN 'Accommodation' "
                + " WHEN b.bookingType LIKE N'%lưu trú%' THEN 'Accommodation' "
                + " WHEN b.bookingType LIKE N'%khách sạn%' THEN 'Accommodation' "
                + " WHEN LOWER(b.bookingType) LIKE '%vehicle%' THEN 'Vehicle' "
                + " WHEN b.bookingType LIKE N'%xe%' THEN 'Vehicle' "
                + " WHEN LOWER(b.bookingType) LIKE '%tour%' THEN 'Tour' "
                + " ELSE b.bookingType "
                + " END ";
    }

    private String getServiceTypeCondition(String serviceType) {
        if ("Accommodation".equals(serviceType)) {
            return " (a.serviceID IS NOT NULL "
                    + " OR LOWER(b.bookingType) LIKE '%accommodation%' "
                    + " OR b.bookingType LIKE N'%lưu trú%' "
                    + " OR b.bookingType LIKE N'%khách sạn%') ";
        }

        if ("Vehicle".equals(serviceType)) {
            return " (v.serviceID IS NOT NULL "
                    + " OR LOWER(b.bookingType) LIKE '%vehicle%' "
                    + " OR b.bookingType LIKE N'%xe%') ";
        }

        if ("Tour".equals(serviceType)) {
            return " (t.tourID IS NOT NULL "
                    + " OR bd.tourScheduleID IS NOT NULL "
                    + " OR LOWER(b.bookingType) LIKE '%tour%') ";
        }

        return " 1 = 1 ";
    }

    private String normalizeServiceType(String type) {
        if (type == null || type.trim().isEmpty()) {
            return "All";
        }

        String value = type.trim().toLowerCase();

        if ("all".equals(value) || "tatca".equals(value) || "tất cả".equals(value)) {
            return "All";
        }

        if ("accommodation".equals(value)
                || "hotel".equals(value)
                || "khachsan".equals(value)
                || "khách sạn".equals(value)
                || "luutru".equals(value)
                || "lưu trú".equals(value)) {
            return "Accommodation";
        }

        if ("vehicle".equals(value)
                || "car".equals(value)
                || "xe".equals(value)
                || "thuexe".equals(value)
                || "thuê xe".equals(value)) {
            return "Vehicle";
        }

        if ("tour".equals(value)) {
            return "Tour";
        }

        return type.trim();
    }

    private String normalizeStatus(String status) {
        if (status == null || status.trim().isEmpty()) {
            return "Hidden";
        }

        if ("Visible".equalsIgnoreCase(status.trim())) {
            return "Visible";
        }

        return "Hidden";
    }

    private String normalizeEmptyToNull(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }

        return value.trim();
    }

    private Integer getNullableInt(ResultSet resultSet, String columnName) throws Exception {
        int value = resultSet.getInt(columnName);

        if (resultSet.wasNull()) {
            return null;
        }

        return value;
    }

    private String buildFullName(String firstName, String lastName) {
        String safeFirstName = firstName == null ? "" : firstName.trim();
        String safeLastName = lastName == null ? "" : lastName.trim();

        String fullName = (safeFirstName + " " + safeLastName).trim();

        if (fullName.isEmpty()) {
            return "Khách hàng";
        }

        return fullName;
    }

    private String convertStatusToVietnamese(String status) {
        if ("Visible".equalsIgnoreCase(status)) {
            return "Hiển thị";
        }

        if ("Hidden".equalsIgnoreCase(status)) {
            return "Đang ẩn";
        }

        return status;
    }

    private String convertServiceTypeToVietnamese(String serviceType) {
        if ("Accommodation".equalsIgnoreCase(serviceType)) {
            return "Khách sạn";
        }

        if ("Vehicle".equalsIgnoreCase(serviceType)) {
            return "Xe";
        }

        if ("Tour".equalsIgnoreCase(serviceType)) {
            return "Tour";
        }

        return "Dịch vụ";
    }
}