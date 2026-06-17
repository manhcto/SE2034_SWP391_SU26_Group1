package vn.edu.fpt.DAO;

import vn.edu.fpt.common.DBConnection;
import vn.edu.fpt.model.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    // Check email tồn tại
    public boolean isEmailExist(String email) {

        String sql = """
        SELECT 1
        FROM [User]
        WHERE email = ?
          AND status = 'Active'
        """;

        try {
            DBConnection db = new DBConnection();
            Connection conn = db.getConnection();

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);

            ResultSet rs = ps.executeQuery();

            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // Đăng ký user mới
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
        INSERT INTO [User]
        (
            firstName,
            lastName,
            email,
            password,
            phone,
            gender,
            dob,
            address,
            roleID,
            status
        )
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'Active')
        """;

        try {

            DBConnection db = new DBConnection();
            Connection conn = db.getConnection();

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, firstName);
            ps.setString(2, lastName);
            ps.setString(3, email);
            ps.setString(4, password);
            ps.setString(5, phone);
            ps.setString(6, gender);

            if (dob == null || dob.isEmpty()) {
                ps.setNull(7, java.sql.Types.DATE);
            } else {
                ps.setDate(7, java.sql.Date.valueOf(dob));
            }

            ps.setString(8, address);
            ps.setInt(9, roleID);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // Login
    public User login(String email, String password) {

        String sql = """
        SELECT *
        FROM [User]
        WHERE email = ?
        AND password = ?
        AND status = 'Active'
        """;

        try {

            DBConnection db = new DBConnection();
            Connection conn = db.getConnection();

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                User user = new User();

                user.setUserID(rs.getInt("userID"));
                user.setFirstName(rs.getString("firstName"));
                user.setLastName(rs.getString("lastName"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setGender(rs.getString("gender"));

                if (rs.getDate("dob") != null) {
                    user.setDob(rs.getDate("dob").toString());
                }

                user.setAddress(rs.getString("address"));
                user.setRoleID(rs.getInt("roleID"));
                user.setStatus(rs.getString("status"));

                return user;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // Lấy user theo email
    public User getUserByEmail(String email) {

        String sql = """
        SELECT *
        FROM [User]
        WHERE email = ?
        """;

        try {

            DBConnection db = new DBConnection();
            Connection conn = db.getConnection();

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                User user = new User();

                user.setUserID(rs.getInt("userID"));
                user.setFirstName(rs.getString("firstName"));
                user.setLastName(rs.getString("lastName"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setGender(rs.getString("gender"));

                if (rs.getDate("dob") != null) {
                    user.setDob(rs.getDate("dob").toString());
                }

                user.setAddress(rs.getString("address"));
                user.setRoleID(rs.getInt("roleID"));
                user.setStatus(rs.getString("status"));

                return user;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // Kiểm tra email + phone cho forgot password
    public boolean checkEmailAndPhone(String email, String phone) {

        String sql = """
        SELECT 1
        FROM [User]
        WHERE email = ?
        AND phone = ?
        """;

        try {

            DBConnection db = new DBConnection();
            Connection conn = db.getConnection();

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, email);
            ps.setString(2, phone);

            ResultSet rs = ps.executeQuery();

            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // Update password
    public boolean updatePassword(String email, String newPassword) {

        String sql = """
        UPDATE [User]
        SET password = ?,
            updateAt = GETDATE()
        WHERE email = ?
        """;

        try {

            DBConnection db = new DBConnection();
            Connection conn = db.getConnection();

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, newPassword);
            ps.setString(2, email);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // Update Profile
    public boolean updateProfile(
            int userID,
            String firstName,
            String lastName,
            String phone,
            String gender,
            String dob,
            String address) {

        String sql = """
        UPDATE [User]
        SET firstName = ?,
            lastName = ?,
            phone = ?,
            gender = ?,
            dob = ?,
            address = ?,
            updateAt = GETDATE()
        WHERE userID = ?
        """;

        try {

            DBConnection db = new DBConnection();
            Connection conn = db.getConnection();

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, firstName);
            ps.setString(2, lastName);
            ps.setString(3, phone);
            ps.setString(4, gender);

            if (dob == null || dob.isEmpty()) {
                ps.setNull(5, java.sql.Types.DATE);
            } else {
                ps.setDate(5, java.sql.Date.valueOf(dob));
            }

            ps.setString(6, address);
            ps.setInt(7, userID);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }


    public boolean deleteAccount(int userID) {

        String sql = """
    UPDATE [User]
    SET email = email + '_deleted_' + CAST(userID AS VARCHAR(20)),
        status = 'Inactive',
        updateAt = GETDATE()
    WHERE userID = ?
    """;

        try {

            DBConnection db = new DBConnection();
            Connection conn = db.getConnection();

            PreparedStatement ps =
                    conn.prepareStatement(sql);

            ps.setInt(1, userID);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;


    }
    public int getTotalUsers(String keyword,
                             String role,
                             String status) {

        String sql = """
        SELECT COUNT(*)
        FROM [User]
        WHERE
        (
            firstName LIKE ?
            OR lastName LIKE ?
            OR email LIKE ?
            OR phone LIKE ?
        )
        AND (? = '' OR roleID = ?)
        AND (? = '' OR status = ?)
        """;

        try (
                Connection conn = new DBConnection().getConnection();
        PreparedStatement ps = conn.prepareStatement(sql);
        ) {

            String key = "%" + keyword + "%";

            ps.setString(1, key);
            ps.setString(2, key);
            ps.setString(3, key);
            ps.setString(4, key);

            ps.setString(5, role);
            ps.setString(6, role);

            ps.setString(7, status);
            ps.setString(8, status);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    public List<User> getUsersPaging(
            int page,
            int pageSize,
            String keyword,
            String role,
            String status) {

        List<User> list = new ArrayList<>();

        String sql = """
        SELECT *
        FROM [User]
        WHERE
        (
            firstName LIKE ?
            OR lastName LIKE ?
            OR email LIKE ?
            OR phone LIKE ?
        )
        AND (? = '' OR roleID = ?)
        AND (? = '' OR [status] = ?)

        ORDER BY userID DESC

        OFFSET ? ROWS
        FETCH NEXT ? ROWS ONLY
        """;

        try (
                Connection conn = new DBConnection().getConnection();
        PreparedStatement ps = conn.prepareStatement(sql);
        ) {

            String key = "%" + keyword + "%";

            ps.setString(1, key);
            ps.setString(2, key);
            ps.setString(3, key);
            ps.setString(4, key);

            ps.setString(5, role);
            ps.setString(6, role);

            ps.setString(7, status);
            ps.setString(8, status);

            ps.setInt(9,
                    (page - 1) * pageSize);

            ps.setInt(10,
                    pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {

                User u = new User();

                u.setUserID(rs.getInt("userID"));
                u.setFirstName(rs.getString("firstName"));
                u.setLastName(rs.getString("lastName"));
                u.setEmail(rs.getString("email"));
                u.setPhone(rs.getString("phone"));
                u.setRoleID(rs.getInt("roleID"));
                u.setStatus(rs.getString("status"));

                u.setCreateAt(rs.getTimestamp("createAt"));

                u.setUpdateAt( rs.getTimestamp("updateAt"));

                list.add(u);

            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int countByRole(int roleID) {

        String sql = """
        SELECT COUNT(*)
        FROM [User]
        WHERE roleID = ?
        """;

        try (
                Connection conn = new DBConnection().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setInt(1, roleID);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }
    public int countBlockedUsers() {

        String sql = """
        SELECT COUNT(*)
        FROM [User]
        WHERE status='Blocked'
        """;

        try (
                Connection conn = new DBConnection().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }
    public User getUserById(int userID) {

        String sql = """
        SELECT *
        FROM [User]
        WHERE userID=?
        """;

        try (
                Connection conn = new DBConnection().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setInt(1, userID);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                User u = new User();

                u.setUserID(rs.getInt("userID"));
                u.setFirstName(rs.getString("firstName"));
                u.setLastName(rs.getString("lastName"));
                u.setEmail(rs.getString("email"));
                u.setPhone(rs.getString("phone"));
                u.setRoleID(rs.getInt("roleID"));
                u.setStatus(rs.getString("status"));

                return u;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
    public void updateRoleAndStatus(
            int userID,
            int roleID,
            String status) {

        String sql = """
        UPDATE [User]
        SET roleID=?,
            status=?,
            updateAt=GETDATE()
        WHERE userID=?
        """;

        try (
                Connection conn = new DBConnection().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setInt(1, roleID);
            ps.setString(2, status);
            ps.setInt(3, userID);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}




