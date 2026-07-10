package vn.edu.fpt.DAO;

import vn.edu.fpt.common.DBConnection;
import vn.edu.fpt.model.Voucher;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class VoucherDAO {

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
}
