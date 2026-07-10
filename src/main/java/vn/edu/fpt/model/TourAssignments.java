package vn.edu.fpt.model;

import java.util.Date;

public class TourAssignments {
    private int assignmentID;
    private String assignmentCode;
    private int tourScheduleID;
    private int userID;
    private String roleInTour;
    private int bookingID;
    private int assignedBy;
    private String assignmentStatus;
    private String priorityLevel;
    private Date assignedAt;
    private Date acceptedAt;
    private Date rejectedAt;
    private String rejectionReason;
    private Date confirmedAt;
    private Date completedAt;
    private Date cancelledAt;
    private Date checkInDeadline;
    private Date actualStartAt;
    private Date actualEndAt;
    private String meetingPoint;
    private Date pickupTime;
    private String guideNameSnapshot;
    private String guidePhoneSnapshot;
    private String staffNote;
    private String guideNote;
    private String customerNote;
    private Date createdAt;
    private Date updatedAt;

    public TourAssignments() {
    }

    public TourAssignments(int assignmentID, int tourScheduleID, int userID, String roleInTour) {
        this.assignmentID = assignmentID;
        this.tourScheduleID = tourScheduleID;
        this.userID = userID;
        this.roleInTour = roleInTour;
    }

    public int getAssignmentID() {
        return assignmentID;
    }

    public void setAssignmentID(int assignmentID) {
        this.assignmentID = assignmentID;
    }

    public String getAssignmentCode() {
        return assignmentCode;
    }

    public void setAssignmentCode(String assignmentCode) {
        this.assignmentCode = assignmentCode;
    }

    public int getTourScheduleID() {
        return tourScheduleID;
    }

    public void setTourScheduleID(int tourScheduleID) {
        this.tourScheduleID = tourScheduleID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getRoleInTour() {
        return roleInTour;
    }

    public void setRoleInTour(String roleInTour) {
        this.roleInTour = roleInTour;
    }

    public int getBookingID() {
        return bookingID;
    }

    public void setBookingID(int bookingID) {
        this.bookingID = bookingID;
    }

    public int getAssignedBy() {
        return assignedBy;
    }

    public void setAssignedBy(int assignedBy) {
        this.assignedBy = assignedBy;
    }

    public String getAssignmentStatus() {
        return assignmentStatus;
    }

    public void setAssignmentStatus(String assignmentStatus) {
        this.assignmentStatus = assignmentStatus;
    }

    public String getPriorityLevel() {
        return priorityLevel;
    }

    public void setPriorityLevel(String priorityLevel) {
        this.priorityLevel = priorityLevel;
    }

    public Date getAssignedAt() {
        return assignedAt;
    }

    public void setAssignedAt(Date assignedAt) {
        this.assignedAt = assignedAt;
    }

    public Date getAcceptedAt() {
        return acceptedAt;
    }

    public void setAcceptedAt(Date acceptedAt) {
        this.acceptedAt = acceptedAt;
    }

    public Date getRejectedAt() {
        return rejectedAt;
    }

    public void setRejectedAt(Date rejectedAt) {
        this.rejectedAt = rejectedAt;
    }

    public String getRejectionReason() {
        return rejectionReason;
    }

    public void setRejectionReason(String rejectionReason) {
        this.rejectionReason = rejectionReason;
    }

    public Date getConfirmedAt() {
        return confirmedAt;
    }

    public void setConfirmedAt(Date confirmedAt) {
        this.confirmedAt = confirmedAt;
    }

    public Date getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(Date completedAt) {
        this.completedAt = completedAt;
    }

    public Date getCancelledAt() {
        return cancelledAt;
    }

    public void setCancelledAt(Date cancelledAt) {
        this.cancelledAt = cancelledAt;
    }

    public Date getCheckInDeadline() {
        return checkInDeadline;
    }

    public void setCheckInDeadline(Date checkInDeadline) {
        this.checkInDeadline = checkInDeadline;
    }

    public Date getActualStartAt() {
        return actualStartAt;
    }

    public void setActualStartAt(Date actualStartAt) {
        this.actualStartAt = actualStartAt;
    }

    public Date getActualEndAt() {
        return actualEndAt;
    }

    public void setActualEndAt(Date actualEndAt) {
        this.actualEndAt = actualEndAt;
    }

    public String getMeetingPoint() {
        return meetingPoint;
    }

    public void setMeetingPoint(String meetingPoint) {
        this.meetingPoint = meetingPoint;
    }

    public Date getPickupTime() {
        return pickupTime;
    }

    public void setPickupTime(Date pickupTime) {
        this.pickupTime = pickupTime;
    }

    public String getGuideNameSnapshot() {
        return guideNameSnapshot;
    }

    public void setGuideNameSnapshot(String guideNameSnapshot) {
        this.guideNameSnapshot = guideNameSnapshot;
    }

    public String getGuidePhoneSnapshot() {
        return guidePhoneSnapshot;
    }

    public void setGuidePhoneSnapshot(String guidePhoneSnapshot) {
        this.guidePhoneSnapshot = guidePhoneSnapshot;
    }

    public String getStaffNote() {
        return staffNote;
    }

    public void setStaffNote(String staffNote) {
        this.staffNote = staffNote;
    }

    public String getGuideNote() {
        return guideNote;
    }

    public void setGuideNote(String guideNote) {
        this.guideNote = guideNote;
    }

    public String getCustomerNote() {
        return customerNote;
    }

    public void setCustomerNote(String customerNote) {
        this.customerNote = customerNote;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }
}
