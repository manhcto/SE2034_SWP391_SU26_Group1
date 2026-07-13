package vn.edu.fpt.DAO;

import vn.edu.fpt.common.DBConnection;
import vn.edu.fpt.model.BookingTraveler;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class BookingTravelerDAO {

    public List<BookingTraveler> getTravelersByAssignment(int assignmentID) {
        List<BookingTraveler> travelers = new ArrayList<>();

        String sql = """
            SELECT DISTINCT
                bt.travelerID,
                bt.bookingID,
                b.bookingCode,
                bt.fullName,
                bt.gender,
                bt.dateOfBirth,
                bt.travelerType,
                bt.phone,
                bt.identityNumber,
                bt.travelerStatus,
                bt.note
            FROM Tour_Assignments ta
            JOIN Booking_Detail bd
                ON bd.tourScheduleID = ta.tourScheduleID
            JOIN Booking b
                ON b.bookingID = bd.bookingID
               AND b.bookingType = N'Tour'
            JOIN Booking_Traveler bt
                ON bt.bookingID = b.bookingID
            WHERE ta.assignmentID = ?
            ORDER BY b.bookingCode, bt.travelerType, bt.fullName
            """;

        DBConnection db = new DBConnection();

        try (
                Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, assignmentID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    travelers.add(mapTraveler(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return travelers;
    }

    public boolean updateTravelerStatusForGuide(
            int assignmentID,
            int guideID,
            int travelerID,
            String travelerStatus,
            String note) {

        String sql = """
            UPDATE bt
            SET
                bt.travelerStatus = ?,
                bt.note = ?
            FROM Booking_Traveler bt
            JOIN Booking_Detail bd
                ON bd.bookingID = bt.bookingID
            JOIN Tour_Assignments ta
                ON ta.tourScheduleID = bd.tourScheduleID
            WHERE ta.assignmentID = ?
              AND ta.userID = ?
              AND bt.travelerID = ?
            """;

        DBConnection db = new DBConnection();

        try (
                Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, normalizeTravelerStatus(travelerStatus));
            ps.setString(2, blankToNull(note));
            ps.setInt(3, assignmentID);
            ps.setInt(4, guideID);
            ps.setInt(5, travelerID);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    private BookingTraveler mapTraveler(ResultSet rs) throws Exception {
        BookingTraveler traveler = new BookingTraveler();

        traveler.setTravelerID(rs.getInt("travelerID"));
        traveler.setBookingID(rs.getInt("bookingID"));
        traveler.setBookingCode(rs.getString("bookingCode"));
        traveler.setFullName(rs.getString("fullName"));
        traveler.setGender(rs.getString("gender"));
        traveler.setDateOfBirth(rs.getDate("dateOfBirth"));
        traveler.setTravelerType(rs.getString("travelerType"));
        traveler.setPhone(rs.getString("phone"));
        traveler.setIdentityNumber(rs.getString("identityNumber"));
        traveler.setTravelerStatus(rs.getString("travelerStatus"));
        traveler.setNote(rs.getString("note"));

        return traveler;
    }

    private String normalizeTravelerStatus(String status) {
        if (status == null) {
            return "Pending";
        }

        return switch (status.trim()) {
            case "Pending", "Checked-in", "Absent", "Completed" -> status.trim();
            default -> "Pending";
        };
    }

    private String blankToNull(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }

        return value.trim();
    }
}
