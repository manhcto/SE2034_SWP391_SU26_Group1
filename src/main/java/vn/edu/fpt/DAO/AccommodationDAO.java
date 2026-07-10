package vn.edu.fpt.DAO;

import vn.edu.fpt.common.DBConnection;
import vn.edu.fpt.model.Accommodation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;

public class AccommodationDAO {

    private static final String BASE_SELECT =
            "SELECT " +
                    "a.accommodationID, a.[name], a.[image], a.[address], a.phone, a.[description], " +
                    "a.rate, a.[type], a.[status], a.checkInTime, a.checkOutTime, " +
                    "a.province, a.district, a.ward " +
                    "FROM [dbo].[Accommodation] a ";

    public List<Accommodation> getAllAccommodations() {
        List<Accommodation> list = new ArrayList<>();

        String sql = BASE_SELECT +
                "ORDER BY a.accommodationID DESC";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapAccommodation(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Accommodation> getAvailableAccommodationsForCustomer() {
        List<Accommodation> list = new ArrayList<>();

        String sql = BASE_SELECT +
                "WHERE a.[status] IN (N'Available', N'Active') " +
                "ORDER BY a.rate DESC, a.accommodationID DESC";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapAccommodation(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public Accommodation getAccommodationById(int accommodationID) {
        String sql = BASE_SELECT +
                "WHERE a.accommodationID = ?";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, accommodationID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapAccommodation(rs);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public Accommodation getAccommodationByIdForCustomer(int accommodationID) {
        String sql = BASE_SELECT +
                "WHERE a.accommodationID = ? " +
                "AND a.[status] IN (N'Available', N'Active')";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, accommodationID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapAccommodation(rs);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean addAccommodation(Accommodation accommodation) {
        String sqlAccommodation =
                "INSERT INTO [dbo].[Accommodation] " +
                        "([name], [image], [address], phone, [description], rate, [type], [status], " +
                        "checkInTime, checkOutTime, province, district, ward) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement psAccommodation = conn.prepareStatement(sqlAccommodation)) {
            psAccommodation.setString(1, accommodation.getName());
            psAccommodation.setString(2, accommodation.getImage());
            psAccommodation.setString(3, accommodation.getAddress());
            psAccommodation.setString(4, accommodation.getPhone());
            psAccommodation.setString(5, accommodation.getDescription());
            psAccommodation.setDouble(6, accommodation.getRate());
            psAccommodation.setString(7, accommodation.getType());
            psAccommodation.setString(8, accommodation.getStatus());
            psAccommodation.setTime(9, accommodation.getCheckInTime());
            psAccommodation.setTime(10, accommodation.getCheckOutTime());
            psAccommodation.setString(11, accommodation.getProvince());
            psAccommodation.setString(12, accommodation.getDistrict());
            psAccommodation.setString(13, accommodation.getWard());

            return psAccommodation.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean updateAccommodation(Accommodation accommodation) {
        String sqlAccommodation =
                "UPDATE [dbo].[Accommodation] " +
                        "SET [name] = ?, [image] = ?, [address] = ?, phone = ?, [description] = ?, " +
                        "rate = ?, [type] = ?, [status] = ?, checkInTime = ?, checkOutTime = ?, " +
                        "province = ?, district = ?, ward = ?, updatedAt = GETDATE() " +
                        "WHERE accommodationID = ?";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement psAccommodation = conn.prepareStatement(sqlAccommodation)) {
            psAccommodation.setString(1, accommodation.getName());
            psAccommodation.setString(2, accommodation.getImage());
            psAccommodation.setString(3, accommodation.getAddress());
            psAccommodation.setString(4, accommodation.getPhone());
            psAccommodation.setString(5, accommodation.getDescription());
            psAccommodation.setDouble(6, accommodation.getRate());
            psAccommodation.setString(7, accommodation.getType());
            psAccommodation.setString(8, accommodation.getStatus());
            psAccommodation.setTime(9, accommodation.getCheckInTime());
            psAccommodation.setTime(10, accommodation.getCheckOutTime());
            psAccommodation.setString(11, accommodation.getProvince());
            psAccommodation.setString(12, accommodation.getDistrict());
            psAccommodation.setString(13, accommodation.getWard());
            psAccommodation.setInt(14, accommodation.getAccommodationID());

            return psAccommodation.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean deleteAccommodation(int accommodationID) {
        String sqlDeleteRoomFacilities =
                        "DELETE rf " +
                        "FROM [dbo].[Room_Facility] rf " +
                        "JOIN [dbo].[Room] r ON rf.roomID = r.roomID " +
                        "WHERE r.accommodationID = ?";

        String sqlDeleteRooms =
                "DELETE FROM [dbo].[Room] WHERE accommodationID = ?";

        String sqlDeleteAccommodationFacilities =
                "DELETE FROM [dbo].[Accommodation_Facility] WHERE accommodationID = ?";

        String sqlDeleteAccommodation =
                "DELETE FROM [dbo].[Accommodation] WHERE accommodationID = ?";

        Connection conn = null;

        try {
            conn = new DBConnection().getConnection();
            conn.setAutoCommit(false);

            executeDeleteByAccommodationID(conn, sqlDeleteRoomFacilities, accommodationID);
            executeDeleteByAccommodationID(conn, sqlDeleteRooms, accommodationID);
            executeDeleteByAccommodationID(conn, sqlDeleteAccommodationFacilities, accommodationID);
            executeDeleteByAccommodationID(conn, sqlDeleteAccommodation, accommodationID);

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

    private void executeDeleteByAccommodationID(Connection conn, String sql, int accommodationID) throws Exception {
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, accommodationID);
            ps.executeUpdate();
        }
    }

    private Accommodation mapAccommodation(ResultSet rs) throws Exception {
        Accommodation accommodation = new Accommodation();

        accommodation.setAccommodationID(rs.getInt("accommodationID"));
        accommodation.setName(rs.getString("name"));
        accommodation.setImage(rs.getString("image"));
        accommodation.setAddress(rs.getString("address"));
        accommodation.setPhone(rs.getString("phone"));
        accommodation.setDescription(rs.getString("description"));
        accommodation.setRate(rs.getDouble("rate"));
        accommodation.setType(rs.getString("type"));
        accommodation.setStatus(rs.getString("status"));
        accommodation.setCheckInTime(rs.getTime("checkInTime"));
        accommodation.setCheckOutTime(rs.getTime("checkOutTime"));
        accommodation.setProvince(rs.getString("province"));
        accommodation.setDistrict(rs.getString("district"));
        accommodation.setWard(rs.getString("ward"));

        return accommodation;
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

    public int addAccommodationAndReturnId(Accommodation accommodation) {
        String sqlAccommodation =
                "INSERT INTO [dbo].[Accommodation] " +
                        "([name], [image], [address], phone, [description], rate, [type], [status], " +
                        "checkInTime, checkOutTime, province, district, ward) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement psAccommodation = conn.prepareStatement(sqlAccommodation, Statement.RETURN_GENERATED_KEYS)) {
            psAccommodation.setString(1, accommodation.getName());
            psAccommodation.setString(2, accommodation.getImage());
            psAccommodation.setString(3, accommodation.getAddress());
            psAccommodation.setString(4, accommodation.getPhone());
            psAccommodation.setString(5, accommodation.getDescription());
            psAccommodation.setDouble(6, accommodation.getRate());
            psAccommodation.setString(7, accommodation.getType());
            psAccommodation.setString(8, accommodation.getStatus());
            psAccommodation.setTime(9, accommodation.getCheckInTime());
            psAccommodation.setTime(10, accommodation.getCheckOutTime());
            psAccommodation.setString(11, accommodation.getProvince());
            psAccommodation.setString(12, accommodation.getDistrict());
            psAccommodation.setString(13, accommodation.getWard());

            if (psAccommodation.executeUpdate() == 0) {
                return 0;
            }

            try (ResultSet keys = psAccommodation.getGeneratedKeys()) {
                return keys.next() ? keys.getInt(1) : 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }
}
