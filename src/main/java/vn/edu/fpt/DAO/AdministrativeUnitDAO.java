package vn.edu.fpt.DAO;

import vn.edu.fpt.common.DBConnection;
import vn.edu.fpt.model.AdministrativeUnit;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

public class AdministrativeUnitDAO {

    public List<AdministrativeUnit> getActiveUnits() {
        List<AdministrativeUnit> units = new ArrayList<>();

        String sql =
                "SELECT administrativeUnitID, provinceCode, provinceName, wardType, wardName " +
                "FROM [dbo].[Administrative_Unit] " +
                "WHERE isActive = 1 " +
                "ORDER BY CAST(provinceCode AS INT), " +
                "CASE wardType WHEN N'Phường' THEN 1 WHEN N'Xã' THEN 2 ELSE 3 END, " +
                "wardName";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                AdministrativeUnit unit = new AdministrativeUnit();

                unit.setAdministrativeUnitID(rs.getInt("administrativeUnitID"));
                unit.setProvinceCode(rs.getString("provinceCode"));
                unit.setProvinceName(rs.getString("provinceName"));
                unit.setWardType(rs.getString("wardType"));
                unit.setWardName(rs.getString("wardName"));

                units.add(unit);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return units;
    }

    public List<String> getActiveProvinceNames() {
        Set<String> names = new LinkedHashSet<>();

        String sql =
                "SELECT DISTINCT provinceCode, provinceName " +
                "FROM [dbo].[Administrative_Unit] " +
                "WHERE isActive = 1 " +
                "ORDER BY CAST(provinceCode AS INT), provinceName";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                names.add(rs.getString("provinceName"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return new ArrayList<>(names);
    }

    public List<String> getActiveWardNamesByProvince(String provinceName) {
        List<String> names = new ArrayList<>();

        String sql =
                "SELECT wardName " +
                "FROM [dbo].[Administrative_Unit] " +
                "WHERE isActive = 1 AND provinceName = ? " +
                "ORDER BY CASE wardType WHEN N'Phường' THEN 1 WHEN N'Xã' THEN 2 ELSE 3 END, wardName";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, provinceName);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    names.add(rs.getString("wardName"));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return names;
    }

    public boolean isValidProvinceWard(String provinceName, String wardName) {
        if (isBlank(provinceName) || isBlank(wardName)) {
            return false;
        }

        String sql =
                "SELECT 1 " +
                "FROM [dbo].[Administrative_Unit] " +
                "WHERE isActive = 1 AND provinceName = ? AND wardName = ?";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, provinceName.trim());
            ps.setString(2, wardName.trim());

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
