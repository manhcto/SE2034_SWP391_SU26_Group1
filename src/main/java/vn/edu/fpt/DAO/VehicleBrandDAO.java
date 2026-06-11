package vn.edu.fpt.DAO;

import vn.edu.fpt.common.DBConnection;
import vn.edu.fpt.model.VehicleBrand;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class VehicleBrandDAO {

    public List<VehicleBrand> getAllBrands() {
        List<VehicleBrand> list = new ArrayList<>();

        String sql = "SELECT brandID, brandName, [status] " +
                "FROM [dbo].[Vehicle_Brand] " +
                "ORDER BY brandName ASC";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapVehicleBrand(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<VehicleBrand> getActiveBrands() {
        List<VehicleBrand> list = new ArrayList<>();

        String sql = "SELECT brandID, brandName, [status] " +
                "FROM [dbo].[Vehicle_Brand] " +
                "WHERE [status] = N'Active' " +
                "ORDER BY brandName ASC";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapVehicleBrand(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public VehicleBrand getBrandById(int brandID) {
        String sql = "SELECT brandID, brandName, [status] " +
                "FROM [dbo].[Vehicle_Brand] " +
                "WHERE brandID = ?";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, brandID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapVehicleBrand(rs);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean addBrand(VehicleBrand brand) {
        String sql = "INSERT INTO [dbo].[Vehicle_Brand] " +
                "(brandName, [status]) VALUES (?, ?)";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, brand.getBrandName());
            ps.setString(2, brand.getStatus());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean updateBrand(VehicleBrand brand) {
        String sql = "UPDATE [dbo].[Vehicle_Brand] " +
                "SET brandName = ?, [status] = ? " +
                "WHERE brandID = ?";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, brand.getBrandName());
            ps.setString(2, brand.getStatus());
            ps.setInt(3, brand.getBrandID());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean deactivateBrand(int brandID) {
        String sql = "UPDATE [dbo].[Vehicle_Brand] " +
                "SET [status] = N'Inactive' " +
                "WHERE brandID = ?";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, brandID);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    private VehicleBrand mapVehicleBrand(ResultSet rs) throws Exception {
        VehicleBrand brand = new VehicleBrand();

        brand.setBrandID(rs.getInt("brandID"));
        brand.setBrandName(rs.getString("brandName"));
        brand.setStatus(rs.getString("status"));

        return brand;
    }
}