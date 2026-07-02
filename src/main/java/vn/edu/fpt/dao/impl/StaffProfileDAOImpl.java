package vn.edu.fpt.dao.impl;

import vn.edu.fpt.dao.StaffProfileDAO;
import vn.edu.fpt.model.StaffProfileDTO;
import vn.edu.fpt.model.StaffProfileUpdateRequest;
import vn.edu.fpt.utils.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class StaffProfileDAOImpl implements StaffProfileDAO {
    private static final String SELECT_PROFILE = """
        SELECT s.staffID, s.userID, s.staffCode, s.staffType, s.position, s.workRegion,
               s.hireDate, s.licenseNumber, s.licenseClass, s.guideLicenseNo, s.languages, s.workStatus,
               u.firstName, u.lastName, u.email, u.phone, u.gender, u.status AS userStatus,
               u.createdAt, u.updatedAt
        FROM dbo.Staff s
        JOIN dbo.[User] u ON s.userID = u.userID
        """;

    @Override
    public StaffProfileDTO findByUserID(Integer userID) throws Exception {
        if (userID == null || userID <= 0) {
            return null;
        }
        String sql = SELECT_PROFILE + " WHERE s.userID = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userID);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapProfile(rs) : null;
            }
        }
    }

    @Override
    public StaffProfileDTO findDefaultWorkingStaff() throws Exception {
        String sql = SELECT_PROFILE + """
            WHERE s.workStatus = N'Working'
              AND u.status = N'Active'
            ORDER BY CASE WHEN s.staffType = N'OperationStaff' THEN 0 ELSE 1 END, s.staffID
            """;
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? mapProfile(rs) : null;
        }
    }

    @Override
    public void updateProfile(StaffProfileUpdateRequest request) throws Exception {
        String updateUser = """
            UPDATE dbo.[User]
            SET firstName = ?,
                lastName = ?,
                phone = ?,
                gender = ?,
                updatedAt = GETDATE()
            WHERE userID = ?
            """;

        String updateStaff = """
            UPDATE dbo.Staff
            SET position = ?,
                workRegion = ?,
                licenseNumber = ?,
                licenseClass = ?,
                guideLicenseNo = ?,
                languages = ?
            WHERE staffID = ?
              AND userID = ?
            """;

        try (Connection conn = DBContext.getConnection()) {
            boolean oldAutoCommit = conn.getAutoCommit();
            conn.setAutoCommit(false);
            try {
                try (PreparedStatement ps = conn.prepareStatement(updateUser)) {
                    ps.setString(1, request.getFirstName());
                    ps.setString(2, request.getLastName());
                    ps.setString(3, request.getPhone());
                    ps.setString(4, request.getGender());
                    ps.setInt(5, request.getUserID());
                    ps.executeUpdate();
                }

                try (PreparedStatement ps = conn.prepareStatement(updateStaff)) {
                    ps.setString(1, request.getPosition());
                    ps.setString(2, request.getWorkRegion());
                    ps.setString(3, request.getLicenseNumber());
                    ps.setString(4, request.getLicenseClass());
                    ps.setString(5, request.getGuideLicenseNo());
                    ps.setString(6, request.getLanguages());
                    ps.setInt(7, request.getStaffID());
                    ps.setInt(8, request.getUserID());
                    ps.executeUpdate();
                }

                conn.commit();
            } catch (Exception ex) {
                conn.rollback();
                throw ex;
            } finally {
                conn.setAutoCommit(oldAutoCommit);
            }
        }
    }

    private StaffProfileDTO mapProfile(ResultSet rs) throws Exception {
        StaffProfileDTO dto = new StaffProfileDTO();
        dto.setStaffID(rs.getInt("staffID"));
        dto.setUserID(rs.getInt("userID"));
        dto.setStaffCode(rs.getString("staffCode"));
        dto.setStaffType(rs.getString("staffType"));
        dto.setPosition(rs.getString("position"));
        dto.setWorkRegion(rs.getString("workRegion"));
        dto.setHireDate(rs.getDate("hireDate"));
        dto.setLicenseNumber(rs.getString("licenseNumber"));
        dto.setLicenseClass(rs.getString("licenseClass"));
        dto.setGuideLicenseNo(rs.getString("guideLicenseNo"));
        dto.setLanguages(rs.getString("languages"));
        dto.setWorkStatus(rs.getString("workStatus"));
        dto.setFirstName(rs.getString("firstName"));
        dto.setLastName(rs.getString("lastName"));
        dto.setEmail(rs.getString("email"));
        dto.setPhone(rs.getString("phone"));
        dto.setGender(rs.getString("gender"));
        dto.setUserStatus(rs.getString("userStatus"));
        dto.setCreatedAt(rs.getTimestamp("createdAt"));
        dto.setUpdatedAt(rs.getTimestamp("updatedAt"));
        return dto;
    }
}
