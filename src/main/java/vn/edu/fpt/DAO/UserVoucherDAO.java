package vn.edu.fpt.DAO;

import vn.edu.fpt.common.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashSet;
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
}
