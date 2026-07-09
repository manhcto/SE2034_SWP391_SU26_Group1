package vn.edu.fpt.model;

import java.util.Date;

public class ItineraryLog {
    private int progressLogID;
    private int tourScheduleID;
    private int assignmentID;
    private int loggedByUserID;
    private String loggedByName;
    private Date logTime;
    private String progressStatus;
    private String title;
    private String content;

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

    public String getLoggedByName() {
        return loggedByName;
    }

    public void setLoggedByName(String loggedByName) {
        this.loggedByName = loggedByName;
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
}
