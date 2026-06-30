package vn.edu.fpt.DAO;

import vn.edu.fpt.common.DBConnection;
import vn.edu.fpt.model.Service;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ServiceDAO {

    public List<Service> getAllServices() {
        List<Service> list = new ArrayList<>();

        String sql = "SELECT serviceID, serviceCategoryID, serviceName, [status], " +
                "serviceType, fulfillmentType, createAt, updateAt " +
                "FROM [dbo].[Service]";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Service s = mapService(rs);
                list.add(s);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public Service getServiceById(int serviceID) {
        String sql = "SELECT serviceID, serviceCategoryID, serviceName, [status], " +
                "serviceType, fulfillmentType, createAt, updateAt " +
                "FROM [dbo].[Service] WHERE serviceID = ?";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, serviceID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapService(rs);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public int addService(Service s) {
        String sql = "INSERT INTO [dbo].[Service] " +
                "(serviceCategoryID, serviceName, [status], serviceType, fulfillmentType, createAt) " +
                "VALUES (?, ?, ?, ?, ?, GETDATE())";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, s.getServiceCategoryID());
            ps.setString(2, s.getServiceName());
            ps.setString(3, s.getStatus());
            ps.setString(4, s.getServiceType());
            ps.setString(5, s.getFulfillmentType());

            int affectedRows = ps.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    public boolean updateService(Service s) {
        String sql = "UPDATE [dbo].[Service] " +
                "SET serviceCategoryID = ?, serviceName = ?, [status] = ?, " +
                "serviceType = ?, fulfillmentType = ?, updateAt = GETDATE() " +
                "WHERE serviceID = ?";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, s.getServiceCategoryID());
            ps.setString(2, s.getServiceName());
            ps.setString(3, s.getStatus());
            ps.setString(4, s.getServiceType());
            ps.setString(5, s.getFulfillmentType());
            ps.setInt(6, s.getServiceID());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean deleteService(int serviceID) {
        String sql = "DELETE FROM [dbo].[Service] WHERE serviceID = ?";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, serviceID);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    private Service mapService(ResultSet rs) throws SQLException {
        Service s = new Service();

        s.setServiceID(rs.getInt("serviceID"));
        s.setServiceCategoryID(rs.getInt("serviceCategoryID"));
        s.setServiceName(rs.getString("serviceName"));
        s.setStatus(rs.getString("status"));
        s.setServiceType(rs.getString("serviceType"));
        s.setFulfillmentType(rs.getString("fulfillmentType"));

        // DB là createAt, Java model là createdAt
        s.setCreatedAt(rs.getTimestamp("createAt"));
        s.setUpdateAt(rs.getTimestamp("updateAt"));

        return s;
    }
}