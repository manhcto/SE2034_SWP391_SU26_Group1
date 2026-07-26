package vn.edu.fpt.DAO;

import vn.edu.fpt.common.DBConnection;
import vn.edu.fpt.model.Booking;
import vn.edu.fpt.model.BookingStatusStat;
import vn.edu.fpt.model.BookingTypeStat;
import vn.edu.fpt.model.BookingValueDataPoint;
import vn.edu.fpt.model.DashboardSummary;
import vn.edu.fpt.model.ServicePerformanceItem;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class DashboardDAO {

    public DashboardSummary getDashboardSummary(LocalDate fromDate, LocalDate toDate) {
        DashboardSummary summary = new DashboardSummary();

        String sql =
                "SELECT " +
                        "(SELECT COUNT(*) FROM [dbo].[Booking] " +
                        " WHERE bookDate >= ? AND bookDate < ?) AS totalBookings, " +
                        "(SELECT ISNULL(SUM(totalPrice), 0) FROM [dbo].[Booking] " +
                        " WHERE [status] IN (N'Confirmed', N'Completed', N'End') " +
                        " AND bookDate >= ? AND bookDate < ?) AS confirmedBookingValue, " +
                        "(SELECT COUNT(*) FROM [dbo].[Booking] " +
                        " WHERE [status] IN (N'Completed', N'End') " +
                        " AND bookDate >= ? AND bookDate < ?) AS completedBookings, " +
                        "(SELECT COUNT(*) FROM [dbo].[User] " +
                        " WHERE roleID = 4 AND createAt >= ? AND createAt < ?) AS newCustomers";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            Timestamp start = toStartTimestamp(fromDate);
            Timestamp endExclusive = toEndExclusiveTimestamp(toDate);

            ps.setTimestamp(1, start);
            ps.setTimestamp(2, endExclusive);
            ps.setTimestamp(3, start);
            ps.setTimestamp(4, endExclusive);
            ps.setTimestamp(5, start);
            ps.setTimestamp(6, endExclusive);
            ps.setTimestamp(7, start);
            ps.setTimestamp(8, endExclusive);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    summary.setTotalBookings(rs.getInt("totalBookings"));
                    summary.setConfirmedBookingValue(rs.getBigDecimal("confirmedBookingValue"));
                    summary.setCompletedBookings(rs.getInt("completedBookings"));
                    summary.setNewCustomers(rs.getInt("newCustomers"));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return summary;
    }

    public List<BookingValueDataPoint> getBookingValueTrend(LocalDate fromDate, LocalDate toDate) {
        Map<LocalDate, BigDecimal> valueByDate = new LinkedHashMap<>();
        LocalDate current = fromDate;

        while (!current.isAfter(toDate)) {
            valueByDate.put(current, BigDecimal.ZERO);
            current = current.plusDays(1);
        }

        String sql =
                "SELECT CAST(bookDate AS date) AS bookingDate, ISNULL(SUM(totalPrice), 0) AS totalValue " +
                        "FROM [dbo].[Booking] " +
                        "WHERE [status] IN (N'Confirmed', N'Completed', N'End') " +
                        "AND bookDate >= ? AND bookDate < ? " +
                        "GROUP BY CAST(bookDate AS date) " +
                        "ORDER BY bookingDate ASC";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setTimestamp(1, toStartTimestamp(fromDate));
            ps.setTimestamp(2, toEndExclusiveTimestamp(toDate));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    LocalDate bookingDate = rs.getDate("bookingDate").toLocalDate();
                    valueByDate.put(bookingDate, rs.getBigDecimal("totalValue"));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        List<BookingValueDataPoint> points = new ArrayList<>();
        for (Map.Entry<LocalDate, BigDecimal> entry : valueByDate.entrySet()) {
            points.add(new BookingValueDataPoint(entry.getKey(), entry.getValue()));
        }

        return points;
    }

    public List<BookingStatusStat> getBookingStatusStats(LocalDate fromDate, LocalDate toDate) {
        Map<String, Integer> countByStatus = new LinkedHashMap<>();
        countByStatus.put("Pending", 0);
        countByStatus.put("Completed", 0);
        countByStatus.put("Cancelled", 0);
        countByStatus.put("End", 0);

        String sql =
                "SELECT [status], COUNT(*) AS bookingCount " +
                        "FROM [dbo].[Booking] " +
                        "WHERE bookDate >= ? AND bookDate < ? " +
                        "GROUP BY [status]";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setTimestamp(1, toStartTimestamp(fromDate));
            ps.setTimestamp(2, toEndExclusiveTimestamp(toDate));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String rawStatus = rs.getString("status");
                    int bookingCount = rs.getInt("bookingCount");
                    String normalizedStatus;

                    if (Booking.isProcessingStatus(rawStatus)) {
                        normalizedStatus = Booking.STATUS_PROCESSING;
                    } else if (Booking.isCancelledStatus(rawStatus)) {
                        normalizedStatus = Booking.STATUS_CANCELLED;
                    } else if (Booking.isEndedStatus(rawStatus)) {
                        normalizedStatus = Booking.STATUS_ENDED;
                    } else if (Booking.isCompletedStatus(rawStatus) || Booking.isApprovedStatus(rawStatus)) {
                        normalizedStatus = Booking.STATUS_COMPLETED;
                    } else {
                        normalizedStatus = rawStatus;
                    }

                    countByStatus.merge(normalizedStatus, bookingCount, Integer::sum);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        List<BookingStatusStat> stats = new ArrayList<>();
        for (Map.Entry<String, Integer> entry : countByStatus.entrySet()) {
            stats.add(new BookingStatusStat(entry.getKey(), entry.getValue()));
        }

        return stats;
    }

    public List<BookingTypeStat> getBookingTypeStats(LocalDate fromDate, LocalDate toDate) {
        Map<String, Integer> countByType = new LinkedHashMap<>();
        countByType.put("Tour", 0);
        countByType.put("Accommodation", 0);

        String sql =
                "SELECT bookingType, COUNT(*) AS bookingCount " +
                        "FROM [dbo].[Booking] " +
                        "WHERE bookDate >= ? AND bookDate < ? " +
                        "GROUP BY bookingType";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setTimestamp(1, toStartTimestamp(fromDate));
            ps.setTimestamp(2, toEndExclusiveTimestamp(toDate));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    countByType.put(rs.getString("bookingType"), rs.getInt("bookingCount"));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        List<BookingTypeStat> stats = new ArrayList<>();
        for (Map.Entry<String, Integer> entry : countByType.entrySet()) {
            stats.add(new BookingTypeStat(entry.getKey(), entry.getValue()));
        }

        return stats;
    }

    public List<ServicePerformanceItem> getTopTours(LocalDate fromDate, LocalDate toDate, int limit) {
        List<ServicePerformanceItem> items = new ArrayList<>();
        if (limit <= 0) {
            return items;
        }

        String sql =
                "SELECT TOP (?) t.tourID AS serviceID, t.tourName AS serviceName, " +
                        "COUNT(DISTINCT b.bookingID) AS bookingCount " +
                        "FROM [dbo].[Booking] b " +
                        "INNER JOIN [dbo].[Booking_Detail] bd ON b.bookingID = bd.bookingID " +
                        "INNER JOIN [dbo].[Tour_Scheduler] ts ON bd.tourScheduleID = ts.tourScheduleID " +
                        "INNER JOIN [dbo].[Tour] t ON ts.tourID = t.tourID " +
                        "WHERE b.[status] IN (N'Confirmed', N'Completed', N'End') " +
                        "AND b.bookingType = N'Tour' " +
                        "AND b.bookDate >= ? AND b.bookDate < ? " +
                        "GROUP BY t.tourID, t.tourName " +
                        "ORDER BY bookingCount DESC, t.tourName ASC";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);
            ps.setTimestamp(2, toStartTimestamp(fromDate));
            ps.setTimestamp(3, toEndExclusiveTimestamp(toDate));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    items.add(mapServicePerformanceItem(rs));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return items;
    }

    public List<ServicePerformanceItem> getTopAccommodations(LocalDate fromDate, LocalDate toDate, int limit) {
        List<ServicePerformanceItem> items = new ArrayList<>();
        if (limit <= 0) {
            return items;
        }

        String sql =
                "SELECT TOP (?) a.accommodationID AS serviceID, a.[name] AS serviceName, " +
                        "COUNT(DISTINCT b.bookingID) AS bookingCount " +
                        "FROM [dbo].[Booking] b " +
                        "INNER JOIN [dbo].[Booking_Detail] bd ON b.bookingID = bd.bookingID " +
                        "INNER JOIN [dbo].[Accommodation] a ON bd.accommodationID = a.accommodationID " +
                        "WHERE b.[status] IN (N'Confirmed', N'Completed', N'End') " +
                        "AND b.bookingType = N'Accommodation' " +
                        "AND b.bookDate >= ? AND b.bookDate < ? " +
                        "GROUP BY a.accommodationID, a.[name] " +
                        "ORDER BY bookingCount DESC, a.[name] ASC";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);
            ps.setTimestamp(2, toStartTimestamp(fromDate));
            ps.setTimestamp(3, toEndExclusiveTimestamp(toDate));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    items.add(mapServicePerformanceItem(rs));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return items;
    }

    private ServicePerformanceItem mapServicePerformanceItem(ResultSet rs) throws Exception {
        ServicePerformanceItem item = new ServicePerformanceItem();
        item.setServiceID(rs.getInt("serviceID"));
        item.setServiceName(rs.getString("serviceName"));
        item.setBookingCount(rs.getInt("bookingCount"));
        return item;
    }

    private Timestamp toStartTimestamp(LocalDate date) {
        return Timestamp.valueOf(date.atStartOfDay());
    }

    private Timestamp toEndExclusiveTimestamp(LocalDate date) {
        return Timestamp.valueOf(date.plusDays(1).atStartOfDay());
    }
}
