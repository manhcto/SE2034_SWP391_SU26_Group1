package vn.edu.fpt.DAO;

import vn.edu.fpt.model.ExternalTicket;
import vn.edu.fpt.common.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ExternalTicketDAO {

    // =======================================================================
    // 1. HÀM DÀNH CHO USER: Chỉ lấy danh sách vé có trạng thái Active
    // =======================================================================
    public List<ExternalTicket> getAllActiveTickets() {
        List<ExternalTicket> list = new ArrayList<>();
        String sql = "SELECT * FROM ExternalTicket WHERE [status] = 'Active'";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ExternalTicket ticket = new ExternalTicket();
                ticket.setServiceID(rs.getInt("serviceID"));
                ticket.setName(rs.getNString("name"));
                ticket.setImage(rs.getString("image"));
                ticket.setAddress(rs.getNString("address"));
                ticket.setPhone(rs.getString("phone"));
                ticket.setDescription(rs.getNString("description"));
                ticket.setRate(rs.getDouble("rate"));
                ticket.setReviewCount(rs.getInt("reviewCount"));
                ticket.setType(rs.getString("type"));
                ticket.setStatus(rs.getString("status"));
                ticket.setTimeOpen(rs.getTime("timeOpen"));
                ticket.setTimeClose(rs.getTime("timeClose"));
                ticket.setDayOfWeekOpen(rs.getNString("dayOfWeekOpen"));
                ticket.setTicketPrice(rs.getDouble("ticketPrice"));

                list.add(ticket);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // =======================================================================
    // 2. HÀM DÀNH CHO STAFF: Lấy TOÀN BỘ vé (cả Active và Inactive, mới nhất lên đầu)
    // =======================================================================
    public List<ExternalTicket> getAllTicketsForStaff() {
        List<ExternalTicket> list = new ArrayList<>();
        String sql = "SELECT * FROM ExternalTicket ORDER BY serviceID DESC";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ExternalTicket ticket = new ExternalTicket();
                ticket.setServiceID(rs.getInt("serviceID"));
                ticket.setName(rs.getNString("name"));
                ticket.setImage(rs.getString("image"));
                ticket.setAddress(rs.getNString("address"));
                ticket.setPhone(rs.getString("phone"));
                ticket.setDescription(rs.getNString("description"));
                ticket.setRate(rs.getDouble("rate"));
                ticket.setReviewCount(rs.getInt("reviewCount"));
                ticket.setType(rs.getString("type"));
                ticket.setStatus(rs.getString("status"));
                ticket.setTimeOpen(rs.getTime("timeOpen"));
                ticket.setTimeClose(rs.getTime("timeClose"));
                ticket.setDayOfWeekOpen(rs.getNString("dayOfWeekOpen"));
                ticket.setTicketPrice(rs.getDouble("ticketPrice"));

                list.add(ticket);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // =======================================================================
    // 3. HÀM THÊM MỚI VÉ: Thêm vào bảng Service (cha) -> Lấy ID -> Thêm vào ExternalTicket (con)
    // =======================================================================
    public boolean insertExternalTicket(ExternalTicket ticket) {
        String sqlService = "INSERT INTO [Service] (serviceCategoryID, serviceName, status, serviceType, createAt) VALUES (?, ?, ?, ?, GETDATE())";
        String sqlTicket = "INSERT INTO ExternalTicket (serviceID, name, image, address, phone, description, rate, reviewCount, type, status, timeOpen, timeClose, dayOfWeekOpen, ticketPrice) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        Connection conn = null;
        PreparedStatement psService = null;
        PreparedStatement psTicket = null;
        ResultSet rs = null;

        try {
            conn = new DBConnection().getConnection();
            // Bật chế độ Transaction (Phải thành công cả 2 bảng mới được lưu)
            conn.setAutoCommit(false);

            // 1. Thêm vào bảng Service (Giả sử serviceCategoryID = 1 là Tham quan & Giải trí)
            // Statement.RETURN_GENERATED_KEYS để lấy ID vừa tự động sinh ra
            psService = conn.prepareStatement(sqlService, PreparedStatement.RETURN_GENERATED_KEYS);
            psService.setInt(1, 1);
            psService.setNString(2, ticket.getName());
            psService.setString(3, ticket.getStatus());
            psService.setString(4, "ExternalTicket");
            psService.executeUpdate();

            // Lấy ID của bảng Service vừa thêm
            rs = psService.getGeneratedKeys();
            int newServiceID = 0;
            if (rs.next()) {
                newServiceID = rs.getInt(1);
            }

            // 2. Thêm vào bảng ExternalTicket với ID vừa lấy được
            psTicket = conn.prepareStatement(sqlTicket);
            psTicket.setInt(1, newServiceID);
            psTicket.setNString(2, ticket.getName());
            psTicket.setString(3, ticket.getImage());
            psTicket.setNString(4, ticket.getAddress());
            psTicket.setString(5, ticket.getPhone());
            psTicket.setNString(6, ticket.getDescription());
            psTicket.setDouble(7, ticket.getRate());
            psTicket.setInt(8, ticket.getReviewCount());
            psTicket.setString(9, ticket.getType());
            psTicket.setString(10, ticket.getStatus());
            psTicket.setTime(11, ticket.getTimeOpen());
            psTicket.setTime(12, ticket.getTimeClose());
            psTicket.setNString(13, ticket.getDayOfWeekOpen());
            psTicket.setDouble(14, ticket.getTicketPrice());

            psTicket.executeUpdate();

            // Lưu toàn bộ xuống Database
            conn.commit();
            return true;

        } catch (Exception e) {
            try {
                if (conn != null) conn.rollback(); // Nếu có lỗi ở bất kỳ đâu -> Hủy bỏ toàn bộ, không lưu rác
            } catch (Exception ex) { ex.printStackTrace(); }
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (psTicket != null) psTicket.close();
                if (psService != null) psService.close();
                if (conn != null) conn.close();
            } catch (Exception e) { e.printStackTrace(); }
        }
        return false;
    }

    // =======================================================================
    // 4. LẤY THÔNG TIN 1 VÉ (Phục vụ cho màn Edit đổ dữ liệu lên Form)
    // =======================================================================
    public ExternalTicket getExternalTicketById(int serviceID) {
        String sql = "SELECT * FROM ExternalTicket WHERE serviceID = ?";
        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, serviceID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ExternalTicket ticket = new ExternalTicket();
                    ticket.setServiceID(rs.getInt("serviceID"));
                    ticket.setName(rs.getNString("name"));
                    ticket.setImage(rs.getString("image"));
                    ticket.setAddress(rs.getNString("address"));
                    ticket.setPhone(rs.getString("phone"));
                    ticket.setDescription(rs.getNString("description"));
                    ticket.setRate(rs.getDouble("rate"));
                    ticket.setReviewCount(rs.getInt("reviewCount"));
                    ticket.setType(rs.getString("type"));
                    ticket.setStatus(rs.getString("status"));
                    ticket.setTimeOpen(rs.getTime("timeOpen"));
                    ticket.setTimeClose(rs.getTime("timeClose"));
                    ticket.setDayOfWeekOpen(rs.getNString("dayOfWeekOpen"));
                    ticket.setTicketPrice(rs.getDouble("ticketPrice"));
                    return ticket;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // =======================================================================
    // 5. CẬP NHẬT VÉ (Update vào cả bảng cha Service và bảng con ExternalTicket)
    // =======================================================================
    public boolean updateExternalTicket(ExternalTicket ticket) {
        String sqlService = "UPDATE [Service] SET serviceName = ?, status = ?, updateAt = GETDATE() WHERE serviceID = ?";
        String sqlTicket = "UPDATE ExternalTicket SET name = ?, image = ?, address = ?, phone = ?, description = ?, type = ?, status = ?, timeOpen = ?, timeClose = ?, dayOfWeekOpen = ?, ticketPrice = ? WHERE serviceID = ?";

        Connection conn = null;
        PreparedStatement psService = null;
        PreparedStatement psTicket = null;

        try {
            conn = new DBConnection().getConnection();
            conn.setAutoCommit(false); // Bật Transaction

            // 1. Cập nhật bảng cha Service
            psService = conn.prepareStatement(sqlService);
            psService.setNString(1, ticket.getName());
            psService.setString(2, ticket.getStatus());
            psService.setInt(3, ticket.getServiceID());
            psService.executeUpdate();

            // 2. Cập nhật bảng con ExternalTicket
            psTicket = conn.prepareStatement(sqlTicket);
            psTicket.setNString(1, ticket.getName());
            psTicket.setString(2, ticket.getImage());
            psTicket.setNString(3, ticket.getAddress());
            psTicket.setString(4, ticket.getPhone());
            psTicket.setNString(5, ticket.getDescription());
            psTicket.setString(6, ticket.getType());
            psTicket.setString(7, ticket.getStatus());
            psTicket.setTime(8, ticket.getTimeOpen());
            psTicket.setTime(9, ticket.getTimeClose());
            psTicket.setNString(10, ticket.getDayOfWeekOpen());
            psTicket.setDouble(11, ticket.getTicketPrice());
            psTicket.setInt(12, ticket.getServiceID());
            psTicket.executeUpdate();

            conn.commit();
            return true;

        } catch (Exception e) {
            try { if (conn != null) conn.rollback(); } catch (Exception ex) { ex.printStackTrace(); }
            e.printStackTrace();
        } finally {
            try {
                if (psTicket != null) psTicket.close();
                if (psService != null) psService.close();
                if (conn != null) conn.close();
            } catch (Exception e) { e.printStackTrace(); }
        }
        return false;
    }

    // =======================================================================
    // 6. XÓA VÉ (Hard Delete - Transaction: Xóa con trước, xóa cha sau)
    // =======================================================================
    public boolean deleteExternalTicket(int serviceID) {
        String sqlTicket = "DELETE FROM ExternalTicket WHERE serviceID = ?";
        String sqlService = "DELETE FROM [Service] WHERE serviceID = ?";
        Connection conn = null;
        try {
            conn = new DBConnection().getConnection();
            conn.setAutoCommit(false); // Bật Transaction

            // 1. Xóa bảng con
            try (PreparedStatement psTicket = conn.prepareStatement(sqlTicket)) {
                psTicket.setInt(1, serviceID);
                psTicket.executeUpdate();
            }
            // 2. Xóa bảng cha
            try (PreparedStatement psService = conn.prepareStatement(sqlService)) {
                psService.setInt(1, serviceID);
                psService.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (Exception e) {
            try { if (conn != null) conn.rollback(); } catch (Exception ex) {}
            e.printStackTrace();
        } finally {
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
        return false;
    }

    // =======================================================================
    // 7. CẬP NHẬT TRẠNG THÁI NHANH (Đã bọc [status] để chống lỗi SQL)
    // =======================================================================
    public boolean updateTicketStatus(int serviceID, String status) {
        String sqlService = "UPDATE [Service] SET [status] = ? WHERE serviceID = ?";
        String sqlTicket = "UPDATE ExternalTicket SET [status] = ? WHERE serviceID = ?";
        Connection conn = null;
        try {
            conn = new DBConnection().getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement psService = conn.prepareStatement(sqlService)) {
                psService.setString(1, status);
                psService.setInt(2, serviceID);
                psService.executeUpdate();
            }
            try (PreparedStatement psTicket = conn.prepareStatement(sqlTicket)) {
                psTicket.setString(1, status);
                psTicket.setInt(2, serviceID);
                psTicket.executeUpdate();
            }
            conn.commit();
            return true;
        } catch (Exception e) {
            try { if (conn != null) conn.rollback(); } catch (Exception ex) {}
            e.printStackTrace();
        } finally {
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
        return false;
    }

    // 1. Hàm lấy danh sách vé cho Khách Hàng (Có Search & Phân trang)
    public List<ExternalTicket> getTicketsForCustomer(String searchKeyword, int pageIndex) {
        List<ExternalTicket> list = new ArrayList<>();
        // Mỗi trang hiển thị 9 sản phẩm
        int pageSize = 9;

        String sql = "SELECT * FROM ExternalTicket " +
                "WHERE [status] = 'Active' AND name LIKE ? " +
                "ORDER BY serviceID DESC " +
                "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // Dấu ? số 1: Từ khóa tìm kiếm
            ps.setNString(1, "%" + searchKeyword + "%");
            // Dấu ? số 2: Bỏ qua bao nhiêu dòng (Công thức: (Trang hiện tại - 1) * Số SP mỗi trang)
            ps.setInt(2, (pageIndex - 1) * pageSize);
            // Dấu ? số 3: Lấy bao nhiêu dòng
            ps.setInt(3, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ExternalTicket ticket = new ExternalTicket();
                    ticket.setServiceID(rs.getInt("serviceID"));
                    ticket.setName(rs.getNString("name"));
                    ticket.setImage(rs.getString("image"));
                    ticket.setAddress(rs.getNString("address"));
                    ticket.setRate(rs.getDouble("rate"));
                    ticket.setReviewCount(rs.getInt("reviewCount"));
                    ticket.setType(rs.getString("type"));
                    ticket.setTicketPrice(rs.getDouble("ticketPrice"));
                    ticket.setStatus(rs.getString("status"));
                    list.add(ticket);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Hàm đếm TỔNG SỐ LƯỢNG vé tìm được (Để tính ra số trang)
    public int countTotalTicketsForCustomer(String searchKeyword) {
        String sql = "SELECT COUNT(*) FROM ExternalTicket WHERE [status] = 'Active' AND name LIKE ?";
        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setNString(1, "%" + searchKeyword + "%");
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}