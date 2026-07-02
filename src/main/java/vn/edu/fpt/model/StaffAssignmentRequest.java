package vn.edu.fpt.model;

public class StaffAssignmentRequest {
    private int tourScheduleID;
    private int staffID;
    private String roleInTour;
    private String assignmentStatus;
    private String note;

    public int getTourScheduleID() { return tourScheduleID; }
    public void setTourScheduleID(int tourScheduleID) { this.tourScheduleID = tourScheduleID; }

    public int getStaffID() { return staffID; }
    public void setStaffID(int staffID) { this.staffID = staffID; }

    public String getRoleInTour() { return roleInTour; }
    public void setRoleInTour(String roleInTour) { this.roleInTour = roleInTour; }

    public String getAssignmentStatus() { return assignmentStatus; }
    public void setAssignmentStatus(String assignmentStatus) { this.assignmentStatus = assignmentStatus; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
}
