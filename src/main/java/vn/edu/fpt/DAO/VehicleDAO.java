package vn.edu.fpt.DAO;

import vn.edu.fpt.model.Vehicles;
import vn.edu.fpt.common.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class VehicleDAO {

    // 1. Xem danh sách tất cả xe cho thuê (ListVehicles - Guest/Customer)
    public List<Vehicles> getAllVehicles() {
        List<Vehicles> list = new ArrayList<>();
        String sql = "SELECT [vehicleID], [serviceID], [vehicleBrand], [license_plate], [price_per_day], [carAvailability] FROM [dbo].[Vehicles]";

        try (Connection conn = new DBConnection().getConnection(); // Kết nối qua DBConnection của thư mục common
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Vehicles vehicle = new Vehicles();
                vehicle.setVehicleID(rs.getInt("vehicleID"));
                vehicle.setServiceID(rs.getInt("serviceID"));
                vehicle.setVehicleBrand(rs.getString("vehicleBrand"));
                vehicle.setLicensePlate(rs.getString("license_plate"));
                vehicle.setPricePerDay(rs.getDouble("price_per_day"));
                vehicle.setCarAvailability(rs.getString("carAvailability"));
                list.add(vehicle);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Xem chi tiết thông tin một chiếc xe (ViewVehicles)
    public Vehicles getVehicleById(int id) {
        String sql = "SELECT * FROM [dbo].[Vehicles] WHERE [vehicleID] = ?";
        try (Connection conn = new DBConnection().getConnection(); //
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Vehicles vehicle = new Vehicles();
                    vehicle.setVehicleID(rs.getInt("vehicleID"));
                    vehicle.setServiceID(rs.getInt("serviceID"));
                    vehicle.setVehicleBrand(rs.getString("vehicleBrand"));
                    vehicle.setLicensePlate(rs.getString("license_plate"));
                    vehicle.setPricePerDay(rs.getDouble("price_per_day"));
                    vehicle.setCarAvailability(rs.getString("carAvailability"));
                    return vehicle;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 3. Thêm xe mới vào danh mục hệ thống (Manage VehicleRental - Staff)
    public boolean insertVehicle(Vehicles vehicle) {
        String sql = "INSERT INTO [dbo].[Vehicles] ([serviceID], [vehicleBrand], [license_plate], [price_per_day], [carAvailability]) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = new DBConnection().getConnection(); //
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, vehicle.getServiceID());
            ps.setString(2, vehicle.getVehicleBrand());
            ps.setString(3, vehicle.getLicensePlate());
            ps.setDouble(4, vehicle.getPricePerDay());
            ps.setString(5, vehicle.getCarAvailability());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 4. Cập nhật thông tin xe hoặc trạng thái thuê/bảo trì (Manage VehicleRental)
    public boolean updateVehicle(Vehicles vehicle) {
        String sql = "UPDATE [dbo].[Vehicles] SET [serviceID] = ?, [vehicleBrand] = ?, [license_plate] = ?, [price_per_day] = ?, [carAvailability] = ? WHERE [vehicleID] = ?";
        try (Connection conn = new DBConnection().getConnection(); //
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, vehicle.getServiceID());
            ps.setString(2, vehicle.getVehicleBrand());
            ps.setString(3, vehicle.getLicensePlate());
            ps.setDouble(4, vehicle.getPricePerDay());
            ps.setString(5, vehicle.getCarAvailability());
            ps.setInt(6, vehicle.getVehicleID());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 5. Xóa phương tiện khỏi hệ thống (Manage VehicleRental)
    public boolean deleteVehicle(int id) {
        String sql = "DELETE FROM [dbo].[Vehicles] WHERE [vehicleID] = ?";
        try (Connection conn = new DBConnection().getConnection(); //
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
