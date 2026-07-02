package vn.edu.fpt.model;

import java.time.LocalDate;

public class ResourceAssignmentRequest {
    private int tourScheduleID;
    private int serviceID;
    private String assignmentCategory;
    private LocalDate serviceDate;
    private LocalDate startDate;
    private LocalDate endDate;
    private Integer vehicleID;
    private Integer driverStaffID;
    private Integer roomID;
    private Integer mealPackageID;
    private int quantity;
    private Integer participantEstimate;
    private Integer estimatedCost;
    private Integer actualCost;
    private String assignmentStatus;
    private String note;

    public int getTourScheduleID() { return tourScheduleID; }
    public void setTourScheduleID(int tourScheduleID) { this.tourScheduleID = tourScheduleID; }

    public int getServiceID() { return serviceID; }
    public void setServiceID(int serviceID) { this.serviceID = serviceID; }

    public String getAssignmentCategory() { return assignmentCategory; }
    public void setAssignmentCategory(String assignmentCategory) { this.assignmentCategory = assignmentCategory; }

    public LocalDate getServiceDate() { return serviceDate; }
    public void setServiceDate(LocalDate serviceDate) { this.serviceDate = serviceDate; }

    public LocalDate getStartDate() { return startDate; }
    public void setStartDate(LocalDate startDate) { this.startDate = startDate; }

    public LocalDate getEndDate() { return endDate; }
    public void setEndDate(LocalDate endDate) { this.endDate = endDate; }

    public Integer getVehicleID() { return vehicleID; }
    public void setVehicleID(Integer vehicleID) { this.vehicleID = vehicleID; }

    public Integer getDriverStaffID() { return driverStaffID; }
    public void setDriverStaffID(Integer driverStaffID) { this.driverStaffID = driverStaffID; }

    public Integer getRoomID() { return roomID; }
    public void setRoomID(Integer roomID) { this.roomID = roomID; }

    public Integer getMealPackageID() { return mealPackageID; }
    public void setMealPackageID(Integer mealPackageID) { this.mealPackageID = mealPackageID; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public Integer getParticipantEstimate() { return participantEstimate; }
    public void setParticipantEstimate(Integer participantEstimate) { this.participantEstimate = participantEstimate; }

    public Integer getEstimatedCost() { return estimatedCost; }
    public void setEstimatedCost(Integer estimatedCost) { this.estimatedCost = estimatedCost; }

    public Integer getActualCost() { return actualCost; }
    public void setActualCost(Integer actualCost) { this.actualCost = actualCost; }

    public String getAssignmentStatus() { return assignmentStatus; }
    public void setAssignmentStatus(String assignmentStatus) { this.assignmentStatus = assignmentStatus; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
}
