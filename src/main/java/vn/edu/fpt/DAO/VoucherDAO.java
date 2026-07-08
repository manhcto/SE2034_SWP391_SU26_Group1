package vn.edu.fpt.DAO;

import vn.edu.fpt.common.DBConnection;
import vn.edu.fpt.model.Voucher;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class VoucherDAO {

    public List<Voucher> getAllVouchers() {
        List<Voucher> vouchers = new ArrayList<>();

        String sql =
                "SELECT voucherID, code, [description], percentDiscount, amountDiscount, " +
                        "minOrderAmount, quantity, startDate, endDate, [status], createdAt, updatedAt " +
                        "FROM [dbo].[Voucher] " +
                        "ORDER BY createdAt DESC, voucherID DESC";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                vouchers.add(mapVoucher(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return vouchers;
    }

    public List<Voucher> getAvailableVouchersForCustomer() {
        List<Voucher> vouchers = new ArrayList<>();

        String sql =
                "SELECT voucherID, code, [description], percentDiscount, amountDiscount, " +
                        "minOrderAmount, quantity, startDate, endDate, [status], createdAt, updatedAt " +
                        "FROM [dbo].[Voucher] " +
                        "WHERE [status] = N'Active' " +
                        "AND quantity > 0 " +
                        "AND GETDATE() BETWEEN startDate AND endDate " +
                        "ORDER BY endDate ASC, voucherID DESC";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                vouchers.add(mapVoucher(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return vouchers;
    }

    public boolean insertVoucher(Voucher voucher) {
        String sql =
                "INSERT INTO [dbo].[Voucher] " +
                        "([code], [description], percentDiscount, amountDiscount, minOrderAmount, " +
                        "quantity, startDate, endDate, [status]) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, voucher.getCode());
            ps.setString(2, emptyToNull(voucher.getDescription()));
            setNullableBigDecimal(ps, 3, voucher.getPercentDiscount());
            setNullableBigDecimal(ps, 4, voucher.getAmountDiscount());
            setNullableBigDecimal(ps, 5, voucher.getMinOrderAmount());
            ps.setInt(6, voucher.getQuantity());
            ps.setTimestamp(7, toTimestamp(voucher.getStartDate()));
            ps.setTimestamp(8, toTimestamp(voucher.getEndDate()));
            ps.setString(9, voucher.getStatus());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean isCodeExists(String code) {
        String sql = "SELECT COUNT(1) FROM [dbo].[Voucher] WHERE UPPER([code]) = UPPER(?)";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, code);

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

    private Voucher mapVoucher(ResultSet rs) throws Exception {
        Voucher voucher = new Voucher();

        voucher.setVoucherID(rs.getInt("voucherID"));
        voucher.setCode(rs.getString("code"));
        voucher.setDescription(rs.getString("description"));
        voucher.setPercentDiscount(rs.getBigDecimal("percentDiscount"));
        voucher.setAmountDiscount(rs.getBigDecimal("amountDiscount"));
        voucher.setMinOrderAmount(rs.getBigDecimal("minOrderAmount"));
        voucher.setQuantity(rs.getInt("quantity"));
        voucher.setStartDate(rs.getTimestamp("startDate"));
        voucher.setEndDate(rs.getTimestamp("endDate"));
        voucher.setStatus(rs.getString("status"));
        voucher.setCreatedAt(rs.getTimestamp("createdAt"));
        voucher.setUpdatedAt(rs.getTimestamp("updatedAt"));

        return voucher;
    }

    private void setNullableBigDecimal(PreparedStatement ps, int index, BigDecimal value) throws Exception {
        if (value == null) {
            ps.setNull(index, Types.DECIMAL);
            return;
        }

        ps.setBigDecimal(index, value);
    }

    private Timestamp toTimestamp(java.util.Date date) {
        if (date == null) {
            return null;
        }

        return new Timestamp(date.getTime());
    }

    private String emptyToNull(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }

        return value.trim();
    }
}
