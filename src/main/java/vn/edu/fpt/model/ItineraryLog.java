package vn.edu.fpt.model;

import java.util.Date;

public class ItineraryLog {
    private int progressLogID;
    private int tourScheduleID;
    private int assignmentID;
    private int loggedByUserID;
    private Date logTime;
    private String progressStatus;
    private String title;
    private String content;
    private String tourName;
    private String assignmentCode;

    public int getProgressLogID() {
        return progressLogID;
    }

    public void setProgressLogID(int progressLogID) {
        this.progressLogID = progressLogID;
    }

    public int getTourScheduleID() {
        return tourScheduleID;
    }

    public void setTourScheduleID(int tourScheduleID) {
        this.tourScheduleID = tourScheduleID;
    }

    public int getAssignmentID() {
        return assignmentID;
    }

    public void setAssignmentID(int assignmentID) {
        this.assignmentID = assignmentID;
    }

    public int getLoggedByUserID() {
        return loggedByUserID;
    }

    public void setLoggedByUserID(int loggedByUserID) {
        this.loggedByUserID = loggedByUserID;
    }

    public Date getLogTime() {
        return logTime;
    }

    public void setLogTime(Date logTime) {
        this.logTime = logTime;
    }

    public String getProgressStatus() {
        return progressStatus;
    }

    public String getProgressStatusLabel() {
        if (progressStatus == null || progressStatus.trim().isEmpty()) {
            return "Cập nhật";
        }

        return switch (progressStatus.trim()) {
            case "At Pickup Point" -> "Đã đến điểm đón";
            case "Pickup Completed" -> "Đã đón khách";
            case "Departed" -> "Đã khởi hành";
            case "Arrived", "Arrived Destination" -> "Đã đến nơi";
            case "Lunch Break" -> "Đang nghỉ ăn trưa";
            case "Activity Completed", "Completed Visit" -> "Hoàn thành hoạt động";
            case "Returning" -> "Đang quay về";
            case "Completed" -> "Hoàn thành tour";
            case "Issue" -> "Có vấn đề phát sinh";
            case "Update" -> "Cập nhật";
            default -> progressStatus.trim();
        };
    }

    public void setProgressStatus(String progressStatus) {
        this.progressStatus = progressStatus;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getTourName() {
        return tourName;
    }

    public void setTourName(String tourName) {
        this.tourName = tourName;
    }

    public String getAssignmentCode() {
        return assignmentCode;
    }

    public void setAssignmentCode(String assignmentCode) {
        this.assignmentCode = assignmentCode;
    }
}
