package vn.edu.fpt.DAO;

import vn.edu.fpt.common.DBConnection;
import vn.edu.fpt.model.Facility;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

public class FacilityDAO {

    private static final Logger LOGGER = Logger.getLogger(FacilityDAO.class.getName());
    private static final String SELECT_COLUMNS =
            "SELECT facilityID, facilityName, icon, facilityScope, [status] " +
                    "FROM [dbo].[Facility] ";

    public List<Facility> getAllActiveFacilities() {
        return findMany(
                SELECT_COLUMNS +
                        "WHERE [status] = N'Active' ORDER BY facilityScope, facilityName",
                null);
    }

    public List<Facility> getAccommodationFacilityOptions() {
        return findMany(
                SELECT_COLUMNS +
                        "WHERE [status] = N'Active' " +
                        "AND facilityScope IN (N'Accommodation', N'Both') ORDER BY facilityName",
                null);
    }

    public List<Facility> getRoomFacilityOptions() {
        return findMany(
                SELECT_COLUMNS +
                        "WHERE [status] = N'Active' " +
                        "AND facilityScope IN (N'Room', N'Both') ORDER BY facilityName",
                null);
    }

    public List<Facility> getAccommodationFacilityEditOptions() {
        return findMany(
                "SELECT f.facilityID, f.facilityName, f.icon, f.facilityScope, f.[status] " +
                        "FROM [dbo].[Facility] f " +
                        "WHERE f.facilityScope IN (N'Accommodation', N'Both') " +
                        "AND (f.[status] = N'Active' OR EXISTS (" +
                        "SELECT 1 FROM [dbo].[Accommodation_Facility] af " +
                        "WHERE af.facilityID = f.facilityID)) ORDER BY f.facilityName",
                null);
    }

    public List<Facility> getRoomFacilityEditOptions() {
        return findMany(
                "SELECT f.facilityID, f.facilityName, f.icon, f.facilityScope, f.[status] " +
                        "FROM [dbo].[Facility] f " +
                        "WHERE f.facilityScope IN (N'Room', N'Both') " +
                        "AND (f.[status] = N'Active' OR EXISTS (" +
                        "SELECT 1 FROM [dbo].[Room_Facility] rf " +
                        "WHERE rf.facilityID = f.facilityID)) ORDER BY f.facilityName",
                null);
    }

    public List<Facility> getFacilitiesByAccommodation(int accommodationID) {
        String sql =
                "SELECT f.facilityID, f.facilityName, f.icon, f.facilityScope, f.[status] " +
                        "FROM [dbo].[Facility] f " +
                        "INNER JOIN [dbo].[Accommodation_Facility] af " +
                        "ON f.facilityID = af.facilityID " +
                        "WHERE af.accommodationID = ? AND f.[status] = N'Active' " +
                        "AND f.facilityScope IN (N'Accommodation', N'Both') " +
                        "ORDER BY f.facilityName";
        return findMany(sql, accommodationID);
    }

    public List<Facility> getFacilitiesByRoom(int roomID) {
        String sql =
                "SELECT f.facilityID, f.facilityName, f.icon, f.facilityScope, f.[status] " +
                        "FROM [dbo].[Facility] f " +
                        "INNER JOIN [dbo].[Room_Facility] rf ON f.facilityID = rf.facilityID " +
                        "WHERE rf.roomID = ? AND f.[status] = N'Active' " +
                        "AND f.facilityScope IN (N'Room', N'Both') " +
                        "ORDER BY f.facilityName";
        return findMany(sql, roomID);
    }

    public Map<Integer, List<Facility>> getAccommodationFacilitiesGrouped() {
        return getAccommodationFacilitiesGrouped(true);
    }

    public Map<Integer, List<Facility>> getAccommodationFacilitiesGroupedForEdit() {
        return getAccommodationFacilitiesGrouped(false);
    }

    private Map<Integer, List<Facility>> getAccommodationFacilitiesGrouped(boolean activeOnly) {
        String sql =
                "SELECT af.accommodationID AS ownerID, f.facilityID, f.facilityName, " +
                        "f.icon, f.facilityScope, f.[status] " +
                        "FROM [dbo].[Accommodation_Facility] af " +
                        "INNER JOIN [dbo].[Facility] f ON f.facilityID = af.facilityID " +
                        "WHERE " + (activeOnly ? "f.[status] = N'Active' AND " : "") +
                        "f.facilityScope IN (N'Accommodation', N'Both') " +
                        "ORDER BY af.accommodationID, f.facilityName";
        return findGrouped(sql);
    }

    public Map<Integer, List<Facility>> getRoomFacilitiesGrouped() {
        return getRoomFacilitiesGrouped(true);
    }

    public Map<Integer, List<Facility>> getRoomFacilitiesGroupedForEdit() {
        return getRoomFacilitiesGrouped(false);
    }

    private Map<Integer, List<Facility>> getRoomFacilitiesGrouped(boolean activeOnly) {
        String sql =
                "SELECT rf.roomID AS ownerID, f.facilityID, f.facilityName, " +
                        "f.icon, f.facilityScope, f.[status] " +
                        "FROM [dbo].[Room_Facility] rf " +
                        "INNER JOIN [dbo].[Facility] f ON f.facilityID = rf.facilityID " +
                        "WHERE " + (activeOnly ? "f.[status] = N'Active' AND " : "") +
                        "f.facilityScope IN (N'Room', N'Both') " +
                        "ORDER BY rf.roomID, f.facilityName";
        return findGrouped(sql);
    }

    public boolean updateAccommodationFacilities(int accommodationID, int[] facilityIDs) {
        return replaceFacilities(
                "Accommodation_Facility",
                "accommodationID",
                accommodationID,
                facilityIDs,
                "Accommodation");
    }

