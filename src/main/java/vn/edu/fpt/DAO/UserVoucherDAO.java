package vn.edu.fpt.DAO;

import vn.edu.fpt.common.DBConnection;
import vn.edu.fpt.model.MyVoucherView;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class UserVoucherDAO {

    public boolean isVoucherSavedByUser(int userID, int voucherID) {
        String sql = "SELECT COUNT(1) FROM [dbo].[User_Voucher] WHERE userID = ? AND voucherID = ?";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userID);
            ps.setInt(2, voucherID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean saveVoucher(int userID, int voucherID) {
        String sql =
                "INSERT INTO [dbo].[User_Voucher] " +
                        "(userID, voucherID, [status], savedAt, usedAt, bookingID) " +
                        "VALUES (?, ?, N'SAVED', GETDATE(), NULL, NULL)";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userID);
            ps.setInt(2, voucherID);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public Set<Integer> getSavedVoucherIdsByUser(int userID) {
        Set<Integer> savedVoucherIds = new HashSet<>();
        String sql = "SELECT voucherID FROM [dbo].[User_Voucher] WHERE userID = ?";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    savedVoucherIds.add(rs.getInt("voucherID"));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return savedVoucherIds;
    }

    public List<MyVoucherView> getMyVouchersByUserID(int userID) {
        List<MyVoucherView> vouchers = new ArrayList<>();

        String sql =
                "SELECT uv.userVoucherID, uv.voucherID, uv.[status] AS userVoucherStatus, " +
                        "uv.savedAt, uv.usedAt, " +
                        "v.code, v.[description], v.percentDiscount, v.amountDiscount, " +
                        "v.minOrderAmount, v.applicableType, v.startDate, v.endDate, " +
                        "CASE " +
                        "WHEN UPPER(uv.[status]) = N'USED' THEN 'used' " +
                        "WHEN UPPER(uv.[status]) = N'SAVED' " +
                        "AND v.[status] = N'Active' " +
                        "AND CAST(GETDATE() AS DATE) BETWEEN CAST(v.startDate AS DATE) AND CAST(v.endDate AS DATE) " +
                        "AND v.usedCount < v.quantity THEN 'available' " +
                        "ELSE 'unavailable' END AS displayStatus, " +
                        "CASE " +
                        "WHEN UPPER(uv.[status]) = N'USED' THEN NULL " +
                        "WHEN v.[status] <> N'Active' THEN 'INACTIVE' " +
                        "WHEN CAST(GETDATE() AS DATE) < CAST(v.startDate AS DATE) THEN 'NOT_STARTED' " +
                        "WHEN CAST(GETDATE() AS DATE) > CAST(v.endDate AS DATE) THEN 'EXPIRED' " +
                        "WHEN v.usedCount >= v.quantity THEN 'OUT_OF_STOCK' " +
                        "ELSE 'UNKNOWN' END AS unavailableReason " +
                        "FROM [dbo].[User_Voucher] uv " +
                        "INNER JOIN [dbo].[Voucher] v ON uv.voucherID = v.voucherID " +
                        "WHERE uv.userID = ? " +
                        "ORDER BY uv.savedAt DESC, uv.userVoucherID DESC";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    vouchers.add(mapMyVoucher(rs));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return vouchers;
    }

    public List<MyVoucherView> getApplicableSavedVouchers(
            int userID, String applicableType, BigDecimal orderAmount) {
        List<MyVoucherView> vouchers = new ArrayList<>();
        String sql =
                "SELECT uv.userVoucherID, uv.voucherID, uv.[status] AS userVoucherStatus, " +
                        "uv.savedAt, uv.usedAt, v.code, v.[description], " +
                        "v.percentDiscount, v.amountDiscount, v.minOrderAmount, v.applicableType, " +
                        "v.startDate, v.endDate, 'available' AS displayStatus, " +
                        "CAST(NULL AS varchar(30)) AS unavailableReason " +
                        "FROM [dbo].[User_Voucher] uv " +
                        "INNER JOIN [dbo].[Voucher] v ON uv.voucherID = v.voucherID " +
                        "WHERE uv.userID = ? AND UPPER(uv.[status]) = N'SAVED' " +
                        "AND v.[status] = N'Active' " +
                        "AND GETDATE() BETWEEN v.startDate AND v.endDate " +
                        "AND v.usedCount < v.quantity " +
                        "AND v.applicableType IN (N'All', ?) " +
                        "AND ISNULL(v.minOrderAmount, 0) <= ? " +
                        "ORDER BY v.endDate, uv.savedAt";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userID);
            ps.setString(2, applicableType);
            ps.setBigDecimal(3, orderAmount == null ? BigDecimal.ZERO : orderAmount);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    vouchers.add(mapMyVoucher(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return vouchers;
    }

    private MyVoucherView mapMyVoucher(ResultSet rs) throws Exception {
        MyVoucherView voucher = new MyVoucherView();

        voucher.setUserVoucherID(rs.getInt("userVoucherID"));
        voucher.setVoucherID(rs.getInt("voucherID"));
        voucher.setCode(rs.getString("code"));
        voucher.setDescription(rs.getString("description"));
        voucher.setPercentDiscount(rs.getBigDecimal("percentDiscount"));
        voucher.setAmountDiscount(rs.getBigDecimal("amountDiscount"));
        voucher.setMinOrderAmount(rs.getBigDecimal("minOrderAmount"));
        voucher.setApplicableType(rs.getString("applicableType"));
        voucher.setStartDate(rs.getTimestamp("startDate"));
        voucher.setEndDate(rs.getTimestamp("endDate"));
        voucher.setUserVoucherStatus(rs.getString("userVoucherStatus"));
        voucher.setSavedAt(rs.getTimestamp("savedAt"));
        voucher.setUsedAt(rs.getTimestamp("usedAt"));
        voucher.setDisplayStatus(rs.getString("displayStatus"));
        voucher.setUnavailableReason(rs.getString("unavailableReason"));

        return voucher;
    }
}
