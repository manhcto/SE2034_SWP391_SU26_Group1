package vn.edu.fpt.model;

import java.util.Date;

public class AssignmentView {

    private int assignmentID;
    private String assignmentCode;
    private int tourScheduleID;
    private int tourID;
    private int guideID;
    private int bookingID;
    private int assignedBy;
    private String bookingCode;
    private String bookingType;
    private String tourName;
    private String startPlace;
    private String endPlace;
    private String guideName;
    private String guideEmail;
    private String guidePhone;
    private String vehicleName;
    private String licensePlate;
    private String vehicleType;
    private int seatCount;
    private Date departureDate;
    private Date endDate;
    private Date bookDate;
    private String status;
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
    private String assignedByName;
    private String staffNote;
    private String guideNote;
    private String customerNote;
    private Date createdAt;
    private Date updatedAt;
    private String roleInTour;
    private String customerName;
    private String customerEmail;
    private String customerPhone;
    private String customerAddress;
    private String note;
    private int numberAdult;
    private int numberChildren;
    private int quantity;
    private int maxParticipants;
    private int bookedQuantity;
    private double unitPrice;
    private double subTotal;
    private double totalPrice;

    public AssignmentView() {
    }

    public AssignmentView(int assignmentID, int bookingID, String tourName, String guideName, String vehicleName, Date departureDate, String status) {
        this.assignmentID = assignmentID;
        this.bookingID = bookingID;
        this.tourName = tourName;
        this.guideName = guideName;
        this.vehicleName = vehicleName;
        this.departureDate = departureDate;
        this.status = status;
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

    public int getTourID() {
        return tourID;
    }

    public void setTourID(int tourID) {
        this.tourID = tourID;
    }

    public int getGuideID() {
        return guideID;
    }

    public void setGuideID(int guideID) {
        this.guideID = guideID;
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

    public String getBookingCode() {
        return bookingCode;
    }

    public void setBookingCode(String bookingCode) {
        this.bookingCode = bookingCode;
    }

    public String getBookingType() {
        return bookingType;
    }

    public void setBookingType(String bookingType) {
        this.bookingType = bookingType;
    }

    public String getTourName() {
        return tourName;
    }

    public void setTourName(String tourName) {
        this.tourName = tourName;
    }

    public String getStartPlace() {
        return startPlace;
    }

    public void setStartPlace(String startPlace) {
        this.startPlace = startPlace;
    }

    public String getEndPlace() {
        return endPlace;
    }

    public void setEndPlace(String endPlace) {
        this.endPlace = endPlace;
    }

    public String getGuideName() {
        return guideName;
    }

    public void setGuideName(String guideName) {
        this.guideName = guideName;
    }

    public String getGuideEmail() {
        return guideEmail;
    }

    public void setGuideEmail(String guideEmail) {
        this.guideEmail = guideEmail;
    }

    public String getGuidePhone() {
        return guidePhone;
    }

    public void setGuidePhone(String guidePhone) {
        this.guidePhone = guidePhone;
    }

    public String getVehicleName() {
        return vehicleName;
    }

    public void setVehicleName(String vehicleName) {
        this.vehicleName = vehicleName;
    }

    public String getLicensePlate() {
        return licensePlate;
    }

    public void setLicensePlate(String licensePlate) {
        this.licensePlate = licensePlate;
    }

    public String getVehicleType() {
        return vehicleType;
    }

    public void setVehicleType(String vehicleType) {
        this.vehicleType = vehicleType;
    }

    public int getSeatCount() {
        return seatCount;
    }

    public void setSeatCount(int seatCount) {
        this.seatCount = seatCount;
    }

    public Date getDepartureDate() {
        return departureDate;
    }

    public void setDepartureDate(Date departureDate) {
        this.departureDate = departureDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public Date getBookDate() {
        return bookDate;
    }

    public void setBookDate(Date bookDate) {
        this.bookDate = bookDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getAssignmentStatus() {
        return assignmentStatus;
    }

    public String getAssignmentStatusLabel() {
        if (assignmentStatus == null || assignmentStatus.trim().isEmpty()) {
            return "Chờ nhận tour";
        }

        return switch (assignmentStatus.trim()) {
            case "Assigned" -> "Chờ nhận tour";
            case "Pending" -> "Chờ nhận tour";
            case "Accepted" -> "Đã xác nhận";
            case "Confirmed" -> "Đã xác nhận";
            case "In Progress" -> "Đang diễn ra";
            case "Completed" -> "Hoàn thành";
            case "Cancelled", "Canceled" -> "Đã hủy";
            case "Rejected" -> "Từ chối";
            default -> assignmentStatus.trim();
        };
    }

    public void setAssignmentStatus(String assignmentStatus) {
        this.assignmentStatus = assignmentStatus;
    }

    public String getPriorityLevel() {
        return priorityLevel;
    }

    public String getPriorityLevelLabel() {
        if (priorityLevel == null || priorityLevel.trim().isEmpty()) {
            return "Bình thường";
        }

        return switch (priorityLevel.trim()) {
            case "Low" -> "Thấp";
            case "Normal" -> "Bình thường";
            case "High" -> "Cao";
            case "Urgent" -> "Khẩn cấp";
            default -> priorityLevel.trim();
        };
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

    public String getAssignedByName() {
        return assignedByName;
    }

    public void setAssignedByName(String assignedByName) {
        this.assignedByName = assignedByName;
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

    public String getRoleInTour() {
        return roleInTour;
    }

    public void setRoleInTour(String roleInTour) {
        this.roleInTour = roleInTour;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getCustomerEmail() {
        return customerEmail;
    }

    public void setCustomerEmail(String customerEmail) {
        this.customerEmail = customerEmail;
    }

    public String getCustomerPhone() {
        return customerPhone;
    }

    public void setCustomerPhone(String customerPhone) {
        this.customerPhone = customerPhone;
    }

    public String getCustomerAddress() {
        return customerAddress;
    }

    public void setCustomerAddress(String customerAddress) {
        this.customerAddress = customerAddress;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public int getNumberAdult() {
        return numberAdult;
    }

    public void setNumberAdult(int numberAdult) {
        this.numberAdult = numberAdult;
    }

    public int getNumberChildren() {
        return numberChildren;
    }

    public void setNumberChildren(int numberChildren) {
        this.numberChildren = numberChildren;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public int getMaxParticipants() {
        return maxParticipants;
    }

    public void setMaxParticipants(int maxParticipants) {
        this.maxParticipants = maxParticipants;
    }

    public int getBookedQuantity() {
        return bookedQuantity;
    }

    public void setBookedQuantity(int bookedQuantity) {
        this.bookedQuantity = bookedQuantity;
    }

    public int getRemainingSeats() {
        return maxParticipants - bookedQuantity;
    }

    public int getTotalGuests() {
        return numberAdult + numberChildren;
    }

    public double getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(double unitPrice) {
        this.unitPrice = unitPrice;
    }

    public double getSubTotal() {
        return subTotal;
    }

    public void setSubTotal(double subTotal) {
        this.subTotal = subTotal;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }
}