    public boolean updateRoomFacilities(int roomID, int[] facilityIDs) {
        return replaceFacilities(
                "Room_Facility",
                "roomID",
                roomID,
                facilityIDs,
                "Room");
    }

    void replaceAccommodationFacilities(
            Connection connection, int accommodationID, int[] facilityIDs) throws SQLException {
        replaceFacilities(
                connection,
                "Accommodation_Facility",
                "accommodationID",
                accommodationID,
                facilityIDs,
                "Accommodation");
    }

    void replaceRoomFacilities(Connection connection, int roomID, int[] facilityIDs)
            throws SQLException {
        replaceFacilities(
                connection,
                "Room_Facility",
                "roomID",
                roomID,
                facilityIDs,
                "Room");
    }

    public int[] parseFacilityIDs(String[] rawValues) {
        if (rawValues == null || rawValues.length == 0) {
            return new int[0];
        }

        List<Integer> ids = new ArrayList<>();
        for (String raw : rawValues) {
            try {
                int id = Integer.parseInt(raw);
                if (id > 0 && !ids.contains(id)) {
                    ids.add(id);
                }
            } catch (NumberFormatException ignored) {
                // Invalid checkbox values are excluded and validated by the DAO update.
            }
        }

        return ids.stream().mapToInt(Integer::intValue).toArray();
    }

    private List<Facility> findMany(String sql, Integer ownerID) {
        List<Facility> facilities = new ArrayList<>();

        try (Connection connection = new DBConnection().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            if (ownerID != null) {
                statement.setInt(1, ownerID);
            }
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    facilities.add(mapFacility(resultSet));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Failed to load facilities", e);
        }

        return facilities;
    }

    private Map<Integer, List<Facility>> findGrouped(String sql) {
        Map<Integer, List<Facility>> grouped = new LinkedHashMap<>();

        try (Connection connection = new DBConnection().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                grouped.computeIfAbsent(resultSet.getInt("ownerID"), ignored -> new ArrayList<>())
                        .add(mapFacility(resultSet));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Failed to load grouped facilities", e);
        }

        return grouped;
    }

    private boolean replaceFacilities(
            String linkTable,
            String ownerColumn,
            int ownerID,
            int[] facilityIDs,
            String requiredScope) {
        try (Connection connection = new DBConnection().getConnection()) {
            connection.setAutoCommit(false);
            try {
                replaceFacilities(
                        connection, linkTable, ownerColumn, ownerID, facilityIDs, requiredScope);

                connection.commit();
                return true;
            } catch (SQLException e) {
                rollback(connection, e);
                LOGGER.log(Level.SEVERE, "Failed to update facilities", e);
                return false;
            } finally {
                restoreAutoCommit(connection);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Failed to open facility transaction", e);
            return false;
        }
    }

    private void replaceFacilities(
            Connection connection,
            String linkTable,
            String ownerColumn,
            int ownerID,
            int[] facilityIDs,
            String requiredScope) throws SQLException {
        if (!areValidFacilityIDs(
                connection, facilityIDs, requiredScope, linkTable, ownerColumn, ownerID)) {
            throw new SQLException("Facility is inactive or has an invalid scope");
        }

        String deleteSql = "DELETE FROM [dbo].[" + linkTable + "] WHERE " + ownerColumn + " = ?";
        String insertSql =
                "INSERT INTO [dbo].[" + linkTable + "] (" + ownerColumn + ", facilityID) " +
                        "VALUES (?, ?)";

        try (PreparedStatement deleteStatement = connection.prepareStatement(deleteSql)) {
            deleteStatement.setInt(1, ownerID);
            deleteStatement.executeUpdate();
        }

        if (facilityIDs == null || facilityIDs.length == 0) {
            return;
        }

        try (PreparedStatement insertStatement = connection.prepareStatement(insertSql)) {
            for (int facilityID : facilityIDs) {
                insertStatement.setInt(1, ownerID);
                insertStatement.setInt(2, facilityID);
                insertStatement.addBatch();
            }
            insertStatement.executeBatch();
        }
    }

    private boolean areValidFacilityIDs(
            Connection connection,
            int[] facilityIDs,
            String requiredScope,
            String linkTable,
            String ownerColumn,
            int ownerID) throws SQLException {
        if (facilityIDs == null || facilityIDs.length == 0) {
            return true;
        }

        String sql =
                "SELECT 1 FROM [dbo].[Facility] f WHERE f.facilityID = ? " +
                        "AND f.facilityScope IN (?, N'Both') AND (" +
                        "f.[status] = N'Active' OR EXISTS (SELECT 1 FROM [dbo].[" + linkTable + "] link " +
                        "WHERE link.facilityID = f.facilityID AND link." + ownerColumn + " = ?))";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            for (int facilityID : facilityIDs) {
                statement.setInt(1, facilityID);
                statement.setString(2, requiredScope);
                statement.setInt(3, ownerID);
                try (ResultSet resultSet = statement.executeQuery()) {
                    if (!resultSet.next()) {
                        return false;
                    }
                }
            }
        }
        return true;
    }

    private Facility mapFacility(ResultSet resultSet) throws SQLException {
        Facility facility = new Facility();
        facility.setFacilityID(resultSet.getInt("facilityID"));
        facility.setFacilityName(resultSet.getString("facilityName"));
        facility.setIcon(resultSet.getString("icon"));
        facility.setFacilityScope(resultSet.getString("facilityScope"));
        facility.setStatus(resultSet.getString("status"));
        return facility;
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
            LOGGER.log(Level.SEVERE, "Failed to restore auto-commit", e);
        }
    }
}
