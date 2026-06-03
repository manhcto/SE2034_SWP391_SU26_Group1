package vn.edu.fpt.DAO;

import vn.edu.fpt.common.DBConnection;
import vn.edu.fpt.model.Service;
import vn.edu.fpt.model.Vehicle;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VehicleDAO {

    public List<Vehicle> getAllVehicles() {
        List<Vehicle> list = new ArrayList<>();

        String sql = "SELECT v.*, " +
                "s.serviceCategoryID, s.serviceName, s.[status] AS serviceStatus, " +
                "s.serviceType, s.fulfillmentType, s.createAt, s.updateAt " +
                "FROM [dbo].[Vehicle] v " +
                "JOIN [dbo].[Service] s ON v.serviceID = s.serviceID";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Vehicle v = mapVehicle(rs);
                list.add(v);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public Vehicle getVehicleById(int serviceID) {
        String sql = "SELECT v.*, " +
                "s.serviceCategoryID, s.serviceName, s.[status] AS serviceStatus, " +
                "s.serviceType, s.fulfillmentType, s.createAt, s.updateAt " +
                "FROM [dbo].[Vehicle] v " +
                "JOIN [dbo].[Service] s ON v.serviceID = s.serviceID " +
                "WHERE v.serviceID = ?";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, serviceID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapVehicle(rs);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean addVehicle(Vehicle v) {
        String sqlService = "INSERT INTO [dbo].[Service] " +
                "(serviceCategoryID, serviceName, [status], serviceType, fulfillmentType, createAt) " +
                "VALUES (?, ?, ?, ?, ?, GETDATE())";

        String sqlVehicle = "INSERT INTO [dbo].[Vehicle] " +
                "(serviceID, vehicleBrand, license_plate, price_per_day, [status], image, seat_count, vehicle_type, transmission, fuel_type) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        Connection conn = null;

        try {
            conn = new DBConnection().getConnection();
            conn.setAutoCommit(false);

            int generatedServiceID = 0;

            try (PreparedStatement psService = conn.prepareStatement(sqlService, Statement.RETURN_GENERATED_KEYS)) {
                Service s = v.getServiceDetails();

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

            try (PreparedStatement psVehicle = conn.prepareStatement(sqlVehicle)) {
                psVehicle.setInt(1, generatedServiceID);
                psVehicle.setString(2, v.getVehicleBrand());
                psVehicle.setString(3, v.getLicensePlate());
                psVehicle.setDouble(4, v.getPricePerDay());
                psVehicle.setString(5, v.getStatus());
                psVehicle.setString(6, v.getImage());
                psVehicle.setInt(7, v.getSeatCount());
                psVehicle.setString(8, v.getVehicleType());
                psVehicle.setString(9, v.getTransmission());
                psVehicle.setString(10, v.getFuelType());

                psVehicle.executeUpdate();
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

    public boolean updateVehicle(Vehicle v) {
        String sqlService = "UPDATE [dbo].[Service] " +
                "SET serviceName = ?, [status] = ?, serviceType = ?, fulfillmentType = ?, updateAt = GETDATE() " +
                "WHERE serviceID = ?";

        String sqlVehicle = "UPDATE [dbo].[Vehicle] " +
                "SET vehicleBrand = ?, license_plate = ?, price_per_day = ?, [status] = ?, " +
                "image = ?, seat_count = ?, vehicle_type = ?, transmission = ?, fuel_type = ? " +
                "WHERE serviceID = ?";

        Connection conn = null;

        try {
            conn = new DBConnection().getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement psService = conn.prepareStatement(sqlService)) {
                Service s = v.getServiceDetails();

                psService.setString(1, s.getServiceName());
                psService.setString(2, s.getStatus());
                psService.setString(3, s.getServiceType());
                psService.setString(4, s.getFulfillmentType());
                psService.setInt(5, v.getServiceID());

                psService.executeUpdate();
            }

            try (PreparedStatement psVehicle = conn.prepareStatement(sqlVehicle)) {
                psVehicle.setString(1, v.getVehicleBrand());
                psVehicle.setString(2, v.getLicensePlate());
                psVehicle.setDouble(3, v.getPricePerDay());
                psVehicle.setString(4, v.getStatus());
                psVehicle.setString(5, v.getImage());
                psVehicle.setInt(6, v.getSeatCount());
                psVehicle.setString(7, v.getVehicleType());
                psVehicle.setString(8, v.getTransmission());
                psVehicle.setString(9, v.getFuelType());
                psVehicle.setInt(10, v.getServiceID());

                psVehicle.executeUpdate();
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

    public boolean deleteVehicle(int serviceID) {
        String sqlVehicle = "DELETE FROM [dbo].[Vehicle] WHERE serviceID = ?";
        String sqlService = "DELETE FROM [dbo].[Service] WHERE serviceID = ?";

        Connection conn = null;

        try {
            conn = new DBConnection().getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement psVehicle = conn.prepareStatement(sqlVehicle)) {
                psVehicle.setInt(1, serviceID);
                psVehicle.executeUpdate();
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

    public List<Vehicle> getAvailableVehiclesForCustomer() {
        List<Vehicle> list = new ArrayList<>();

        String sql = "SELECT v.*, " +
                "s.serviceCategoryID, s.serviceName, s.[status] AS serviceStatus, " +
                "s.serviceType, s.fulfillmentType, s.createAt, s.updateAt " +
                "FROM [dbo].[Vehicle] v " +
                "JOIN [dbo].[Service] s ON v.serviceID = s.serviceID " +
                "WHERE s.[status] = 'Active' " +
                "AND s.serviceType = 'Vehicle' " +
                "AND v.[status] = 'Available' " +
                "ORDER BY v.price_per_day ASC, v.serviceID DESC";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Vehicle v = mapVehicle(rs);
                list.add(v);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public Vehicle getVehicleByIdForCustomer(int serviceID) {
        String sql = "SELECT v.*, " +
                "s.serviceCategoryID, s.serviceName, s.[status] AS serviceStatus, " +
                "s.serviceType, s.fulfillmentType, s.createAt, s.updateAt " +
                "FROM [dbo].[Vehicle] v " +
                "JOIN [dbo].[Service] s ON v.serviceID = s.serviceID " +
                "WHERE v.serviceID = ? " +
                "AND s.[status] = 'Active' " +
                "AND s.serviceType = 'Vehicle' " +
                "AND v.[status] = 'Available'";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, serviceID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapVehicle(rs);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    private Vehicle mapVehicle(ResultSet rs) throws SQLException {
        Vehicle v = new Vehicle();

        v.setServiceID(rs.getInt("serviceID"));
        v.setVehicleBrand(rs.getString("vehicleBrand"));
        v.setLicensePlate(rs.getString("license_plate"));
        v.setPricePerDay(rs.getDouble("price_per_day"));
        v.setStatus(rs.getString("status"));

        v.setImage(rs.getString("image"));
        v.setSeatCount(rs.getInt("seat_count"));
        v.setVehicleType(rs.getString("vehicle_type"));
        v.setTransmission(rs.getString("transmission"));
        v.setFuelType(rs.getString("fuel_type"));

        Service s = new Service();
        s.setServiceID(rs.getInt("serviceID"));
        s.setServiceCategoryID(rs.getInt("serviceCategoryID"));
        s.setServiceName(rs.getString("serviceName"));
        s.setStatus(rs.getString("serviceStatus"));
        s.setServiceType(rs.getString("serviceType"));
        s.setFulfillmentType(rs.getString("fulfillmentType"));
        s.setCreatedAt(rs.getTimestamp("createAt"));
        s.setUpdateAt(rs.getTimestamp("updateAt"));

        v.setServiceDetails(s);

        return v;
    }
}