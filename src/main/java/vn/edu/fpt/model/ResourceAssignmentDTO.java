package vn.edu.fpt.model;

import java.sql.Date;

public class ResourceAssignmentDTO {
    private int assignmentID;
    private int tourScheduleID;
    private int serviceID;
    private String serviceName;
    private String assignmentCategory;
    private Date serviceDate;
    private Date startDate;
    private Date endDate;
    private Integer vehicleID;
    private String vehicleName;
    private String licensePlate;
    private Integer driverStaffID;
    private String driverName;
    private Integer roomID;
    private String roomName;
    private Integer mealPackageID;
    private String mealPackageName;
    private int quantity;
    private Integer participantEstimate;
    private Integer estimatedCost;
    private Integer actualCost;
    private String assignmentStatus;
    private String note;

    public int getAssignmentID() { return assignmentID; }
    public void setAssignmentID(int assignmentID) { this.assignmentID = assignmentID; }

    public int getTourScheduleID() { return tourScheduleID; }
    public void setTourScheduleID(int tourScheduleID) { this.tourScheduleID = tourScheduleID; }

    public int getServiceID() { return serviceID; }
    public void setServiceID(int serviceID) { this.serviceID = serviceID; }

    public String getServiceName() { return serviceName; }
    public void setServiceName(String serviceName) { this.serviceName = serviceName; }

    public String getAssignmentCategory() { return assignmentCategory; }
    public void setAssignmentCategory(String assignmentCategory) { this.assignmentCategory = assignmentCategory; }

    public Date getServiceDate() { return serviceDate; }
    public void setServiceDate(Date serviceDate) { this.serviceDate = serviceDate; }

    public Date getStartDate() { return startDate; }
    public void setStartDate(Date startDate) { this.startDate = startDate; }

    public Date getEndDate() { return endDate; }
    public void setEndDate(Date endDate) { this.endDate = endDate; }

    public Integer getVehicleID() { return vehicleID; }
    public void setVehicleID(Integer vehicleID) { this.vehicleID = vehicleID; }

    public String getVehicleName() { return vehicleName; }
    public void setVehicleName(String vehicleName) { this.vehicleName = vehicleName; }

    public String getLicensePlate() { return licensePlate; }
    public void setLicensePlate(String licensePlate) { this.licensePlate = licensePlate; }

    public Integer getDriverStaffID() { return driverStaffID; }
    public void setDriverStaffID(Integer driverStaffID) { this.driverStaffID = driverStaffID; }

    public String getDriverName() { return driverName; }
    public void setDriverName(String driverName) { this.driverName = driverName; }

    public Integer getRoomID() { return roomID; }
    public void setRoomID(Integer roomID) { this.roomID = roomID; }

    public String getRoomName() { return roomName; }
    public void setRoomName(String roomName) { this.roomName = roomName; }

    public Integer getMealPackageID() { return mealPackageID; }
    public void setMealPackageID(Integer mealPackageID) { this.mealPackageID = mealPackageID; }

    public String getMealPackageName() { return mealPackageName; }
    public void setMealPackageName(String mealPackageName) { this.mealPackageName = mealPackageName; }

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

    public String getCategoryText() {
        if ("Vehicle".equals(assignmentCategory)) return "Xe/Phương tiện";
        if ("Accommodation".equals(assignmentCategory)) return "Lưu trú";
        if ("Room".equals(assignmentCategory)) return "Phòng";
        if ("Restaurant".equals(assignmentCategory)) return "Nhà hàng";
        if ("Meal".equals(assignmentCategory)) return "Bữa ăn";
        if ("Entertainment".equals(assignmentCategory)) return "Điểm vui chơi";
        if ("Insurance".equals(assignmentCategory)) return "Bảo hiểm";
        if ("Guide".equals(assignmentCategory)) return "Hướng dẫn viên";
        return "Khác";
    }

    public String getStatusText() {
        if ("Planned".equals(assignmentStatus)) return "Dự kiến";
        if ("Confirmed".equals(assignmentStatus)) return "Đã xác nhận";
        if ("InUse".equals(assignmentStatus)) return "Đang sử dụng";
        if ("Completed".equals(assignmentStatus)) return "Hoàn thành";
        if ("Cancelled".equals(assignmentStatus)) return "Đã hủy";
        return assignmentStatus;
    }
}
