package vn.edu.fpt.DAO;

import vn.edu.fpt.common.DBConnection;
import vn.edu.fpt.model.AssignmentView;
import vn.edu.fpt.model.Booking;
import vn.edu.fpt.model.TourAssignments;
import vn.edu.fpt.model.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Time;
import java.sql.Timestamp;
import java.sql.Types;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

public class AssignmentDAOImpl {

    private static final String ASSIGNABLE_TOUR_BOOKING_STATUS_CONDITION =
            "LTRIM(RTRIM(ISNULL(b.[status], N''))) IN (N'Confirmed', N'Đã xác nhận', N'Đã duyệt')";

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
            b.bookingCode,
            b.bookingType,
            LTRIM(RTRIM(ISNULL(b.firstName, N'') + N' ' + ISNULL(b.lastName, N''))) AS customerName,
            b.email AS customerEmail,
            b.phone AS customerPhone,
            b.address AS customerAddress,
            b.note,
            b.numberAdult,
            b.numberChildren,
            b.[status] AS bookingStatus,
            b.bookDate,
            b.totalPrice,
            bd.quantity AS detailQuantity,
            bd.unitPrice,
            bd.subTotal,
            t.tourID,
            t.tourName,
            t.startPlace,
            t.endPlace,
            LTRIM(RTRIM(ISNULL(u.firstName, N'') + N' ' + ISNULL(u.lastName, N''))) AS guideName,
            u.email AS guideEmail,
            u.phone AS guidePhone,
            LTRIM(RTRIM(ISNULL(staff.firstName, N'') + N' ' + ISNULL(staff.lastName, N''))) AS assignedByName,
            ts.startDate,
            ts.endDate,
            ts.departureTime,
            ts.maxParticipants,
            ts.quantity AS bookedQuantity
        FROM Tour_Assignments ta
        JOIN Tour_Scheduler ts
            ON ta.tourScheduleID = ts.tourScheduleID
        JOIN Tour t
            ON ts.tourID = t.tourID
        JOIN [User] u
            ON ta.userID = u.userID
        LEFT JOIN [User] staff
            ON ta.assignedBy = staff.userID
        LEFT JOIN Booking b
            ON ta.bookingID = b.bookingID
        LEFT JOIN Booking_Detail bd
            ON bd.bookingID = b.bookingID
           AND bd.tourScheduleID = ta.tourScheduleID
        """;

    public List<AssignmentView> getAllAssignments() {
        List<AssignmentView> list = new ArrayList<>();

        String sql = ASSIGNMENT_SELECT + """
            ORDER BY ta.assignedAt DESC, ta.assignmentID DESC
            """;

        DBConnection db = new DBConnection();

        try (
                Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {
            while (rs.next()) {
                list.add(mapAssignmentView(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
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
            ps.setString(index++, normalize(assignment.getRoleInTour(), "Hướng dẫn viên"));
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
            ps.setString(index++, normalize(assignment.getRoleInTour(), "Hướng dẫn viên"));
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
            ps.setInt(index++, assignment.getUserID());
            ps.setInt(index, assignment.getAssignmentID());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean deleteAssignment(int id) {
        String deleteLogsSql = """
            DELETE FROM Tour_Progress_Log
            WHERE assignmentID = ?
            """;

        String deleteAssignmentSql = """
            DELETE FROM Tour_Assignments
            WHERE assignmentID = ?
            """;

        DBConnection db = new DBConnection();

        try (Connection conn = db.getConnection()) {
            conn.setAutoCommit(false);

            try (
                    PreparedStatement deleteLogs = conn.prepareStatement(deleteLogsSql);
                    PreparedStatement deleteAssignment = conn.prepareStatement(deleteAssignmentSql)
            ) {
                deleteLogs.setInt(1, id);
                deleteLogs.executeUpdate();

                deleteAssignment.setInt(1, id);
                int affectedRows = deleteAssignment.executeUpdate();

                if (affectedRows > 0) {
                    conn.commit();
                    return true;
                }

                conn.rollback();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public AssignmentView getAssignmentDetail(int id) {
        String sql = ASSIGNMENT_SELECT + """
            WHERE ta.assignmentID = ?
            """;

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

    public List<AssignmentView> getAllBookingsForAssignment() {
        List<AssignmentView> list = new ArrayList<>();

        String sql = """
            SELECT DISTINCT
                b.bookingID,
                b.bookingCode,
                b.bookingType,
                LTRIM(RTRIM(ISNULL(b.firstName, N'') + N' ' + ISNULL(b.lastName, N''))) AS customerName,
                b.email AS customerEmail,
                b.phone AS customerPhone,
                b.numberAdult,
                b.numberChildren,
                b.[status] AS bookingStatus,
                b.bookDate,
                b.totalPrice,
                bd.tourScheduleID,
                bd.quantity AS detailQuantity,
                bd.unitPrice,
                bd.subTotal,
                t.tourID,
                t.tourName,
                t.startPlace,
                t.endPlace,
                ts.startDate,
                ts.endDate,
                ts.departureTime,
                ts.maxParticipants,
                ts.quantity AS bookedQuantity
            FROM Booking b
            OUTER APPLY (
                SELECT TOP 1 *
                FROM Booking_Detail bdInner
                WHERE bdInner.bookingID = b.bookingID
                ORDER BY bdInner.bookingDetailID ASC
            ) bd
            JOIN Tour_Scheduler ts
                ON bd.tourScheduleID = ts.tourScheduleID
            JOIN Tour t
                ON ts.tourID = t.tourID
            WHERE bd.tourScheduleID IS NOT NULL
              AND UPPER(LTRIM(RTRIM(ISNULL(b.bookingType, N'')))) = N'TOUR'
              AND (
                  """ + ASSIGNABLE_TOUR_BOOKING_STATUS_CONDITION + """
              )
              AND NOT EXISTS (
                  SELECT 1
                  FROM Tour_Assignments assignedTour
                  JOIN Booking assignedBooking
                      ON assignedTour.bookingID = assignedBooking.bookingID
                  WHERE assignedTour.tourScheduleID = bd.tourScheduleID
                    AND (
                        assignedTour.bookingID = b.bookingID
                        OR (
                            b.userID IS NOT NULL
                            AND assignedBooking.userID = b.userID
                        )
                        OR (
                            NULLIF(LOWER(LTRIM(RTRIM(ISNULL(b.email, N'')))), N'') IS NOT NULL
                            AND LOWER(LTRIM(RTRIM(ISNULL(assignedBooking.email, N'')))) =
                                LOWER(LTRIM(RTRIM(ISNULL(b.email, N''))))
                        )
                        OR (
                            NULLIF(LTRIM(RTRIM(ISNULL(b.phone, N''))), N'') IS NOT NULL
                            AND LTRIM(RTRIM(ISNULL(assignedBooking.phone, N''))) =
                                LTRIM(RTRIM(ISNULL(b.phone, N'')))
                        )
                    )
              )
            ORDER BY b.bookingID DESC
            """;

        DBConnection db = new DBConnection();

        try (
                Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {
            while (rs.next()) {
                AssignmentView a = new AssignmentView();

                a.setBookingID(rs.getInt("bookingID"));
                a.setBookingCode(rs.getString("bookingCode"));
                a.setBookingType(rs.getString("bookingType"));
                a.setCustomerName(rs.getString("customerName"));
                a.setCustomerEmail(rs.getString("customerEmail"));
                a.setCustomerPhone(rs.getString("customerPhone"));
                a.setNumberAdult(rs.getInt("numberAdult"));
                a.setNumberChildren(rs.getInt("numberChildren"));
                a.setStatus(rs.getString("bookingStatus"));
                a.setBookDate(rs.getTimestamp("bookDate"));
                a.setTotalPrice(rs.getDouble("totalPrice"));
                a.setTourScheduleID(rs.getInt("tourScheduleID"));
                a.setQuantity(rs.getInt("detailQuantity"));
                a.setUnitPrice(rs.getDouble("unitPrice"));
                a.setSubTotal(rs.getDouble("subTotal"));
                a.setTourID(rs.getInt("tourID"));
                a.setTourName(rs.getString("tourName"));
                a.setStartPlace(rs.getString("startPlace"));
                a.setEndPlace(rs.getString("endPlace"));
                a.setDepartureDate(rs.getTimestamp("startDate"));
                a.setEndDate(rs.getTimestamp("endDate"));
                Timestamp departureAt = composeDepartureAt(
                        rs.getTimestamp("startDate"),
                        rs.getTime("departureTime")
                );
                a.setPickupTime(minutesBefore(departureAt, 30));
                a.setCheckInDeadline(minutesBefore(departureAt, 10));
                a.setMaxParticipants(rs.getInt("maxParticipants"));
                a.setBookedQuantity(rs.getInt("bookedQuantity"));

                list.add(a);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public Timestamp getScheduleDepartureAt(int tourScheduleID) {
        String sql = """
            SELECT
                startDate,
                departureTime
            FROM Tour_Scheduler
            WHERE tourScheduleID = ?
            """;

        DBConnection db = new DBConnection();

        try (
                Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, tourScheduleID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return composeDepartureAt(
                            rs.getTimestamp("startDate"),
                            rs.getTime("departureTime")
                    );
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
            JOIN [Role] r
                ON u.roleID = r.roleID
            WHERE r.roleName IN (N'TourGuide', N'Tour Guide', N'Guide')
              AND u.[status] = N'Active'
            ORDER BY u.userID DESC
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

    public boolean isConfirmedTourBookingForAssignment(int bookingID) {
        String sql = """
            SELECT TOP 1 1
            FROM Booking b
            OUTER APPLY (
                SELECT TOP 1 *
                FROM Booking_Detail bdInner
                WHERE bdInner.bookingID = b.bookingID
                ORDER BY bdInner.bookingDetailID ASC
            ) bd
            WHERE b.bookingID = ?
              AND bd.tourScheduleID IS NOT NULL
              AND UPPER(LTRIM(RTRIM(ISNULL(b.bookingType, N'')))) = N'TOUR'
              AND (
                  """ + ASSIGNABLE_TOUR_BOOKING_STATUS_CONDITION + """
              )
            """;

        DBConnection db = new DBConnection();

        try (
                Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, bookingID);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean hasAssignmentForSameTourGuide(int tourScheduleID, int guideID, int excludedAssignmentID) {
        if (tourScheduleID <= 0 || guideID <= 0) {
            return false;
        }

        String sql = """
            SELECT TOP 1 1
            FROM Tour_Assignments
            WHERE tourScheduleID = ?
              AND userID = ?
              AND (? <= 0 OR assignmentID <> ?)
            """;

        DBConnection db = new DBConnection();

        try (
                Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, tourScheduleID);
            ps.setInt(2, guideID);
            ps.setInt(3, excludedAssignmentID);
            ps.setInt(4, excludedAssignmentID);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean hasAssignmentForSameTourCustomer(int tourScheduleID, int bookingID, int excludedAssignmentID) {
        if (tourScheduleID <= 0 || bookingID <= 0) {
            return false;
        }

        String sql = """
            SELECT TOP 1 1
            FROM Booking candidateBooking
            JOIN Tour_Assignments assignedTour
                ON assignedTour.tourScheduleID = ?
            JOIN Booking assignedBooking
                ON assignedTour.bookingID = assignedBooking.bookingID
            WHERE candidateBooking.bookingID = ?
              AND (? <= 0 OR assignedTour.assignmentID <> ?)
              AND (
                  assignedTour.bookingID = candidateBooking.bookingID
                  OR (
                      candidateBooking.userID IS NOT NULL
                      AND assignedBooking.userID = candidateBooking.userID
                  )
                  OR (
                      NULLIF(LOWER(LTRIM(RTRIM(ISNULL(candidateBooking.email, N'')))), N'') IS NOT NULL
                      AND LOWER(LTRIM(RTRIM(ISNULL(assignedBooking.email, N'')))) =
                          LOWER(LTRIM(RTRIM(ISNULL(candidateBooking.email, N''))))
                  )
                  OR (
                      NULLIF(LTRIM(RTRIM(ISNULL(candidateBooking.phone, N''))), N'') IS NOT NULL
                      AND LTRIM(RTRIM(ISNULL(assignedBooking.phone, N''))) =
                          LTRIM(RTRIM(ISNULL(candidateBooking.phone, N'')))
                  )
              )
            """;

        DBConnection db = new DBConnection();

        try (
                Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, tourScheduleID);
            ps.setInt(2, bookingID);
            ps.setInt(3, excludedAssignmentID);
            ps.setInt(4, excludedAssignmentID);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean hasOverlappingAssignmentForGuide(int tourScheduleID, int guideID, int excludedAssignmentID) {
        if (tourScheduleID <= 0 || guideID <= 0) {
            return false;
        }

        String sql = """
            SELECT TOP 1 1
            FROM Tour_Scheduler candidateSchedule
            JOIN Tour_Assignments assignedTour
                ON assignedTour.userID = ?
               AND (? <= 0 OR assignedTour.assignmentID <> ?)
            JOIN Tour_Scheduler assignedSchedule
                ON assignedTour.tourScheduleID = assignedSchedule.tourScheduleID
            WHERE candidateSchedule.tourScheduleID = ?
              AND LTRIM(RTRIM(ISNULL(assignedTour.assignmentStatus, N''))) NOT IN
                  (N'Cancelled', N'Rejected', N'Đã hủy', N'Từ chối')
              AND CONVERT(date, candidateSchedule.startDate) <=
                  CONVERT(date, ISNULL(assignedSchedule.endDate, assignedSchedule.startDate))
              AND CONVERT(date, ISNULL(candidateSchedule.endDate, candidateSchedule.startDate)) >=
                  CONVERT(date, assignedSchedule.startDate)
            """;

        DBConnection db = new DBConnection();

        try (
                Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, guideID);
            ps.setInt(2, excludedAssignmentID);
            ps.setInt(3, excludedAssignmentID);
            ps.setInt(4, tourScheduleID);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public List<AssignmentView> getAssignmentsByGuide(int guideID) {
        List<AssignmentView> list = new ArrayList<>();

        String sql = ASSIGNMENT_SELECT + """
            WHERE ta.userID = ?
            ORDER BY ts.startDate ASC, ta.assignedAt DESC, ta.assignmentID DESC
            """;

        DBConnection db = new DBConnection();

        try (
                Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, guideID);

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

    public boolean confirmAssignmentForGuide(int assignmentID, int guideID) {
        String sql = """
            UPDATE Tour_Assignments
            SET
                assignmentStatus = N'Confirmed',
                acceptedAt = CASE WHEN acceptedAt IS NULL THEN GETDATE() ELSE acceptedAt END,
                confirmedAt = CASE WHEN confirmedAt IS NULL THEN GETDATE() ELSE confirmedAt END,
                updatedAt = GETDATE()
            WHERE assignmentID = ?
              AND userID = ?
              AND LTRIM(RTRIM(ISNULL(assignmentStatus, N'Pending')))
                  IN (N'Pending', N'Assigned', N'Accepted')
            """;

        DBConnection db = new DBConnection();

        try (
                Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, assignmentID);
            ps.setInt(2, guideID);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean updateAssignmentStatusFromProgressForGuide(
            int assignmentID,
            int guideID,
            String status) {

        String updateAssignmentSql = """
            UPDATE Tour_Assignments
            SET
                assignmentStatus = ?,
                actualStartAt = CASE WHEN ? = N'In Progress' AND actualStartAt IS NULL THEN GETDATE() ELSE actualStartAt END,
                actualEndAt = CASE WHEN ? = N'Completed' AND actualEndAt IS NULL THEN GETDATE() ELSE actualEndAt END,
                completedAt = CASE WHEN ? = N'Completed' AND completedAt IS NULL THEN GETDATE() ELSE completedAt END,
                updatedAt = GETDATE()
            WHERE assignmentID = ?
              AND userID = ?
              AND LTRIM(RTRIM(ISNULL(assignmentStatus, N''))) IN (N'Accepted', N'Confirmed', N'In Progress')
            """;

        String endBookingSql = """
            UPDATE b
            SET b.[status] = ?, b.updatedAt = GETDATE()
            FROM Booking b
            INNER JOIN Booking_Detail bd ON bd.bookingID = b.bookingID
            INNER JOIN Tour_Assignments ta ON ta.tourScheduleID = bd.tourScheduleID
            WHERE ta.assignmentID = ?
              AND ta.userID = ?
              AND (
                    (ta.bookingID IS NOT NULL AND ta.bookingID > 0 AND b.bookingID = ta.bookingID)
                    OR (ta.bookingID IS NULL OR ta.bookingID = 0)
                  )
              AND LTRIM(RTRIM(ISNULL(b.[status], N''))) IN (
                    N'Pending', N'Đang xử lý', N'Đang thanh toán', N'Đang đợi chuyển khoản',
                    N'Completed', N'Hoàn thành', N'Confirmed', N'Đã duyệt',
                    N'End', N'Ended', N'Tour kết thúc', N'Đã kết thúc'
                  )
            """;

        String normalizedStatus = normalize(status, "In Progress");
        DBConnection db = new DBConnection();

        try (Connection conn = db.getConnection()) {
            conn.setAutoCommit(false);
            try {
                try (PreparedStatement ps = conn.prepareStatement(updateAssignmentSql)) {
                    int index = 1;
                    ps.setString(index++, normalizedStatus);
                    ps.setString(index++, normalizedStatus);
                    ps.setString(index++, normalizedStatus);
                    ps.setString(index++, normalizedStatus);
                    ps.setInt(index++, assignmentID);
                    ps.setInt(index, guideID);

                    if (ps.executeUpdate() == 0) {
                        conn.rollback();
                        return false;
                    }
                }

                if ("Completed".equalsIgnoreCase(normalizedStatus)) {
                    try (PreparedStatement ps = conn.prepareStatement(endBookingSql)) {
                        ps.setNString(1, Booking.STATUS_ENDED);
                        ps.setInt(2, assignmentID);
                        ps.setInt(3, guideID);

                        if (ps.executeUpdate() == 0) {
                            conn.rollback();
                            return false;
                        }
                    }
                }

                conn.commit();
                return true;
            } catch (Exception e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
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
        a.setBookingID(rs.getInt("bookingID"));
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

        a.setBookingCode(rs.getString("bookingCode"));
        a.setBookingType(rs.getString("bookingType"));
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
        Timestamp departureAt = composeDepartureAt(
                rs.getTimestamp("startDate"),
                rs.getTime("departureTime")
        );
        a.setPickupTime(minutesBefore(departureAt, 30));
        a.setCheckInDeadline(minutesBefore(departureAt, 10));
        a.setMaxParticipants(rs.getInt("maxParticipants"));
        a.setBookedQuantity(rs.getInt("bookedQuantity"));

        return a;
    }

    private Timestamp composeDepartureAt(Timestamp startDate, Time departureTime) {
        if (startDate == null) {
            return null;
        }

        LocalDateTime startDateTime = startDate.toLocalDateTime();
        LocalDate date = startDateTime.toLocalDate();
        LocalTime time = departureTime == null
                ? startDateTime.toLocalTime()
                : departureTime.toLocalTime();

        if (departureTime == null && LocalTime.MIDNIGHT.equals(time)) {
            return null;
        }

        return Timestamp.valueOf(LocalDateTime.of(date, time));
    }

    private Timestamp minutesBefore(Timestamp baseTime, int minutes) {
        if (baseTime == null) {
            return null;
        }

        return Timestamp.valueOf(baseTime.toLocalDateTime().minusMinutes(minutes));
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

    private void setNullableInt(PreparedStatement ps, int index, int value) throws Exception {
        if (value > 0) {
            ps.setInt(index, value);
        } else {
            ps.setNull(index, Types.INTEGER);
        }
    }

    private void setNullableTimestamp(PreparedStatement ps, int index, java.util.Date value) throws Exception {
        if (value == null) {
            ps.setNull(index, Types.TIMESTAMP);
            return;
        }

        ps.setTimestamp(index, new Timestamp(value.getTime()));
    }

    private String blankToNull(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }

        return value.trim();
    }

    private String normalize(String value, String fallback) {
        String normalized = blankToNull(value);
        return normalized == null ? fallback : normalized;
    }
}
