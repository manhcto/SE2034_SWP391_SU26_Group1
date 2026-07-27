package vn.edu.fpt.DAO;

import vn.edu.fpt.common.DBConnection;
import vn.edu.fpt.model.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    // Kiểm tra email đã tồn tại trong hệ thống hay chưa.
    public boolean isEmailExist(String email) {
        String sql = """
                SELECT 1
                FROM [User]
                WHERE LTRIM(RTRIM(email)) = ?
                """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, trimValue(email));
            return hasResult(ps);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Tạo mới một tài khoản người dùng.
    public boolean registerUser(String firstName,
                                String lastName,
                                String email,
                                String password,
                                String phone,
                                String gender,
                                String dob,
                                String address,
                                int roleID) {
        String sql = """
                INSERT INTO [User] (
                    firstName, lastName, email, password, phone,
                    gender, dob, address, roleID, status, createAt
                )
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'Active', GETDATE())
                """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, firstName);
            ps.setString(2, lastName);
            ps.setString(3, trimValue(email));
            ps.setString(4, password);
            ps.setString(5, trimValue(phone));
            ps.setString(6, gender);
            setDateOrNull(ps, 7, dob);
            ps.setString(8, address);
            ps.setInt(9, roleID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Đăng nhập bằng email, mật khẩu và chỉ lấy tài khoản đang hoạt động.
    public User login(String email, String password) {
        String sql = """
                SELECT u.*, r.roleName
                FROM [User] u
                LEFT JOIN [Role] r ON u.roleID = r.roleID
                WHERE LTRIM(RTRIM(u.email)) = ?
                  AND u.[password] COLLATE Latin1_General_BIN2 = ?
                  AND u.[status] = N'Active'
                """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, trimValue(email));
            ps.setString(2, password);
            return findUser(ps);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // Lấy thông tin người dùng theo email.
    public User getUserByEmail(String email) {
        String sql = """
                SELECT u.*, r.roleName
                FROM [User] u
                LEFT JOIN [Role] r ON u.roleID = r.roleID
                WHERE LTRIM(RTRIM(u.email)) = ?
                """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, trimValue(email));
            return findUser(ps);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // Kiểm tra cặp email và số điện thoại khi quên mật khẩu.
    public boolean checkEmailAndPhone(String email, String phone) {
        String sql = """
                SELECT 1
                FROM [User]
                WHERE LTRIM(RTRIM(email)) = ?
                  AND LTRIM(RTRIM(phone)) = ?
                """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, trimValue(email));
            ps.setString(2, trimValue(phone));
            return hasResult(ps);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Cập nhật mật khẩu mới theo email.
    public boolean updatePassword(String email, String newPassword) {
        String sql = """
                UPDATE [User]
                SET password = ?, updateAt = GETDATE()
                WHERE LTRIM(RTRIM(email)) = ?
                """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newPassword);
            ps.setString(2, trimValue(email));
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Cập nhật hồ sơ cá nhân của người dùng.
    public boolean updateProfile(int userID,
                                 String firstName,
                                 String lastName,
                                 String phone,
                                 String gender,
                                 String dob,
                                 String address) {
        String sql = """
                UPDATE [User]
                SET firstName = ?, lastName = ?, phone = ?, gender = ?,
                    dob = ?, address = ?, updateAt = GETDATE()
                WHERE userID = ?
                """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, firstName);
            ps.setString(2, lastName);
            ps.setString(3, trimValue(phone));
            ps.setString(4, gender);
            setDateOrNull(ps, 5, dob);
            ps.setString(6, address);
            ps.setInt(7, userID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Đánh dấu tài khoản là không hoạt động thay vì xóa cứng.
    public boolean deleteAccount(int userID) {
        String sql = """
                UPDATE [User]
                SET status = 'Inactive', updateAt = GETDATE()
                WHERE userID = ?
                """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Đếm tổng số user theo từ khóa, vai trò và trạng thái.
    public int getTotalUsers(String keyword, String role, String status) {
        String sql = """
                SELECT COUNT(*)
                FROM [User]
                WHERE (firstName LIKE ? OR lastName LIKE ? OR email LIKE ? OR phone LIKE ?)
                  AND (? = '' OR roleID = ?)
                  AND (? = '' OR status = ?)
                """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String key = "%" + keyword + "%";
            ps.setString(1, key);
            ps.setString(2, key);
            ps.setString(3, key);
            ps.setString(4, key);
            ps.setString(5, role);
            ps.setString(6, role);
            ps.setString(7, status);
            ps.setString(8, status);
            return getCount(ps);
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    // Lấy danh sách user phân trang theo bộ lọc quản trị.
    public List<User> getUsersPaging(int page,
                                     int pageSize,
                                     String keyword,
                                     String role,
                                     String status) {
        List<User> users = new ArrayList<>();
        String sql = """
                SELECT *
                FROM [User]
                WHERE (firstName LIKE ? OR lastName LIKE ? OR email LIKE ? OR phone LIKE ?)
                  AND (? = '' OR roleID = ?)
                  AND (? = '' OR [status] = ?)
                ORDER BY userID DESC
                OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
                """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String key = "%" + keyword + "%";
            ps.setString(1, key);
            ps.setString(2, key);
            ps.setString(3, key);
            ps.setString(4, key);
            ps.setString(5, role);
            ps.setString(6, role);
            ps.setString(7, status);
            ps.setString(8, status);
            ps.setInt(9, (page - 1) * pageSize);
            ps.setInt(10, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    User user = new User();
                    user.setUserID(rs.getInt("userID"));
                    user.setFirstName(rs.getString("firstName"));
                    user.setLastName(rs.getString("lastName"));
                    user.setEmail(rs.getString("email"));
                    user.setPhone(rs.getString("phone"));
                    user.setRoleID(rs.getInt("roleID"));
                    user.setStatus(rs.getString("status"));
                    user.setCreateAt(rs.getTimestamp("createAt"));
                    users.add(user);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return users;
    }

    // Đếm số user thuộc một vai trò cụ thể.
    public int countByRole(int roleID) {
        String sql = """
                SELECT COUNT(*)
                FROM [User]
                WHERE roleID = ?
                """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roleID);
            return getCount(ps);
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    // Đếm tổng số tài khoản đang hoạt động.
    public int countActiveUsers() {
        String sql = """
                SELECT COUNT(*)
                FROM [User]
                WHERE [status] = 'Active'
                """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            return getCount(ps);
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    // Lấy thông tin user theo khóa chính userID.
    public User getUserById(int userID) {
        String sql = """
                SELECT *
                FROM [User]
                WHERE userID = ?
                """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userID);

            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }

                User user = new User();
                user.setUserID(rs.getInt("userID"));
                user.setFirstName(rs.getString("firstName"));
                user.setLastName(rs.getString("lastName"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setRoleID(rs.getInt("roleID"));
                user.setStatus(rs.getString("status"));
                return user;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // Cập nhật vai trò cho một user.
    public void updateRole(int userID, int roleID) {
        String sql = """
                UPDATE [User]
                SET roleID = ?, updateAt = GETDATE()
                WHERE userID = ?
                """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roleID);
            ps.setInt(2, userID);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Chạy query và trả về một user đầu tiên nếu có.
    private User findUser(PreparedStatement ps) throws SQLException {
        try (ResultSet rs = ps.executeQuery()) {
            return rs.next() ? mapUser(rs) : null;
        }
    }

    // Kiểm tra query có trả ra ít nhất một dòng hay không.
    private boolean hasResult(PreparedStatement ps) throws SQLException {
        try (ResultSet rs = ps.executeQuery()) {
            return rs.next();
        }
    }

    // Đọc kết quả COUNT(*) từ một câu query.
    private int getCount(PreparedStatement ps) throws SQLException {
        try (ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    // Map một dòng ResultSet thành đối tượng User đầy đủ.
    private User mapUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserID(rs.getInt("userID"));
        user.setFirstName(rs.getString("firstName"));
        user.setLastName(rs.getString("lastName"));
        user.setEmail(rs.getString("email"));
        user.setPhone(rs.getString("phone"));
        user.setGender(rs.getString("gender"));
        user.setAddress(rs.getString("address"));
        user.setRoleID(rs.getInt("roleID"));
        user.setStatus(rs.getString("status"));

        if (hasColumn(rs, "roleName")) {
            user.setRoleName(rs.getString("roleName"));
        }

        if (rs.getDate("dob") != null) {
            user.setDob(rs.getDate("dob").toString());
        }

        if (hasColumn(rs, "createAt")) {
            user.setCreateAt(rs.getTimestamp("createAt"));
        }

        return user;
    }

    // Kiểm tra cột có tồn tại trong ResultSet hay không.
    private boolean hasColumn(ResultSet rs, String columnName) {
        try {
            rs.findColumn(columnName);
            return true;
        } catch (SQLException e) {
            return false;
        }
    }

    // Gán ngày vào PreparedStatement hoặc set NULL nếu rỗng.
    private void setDateOrNull(PreparedStatement ps, int index, String value) throws SQLException {
        if (value == null || value.isEmpty()) {
            ps.setNull(index, Types.DATE);
            return;
        }

        ps.setDate(index, java.sql.Date.valueOf(value));
    }

    // Cắt khoảng trắng đầu cuối, null thì đổi thành chuỗi rỗng.
    private String trimValue(String value) {
        return value == null ? "" : value.trim();
    }
    // Khôi phục tài khoản bị xóa (chuyển trạng thái về Active)
    public boolean restoreAccount(int userID) {
        String sql = """
            UPDATE [User]
            SET status = 'Active', updateAt = GETDATE()
            WHERE userID = ?
            """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
