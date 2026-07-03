package vn.edu.fpt.DAO;

import vn.edu.fpt.common.DBConnection;
import vn.edu.fpt.model.AssignmentView;
import vn.edu.fpt.model.TourAssignments;
import vn.edu.fpt.model.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AssignmentDAOImpl {
    public List<AssignmentView> getAllAssignments() {

        List<AssignmentView> list = new ArrayList<>();

        String sql = """
            SELECT
                ta.assignmentID,
                b.bookingID,
                t.tourName,
                CONCAT(u.firstName, ' ', u.lastName) AS guideName,
                ts.startDate,
                b.status AS bookingStatus
            
            FROM Tour_Assignments ta
            
            JOIN Tour_Scheduler ts
                ON ta.tourScheduleID = ts.tourScheduleID
            
            JOIN Tour t
                ON ts.tourID = t.tourID
            
            JOIN [User] u
                ON ta.userID = u.userID
            
            LEFT JOIN Booking_Detail bd
                ON bd.tourScheduleID = ts.tourScheduleID
            
            LEFT JOIN Booking b
                ON b.bookingID = bd.bookingID

            ORDER BY ta.assignmentID DESC
            """;
        DBConnection db = new DBConnection();
        try (
                Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {

            while (rs.next()) {

                AssignmentView a = new AssignmentView();

                a.setAssignmentID(rs.getInt("assignmentID"));

                a.setBookingID(rs.getInt("bookingID"));

                a.setTourName(rs.getString("tourName"));

                a.setGuideName(rs.getString("guideName"));

                a.setDepartureDate(rs.getDate("startDate"));

                list.add(a);
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

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                TourAssignments ta = new TourAssignments();

                ta.setAssignmentID(rs.getInt("assignmentID"));

                ta.setTourScheduleID(rs.getInt("tourScheduleID"));

                ta.setUserID(rs.getInt("userID"));

                ta.setRoleInTour( rs.getString("roleInTour"));

                return ta;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
    public boolean addAssignment(
            TourAssignments assignment) {

        String sql = """
            INSERT INTO Tour_Assignments
            (
                tourScheduleID,
                userID,
                roleInTour
            )
            VALUES
            (
                ?, ?, ?
            )
            """;
        DBConnection db = new DBConnection();
        try (
                Connection conn = db.getConnection();
                PreparedStatement ps =
                        conn.prepareStatement(sql)
        ) {

            ps.setInt(
                    1,
                    assignment.getTourScheduleID());

            ps.setInt(
                    2,
                    assignment.getUserID());

            ps.setString(
                    3,
                    assignment.getRoleInTour());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
    public boolean updateAssignment(
            TourAssignments assignment) {

        String sql = """
            UPDATE Tour_Assignments
            SET
                tourScheduleID = ?,
                userID = ?,
                roleInTour = ?
            WHERE assignmentID = ?
            """;
        DBConnection db = new DBConnection();
        try (
                Connection conn = db.getConnection();
                PreparedStatement ps =
                        conn.prepareStatement(sql)
        ) {

            ps.setInt(
                    1,
                    assignment.getTourScheduleID());

            ps.setInt(
                    2,
                    assignment.getUserID());

            ps.setString(
                    3,
                    assignment.getRoleInTour());

            ps.setInt(
                    4,
                    assignment.getAssignmentID());

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
                PreparedStatement ps =
                        conn.prepareStatement(sql)
        ) {

            ps.setInt(1, id);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
    public AssignmentView getAssignmentDetail(int id) {

        String sql = """
        SELECT
            ta.assignmentID,
            b.bookingID,
            t.tourName,
            CONCAT(u.firstName,' ',u.lastName) AS guideName,
            ts.startDate,
            b.status
        FROM Tour_Assignments ta

        JOIN Tour_Scheduler ts
            ON ta.tourScheduleID = ts.tourScheduleID

        JOIN Tour t
            ON ts.tourID = t.tourID

        JOIN [User] u
            ON ta.userID = u.userID

        LEFT JOIN Booking_Detail bd
            ON bd.tourScheduleID = ts.tourScheduleID

        LEFT JOIN Booking b
            ON b.bookingID = bd.bookingID

        WHERE ta.assignmentID = ?
        """;

        DBConnection db = new DBConnection();

        try (
                Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                AssignmentView a = new AssignmentView();

                a.setAssignmentID(
                        rs.getInt("assignmentID"));

                a.setBookingID(
                        rs.getInt("bookingID"));

                a.setTourName(
                        rs.getString("tourName"));

                a.setGuideName(
                        rs.getString("guideName"));

                a.setDepartureDate(
                        rs.getDate("startDate"));

                a.setStatus(
                        rs.getString("status"));

                return a;
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
            t.tourName
        FROM Booking b
        JOIN Booking_Detail bd
            ON b.bookingID = bd.bookingID
        JOIN Tour_Scheduler ts
            ON bd.tourScheduleID = ts.tourScheduleID
        JOIN Tour t
            ON ts.tourID = t.tourID
        WHERE bd.tourScheduleID IS NOT NULL
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
                a.setTourName(rs.getString("tourName"));

                list.add(a);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
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
            u.status,
            u.roleID
        FROM [User] u
        JOIN [Role] r
            ON u.roleID = r.roleID
        WHERE r.roleName = N'Tour Guide'
          AND u.status = N'Active'
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

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt("tourScheduleID");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return -1;
    }

    public List<AssignmentView> getAssignmentsByGuide(int guideID) {

        List<AssignmentView> list = new ArrayList<>();

        String sql = """
        SELECT
            ta.assignmentID,
            b.bookingID,
            t.tourName,
            CONCAT(u.firstName, ' ', u.lastName) AS guideName,
            ts.startDate,
            b.status
        FROM Tour_Assignments ta

        JOIN Tour_Scheduler ts
            ON ta.tourScheduleID = ts.tourScheduleID

        JOIN Tour t
            ON ts.tourID = t.tourID

        JOIN [User] u
            ON ta.userID = u.userID

        LEFT JOIN Booking_Detail bd
            ON bd.tourScheduleID = ts.tourScheduleID

        LEFT JOIN Booking b
            ON b.bookingID = bd.bookingID

        WHERE ta.userID = ?

        ORDER BY ts.startDate ASC
    """;

        DBConnection db = new DBConnection();

        try (
                Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setInt(1, guideID);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                AssignmentView a = new AssignmentView();

                a.setAssignmentID(
                        rs.getInt("assignmentID"));

                a.setBookingID(
                        rs.getInt("bookingID"));

                a.setTourName(
                        rs.getString("tourName"));

                a.setGuideName(
                        rs.getString("guideName"));

                a.setDepartureDate(
                        rs.getDate("startDate"));

                a.setStatus(
                        rs.getString("status"));

                list.add(a);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean updateBookingStatus(int bookingID, String status) {

        String sql = """
        UPDATE Booking
        SET [status] = ?
        WHERE bookingID = ?
    """;

        DBConnection db = new DBConnection();

        try (
                Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, status);
            ps.setInt(2, bookingID);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}
