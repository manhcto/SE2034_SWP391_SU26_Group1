package vn.edu.fpt.DAO;

import vn.edu.fpt.common.DBConnection;
import vn.edu.fpt.model.Tour;
import vn.edu.fpt.model.TourSchedule;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TourScheduleDAO {

    private static Boolean scheduleTransportTypeColumnAvailable;

    // Lấy toàn bộ lịch của một tour để Staff/Admin xem chi tiết.
    public List<TourSchedule> getSchedulesByTourId(int tourID) {
        List<TourSchedule> schedules = new ArrayList<>();
        boolean hasTransportColumn = hasScheduleTransportTypeColumn();

        String sql = """
                SELECT
                    tourScheduleID, tourID, %s startDate, endDate, departureTime, expectedReturnTime,
                    bookingDeadline, minParticipants, maxParticipants, quantity, bookedSeats,
                    maxParticipantsPerBooking, adultPrice, childPrice, infantPrice,
                    singleRoomSurcharge, depositPercent, cancellationPolicy,
                    scheduleStatus, createdAt, updatedAt
                FROM Tour_Scheduler
                WHERE tourID = ?
                ORDER BY startDate ASC, tourScheduleID ASC
                """.formatted(scheduleTransportSelectFragment(hasTransportColumn));

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, tourID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    schedules.add(mapSchedule(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return schedules;
    }

    public List<TourSchedule> getSchedulesForStaffOverview() {
        List<TourSchedule> schedules = new ArrayList<>();
        boolean hasTransportColumn = hasScheduleTransportTypeColumn();
        String transportColumn = hasTransportColumn
                ? "ts.scheduleTransportType AS scheduleTransportType, "
                : "CAST(NULL AS NVARCHAR(50)) AS scheduleTransportType, ";

        String sql = """
                SELECT
                    ts.tourScheduleID, ts.tourID, %s ts.startDate, ts.endDate,
                    ts.departureTime, ts.expectedReturnTime, ts.bookingDeadline,
                    ts.minParticipants, ts.maxParticipants, ts.quantity, ts.bookedSeats,
                    ts.maxParticipantsPerBooking, ts.adultPrice, ts.childPrice, ts.infantPrice,
                    ts.singleRoomSurcharge, ts.depositPercent, ts.cancellationPolicy,
                    ts.scheduleStatus, ts.createdAt, ts.updatedAt,
                    t.tourName, t.tourCode, t.[status] AS tourStatus,
                    t.startPlace, t.endPlace, t.mainTransportType
                FROM Tour_Scheduler ts
                JOIN Tour t ON t.tourID = ts.tourID
                ORDER BY
                    CASE WHEN ts.startDate >= CAST(GETDATE() AS DATE) THEN 0 ELSE 1 END,
                    ts.startDate ASC,
                    ts.tourScheduleID ASC
                """.formatted(transportColumn);

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                schedules.add(mapSchedule(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return schedules;
    }


    private boolean hasScheduleTransportTypeColumn() {
        // Một số database cũ có thể chưa chạy migration thêm scheduleTransportType.
        // Cache kết quả để không query INFORMATION_SCHEMA nhiều lần trong một request/app run.
        if (scheduleTransportTypeColumnAvailable != null) {
            return scheduleTransportTypeColumnAvailable;
        }

        String sql = """
                SELECT 1
                FROM INFORMATION_SCHEMA.COLUMNS
                WHERE TABLE_NAME = 'Tour_Scheduler'
                  AND COLUMN_NAME = 'scheduleTransportType'
                """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            scheduleTransportTypeColumnAvailable = rs.next();
            return scheduleTransportTypeColumnAvailable;
        } catch (Exception e) {
            e.printStackTrace();
        }
        scheduleTransportTypeColumnAvailable = false;
        return false;
    }

    private String scheduleTransportSelectFragment(boolean supported) {
        return supported ? "scheduleTransportType, " : "CAST(NULL AS NVARCHAR(50)) AS scheduleTransportType, ";
    }


    public boolean syncOpenSchedulesWithTourStatus(Tour tour) {
        if (tour == null || tour.getTourID() <= 0 || "Active".equals(tour.getStatus())) {
            return true;
        }

        String forcedStatus = "Inactive".equals(tour.getStatus()) ? "Closed" : "Planned";
        String sql = """
                UPDATE Tour_Scheduler
                SET scheduleStatus = ?, updatedAt = GETDATE()
                WHERE tourID = ?
                  AND scheduleStatus = N'Open'
                """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, forcedStatus);
            ps.setInt(2, tour.getTourID());
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean syncOpenSchedulesWithTourStatuses() {
        String sql = """
                UPDATE ts
                SET scheduleStatus = CASE WHEN t.[status] = N'Inactive' THEN N'Closed' ELSE N'Planned' END,
                    updatedAt = GETDATE()
                FROM Tour_Scheduler ts
                JOIN Tour t ON t.tourID = ts.tourID
                WHERE ts.scheduleStatus = N'Open'
                  AND t.[status] <> N'Active'
                """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public TourSchedule getScheduleById(int tourScheduleID) {
        boolean hasTransportColumn = hasScheduleTransportTypeColumn();
        String sql = """
                SELECT
                    tourScheduleID, tourID, %s startDate, endDate, departureTime, expectedReturnTime,
                    bookingDeadline, minParticipants, maxParticipants, quantity, bookedSeats,
                    maxParticipantsPerBooking, adultPrice, childPrice, infantPrice,
                    singleRoomSurcharge, depositPercent, cancellationPolicy,
                    scheduleStatus, createdAt, updatedAt
                FROM Tour_Scheduler
                WHERE tourScheduleID = ?
                """.formatted(scheduleTransportSelectFragment(hasTransportColumn));

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, tourScheduleID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapSchedule(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean insertTourSchedule(TourSchedule schedule) {
        boolean hasTransportColumn = hasScheduleTransportTypeColumn();
        // Nếu DB có cột scheduleTransportType thì insert thêm cột đó, nếu không thì bỏ qua.
        String transportColumn = hasTransportColumn ? "scheduleTransportType, " : "";
        String transportValue = hasTransportColumn ? "?, " : "";
        String sql = """
                INSERT INTO Tour_Scheduler (
                    tourID, %s startDate, endDate, departureTime, expectedReturnTime,
                    bookingDeadline, minParticipants, maxParticipants, quantity, bookedSeats,
                    maxParticipantsPerBooking, adultPrice, childPrice, infantPrice,
                    singleRoomSurcharge, depositPercent, cancellationPolicy,
                    scheduleStatus, createdAt, updatedAt
                ) VALUES (
                    ?, %s ?, ?, ?, ?, ?, ?, ?, 0, 0, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), NULL
                )
                """.formatted(transportColumn, transportValue);

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            bindScheduleForInsertOrUpdate(ps, schedule, false, hasTransportColumn);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean updateTourSchedule(TourSchedule schedule) {
        boolean hasTransportColumn = hasScheduleTransportTypeColumn();
        // Cùng một câu UPDATE, chỉ thêm phần set phương tiện khi DB có cột tương ứng.
        String transportSet = hasTransportColumn ? "scheduleTransportType = ?, " : "";
        String sql = """
                UPDATE Tour_Scheduler
                SET %s startDate = ?, endDate = ?, departureTime = ?, expectedReturnTime = ?,
                    bookingDeadline = ?, minParticipants = ?, maxParticipants = ?,
                    maxParticipantsPerBooking = ?, adultPrice = ?, childPrice = ?, infantPrice = ?,
                    singleRoomSurcharge = ?, depositPercent = ?, cancellationPolicy = ?,
                    scheduleStatus = ?, updatedAt = GETDATE()
                WHERE tourScheduleID = ?
                """.formatted(transportSet);

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            bindScheduleForInsertOrUpdate(ps, schedule, true, hasTransportColumn);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean updateTourScheduleLimited(TourSchedule schedule) {
        String sql = """
                UPDATE Tour_Scheduler
                SET departureTime = ?, expectedReturnTime = ?, bookingDeadline = ?,
                    minParticipants = ?, maxParticipants = ?, maxParticipantsPerBooking = ?,
                    cancellationPolicy = ?, scheduleStatus = ?, updatedAt = GETDATE()
                WHERE tourScheduleID = ?
                  AND ? <= maxParticipants
                """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            setNullableTime(ps, 1, schedule.getDepartureTime());
            setNullableTime(ps, 2, schedule.getExpectedReturnTime());
            setNullableTimestamp(ps, 3, schedule.getBookingDeadline());
            ps.setInt(4, schedule.getMinParticipants());
            ps.setInt(5, schedule.getMaxParticipants());
            ps.setInt(6, schedule.getMaxParticipantsPerBooking() <= 0 ? 10 : schedule.getMaxParticipantsPerBooking());
            setNullableString(ps, 7, schedule.getCancellationPolicy());
            ps.setString(8, isBlank(schedule.getScheduleStatus()) ? "Open" : schedule.getScheduleStatus());
            ps.setInt(9, schedule.getTourScheduleID());
            ps.setInt(10, schedule.getQuantity());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean changeTourScheduleStatus(int tourScheduleID, String scheduleStatus) {
        String sql = """
                UPDATE Tour_Scheduler
                SET scheduleStatus = ?, updatedAt = GETDATE()
                WHERE tourScheduleID = ?
                """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, scheduleStatus);
            ps.setInt(2, tourScheduleID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean closeTourSchedule(int tourScheduleID) {
        String sql = """
                UPDATE Tour_Scheduler
                SET scheduleStatus = N'Closed', updatedAt = GETDATE()
                WHERE tourScheduleID = ?
                  AND scheduleStatus IN (N'Open', N'Planned')
                """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, tourScheduleID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean isDuplicateScheduleStartDate(int tourID, int currentScheduleID, Timestamp startDate) {
        if (startDate == null) {
            return false;
        }

        String sql = """
                SELECT 1
                FROM Tour_Scheduler
                WHERE tourID = ?
                  AND tourScheduleID <> ?
                  AND CONVERT(date, startDate) = CONVERT(date, ?)
                  AND scheduleStatus <> N'Cancelled'
                """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, tourID);
            ps.setInt(2, currentScheduleID);
            ps.setTimestamp(3, startDate);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public Map<String, Boolean> getDuplicateScheduleStartDateMap(int tourID) {
        Map<String, Boolean> duplicateDates = new HashMap<>();
        String sql = """
                SELECT CONVERT(date, startDate) AS dateKey
                FROM Tour_Scheduler
                WHERE tourID = ?
                  AND scheduleStatus <> N'Cancelled'
                GROUP BY CONVERT(date, startDate)
                HAVING COUNT(*) > 1
                """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, tourID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    java.sql.Date date = rs.getDate("dateKey");
                    if (date != null) {
                        duplicateDates.put(date.toLocalDate().toString(), Boolean.TRUE);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return duplicateDates;
    }

    public boolean isScheduleStartDateTooClose(int tourID, int currentScheduleID, Timestamp startDate, int minGapDays) {
        if (startDate == null) {
            return false;
        }

        String sql = """
                SELECT 1
                FROM Tour_Scheduler
                WHERE tourID = ?
                  AND tourScheduleID <> ?
                  AND scheduleStatus <> N'Cancelled'
                  AND ABS(DATEDIFF(day, CONVERT(date, startDate), CONVERT(date, ?))) < ?
                """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, tourID);
            ps.setInt(2, currentScheduleID);
            ps.setTimestamp(3, startDate);
            ps.setInt(4, Math.max(1, minGapDays));

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public List<TourSchedule> getAvailableSchedulesForCustomerByTourId(int tourID, int limit) {
        List<TourSchedule> schedules = new ArrayList<>();
        boolean hasTransportColumn = hasScheduleTransportTypeColumn();
        int safeLimit = limit <= 0 ? 50 : Math.min(limit, 100);

        String sql = """
                SELECT
                    tourScheduleID, tourID, %s startDate, endDate, departureTime, expectedReturnTime,
                    bookingDeadline, minParticipants, maxParticipants, quantity, bookedSeats,
                    maxParticipantsPerBooking, adultPrice, childPrice, infantPrice,
                    singleRoomSurcharge, depositPercent, cancellationPolicy,
                    scheduleStatus, createdAt, updatedAt
                FROM Tour_Scheduler
                WHERE tourID = ?
                  AND scheduleStatus = N'Open'
                  AND startDate >= CAST(GETDATE() AS date)
                  AND ISNULL(quantity, 0) < ISNULL(maxParticipants, 0)
                ORDER BY startDate ASC, tourScheduleID ASC
                OFFSET 0 ROWS FETCH NEXT %d ROWS ONLY
                """.formatted(scheduleTransportSelectFragment(hasTransportColumn), safeLimit);

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, tourID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    schedules.add(mapSchedule(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return schedules;
    }

    private void bindScheduleForInsertOrUpdate(PreparedStatement ps, TourSchedule schedule, boolean updateMode, boolean hasTransportColumn) throws Exception {
        // Bind theo đúng thứ tự dấu ? trong insertTourSchedule/updateTourSchedule.
        int index = 1;
        if (!updateMode) {
            ps.setInt(index++, schedule.getTourID());
        }
        if (hasTransportColumn) {
            setNullableString(ps, index++, schedule.getScheduleTransportType());
        }
        ps.setTimestamp(index++, schedule.getStartDate());
        ps.setTimestamp(index++, schedule.getEndDate());
        setNullableTime(ps, index++, schedule.getDepartureTime());
        setNullableTime(ps, index++, schedule.getExpectedReturnTime());
        setNullableTimestamp(ps, index++, schedule.getBookingDeadline());
        ps.setInt(index++, schedule.getMinParticipants());
        ps.setInt(index++, schedule.getMaxParticipants());
        ps.setInt(index++, schedule.getMaxParticipantsPerBooking() <= 0 ? 10 : schedule.getMaxParticipantsPerBooking());
        ps.setBigDecimal(index++, schedule.getAdultPrice());
        ps.setBigDecimal(index++, schedule.getChildPrice());
        ps.setBigDecimal(index++, schedule.getInfantPrice());
        ps.setBigDecimal(index++, schedule.getSingleRoomSurcharge());
        ps.setInt(index++, schedule.getDepositPercent() == null ? 0 : schedule.getDepositPercent());
        setNullableString(ps, index++, schedule.getCancellationPolicy());
        ps.setString(index++, isBlank(schedule.getScheduleStatus()) ? "Open" : schedule.getScheduleStatus());
        if (updateMode) {
            ps.setInt(index, schedule.getTourScheduleID());
        }
    }



    private TourSchedule mapSchedule(ResultSet rs) throws Exception {
        TourSchedule schedule = new TourSchedule();
        schedule.setTourScheduleID(rs.getInt("tourScheduleID"));
        schedule.setTourID(rs.getInt("tourID"));
        schedule.setScheduleTransportType(rs.getString("scheduleTransportType"));
        schedule.setStartDate(rs.getTimestamp("startDate"));
        schedule.setEndDate(rs.getTimestamp("endDate"));
        schedule.setDepartureTime(rs.getTime("departureTime"));
        schedule.setExpectedReturnTime(rs.getTime("expectedReturnTime"));
        schedule.setBookingDeadline(rs.getTimestamp("bookingDeadline"));
        schedule.setMinParticipants(rs.getInt("minParticipants"));
        schedule.setMaxParticipants(rs.getInt("maxParticipants"));
        schedule.setQuantity(rs.getInt("quantity"));
        schedule.setBookedSeats(rs.getInt("bookedSeats"));
        schedule.setMaxParticipantsPerBooking(rs.getInt("maxParticipantsPerBooking"));
        schedule.setAdultPrice(rs.getBigDecimal("adultPrice"));
        schedule.setChildPrice(rs.getBigDecimal("childPrice"));
        schedule.setInfantPrice(rs.getBigDecimal("infantPrice"));
        schedule.setSingleRoomSurcharge(rs.getBigDecimal("singleRoomSurcharge"));
        int depositPercent = rs.getInt("depositPercent");
        schedule.setDepositPercent(rs.wasNull() ? null : depositPercent);
        schedule.setCancellationPolicy(rs.getString("cancellationPolicy"));
        schedule.setScheduleStatus(rs.getString("scheduleStatus"));
        schedule.setCreatedAt(rs.getTimestamp("createdAt"));
        schedule.setUpdatedAt(rs.getTimestamp("updatedAt"));
        schedule.setTourName(getOptionalString(rs, "tourName"));
        schedule.setTourCode(getOptionalString(rs, "tourCode"));
        schedule.setTourStatus(getOptionalString(rs, "tourStatus"));
        schedule.setStartPlace(getOptionalString(rs, "startPlace"));
        schedule.setEndPlace(getOptionalString(rs, "endPlace"));
        schedule.setMainTransportType(getOptionalString(rs, "mainTransportType"));
        return schedule;
    }

    private String getOptionalString(ResultSet rs, String columnName) throws SQLException {
        try {
            return rs.getString(columnName);
        } catch (SQLException e) {
            return "";
        }
    }

    private void setNullableTime(PreparedStatement ps, int index, java.sql.Time value) throws Exception {
        if (value == null) {
            ps.setNull(index, Types.TIME);
        } else {
            ps.setTime(index, value);
        }
    }

    private void setNullableTimestamp(PreparedStatement ps, int index, Timestamp value) throws Exception {
        if (value == null) {
            ps.setNull(index, Types.TIMESTAMP);
        } else {
            ps.setTimestamp(index, value);
        }
    }

    private void setNullableString(PreparedStatement ps, int index, String value) throws Exception {
        if (isBlank(value)) {
            ps.setNull(index, Types.NVARCHAR);
        } else {
            ps.setString(index, value.trim());
        }
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
