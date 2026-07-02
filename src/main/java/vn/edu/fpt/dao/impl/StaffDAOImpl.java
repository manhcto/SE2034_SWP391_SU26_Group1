package vn.edu.fpt.dao.impl;

import vn.edu.fpt.dao.StaffDAO;
import vn.edu.fpt.model.StaffOption;
import vn.edu.fpt.utils.DBContext;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class StaffDAOImpl implements StaffDAO {

    @Override
    public List<StaffOption> getActiveGuides() throws SQLException {
        return getActiveStaffByTypes("N'Guide', N'Staff', N'Coordinator'");
    }

    @Override
    public List<StaffOption> getActiveDrivers() throws SQLException {
        return getActiveStaffByTypes("N'Driver'");
    }

    private List<StaffOption> getActiveStaffByTypes(String typeSql) throws SQLException {
        List<StaffOption> list = new ArrayList<>();

        String sql = "SELECT s.staffID, s.staffCode, s.staffType, "
                + "       LTRIM(RTRIM(u.firstName + N' ' + u.lastName)) AS fullName, "
                + "       u.phone "
                + "FROM dbo.Staff s "
                + "JOIN dbo.[User] u ON s.userID = u.userID "
                + "WHERE s.workStatus = N'Working' "
                + "  AND u.status = N'Active' "
                + "  AND s.staffType IN (" + typeSql + ") "
                + "ORDER BY s.staffCode";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                StaffOption item = new StaffOption();
                item.setStaffID(rs.getInt("staffID"));
                item.setStaffCode(rs.getString("staffCode"));
                item.setFullName(rs.getString("fullName"));
                item.setPhone(rs.getString("phone"));
                item.setStaffType(rs.getString("staffType"));
                list.add(item);
            }
        }

        return list;
    }

    @Override
    public boolean isGuideAvailable(int staffID, LocalDate departureDate, LocalDate returnDate, Integer excludeScheduleID)
            throws SQLException {
        return isStaffAvailable(staffID, departureDate, returnDate, excludeScheduleID, "Guide");
    }

    @Override
    public boolean isDriverAvailable(int staffID, LocalDate departureDate, LocalDate returnDate, Integer excludeScheduleID)
            throws SQLException {
        return isStaffAvailable(staffID, departureDate, returnDate, excludeScheduleID, "Driver");
    }

    private boolean isStaffAvailable(int staffID,
                                     LocalDate departureDate,
                                     LocalDate returnDate,
                                     Integer excludeScheduleID,
                                     String roleInTour) throws SQLException {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) ");
        sql.append("FROM dbo.Tour_Assignment ta ");
        sql.append("JOIN dbo.Tour_Schedule ts ON ta.tourScheduleID = ts.tourScheduleID ");
        sql.append("WHERE ta.staffID = ? ");
        sql.append("  AND ta.roleInTour = ? ");
        sql.append("  AND ta.assignmentStatus <> N'Cancelled' ");
        sql.append("  AND ts.scheduleStatus <> N'Cancelled' ");
        sql.append("  AND NOT (ts.returnDate < ? OR ts.departureDate > ?) ");

        if (excludeScheduleID != null) {
            sql.append(" AND ts.tourScheduleID <> ? ");
        }

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            ps.setInt(1, staffID);
            ps.setString(2, roleInTour);
            ps.setDate(3, Date.valueOf(departureDate));
            ps.setDate(4, Date.valueOf(returnDate));

            if (excludeScheduleID != null) {
                ps.setInt(5, excludeScheduleID);
            }

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) == 0;
            }
        }
    }
}
