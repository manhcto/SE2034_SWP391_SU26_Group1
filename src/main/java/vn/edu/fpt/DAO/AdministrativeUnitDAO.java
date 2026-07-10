package vn.edu.fpt.DAO;

import vn.edu.fpt.common.DBConnection;
import vn.edu.fpt.model.AdministrativeUnit;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

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
                unit.setRegionGroup(resolveRegionGroup(unit.getProvinceName()));

                units.add(unit);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return units;
    }

    /**
     * Dùng riêng cho form Add/Edit Tour.
     *
     * Bảng Administrative_Unit của project có rất nhiều phường/xã cho cùng một tỉnh/thành.
     * Nếu lấy trực tiếp toàn bộ bảng, dropdown điểm đi/điểm đến sẽ bị lặp hàng chục lần
     * cùng một tỉnh, ví dụ "Tỉnh Thanh Hóa". Vì vậy hàm này chỉ lấy các dòng đại diện
     * cấp tỉnh/thành đã seed cho tour, sau đó GROUP BY provinceName để chống trùng dữ liệu
     * kể cả khi file seed bị chạy nhiều lần.
     */
    public List<AdministrativeUnit> getActiveProvinces() {
        List<AdministrativeUnit> provinces = new ArrayList<>();

        String sql =
                "SELECT " +
                "    MIN(administrativeUnitID) AS administrativeUnitID, " +
                "    MIN(provinceCode) AS provinceCode, " +
                "    provinceName " +
                "FROM [dbo].[Administrative_Unit] " +
                "WHERE isActive = 1 " +
                "  AND provinceName IS NOT NULL " +
                "  AND LTRIM(RTRIM(provinceName)) <> N'' " +
                "  AND ( " +
                "        wardType IN (N'Tỉnh/Thành', N'Tỉnh', N'Thành phố') " +
                "        OR wardName = N'Trung tâm' " +
                "      ) " +
                "GROUP BY provinceName " +
                "ORDER BY " +
                "    CASE " +
                "        WHEN MIN(CASE WHEN ISNUMERIC(provinceCode) = 1 THEN CAST(provinceCode AS INT) END) IS NULL THEN 999 " +
                "        ELSE MIN(CASE WHEN ISNUMERIC(provinceCode) = 1 THEN CAST(provinceCode AS INT) END) " +
                "    END, " +
                "    provinceName";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                AdministrativeUnit province = new AdministrativeUnit();

                province.setAdministrativeUnitID(rs.getInt("administrativeUnitID"));
                province.setProvinceCode(rs.getString("provinceCode"));
                province.setProvinceName(rs.getString("provinceName"));
                province.setWardType("Tỉnh/Thành");
                province.setWardName("Trung tâm");
                province.setRegionGroup(resolveRegionGroup(province.getProvinceName()));

                provinces.add(province);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return provinces;
    }

    public boolean isValidProvinceName(String provinceName) {
        if (isBlank(provinceName)) {
            return false;
        }

        String sql =
                "SELECT 1 " +
                "FROM [dbo].[Administrative_Unit] " +
                "WHERE isActive = 1 " +
                "  AND provinceName = ? " +
                "  AND ( " +
                "        wardType IN (N'Tỉnh/Thành', N'Tỉnh', N'Thành phố') " +
                "        OR wardName = N'Trung tâm' " +
                "      )";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, provinceName.trim());

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
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

    private String resolveRegionGroup(String provinceName) {
        if (provinceName == null) {
            return "Khác";
        }

        String normalized = provinceName
                .toLowerCase()
                .replace("thành phố", "")
                .replace("tỉnh", "")
                .trim();

        if (containsAny(normalized,
                "hà nội", "hải phòng", "quảng ninh", "cao bằng", "lạng sơn",
                "lai châu", "điện biên", "sơn la", "lào cai", "tuyên quang",
                "thái nguyên", "phú thọ", "bắc ninh", "hưng yên", "ninh bình",
                "hà giang", "yên bái", "bắc kạn", "bắc giang", "hòa bình",
                "nam định", "thái bình", "vĩnh phúc", "hà nam")) {
            return "Miền Bắc";
        }

        if (containsAny(normalized,
                "thanh hóa", "nghệ an", "hà tĩnh", "quảng trị", "quảng bình",
                "huế", "đà nẵng", "quảng nam", "quảng ngãi", "bình định",
                "gia lai", "đắk lắk", "đắc lắc", "khánh hòa", "ninh thuận",
                "bình thuận", "lâm đồng", "kon tum", "phú yên", "đắk nông")) {
            return "Miền Trung";
        }

        if (containsAny(normalized,
                "hồ chí minh", "bà rịa", "vũng tàu", "đồng nai", "tây ninh",
                "bình dương", "bình phước", "long an", "đồng tháp", "an giang",
                "cần thơ", "vĩnh long", "cà mau", "bạc liêu", "bến tre",
                "tiền giang", "trà vinh", "sóc trăng", "hậu giang", "kiên giang")) {
            return "Miền Nam";
        }

        return "Khác";
    }

    private boolean containsAny(String value, String... keywords) {
        for (String keyword : keywords) {
            if (value.contains(keyword)) {
                return true;
            }
        }
        return false;
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
