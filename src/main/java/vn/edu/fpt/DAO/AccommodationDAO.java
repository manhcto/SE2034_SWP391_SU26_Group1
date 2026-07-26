package vn.edu.fpt.DAO;

import vn.edu.fpt.common.DBConnection;
import vn.edu.fpt.model.Accommodation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AccommodationDAO {

    private static final Logger LOGGER = Logger.getLogger(AccommodationDAO.class.getName());
    private static final String BASE_SELECT =
            "SELECT a.accommodationID, a.[name], a.[image], a.[address], a.phone, a.[description], " +
                    "a.rate, a.[type], a.[status], a.checkInTime, a.checkOutTime, " +
                    "a.province, a.district, a.ward, a.createdByUserID, a.createdAt, a.updatedAt, " +
                    "COALESCE(fr.averageRate, CAST(0 AS decimal(3,2))) AS averageRate, " +
                    "COALESCE(fr.reviewCount, 0) AS reviewCount " +
                    "FROM [dbo].[Accommodation] a " +
                    "LEFT JOIN (" +
                    "    SELECT rated.accommodationID, " +
                    "           CAST(AVG(CAST(rated.rate AS decimal(10,2))) AS decimal(3,2)) AS averageRate, " +
                    "           COUNT(*) AS reviewCount " +
                    "    FROM (" +
                    "        SELECT DISTINCT f.feedbackID, bd.accommodationID, f.rate " +
                    "        FROM [dbo].[Feedback] f " +
                    "        INNER JOIN [dbo].[Booking_Detail] bd ON bd.bookingID = f.bookingID " +
                    "        WHERE f.[status] = N'Visible' AND bd.accommodationID IS NOT NULL" +
                    "    ) rated " +
                    "    GROUP BY rated.accommodationID" +
                    ") fr ON fr.accommodationID = a.accommodationID ";
    private static final String INSERT_SQL =
            "INSERT INTO [dbo].[Accommodation] " +
                    "([name], [image], [address], phone, [description], [type], [status], " +
                    "checkInTime, checkOutTime, province, district, ward, createdByUserID) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    public List<Accommodation> getAllAccommodations() {
        return findMany(BASE_SELECT + "ORDER BY a.accommodationID DESC");
    }

    public List<Accommodation> getAvailableAccommodationsForCustomer() {
        String sql = BASE_SELECT +
                "WHERE a.[status] IN (N'Available', N'Active') " +
                "ORDER BY averageRate DESC, a.accommodationID DESC";
        return findMany(sql);
    }

    public Accommodation getAccommodationById(int accommodationID) {
        return findById(accommodationID, false);
    }

    public Accommodation getAccommodationByIdForCustomer(int accommodationID) {
        return findById(accommodationID, true);
    }

    public boolean addAccommodation(Accommodation accommodation) {
        return addAccommodationAndReturnId(accommodation) > 0;
    }

    public int addAccommodationAndReturnId(Accommodation accommodation) {
        try (Connection connection = new DBConnection().getConnection();
            PreparedStatement statement = connection.prepareStatement(
                     INSERT_SQL, Statement.RETURN_GENERATED_KEYS)) {
            bindAccommodationFields(statement, accommodation);
            setNullableInteger(statement, 13, accommodation.getCreatedByUserID());

            if (statement.executeUpdate() == 0) {
                return 0;
            }

            try (ResultSet keys = statement.getGeneratedKeys()) {
                return keys.next() ? keys.getInt(1) : 0;
            }
        } catch (SQLException e) {
            logFailure("add accommodation", e);
            return 0;
        }
    }

    public int addAccommodationWithFacilities(
            Accommodation accommodation, int[] facilityIDs) {
        try (Connection connection = new DBConnection().getConnection()) {
            connection.setAutoCommit(false);
            try {
                int accommodationID = insertAccommodation(connection, accommodation);
                if (accommodationID == 0) {
                    connection.rollback();
                    return 0;
                }

                new FacilityDAO().replaceAccommodationFacilities(
                        connection, accommodationID, facilityIDs);
                connection.commit();
                return accommodationID;
            } catch (SQLException e) {
                rollback(connection, e);
                logFailure("add accommodation with facilities", e);
                return 0;
            } finally {
                restoreAutoCommit(connection);
            }
        } catch (SQLException e) {
            logFailure("open accommodation insert transaction", e);
            return 0;
        }
    }

    public boolean updateAccommodation(Accommodation accommodation) {
        String sql =
                "UPDATE [dbo].[Accommodation] " +
                        "SET [name] = ?, [image] = ?, [address] = ?, phone = ?, [description] = ?, " +
                        "[type] = ?, [status] = ?, checkInTime = ?, checkOutTime = ?, " +
                        "province = ?, district = ?, ward = ?, updatedAt = GETDATE() " +
                        "WHERE accommodationID = ?";

        try (Connection connection = new DBConnection().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            bindAccommodationFields(statement, accommodation);
            statement.setInt(13, accommodation.getAccommodationID());
            return statement.executeUpdate() == 1;
        } catch (SQLException e) {
            logFailure("update accommodation", e);
            return false;
        }
    }

    public boolean updateAccommodationWithFacilities(
            Accommodation accommodation, int[] facilityIDs) {
        String sql =
                "UPDATE [dbo].[Accommodation] " +
                        "SET [name] = ?, [image] = ?, [address] = ?, phone = ?, [description] = ?, " +
                        "[type] = ?, [status] = ?, checkInTime = ?, checkOutTime = ?, " +
                        "province = ?, district = ?, ward = ?, updatedAt = GETDATE() " +
                        "WHERE accommodationID = ?";

        try (Connection connection = new DBConnection().getConnection()) {
            connection.setAutoCommit(false);
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                bindAccommodationFields(statement, accommodation);
                statement.setInt(13, accommodation.getAccommodationID());
                if (statement.executeUpdate() != 1) {
                    connection.rollback();
                    return false;
                }

                new FacilityDAO().replaceAccommodationFacilities(
                        connection, accommodation.getAccommodationID(), facilityIDs);
                connection.commit();
                return true;
            } catch (SQLException e) {
                rollback(connection, e);
                logFailure("update accommodation with facilities", e);
                return false;
            } finally {
                restoreAutoCommit(connection);
            }
        } catch (SQLException e) {
            logFailure("open accommodation update transaction", e);
            return false;
        }
    }

    public boolean deleteAccommodation(int accommodationID) {
        String deleteAccommodation =
                "DELETE FROM [dbo].[Accommodation] WHERE accommodationID = ?";

        try (Connection connection = new DBConnection().getConnection()) {
            connection.setAutoCommit(false);
            try {
                int deleted = executeDelete(connection, deleteAccommodation, accommodationID);

                if (deleted != 1) {
                    connection.rollback();
                    return false;
                }

                connection.commit();
                return true;
            } catch (SQLException e) {
                rollback(connection, e);
                logFailure("delete accommodation", e);
                return false;
            } finally {
                restoreAutoCommit(connection);
            }
        } catch (SQLException e) {
            logFailure("open connection to delete accommodation", e);
            return false;
        }
    }

    public boolean hasBookingReferences(int accommodationID) {
        String sql =
                "SELECT TOP 1 1 FROM [dbo].[Booking_Detail] bd " +
                        "WHERE bd.accommodationID = ? OR bd.roomID IN (" +
                        "SELECT r.roomID FROM [dbo].[Room] r WHERE r.accommodationID = ?)";
        return exists(sql, accommodationID);
    }

    public boolean deactivateAccommodation(int accommodationID) {
        String sql =
                "UPDATE [dbo].[Accommodation] SET [status] = N'Unavailable', " +
                        "updatedAt = GETDATE() WHERE accommodationID = ?";
        try (Connection connection = new DBConnection().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, accommodationID);
            return statement.executeUpdate() == 1;
        } catch (SQLException e) {
            logFailure("deactivate accommodation", e);
            return false;
        }
    }

    private List<Accommodation> findMany(String sql) {
        List<Accommodation> accommodations = new ArrayList<>();

        try (Connection connection = new DBConnection().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                accommodations.add(mapAccommodation(resultSet));
            }
        } catch (SQLException e) {
            logFailure("load accommodations", e);
        }

        return accommodations;
    }

    private Accommodation findById(int accommodationID, boolean customerOnly) {
        String sql = BASE_SELECT +
                "WHERE a.accommodationID = ?" +
                (customerOnly ? " AND a.[status] IN (N'Available', N'Active')" : "");

        try (Connection connection = new DBConnection().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, accommodationID);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() ? mapAccommodation(resultSet) : null;
            }
        } catch (SQLException e) {
            logFailure("find accommodation by id", e);
            return null;
        }
    }

    private int insertAccommodation(Connection connection, Accommodation accommodation)
            throws SQLException {
        try (PreparedStatement statement = connection.prepareStatement(
                INSERT_SQL, Statement.RETURN_GENERATED_KEYS)) {
            bindAccommodationFields(statement, accommodation);
            setNullableInteger(statement, 13, accommodation.getCreatedByUserID());
            if (statement.executeUpdate() != 1) {
                return 0;
            }
            try (ResultSet keys = statement.getGeneratedKeys()) {
                return keys.next() ? keys.getInt(1) : 0;
            }
        }
    }

    private void bindAccommodationFields(
            PreparedStatement statement, Accommodation accommodation)
            throws SQLException {
        statement.setString(1, accommodation.getName());
        statement.setString(2, accommodation.getImage());
        statement.setString(3, accommodation.getAddress());
        statement.setString(4, accommodation.getPhone());
        statement.setString(5, accommodation.getDescription());
        statement.setString(6, accommodation.getType());
        statement.setString(7, accommodation.getStatus());
        statement.setTime(8, accommodation.getCheckInTime());
        statement.setTime(9, accommodation.getCheckOutTime());
        statement.setString(10, accommodation.getProvince());
        statement.setString(11, accommodation.getDistrict());
        statement.setString(12, accommodation.getWard());
    }

    private void setNullableInteger(PreparedStatement statement, int index, Integer value)
            throws SQLException {
        if (value == null) {
            statement.setNull(index, Types.INTEGER);
        } else {
            statement.setInt(index, value);
        }
    }

    private int executeDelete(Connection connection, String sql, int accommodationID)
            throws SQLException {
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, accommodationID);
            return statement.executeUpdate();
        }
    }

    private Accommodation mapAccommodation(ResultSet resultSet) throws SQLException {
        Accommodation accommodation = new Accommodation();
        accommodation.setAccommodationID(resultSet.getInt("accommodationID"));
        accommodation.setName(resultSet.getString("name"));
        accommodation.setImage(resultSet.getString("image"));
        accommodation.setAddress(resultSet.getString("address"));
        accommodation.setPhone(resultSet.getString("phone"));
        accommodation.setDescription(resultSet.getString("description"));
        accommodation.setRate(resultSet.getBigDecimal("rate"));
        accommodation.setAverageRate(resultSet.getBigDecimal("averageRate"));
        accommodation.setReviewCount(resultSet.getInt("reviewCount"));
        accommodation.setType(resultSet.getString("type"));
        accommodation.setStatus(resultSet.getString("status"));
        accommodation.setCheckInTime(resultSet.getTime("checkInTime"));
        accommodation.setCheckOutTime(resultSet.getTime("checkOutTime"));
        accommodation.setProvince(resultSet.getString("province"));
        accommodation.setDistrict(resultSet.getString("district"));
        accommodation.setWard(resultSet.getString("ward"));
        int createdByUserID = resultSet.getInt("createdByUserID");
        accommodation.setCreatedByUserID(resultSet.wasNull() ? null : createdByUserID);
        if (resultSet.getTimestamp("createdAt") != null) {
            accommodation.setCreatedAt(resultSet.getTimestamp("createdAt").toLocalDateTime());
        }
        if (resultSet.getTimestamp("updatedAt") != null) {
            accommodation.setUpdatedAt(resultSet.getTimestamp("updatedAt").toLocalDateTime());
        }
        return accommodation;
    }

    private boolean exists(String sql, int id) {
        try (Connection connection = new DBConnection().getConnection();
            PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, id);
            statement.setInt(2, id);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next();
            }
        } catch (SQLException e) {
            logFailure("check accommodation reference", e);
            return true;
        }
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
            logFailure("restore auto-commit", e);
        }
    }

    private void logFailure(String operation, SQLException error) {
        LOGGER.log(Level.SEVERE, "Failed to " + operation, error);
    }
}
