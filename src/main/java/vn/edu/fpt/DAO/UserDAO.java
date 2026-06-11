package vn.edu.fpt.DAO;

import vn.edu.fpt.common.DBConnection;
import vn.edu.fpt.model.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {

    // check email tồn tại
    public boolean isEmailExist(String email) {
        String sql = "SELECT 1 FROM [User] WHERE email = ?";

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

    // register user
    public boolean registerUser(String firstName, String lastName,
                                String email, String password,
                                String phone, String gender,
                                String dob, String address,
                                int roleID) {

        String sql = """
            INSERT INTO [User]
            (firstName, lastName, email, password, phone, gender, dob, address, roleID)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
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
    public User login(String email, String password) {

        String sql = "SELECT userID, firstName, lastName, email, roleID " +
                "FROM [User] WHERE email = ? AND password = ?";

        try {
            DBConnection db = new DBConnection();
            Connection conn = db.getConnection();

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new User(
                        rs.getInt("userID"),
                        rs.getString("firstName"),
                        rs.getString("lastName"),
                        rs.getString("email"),
                        rs.getInt("roleID")
                );
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean checkEmailAndPhone(String email, String phone) {

        String sql = "SELECT 1 FROM [User] WHERE email = ? AND phone = ?";

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
    public User getUserByEmail(String email) {

        String sql = """
            SELECT userID,
                   firstName,
                   lastName,
                   email,
                   roleID
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

                return new User(
                        rs.getInt("userID"),
                        rs.getString("firstName"),
                        rs.getString("lastName"),
                        rs.getString("email"),
                        rs.getInt("roleID")
                );
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
    public boolean updateProfile(
            int userID,
            String firstName,
            String lastName,
            String gender) {

        String sql =
                "UPDATE [User] " +
                        "SET firstName = ?, " +
                        "lastName = ?, " +
                        "gender = ?, " +
                        "updateAt = GETDATE() " +
                        "WHERE userID = ?";

        try {

            DBConnection db = new DBConnection();
            Connection conn = db.getConnection();

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, firstName);
            ps.setString(2, lastName);
            ps.setString(3, gender);
            ps.setInt(4, userID);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {

            e.printStackTrace();

        }

        return false;
    }
}