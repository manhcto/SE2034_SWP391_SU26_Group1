package vn.edu.fpt.DAO;

import vn.edu.fpt.common.DBConnection;
import vn.edu.fpt.model.AssignmentView;
import vn.edu.fpt.model.TourAssignments;
import vn.edu.fpt.model.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class AssignmentDAOImpl {

    private static final String ASSIGNMENT_SELECT = """
        SELECT
            ta.assignmentID,
            ta.assignmentCode,
            ta.tourScheduleID,
            ta.userID AS guideID,
            ta.roleInTour,
            ta.bookingID,
            ta.assignedBy,
            ta.assignmentStatus,
            ta.priorityLevel,
            ta.assignedAt,
            ta.acceptedAt,
            ta.rejectedAt,
            ta.rejectionReason,
            ta.confirmedAt,
            ta.completedAt,
            ta.cancelledAt,
            ta.checkInDeadline,
            ta.actualStartAt,
            ta.actualEndAt,
            ta.meetingPoint,
            ta.pickupTime,
            ta.guideNameSnapshot,
            ta.guidePhoneSnapshot,
            ta.staffNote,
            ta.guideNote,
            ta.customerNote,
            ta.createdAt,
            ta.updatedAt,
            N'Open' AS scheduleStatus,
            ts.startDate,
            ts.endDate,
            ts.maxParticipants,
            ts.quantity AS scheduleQuantity,
            t.tourID,
            t.tourName,
            t.startPlace,
            t.endPlace,
            LTRIM(RTRIM(ISNULL(guide.firstName, N'') + N' ' + ISNULL(guide.lastName, N''))) AS guideName,
            guide.email AS guideEmail,
            guide.phone AS guidePhone,
            LTRIM(RTRIM(ISNULL(staff.firstName, N'') + N' ' + ISNULL(staff.lastName, N''))) AS assignedByName,
            fb.bookingID AS firstBookingID,
            fb.bookingCode,
            fb.bookingType,
            fb.bookingStatus,
            fb.customerName,
            fb.customerEmail,
            fb.customerPhone,
            fb.customerAddress,
            fb.note,
            fb.bookDate,
            fb.totalPrice,
            fb.detailQuantity,
            fb.unitPrice,
            fb.subTotal,
            bs.bookingCount,
            bs.numberAdult,
            bs.numberChildren,
            bs.bookedQuantity
        FROM Tour_Assignments ta
        JOIN Tour_Scheduler ts
            ON ta.tourScheduleID = ts.tourScheduleID
        JOIN Tour t
            ON ts.tourID = t.tourID
        JOIN [User] guide
            ON ta.userID = guide.userID
        LEFT JOIN [User] staff
            ON ta.assignedBy = staff.userID
        OUTER APPLY (
            SELECT TOP 1
                b.bookingID,
                b.bookingCode,
                b.bookingType,
                b.[status] AS bookingStatus,
                LTRIM(RTRIM(ISNULL(b.firstName, N'') + N' ' + ISNULL(b.lastName, N''))) AS customerName,
                b.email AS customerEmail,
                b.phone AS customerPhone,
                b.address AS customerAddress,
                b.note,
                b.bookDate,
                b.totalPrice,
                bd.quantity AS detailQuantity,
                bd.unitPrice,
                bd.subTotal
            FROM Booking_Detail bd
            JOIN Booking b
                ON bd.bookingID = b.bookingID
               AND b.bookingType = N'Tour'
            WHERE bd.tourScheduleID = ta.tourScheduleID
            ORDER BY
                CASE
                    WHEN b.[status] = N'Confirmed' THEN 0
                    WHEN b.[status] = N'Pending' THEN 1
                    ELSE 2
                END,
                b.bookDate DESC,
                b.bookingID DESC
        ) fb
        OUTER APPLY (
            SELECT
                COUNT(DISTINCT b2.bookingID) AS bookingCount,
                COALESCE(SUM(CASE WHEN b2.[status] <> N'Cancelled' THEN b2.numberAdult ELSE 0 END), 0) AS numberAdult,
                COALESCE(SUM(CASE WHEN b2.[status] <> N'Cancelled' THEN b2.numberChildren ELSE 0 END), 0) AS numberChildren,
                COALESCE(SUM(CASE WHEN b2.[status] <> N'Cancelled' THEN bd2.quantity ELSE 0 END), 0) AS bookedQuantity
            FROM Booking_Detail bd2
            JOIN Booking b2
                ON bd2.bookingID = b2.bookingID
               AND b2.bookingType = N'Tour'
            WHERE bd2.tourScheduleID = ta.tourScheduleID
        ) bs
        """;

    public List<AssignmentView> getAllAssignments() {
        return getAllAssignments(null, null);
    }

    public List<AssignmentView> getAllAssignments(String keyword, String status) {
        List<AssignmentView> list = new ArrayList<>();
        List<Object> params = new ArrayList<>();

        StringBuilder sql = new StringBuilder(ASSIGNMENT_SELECT).append(" WHERE 1 = 1 ");

        String normalizedKeyword = blankToNull(keyword);
        if (normalizedKeyword != null) {
            sql.append("""
                AND (
                    ta.assignmentCode LIKE ?
                    OR t.tourName LIKE ?
                    OR guide.firstName LIKE ?
                    OR guide.lastName LIKE ?
                    OR guide.email LIKE ?
                    OR fb.bookingCode LIKE ?
                )
                """);
            String like = "%" + normalizedKeyword + "%";
            for (int i = 0; i < 6; i++) {
                params.add(like);
            }
        }

        String normalizedStatus = blankToNull(status);
        if (normalizedStatus != null) {
            sql.append(" AND ta.assignmentStatus = ? ");
            params.add(normalizedStatus);
        }

        sql.append(" ORDER BY ts.startDate ASC, ta.assignedAt DESC, ta.assignmentID DESC ");

        DBConnection db = new DBConnection();

        try (
                Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())
        ) {
            setParams(ps, params);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapAssignmentView(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<AssignmentView> getConfirmedSchedulesForAssignment(String keyword) {
        return getSchedulesForAssignment(keyword, true);
    }

    public List<AssignmentView> getAllSchedulesForAssignmentOptions(String keyword) {
        return getSchedulesForAssignment(keyword, false);
    }

    private List<AssignmentView> getSchedulesForAssignment(String keyword, boolean onlyWithoutActiveAssignment) {
        List<AssignmentView> list = new ArrayList<>();
        List<Object> params = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""
            SELECT
                ts.tourScheduleID,
                ts.tourID,
                N'Open' AS scheduleStatus,
                ts.startDate,
                ts.endDate,
                ts.maxParticipants,
                ts.quantity AS bookedQuantity,
                t.tourName,
                t.startPlace,
                t.endPlace,
                COUNT(DISTINCT b.bookingID) AS bookingCount,
                COALESCE(SUM(CASE WHEN b.[status] <> N'Cancelled' THEN b.numberAdult ELSE 0 END), 0) AS numberAdult,
                COALESCE(SUM(CASE WHEN b.[status] <> N'Cancelled' THEN b.numberChildren ELSE 0 END), 0) AS numberChildren,
                COALESCE(SUM(CASE WHEN b.[status] <> N'Cancelled' THEN bd.quantity ELSE 0 END), 0) AS detailQuantity
            FROM Tour_Scheduler ts
            JOIN Tour t
                ON ts.tourID = t.tourID
            LEFT JOIN Booking_Detail bd
                ON bd.tourScheduleID = ts.tourScheduleID
            LEFT JOIN Booking b
                ON b.bookingID = bd.bookingID
               AND b.bookingType = N'Tour'
            WHERE 1 = 1
            """);

        if (onlyWithoutActiveAssignment) {
            sql.append("""
              AND NOT EXISTS (
                SELECT 1
                FROM Tour_Assignments existing
                WHERE existing.tourScheduleID = ts.tourScheduleID
                  AND existing.assignmentStatus NOT IN (N'Cancelled', N'Rejected')
              )
              """);
        }

        String normalizedKeyword = blankToNull(keyword);
        if (normalizedKeyword != null) {
            sql.append("""
                AND (
                    t.tourName LIKE ?
                    OR t.startPlace LIKE ?
                    OR t.endPlace LIKE ?
                    OR CAST(ts.tourScheduleID AS NVARCHAR(30)) LIKE ?
                )
                """);
            String like = "%" + normalizedKeyword + "%";
            for (int i = 0; i < 4; i++) {
                params.add(like);
            }
        }

        sql.append("""
            GROUP BY
                ts.tourScheduleID,
                ts.tourID,
                ts.startDate,
                ts.endDate,
                ts.maxParticipants,
                ts.quantity,
                t.tourName,
                t.startPlace,
                t.endPlace
            ORDER BY ts.startDate ASC, ts.tourScheduleID DESC
            """);

        DBConnection db = new DBConnection();

        try (
                Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())
        ) {
            setParams(ps, params);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapScheduleView(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public AssignmentView getScheduleById(int tourScheduleID) {
        String sql = """
            SELECT
                ts.tourScheduleID,
                ts.tourID,
                N'Open' AS scheduleStatus,
                ts.startDate,
                ts.endDate,
                ts.maxParticipants,
                ts.quantity AS bookedQuantity,
                t.tourName,
                t.startPlace,
                t.endPlace,
                COUNT(DISTINCT b.bookingID) AS bookingCount,
                COALESCE(SUM(CASE WHEN b.[status] <> N'Cancelled' THEN b.numberAdult ELSE 0 END), 0) AS numberAdult,
                COALESCE(SUM(CASE WHEN b.[status] <> N'Cancelled' THEN b.numberChildren ELSE 0 END), 0) AS numberChildren,
                COALESCE(SUM(CASE WHEN b.[status] <> N'Cancelled' THEN bd.quantity ELSE 0 END), 0) AS detailQuantity
            FROM Tour_Scheduler ts
            JOIN Tour t
                ON ts.tourID = t.tourID
            LEFT JOIN Booking_Detail bd
                ON bd.tourScheduleID = ts.tourScheduleID
            LEFT JOIN Booking b
                ON b.bookingID = bd.bookingID
               AND b.bookingType = N'Tour'
            WHERE ts.tourScheduleID = ?
            GROUP BY
                ts.tourScheduleID,
                ts.tourID,
                ts.startDate,
                ts.endDate,
                ts.maxParticipants,
                ts.quantity,
                t.tourName,
                t.startPlace,
                t.endPlace
            """;

        DBConnection db = new DBConnection();

        try (
                Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, tourScheduleID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapScheduleView(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public TourAssignments getAssignmentById(int id) {
        String sql = """
            SELECT *
            FROM Tour_Assignments
            WHERE assignmentID = ?
            """;

        DBConnection db = new DBConnection();

        try (
                Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapTourAssignment(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean addAssignment(TourAssignments assignment) {
        String sql = """
            INSERT INTO Tour_Assignments
            (
                tourScheduleID,
                userID,
                roleInTour,
                bookingID,
                assignedBy,
                assignmentStatus,
                priorityLevel,
                meetingPoint,
                pickupTime,
                checkInDeadline,
                staffNote,
                guideNote,
                customerNote,
                guideNameSnapshot,
                guidePhoneSnapshot
            )
            SELECT
                ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,
                LTRIM(RTRIM(ISNULL(u.firstName, N'') + N' ' + ISNULL(u.lastName, N''))),
                u.phone
            FROM [User] u
            WHERE u.userID = ?
            """;

        DBConnection db = new DBConnection();

        try (
                Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)
        ) {
            int index = 1;
            ps.setInt(index++, assignment.getTourScheduleID());
            ps.setInt(index++, assignment.getUserID());
            ps.setString(index++, normalize(assignment.getRoleInTour(), "Tour Guide"));
            setNullableInt(ps, index++, assignment.getBookingID());
            setNullableInt(ps, index++, assignment.getAssignedBy());
            ps.setString(index++, normalize(assignment.getAssignmentStatus(), "Pending"));
            ps.setString(index++, normalize(assignment.getPriorityLevel(), "Normal"));
            ps.setString(index++, blankToNull(assignment.getMeetingPoint()));
            setNullableTimestamp(ps, index++, assignment.getPickupTime());
            setNullableTimestamp(ps, index++, assignment.getCheckInDeadline());
            ps.setString(index++, blankToNull(assignment.getStaffNote()));
            ps.setString(index++, blankToNull(assignment.getGuideNote()));
            ps.setString(index++, blankToNull(assignment.getCustomerNote()));
            ps.setInt(index, assignment.getUserID());

            int affectedRows = ps.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        updateAssignmentCode(conn, keys.getInt(1));
                    }
                }

                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean updateAssignment(TourAssignments assignment) {
        String sql = """
            UPDATE ta
            SET
                ta.tourScheduleID = ?,
                ta.userID = ?,
                ta.roleInTour = ?,
                ta.bookingID = ?,
                ta.assignedBy = ?,
                ta.assignmentStatus = ?,
                ta.priorityLevel = ?,
                ta.meetingPoint = ?,
                ta.pickupTime = ?,
                ta.checkInDeadline = ?,
                ta.actualStartAt = ?,
                ta.actualEndAt = ?,
                ta.rejectionReason = ?,
                ta.staffNote = ?,
                ta.guideNote = ?,
                ta.customerNote = ?,
                ta.guideNameSnapshot = LTRIM(RTRIM(ISNULL(u.firstName, N'') + N' ' + ISNULL(u.lastName, N''))),
                ta.guidePhoneSnapshot = u.phone,
                ta.acceptedAt = CASE WHEN ? = N'Accepted' AND ta.acceptedAt IS NULL THEN GETDATE() ELSE ta.acceptedAt END,
                ta.confirmedAt = CASE WHEN ? = N'Confirmed' AND ta.confirmedAt IS NULL THEN GETDATE() ELSE ta.confirmedAt END,
                ta.actualStartAt = CASE WHEN ? = N'In Progress' AND ta.actualStartAt IS NULL THEN GETDATE() ELSE ta.actualStartAt END,
                ta.actualEndAt = CASE WHEN ? IN (N'Completed', N'Cancelled') AND ta.actualEndAt IS NULL THEN GETDATE() ELSE ta.actualEndAt END,
                ta.completedAt = CASE WHEN ? = N'Completed' AND ta.completedAt IS NULL THEN GETDATE() ELSE ta.completedAt END,
                ta.cancelledAt = CASE WHEN ? = N'Cancelled' AND ta.cancelledAt IS NULL THEN GETDATE() ELSE ta.cancelledAt END,
                ta.rejectedAt = CASE WHEN ? = N'Rejected' AND ta.rejectedAt IS NULL THEN GETDATE() ELSE ta.rejectedAt END,
                ta.updatedAt = GETDATE()
            FROM Tour_Assignments ta
            JOIN [User] u
                ON u.userID = ?
            WHERE ta.assignmentID = ?
            """;

        DBConnection db = new DBConnection();

        try (
                Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            String status = normalize(assignment.getAssignmentStatus(), "Pending");

            int index = 1;
            ps.setInt(index++, assignment.getTourScheduleID());
            ps.setInt(index++, assignment.getUserID());
            ps.setString(index++, normalize(assignment.getRoleInTour(), "Tour Guide"));
            setNullableInt(ps, index++, assignment.getBookingID());
            setNullableInt(ps, index++, assignment.getAssignedBy());
            ps.setString(index++, status);
            ps.setString(index++, normalize(assignment.getPriorityLevel(), "Normal"));
            ps.setString(index++, blankToNull(assignment.getMeetingPoint()));
            setNullableTimestamp(ps, index++, assignment.getPickupTime());
            setNullableTimestamp(ps, index++, assignment.getCheckInDeadline());
            setNullableTimestamp(ps, index++, assignment.getActualStartAt());
            setNullableTimestamp(ps, index++, assignment.getActualEndAt());
            ps.setString(index++, blankToNull(assignment.getRejectionReason()));
            ps.setString(index++, blankToNull(assignment.getStaffNote()));
            ps.setString(index++, blankToNull(assignment.getGuideNote()));
            ps.setString(index++, blankToNull(assignment.getCustomerNote()));
            ps.setString(index++, status);
            ps.setString(index++, status);
            ps.setString(index++, status);
            ps.setString(index++, status);
            ps.setString(index++, status);
            ps.setString(index++, status);
            ps.setString(index++, status);
            ps.setInt(index++, assignment.getUserID());
            ps.setInt(index, assignment.getAssignmentID());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean deleteAssignment(int id) {
        String sql = """
            DELETE FROM Tour_Assignments
            WHERE assignmentID = ?
            """;

        DBConnection db = new DBConnection();

        try (
                Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public AssignmentView getAssignmentDetail(int id) {
        String sql = ASSIGNMENT_SELECT + " WHERE ta.assignmentID = ? ";

        DBConnection db = new DBConnection();

        try (
                Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapAssignmentView(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public AssignmentView getAssignmentDetailForGuide(int id, int guideID) {
        String sql = ASSIGNMENT_SELECT + """
            WHERE ta.assignmentID = ?
              AND ta.userID = ?
            """;

        DBConnection db = new DBConnection();

        try (
                Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, id);
            ps.setInt(2, guideID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapAssignmentView(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public List<User> getAllGuides() {
        List<User> list = new ArrayList<>();

        String sql = """
            SELECT
                u.userID,
                u.firstName,
                u.lastName,
                u.email,
                u.phone,
                u.[status],
                u.roleID
            FROM [User] u
            LEFT JOIN [Role] r
                ON u.roleID = r.roleID
            WHERE (
                    LOWER(REPLACE(ISNULL(r.roleName, N''), N' ', N'')) IN (N'tourguide', N'guide')
                    OR (NULLIF(LTRIM(RTRIM(ISNULL(r.roleName, N''))), N'') IS NULL AND u.roleID IN (2, 3))
                  )
              AND u.[status] = N'Active'
            ORDER BY u.firstName, u.lastName, u.userID DESC
            """;

        DBConnection db = new DBConnection();

        try (
                Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {
            while (rs.next()) {
                User u = new User();

                u.setUserID(rs.getInt("userID"));
                u.setFirstName(rs.getString("firstName"));
                u.setLastName(rs.getString("lastName"));
                u.setEmail(rs.getString("email"));
                u.setPhone(rs.getString("phone"));
                u.setRoleID(rs.getInt("roleID"));
                u.setStatus(rs.getString("status"));

                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int getTourScheduleIDByBookingID(int bookingID) {
        String sql = """
            SELECT TOP 1
                tourScheduleID
            FROM Booking_Detail
            WHERE bookingID = ?
              AND tourScheduleID IS NOT NULL
            """;

        DBConnection db = new DBConnection();

        try (
                Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, bookingID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("tourScheduleID");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return -1;
    }

    public List<AssignmentView> getAssignmentsByGuide(int guideID) {
        return getAssignmentsByGuide(guideID, null, null, null);
    }

    public List<AssignmentView> getAssignmentsByGuide(int guideID, String status, String dateFrom, String dateTo) {
        List<AssignmentView> list = new ArrayList<>();
        List<Object> params = new ArrayList<>();

        StringBuilder sql = new StringBuilder(ASSIGNMENT_SELECT).append(" WHERE ta.userID = ? ");
        params.add(guideID);

        String normalizedStatus = blankToNull(status);
        if (normalizedStatus != null) {
            sql.append(" AND ta.assignmentStatus = ? ");
            params.add(normalizedStatus);
        }

        String normalizedDateFrom = blankToNull(dateFrom);
        if (normalizedDateFrom != null) {
            sql.append(" AND CAST(ts.startDate AS DATE) >= ? ");
            params.add(normalizedDateFrom);
        }

        String normalizedDateTo = blankToNull(dateTo);
        if (normalizedDateTo != null) {
            sql.append(" AND CAST(ts.startDate AS DATE) <= ? ");
            params.add(normalizedDateTo);
        }

        sql.append(" ORDER BY ts.startDate ASC, ta.assignedAt DESC, ta.assignmentID DESC ");

        DBConnection db = new DBConnection();

        try (
                Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())
        ) {
            setParams(ps, params);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapAssignmentView(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean updateAssignmentStatusForGuide(
            int assignmentID,
            int guideID,
            String status,
            String guideNote) {

        String sql = """
            UPDATE Tour_Assignments
            SET
                assignmentStatus = ?,
                guideNote = ?,
                acceptedAt = CASE WHEN ? = N'Accepted' AND acceptedAt IS NULL THEN GETDATE() ELSE acceptedAt END,
                confirmedAt = CASE WHEN ? = N'Confirmed' AND confirmedAt IS NULL THEN GETDATE() ELSE confirmedAt END,
                actualStartAt = CASE WHEN ? = N'In Progress' AND actualStartAt IS NULL THEN GETDATE() ELSE actualStartAt END,
                actualEndAt = CASE WHEN ? IN (N'Completed', N'Cancelled') AND actualEndAt IS NULL THEN GETDATE() ELSE actualEndAt END,
                completedAt = CASE WHEN ? = N'Completed' AND completedAt IS NULL THEN GETDATE() ELSE completedAt END,
                cancelledAt = CASE WHEN ? = N'Cancelled' AND cancelledAt IS NULL THEN GETDATE() ELSE cancelledAt END,
                rejectedAt = CASE WHEN ? = N'Rejected' AND rejectedAt IS NULL THEN GETDATE() ELSE rejectedAt END,
                updatedAt = GETDATE()
            WHERE assignmentID = ?
              AND userID = ?
            """;

        DBConnection db = new DBConnection();

        try (
                Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            String normalizedStatus = normalize(status, "Pending");

            int index = 1;
            ps.setString(index++, normalizedStatus);
            ps.setString(index++, blankToNull(guideNote));
            ps.setString(index++, normalizedStatus);
            ps.setString(index++, normalizedStatus);
            ps.setString(index++, normalizedStatus);
            ps.setString(index++, normalizedStatus);
            ps.setString(index++, normalizedStatus);
            ps.setString(index++, normalizedStatus);
            ps.setString(index++, normalizedStatus);
            ps.setInt(index++, assignmentID);
            ps.setInt(index, guideID);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean isGuideAvailable(int guideID, int tourScheduleID, int excludeAssignmentID) {
        String sql = """
            SELECT COUNT(1) AS conflictCount
            FROM Tour_Assignments ta
            JOIN Tour_Scheduler currentSchedule
                ON ta.tourScheduleID = currentSchedule.tourScheduleID
            JOIN Tour_Scheduler targetSchedule
                ON targetSchedule.tourScheduleID = ?
            WHERE ta.userID = ?
              AND ta.assignmentID <> ?
              AND ta.assignmentStatus NOT IN (N'Cancelled', N'Rejected')
              AND targetSchedule.startDate <= currentSchedule.endDate
              AND targetSchedule.endDate >= currentSchedule.startDate
            """;

        DBConnection db = new DBConnection();

        try (
                Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, tourScheduleID);
            ps.setInt(2, guideID);
            ps.setInt(3, excludeAssignmentID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("conflictCount") == 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    private TourAssignments mapTourAssignment(ResultSet rs) throws Exception {
        TourAssignments ta = new TourAssignments();

        ta.setAssignmentID(rs.getInt("assignmentID"));
        ta.setAssignmentCode(rs.getString("assignmentCode"));
        ta.setTourScheduleID(rs.getInt("tourScheduleID"));
        ta.setUserID(rs.getInt("userID"));
        ta.setRoleInTour(rs.getString("roleInTour"));
        ta.setBookingID(rs.getInt("bookingID"));
        ta.setAssignedBy(rs.getInt("assignedBy"));
        ta.setAssignmentStatus(rs.getString("assignmentStatus"));
        ta.setPriorityLevel(rs.getString("priorityLevel"));
        ta.setAssignedAt(rs.getTimestamp("assignedAt"));
        ta.setAcceptedAt(rs.getTimestamp("acceptedAt"));
        ta.setRejectedAt(rs.getTimestamp("rejectedAt"));
        ta.setRejectionReason(rs.getString("rejectionReason"));
        ta.setConfirmedAt(rs.getTimestamp("confirmedAt"));
        ta.setCompletedAt(rs.getTimestamp("completedAt"));
        ta.setCancelledAt(rs.getTimestamp("cancelledAt"));
        ta.setCheckInDeadline(rs.getTimestamp("checkInDeadline"));
        ta.setActualStartAt(rs.getTimestamp("actualStartAt"));
        ta.setActualEndAt(rs.getTimestamp("actualEndAt"));
        ta.setMeetingPoint(rs.getString("meetingPoint"));
        ta.setPickupTime(rs.getTimestamp("pickupTime"));
        ta.setGuideNameSnapshot(rs.getString("guideNameSnapshot"));
        ta.setGuidePhoneSnapshot(rs.getString("guidePhoneSnapshot"));
        ta.setStaffNote(rs.getString("staffNote"));
        ta.setGuideNote(rs.getString("guideNote"));
        ta.setCustomerNote(rs.getString("customerNote"));
        ta.setCreatedAt(rs.getTimestamp("createdAt"));
        ta.setUpdatedAt(rs.getTimestamp("updatedAt"));

        return ta;
    }

    private AssignmentView mapAssignmentView(ResultSet rs) throws Exception {
        AssignmentView a = new AssignmentView();

        a.setAssignmentID(rs.getInt("assignmentID"));
        a.setAssignmentCode(rs.getString("assignmentCode"));
        a.setTourScheduleID(rs.getInt("tourScheduleID"));
        a.setTourID(rs.getInt("tourID"));
        a.setGuideID(rs.getInt("guideID"));
        a.setGuideName(rs.getString("guideName"));
        a.setGuideEmail(rs.getString("guideEmail"));
        a.setGuidePhone(rs.getString("guidePhone"));
        a.setGuideNameSnapshot(rs.getString("guideNameSnapshot"));
        a.setGuidePhoneSnapshot(rs.getString("guidePhoneSnapshot"));
        a.setRoleInTour(rs.getString("roleInTour"));
        a.setBookingID(firstPositive(rs.getInt("bookingID"), rs.getInt("firstBookingID")));
        a.setAssignedBy(rs.getInt("assignedBy"));
        a.setAssignedByName(rs.getString("assignedByName"));
        a.setAssignmentStatus(rs.getString("assignmentStatus"));
        a.setStatus(rs.getString("assignmentStatus"));
        a.setPriorityLevel(rs.getString("priorityLevel"));
        a.setAssignedAt(rs.getTimestamp("assignedAt"));
        a.setAcceptedAt(rs.getTimestamp("acceptedAt"));
        a.setRejectedAt(rs.getTimestamp("rejectedAt"));
        a.setRejectionReason(rs.getString("rejectionReason"));
        a.setConfirmedAt(rs.getTimestamp("confirmedAt"));
        a.setCompletedAt(rs.getTimestamp("completedAt"));
        a.setCancelledAt(rs.getTimestamp("cancelledAt"));
        a.setCheckInDeadline(rs.getTimestamp("checkInDeadline"));
        a.setActualStartAt(rs.getTimestamp("actualStartAt"));
        a.setActualEndAt(rs.getTimestamp("actualEndAt"));
        a.setMeetingPoint(rs.getString("meetingPoint"));
        a.setPickupTime(rs.getTimestamp("pickupTime"));
        a.setStaffNote(rs.getString("staffNote"));
        a.setGuideNote(rs.getString("guideNote"));
        a.setCustomerNote(rs.getString("customerNote"));
        a.setCreatedAt(rs.getTimestamp("createdAt"));
        a.setUpdatedAt(rs.getTimestamp("updatedAt"));
        a.setScheduleStatus(rs.getString("scheduleStatus"));
        a.setBookingCode(rs.getString("bookingCode"));
        a.setBookingType(rs.getString("bookingType"));
        a.setBookingStatus(rs.getString("bookingStatus"));
        a.setCustomerName(rs.getString("customerName"));
        a.setCustomerEmail(rs.getString("customerEmail"));
        a.setCustomerPhone(rs.getString("customerPhone"));
        a.setCustomerAddress(rs.getString("customerAddress"));
        a.setNote(rs.getString("note"));
        a.setNumberAdult(rs.getInt("numberAdult"));
        a.setNumberChildren(rs.getInt("numberChildren"));
        a.setBookDate(rs.getTimestamp("bookDate"));
        a.setTotalPrice(rs.getDouble("totalPrice"));
        a.setQuantity(rs.getInt("detailQuantity"));
        a.setUnitPrice(rs.getDouble("unitPrice"));
        a.setSubTotal(rs.getDouble("subTotal"));
        a.setTourName(rs.getString("tourName"));
        a.setStartPlace(rs.getString("startPlace"));
        a.setEndPlace(rs.getString("endPlace"));
        a.setDepartureDate(rs.getTimestamp("startDate"));
        a.setEndDate(rs.getTimestamp("endDate"));
        a.setMaxParticipants(rs.getInt("maxParticipants"));
        a.setBookedQuantity(firstPositive(rs.getInt("bookedQuantity"), rs.getInt("scheduleQuantity")));
        a.setBookingCount(rs.getInt("bookingCount"));

        return a;
    }

    private AssignmentView mapScheduleView(ResultSet rs) throws Exception {
        AssignmentView a = new AssignmentView();

        a.setTourScheduleID(rs.getInt("tourScheduleID"));
        a.setTourID(rs.getInt("tourID"));
        a.setScheduleStatus(rs.getString("scheduleStatus"));
        a.setStatus(rs.getString("scheduleStatus"));
        a.setDepartureDate(rs.getTimestamp("startDate"));
        a.setEndDate(rs.getTimestamp("endDate"));
        a.setMaxParticipants(rs.getInt("maxParticipants"));
        a.setBookedQuantity(rs.getInt("bookedQuantity"));
        a.setTourName(rs.getString("tourName"));
        a.setStartPlace(rs.getString("startPlace"));
        a.setEndPlace(rs.getString("endPlace"));
        a.setBookingCount(rs.getInt("bookingCount"));
        a.setNumberAdult(rs.getInt("numberAdult"));
        a.setNumberChildren(rs.getInt("numberChildren"));
        a.setQuantity(rs.getInt("detailQuantity"));

        return a;
    }

    private void updateAssignmentCode(Connection conn, int assignmentID) throws Exception {
        String sql = """
            UPDATE Tour_Assignments
            SET assignmentCode = N'ASG-' + RIGHT('000000' + CAST(assignmentID AS VARCHAR(20)), 6)
            WHERE assignmentID = ?
              AND assignmentCode IS NULL
            """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, assignmentID);
            ps.executeUpdate();
        }
    }

    private void setParams(PreparedStatement ps, List<Object> params) throws Exception {
        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }
    }

    private void setNullableInt(PreparedStatement ps, int index, int value) throws Exception {
        if (value <= 0) {
            ps.setNull(index, Types.INTEGER);
            return;
        }

        ps.setInt(index, value);
    }

    private void setNullableTimestamp(PreparedStatement ps, int index, java.util.Date value) throws Exception {
        if (value == null) {
            ps.setNull(index, Types.TIMESTAMP);
            return;
        }

        ps.setTimestamp(index, new Timestamp(value.getTime()));
    }

    private String normalize(String value, String fallback) {
        String normalized = blankToNull(value);
        return normalized == null ? fallback : normalized;
    }

    private String blankToNull(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }

        return value.trim();
    }

    private int firstPositive(int first, int second) {
        return first > 0 ? first : second;
    }
}
