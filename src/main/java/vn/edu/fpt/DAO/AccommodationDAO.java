package vn.edu.fpt.DAO;

import vn.edu.fpt.model.Accommodation;
import vn.edu.fpt.common.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class AccommodationDAO {
    // 1. Xem danh sách tất cả nơi lưu trú (Dành cho Guest/Customer và Staff)
    public List<Accommodation> getAllAccommodations() {
        List<Accommodation> list = new ArrayList<>();
        String sql = "SELECT [serviceID], [name], [image], [address], [phone], [description], [rate], [type], [status], [checkInTime], [checkOutTime] FROM [dbo].[Accommodation]";

        // Sử dụng lớp DBConnection từ thư mục common để mở kết nối
        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Accommodation acc = new Accommodation();
                acc.setServiceID(rs.getInt("serviceID"));
                acc.setName(rs.getString("name"));
                acc.setImage(rs.getString("image"));
                acc.setAddress(rs.getString("address"));
                acc.setPhone(rs.getString("phone"));
                acc.setDescription(rs.getString("description"));
                acc.setRate(rs.getDouble("rate"));
                acc.setType(rs.getString("type"));
                acc.setStatus(rs.getString("status"));
                acc.setCheckInTime(rs.getString("checkInTime"));
                acc.setCheckOutTime(rs.getString("checkOutTime"));
                list.add(acc);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Xem chi tiết thông tin một nơi lưu trú (ViewAccommodation)
    public Accommodation getAccommodationById(int id) {
        String sql = "SELECT * FROM [dbo].[Accommodation] WHERE [serviceID] = ?";
        try (Connection conn = new DBConnection().getConnection(); //
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Accommodation acc = new Accommodation();
                    acc.setServiceID(rs.getInt("serviceID"));
                    acc.setName(rs.getString("name"));
                    acc.setImage(rs.getString("image"));
                    acc.setAddress(rs.getString("address"));
                    acc.setPhone(rs.getString("phone"));
                    acc.setDescription(rs.getString("description"));
                    acc.setRate(rs.getDouble("rate"));
                    acc.setType(rs.getString("type"));
                    acc.setStatus(rs.getString("status"));
                    acc.setCheckInTime(rs.getString("checkInTime"));
                    acc.setCheckOutTime(rs.getString("checkOutTime"));
                    return acc;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 3. Thêm mới nơi lưu trú (Manage Accommodation - Quyền Staff)
    public boolean insertAccommodation(Accommodation acc) {
        String sql = "INSERT INTO [dbo].[Accommodation] ([serviceID], [name], [image], [address], [phone], [description], [rate], [type], [status], [checkInTime], [checkOutTime]) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = new DBConnection().getConnection(); //
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, acc.getServiceID());
            ps.setString(2, acc.getName());
            ps.setString(3, acc.getImage());
            ps.setString(4, acc.getAddress());
            ps.setString(5, acc.getPhone());
            ps.setString(6, acc.getDescription());
            ps.setDouble(7, acc.getRate());
            ps.setString(8, acc.getType());
            ps.setString(9, acc.getStatus());
            ps.setString(10, acc.getCheckInTime());
            ps.setString(11, acc.getCheckOutTime());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 4. Cập nhật thông tin nơi lưu trú (Manage Accommodation)
    public boolean updateAccommodation(Accommodation acc) {
        String sql = "UPDATE [dbo].[Accommodation] SET [name] = ?, [image] = ?, [address] = ?, [phone] = ?, [description] = ?, [rate] = ?, [type] = ?, [status] = ?, [checkInTime] = ?, [checkOutTime] = ? WHERE [serviceID] = ?";
        try (Connection conn = new DBConnection().getConnection(); //
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, acc.getName());
            ps.setString(2, acc.getImage());
            ps.setString(3, acc.getAddress());
            ps.setString(4, acc.getPhone());
            ps.setString(5, acc.getDescription());
            ps.setDouble(6, acc.getRate());
            ps.setString(7, acc.getType());
            ps.setString(8, acc.getStatus());
            ps.setString(9, acc.getCheckInTime());
            ps.setString(10, acc.getCheckOutTime());
            ps.setInt(11, acc.getServiceID());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 5. Xóa nơi lưu trú (Manage Accommodation)
    public boolean deleteAccommodation(int id) {
        String sql = "DELETE FROM [dbo].[Accommodation] WHERE [serviceID] = ?";
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
