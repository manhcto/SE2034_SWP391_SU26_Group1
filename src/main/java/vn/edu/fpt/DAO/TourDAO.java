package vn.edu.fpt.DAO;

import vn.edu.fpt.common.DBConnection;
import vn.edu.fpt.model.Destination;
import vn.edu.fpt.model.Region;
import vn.edu.fpt.model.Tour;
import vn.edu.fpt.model.TourCategory;
import vn.edu.fpt.model.TourItinerary;
import vn.edu.fpt.model.TourSchedule;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.SQLException;
import java.sql.Time;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TourDAO {

    private static final BigDecimal MIN_SCHEDULE_ADULT_PRICE = new BigDecimal("100000");
    private static final BigDecimal CHILD_RATE = new BigDecimal("0.50");

    private static final String TOUR_SELECT = """
            SELECT
                t.tourID,
                t.tourCategoryID,
                t.tourName,
                t.tourCode,
                t.tourType,
                t.numberOfDay,
                t.numberOfNights,
                t.startPlace,
                t.endPlace,
                t.[image],
                t.adultPrice,
                t.childrenPrice,
                t.infantPrice,
                t.singleRoomSurcharge,
                t.depositPercent,
                t.vatPercent,
                t.tourIntroduce,
                t.tourInclude,
                t.tourNonInclude,
                t.pickupPointName,
                t.pickupAddress,
                t.arriveBeforeMinutes,
                t.pickupNote,
                t.mainTransportType,
                t.childPolicyNote,
                t.rate,
                t.[status],
                t.isFeatured,
                t.regionID,
                t.createdByUserID,
                t.approvedByUserID,
                t.approvedAt,
                t.rejectionReason,
                t.createdAt,
                t.updatedAt,
                tc.categoryName,
                r.regionName,
                LTRIM(RTRIM(ISNULL(cu.firstName, N'') + N' ' + ISNULL(cu.lastName, N''))) AS createdByName,
                LTRIM(RTRIM(ISNULL(au.firstName, N'') + N' ' + ISNULL(au.lastName, N''))) AS approvedByName,
                ISNULL((SELECT COUNT(*) FROM Tour_Scheduler ts WHERE ts.tourID = t.tourID), 0) AS scheduleCount,
                ISNULL((
                    SELECT COUNT(DISTINCT bd.bookingID)
                    FROM Tour_Scheduler ts
                    JOIN Booking_Detail bd ON bd.tourScheduleID = ts.tourScheduleID
                    WHERE ts.tourID = t.tourID
                ), 0) AS bookingCount
            FROM Tour t
            JOIN Tour_Category tc ON t.tourCategoryID = tc.tourCategoryID
            LEFT JOIN Region r ON t.regionID = r.regionID
            LEFT JOIN [User] cu ON t.createdByUserID = cu.userID
            LEFT JOIN [User] au ON t.approvedByUserID = au.userID
            """;

    public List<Tour> getToursForStaff(String keyword, String status, Integer categoryID, Integer regionID) {
        List<Tour> tours = new ArrayList<>();
        List<Object> params = new ArrayList<>();

        StringBuilder sql = new StringBuilder(TOUR_SELECT)
                .append(" WHERE 1 = 1 ");

        if (!isBlank(keyword)) {
            sql.append(" AND (t.tourName LIKE ? OR t.tourCode LIKE ? OR t.startPlace LIKE ? OR t.endPlace LIKE ?) ");
            String likeKeyword = "%" + keyword.trim() + "%";
            params.add(likeKeyword);
            params.add(likeKeyword);
            params.add(likeKeyword);
            params.add(likeKeyword);
        }

        if (!isBlank(status)) {
            sql.append(" AND t.[status] = ? ");
            params.add(status.trim());
        }

        if (categoryID != null && categoryID > 0) {
            sql.append(" AND t.tourCategoryID = ? ");
            params.add(categoryID);
        }

        if (regionID != null && regionID > 0) {
            sql.append(" AND t.regionID = ? ");
            params.add(regionID);
        }

        sql.append(" ORDER BY t.createdAt DESC, t.tourID DESC ");

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            bindParams(ps, params);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    tours.add(mapTour(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return tours;
    }

    public Tour getTourById(int tourID) {
        String sql = TOUR_SELECT + " WHERE t.tourID = ? ";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, tourID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapTour(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public void loadManagedImages(Tour tour) {
        if (tour == null || tour.getTourID() <= 0) {
            return;
        }

        Map<String, String> images = getManagedImageMap(tour.getTourID());
        tour.setIntroImage(images.get("INTRO_IMAGE"));

        if (tour.getItineraryList() != null) {
            for (TourItinerary itinerary : tour.getItineraryList()) {
                itinerary.setImageUrl(images.get(buildItineraryImageCaption(itinerary.getDayNumber())));
            }
        }
    }

    private Map<String, String> getManagedImageMap(int tourID) {
        Map<String, String> images = new HashMap<>();

        String sql = """
                SELECT caption, imageUrl
                FROM Tour_Image
                WHERE tourID = ?
                  AND [status] = N'Active'
                  AND (caption = N'INTRO_IMAGE' OR caption LIKE N'ITINERARY_DAY_%_IMAGE')
                ORDER BY displayOrder ASC, imageID ASC
                """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, tourID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String caption = rs.getString("caption");
                    if (!images.containsKey(caption)) {
                        images.put(caption, rs.getString("imageUrl"));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return images;
    }

    public List<TourItinerary> getItinerariesByTourId(int tourID) {
        List<TourItinerary> itineraries = new ArrayList<>();

        String sql = """
                SELECT itineraryID, tourID, dayNumber, title, [description], mealPlan, transportNote, [status]
                FROM Tour_Itinerary
                WHERE tourID = ?
                ORDER BY dayNumber ASC, itineraryID ASC
                """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, tourID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    itineraries.add(mapItinerary(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return itineraries;
    }

    public List<TourSchedule> getSchedulesByTourId(int tourID) {
        List<TourSchedule> schedules = new ArrayList<>();
        boolean hasTransportColumn = hasScheduleTransportTypeColumn();

        String sql = """
                SELECT
                    tourScheduleID, tourID, %s startDate, endDate, departureTime, expectedReturnTime,
                    bookingDeadline, minParticipants, maxParticipants, quantity, bookedSeats,
                    maxParticipantsPerBooking, adultPrice, childPrice, infantPrice,
                    singleRoomSurcharge, depositPercent, vatPercent, cancellationPolicy,
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
                    ts.singleRoomSurcharge, ts.depositPercent, ts.vatPercent, ts.cancellationPolicy,
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

    public List<TourCategory> getActiveCategories() {
        List<TourCategory> categories = new ArrayList<>();

        String sql = """
                SELECT tourCategoryID, categoryName, [description], [status]
                FROM Tour_Category
                WHERE [status] = N'Active'
                ORDER BY categoryName ASC
                """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                TourCategory category = new TourCategory();
                category.setTourCategoryID(rs.getInt("tourCategoryID"));
                category.setCategoryName(rs.getString("categoryName"));
                category.setDescription(rs.getString("description"));
                category.setStatus(rs.getString("status"));
                categories.add(category);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return categories;
    }

    public List<Region> getActiveRegions() {
        List<Region> regions = new ArrayList<>();

        String sql = """
                SELECT regionID, regionName, [description], [status]
                FROM Region
                WHERE [status] = N'Active'
                ORDER BY regionID ASC
                """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Region region = new Region();
                region.setRegionID(rs.getInt("regionID"));
                region.setRegionName(rs.getString("regionName"));
                region.setDescription(rs.getString("description"));
                region.setStatus(rs.getString("status"));
                regions.add(region);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return regions;
    }

    public List<Destination> getActiveDestinations() {
        List<Destination> destinations = new ArrayList<>();

        String sql = """
                SELECT d.destinationID, d.regionID, d.destinationName, d.[description], d.[status], r.regionName
                FROM Destination d
                LEFT JOIN Region r ON d.regionID = r.regionID
                WHERE d.[status] = N'Active'
                ORDER BY r.regionID ASC, d.destinationName ASC
                """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Destination destination = new Destination();
                destination.setDestinationID(rs.getInt("destinationID"));
                int regionID = rs.getInt("regionID");
                destination.setRegionID(rs.wasNull() ? null : regionID);
                destination.setDestinationName(rs.getString("destinationName"));
                destination.setDescription(rs.getString("description"));
                destination.setStatus(rs.getString("status"));
                destination.setRegionName(rs.getString("regionName"));
                destinations.add(destination);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return destinations;
    }

    public boolean existsActiveCategory(int categoryID) {
        return existsByIdAndStatus("Tour_Category", "tourCategoryID", categoryID);
    }

    public boolean existsActiveRegion(int regionID) {
        return existsByIdAndStatus("Region", "regionID", regionID);
    }

    public String getNextTourCodePreview() {
        String sql = "SELECT ISNULL(MAX(tourID), 0) + 1 AS nextTourID FROM Tour";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return buildTourCode(rs.getInt("nextTourID"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return buildTourCode(1);
    }

    public int insertTourWithItineraries(Tour tour) {
        String insertTourSql = """
                INSERT INTO Tour (
                    tourCategoryID, tourName, tourCode, tourType, numberOfDay, numberOfNights,
                    startPlace, endPlace, [image], adultPrice, childrenPrice, infantPrice,
                    singleRoomSurcharge, depositPercent, vatPercent, tourIntroduce, tourInclude,
                    tourNonInclude, pickupPointName, pickupAddress, arriveBeforeMinutes,
                    pickupNote, mainTransportType, childPolicyNote, rate, [status], isFeatured,
                    regionID, createdByUserID, approvedByUserID, approvedAt, rejectionReason,
                    createdAt, updatedAt
                ) VALUES (
                    ?, ?, NULL, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NULL,
                    ?, ?, ?, ?, NULL, NULL, NULL, GETDATE(), NULL
                )
                """;

        Connection conn = null;

        try {
            conn = new DBConnection().getConnection();
            conn.setAutoCommit(false);

            int tourID;
            try (PreparedStatement ps = conn.prepareStatement(insertTourSql, Statement.RETURN_GENERATED_KEYS)) {
                bindTourForInsert(ps, tour);
                ps.executeUpdate();

                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (!keys.next()) {
                        throw new SQLException("Cannot get generated tourID.");
                    }
                    tourID = keys.getInt(1);
                }
            }

            updateTourCode(conn, tourID);
            insertItineraries(conn, tourID, tour.getItineraryList());
            replaceManagedImages(conn, tourID, tour);
            insertSchedules(conn, tourID, tour.getScheduleList());

            conn.commit();
            return tourID;
        } catch (Exception e) {
            rollbackQuietly(conn);
            e.printStackTrace();
        } finally {
            closeQuietly(conn);
        }

        return 0;
    }

    public boolean updateTourWithItineraries(Tour tour) {
        String updateTourSql = """
                UPDATE Tour
                SET tourCategoryID = ?, tourName = ?, tourType = ?, numberOfDay = ?, numberOfNights = ?,
                    startPlace = ?, endPlace = ?, [image] = ?, adultPrice = ?, childrenPrice = ?,
                    infantPrice = ?, singleRoomSurcharge = ?, depositPercent = ?, vatPercent = ?,
                    tourIntroduce = ?, tourInclude = ?, tourNonInclude = ?, pickupPointName = ?,
                    pickupAddress = ?, arriveBeforeMinutes = ?, pickupNote = ?, mainTransportType = ?,
                    childPolicyNote = ?, [status] = ?, isFeatured = ?, regionID = ?, updatedAt = GETDATE(),
                    rejectionReason = CASE WHEN [status] = N'Rejected' AND ? <> N'Rejected' THEN NULL ELSE rejectionReason END
                WHERE tourID = ?
                """;

        Connection conn = null;

        try {
            conn = new DBConnection().getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement ps = conn.prepareStatement(updateTourSql)) {
                bindTourForUpdate(ps, tour);
                int updatedRows = ps.executeUpdate();

                if (updatedRows == 0) {
                    conn.rollback();
                    return false;
                }
            }

            deleteItinerariesByTourId(conn, tour.getTourID());
            insertItineraries(conn, tour.getTourID(), tour.getItineraryList());
            replaceManagedImages(conn, tour.getTourID(), tour);
            ensureTourCode(conn, tour.getTourID());

            conn.commit();
            return true;
        } catch (Exception e) {
            rollbackQuietly(conn);
            e.printStackTrace();
        } finally {
            closeQuietly(conn);
        }

        return false;
    }

    public boolean updateActiveTourContentOnly(Tour tour) {
        String updateTourSql = """
                UPDATE Tour
                SET [image] = ?,
                    tourIntroduce = ?,
                    tourInclude = ?,
                    updatedAt = GETDATE()
                WHERE tourID = ?
                  AND [status] = N'Active'
                """;

        Connection conn = null;

        try {
            conn = new DBConnection().getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement ps = conn.prepareStatement(updateTourSql)) {
                setNullableString(ps, 1, tour.getImage());
                setNullableString(ps, 2, tour.getTourIntroduce());
                setNullableString(ps, 3, tour.getTourInclude());
                ps.setInt(4, tour.getTourID());

                if (ps.executeUpdate() == 0) {
                    conn.rollback();
                    return false;
                }
            }

            replaceManagedImages(conn, tour.getTourID(), tour);

            conn.commit();
            return true;
        } catch (Exception e) {
            rollbackQuietly(conn);
            e.printStackTrace();
        } finally {
            closeQuietly(conn);
        }

        return false;
    }

    private void bindTourForInsert(PreparedStatement ps, Tour tour) throws Exception {
        int index = 1;
        ps.setInt(index++, tour.getTourCategoryID());
        ps.setString(index++, tour.getTourName());
        ps.setString(index++, tour.getTourType());
        ps.setInt(index++, tour.getNumberOfDay());
        setInteger(ps, index++, tour.getNumberOfNights());
        ps.setString(index++, tour.getStartPlace());
        ps.setString(index++, tour.getEndPlace());
        setNullableString(ps, index++, tour.getImage());
        ps.setBigDecimal(index++, tour.getAdultPrice());
        ps.setBigDecimal(index++, tour.getChildrenPrice());
        ps.setBigDecimal(index++, tour.getInfantPrice());
        ps.setBigDecimal(index++, tour.getSingleRoomSurcharge());
        ps.setInt(index++, tour.getDepositPercent());
        ps.setInt(index++, tour.getVatPercent());
        setNullableString(ps, index++, tour.getTourIntroduce());
        setNullableString(ps, index++, tour.getTourInclude());
        setNullableString(ps, index++, tour.getTourNonInclude());
        setNullableString(ps, index++, tour.getPickupPointName());
        setNullableString(ps, index++, tour.getPickupAddress());
        setInteger(ps, index++, tour.getArriveBeforeMinutes());
        setNullableString(ps, index++, tour.getPickupNote());
        setNullableString(ps, index++, tour.getMainTransportType());
        setNullableString(ps, index++, tour.getChildPolicyNote());
        ps.setString(index++, tour.getStatus());
        ps.setBoolean(index++, tour.isFeatured());
        setInteger(ps, index++, tour.getRegionID());
        setInteger(ps, index, tour.getCreatedByUserID());
    }

    private void bindTourForUpdate(PreparedStatement ps, Tour tour) throws Exception {
        int index = 1;
        ps.setInt(index++, tour.getTourCategoryID());
        ps.setString(index++, tour.getTourName());
        ps.setString(index++, tour.getTourType());
        ps.setInt(index++, tour.getNumberOfDay());
        setInteger(ps, index++, tour.getNumberOfNights());
        ps.setString(index++, tour.getStartPlace());
        ps.setString(index++, tour.getEndPlace());
        setNullableString(ps, index++, tour.getImage());
        ps.setBigDecimal(index++, tour.getAdultPrice());
        ps.setBigDecimal(index++, tour.getChildrenPrice());
        ps.setBigDecimal(index++, tour.getInfantPrice());
        ps.setBigDecimal(index++, tour.getSingleRoomSurcharge());
        ps.setInt(index++, tour.getDepositPercent());
        ps.setInt(index++, tour.getVatPercent());
        setNullableString(ps, index++, tour.getTourIntroduce());
        setNullableString(ps, index++, tour.getTourInclude());
        setNullableString(ps, index++, tour.getTourNonInclude());
        setNullableString(ps, index++, tour.getPickupPointName());
        setNullableString(ps, index++, tour.getPickupAddress());
        setInteger(ps, index++, tour.getArriveBeforeMinutes());
        setNullableString(ps, index++, tour.getPickupNote());
        setNullableString(ps, index++, tour.getMainTransportType());
        setNullableString(ps, index++, tour.getChildPolicyNote());
        ps.setString(index++, tour.getStatus());
        ps.setBoolean(index++, tour.isFeatured());
        setInteger(ps, index++, tour.getRegionID());
        ps.setString(index++, tour.getStatus());
        ps.setInt(index, tour.getTourID());
    }

    private void insertItineraries(Connection conn, int tourID, List<TourItinerary> itineraries) throws Exception {
        String sql = """
                INSERT INTO Tour_Itinerary (tourID, dayNumber, title, [description], mealPlan, transportNote, [status])
                VALUES (?, ?, ?, ?, ?, ?, N'Active')
                """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (TourItinerary itinerary : itineraries) {
                ps.setInt(1, tourID);
                ps.setInt(2, itinerary.getDayNumber());
                ps.setString(3, itinerary.getTitle());
                setNullableString(ps, 4, itinerary.getDescription());
                setNullableString(ps, 5, itinerary.getMealPlan());
                setNullableString(ps, 6, itinerary.getTransportNote());
                ps.addBatch();
            }

            ps.executeBatch();
        }
    }

    private void deleteItinerariesByTourId(Connection conn, int tourID) throws Exception {
        String sql = "DELETE FROM Tour_Itinerary WHERE tourID = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tourID);
            ps.executeUpdate();
        }
    }

    private void insertSchedules(Connection conn, int tourID, List<TourSchedule> schedules) throws Exception {
        if (schedules == null || schedules.isEmpty()) {
            return;
        }

        String sql = """
                INSERT INTO Tour_Scheduler (
                    tourID, startDate, endDate, departureTime, expectedReturnTime,
                    bookingDeadline, minParticipants, maxParticipants, quantity, bookedSeats,
                    maxParticipantsPerBooking, adultPrice, childPrice, infantPrice,
                    singleRoomSurcharge, depositPercent, vatPercent, cancellationPolicy,
                    scheduleStatus, createdAt, updatedAt
                ) VALUES (
                    ?, ?, ?, ?, ?, ?, ?, ?, 0, 0, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), NULL
                )
                """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (TourSchedule schedule : schedules) {
                ps.setInt(1, tourID);
                ps.setTimestamp(2, schedule.getStartDate());
                ps.setTimestamp(3, schedule.getEndDate());
                if (schedule.getDepartureTime() == null) {
                    ps.setNull(4, Types.TIME);
                } else {
                    ps.setTime(4, schedule.getDepartureTime());
                }
                if (schedule.getExpectedReturnTime() == null) {
                    ps.setNull(5, Types.TIME);
                } else {
                    ps.setTime(5, schedule.getExpectedReturnTime());
                }
                if (schedule.getBookingDeadline() == null) {
                    ps.setNull(6, Types.TIMESTAMP);
                } else {
                    ps.setTimestamp(6, schedule.getBookingDeadline());
                }
                ps.setInt(7, schedule.getMinParticipants());
                ps.setInt(8, schedule.getMaxParticipants());
                ps.setInt(9, schedule.getMaxParticipantsPerBooking() <= 0 ? 10 : schedule.getMaxParticipantsPerBooking());
                ps.setBigDecimal(10, schedule.getAdultPrice());
                ps.setBigDecimal(11, schedule.getChildPrice());
                ps.setBigDecimal(12, schedule.getInfantPrice());
                ps.setBigDecimal(13, schedule.getSingleRoomSurcharge());
                ps.setInt(14, schedule.getDepositPercent() == null ? 0 : schedule.getDepositPercent());
                ps.setInt(15, schedule.getVatPercent() == null ? 0 : schedule.getVatPercent());
                setNullableString(ps, 16, schedule.getCancellationPolicy());
                ps.setString(17, isBlank(schedule.getScheduleStatus()) ? "Open" : schedule.getScheduleStatus());
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }

    private void replaceManagedImages(Connection conn, int tourID, Tour tour) throws Exception {
        deleteManagedImages(conn, tourID);
        insertManagedImage(conn, tourID, tour.getIntroImage(), "INTRO_IMAGE", 1);

        if (tour.getItineraryList() != null) {
            int order = 10;
            for (TourItinerary itinerary : tour.getItineraryList()) {
                insertManagedImage(
                        conn,
                        tourID,
                        itinerary.getImageUrl(),
                        buildItineraryImageCaption(itinerary.getDayNumber()),
                        order++
                );
            }
        }
    }

    private void deleteManagedImages(Connection conn, int tourID) throws Exception {
        String sql = """
                DELETE FROM Tour_Image
                WHERE tourID = ?
                  AND (caption = N'INTRO_IMAGE' OR caption LIKE N'ITINERARY_DAY_%_IMAGE')
                """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tourID);
            ps.executeUpdate();
        }
    }

    private void insertManagedImage(Connection conn, int tourID, String imageUrl, String caption, int displayOrder) throws Exception {
        if (isBlank(imageUrl)) {
            return;
        }

        String sql = """
                INSERT INTO Tour_Image (tourID, imageUrl, caption, displayOrder, [status])
                VALUES (?, ?, ?, ?, N'Active')
                """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tourID);
            ps.setString(2, imageUrl.trim());
            ps.setString(3, caption);
            ps.setInt(4, displayOrder);
            ps.executeUpdate();
        }
    }

    private String buildItineraryImageCaption(int dayNumber) {
        return "ITINERARY_DAY_" + dayNumber + "_IMAGE";
    }

    private void updateTourCode(Connection conn, int tourID) throws Exception {
        String sql = "UPDATE Tour SET tourCode = ? WHERE tourID = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, buildUniqueTourCode(conn, tourID));
            ps.setInt(2, tourID);
            ps.executeUpdate();
        }
    }

    private void ensureTourCode(Connection conn, int tourID) throws Exception {
        String sql = "UPDATE Tour SET tourCode = ? WHERE tourID = ? AND (tourCode IS NULL OR LTRIM(RTRIM(tourCode)) = '')";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, buildUniqueTourCode(conn, tourID));
            ps.setInt(2, tourID);
            ps.executeUpdate();
        }
    }

    private String buildUniqueTourCode(Connection conn, int tourID) throws Exception {
        String baseCode = buildTourCode(tourID);
        if (!tourCodeExists(conn, baseCode, tourID)) {
            return baseCode;
        }

        for (int suffix = 1; suffix <= 99; suffix++) {
            String candidate = baseCode + "-" + suffix;
            if (!tourCodeExists(conn, candidate, tourID)) {
                return candidate;
            }
        }

        throw new SQLException("Cannot generate unique tour code for tourID " + tourID);
    }

    private boolean tourCodeExists(Connection conn, String tourCode, int currentTourID) throws Exception {
        String sql = "SELECT 1 FROM Tour WHERE tourCode = ? AND tourID <> ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, tourCode);
            ps.setInt(2, currentTourID);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    private String buildTourCode(int tourID) {
        return String.format("TOUR-%06d", tourID);
    }

    private boolean existsByIdAndStatus(String tableName, String idColumn, int id) {
        String sql = "SELECT 1 FROM " + tableName + " WHERE " + idColumn + " = ? AND [status] = N'Active'";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    private void bindParams(PreparedStatement ps, List<Object> params) throws Exception {
        for (int i = 0; i < params.size(); i++) {
            Object value = params.get(i);
            if (value instanceof Integer) {
                ps.setInt(i + 1, (Integer) value);
            } else {
                ps.setString(i + 1, String.valueOf(value));
            }
        }
    }


    private boolean hasScheduleTransportTypeColumn() {
        String sql = """
                SELECT 1
                FROM INFORMATION_SCHEMA.COLUMNS
                WHERE TABLE_NAME = 'Tour_Scheduler'
                  AND COLUMN_NAME = 'scheduleTransportType'
                """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
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
                    singleRoomSurcharge, depositPercent, vatPercent, cancellationPolicy,
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
        String sql;
        if (hasTransportColumn) {
            sql = """
                    INSERT INTO Tour_Scheduler (
                        tourID, scheduleTransportType, startDate, endDate, departureTime, expectedReturnTime,
                        bookingDeadline, minParticipants, maxParticipants, quantity, bookedSeats,
                        maxParticipantsPerBooking, adultPrice, childPrice, infantPrice,
                        singleRoomSurcharge, depositPercent, vatPercent, cancellationPolicy,
                        scheduleStatus, createdAt, updatedAt
                    ) VALUES (
                        ?, ?, ?, ?, ?, ?, ?, ?, ?, 0, 0, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), NULL
                    )
                    """;
        } else {
            sql = """
                    INSERT INTO Tour_Scheduler (
                        tourID, startDate, endDate, departureTime, expectedReturnTime,
                        bookingDeadline, minParticipants, maxParticipants, quantity, bookedSeats,
                        maxParticipantsPerBooking, adultPrice, childPrice, infantPrice,
                        singleRoomSurcharge, depositPercent, vatPercent, cancellationPolicy,
                        scheduleStatus, createdAt, updatedAt
                    ) VALUES (
                        ?, ?, ?, ?, ?, ?, ?, ?, 0, 0, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), NULL
                    )
                    """;
        }

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
        String sql;
        if (hasTransportColumn) {
            sql = """
                    UPDATE Tour_Scheduler
                    SET scheduleTransportType = ?, startDate = ?, endDate = ?, departureTime = ?, expectedReturnTime = ?,
                        bookingDeadline = ?, minParticipants = ?, maxParticipants = ?,
                        maxParticipantsPerBooking = ?, adultPrice = ?, childPrice = ?, infantPrice = ?,
                        singleRoomSurcharge = ?, depositPercent = ?, vatPercent = ?, cancellationPolicy = ?,
                        scheduleStatus = ?, updatedAt = GETDATE()
                    WHERE tourScheduleID = ?
                    """;
        } else {
            sql = """
                    UPDATE Tour_Scheduler
                    SET startDate = ?, endDate = ?, departureTime = ?, expectedReturnTime = ?,
                        bookingDeadline = ?, minParticipants = ?, maxParticipants = ?,
                        maxParticipantsPerBooking = ?, adultPrice = ?, childPrice = ?, infantPrice = ?,
                        singleRoomSurcharge = ?, depositPercent = ?, vatPercent = ?, cancellationPolicy = ?,
                        scheduleStatus = ?, updatedAt = GETDATE()
                    WHERE tourScheduleID = ?
                    """;
        }

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

            if (schedule.getDepartureTime() == null) {
                ps.setNull(1, Types.TIME);
            } else {
                ps.setTime(1, schedule.getDepartureTime());
            }
            if (schedule.getExpectedReturnTime() == null) {
                ps.setNull(2, Types.TIME);
            } else {
                ps.setTime(2, schedule.getExpectedReturnTime());
            }
            if (schedule.getBookingDeadline() == null) {
                ps.setNull(3, Types.TIMESTAMP);
            } else {
                ps.setTimestamp(3, schedule.getBookingDeadline());
            }
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

    public Map<Integer, String> getSchedulePriceWarningMap(int tourID) {
        Map<Integer, String> warningMap = new HashMap<>();
        for (TourSchedule schedule : getSchedulesByTourId(tourID)) {
            String warning = buildSchedulePriceWarning(schedule);
            if (!isBlank(warning)) {
                warningMap.put(schedule.getTourScheduleID(), warning);
            }
        }
        return warningMap;
    }

    private String buildSchedulePriceWarning(TourSchedule schedule) {
        if (schedule == null || "Cancelled".equals(schedule.getScheduleStatus())) {
            return "";
        }

        List<String> warnings = new ArrayList<>();
        BigDecimal adultPrice = schedule.getAdultPrice();
        BigDecimal childPrice = schedule.getChildPrice();
        BigDecimal singleRoom = schedule.getSingleRoomSurcharge();

        if (adultPrice == null || adultPrice.compareTo(MIN_SCHEDULE_ADULT_PRICE) <= 0) {
            warnings.add("Giá người lớn phải lớn hơn 100.000");
        }

        if (adultPrice != null && adultPrice.compareTo(BigDecimal.ZERO) > 0) {
            BigDecimal expectedChild = adultPrice.multiply(CHILD_RATE).setScale(0, RoundingMode.HALF_UP);
            if (childPrice == null || childPrice.compareTo(expectedChild) != 0) {
                warnings.add("Giá trẻ em 5-10 tuổi phải bằng 50% giá người lớn");
            }
        }

        if (singleRoom == null || singleRoom.compareTo(BigDecimal.ZERO) < 0) {
            warnings.add("Phụ thu phòng đơn phải lớn hơn hoặc bằng 0");
        }

        return String.join("; ", warnings);
    }

    private void bindScheduleForInsertOrUpdate(PreparedStatement ps, TourSchedule schedule, boolean updateMode, boolean hasTransportColumn) throws Exception {
        int index = 1;
        if (!updateMode) {
            ps.setInt(index++, schedule.getTourID());
        }
        if (hasTransportColumn) {
            setNullableString(ps, index++, schedule.getScheduleTransportType());
        }
        ps.setTimestamp(index++, schedule.getStartDate());
        ps.setTimestamp(index++, schedule.getEndDate());
        if (schedule.getDepartureTime() == null) {
            ps.setNull(index++, Types.TIME);
        } else {
            ps.setTime(index++, schedule.getDepartureTime());
        }
        if (schedule.getExpectedReturnTime() == null) {
            ps.setNull(index++, Types.TIME);
        } else {
            ps.setTime(index++, schedule.getExpectedReturnTime());
        }
        if (schedule.getBookingDeadline() == null) {
            ps.setNull(index++, Types.TIMESTAMP);
        } else {
            ps.setTimestamp(index++, schedule.getBookingDeadline());
        }
        ps.setInt(index++, schedule.getMinParticipants());
        ps.setInt(index++, schedule.getMaxParticipants());
        ps.setInt(index++, schedule.getMaxParticipantsPerBooking() <= 0 ? 10 : schedule.getMaxParticipantsPerBooking());
        ps.setBigDecimal(index++, schedule.getAdultPrice());
        ps.setBigDecimal(index++, schedule.getChildPrice());
        ps.setBigDecimal(index++, schedule.getInfantPrice());
        ps.setBigDecimal(index++, schedule.getSingleRoomSurcharge());
        ps.setInt(index++, schedule.getDepositPercent() == null ? 0 : schedule.getDepositPercent());
        ps.setInt(index++, schedule.getVatPercent() == null ? 0 : schedule.getVatPercent());
        setNullableString(ps, index++, schedule.getCancellationPolicy());
        ps.setString(index++, isBlank(schedule.getScheduleStatus()) ? "Open" : schedule.getScheduleStatus());
        if (updateMode) {
            ps.setInt(index, schedule.getTourScheduleID());
        }
    }


    public List<Tour> getPublishedToursForCustomer(String keyword, String startPlace, String destination,
                                                   Integer regionID, Integer categoryID, String startDate,
                                                   int limit) {
        return getPublishedToursForCustomer(keyword, startPlace, destination, regionID, categoryID, startDate, null, null, limit);
    }

    public List<Tour> getPublishedToursForCustomer(String keyword, String startPlace, String destination,
                                                   Integer regionID, Integer categoryID, String startDate,
                                                   BigDecimal minPrice, BigDecimal maxPrice, int limit) {
        List<Tour> tours = new ArrayList<>();
        List<Object> params = new ArrayList<>();
        int safeLimit = limit <= 0 ? 100 : Math.min(limit, 1000);

        StringBuilder sql = new StringBuilder(TOUR_SELECT)
                .append(" WHERE t.[status] = N'Active' ")
                .append(" AND EXISTS ( ")
                .append("     SELECT 1 FROM Tour_Scheduler ts ")
                .append("     WHERE ts.tourID = t.tourID ")
                .append("       AND ts.scheduleStatus = N'Open' ")
                .append("       AND ts.startDate >= CAST(GETDATE() AS date) ")
                .append("       AND ISNULL(ts.quantity, 0) < ISNULL(ts.maxParticipants, 0) ");

        if (!isBlank(startDate)) {
            sql.append(" AND CAST(ts.startDate AS date) = CAST(? AS date) ");
            params.add(startDate.trim());
        }

        if (minPrice != null) {
            sql.append(" AND COALESCE(ts.adultPrice, t.adultPrice, 0) >= ? ");
            params.add(minPrice);
        }

        if (maxPrice != null) {
            sql.append(" AND COALESCE(ts.adultPrice, t.adultPrice, 0) <= ? ");
            params.add(maxPrice);
        }

        sql.append(" ) ");

        if (!isBlank(keyword)) {
            sql.append(" AND (t.tourName LIKE ? OR t.tourCode LIKE ? OR t.startPlace LIKE ? OR t.endPlace LIKE ? OR tc.categoryName LIKE ? OR r.regionName LIKE ?) ");
            String likeKeyword = "%" + keyword.trim() + "%";
            params.add(likeKeyword);
            params.add(likeKeyword);
            params.add(likeKeyword);
            params.add(likeKeyword);
            params.add(likeKeyword);
            params.add(likeKeyword);
        }

        if (!isBlank(startPlace)) {
            sql.append(" AND t.startPlace = ? ");
            params.add(startPlace.trim());
        }

        if (!isBlank(destination)) {
            sql.append(" AND t.endPlace = ? ");
            params.add(destination.trim());
        }

        if (regionID != null && regionID > 0) {
            sql.append(" AND t.regionID = ? ");
            params.add(regionID);
        }

        if (categoryID != null && categoryID > 0) {
            sql.append(" AND t.tourCategoryID = ? ");
            params.add(categoryID);
        }

        sql.append(" ORDER BY t.isFeatured DESC, t.createdAt DESC, t.tourID DESC OFFSET 0 ROWS FETCH NEXT ")
                .append(safeLimit)
                .append(" ROWS ONLY ");

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            bindParams(ps, params);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Tour tour = mapTour(rs);
                    tour.setScheduleList(getAvailableSchedulesForCustomerByTourId(tour.getTourID(), 100));
                    tours.add(tour);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return tours;
    }

    public List<Tour> getFeaturedToursForHome(int limit) {
        List<Tour> tours = getPublishedToursForCustomer(null, null, null, null, null, null, limit);
        List<Tour> featuredTours = new ArrayList<>();
        for (Tour tour : tours) {
            if (tour.isFeatured()) {
                featuredTours.add(tour);
            }
        }
        if (!featuredTours.isEmpty()) {
            return featuredTours.size() > limit ? featuredTours.subList(0, limit) : featuredTours;
        }
        return tours;
    }

    public int countPublishedToursForCustomer() {
        String sql = """
                SELECT COUNT(DISTINCT t.tourID)
                FROM Tour t
                WHERE t.[status] = N'Active'
                  AND EXISTS (
                      SELECT 1
                      FROM Tour_Scheduler ts
                      WHERE ts.tourID = t.tourID
                        AND ts.scheduleStatus = N'Open'
                        AND ts.startDate >= CAST(GETDATE() AS date)
                        AND ISNULL(ts.quantity, 0) < ISNULL(ts.maxParticipants, 0)
                  )
                """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Tour> getPublishedToursForHomeByRegionName(String regionName, int limit) {
        List<Tour> tours = new ArrayList<>();
        if (isBlank(regionName)) {
            return tours;
        }
        int safeLimit = limit <= 0 ? 3 : Math.min(limit, 10);

        String sql = TOUR_SELECT + """
                WHERE t.[status] = N'Active'
                  AND r.regionName = ?
                  AND EXISTS (
                      SELECT 1
                      FROM Tour_Scheduler ts
                      WHERE ts.tourID = t.tourID
                        AND ts.scheduleStatus = N'Open'
                        AND ts.startDate >= CAST(GETDATE() AS date)
                        AND ISNULL(ts.quantity, 0) < ISNULL(ts.maxParticipants, 0)
                  )
                ORDER BY t.isFeatured DESC, t.createdAt DESC, t.tourID DESC
                OFFSET 0 ROWS FETCH NEXT """ + " " + safeLimit + " ROWS ONLY ";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, regionName.trim());

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Tour tour = mapTour(rs);
                    tour.setScheduleList(getAvailableSchedulesForCustomerByTourId(tour.getTourID(), 100));
                    tours.add(tour);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return tours;
    }

    public Tour getPublishedTourById(int tourID) {
        String sql = TOUR_SELECT + " WHERE t.tourID = ? AND t.[status] = N'Active' ";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, tourID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Tour tour = mapTour(rs);
                    tour.setItineraryList(getItinerariesByTourId(tourID));
                    tour.setScheduleList(getAvailableSchedulesForCustomerByTourId(tourID, 100));
                    loadManagedImages(tour);
                    return tour;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
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
                    singleRoomSurcharge, depositPercent, vatPercent, cancellationPolicy,
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

    public List<String> getPublishedStartPlaces() {
        return getPublishedTourPlaces("startPlace");
    }

    public List<String> getPublishedDestinations() {
        return getPublishedTourPlaces("endPlace");
    }

    private List<String> getPublishedTourPlaces(String columnName) {
        List<String> places = new ArrayList<>();
        String safeColumn = "endPlace".equals(columnName) ? "endPlace" : "startPlace";
        String sql = """
                SELECT DISTINCT t.%s AS placeName
                FROM Tour t
                WHERE t.[status] = N'Active'
                  AND t.%s IS NOT NULL
                  AND LTRIM(RTRIM(t.%s)) <> N''
                  AND EXISTS (
                      SELECT 1 FROM Tour_Scheduler ts
                      WHERE ts.tourID = t.tourID
                        AND ts.scheduleStatus = N'Open'
                        AND ts.startDate >= CAST(GETDATE() AS date)
                        AND ISNULL(ts.quantity, 0) < ISNULL(ts.maxParticipants, 0)
                  )
                ORDER BY placeName ASC
                """.formatted(safeColumn, safeColumn, safeColumn);

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                String place = rs.getString("placeName");
                if (!isBlank(place)) {
                    places.add(place.trim());
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return places;
    }


    public Map<String, Integer> getTourStatusCounts() {
        Map<String, Integer> counts = new HashMap<>();
        String sql = """
                SELECT [status], COUNT(*) AS total
                FROM Tour
                GROUP BY [status]
                """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                counts.put(rs.getString("status"), rs.getInt("total"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        counts.putIfAbsent("Draft", 0);
        counts.putIfAbsent("Pending", 0);
        counts.putIfAbsent("Active", 0);
        counts.putIfAbsent("Rejected", 0);
        counts.putIfAbsent("Inactive", 0);
        return counts;
    }

    public List<String> getTourReadinessErrors(int tourID) {
        List<String> errors = new ArrayList<>();
        Tour tour = getTourById(tourID);
        if (tour == null) {
            errors.add("Tour không tồn tại.");
            return errors;
        }

        if (isBlank(tour.getTourName())) {
            errors.add("Thiếu tên tour.");
        }
        if (tour.getTourCategoryID() <= 0) {
            errors.add("Thiếu danh mục tour.");
        }
        if (tour.getNumberOfDay() <= 0 || tour.getNumberOfDay() > 15) {
            errors.add("Số ngày tour không hợp lệ.");
        }
        if (isBlank(tour.getStartPlace()) || isBlank(tour.getEndPlace())) {
            errors.add("Thiếu điểm khởi hành hoặc điểm đến.");
        }
        if (isBlank(tour.getImage())) {
            errors.add("Thiếu ảnh bìa tour.");
        }
        int itineraryCount = countActiveItineraries(tourID);
        if (itineraryCount < tour.getNumberOfDay()) {
            errors.add("Lịch trình từng ngày chưa đủ theo số ngày tour.");
        }

        int scheduleCount = countValidSchedulesForApproval(tourID);
        if (scheduleCount <= 0) {
            errors.add("Tour cần có ít nhất một lịch khởi hành trong tương lai, còn chỗ và có giá người lớn hợp lệ.");
        }

        if (!getDuplicateScheduleStartDateMap(tourID).isEmpty()) {
            errors.add("Tour đang có lịch khởi hành bị trùng ngày. Vui lòng sửa hoặc đóng lịch trùng trước khi gửi duyệt.");
        }

        if (!getSchedulePriceWarningMap(tourID).isEmpty()) {
            errors.add("Tour đang có lịch có giá bất thường. Giá người lớn phải lớn hơn 100.000, giá trẻ em 5-10 tuổi bằng 50% giá người lớn và phụ thu phòng đơn không được âm.");
        }

        return errors;
    }

    public List<TourReadinessItem> getTourReadinessChecklist(int tourID) {
        List<TourReadinessItem> checklist = new ArrayList<>();
        Tour tour = getTourById(tourID);
        if (tour == null) {
            checklist.add(new TourReadinessItem("Hồ sơ tour", false, "Tour không tồn tại."));
            return checklist;
        }

        int itineraryCount = countActiveItineraries(tourID);
        int validScheduleCount = countValidSchedulesForApproval(tourID);
        boolean hasDuplicateStartDate = !getDuplicateScheduleStartDateMap(tourID).isEmpty();
        boolean hasPriceWarnings = !getSchedulePriceWarningMap(tourID).isEmpty();

        boolean identityReady = !isBlank(tour.getTourName())
                && tour.getTourCategoryID() > 0
                && tour.getNumberOfDay() > 0
                && tour.getNumberOfDay() <= 15
                && !isBlank(tour.getStartPlace())
                && !isBlank(tour.getEndPlace());
        checklist.add(new TourReadinessItem(
                "Thông tin định danh",
                identityReady,
                identityReady
                        ? "Tên tour, danh mục, tuyến đi và thời lượng đã hợp lệ."
                        : "Cần đủ tên tour, danh mục, điểm đi/đến và số ngày hợp lệ."
        ));

        boolean imageReady = !isBlank(tour.getImage());
        checklist.add(new TourReadinessItem(
                "Ảnh đại diện",
                imageReady,
                imageReady ? "Tour đã có ảnh đại diện để hiển thị cho khách." : "Cần thêm ảnh đại diện trước khi gửi duyệt."
        ));

        boolean highlightReady = !isBlank(tour.getTourInclude());
        checklist.add(new TourReadinessItem(
                "Điểm nổi bật",
                highlightReady,
                highlightReady ? "Đã có nội dung điểm nổi bật/dịch vụ chính." : "Nên thêm điểm nổi bật để Admin và khách dễ kiểm tra tour."
        ));

        boolean itineraryReady = itineraryCount >= tour.getNumberOfDay();
        checklist.add(new TourReadinessItem(
                "Lịch trình từng ngày",
                itineraryReady,
                itineraryReady
                        ? "Đã có đủ lịch trình theo số ngày của tour."
                        : "Cần ít nhất " + tour.getNumberOfDay() + " ngày lịch trình, hiện có " + itineraryCount + "."
        ));

        boolean scheduleReady = validScheduleCount > 0;
        checklist.add(new TourReadinessItem(
                "Lịch khởi hành và giá",
                scheduleReady,
                scheduleReady
                        ? "Có ít nhất một lịch trong tương lai, còn chỗ và giá người lớn hợp lệ."
                        : "Cần thêm ít nhất một lịch trong tương lai, còn chỗ và có giá người lớn hợp lệ."
        ));

        checklist.add(new TourReadinessItem(
                "Không trùng ngày khởi hành",
                !hasDuplicateStartDate,
                hasDuplicateStartDate
                        ? "Đang có lịch cùng ngày khởi hành trong tour này. Staff nên sửa hoặc đóng lịch trùng trước khi gửi duyệt."
                        : "Không phát hiện lịch trùng ngày khởi hành."
        ));

        checklist.add(new TourReadinessItem(
                "Không có giá bất thường",
                !hasPriceWarnings,
                hasPriceWarnings
                        ? "Có lịch có giá chưa đúng rule: người lớn > 100.000, trẻ em 5-10 tuổi = 50%, phụ thu >= 0."
                        : "Giá lịch đang đúng rule kiểm tra."
        ));

        return checklist;
    }

    public static class TourReadinessItem {
        private final String title;
        private final boolean ready;
        private final String detail;

        public TourReadinessItem(String title, boolean ready, String detail) {
            this.title = title;
            this.ready = ready;
            this.detail = detail;
        }

        public String getTitle() {
            return title;
        }

        public boolean isReady() {
            return ready;
        }

        public boolean getReady() {
            return ready;
        }

        public String getDetail() {
            return detail;
        }
    }

    private int countActiveItineraries(int tourID) {
        String sql = """
                SELECT COUNT(*)
                FROM Tour_Itinerary
                WHERE tourID = ?
                  AND (status IS NULL OR status = N'Active')
                """;
        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tourID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    private int countValidSchedulesForApproval(int tourID) {
        String sql = """
                SELECT COUNT(*)
                FROM Tour_Scheduler
                WHERE tourID = ?
                  AND scheduleStatus IN (N'Planned', N'Open')
                  AND startDate >= CAST(GETDATE() AS DATE)
                  AND maxParticipants > 0
                  AND quantity < maxParticipants
                  AND adultPrice > 100000
                  AND childPrice = ROUND(adultPrice * 0.5, 0)
                  AND ISNULL(singleRoomSurcharge, 0) >= 0
                """;
        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tourID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean submitTourForApproval(int tourID) {
        String sql = """
                UPDATE Tour
                SET [status] = N'Pending', rejectionReason = NULL, updatedAt = GETDATE()
                WHERE tourID = ?
                  AND [status] IN (N'Draft', N'Rejected')
                """;
        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tourID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean approveTour(int tourID, int adminUserID, boolean openValidSchedules) {
        Connection conn = null;
        try {
            conn = new DBConnection().getConnection();
            conn.setAutoCommit(false);

            String sql = """
                    UPDATE Tour
                    SET [status] = N'Active',
                        approvedByUserID = ?,
                        approvedAt = GETDATE(),
                        rejectionReason = NULL,
                        updatedAt = GETDATE()
                    WHERE tourID = ?
                      AND [status] = N'Pending'
                    """;
            int updated;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, adminUserID);
                ps.setInt(2, tourID);
                updated = ps.executeUpdate();
            }

            if (updated <= 0) {
                conn.rollback();
                return false;
            }

            if (openValidSchedules) {
                String openSql = """
                        UPDATE Tour_Scheduler
                        SET scheduleStatus = N'Open', updatedAt = GETDATE()
                        WHERE tourID = ?
                          AND scheduleStatus = N'Planned'
                          AND startDate >= CAST(GETDATE() AS DATE)
                          AND quantity < maxParticipants
                        """;
                try (PreparedStatement ps = conn.prepareStatement(openSql)) {
                    ps.setInt(1, tourID);
                    ps.executeUpdate();
                }
            }

            conn.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            rollbackQuietly(conn);
        } finally {
            closeQuietly(conn);
        }
        return false;
    }

    public boolean rejectTour(int tourID, int adminUserID, String rejectionReason) {
        String sql = """
                UPDATE Tour
                SET [status] = N'Rejected',
                    approvedByUserID = ?,
                    approvedAt = NULL,
                    rejectionReason = ?,
                    updatedAt = GETDATE()
                WHERE tourID = ?
                  AND [status] = N'Pending'
                """;
        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, adminUserID);
            ps.setString(2, rejectionReason == null ? "" : rejectionReason.trim());
            ps.setInt(3, tourID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean setTourInactive(int tourID) {
        Connection conn = null;
        try {
            conn = new DBConnection().getConnection();
            conn.setAutoCommit(false);

            String tourSql = """
                    UPDATE Tour
                    SET [status] = N'Inactive', updatedAt = GETDATE()
                    WHERE tourID = ?
                      AND [status] = N'Active'
                    """;
            int updated;
            try (PreparedStatement ps = conn.prepareStatement(tourSql)) {
                ps.setInt(1, tourID);
                updated = ps.executeUpdate();
            }

            if (updated <= 0) {
                conn.rollback();
                return false;
            }

            String scheduleSql = """
                    UPDATE Tour_Scheduler
                    SET scheduleStatus = N'Closed', updatedAt = GETDATE()
                    WHERE tourID = ?
                      AND scheduleStatus = N'Open'
                    """;
            try (PreparedStatement ps = conn.prepareStatement(scheduleSql)) {
                ps.setInt(1, tourID);
                ps.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            rollbackQuietly(conn);
        } finally {
            closeQuietly(conn);
        }
        return false;
    }

    public boolean reactivateTour(int tourID, int adminUserID) {
        String sql = """
                UPDATE Tour
                SET [status] = N'Active',
                    approvedByUserID = COALESCE(approvedByUserID, ?),
                    approvedAt = COALESCE(approvedAt, GETDATE()),
                    updatedAt = GETDATE()
                WHERE tourID = ?
                  AND [status] = N'Inactive'
                """;
        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, adminUserID);
            ps.setInt(2, tourID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private Tour mapTour(ResultSet rs) throws Exception {
        Tour tour = new Tour();

        tour.setTourID(rs.getInt("tourID"));
        tour.setTourCategoryID(rs.getInt("tourCategoryID"));
        tour.setTourName(rs.getString("tourName"));
        tour.setTourCode(rs.getString("tourCode"));
        tour.setTourType(rs.getString("tourType"));
        tour.setNumberOfDay(rs.getInt("numberOfDay"));
        int nights = rs.getInt("numberOfNights");
        tour.setNumberOfNights(rs.wasNull() ? null : nights);
        tour.setStartPlace(rs.getString("startPlace"));
        tour.setEndPlace(rs.getString("endPlace"));
        tour.setImage(rs.getString("image"));
        tour.setAdultPrice(rs.getBigDecimal("adultPrice"));
        tour.setChildrenPrice(rs.getBigDecimal("childrenPrice"));
        tour.setInfantPrice(rs.getBigDecimal("infantPrice"));
        tour.setSingleRoomSurcharge(rs.getBigDecimal("singleRoomSurcharge"));
        tour.setDepositPercent(rs.getInt("depositPercent"));
        tour.setVatPercent(rs.getInt("vatPercent"));
        tour.setTourIntroduce(rs.getString("tourIntroduce"));
        tour.setTourInclude(rs.getString("tourInclude"));
        tour.setTourNonInclude(rs.getString("tourNonInclude"));
        tour.setPickupPointName(rs.getString("pickupPointName"));
        tour.setPickupAddress(rs.getString("pickupAddress"));
        int arriveBeforeMinutes = rs.getInt("arriveBeforeMinutes");
        tour.setArriveBeforeMinutes(rs.wasNull() ? null : arriveBeforeMinutes);
        tour.setPickupNote(rs.getString("pickupNote"));
        tour.setMainTransportType(rs.getString("mainTransportType"));
        tour.setChildPolicyNote(rs.getString("childPolicyNote"));
        tour.setRate(rs.getBigDecimal("rate"));
        tour.setStatus(rs.getString("status"));
        tour.setFeatured(rs.getBoolean("isFeatured"));
        int regionID = rs.getInt("regionID");
        tour.setRegionID(rs.wasNull() ? null : regionID);
        int createdByUserID = rs.getInt("createdByUserID");
        tour.setCreatedByUserID(rs.wasNull() ? null : createdByUserID);
        int approvedByUserID = rs.getInt("approvedByUserID");
        tour.setApprovedByUserID(rs.wasNull() ? null : approvedByUserID);
        tour.setApprovedAt(rs.getTimestamp("approvedAt"));
        tour.setRejectionReason(rs.getString("rejectionReason"));
        tour.setCreatedAt(rs.getTimestamp("createdAt"));
        tour.setUpdatedAt(rs.getTimestamp("updatedAt"));
        tour.setCategoryName(rs.getString("categoryName"));
        tour.setRegionName(rs.getString("regionName"));
        tour.setCreatedByName(rs.getString("createdByName"));
        tour.setApprovedByName(rs.getString("approvedByName"));
        tour.setScheduleCount(rs.getInt("scheduleCount"));
        tour.setBookingCount(rs.getInt("bookingCount"));

        return tour;
    }

    private TourItinerary mapItinerary(ResultSet rs) throws Exception {
        TourItinerary itinerary = new TourItinerary();
        itinerary.setItineraryID(rs.getInt("itineraryID"));
        itinerary.setTourID(rs.getInt("tourID"));
        itinerary.setDayNumber(rs.getInt("dayNumber"));
        itinerary.setTitle(rs.getString("title"));
        itinerary.setDescription(rs.getString("description"));
        itinerary.setMealPlan(rs.getString("mealPlan"));
        itinerary.setTransportNote(rs.getString("transportNote"));
        itinerary.setStatus(rs.getString("status"));
        return itinerary;
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
        int vatPercent = rs.getInt("vatPercent");
        schedule.setVatPercent(rs.wasNull() ? null : vatPercent);
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

    private void setNullableString(PreparedStatement ps, int index, String value) throws Exception {
        if (isBlank(value)) {
            ps.setNull(index, Types.NVARCHAR);
        } else {
            ps.setString(index, value.trim());
        }
    }

    private void setInteger(PreparedStatement ps, int index, Integer value) throws Exception {
        if (value == null) {
            ps.setNull(index, Types.INTEGER);
        } else {
            ps.setInt(index, value);
        }
    }

    private void rollbackQuietly(Connection conn) {
        if (conn != null) {
            try {
                conn.rollback();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    private void closeQuietly(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
