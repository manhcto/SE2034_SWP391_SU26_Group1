package vn.edu.fpt.DAO;

import vn.edu.fpt.common.DBConnection;
import vn.edu.fpt.model.Accommodation;
import vn.edu.fpt.model.Service;

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
                    "a.serviceID, a.[name], a.[image], a.[address], a.phone, a.[description], " +
                    "a.rate, a.[type], a.[status], a.checkInTime, a.checkOutTime, " +
                    "a.province, a.district, a.ward, " +
                    "s.serviceCategoryID, s.serviceName, s.[status] AS serviceStatus, " +
                    "s.serviceType, s.fulfillmentType " +
                    "FROM [dbo].[Accommodation] a " +
                    "JOIN [dbo].[Service] s ON a.serviceID = s.serviceID ";

    public List<Accommodation> getAllAccommodations() {
        List<Accommodation> list = new ArrayList<>();

        String sql = BASE_SELECT +
                "ORDER BY a.serviceID DESC";

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
                "WHERE s.[status] = N'Active' " +
                "AND s.serviceType = N'Accommodation' " +
                "AND a.[status] IN (N'Available', N'Active') " +
                "ORDER BY a.rate DESC, a.serviceID DESC";

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

    public Accommodation getAccommodationById(int serviceID) {
        String sql = BASE_SELECT +
                "WHERE a.serviceID = ?";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, serviceID);

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

    public Accommodation getAccommodationByIdForCustomer(int serviceID) {
        String sql = BASE_SELECT +
                "WHERE a.serviceID = ? " +
                "AND s.[status] = N'Active' " +
                "AND s.serviceType = N'Accommodation' " +
                "AND a.[status] IN (N'Available', N'Active')";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, serviceID);

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
        String sqlService =
                "INSERT INTO [dbo].[Service] " +
                        "(serviceCategoryID, serviceName, [status], serviceType, fulfillmentType, createAt, updateAt) " +
                        "VALUES (?, ?, ?, ?, ?, GETDATE(), GETDATE())";

        String sqlAccommodation =
                "INSERT INTO [dbo].[Accommodation] " +
                        "(serviceID, [name], [image], [address], phone, [description], rate, [type], [status], " +
                        "checkInTime, checkOutTime, province, district, ward) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        Connection conn = null;

        try {
            conn = new DBConnection().getConnection();
            conn.setAutoCommit(false);

            int generatedServiceID = 0;

            try (PreparedStatement psService = conn.prepareStatement(sqlService, Statement.RETURN_GENERATED_KEYS)) {
                Service service = accommodation.getServiceDetails();

                psService.setInt(1, service == null ? 1 : service.getServiceCategoryID());
                psService.setString(2, accommodation.getName());
                psService.setString(3, "Active");
                psService.setString(4, "Accommodation");
                psService.setString(5, "Booking");

                psService.executeUpdate();

                try (ResultSet keys = psService.getGeneratedKeys()) {
                    if (keys.next()) {
                        generatedServiceID = keys.getInt(1);
                    }
                }
            }

            if (generatedServiceID <= 0) {
                conn.rollback();
                return false;
            }

            try (PreparedStatement psAccommodation = conn.prepareStatement(sqlAccommodation)) {
                psAccommodation.setInt(1, generatedServiceID);
                psAccommodation.setString(2, accommodation.getName());
                psAccommodation.setString(3, accommodation.getImage());
                psAccommodation.setString(4, accommodation.getAddress());
                psAccommodation.setString(5, accommodation.getPhone());
                psAccommodation.setString(6, accommodation.getDescription());
                psAccommodation.setDouble(7, accommodation.getRate());
                psAccommodation.setString(8, accommodation.getType());
                psAccommodation.setString(9, accommodation.getStatus());
                psAccommodation.setTime(10, accommodation.getCheckInTime());
                psAccommodation.setTime(11, accommodation.getCheckOutTime());
                psAccommodation.setString(12, accommodation.getProvince());
                psAccommodation.setString(13, accommodation.getDistrict());
                psAccommodation.setString(14, accommodation.getWard());

                psAccommodation.executeUpdate();
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

    public boolean updateAccommodation(Accommodation accommodation) {
        String sqlService =
                "UPDATE [dbo].[Service] " +
                        "SET serviceName = ?, [status] = ?, serviceType = ?, fulfillmentType = ?, updateAt = GETDATE() " +
                        "WHERE serviceID = ?";

        String sqlAccommodation =
                "UPDATE [dbo].[Accommodation] " +
                        "SET [name] = ?, [image] = ?, [address] = ?, phone = ?, [description] = ?, " +
                        "rate = ?, [type] = ?, [status] = ?, checkInTime = ?, checkOutTime = ?, " +
                        "province = ?, district = ?, ward = ? " +
                        "WHERE serviceID = ?";

        Connection conn = null;

        try {
            conn = new DBConnection().getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement psService = conn.prepareStatement(sqlService)) {
                psService.setString(1, accommodation.getName());
                psService.setString(2, "Active");
                psService.setString(3, "Accommodation");
                psService.setString(4, "Booking");
                psService.setInt(5, accommodation.getServiceID());
                psService.executeUpdate();
            }

            try (PreparedStatement psAccommodation = conn.prepareStatement(sqlAccommodation)) {
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
                psAccommodation.setInt(14, accommodation.getServiceID());

                psAccommodation.executeUpdate();
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

    public boolean deleteAccommodation(int serviceID) {
        String sqlDeleteRoomFacilities =
                "DELETE rf " +
                        "FROM [dbo].[Room_Facility] rf " +
                        "JOIN [dbo].[Room] r ON rf.roomID = r.roomID " +
                        "WHERE r.serviceID = ?";

        String sqlDeleteRooms =
                "DELETE FROM [dbo].[Room] WHERE serviceID = ?";

        String sqlDeleteAccommodationFacilities =
                "DELETE FROM [dbo].[Accommodation_Facility] WHERE serviceID = ?";

        String sqlDeleteAccommodation =
                "DELETE FROM [dbo].[Accommodation] WHERE serviceID = ?";

        String sqlDeleteService =
                "DELETE FROM [dbo].[Service] WHERE serviceID = ?";

        Connection conn = null;

        try {
            conn = new DBConnection().getConnection();
            conn.setAutoCommit(false);

            executeDeleteByServiceID(conn, sqlDeleteRoomFacilities, serviceID);
            executeDeleteByServiceID(conn, sqlDeleteRooms, serviceID);
            executeDeleteByServiceID(conn, sqlDeleteAccommodationFacilities, serviceID);
            executeDeleteByServiceID(conn, sqlDeleteAccommodation, serviceID);
            executeDeleteByServiceID(conn, sqlDeleteService, serviceID);

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

    private void executeDeleteByServiceID(Connection conn, String sql, int serviceID) throws Exception {
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, serviceID);
            ps.executeUpdate();
        }
    }

    private Accommodation mapAccommodation(ResultSet rs) throws Exception {
        Accommodation accommodation = new Accommodation();

        accommodation.setServiceID(rs.getInt("serviceID"));
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

        Service service = new Service();
        service.setServiceID(rs.getInt("serviceID"));
        service.setServiceCategoryID(rs.getInt("serviceCategoryID"));
        service.setServiceName(rs.getString("serviceName"));
        service.setStatus(rs.getString("serviceStatus"));
        service.setServiceType(rs.getString("serviceType"));
        service.setFulfillmentType(rs.getString("fulfillmentType"));

        accommodation.setServiceDetails(service);

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
        String sqlService =
                "INSERT INTO [dbo].[Service] " +
                        "(serviceCategoryID, serviceName, [status], serviceType, fulfillmentType, createAt, updateAt) " +
                        "VALUES (?, ?, ?, ?, ?, GETDATE(), GETDATE())";

        String sqlAccommodation =
                "INSERT INTO [dbo].[Accommodation] " +
                        "(serviceID, [name], [image], [address], phone, [description], rate, [type], [status], " +
                        "checkInTime, checkOutTime, province, district, ward) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        Connection conn = null;

        try {
            conn = new DBConnection().getConnection();
            conn.setAutoCommit(false);

            int generatedServiceID = 0;

            try (PreparedStatement psService = conn.prepareStatement(sqlService, Statement.RETURN_GENERATED_KEYS)) {
                Service service = accommodation.getServiceDetails();

                psService.setInt(1, service == null ? 1 : service.getServiceCategoryID());
                psService.setString(2, accommodation.getName());
                psService.setString(3, "Active");
                psService.setString(4, "Accommodation");
                psService.setString(5, "Booking");

                psService.executeUpdate();

                try (ResultSet keys = psService.getGeneratedKeys()) {
                    if (keys.next()) {
                        generatedServiceID = keys.getInt(1);
                    }
                }
            }

            if (generatedServiceID <= 0) {
                conn.rollback();
                return 0;
            }

            try (PreparedStatement psAccommodation = conn.prepareStatement(sqlAccommodation)) {
                psAccommodation.setInt(1, generatedServiceID);
                psAccommodation.setString(2, accommodation.getName());
                psAccommodation.setString(3, accommodation.getImage());
                psAccommodation.setString(4, accommodation.getAddress());
                psAccommodation.setString(5, accommodation.getPhone());
                psAccommodation.setString(6, accommodation.getDescription());
                psAccommodation.setDouble(7, accommodation.getRate());
                psAccommodation.setString(8, accommodation.getType());
                psAccommodation.setString(9, accommodation.getStatus());
                psAccommodation.setTime(10, accommodation.getCheckInTime());
                psAccommodation.setTime(11, accommodation.getCheckOutTime());
                psAccommodation.setString(12, accommodation.getProvince());
                psAccommodation.setString(13, accommodation.getDistrict());
                psAccommodation.setString(14, accommodation.getWard());

                psAccommodation.executeUpdate();
            }

            conn.commit();
            return generatedServiceID;

        } catch (Exception e) {
            rollbackQuietly(conn);
            e.printStackTrace();

        } finally {
            closeQuietly(conn);
        }

        return 0;
    }
}