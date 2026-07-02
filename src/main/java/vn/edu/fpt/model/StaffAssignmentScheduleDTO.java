package vn.edu.fpt.model;

import java.sql.Date;
import java.sql.Timestamp;

public class StaffAssignmentScheduleDTO {
    private int tourScheduleID;
    private int tourID;
    private String tourCode;
    private String tourName;
    private Date departureDate;
    private Date returnDate;
    private Timestamp bookingDeadline;
    private int minParticipants;
    private int maxParticipants;
    private int bookedSeats;
    private String scheduleStatus;
    private String tourStatus;
    private int activeStaffCount;
    private int guideCount;
    private int driverCount;
    private int coordinatorCount;
    private int operationStaffCount;

    public int getTourScheduleID() { return tourScheduleID; }
    public void setTourScheduleID(int tourScheduleID) { this.tourScheduleID = tourScheduleID; }

    public int getTourID() { return tourID; }
    public void setTourID(int tourID) { this.tourID = tourID; }

    public String getTourCode() { return tourCode; }
    public void setTourCode(String tourCode) { this.tourCode = tourCode; }

    public String getTourName() { return tourName; }
    public void setTourName(String tourName) { this.tourName = tourName; }

    public Date getDepartureDate() { return departureDate; }
    public void setDepartureDate(Date departureDate) { this.departureDate = departureDate; }

    public Date getReturnDate() { return returnDate; }
    public void setReturnDate(Date returnDate) { this.returnDate = returnDate; }

    public Timestamp getBookingDeadline() { return bookingDeadline; }
    public void setBookingDeadline(Timestamp bookingDeadline) { this.bookingDeadline = bookingDeadline; }

    public int getMinParticipants() { return minParticipants; }
    public void setMinParticipants(int minParticipants) { this.minParticipants = minParticipants; }

    public int getMaxParticipants() { return maxParticipants; }
    public void setMaxParticipants(int maxParticipants) { this.maxParticipants = maxParticipants; }

    public int getBookedSeats() { return bookedSeats; }
    public void setBookedSeats(int bookedSeats) { this.bookedSeats = bookedSeats; }

    public String getScheduleStatus() { return scheduleStatus; }
    public void setScheduleStatus(String scheduleStatus) { this.scheduleStatus = scheduleStatus; }

    public String getTourStatus() { return tourStatus; }
    public void setTourStatus(String tourStatus) { this.tourStatus = tourStatus; }

    public int getActiveStaffCount() { return activeStaffCount; }
    public void setActiveStaffCount(int activeStaffCount) { this.activeStaffCount = activeStaffCount; }

    public int getGuideCount() { return guideCount; }
    public void setGuideCount(int guideCount) { this.guideCount = guideCount; }

    public int getDriverCount() { return driverCount; }
    public void setDriverCount(int driverCount) { this.driverCount = driverCount; }

    public int getCoordinatorCount() { return coordinatorCount; }
    public void setCoordinatorCount(int coordinatorCount) { this.coordinatorCount = coordinatorCount; }

    public int getOperationStaffCount() { return operationStaffCount; }
    public void setOperationStaffCount(int operationStaffCount) { this.operationStaffCount = operationStaffCount; }

    public String getPassengerSummary() {
        return bookedSeats + "/" + maxParticipants + " khách";
    }

    public boolean isBelowMinimum() {
        return bookedSeats < minParticipants;
    }

    public String getMinimumStatusText() {
        return isBelowMinimum() ? "Chưa đủ tối thiểu" : "Đủ tối thiểu";
    }

    public String getScheduleStatusText() {
        if ("Draft".equals(scheduleStatus)) return "Chưa mở bán";
        if ("PendingApproval".equals(scheduleStatus)) return "Chờ duyệt";
        if ("Open".equals(scheduleStatus)) return "Đang mở bán";
        if ("Full".equals(scheduleStatus)) return "Đã đủ khách";
        if ("Closed".equals(scheduleStatus)) return "Đã đóng bán";
        if ("Departed".equals(scheduleStatus)) return "Đã khởi hành";
        if ("Completed".equals(scheduleStatus)) return "Hoàn thành";
        if ("Cancelled".equals(scheduleStatus)) return "Đã hủy";
        return scheduleStatus;
    }

    public String getScheduleStatusCssClass() {
        if ("Open".equals(scheduleStatus)) return "status-approved";
        if ("PendingApproval".equals(scheduleStatus)) return "status-pending";
        if ("Full".equals(scheduleStatus) || "Completed".equals(scheduleStatus)) return "status-completed";
        if ("Closed".equals(scheduleStatus) || "Cancelled".equals(scheduleStatus)) return "status-cancelled";
        return "status-draft";
    }
}
