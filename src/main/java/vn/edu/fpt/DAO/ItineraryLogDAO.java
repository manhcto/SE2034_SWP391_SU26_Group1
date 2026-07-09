package vn.edu.fpt.DAO;

import vn.edu.fpt.common.DBConnection;
import vn.edu.fpt.model.ItineraryLog;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class ItineraryLogDAO {

    public List<ItineraryLog> getLogsByAssignment(int assignmentID) {
        List<ItineraryLog> logs = new ArrayList<>();

        String sql = """
            SELECT
                l.progressLogID,
                l.tourScheduleID,
                l.assignmentID,
                l.loggedByUserID,
                LTRIM(RTRIM(ISNULL(u.firstName, N'') + N' ' + ISNULL(u.lastName, N''))) AS loggedByName,
                l.logTime,
                l.progressStatus,
                l.title,
                l.content
            FROM Tour_Progress_Log l
            LEFT JOIN [User] u
                ON l.loggedByUserID = u.userID
            WHERE l.assignmentID = ?
            ORDER BY l.logTime DESC, l.progressLogID DESC
            """;

        DBConnection db = new DBConnection();

        try (
                Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, assignmentID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    logs.add(mapLog(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return logs;
    }

    public List<ItineraryLog> getRecentLogsByGuide(int guideID, int limit) {
        List<ItineraryLog> logs = new ArrayList<>();
        int safeLimit = Math.max(1, Math.min(limit, 20));

        String sql = """
            SELECT TOP (%d)
                l.progressLogID,
                l.tourScheduleID,
                l.assignmentID,
                l.loggedByUserID,
                LTRIM(RTRIM(ISNULL(u.firstName, N'') + N' ' + ISNULL(u.lastName, N''))) AS loggedByName,
                l.logTime,
                l.progressStatus,
                l.title,
                l.content
            FROM Tour_Progress_Log l
            JOIN Tour_Assignments ta
                ON l.assignmentID = ta.assignmentID
            LEFT JOIN [User] u
                ON l.loggedByUserID = u.userID
            WHERE ta.userID = ?
            ORDER BY l.logTime DESC, l.progressLogID DESC
            """.formatted(safeLimit);

        DBConnection db = new DBConnection();

        try (
                Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, guideID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    logs.add(mapLog(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return logs;
    }

    public boolean addLogForGuide(
            int assignmentID,
            int guideID,
            String progressStatus,
            String title,
            String content) {

        String sql = """
            INSERT INTO Tour_Progress_Log
            (
                tourScheduleID,
                assignmentID,
                loggedByUserID,
                progressStatus,
                title,
                content
            )
            SELECT
                ta.tourScheduleID,
                ta.assignmentID,
                ?,
                ?,
                ?,
                ?
            FROM Tour_Assignments ta
            WHERE ta.assignmentID = ?
              AND ta.userID = ?
            """;

        DBConnection db = new DBConnection();

        try (
                Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)
        ) {
            ps.setInt(1, guideID);
            ps.setString(2, normalizeProgressStatus(progressStatus));
            ps.setString(3, blankToNull(title));
            ps.setString(4, blankToNull(content));
            ps.setInt(5, assignmentID);
            ps.setInt(6, guideID);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    private ItineraryLog mapLog(ResultSet rs) throws Exception {
        ItineraryLog log = new ItineraryLog();

        log.setProgressLogID(rs.getInt("progressLogID"));
        log.setTourScheduleID(rs.getInt("tourScheduleID"));
        log.setAssignmentID(rs.getInt("assignmentID"));
        log.setLoggedByUserID(rs.getInt("loggedByUserID"));
        log.setLoggedByName(rs.getString("loggedByName"));
        log.setLogTime(rs.getTimestamp("logTime"));
        log.setProgressStatus(rs.getString("progressStatus"));
        log.setTitle(rs.getString("title"));
        log.setContent(rs.getString("content"));

        return log;
    }

    private String normalizeProgressStatus(String status) {
        if (status == null) {
            return "Update";
        }

        return switch (status.trim()) {
            case "Pickup Completed",
                 "Departed",
                 "Arrived",
                 "Activity Completed",
                 "Returning",
                 "Completed",
                 "Issue",
                 "Update" -> status.trim();
            default -> "Update";
        };
    }

    private String blankToNull(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }

        return value.trim();
    }
}
