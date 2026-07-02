package vn.edu.fpt.model;

import java.sql.Date;
import java.sql.Timestamp;

public class StaffAssignmentDTO {
    private int assignmentID;
    private int tourScheduleID;
    private int tourID;
    private String tourCode;
    private String tourName;
    private Date departureDate;
    private Date returnDate;
    private String scheduleStatus;
    private String tourStatus;
    private int staffID;
    private String staffCode;
    private String staffName;
    private String phone;
    private String staffType;
    private String roleInTour;
    private String assignmentStatus;
    private String note;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public int getAssignmentID() { return assignmentID; }
    public void setAssignmentID(int assignmentID) { this.assignmentID = assignmentID; }

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

    public String getScheduleStatus() { return scheduleStatus; }
    public void setScheduleStatus(String scheduleStatus) { this.scheduleStatus = scheduleStatus; }

    public String getTourStatus() { return tourStatus; }
    public void setTourStatus(String tourStatus) { this.tourStatus = tourStatus; }

    public int getStaffID() { return staffID; }
    public void setStaffID(int staffID) { this.staffID = staffID; }

    public String getStaffCode() { return staffCode; }
    public void setStaffCode(String staffCode) { this.staffCode = staffCode; }

    public String getStaffName() { return staffName; }
    public void setStaffName(String staffName) { this.staffName = staffName; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getStaffType() { return staffType; }
    public void setStaffType(String staffType) { this.staffType = staffType; }

    public String getRoleInTour() { return roleInTour; }
    public void setRoleInTour(String roleInTour) { this.roleInTour = roleInTour; }

    public String getAssignmentStatus() { return assignmentStatus; }
    public void setAssignmentStatus(String assignmentStatus) { this.assignmentStatus = assignmentStatus; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public String getRoleText() {
        if ("Guide".equals(roleInTour)) return "Hướng dẫn viên";
        if ("Driver".equals(roleInTour)) return "Tài xế";
        if ("Coordinator".equals(roleInTour)) return "Điều phối viên";
        if ("OperationStaff".equals(roleInTour)) return "Nhân sự vận hành";
        if ("Other".equals(roleInTour)) return "Nhiệm vụ khác";
        return roleInTour;
    }

    public String getStatusText() {
        if ("Pending".equals(assignmentStatus)) return "Chờ nhận nhiệm vụ";
        if ("Accepted".equals(assignmentStatus)) return "Đã nhận nhiệm vụ";
        if ("Rejected".equals(assignmentStatus)) return "Từ chối";
        if ("Cancelled".equals(assignmentStatus)) return "Đã hủy";
        if ("Completed".equals(assignmentStatus)) return "Hoàn thành";
        return assignmentStatus;
    }

    public String getStatusCssClass() {
        if ("Pending".equals(assignmentStatus)) return "status-pending";
        if ("Accepted".equals(assignmentStatus)) return "status-approved";
        if ("Rejected".equals(assignmentStatus) || "Cancelled".equals(assignmentStatus)) return "status-rejected";
        if ("Completed".equals(assignmentStatus)) return "status-completed";
        return "status-draft";
    }

    public boolean isActiveAssignment() {
        return "Pending".equals(assignmentStatus) || "Accepted".equals(assignmentStatus);
    }
}
