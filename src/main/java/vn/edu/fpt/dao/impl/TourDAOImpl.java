package vn.edu.fpt.dao.impl;

import vn.edu.fpt.dao.LookupDAO;
import vn.edu.fpt.dao.TourDAO;
import vn.edu.fpt.model.TourCreateRequest;
import vn.edu.fpt.model.TourDetailDTO;
import vn.edu.fpt.model.TourItineraryRequest;
import vn.edu.fpt.model.TourListItem;
import vn.edu.fpt.model.TourOptionalServiceRequest;
import vn.edu.fpt.model.TourScheduleDTO;
import vn.edu.fpt.model.TourScheduleRequest;
import vn.edu.fpt.utils.DBContext;
import vn.edu.fpt.utils.TourBusinessRule;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Time;
import java.sql.Types;
import java.time.LocalDate;
import java.time.Year;
import java.util.ArrayList;
import java.util.List;

public class TourDAOImpl implements TourDAO {
    private final LookupDAO lookupDAO = new LookupDAOImpl();

    @Override
    public String generateNextTourCode(Connection conn) throws SQLException {
        String prefix = "T" + Year.now().getValue() + "-";
        String sql = "SELECT TOP 1 tourCode FROM dbo.Tour WITH (UPDLOCK, HOLDLOCK) WHERE tourCode LIKE ? ORDER BY tourCode DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, prefix + "%");
            try (ResultSet rs = ps.executeQuery()) {
                int next = 1;
                if (rs.next()) {
                    String lastCode = rs.getString("tourCode");
                    String[] parts = lastCode == null ? new String[0] : lastCode.split("-");
                    if (parts.length == 2) {
                        try { next = Integer.parseInt(parts[1]) + 1; } catch (NumberFormatException ignored) { next = 1; }
                    }
                }
                return prefix + String.format("%04d", next);
            }
        }
    }

    @Override
    public int createTourWithSchedules(Connection conn, TourCreateRequest request, Integer createdByUserID)
            throws SQLException {
        int tourID = insertTour(conn, request, createdByUserID);
        for (TourScheduleRequest schedule : request.getSchedules()) {
            int scheduleID = insertTourSchedule(conn, tourID, schedule, createdByUserID, TourBusinessRule.SCHEDULE_DRAFT);
            replaceStaffAssignments(conn, scheduleID, schedule.getGuideStaffID(), schedule.getDriverStaffID());
        }
        replaceItineraries(conn, tourID, request.getItineraries());
        replaceOptionalServices(conn, tourID, request.getOptionalServices());
        replaceTourImages(conn, tourID, request.getCoverImageUrl(), request.getImageUrls());
        return tourID;
    }

    @Override
    public void updateTourFull(Connection conn, int tourID, TourCreateRequest request, Integer updatedByUserID)
            throws SQLException {
        updateTourBasic(conn, tourID, request, updatedByUserID);
        deleteAssignmentsByTour(conn, tourID);
        deleteSchedulesByTour(conn, tourID);
        for (TourScheduleRequest schedule : request.getSchedules()) {
            int scheduleID = insertTourSchedule(conn, tourID, schedule, updatedByUserID, TourBusinessRule.SCHEDULE_DRAFT);
            replaceStaffAssignments(conn, scheduleID, schedule.getGuideStaffID(), schedule.getDriverStaffID());
        }
        replaceItineraries(conn, tourID, request.getItineraries());
        replaceOptionalServices(conn, tourID, request.getOptionalServices());
        replaceTourImages(conn, tourID, request.getCoverImageUrl(), request.getImageUrls());
    }

    @Override
    public void updateSchedulesOnly(Connection conn, int tourID, TourCreateRequest request, Integer updatedByUserID)
            throws SQLException {
        for (TourScheduleRequest schedule : request.getSchedules()) {
            if (schedule.getTourScheduleID() != null && schedule.getTourScheduleID() > 0) {
                if (isScheduleEditable(conn, schedule.getTourScheduleID())) {
                    updateTourSchedule(conn, tourID, schedule, updatedByUserID);
                    replaceStaffAssignments(conn, schedule.getTourScheduleID(), schedule.getGuideStaffID(), schedule.getDriverStaffID());
                }
            } else {
                int scheduleID = insertTourSchedule(conn, tourID, schedule, updatedByUserID, TourBusinessRule.SCHEDULE_OPEN);
                replaceStaffAssignments(conn, scheduleID, schedule.getGuideStaffID(), schedule.getDriverStaffID());
            }
        }
    }

    private int insertTour(Connection conn, TourCreateRequest request, Integer createdByUserID)
            throws SQLException {
        TourScheduleRequest firstSchedule = request.getSchedules().isEmpty() ? null : request.getSchedules().get(0);
        String departurePlace = safeString(lookupDAO.getDestinationNameByID(request.getDepartureDestinationID()));
        String destination = safeString(lookupDAO.getDestinationNameByID(request.getDestinationID()));
        int adultPrice = firstSchedule == null ? 0 : firstSchedule.getAdultPrice();
        int childPrice = firstSchedule == null ? 0 : firstSchedule.getChildPrice();
        int infantPrice = firstSchedule == null ? 0 : firstSchedule.getInfantPrice();
        int singleRoomSurcharge = firstSchedule == null ? 0 : firstSchedule.getSingleRoomSurcharge();
        int depositPercent = firstSchedule == null ? 30 : firstSchedule.getDepositPercent();
        int vatPercent = firstSchedule == null ? 8 : firstSchedule.getVatPercent();

        String sql = "INSERT INTO dbo.Tour ("
                + "tourCategoryID, regionID, tourCode, tourName, tourType, "
                + "departurePlace, destination, numberOfDays, numberOfNights, "
                + "pickupPointName, pickupTime, mainTransportType, vehicleSeatCount, "
                + "shortDescription, description, coverImageUrl, "
                + "adultPrice, childPrice, infantPrice, singleRoomSurcharge, depositPercent, vatPercent, "
                + "tourStatus, createdByUserID, createdAt, updatedAt"
                + ") VALUES (?, ?, ?, ?, N'Domestic', ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, N'Draft', ?, GETDATE(), GETDATE())";

        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            bindTourBasicParams(ps, request, departurePlace, destination, 1);
            ps.setInt(16, adultPrice);
            ps.setInt(17, childPrice);
            ps.setInt(18, infantPrice);
            ps.setInt(19, singleRoomSurcharge);
            ps.setInt(20, depositPercent);
            ps.setInt(21, vatPercent);
            if (createdByUserID == null) ps.setNull(22, Types.INTEGER); else ps.setInt(22, createdByUserID);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        throw new SQLException("Không lấy được tourID sau khi tạo tour.");
    }

    private void updateTourBasic(Connection conn, int tourID, TourCreateRequest request, Integer updatedByUserID)
            throws SQLException {
        TourScheduleRequest firstSchedule = request.getSchedules().isEmpty() ? null : request.getSchedules().get(0);
        String departurePlace = lookupDAO.getDestinationNameByID(request.getDepartureDestinationID());
        String destination = lookupDAO.getDestinationNameByID(request.getDestinationID());
        int adultPrice = firstSchedule == null ? 0 : firstSchedule.getAdultPrice();
        int childPrice = firstSchedule == null ? 0 : firstSchedule.getChildPrice();
        int infantPrice = firstSchedule == null ? 0 : firstSchedule.getInfantPrice();
        int singleRoomSurcharge = firstSchedule == null ? 0 : firstSchedule.getSingleRoomSurcharge();
        int depositPercent = firstSchedule == null ? 30 : firstSchedule.getDepositPercent();
        int vatPercent = firstSchedule == null ? 8 : firstSchedule.getVatPercent();

        String sql = "UPDATE dbo.Tour SET "
                + "tourCategoryID = CASE WHEN ? > 0 THEN ? ELSE tourCategoryID END, "
                + "regionID = COALESCE(?, regionID), "
                + "tourName=?, "
                + "departurePlace = CASE WHEN ? IS NOT NULL AND ? <> N'' THEN ? ELSE departurePlace END, "
                + "destination = CASE WHEN ? IS NOT NULL AND ? <> N'' THEN ? ELSE destination END, "
                + "numberOfDays=?, numberOfNights=?, pickupPointName=?, pickupTime=?, "
                + "mainTransportType=?, vehicleSeatCount=?, shortDescription=?, description=?, coverImageUrl=?, "
                + "adultPrice=?, childPrice=?, infantPrice=?, singleRoomSurcharge=?, depositPercent=?, vatPercent=?, updatedAt=GETDATE() "
                + "WHERE tourID=? AND tourStatus IN (N'Draft', N'Rejected')";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            int idx = 1;
            ps.setInt(idx++, request.getTourCategoryID());
            ps.setInt(idx++, request.getTourCategoryID());
            if (request.getRegionID() == null || request.getRegionID() <= 0) ps.setNull(idx++, Types.INTEGER); else ps.setInt(idx++, request.getRegionID());
            ps.setString(idx++, request.getTourName());
            ps.setString(idx++, departurePlace); ps.setString(idx++, departurePlace); ps.setString(idx++, departurePlace);
            ps.setString(idx++, destination); ps.setString(idx++, destination); ps.setString(idx++, destination);
            ps.setInt(idx++, request.getNumberOfDays());
            ps.setInt(idx++, request.getNumberOfNights());
            ps.setString(idx++, request.getPickupPointName());
            if (request.getPickupTime() == null) ps.setNull(idx++, Types.TIME); else ps.setTime(idx++, Time.valueOf(request.getPickupTime()));
            ps.setString(idx++, request.getMainTransportType());
            if (request.getVehicleSeatCount() == null) ps.setNull(idx++, Types.INTEGER); else ps.setInt(idx++, request.getVehicleSeatCount());
            ps.setString(idx++, request.getShortDescription());
            ps.setString(idx++, request.getDescription());
            ps.setString(idx++, request.getCoverImageUrl());
            ps.setInt(idx++, adultPrice);
            ps.setInt(idx++, childPrice);
            ps.setInt(idx++, infantPrice);
            ps.setInt(idx++, singleRoomSurcharge);
            ps.setInt(idx++, depositPercent);
            ps.setInt(idx++, vatPercent);
            ps.setInt(idx, tourID);
            ps.executeUpdate();
        }
    }

    private void bindTourBasicParams(PreparedStatement ps, TourCreateRequest request, String departurePlace, String destination, int start)
            throws SQLException {
        ps.setInt(start, request.getTourCategoryID());
        if (request.getRegionID() == null) ps.setNull(start + 1, Types.INTEGER); else ps.setInt(start + 1, request.getRegionID());
        ps.setString(start + 2, request.getTourCode());
        ps.setString(start + 3, request.getTourName());
        ps.setString(start + 4, departurePlace);
        ps.setString(start + 5, destination);
        ps.setInt(start + 6, request.getNumberOfDays());
        ps.setInt(start + 7, request.getNumberOfNights());
        ps.setString(start + 8, request.getPickupPointName());
        if (request.getPickupTime() == null) ps.setNull(start + 9, Types.TIME); else ps.setTime(start + 9, Time.valueOf(request.getPickupTime()));
        ps.setString(start + 10, request.getMainTransportType());
        if (request.getVehicleSeatCount() == null) ps.setNull(start + 11, Types.INTEGER); else ps.setInt(start + 11, request.getVehicleSeatCount());
        ps.setString(start + 12, request.getShortDescription());
        ps.setString(start + 13, request.getDescription());
        ps.setString(start + 14, request.getCoverImageUrl());
    }

    private int insertTourSchedule(Connection conn, int tourID, TourScheduleRequest schedule, Integer userID, String status)
            throws SQLException {
        String sql = "INSERT INTO dbo.Tour_Schedule (tourID, departureDate, returnDate, bookingCloseDate, "
                + "minParticipants, maxParticipants, bookedSeats, adultPrice, childPrice, infantPrice, singleRoomSurcharge, "
                + "depositPercent, hasVAT, vatPercent, displayPrice, scheduleStatus, priceUpdatedAt, priceUpdatedByUserID, createdAt) "
                + "VALUES (?, ?, ?, ?, ?, ?, 0, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), ?, GETDATE())";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            bindScheduleParams(ps, tourID, schedule, status, userID, false);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) { if (rs.next()) return rs.getInt(1); }
        }
        throw new SQLException("Không lấy được tourScheduleID.");
    }

    private void updateTourSchedule(Connection conn, int tourID, TourScheduleRequest schedule, Integer userID)
            throws SQLException {
        String sql = "UPDATE dbo.Tour_Schedule SET departureDate=?, returnDate=?, bookingCloseDate=?, "
                + "minParticipants=?, maxParticipants=?, adultPrice=?, childPrice=?, infantPrice=?, singleRoomSurcharge=?, "
                + "depositPercent=?, hasVAT=?, vatPercent=?, displayPrice=?, priceUpdatedAt=GETDATE(), priceUpdatedByUserID=? "
                + "WHERE tourScheduleID=? AND tourID=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, Date.valueOf(schedule.getDepartureDate()));
            ps.setDate(2, Date.valueOf(schedule.getReturnDate()));
            ps.setDate(3, Date.valueOf(schedule.getBookingCloseDate()));
            ps.setInt(4, schedule.getMinParticipants());
            ps.setInt(5, schedule.getMaxParticipants());
            ps.setInt(6, schedule.getAdultPrice());
            ps.setInt(7, schedule.getChildPrice());
            ps.setInt(8, schedule.getInfantPrice());
            ps.setInt(9, schedule.getSingleRoomSurcharge());
            ps.setInt(10, schedule.getDepositPercent());
            ps.setBoolean(11, schedule.isHasVAT());
            ps.setInt(12, schedule.getVatPercent());
            ps.setInt(13, schedule.getDisplayPrice());
            if (userID == null) ps.setNull(14, Types.INTEGER); else ps.setInt(14, userID);
            ps.setInt(15, schedule.getTourScheduleID());
            ps.setInt(16, tourID);
            ps.executeUpdate();
        }
    }

    private void bindScheduleParams(PreparedStatement ps, int tourID, TourScheduleRequest schedule, String status, Integer userID, boolean update)
            throws SQLException {
        ps.setInt(1, tourID);
        ps.setDate(2, Date.valueOf(schedule.getDepartureDate()));
        ps.setDate(3, Date.valueOf(schedule.getReturnDate()));
        ps.setDate(4, Date.valueOf(schedule.getBookingCloseDate()));
        ps.setInt(5, schedule.getMinParticipants());
        ps.setInt(6, schedule.getMaxParticipants());
        ps.setInt(7, schedule.getAdultPrice());
        ps.setInt(8, schedule.getChildPrice());
        ps.setInt(9, schedule.getInfantPrice());
        ps.setInt(10, schedule.getSingleRoomSurcharge());
        ps.setInt(11, schedule.getDepositPercent());
        ps.setBoolean(12, schedule.isHasVAT());
        ps.setInt(13, schedule.getVatPercent());
        ps.setInt(14, schedule.getDisplayPrice());
        ps.setString(15, status);
        if (userID == null) ps.setNull(16, Types.INTEGER); else ps.setInt(16, userID);
    }

    private boolean isScheduleEditable(Connection conn, int scheduleID) throws SQLException {
        String sql = "SELECT scheduleStatus, bookedSeats, departureDate FROM dbo.Tour_Schedule WHERE tourScheduleID=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, scheduleID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    LocalDate dep = rs.getDate("departureDate") == null ? null : rs.getDate("departureDate").toLocalDate();
                    return TourBusinessRule.canEditSchedule(rs.getString("scheduleStatus"), rs.getInt("bookedSeats"), dep);
                }
            }
        }
        return false;
    }

    private void replaceStaffAssignments(Connection conn, int scheduleID, Integer guideStaffID, Integer driverStaffID) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement("DELETE FROM dbo.Tour_Assignment WHERE tourScheduleID=? AND roleInTour IN (N'Guide', N'Driver')")) {
            ps.setInt(1, scheduleID);
            ps.executeUpdate();
        }
        insertStaffAssignment(conn, scheduleID, guideStaffID, "Guide");
        insertStaffAssignment(conn, scheduleID, driverStaffID, "Driver");
    }

    private void insertStaffAssignment(Connection conn, int scheduleID, Integer staffID, String role) throws SQLException {
        if (staffID == null || staffID <= 0) return;
        String sql = "INSERT INTO dbo.Tour_Assignment (tourScheduleID, staffID, roleInTour, assignmentStatus, createdAt) VALUES (?, ?, ?, N'Pending', GETDATE())";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, scheduleID);
            ps.setInt(2, staffID);
            ps.setString(3, role);
            ps.executeUpdate();
        }
    }

    private void deleteAssignmentsByTour(Connection conn, int tourID) throws SQLException {
        String sql = "DELETE ta FROM dbo.Tour_Assignment ta JOIN dbo.Tour_Schedule ts ON ta.tourScheduleID = ts.tourScheduleID WHERE ts.tourID=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) { ps.setInt(1, tourID); ps.executeUpdate(); }
    }

    private void deleteSchedulesByTour(Connection conn, int tourID) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement("DELETE FROM dbo.Tour_Schedule WHERE tourID=?")) { ps.setInt(1, tourID); ps.executeUpdate(); }
    }

    private void replaceItineraries(Connection conn, int tourID, List<TourItineraryRequest> itineraries) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement("DELETE FROM dbo.Tour_Itinerary WHERE tourID=?")) { ps.setInt(1, tourID); ps.executeUpdate(); }
        if (itineraries == null || itineraries.isEmpty()) return;
        String sql = "INSERT INTO dbo.Tour_Itinerary (tourID, dayNumber, title, transportDescription, experienceActivities, activityDescription, accommodationDescription, note, createdAt) VALUES (?, ?, ?, ?, ?, ?, ?, ?, GETDATE())";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (TourItineraryRequest item : itineraries) {
                ps.setInt(1, tourID);
                ps.setInt(2, item.getDayNumber());
                ps.setString(3, "Ngày " + item.getDayNumber());
                ps.setString(4, item.getTransportDescription());
                ps.setString(5, item.getExperienceActivities());
                ps.setString(6, item.getExperienceActivities());
                ps.setString(7, item.getAccommodationDescription());
                ps.setString(8, item.getNote());
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }

    private void replaceOptionalServices(Connection conn, int tourID, List<TourOptionalServiceRequest> services) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement("DELETE FROM dbo.Tour_Optional_Service WHERE tourID=?")) { ps.setInt(1, tourID); ps.executeUpdate(); }
        if (services == null || services.isEmpty()) return;
        String sql = "INSERT INTO dbo.Tour_Optional_Service (tourID, externalServiceCode, serviceName, description, imageUrl, price, isDefaultSelected, status, createdAt) VALUES (?, ?, ?, ?, ?, ?, ?, N'Active', GETDATE())";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (TourOptionalServiceRequest item : services) {
                ps.setInt(1, tourID);
                ps.setString(2, item.getExternalServiceCode());
                ps.setString(3, item.getServiceName());
                ps.setString(4, item.getDescription());
                ps.setString(5, item.getImageUrl());
                ps.setInt(6, item.getPrice());
                ps.setBoolean(7, item.isDefaultSelected());
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }

    private void replaceTourImages(Connection conn, int tourID, String coverImageUrl, List<String> imageUrls) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement("DELETE FROM dbo.Tour_Image WHERE tourID=?")) { ps.setInt(1, tourID); ps.executeUpdate(); }
        String sql = "INSERT INTO dbo.Tour_Image (tourID, imageUrl, caption, sortOrder, isCover, createdAt) VALUES (?, ?, ?, ?, ?, GETDATE())";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            int sort = 1;
            if (coverImageUrl != null && !coverImageUrl.trim().isEmpty()) {
                ps.setInt(1, tourID); ps.setString(2, coverImageUrl); ps.setString(3, "Ảnh bìa"); ps.setInt(4, 0); ps.setBoolean(5, true); ps.addBatch();
            }
            if (imageUrls != null) {
                for (String url : imageUrls) {
                    if (url == null || url.trim().isEmpty()) continue;
                    ps.setInt(1, tourID); ps.setString(2, url); ps.setString(3, null); ps.setInt(4, sort++); ps.setBoolean(5, false); ps.addBatch();
                }
            }
            ps.executeBatch();
        }
    }

    @Override
    public String getTourStatus(int tourID) throws SQLException {
        String sql = "SELECT tourStatus FROM dbo.Tour WHERE tourID=?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tourID);
            try (ResultSet rs = ps.executeQuery()) { return rs.next() ? rs.getString(1) : null; }
        }
    }

    @Override
    public List<TourListItem> searchTours(String keyword, String status, Integer regionID, Integer categoryID) throws SQLException {
        List<TourListItem> list = new ArrayList<>();
        List<Object> params = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT t.tourID, t.tourCode, t.tourName, t.coverImageUrl, tc.tourCategoryName, r.regionName, t.destination, ");
        sql.append("t.numberOfDays, t.numberOfNights, t.tourStatus, t.createdAt, t.updatedAt, ");
        sql.append("(SELECT COUNT(*) FROM dbo.Tour_Schedule ts WHERE ts.tourID=t.tourID) AS scheduleCount FROM dbo.Tour t ");
        sql.append("LEFT JOIN dbo.Tour_Category tc ON t.tourCategoryID=tc.tourCategoryID LEFT JOIN dbo.Region r ON t.regionID=r.regionID WHERE 1=1 ");
        if (keyword != null && !keyword.trim().isEmpty()) { sql.append("AND (t.tourCode LIKE ? OR t.tourName LIKE ?) "); params.add("%"+keyword.trim()+"%"); params.add("%"+keyword.trim()+"%"); }
        if (status != null && !status.trim().isEmpty()) { sql.append("AND t.tourStatus=? "); params.add(status.trim()); }
        if (regionID != null && regionID > 0) { sql.append("AND t.regionID=? "); params.add(regionID); }
        if (categoryID != null && categoryID > 0) { sql.append("AND t.tourCategoryID=? "); params.add(categoryID); }
        sql.append("ORDER BY t.createdAt DESC");
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            bindParams(ps, params);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TourListItem item = new TourListItem();
                    item.setTourID(rs.getInt("tourID"));
                    item.setTourCode(rs.getString("tourCode"));
                    item.setTourName(rs.getString("tourName"));
                    item.setCoverImageUrl(rs.getString("coverImageUrl"));
                    item.setTourCategoryName(rs.getString("tourCategoryName"));
                    item.setRegionName(rs.getString("regionName"));
                    item.setDestination(rs.getString("destination"));
                    item.setNumberOfDays(rs.getInt("numberOfDays"));
                    item.setNumberOfNights(rs.getInt("numberOfNights"));
                    item.setTourStatus(rs.getString("tourStatus"));
                    item.setCreatedAt(rs.getTimestamp("createdAt"));
                    item.setUpdatedAt(rs.getTimestamp("updatedAt"));
                    item.setScheduleCount(rs.getInt("scheduleCount"));
                    list.add(item);
                }
            }
        }
        return list;
    }

    @Override
    public TourDetailDTO getTourDetailByID(int tourID) throws SQLException {
        TourDetailDTO tour = getTourBasic(tourID);
        if (tour == null) return null;
        tour.setSchedules(getSchedules(tourID));
        tour.setItineraries(getItineraries(tourID));
        tour.setOptionalServices(getOptionalServices(tourID));
        tour.setImageUrls(getImageUrls(tourID));
        return tour;
    }

    private TourDetailDTO getTourBasic(int tourID) throws SQLException {
        String sql = "SELECT t.tourID, t.tourCode, t.tourName, t.tourCategoryID, t.regionID, tc.tourCategoryName, r.regionName, t.departurePlace, t.destination, "
                + "t.pickupPointName, t.pickupTime, t.numberOfDays, t.numberOfNights, t.mainTransportType, t.vehicleSeatCount, "
                + "t.shortDescription, t.description, t.coverImageUrl, t.tourStatus, t.createdAt, t.updatedAt "
                + "FROM dbo.Tour t LEFT JOIN dbo.Tour_Category tc ON t.tourCategoryID=tc.tourCategoryID LEFT JOIN dbo.Region r ON t.regionID=r.regionID WHERE t.tourID=?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tourID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    TourDetailDTO dto = new TourDetailDTO();
                    dto.setTourID(rs.getInt("tourID")); dto.setTourCode(rs.getString("tourCode")); dto.setTourName(rs.getString("tourName"));
                    dto.setTourCategoryID(rs.getInt("tourCategoryID")); dto.setRegionID((Integer) rs.getObject("regionID"));
                    dto.setTourCategoryName(rs.getString("tourCategoryName")); dto.setRegionName(rs.getString("regionName"));
                    dto.setDeparturePlace(rs.getString("departurePlace")); dto.setDestination(rs.getString("destination"));
                    dto.setPickupPointName(rs.getString("pickupPointName")); dto.setPickupTime(rs.getTime("pickupTime"));
                    dto.setNumberOfDays(rs.getInt("numberOfDays")); dto.setNumberOfNights(rs.getInt("numberOfNights"));
                    dto.setMainTransportType(rs.getString("mainTransportType")); dto.setVehicleSeatCount((Integer) rs.getObject("vehicleSeatCount"));
                    dto.setShortDescription(rs.getString("shortDescription")); dto.setDescription(rs.getString("description")); dto.setCoverImageUrl(rs.getString("coverImageUrl"));
                    dto.setTourStatus(rs.getString("tourStatus")); dto.setCreatedAt(rs.getTimestamp("createdAt")); dto.setUpdatedAt(rs.getTimestamp("updatedAt"));
                    return dto;
                }
            }
        }
        return null;
    }

    private List<TourScheduleDTO> getSchedules(int tourID) throws SQLException {
        List<TourScheduleDTO> list = new ArrayList<>();
        String sql = "SELECT ts.tourScheduleID, ts.departureDate, ts.returnDate, ts.bookingCloseDate, ts.minParticipants, ts.maxParticipants, ts.bookedSeats, ts.scheduleStatus, "
                + "ts.adultPrice, ts.childPrice, ts.infantPrice, ts.singleRoomSurcharge, ts.depositPercent, ts.hasVAT, ts.vatPercent, ts.displayPrice, "
                + "gs.staffID AS guideStaffID, gs.staffCode AS guideCode, LTRIM(RTRIM(gu.firstName + N' ' + gu.lastName)) AS guideName, "
                + "ds.staffID AS driverStaffID, ds.staffCode AS driverCode, LTRIM(RTRIM(du.firstName + N' ' + du.lastName)) AS driverName "
                + "FROM dbo.Tour_Schedule ts "
                + "LEFT JOIN dbo.Tour_Assignment gta ON ts.tourScheduleID=gta.tourScheduleID AND gta.roleInTour=N'Guide' AND gta.assignmentStatus<>N'Cancelled' "
                + "LEFT JOIN dbo.Staff gs ON gta.staffID=gs.staffID LEFT JOIN dbo.[User] gu ON gs.userID=gu.userID "
                + "LEFT JOIN dbo.Tour_Assignment dta ON ts.tourScheduleID=dta.tourScheduleID AND dta.roleInTour=N'Driver' AND dta.assignmentStatus<>N'Cancelled' "
                + "LEFT JOIN dbo.Staff ds ON dta.staffID=ds.staffID LEFT JOIN dbo.[User] du ON ds.userID=du.userID "
                + "WHERE ts.tourID=? ORDER BY ts.departureDate";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tourID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TourScheduleDTO dto = new TourScheduleDTO();
                    dto.setTourScheduleID(rs.getInt("tourScheduleID")); dto.setDepartureDate(rs.getDate("departureDate")); dto.setReturnDate(rs.getDate("returnDate")); dto.setBookingCloseDate(rs.getDate("bookingCloseDate"));
                    dto.setMinParticipants(rs.getInt("minParticipants")); dto.setMaxParticipants(rs.getInt("maxParticipants")); dto.setBookedSeats(rs.getInt("bookedSeats")); dto.setScheduleStatus(rs.getString("scheduleStatus"));
                    dto.setAdultPrice(rs.getInt("adultPrice")); dto.setChildPrice(rs.getInt("childPrice")); dto.setInfantPrice(rs.getInt("infantPrice")); dto.setSingleRoomSurcharge(rs.getInt("singleRoomSurcharge"));
                    dto.setDepositPercent(rs.getInt("depositPercent")); dto.setHasVAT(rs.getBoolean("hasVAT")); dto.setVatPercent(rs.getInt("vatPercent")); dto.setDisplayPrice(rs.getInt("displayPrice"));
                    dto.setGuideStaffID((Integer) rs.getObject("guideStaffID"));
                    dto.setGuideCode(rs.getString("guideCode")); dto.setGuideName(rs.getString("guideName")); dto.setDriverStaffID((Integer) rs.getObject("driverStaffID")); dto.setDriverCode(rs.getString("driverCode")); dto.setDriverName(rs.getString("driverName"));
                    LocalDate dep = dto.getDepartureDate() == null ? null : dto.getDepartureDate().toLocalDate();
                    boolean editable = TourBusinessRule.canEditSchedule(dto.getScheduleStatus(), dto.getBookedSeats(), dep);
                    dto.setEditable(editable); dto.setLockedReason(editable ? null : "Lịch đã khóa theo trạng thái hoặc đã bán ở tháng cũ.");
                    list.add(dto);
                }
            }
        }
        return list;
    }

    private List<TourItineraryRequest> getItineraries(int tourID) throws SQLException {
        List<TourItineraryRequest> list = new ArrayList<>();
        String sql = "SELECT dayNumber, transportDescription, experienceActivities, accommodationDescription, note FROM dbo.Tour_Itinerary WHERE tourID=? ORDER BY dayNumber";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tourID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TourItineraryRequest item = new TourItineraryRequest();
                    item.setDayNumber(rs.getInt("dayNumber")); item.setTransportDescription(rs.getString("transportDescription")); item.setExperienceActivities(rs.getString("experienceActivities")); item.setAccommodationDescription(rs.getString("accommodationDescription")); item.setNote(rs.getString("note"));
                    list.add(item);
                }
            }
        }
        return list;
    }

    private List<TourOptionalServiceRequest> getOptionalServices(int tourID) throws SQLException {
        List<TourOptionalServiceRequest> list = new ArrayList<>();
        String sql = "SELECT externalServiceCode, serviceName, description, imageUrl, price, isDefaultSelected FROM dbo.Tour_Optional_Service WHERE tourID=? AND status=N'Active' ORDER BY optionalServiceID";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tourID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TourOptionalServiceRequest item = new TourOptionalServiceRequest();
                    item.setExternalServiceCode(rs.getString("externalServiceCode")); item.setServiceName(rs.getString("serviceName")); item.setDescription(rs.getString("description")); item.setImageUrl(rs.getString("imageUrl")); item.setPrice(rs.getInt("price")); item.setDefaultSelected(rs.getBoolean("isDefaultSelected"));
                    list.add(item);
                }
            }
        }
        return list;
    }

    private List<String> getImageUrls(int tourID) throws SQLException {
        List<String> list = new ArrayList<>();
        String sql = "SELECT imageUrl FROM dbo.Tour_Image WHERE tourID=? AND isCover=0 ORDER BY sortOrder, imageID";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tourID);
            try (ResultSet rs = ps.executeQuery()) { while (rs.next()) list.add(rs.getString("imageUrl")); }
        }
        return list;
    }

    @Override
    public void submitForApproval(int tourID, Integer userID) throws SQLException {
        try (Connection conn = DBContext.getConnection()) {
            try {
                conn.setAutoCommit(false);
                try (PreparedStatement ps = conn.prepareStatement(
                        "UPDATE dbo.Tour SET tourStatus=N'PendingApproval', updatedAt=GETDATE() "
                                + "WHERE tourID=? AND tourStatus IN (N'Draft', N'Rejected')")) {
                    ps.setInt(1, tourID);
                    ps.executeUpdate();
                }
                try (PreparedStatement ps = conn.prepareStatement(
                        "UPDATE dbo.Tour_Schedule SET scheduleStatus=N'PendingApproval' "
                                + "WHERE tourID=? AND scheduleStatus=N'Draft'")) {
                    ps.setInt(1, tourID);
                    ps.executeUpdate();
                }
                conn.commit();
            } catch (SQLException ex) {
                conn.rollback();
                throw ex;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }

    @Override
    public void approveTour(int tourID, Integer userID) throws SQLException {
        try (Connection conn = DBContext.getConnection()) {
            try {
                conn.setAutoCommit(false);
                try (PreparedStatement ps = conn.prepareStatement("UPDATE dbo.Tour SET tourStatus=N'Selling', updatedAt=GETDATE() WHERE tourID=? AND tourStatus=N'PendingApproval'")) { ps.setInt(1, tourID); ps.executeUpdate(); }
                try (PreparedStatement ps = conn.prepareStatement("UPDATE dbo.Tour_Schedule SET scheduleStatus=N'Open' WHERE tourID=? AND scheduleStatus IN (N'Draft', N'PendingApproval')")) { ps.setInt(1, tourID); ps.executeUpdate(); }
                conn.commit();
            } catch (SQLException ex) { conn.rollback(); throw ex; }
            finally { conn.setAutoCommit(true); }
        }
    }

    @Override
    public void markTourSoldOut(int tourID, Integer userID) throws SQLException {
        try (Connection conn = DBContext.getConnection()) {
            try {
                conn.setAutoCommit(false);
                try (PreparedStatement ps = conn.prepareStatement(
                        "UPDATE dbo.Tour SET tourStatus=N'SoldOut', updatedAt=GETDATE() "
                                + "WHERE tourID=? AND tourStatus IN (N'Selling', N'Approved')")) {
                    ps.setInt(1, tourID);
                    ps.executeUpdate();
                }

                try (PreparedStatement ps = conn.prepareStatement(
                        "UPDATE dbo.Tour_Schedule "
                                + "SET scheduleStatus = CASE WHEN bookedSeats >= maxParticipants THEN N'Full' ELSE N'Closed' END "
                                + "WHERE tourID=? AND scheduleStatus IN (N'Draft', N'PendingApproval', N'Open')")) {
                    ps.setInt(1, tourID);
                    ps.executeUpdate();
                }
                conn.commit();
            } catch (SQLException ex) {
                conn.rollback();
                throw ex;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }

    private void bindParams(PreparedStatement ps, List<Object> params) throws SQLException { for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i)); }
    private String safeString(String s) { return s == null ? "" : s; }
}
