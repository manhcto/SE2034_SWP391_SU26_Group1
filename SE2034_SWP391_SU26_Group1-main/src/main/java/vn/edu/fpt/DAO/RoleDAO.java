package vn.edu.fpt.DAO;

import java.sql.*;
import java.util.*;

import vn.edu.fpt.common.DBConnection;
import vn.edu.fpt.model.Role;

public class RoleDAO extends DBConnection {

    public List<Role> getAllRoles() {

        List<Role> list = new ArrayList<>();

        String sql = "SELECT * FROM [Role]";

        try (
                Connection conn = new DBConnection().getConnection();
        PreparedStatement ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery()
        ) {

            while (rs.next()) {

                list.add(
                        new Role(
                                rs.getInt("roleID"),
                                rs.getString("roleName")
                        )
                );
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}