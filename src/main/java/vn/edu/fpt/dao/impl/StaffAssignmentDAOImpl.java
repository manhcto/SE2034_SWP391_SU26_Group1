package vn.edu.fpt.dao.impl;

import vn.edu.fpt.dao.StaffAssignmentDAO;
import vn.edu.fpt.model.StaffAssignmentDTO;
import vn.edu.fpt.model.StaffAssignmentRequest;
import vn.edu.fpt.model.StaffAssignmentScheduleDTO;
import vn.edu.fpt.model.StaffOption;
import vn.edu.fpt.utils.DBContext;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.sql.Types;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class StaffAssignmentDAOImpl implements StaffAssignmentDAO {
    @Override
    public List<StaffAssignmentScheduleDTO> searchSchedules(String keyword, String scheduleStatus) throws Exception {
        List<StaffAssignmentScheduleDTO> list = new ArrayList<>();
        String sql = """
            SELECT ts.tourScheduleID, ts.tourID, t.tourCode, t.tourName,
                   ts.departureDate, ts.returnDate, ts.bookingDeadline,
                   ts.minParticipants, ts.maxParticipants, ts.bookedSeats,
                   ts.scheduleStatus, t.tourStatus,
                   SUM(CASE WHEN ta.assignmentStatus IN (N'Pending', N'Accepted') THEN 1 ELSE 0 END) AS activeStaffCount,
                   SUM(CASE WHEN ta.roleInTour = N'Guide' AND ta.assignmentStatus IN (N'Pending', N'Accepted') THEN 1 ELSE 0 END) AS guideCount,
                   SUM(CASE WHEN ta.roleInTour = N'Driver' AND ta.assignmentStatus IN (N'Pending', N'Accepted') THEN 1 ELSE 0 END) AS driverCount,
                   SUM(CASE WHEN ta.roleInTour = N'Coordinator' AND ta.assignmentStatus IN (N'Pending', N'Accepted') THEN 1 ELSE 0 END) AS coordinatorCount,
                   SUM(CASE WHEN ta.roleInTour = N'OperationStaff' AND ta.assignmentStatus IN (N'Pending', N'Accepted') THEN 1 ELSE 0 END) AS operationStaffCount
            FROM dbo.Tour_Schedule ts
            JOIN dbo.Tour t ON ts.tourID = t.tourID
            LEFT JOIN dbo.Tour_Assignment ta ON ta.tourScheduleID = ts.tourScheduleID
            WHERE (? = N'' OR t.tourCode LIKE ? OR t.tourName LIKE ?)
              AND (? = N'' OR ts.scheduleStatus = ?)
            GROUP BY ts.tourScheduleID, ts.tourID, t.tourCode, t.tourName,
                     ts.departureDate, ts.returnDate, ts.bookingDeadline,
                     ts.minParticipants, ts.maxParticipants, ts.bookedSeats,
                     ts.scheduleStatus, t.tourStatus
            ORDER BY ts.departureDate DESC, ts.tourScheduleID DESC
            """;
        String kw = keyword == null ? "" : keyword.trim();
        String like = "%" + kw + "%";
        String status = scheduleStatus == null ? "" : scheduleStatus.trim();
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, kw);
            ps.setString(2, like);
            ps.setString(3, like);
            ps.setString(4, status);
            ps.setString(5, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapSchedule(rs));
                }
            }
        }
        return list;
    }

    @Override
    public StaffAssignmentScheduleDTO findScheduleByID(int tourScheduleID) throws Exception {
        String sql = """
            SELECT ts.tourScheduleID, ts.tourID, t.tourCode, t.tourName,
                   ts.departureDate, ts.returnDate, ts.bookingDeadline,
                   ts.minParticipants, ts.maxParticipants, ts.bookedSeats,
                   ts.scheduleStatus, t.tourStatus,
                   SUM(CASE WHEN ta.assignmentStatus IN (N'Pending', N'Accepted') THEN 1 ELSE 0 END) AS activeStaffCount,
                   SUM(CASE WHEN ta.roleInTour = N'Guide' AND ta.assignmentStatus IN (N'Pending', N'Accepted') THEN 1 ELSE 0 END) AS guideCount,
                   SUM(CASE WHEN ta.roleInTour = N'Driver' AND ta.assignmentStatus IN (N'Pending', N'Accepted') THEN 1 ELSE 0 END) AS driverCount,
                   SUM(CASE WHEN ta.roleInTour = N'Coordinator' AND ta.assignmentStatus IN (N'Pending', N'Accepted') THEN 1 ELSE 0 END) AS coordinatorCount,
                   SUM(CASE WHEN ta.roleInTour = N'OperationStaff' AND ta.assignmentStatus IN (N'Pending', N'Accepted') THEN 1 ELSE 0 END) AS operationStaffCount
            FROM dbo.Tour_Schedule ts
            JOIN dbo.Tour t ON ts.tourID = t.tourID
            LEFT JOIN dbo.Tour_Assignment ta ON ta.tourScheduleID = ts.tourScheduleID
            WHERE ts.tourScheduleID = ?
            GROUP BY ts.tourScheduleID, ts.tourID, t.tourCode, t.tourName,
                     ts.departureDate, ts.returnDate, ts.bookingDeadline,
                     ts.minParticipants, ts.maxParticipants, ts.bookedSeats,
                     ts.scheduleStatus, t.tourStatus
            """;
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tourScheduleID);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapSchedule(rs) : null;
            }
        }
    }

    @Override
    public List<StaffAssignmentDTO> getAssignmentsByScheduleID(int tourScheduleID) throws Exception {
        List<StaffAssignmentDTO> list = new ArrayList<>();
        String sql = """
            SELECT ta.assignmentID, ta.tourScheduleID, ts.tourID, t.tourCode, t.tourName,
                   ts.departureDate, ts.returnDate, ts.scheduleStatus, t.tourStatus,
                   ta.staffID, s.staffCode,
                   CONCAT(COALESCE(u.lastName, N''), N' ', COALESCE(u.firstName, N'')) AS staffName,
                   u.phone, s.staffType, ta.roleInTour, ta.assignmentStatus, ta.note,
                   ta.createdAt, ta.updatedAt
            FROM dbo.Tour_Assignment ta
            JOIN dbo.Tour_Schedule ts ON ta.tourScheduleID = ts.tourScheduleID
            JOIN dbo.Tour t ON ts.tourID = t.tourID
            JOIN dbo.Staff s ON ta.staffID = s.staffID
            JOIN dbo.[User] u ON s.userID = u.userID
            WHERE ta.tourScheduleID = ?
            ORDER BY CASE ta.assignmentStatus WHEN N'Accepted' THEN 1 WHEN N'Pending' THEN 2 WHEN N'Completed' THEN 3 ELSE 4 END,
                     ta.roleInTour, ta.assignmentID DESC
            """;
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tourScheduleID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapAssignment(rs));
                }
            }
        }
        return list;
    }

    @Override
    public List<StaffOption> getAssignableStaff() throws Exception {
        List<StaffOption> list = new ArrayList<>();
        String sql = """
            SELECT s.staffID, s.staffCode,
                   CONCAT(COALESCE(u.lastName, N''), N' ', COALESCE(u.firstName, N'')) AS fullName,
                   u.phone, s.staffType
            FROM dbo.Staff s
            JOIN dbo.[User] u ON s.userID = u.userID
            WHERE s.workStatus = N'Working'
              AND u.status = N'Active'
              AND s.staffType IN (N'Guide', N'Driver', N'Coordinator', N'OperationStaff', N'Staff')
            ORDER BY CASE s.staffType
                        WHEN N'Guide' THEN 1
                        WHEN N'Driver' THEN 2
                        WHEN N'Coordinator' THEN 3
                        WHEN N'OperationStaff' THEN 4
                        ELSE 5
                     END,
                     s.staffCode
            """;
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapStaffOption(rs));
            }
        }
        return list;
    }

    @Override
    public StaffOption findStaffByID(int staffID) throws Exception {
        String sql = """
            SELECT s.staffID, s.staffCode,
                   CONCAT(COALESCE(u.lastName, N''), N' ', COALESCE(u.firstName, N'')) AS fullName,
                   u.phone, s.staffType
            FROM dbo.Staff s
            JOIN dbo.[User] u ON s.userID = u.userID
            WHERE s.staffID = ?
              AND s.workStatus = N'Working'
              AND u.status = N'Active'
            """;
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, staffID);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapStaffOption(rs) : null;
            }
        }
    }

    @Override
    public boolean existsActiveAssignment(int tourScheduleID, int staffID, String roleInTour) throws Exception {
        String sql = """
            SELECT COUNT(1)
            FROM dbo.Tour_Assignment
            WHERE tourScheduleID = ?
              AND staffID = ?
              AND roleInTour = ?
              AND assignmentStatus IN (N'Pending', N'Accepted')
            """;
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tourScheduleID);
            ps.setInt(2, staffID);
            ps.setString(3, roleInTour);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    @Override
    public boolean hasScheduleConflict(int staffID, LocalDate departureDate, LocalDate returnDate, Integer excludeAssignmentID) throws Exception {
        String sql = """
            SELECT COUNT(1)
            FROM dbo.Tour_Assignment ta
            JOIN dbo.Tour_Schedule ts ON ta.tourScheduleID = ts.tourScheduleID
            WHERE ta.staffID = ?
              AND ta.assignmentStatus IN (N'Pending', N'Accepted')
              AND ts.scheduleStatus NOT IN (N'Cancelled', N'Completed')
              AND (? IS NULL OR ta.assignmentID <> ?)
              AND ts.departureDate <= ?
              AND ts.returnDate >= ?
            """;
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, staffID);
            if (excludeAssignmentID == null || excludeAssignmentID <= 0) {
                ps.setNull(2, Types.INTEGER);
                ps.setNull(3, Types.INTEGER);
            } else {
                ps.setInt(2, excludeAssignmentID);
                ps.setInt(3, excludeAssignmentID);
            }
            ps.setDate(4, Date.valueOf(returnDate));
            ps.setDate(5, Date.valueOf(departureDate));
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    @Override
    public int insertAssignment(StaffAssignmentRequest request) throws Exception {
        String sql = """
            INSERT INTO dbo.Tour_Assignment (tourScheduleID, staffID, roleInTour, assignmentStatus, note, createdAt, updatedAt)
            VALUES (?, ?, ?, ?, ?, GETDATE(), NULL)
            """;
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, request.getTourScheduleID());
            ps.setInt(2, request.getStaffID());
            ps.setString(3, request.getRoleInTour());
            ps.setString(4, request.getAssignmentStatus() == null || request.getAssignmentStatus().isBlank() ? "Pending" : request.getAssignmentStatus());
            ps.setString(5, request.getNote());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    @Override
    public StaffAssignmentDTO findAssignmentByID(int assignmentID) throws Exception {
        String sql = """
            SELECT ta.assignmentID, ta.tourScheduleID, ts.tourID, t.tourCode, t.tourName,
                   ts.departureDate, ts.returnDate, ts.scheduleStatus, t.tourStatus,
                   ta.staffID, s.staffCode,
                   CONCAT(COALESCE(u.lastName, N''), N' ', COALESCE(u.firstName, N'')) AS staffName,
                   u.phone, s.staffType, ta.roleInTour, ta.assignmentStatus, ta.note,
                   ta.createdAt, ta.updatedAt
            FROM dbo.Tour_Assignment ta
            JOIN dbo.Tour_Schedule ts ON ta.tourScheduleID = ts.tourScheduleID
            JOIN dbo.Tour t ON ts.tourID = t.tourID
            JOIN dbo.Staff s ON ta.staffID = s.staffID
            JOIN dbo.[User] u ON s.userID = u.userID
            WHERE ta.assignmentID = ?
            """;
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, assignmentID);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapAssignment(rs) : null;
            }
        }
    }

    @Override
    public void updateAssignmentStatus(int assignmentID, String assignmentStatus, String note) throws Exception {
        String sql = """
            UPDATE dbo.Tour_Assignment
            SET assignmentStatus = ?,
                note = CASE WHEN ? IS NULL OR ? = N'' THEN note ELSE ? END,
                updatedAt = GETDATE()
            WHERE assignmentID = ?
            """;
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, assignmentStatus);
            ps.setString(2, note);
            ps.setString(3, note);
            ps.setString(4, note);
            ps.setInt(5, assignmentID);
            ps.executeUpdate();
        }
    }

    private StaffAssignmentScheduleDTO mapSchedule(ResultSet rs) throws Exception {
        StaffAssignmentScheduleDTO dto = new StaffAssignmentScheduleDTO();
        dto.setTourScheduleID(rs.getInt("tourScheduleID"));
        dto.setTourID(rs.getInt("tourID"));
        dto.setTourCode(rs.getString("tourCode"));
        dto.setTourName(rs.getString("tourName"));
        dto.setDepartureDate(rs.getDate("departureDate"));
        dto.setReturnDate(rs.getDate("returnDate"));
        dto.setBookingDeadline(rs.getTimestamp("bookingDeadline"));
        dto.setMinParticipants(rs.getInt("minParticipants"));
        dto.setMaxParticipants(rs.getInt("maxParticipants"));
        dto.setBookedSeats(rs.getInt("bookedSeats"));
        dto.setScheduleStatus(rs.getString("scheduleStatus"));
        dto.setTourStatus(rs.getString("tourStatus"));
        dto.setActiveStaffCount(rs.getInt("activeStaffCount"));
        dto.setGuideCount(rs.getInt("guideCount"));
        dto.setDriverCount(rs.getInt("driverCount"));
        dto.setCoordinatorCount(rs.getInt("coordinatorCount"));
        dto.setOperationStaffCount(rs.getInt("operationStaffCount"));
        return dto;
    }

    private StaffAssignmentDTO mapAssignment(ResultSet rs) throws Exception {
        StaffAssignmentDTO dto = new StaffAssignmentDTO();
        dto.setAssignmentID(rs.getInt("assignmentID"));
        dto.setTourScheduleID(rs.getInt("tourScheduleID"));
        dto.setTourID(rs.getInt("tourID"));
        dto.setTourCode(rs.getString("tourCode"));
        dto.setTourName(rs.getString("tourName"));
        dto.setDepartureDate(rs.getDate("departureDate"));
        dto.setReturnDate(rs.getDate("returnDate"));
        dto.setScheduleStatus(rs.getString("scheduleStatus"));
        dto.setTourStatus(rs.getString("tourStatus"));
        dto.setStaffID(rs.getInt("staffID"));
        dto.setStaffCode(rs.getString("staffCode"));
        dto.setStaffName(rs.getString("staffName"));
        dto.setPhone(rs.getString("phone"));
        dto.setStaffType(rs.getString("staffType"));
        dto.setRoleInTour(rs.getString("roleInTour"));
        dto.setAssignmentStatus(rs.getString("assignmentStatus"));
        dto.setNote(rs.getString("note"));
        Timestamp createdAt = rs.getTimestamp("createdAt");
        Timestamp updatedAt = rs.getTimestamp("updatedAt");
        dto.setCreatedAt(createdAt);
        dto.setUpdatedAt(updatedAt);
        return dto;
    }

    private StaffOption mapStaffOption(ResultSet rs) throws Exception {
        StaffOption staff = new StaffOption();
        staff.setStaffID(rs.getInt("staffID"));
        staff.setStaffCode(rs.getString("staffCode"));
        staff.setFullName(rs.getString("fullName"));
        staff.setPhone(rs.getString("phone"));
        staff.setStaffType(rs.getString("staffType"));
        return staff;
    }
}
