package vn.edu.fpt.dao.impl;

import vn.edu.fpt.dao.ResourceAllocationDAO;
import vn.edu.fpt.model.ResourceAssignmentDTO;
import vn.edu.fpt.model.ResourceAssignmentRequest;
import vn.edu.fpt.model.ResourceOptionDTO;
import vn.edu.fpt.model.TourScheduleResourceDTO;
import vn.edu.fpt.utils.DBContext;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class ResourceAllocationDAOImpl implements ResourceAllocationDAO {
    @Override
    public List<TourScheduleResourceDTO> searchSchedules(String keyword, String scheduleStatus) throws Exception {
        List<TourScheduleResourceDTO> list = new ArrayList<>();
        String sql = """
            SELECT ts.tourScheduleID, ts.tourID, t.tourCode, t.tourName,
                   ts.departureDate, ts.returnDate, ts.bookingDeadline,
                   ts.minParticipants, ts.maxParticipants, ts.bookedSeats,
                   ts.scheduleStatus, t.tourStatus,
                   (
                       SELECT COUNT(1)
                       FROM dbo.Tour_Schedule_Service_Assignment a
                       WHERE a.tourScheduleID = ts.tourScheduleID
                         AND a.assignmentStatus <> N'Cancelled'
                   ) AS resourceCount
            FROM dbo.Tour_Schedule ts
            JOIN dbo.Tour t ON ts.tourID = t.tourID
            WHERE (? = N'' OR t.tourCode LIKE ? OR t.tourName LIKE ?)
              AND (? = N'' OR ts.scheduleStatus = ?)
            ORDER BY ts.departureDate DESC, ts.tourScheduleID DESC
            """;
        String kw = keyword == null ? "" : keyword.trim();
        String like = "%" + kw + "%";
        String status = scheduleStatus == null ? "" : scheduleStatus.trim();

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, kw);
            ps.setString(2, like);
            ps.setString(3, like);
            ps.setString(4, status);
            ps.setString(5, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapSchedule(rs));
                }
            }
        }
        return list;
    }

    @Override
    public TourScheduleResourceDTO findScheduleByID(int tourScheduleID) throws Exception {
        String sql = """
            SELECT ts.tourScheduleID, ts.tourID, t.tourCode, t.tourName,
                   ts.departureDate, ts.returnDate, ts.bookingDeadline,
                   ts.minParticipants, ts.maxParticipants, ts.bookedSeats,
                   ts.scheduleStatus, t.tourStatus,
                   (
                       SELECT COUNT(1)
                       FROM dbo.Tour_Schedule_Service_Assignment a
                       WHERE a.tourScheduleID = ts.tourScheduleID
                         AND a.assignmentStatus <> N'Cancelled'
                   ) AS resourceCount
            FROM dbo.Tour_Schedule ts
            JOIN dbo.Tour t ON ts.tourID = t.tourID
            WHERE ts.tourScheduleID = ?
            """;
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tourScheduleID);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapSchedule(rs) : null;
            }
        }
    }

    @Override
    public List<ResourceAssignmentDTO> getAssignmentsByScheduleID(int tourScheduleID) throws Exception {
        List<ResourceAssignmentDTO> list = new ArrayList<>();
        String sql = """
            SELECT a.assignmentID, a.tourScheduleID, a.serviceID, s.serviceName,
                   a.assignmentCategory, a.serviceDate, a.startDate, a.endDate,
                   a.vehicleID,
                   CONCAT(COALESCE(v.vehicleBrand, N''), N' ', COALESCE(v.vehicleType, N'')) AS vehicleName,
                   v.licensePlate,
                   a.driverStaffID,
                   CONCAT(COALESCE(u.lastName, N''), N' ', COALESCE(u.firstName, N'')) AS driverName,
                   a.roomID,
                   CONCAT(r.roomType, N' - ', r.capacityPerRoom, N' khách/phòng') AS roomName,
                   a.mealPackageID,
                   mp.packageName AS mealPackageName,
                   a.quantity, a.participantEstimate, a.estimatedCost, a.actualCost,
                   a.assignmentStatus, a.note
            FROM dbo.Tour_Schedule_Service_Assignment a
            JOIN dbo.Service s ON a.serviceID = s.serviceID
            LEFT JOIN dbo.Vehicle v ON a.vehicleID = v.vehicleID
            LEFT JOIN dbo.Staff ds ON a.driverStaffID = ds.staffID
            LEFT JOIN dbo.[User] u ON ds.userID = u.userID
            LEFT JOIN dbo.Room r ON a.roomID = r.roomID
            LEFT JOIN dbo.Meal_Package mp ON a.mealPackageID = mp.mealPackageID
            WHERE a.tourScheduleID = ?
            ORDER BY a.assignmentID DESC
            """;
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tourScheduleID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapAssignment(rs));
                }
            }
        }
        return list;
    }

    @Override
    public List<ResourceOptionDTO> getActiveServices() throws Exception {
        String sql = """
            SELECT serviceID AS value, serviceName AS label, serviceType AS type,
                   regionID, basePrice AS price, description AS extra
            FROM dbo.Service
            WHERE status = N'Active'
            ORDER BY serviceType, serviceName
            """;
        return queryOptions(sql);
    }

    @Override
    public List<ResourceOptionDTO> getAvailableVehicles() throws Exception {
        String sql = """
            SELECT v.vehicleID AS value,
                   CONCAT(COALESCE(v.vehicleBrand, N''), N' ', COALESCE(v.vehicleType, N''), N' - ', v.licensePlate, N' - ', v.seatCount, N' chỗ') AS label,
                   N'Vehicle' AS type,
                   v.regionID,
                   v.pricePerDay AS price,
                   v.status AS extra
            FROM dbo.Vehicle v
            WHERE v.status IN (N'Available', N'Busy')
            ORDER BY v.status, v.seatCount DESC, v.licensePlate
            """;
        return queryOptions(sql);
    }

    @Override
    public List<ResourceOptionDTO> getAvailableRooms() throws Exception {
        String sql = """
            SELECT r.roomID AS value,
                   CONCAT(r.roomType, N' - ', r.capacityPerRoom, N' khách/phòng - còn ', r.numberOfRooms, N' phòng') AS label,
                   N'Room' AS type,
                   NULL AS regionID,
                   r.pricePerRoom AS price,
                   r.status AS extra
            FROM dbo.Room r
            WHERE r.status = N'Available'
            ORDER BY r.roomType
            """;
        return queryOptions(sql);
    }

    @Override
    public List<ResourceOptionDTO> getActiveMealPackages() throws Exception {
        String sql = """
            SELECT mp.mealPackageID AS value,
                   CONCAT(mp.packageName, N' - ', COALESCE(mp.mealType, N'Other')) AS label,
                   N'Meal' AS type,
                   NULL AS regionID,
                   mp.pricePerPerson AS price,
                   mp.status AS extra
            FROM dbo.Meal_Package mp
            WHERE mp.status = N'Active'
            ORDER BY mp.packageName
            """;
        return queryOptions(sql);
    }

    @Override
    public List<ResourceOptionDTO> getWorkingDrivers() throws Exception {
        String sql = """
            SELECT s.staffID AS value,
                   CONCAT(s.staffCode, N' - ', COALESCE(u.lastName, N''), N' ', COALESCE(u.firstName, N''), N' - ', COALESCE(u.phone, N'')) AS label,
                   N'Driver' AS type,
                   NULL AS regionID,
                   NULL AS price,
                   s.licenseClass AS extra
            FROM dbo.Staff s
            JOIN dbo.[User] u ON s.userID = u.userID
            WHERE s.staffType = N'Driver'
              AND s.workStatus = N'Working'
              AND u.status = N'Active'
            ORDER BY s.staffCode
            """;
        return queryOptions(sql);
    }

    @Override
    public void insertAssignment(ResourceAssignmentRequest request, Integer createdByUserID) throws Exception {
        String sql = """
            INSERT INTO dbo.Tour_Schedule_Service_Assignment (
                tourScheduleID, serviceID, assignmentCategory, serviceDate, startDate, endDate,
                vehicleID, driverStaffID, roomID, mealPackageID,
                quantity, participantEstimate, estimatedCost, actualCost,
                assignmentStatus, note, createdByUserID, createdAt, updatedAt
            )
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), NULL)
            """;
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, request.getTourScheduleID());
            ps.setInt(2, request.getServiceID());
            ps.setString(3, request.getAssignmentCategory());
            setDate(ps, 4, request.getServiceDate());
            setDate(ps, 5, request.getStartDate());
            setDate(ps, 6, request.getEndDate());
            setNullableInt(ps, 7, request.getVehicleID());
            setNullableInt(ps, 8, request.getDriverStaffID());
            setNullableInt(ps, 9, request.getRoomID());
            setNullableInt(ps, 10, request.getMealPackageID());
            ps.setInt(11, request.getQuantity());
            setNullableInt(ps, 12, request.getParticipantEstimate());
            setNullableInt(ps, 13, request.getEstimatedCost());
            setNullableInt(ps, 14, request.getActualCost());
            ps.setString(15, request.getAssignmentStatus());
            ps.setString(16, request.getNote());
            setNullableInt(ps, 17, createdByUserID);
            ps.executeUpdate();
        }
    }

    @Override
    public void updateAssignmentStatus(int assignmentID, String assignmentStatus) throws Exception {
        String sql = """
            UPDATE dbo.Tour_Schedule_Service_Assignment
            SET assignmentStatus = ?, updatedAt = GETDATE()
            WHERE assignmentID = ?
            """;
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, assignmentStatus);
            ps.setInt(2, assignmentID);
            ps.executeUpdate();
        }
    }

    private List<ResourceOptionDTO> queryOptions(String sql) throws Exception {
        List<ResourceOptionDTO> list = new ArrayList<>();
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Integer regionID = rs.getObject("regionID") == null ? null : rs.getInt("regionID");
                Integer price = rs.getObject("price") == null ? null : rs.getInt("price");
                list.add(new ResourceOptionDTO(
                        rs.getInt("value"),
                        rs.getString("label"),
                        rs.getString("type"),
                        regionID,
                        price,
                        rs.getString("extra")
                ));
            }
        }
        return list;
    }

    private TourScheduleResourceDTO mapSchedule(ResultSet rs) throws Exception {
        TourScheduleResourceDTO dto = new TourScheduleResourceDTO();
        dto.setTourScheduleID(rs.getInt("tourScheduleID"));
        dto.setTourID(rs.getInt("tourID"));
        dto.setTourCode(rs.getString("tourCode"));
        dto.setTourName(rs.getString("tourName"));
        dto.setDepartureDate(rs.getDate("departureDate"));
        dto.setReturnDate(rs.getDate("returnDate"));
        dto.setBookingDeadline(rs.getTimestamp("bookingDeadline"));
        dto.setMinParticipants(rs.getInt("minParticipants"));
        dto.setMaxParticipants(rs.getInt("maxParticipants"));
        dto.setBookedSeats(rs.getInt("bookedSeats"));
        dto.setScheduleStatus(rs.getString("scheduleStatus"));
        dto.setTourStatus(rs.getString("tourStatus"));
        dto.setResourceCount(rs.getInt("resourceCount"));
        return dto;
    }

    private ResourceAssignmentDTO mapAssignment(ResultSet rs) throws Exception {
        ResourceAssignmentDTO dto = new ResourceAssignmentDTO();
        dto.setAssignmentID(rs.getInt("assignmentID"));
        dto.setTourScheduleID(rs.getInt("tourScheduleID"));
        dto.setServiceID(rs.getInt("serviceID"));
        dto.setServiceName(rs.getString("serviceName"));
        dto.setAssignmentCategory(rs.getString("assignmentCategory"));
        dto.setServiceDate(rs.getDate("serviceDate"));
        dto.setStartDate(rs.getDate("startDate"));
        dto.setEndDate(rs.getDate("endDate"));
        dto.setVehicleID(getNullableInt(rs, "vehicleID"));
        dto.setVehicleName(rs.getString("vehicleName"));
        dto.setLicensePlate(rs.getString("licensePlate"));
        dto.setDriverStaffID(getNullableInt(rs, "driverStaffID"));
        dto.setDriverName(rs.getString("driverName"));
        dto.setRoomID(getNullableInt(rs, "roomID"));
        dto.setRoomName(rs.getString("roomName"));
        dto.setMealPackageID(getNullableInt(rs, "mealPackageID"));
        dto.setMealPackageName(rs.getString("mealPackageName"));
        dto.setQuantity(rs.getInt("quantity"));
        dto.setParticipantEstimate(getNullableInt(rs, "participantEstimate"));
        dto.setEstimatedCost(getNullableInt(rs, "estimatedCost"));
        dto.setActualCost(getNullableInt(rs, "actualCost"));
        dto.setAssignmentStatus(rs.getString("assignmentStatus"));
        dto.setNote(rs.getString("note"));
        return dto;
    }

    private Integer getNullableInt(ResultSet rs, String column) throws Exception {
        int value = rs.getInt(column);
        return rs.wasNull() ? null : value;
    }

    private void setNullableInt(PreparedStatement ps, int index, Integer value) throws Exception {
        if (value == null || value <= 0) {
            ps.setNull(index, Types.INTEGER);
        } else {
            ps.setInt(index, value);
        }
    }

    private void setDate(PreparedStatement ps, int index, java.time.LocalDate value) throws Exception {
        if (value == null) {
            ps.setNull(index, Types.DATE);
        } else {
            ps.setDate(index, Date.valueOf(value));
        }
    }
}
