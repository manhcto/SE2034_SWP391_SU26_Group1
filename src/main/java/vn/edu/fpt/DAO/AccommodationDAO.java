package vn.edu.fpt.DAO;

import vn.edu.fpt.common.DBConnection;
import vn.edu.fpt.model.Accommodation;
import vn.edu.fpt.model.Service;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AccommodationDAO {

    public List<Accommodation> getAllAccommodations() {
        List<Accommodation> list = new ArrayList<>();

        String sql = "SELECT a.*, " +
                "s.serviceCategoryID, s.serviceName, s.[status] AS serviceStatus, " +
                "s.serviceType, s.fulfillmentType, s.createAt, s.updateAt " +
                "FROM [dbo].[Accommodation] a " +
                "JOIN [dbo].[Service] s ON a.serviceID = s.serviceID";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Accommodation a = mapAccommodation(rs);
                list.add(a);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public Accommodation getAccommodationById(int serviceID) {
        String sql = "SELECT a.*, " +
                "s.serviceCategoryID, s.serviceName, s.[status] AS serviceStatus, " +
                "s.serviceType, s.fulfillmentType, s.createAt, s.updateAt " +
                "FROM [dbo].[Accommodation] a " +
                "JOIN [dbo].[Service] s ON a.serviceID = s.serviceID " +
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

    public boolean addAccommodation(Accommodation a) {
        String sqlService = "INSERT INTO [dbo].[Service] " +
                "(serviceCategoryID, serviceName, [status], serviceType, fulfillmentType, createAt) " +
                "VALUES (?, ?, ?, ?, ?, GETDATE())";

        String sqlAccommodation = "INSERT INTO [dbo].[Accommodation] " +
                "(serviceID, [name], [image], [address], [phone], [description], " +
                "rate, [type], [status], checkInTime, checkOutTime) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        Connection conn = null;

        try {
            conn = new DBConnection().getConnection();
            conn.setAutoCommit(false);

            int generatedServiceID = 0;

            try (PreparedStatement psService = conn.prepareStatement(sqlService, Statement.RETURN_GENERATED_KEYS)) {
                Service s = a.getServiceDetails();

                psService.setInt(1, s.getServiceCategoryID());
                psService.setString(2, s.getServiceName());
                psService.setString(3, s.getStatus());
                psService.setString(4, s.getServiceType());
                psService.setString(5, s.getFulfillmentType());

                psService.executeUpdate();

                try (ResultSet rs = psService.getGeneratedKeys()) {
                    if (rs.next()) {
                        generatedServiceID = rs.getInt(1);
                    }
                }
            }

            if (generatedServiceID <= 0) {
                conn.rollback();
                return false;
            }

            try (PreparedStatement psAcc = conn.prepareStatement(sqlAccommodation)) {
                psAcc.setInt(1, generatedServiceID);
                psAcc.setString(2, a.getName());
                psAcc.setString(3, a.getImage());
                psAcc.setString(4, a.getAddress());
                psAcc.setString(5, a.getPhone());
                psAcc.setString(6, a.getDescription());
                psAcc.setDouble(7, a.getRate());
                psAcc.setString(8, a.getType());
                psAcc.setString(9, a.getStatus());
                psAcc.setTime(10, a.getCheckInTime());
                psAcc.setTime(11, a.getCheckOutTime());

                psAcc.executeUpdate();
            }

            conn.commit();
            return true;

        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }

            e.printStackTrace();

        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }

        return false;
    }

    public boolean updateAccommodation(Accommodation a) {
        String sqlService = "UPDATE [dbo].[Service] " +
                "SET serviceName = ?, [status] = ?, serviceType = ?, fulfillmentType = ?, updateAt = GETDATE() " +
                "WHERE serviceID = ?";

        String sqlAccommodation = "UPDATE [dbo].[Accommodation] " +
                "SET [name] = ?, [image] = ?, [address] = ?, [phone] = ?, " +
                "[description] = ?, rate = ?, [type] = ?, [status] = ?, " +
                "checkInTime = ?, checkOutTime = ? " +
                "WHERE serviceID = ?";

        Connection conn = null;

        try {
            conn = new DBConnection().getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement psService = conn.prepareStatement(sqlService)) {
                Service s = a.getServiceDetails();

                psService.setString(1, s.getServiceName());
                psService.setString(2, s.getStatus());
                psService.setString(3, s.getServiceType());
                psService.setString(4, s.getFulfillmentType());
                psService.setInt(5, a.getServiceID());

                psService.executeUpdate();
            }

            try (PreparedStatement psAcc = conn.prepareStatement(sqlAccommodation)) {
                psAcc.setString(1, a.getName());
                psAcc.setString(2, a.getImage());
                psAcc.setString(3, a.getAddress());
                psAcc.setString(4, a.getPhone());
                psAcc.setString(5, a.getDescription());
                psAcc.setDouble(6, a.getRate());
                psAcc.setString(7, a.getType());
                psAcc.setString(8, a.getStatus());
                psAcc.setTime(9, a.getCheckInTime());
                psAcc.setTime(10, a.getCheckOutTime());
                psAcc.setInt(11, a.getServiceID());

                psAcc.executeUpdate();
            }

            conn.commit();
            return true;

        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }

            e.printStackTrace();

        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }

        return false;
    }

    public boolean deleteAccommodation(int serviceID) {
        String sqlRoom = "DELETE FROM [dbo].[Room] WHERE serviceID = ?";
        String sqlAccommodation = "DELETE FROM [dbo].[Accommodation] WHERE serviceID = ?";
        String sqlService = "DELETE FROM [dbo].[Service] WHERE serviceID = ?";

        Connection conn = null;

        try {
            conn = new DBConnection().getConnection();
            conn.setAutoCommit(false);

            // Xóa Room trước vì Room đang FK tới Accommodation
            try (PreparedStatement psRoom = conn.prepareStatement(sqlRoom)) {
                psRoom.setInt(1, serviceID);
                psRoom.executeUpdate();
            }

            try (PreparedStatement psAcc = conn.prepareStatement(sqlAccommodation)) {
                psAcc.setInt(1, serviceID);
                psAcc.executeUpdate();
            }

            try (PreparedStatement psService = conn.prepareStatement(sqlService)) {
                psService.setInt(1, serviceID);
                psService.executeUpdate();
            }

            conn.commit();
            return true;

        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }

            e.printStackTrace();

        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }

        return false;
    }

    private Accommodation mapAccommodation(ResultSet rs) throws SQLException {
        Accommodation a = new Accommodation();

        a.setServiceID(rs.getInt("serviceID"));
        a.setName(rs.getString("name"));
        a.setImage(rs.getString("image"));
        a.setAddress(rs.getString("address"));
        a.setPhone(rs.getString("phone"));
        a.setDescription(rs.getString("description"));
        a.setRate(rs.getDouble("rate"));
        a.setType(rs.getString("type"));
        a.setStatus(rs.getString("status"));
        a.setCheckInTime(rs.getTime("checkInTime"));
        a.setCheckOutTime(rs.getTime("checkOutTime"));

        Service s = new Service();
        s.setServiceID(rs.getInt("serviceID"));
        s.setServiceCategoryID(rs.getInt("serviceCategoryID"));
        s.setServiceName(rs.getString("serviceName"));
        s.setStatus(rs.getString("serviceStatus"));
        s.setServiceType(rs.getString("serviceType"));
        s.setFulfillmentType(rs.getString("fulfillmentType"));
        s.setCreatedAt(rs.getTimestamp("createAt"));
        s.setUpdateAt(rs.getTimestamp("updateAt"));

        a.setServiceDetails(s);

        return a;
    }
}