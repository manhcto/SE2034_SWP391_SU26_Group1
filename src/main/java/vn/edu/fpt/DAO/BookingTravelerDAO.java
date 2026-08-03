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
        ensureTravelersForAssignment(assignmentID);

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
                bt.note,
                CASE
                    WHEN bt.travelerID = (
                        SELECT MIN(bt2.travelerID)
                        FROM Booking_Traveler bt2
                        WHERE bt2.bookingID = bt.bookingID
                    ) THEN 1
                    ELSE 0
                END AS booker
            FROM Tour_Assignments ta
            JOIN Tour_Assignment_Booking tab ON tab.assignmentID = ta.assignmentID
            JOIN Booking b ON b.bookingID = tab.bookingID AND b.bookingType = N'Tour'
            JOIN Booking_Traveler bt
                ON bt.bookingID = b.bookingID
            WHERE ta.assignmentID = ?
            ORDER BY b.bookingCode, booker DESC, bt.travelerType, bt.fullName
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
            String fullName,
            String phone,
            String note) {

        String sql = """
            UPDATE bt
            SET
                bt.fullName = CASE
                    WHEN bt.travelerID = (
                        SELECT MIN(bt2.travelerID)
                        FROM Booking_Traveler bt2
                        WHERE bt2.bookingID = bt.bookingID
                    )
                    OR ? IS NULL
                    OR LTRIM(RTRIM(?)) = N''
                    THEN bt.fullName
                    ELSE LTRIM(RTRIM(?))
                END,
                bt.phone = CASE
                    WHEN bt.travelerID = (
                        SELECT MIN(bt2.travelerID)
                        FROM Booking_Traveler bt2
                        WHERE bt2.bookingID = bt.bookingID
                    )
                    THEN bt.phone
                    ELSE ?
                END,
                bt.travelerStatus = ?,
                bt.note = ?
            FROM Booking_Traveler bt
            JOIN Tour_Assignments ta
                ON ta.assignmentID = ?
            WHERE ta.userID = ?
              AND bt.travelerID = ?
              AND EXISTS (
                  SELECT 1 FROM Tour_Assignment_Booking tab
                  WHERE tab.assignmentID = ta.assignmentID AND tab.bookingID = bt.bookingID
              )
            """;

        DBConnection db = new DBConnection();

        try (
                Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            int index = 1;
            ps.setString(index++, blankToNull(fullName));
            ps.setString(index++, blankToNull(fullName));
            ps.setString(index++, blankToNull(fullName));
            ps.setString(index++, blankToNull(phone));
            ps.setString(index++, normalizeTravelerStatus(travelerStatus));
            ps.setString(index++, blankToNull(note));
            ps.setInt(index++, assignmentID);
            ps.setInt(index++, guideID);
            ps.setInt(index, travelerID);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    private void ensureTravelersForAssignment(int assignmentID) {
        String bookingSql = """
            SELECT DISTINCT
                b.bookingID,
                b.bookingCode,
                LTRIM(RTRIM(ISNULL(b.firstName, N'') + N' ' + ISNULL(b.lastName, N''))) AS customerName,
                b.phone,
                ISNULL(b.numberAdult, 0) AS numberAdult,
                ISNULL(b.numberChildren, 0) AS numberChildren
            FROM Tour_Assignments ta
            JOIN Tour_Assignment_Booking tab ON tab.assignmentID = ta.assignmentID
            JOIN Booking b ON b.bookingID = tab.bookingID
            WHERE ta.assignmentID = ?
              AND UPPER(LTRIM(RTRIM(ISNULL(b.bookingType, N'')))) = N'TOUR'
            ORDER BY b.bookingID
            """;

        String countTravelerSql = """
            SELECT COUNT(1)
            FROM Booking_Traveler
            WHERE bookingID = ?
            """;

        String insertTravelerSql = """
            INSERT INTO Booking_Traveler
                (bookingID, fullName, gender, travelerType, phone, travelerStatus, note)
            VALUES
                (?, ?, NULL, ?, ?, N'Pending', N'Tự tạo từ số lượng khách trong booking')
            """;

        DBConnection db = new DBConnection();

        try (Connection conn = db.getConnection()) {
            List<TravelerSeed> seeds = new ArrayList<>();

            try (PreparedStatement ps = conn.prepareStatement(bookingSql)) {
                ps.setInt(1, assignmentID);

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        seeds.add(new TravelerSeed(
                                rs.getInt("bookingID"),
                                rs.getString("bookingCode"),
                                rs.getString("customerName"),
                                rs.getString("phone"),
                                rs.getInt("numberAdult"),
                                rs.getInt("numberChildren")
                        ));
                    }
                }
            }

            for (TravelerSeed seed : seeds) {
                if (countTravelers(conn, countTravelerSql, seed.bookingID) > 0) {
                    continue;
                }

                createDefaultTravelers(conn, insertTravelerSql, seed);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private int countTravelers(Connection conn, String sql, int bookingID) throws Exception {
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingID);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    private void createDefaultTravelers(Connection conn, String sql, TravelerSeed seed) throws Exception {
        int adults = Math.max(seed.numberAdult, 0);
        int children = Math.max(seed.numberChildren, 0);

        for (int i = 1; i <= adults; i++) {
            String fullName = i == 1 && !isBlank(seed.customerName)
                    ? seed.customerName
                    : "Người lớn " + i + " - " + safeBookingCode(seed);

            insertDefaultTraveler(conn, sql, seed.bookingID, fullName, "Người lớn", i == 1 ? seed.phone : null);
        }

        for (int i = 1; i <= children; i++) {
            String fullName = "Trẻ em " + i + " - " + safeBookingCode(seed);
            insertDefaultTraveler(conn, sql, seed.bookingID, fullName, "Trẻ em", null);
        }
    }

    private void insertDefaultTraveler(
            Connection conn,
            String sql,
            int bookingID,
            String fullName,
            String travelerType,
            String phone) throws Exception {

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingID);
            ps.setString(2, fullName);
            ps.setString(3, travelerType);
            ps.setString(4, blankToNull(phone));
            ps.executeUpdate();
        }
    }

    private String safeBookingCode(TravelerSeed seed) {
        return isBlank(seed.bookingCode) ? "Booking #" + seed.bookingID : seed.bookingCode;
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
        traveler.setBooker(rs.getBoolean("booker"));
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

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private static class TravelerSeed {
        private final int bookingID;
        private final String bookingCode;
        private final String customerName;
        private final String phone;
        private final int numberAdult;
        private final int numberChildren;

        private TravelerSeed(
                int bookingID,
                String bookingCode,
                String customerName,
                String phone,
                int numberAdult,
                int numberChildren) {
            this.bookingID = bookingID;
            this.bookingCode = bookingCode;
            this.customerName = customerName;
            this.phone = phone;
            this.numberAdult = numberAdult;
            this.numberChildren = numberChildren;
        }
    }
}
