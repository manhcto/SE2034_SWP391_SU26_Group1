package vn.edu.fpt.DAO;

import vn.edu.fpt.common.DBConnection;
import vn.edu.fpt.model.ItineraryLog;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class ItineraryLogDAO {
    public boolean addProgressLog(ItineraryLog log) {
        String sql = """
            INSERT INTO Tour_Progress_Log
            (
                tourScheduleID,
                assignmentID,
                loggedByUserID,
                logTime,
                progressStatus,
                title,
                content
            )
            VALUES (?, ?, ?, GETDATE(), ?, ?, ?)
            """;

        DBConnection db = new DBConnection();

        try (
                Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, log.getTourScheduleID());
            ps.setInt(2, log.getAssignmentID());

            if (log.getLoggedByUserID() > 0) {
                ps.setInt(3, log.getLoggedByUserID());
            } else {
                ps.setNull(3, Types.INTEGER);
            }

            ps.setString(4, normalize(log.getProgressStatus(), "Update"));
            ps.setString(5, blankToNull(log.getTitle()));
            ps.setString(6, blankToNull(log.getContent()));

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public List<ItineraryLog> getLogsByAssignmentForGuide(int assignmentID, int guideID) {
        List<ItineraryLog> list = new ArrayList<>();

        String sql = """
            SELECT
                l.progressLogID,
                l.tourScheduleID,
                l.assignmentID,
                l.loggedByUserID,
                l.logTime,
                l.progressStatus,
                l.title,
                l.content,
                ta.assignmentCode,
                t.tourName
            FROM Tour_Progress_Log l
            JOIN Tour_Assignments ta
                ON l.assignmentID = ta.assignmentID
            JOIN Tour_Scheduler ts
                ON l.tourScheduleID = ts.tourScheduleID
            JOIN Tour t
                ON ts.tourID = t.tourID
            WHERE l.assignmentID = ?
              AND ta.userID = ?
            ORDER BY l.logTime DESC, l.progressLogID DESC
            """;

        DBConnection db = new DBConnection();

        try (
                Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, assignmentID);
            ps.setInt(2, guideID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapLog(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<ItineraryLog> getRecentLogsByGuide(int guideID, int limit) {
        List<ItineraryLog> list = new ArrayList<>();

        String sql = """
            SELECT TOP (?)
                l.progressLogID,
                l.tourScheduleID,
                l.assignmentID,
                l.loggedByUserID,
                l.logTime,
                l.progressStatus,
                l.title,
                l.content,
                ta.assignmentCode,
                t.tourName
            FROM Tour_Progress_Log l
            JOIN Tour_Assignments ta
                ON l.assignmentID = ta.assignmentID
            JOIN Tour_Scheduler ts
                ON l.tourScheduleID = ts.tourScheduleID
            JOIN Tour t
                ON ts.tourID = t.tourID
            WHERE ta.userID = ?
            ORDER BY l.logTime DESC, l.progressLogID DESC
            """;

        DBConnection db = new DBConnection();

        try (
                Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, Math.max(1, limit));
            ps.setInt(2, guideID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapLog(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    private ItineraryLog mapLog(ResultSet rs) throws Exception {
        ItineraryLog log = new ItineraryLog();

        log.setProgressLogID(rs.getInt("progressLogID"));
        log.setTourScheduleID(rs.getInt("tourScheduleID"));
        log.setAssignmentID(rs.getInt("assignmentID"));
        log.setLoggedByUserID(rs.getInt("loggedByUserID"));
        log.setLogTime(rs.getTimestamp("logTime"));
        log.setProgressStatus(rs.getString("progressStatus"));
        log.setTitle(rs.getString("title"));
        log.setContent(rs.getString("content"));
        log.setAssignmentCode(rs.getString("assignmentCode"));
        log.setTourName(rs.getString("tourName"));

        return log;
    }

    private String normalize(String value, String defaultValue) {
        if (value == null || value.trim().isEmpty()) {
            return defaultValue;
        }

        return value.trim();
    }

    private String blankToNull(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }

        return value.trim();
    }
}
