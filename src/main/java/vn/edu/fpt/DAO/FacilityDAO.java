package vn.edu.fpt.DAO;

import vn.edu.fpt.common.DBConnection;
import vn.edu.fpt.model.Facility;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class FacilityDAO {

    public List<Facility> getAllActiveFacilities() {
        List<Facility> list = new ArrayList<>();

        String sql =
                "SELECT facilityID, facilityName, icon, facilityScope, [status] " +
                        "FROM [dbo].[Facility] " +
                        "WHERE [status] = N'Active' " +
                        "ORDER BY facilityScope, facilityName";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapFacility(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Facility> getAccommodationFacilityOptions() {
        List<Facility> list = new ArrayList<>();

        String sql =
                "SELECT facilityID, facilityName, icon, facilityScope, [status] " +
                        "FROM [dbo].[Facility] " +
                        "WHERE [status] = N'Active' " +
                        "AND facilityScope IN (N'Accommodation', N'Both') " +
                        "ORDER BY facilityName";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapFacility(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Facility> getRoomFacilityOptions() {
        List<Facility> list = new ArrayList<>();

        String sql =
                "SELECT facilityID, facilityName, icon, facilityScope, [status] " +
                        "FROM [dbo].[Facility] " +
                        "WHERE [status] = N'Active' " +
                        "AND facilityScope IN (N'Room', N'Both') " +
                        "ORDER BY facilityName";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapFacility(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Facility> getFacilitiesByAccommodation(int accommodationID) {
        List<Facility> list = new ArrayList<>();

        String sql =
                        "SELECT f.facilityID, f.facilityName, f.icon, f.facilityScope, f.[status] " +
                        "FROM [dbo].[Facility] f " +
                        "JOIN [dbo].[Accommodation_Facility] af ON f.facilityID = af.facilityID " +
                        "WHERE af.accommodationID = ? " +
                        "AND f.[status] = N'Active' " +
                        "ORDER BY f.facilityName";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, accommodationID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapFacility(rs));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Facility> getFacilitiesByRoom(int roomID) {
        List<Facility> list = new ArrayList<>();

        String sql =
                "SELECT f.facilityID, f.facilityName, f.icon, f.facilityScope, f.[status] " +
                        "FROM [dbo].[Facility] f " +
                        "JOIN [dbo].[Room_Facility] rf ON f.facilityID = rf.facilityID " +
                        "WHERE rf.roomID = ? " +
                        "AND f.[status] = N'Active' " +
                        "ORDER BY f.facilityName";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, roomID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapFacility(rs));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean updateAccommodationFacilities(int accommodationID, int[] facilityIDs) {
        String sqlDelete =
                "DELETE FROM [dbo].[Accommodation_Facility] WHERE accommodationID = ?";

        String sqlInsert =
                "INSERT INTO [dbo].[Accommodation_Facility] (accommodationID, facilityID) " +
                        "VALUES (?, ?)";

        Connection conn = null;

        try {
            conn = new DBConnection().getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement psDelete = conn.prepareStatement(sqlDelete)) {
                psDelete.setInt(1, accommodationID);
                psDelete.executeUpdate();
            }

            if (facilityIDs != null && facilityIDs.length > 0) {
                try (PreparedStatement psInsert = conn.prepareStatement(sqlInsert)) {
                    for (int facilityID : facilityIDs) {
                        if (facilityID <= 0) {
                            continue;
                        }

                        psInsert.setInt(1, accommodationID);
                        psInsert.setInt(2, facilityID);
                        psInsert.addBatch();
                    }

                    psInsert.executeBatch();
                }
            }

            conn.commit();
            return true;

        } catch (Exception e) {
            rollbackQuietly(conn);
            e.printStackTrace();

        } finally {
            closeQuietly(conn);
        }

        return false;
    }

    public boolean updateRoomFacilities(int roomID, int[] facilityIDs) {
        String sqlDelete =
                "DELETE FROM [dbo].[Room_Facility] WHERE roomID = ?";

        String sqlInsert =
                "INSERT INTO [dbo].[Room_Facility] (roomID, facilityID) " +
                        "VALUES (?, ?)";

        Connection conn = null;

        try {
            conn = new DBConnection().getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement psDelete = conn.prepareStatement(sqlDelete)) {
                psDelete.setInt(1, roomID);
                psDelete.executeUpdate();
            }

            if (facilityIDs != null && facilityIDs.length > 0) {
                try (PreparedStatement psInsert = conn.prepareStatement(sqlInsert)) {
                    for (int facilityID : facilityIDs) {
                        if (facilityID <= 0) {
                            continue;
                        }

                        psInsert.setInt(1, roomID);
                        psInsert.setInt(2, facilityID);
                        psInsert.addBatch();
                    }

                    psInsert.executeBatch();
                }
            }

            conn.commit();
            return true;

        } catch (Exception e) {
            rollbackQuietly(conn);
            e.printStackTrace();

        } finally {
            closeQuietly(conn);
        }

        return false;
    }

    public int[] parseFacilityIDs(String[] rawValues) {
        if (rawValues == null || rawValues.length == 0) {
            return new int[0];
        }

        List<Integer> ids = new ArrayList<>();

        for (String raw : rawValues) {
            try {
                int id = Integer.parseInt(raw);

                if (id > 0) {
                    ids.add(id);
                }

            } catch (Exception ignored) {
            }
        }

        int[] result = new int[ids.size()];

        for (int i = 0; i < ids.size(); i++) {
            result[i] = ids.get(i);
        }

        return result;
    }

    private Facility mapFacility(ResultSet rs) throws Exception {
        Facility facility = new Facility();

        facility.setFacilityID(rs.getInt("facilityID"));
        facility.setFacilityName(rs.getString("facilityName"));
        facility.setIcon(rs.getString("icon"));
        facility.setFacilityScope(rs.getString("facilityScope"));
        facility.setStatus(rs.getString("status"));

        return facility;
    }

    private void rollbackQuietly(Connection conn) {
        if (conn != null) {
            try {
                conn.rollback();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    private void closeQuietly(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
