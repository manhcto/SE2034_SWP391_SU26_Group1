package vn.edu.fpt.DAO;
import vn.edu.fpt.model.Voucher;
import vn.edu.fpt.common.DBConnection; // Import class kết nối DB của nhóm
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VoucherDAO {

    // 1. READ: Lấy danh sách toàn bộ Voucher
    public List<Voucher> getAllVouchers() {
        List<Voucher> list = new ArrayList<>();
        String sql = "SELECT voucherID, voucherCode, voucherName, percentDiscount, startDate, endDate, quantity, status, applyFor, image, description FROM Voucher";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Voucher v = new Voucher();
                v.setVoucherId(rs.getInt("voucherId"));
                v.setVoucherCode(rs.getString("voucherCode"));
                v.setVoucherName(rs.getString("voucherName"));
                v.setPercentDiscount(rs.getDouble("percentDiscount"));
                v.setStartDate(rs.getDate("startDate"));
                v.setEndDate(rs.getDate("endDate"));
                v.setQuantity(rs.getInt("quantity"));
                v.setStatus(rs.getString("status"));
                v.setApplyFor(rs.getString("applyFor"));
                v.setImage(rs.getString("image"));
                v.setDescription(rs.getString("description"));
                list.add(v);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // 2. CREATE: Thêm mới Voucher
    public boolean insertVoucher(Voucher v) {
        String sql = "INSERT INTO Voucher (voucherCode, voucherName, percentDiscount, startDate, endDate, quantity, status, applyFor, image, description) VALUES (?, ?, ?, ?, ?, ?, 'Active', ?)";
        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, v.getVoucherCode());
            ps.setString(2, v.getVoucherName());
            ps.setDouble(3, v.getPercentDiscount());
            ps.setDate(4, v.getStartDate());
            ps.setDate(5, v.getEndDate());
            ps.setInt(6, v.getQuantity());
            ps.setString(7, v.getApplyFor());
            ps.setString(8, "Active");// Mặc định khi tạo mới là Active
            ps.setString(9, v.getImage());
            ps.setString(10, v.getDescription());

            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // 3. UPDATE: Cập nhật thông tin Voucher
    public boolean updateVoucher(Voucher v) {
        String sql = "UPDATE Voucher SET voucherName=?, percentDiscount=?, startDate=?, endDate=?, quantity=?, status=?, applyFor=?, image=?, description=? WHERE voucherID=?";
        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, v.getVoucherName());
            ps.setDouble(2, v.getPercentDiscount());
            ps.setDate(3, v.getStartDate());
            ps.setDate(4, v.getEndDate());
            ps.setInt(5, v.getQuantity());
            ps.setString(6, v.getStatus());
            ps.setString(7, v.getApplyFor());
            ps.setString(8, v.getImage());
            ps.setString(9, v.getDescription());
            ps.setInt(10, v.getVoucherId());

            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // 4. DELETE: Xóa mềm (Soft Delete) - Chuyển status thành 'Inactive'
    public boolean deleteVoucher(int voucherId) {
        String sql = "UPDATE Voucher SET status = 'Inactive' WHERE voucherId = ?";
        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, voucherId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }
}
