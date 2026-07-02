package vn.edu.fpt.model;

import java.sql.Timestamp;

public class TourListItem {
    private int tourID;
    private String tourCode;
    private String tourName;
    private String coverImageUrl;
    private String tourCategoryName;
    private String regionName;
    private String destination;
    private int numberOfDays;
    private int numberOfNights;
    private int scheduleCount;
    private String tourStatus;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public int getTourID() {
        return tourID;
    }

    public void setTourID(int tourID) {
        this.tourID = tourID;
    }

    public String getTourCode() {
        return tourCode;
    }

    public void setTourCode(String tourCode) {
        this.tourCode = tourCode;
    }

    public String getTourName() {
        return tourName;
    }

    public void setTourName(String tourName) {
        this.tourName = tourName;
    }

    public String getCoverImageUrl() {
        return coverImageUrl;
    }

    public void setCoverImageUrl(String coverImageUrl) {
        this.coverImageUrl = coverImageUrl;
    }

    public String getTourCategoryName() {
        return tourCategoryName;
    }

    public void setTourCategoryName(String tourCategoryName) {
        this.tourCategoryName = tourCategoryName;
    }

    public String getRegionName() {
        return regionName;
    }

    public void setRegionName(String regionName) {
        this.regionName = regionName;
    }

    public String getDestination() {
        return destination;
    }

    public void setDestination(String destination) {
        this.destination = destination;
    }

    public int getNumberOfDays() {
        return numberOfDays;
    }

    public void setNumberOfDays(int numberOfDays) {
        this.numberOfDays = numberOfDays;
    }

    public int getNumberOfNights() {
        return numberOfNights;
    }

    public void setNumberOfNights(int numberOfNights) {
        this.numberOfNights = numberOfNights;
    }

    public int getScheduleCount() {
        return scheduleCount;
    }

    public void setScheduleCount(int scheduleCount) {
        this.scheduleCount = scheduleCount;
    }

    public String getTourStatus() {
        return tourStatus;
    }

    public void setTourStatus(String tourStatus) {
        this.tourStatus = tourStatus;
    }

    public String getTourStatusText() {
        if ("Draft".equals(tourStatus)) return "Nháp";
        if ("Rejected".equals(tourStatus)) return "Bị từ chối";
        if ("PendingApproval".equals(tourStatus)) return "Chờ duyệt";
        if ("Selling".equals(tourStatus) || "Approved".equals(tourStatus)) return "Đang bán";
        if ("SoldOut".equals(tourStatus)) return "Đã bán";
        if ("Cancelled".equals(tourStatus)) return "Đã hủy";
        if ("Completed".equals(tourStatus)) return "Hoàn thành";
        return tourStatus;
    }

    public String getStatusCssClass() {
        if ("PendingApproval".equals(tourStatus)) return "status-pending";
        if ("Selling".equals(tourStatus) || "Approved".equals(tourStatus)) return "status-approved";
        if ("Rejected".equals(tourStatus)) return "status-rejected";
        if ("Cancelled".equals(tourStatus)) return "status-cancelled";
        if ("Completed".equals(tourStatus) || "SoldOut".equals(tourStatus)) return "status-completed";
        return "status-draft";
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
}
