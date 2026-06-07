package vn.edu.fpt.DAO;

import vn.edu.fpt.common.DBConnection;
import vn.edu.fpt.model.Service;
import vn.edu.fpt.model.Vehicle;
import vn.edu.fpt.model.VehicleBrand;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class VehicleDAO {

    private static final String BASE_SELECT =
            "SELECT " +
                    "v.serviceID, " +
                    "v.brandID AS vehicleBrandID, " +
                    "v.vehicleModel, " +
                    "v.license_plate, " +
                    "v.price_per_day, " +
                    "v.[status] AS vehicleStatus, " +
                    "v.image, " +
                    "v.seat_count, " +
                    "v.vehicle_type, " +
                    "v.transmission, " +
                    "v.fuel_type, " +
                    "v.pickup_province, " +
                    "v.pickup_district, " +
                    "v.pickup_ward, " +
                    "v.pickup_address, " +
                    "v.description, " +
                    "v.usage_notes, " +
                    "v.deposit_amount, " +
                    "b.brandID, " +
                    "b.brandName, " +
                    "b.[status] AS brandStatus, " +
                    "s.serviceCategoryID, " +
                    "s.serviceName, " +
                    "s.[status] AS serviceStatus, " +
                    "s.serviceType, " +
                    "s.fulfillmentType, " +
                    "s.createAt, " +
                    "s.updateAt " +
                    "FROM [dbo].[Vehicle] v " +
                    "JOIN [dbo].[Service] s ON v.serviceID = s.serviceID " +
                    "LEFT JOIN [dbo].[Vehicle_Brand] b ON v.brandID = b.brandID ";

    public List<Vehicle> getAllVehicles() {
        List<Vehicle> list = new ArrayList<>();

        String sql = BASE_SELECT +
                "ORDER BY v.serviceID DESC";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapVehicle(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public Vehicle getVehicleById(int serviceID) {
        String sql = BASE_SELECT +
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

    public List<Vehicle> getAvailableVehiclesForCustomer() {
        List<Vehicle> list = new ArrayList<>();

        String sql = BASE_SELECT +
                "WHERE s.[status] = N'Active' " +
                "AND s.serviceType = N'Vehicle' " +
                "AND v.[status] = N'Available' " +
                "ORDER BY v.price_per_day ASC, v.serviceID DESC";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapVehicle(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public Vehicle getVehicleByIdForCustomer(int serviceID) {
        String sql = BASE_SELECT +
                "WHERE v.serviceID = ? " +
                "AND s.[status] = N'Active' " +
                "AND s.serviceType = N'Vehicle' " +
                "AND v.[status] = N'Available'";

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

    public boolean addVehicle(Vehicle vehicle) {
        String sqlService =
                "INSERT INTO [dbo].[Service] " +
                        "(serviceCategoryID, serviceName, [status], serviceType, fulfillmentType, createAt) " +
                        "VALUES (?, ?, ?, ?, ?, GETDATE())";

        String sqlVehicle =
                "INSERT INTO [dbo].[Vehicle] (" +
                        "serviceID, brandID, vehicleModel, license_plate, price_per_day, [status], " +
                        "image, seat_count, vehicle_type, transmission, fuel_type, " +
                        "pickup_province, pickup_district, pickup_ward, pickup_address, " +
                        "description, usage_notes, deposit_amount" +
                        ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        Connection conn = null;

        try {
            conn = new DBConnection().getConnection();
            conn.setAutoCommit(false);

            String serviceName = resolveServiceName(conn, vehicle);
            Service service = vehicle.getServiceDetails();

            int serviceCategoryID =
                    service != null && service.getServiceCategoryID() > 0
                            ? service.getServiceCategoryID()
                            : 2;

            String serviceStatus =
                    service != null && !isBlank(service.getStatus())
                            ? service.getStatus()
                            : "Active";

            String serviceType =
                    service != null && !isBlank(service.getServiceType())
                            ? service.getServiceType()
                            : "Vehicle";

            String fulfillmentType =
                    service != null && !isBlank(service.getFulfillmentType())
                            ? service.getFulfillmentType()
                            : "Rental";

            int generatedServiceID;

            try (PreparedStatement psService =
                         conn.prepareStatement(sqlService, Statement.RETURN_GENERATED_KEYS)) {

                psService.setInt(1, serviceCategoryID);
                psService.setString(2, serviceName);
                psService.setString(3, serviceStatus);
                psService.setString(4, serviceType);
                psService.setString(5, fulfillmentType);

                int affectedRows = psService.executeUpdate();

                if (affectedRows == 0) {
                    conn.rollback();
                    return false;
                }

                try (ResultSet rs = psService.getGeneratedKeys()) {
                    if (!rs.next()) {
                        conn.rollback();
                        return false;
                    }

                    generatedServiceID = rs.getInt(1);
                }
            }

            try (PreparedStatement psVehicle = conn.prepareStatement(sqlVehicle)) {
                psVehicle.setInt(1, generatedServiceID);
                psVehicle.setInt(2, vehicle.getBrandID());
                psVehicle.setString(3, vehicle.getVehicleModel());
                psVehicle.setString(4, vehicle.getLicensePlate());
                psVehicle.setDouble(5, vehicle.getPricePerDay());
                psVehicle.setString(6, vehicle.getStatus());
                psVehicle.setString(7, vehicle.getImage());
                psVehicle.setInt(8, vehicle.getSeatCount());
                psVehicle.setString(9, vehicle.getVehicleType());
                psVehicle.setString(10, vehicle.getTransmission());
                psVehicle.setString(11, vehicle.getFuelType());
                psVehicle.setString(12, vehicle.getPickupProvince());
                psVehicle.setString(13, vehicle.getPickupDistrict());
                psVehicle.setString(14, vehicle.getPickupWard());
                psVehicle.setString(15, vehicle.getPickupAddress());
                psVehicle.setString(16, vehicle.getDescription());
                psVehicle.setString(17, vehicle.getUsageNotes());
                psVehicle.setDouble(18, vehicle.getDepositAmount());

                psVehicle.executeUpdate();
            }

            conn.commit();
            return true;

        } catch (Exception e) {
            rollback(conn);
            e.printStackTrace();
        } finally {
            closeConnection(conn);
        }

        return false;
    }

    public boolean updateVehicle(Vehicle vehicle) {
        String sqlService =
                "UPDATE [dbo].[Service] SET " +
                        "serviceName = ?, " +
                        "[status] = ?, " +
                        "serviceType = ?, " +
                        "fulfillmentType = ?, " +
                        "updateAt = GETDATE() " +
                        "WHERE serviceID = ?";

        String sqlVehicle =
                "UPDATE [dbo].[Vehicle] SET " +
                        "brandID = ?, " +
                        "vehicleModel = ?, " +
                        "license_plate = ?, " +
                        "price_per_day = ?, " +
                        "[status] = ?, " +
                        "image = ?, " +
                        "seat_count = ?, " +
                        "vehicle_type = ?, " +
                        "transmission = ?, " +
                        "fuel_type = ?, " +
                        "pickup_province = ?, " +
                        "pickup_district = ?, " +
                        "pickup_ward = ?, " +
                        "pickup_address = ?, " +
                        "description = ?, " +
                        "usage_notes = ?, " +
                        "deposit_amount = ? " +
                        "WHERE serviceID = ?";

        Connection conn = null;

        try {
            conn = new DBConnection().getConnection();
            conn.setAutoCommit(false);

            String serviceName = resolveServiceName(conn, vehicle);
            Service service = vehicle.getServiceDetails();

            String serviceStatus =
                    service != null && !isBlank(service.getStatus())
                            ? service.getStatus()
                            : "Active";

            String serviceType =
                    service != null && !isBlank(service.getServiceType())
                            ? service.getServiceType()
                            : "Vehicle";

            String fulfillmentType =
                    service != null && !isBlank(service.getFulfillmentType())
                            ? service.getFulfillmentType()
                            : "Rental";

            try (PreparedStatement psService = conn.prepareStatement(sqlService)) {
                psService.setString(1, serviceName);
                psService.setString(2, serviceStatus);
                psService.setString(3, serviceType);
                psService.setString(4, fulfillmentType);
                psService.setInt(5, vehicle.getServiceID());

                psService.executeUpdate();
            }

            try (PreparedStatement psVehicle = conn.prepareStatement(sqlVehicle)) {
                psVehicle.setInt(1, vehicle.getBrandID());
                psVehicle.setString(2, vehicle.getVehicleModel());
                psVehicle.setString(3, vehicle.getLicensePlate());
                psVehicle.setDouble(4, vehicle.getPricePerDay());
                psVehicle.setString(5, vehicle.getStatus());
                psVehicle.setString(6, vehicle.getImage());
                psVehicle.setInt(7, vehicle.getSeatCount());
                psVehicle.setString(8, vehicle.getVehicleType());
                psVehicle.setString(9, vehicle.getTransmission());
                psVehicle.setString(10, vehicle.getFuelType());
                psVehicle.setString(11, vehicle.getPickupProvince());
                psVehicle.setString(12, vehicle.getPickupDistrict());
                psVehicle.setString(13, vehicle.getPickupWard());
                psVehicle.setString(14, vehicle.getPickupAddress());
                psVehicle.setString(15, vehicle.getDescription());
                psVehicle.setString(16, vehicle.getUsageNotes());
                psVehicle.setDouble(17, vehicle.getDepositAmount());
                psVehicle.setInt(18, vehicle.getServiceID());

                psVehicle.executeUpdate();
            }

            conn.commit();
            return true;

        } catch (Exception e) {
            rollback(conn);
            e.printStackTrace();
        } finally {
            closeConnection(conn);
        }

        return false;
    }

    public boolean deleteVehicle(int serviceID) {
        String sqlVehicle =
                "DELETE FROM [dbo].[Vehicle] WHERE serviceID = ?";

        String sqlService =
                "DELETE FROM [dbo].[Service] WHERE serviceID = ?";

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
            rollback(conn);
            e.printStackTrace();
        } finally {
            closeConnection(conn);
        }

        return false;
    }

    private Vehicle mapVehicle(ResultSet rs) throws SQLException {
        Vehicle vehicle = new Vehicle();

        vehicle.setServiceID(rs.getInt("serviceID"));
        vehicle.setBrandID(rs.getInt("vehicleBrandID"));
        vehicle.setVehicleModel(rs.getString("vehicleModel"));
        vehicle.setLicensePlate(rs.getString("license_plate"));
        vehicle.setPricePerDay(rs.getDouble("price_per_day"));
        vehicle.setStatus(rs.getString("vehicleStatus"));
        vehicle.setImage(rs.getString("image"));
        vehicle.setSeatCount(rs.getInt("seat_count"));
        vehicle.setVehicleType(rs.getString("vehicle_type"));
        vehicle.setTransmission(rs.getString("transmission"));
        vehicle.setFuelType(rs.getString("fuel_type"));
        vehicle.setPickupProvince(rs.getString("pickup_province"));
        vehicle.setPickupDistrict(rs.getString("pickup_district"));
        vehicle.setPickupWard(rs.getString("pickup_ward"));
        vehicle.setPickupAddress(rs.getString("pickup_address"));
        vehicle.setDescription(rs.getString("description"));
        vehicle.setUsageNotes(rs.getString("usage_notes"));
        vehicle.setDepositAmount(rs.getDouble("deposit_amount"));

        VehicleBrand brand = new VehicleBrand();
        brand.setBrandID(rs.getInt("brandID"));
        brand.setBrandName(rs.getString("brandName"));
        brand.setStatus(rs.getString("brandStatus"));
        vehicle.setBrandDetails(brand);

        Service service = new Service();
        service.setServiceID(rs.getInt("serviceID"));
        service.setServiceCategoryID(rs.getInt("serviceCategoryID"));
        service.setServiceName(rs.getString("serviceName"));
        service.setStatus(rs.getString("serviceStatus"));
        service.setServiceType(rs.getString("serviceType"));
        service.setFulfillmentType(rs.getString("fulfillmentType"));
        service.setCreatedAt(rs.getTimestamp("createAt"));
        service.setUpdateAt(rs.getTimestamp("updateAt"));
        vehicle.setServiceDetails(service);

        return vehicle;
    }

    private String resolveServiceName(Connection conn, Vehicle vehicle) throws SQLException {
        if (vehicle.getServiceDetails() != null
                && !isBlank(vehicle.getServiceDetails().getServiceName())) {
            return vehicle.getServiceDetails().getServiceName().trim();
        }

        String brandName = getBrandNameById(conn, vehicle.getBrandID());
        String vehicleModel =
                vehicle.getVehicleModel() == null
                        ? ""
                        : vehicle.getVehicleModel().trim();

        return (brandName + " " + vehicleModel).trim();
    }

    private String getBrandNameById(Connection conn, int brandID) throws SQLException {
        String sql =
                "SELECT brandName FROM [dbo].[Vehicle_Brand] WHERE brandID = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, brandID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("brandName");
                }
            }
        }

        return "";
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private void rollback(Connection conn) {
        if (conn != null) {
            try {
                conn.rollback();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    private void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.setAutoCommit(true);
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}