package vn.edu.fpt.model;

public class TourAssignments {
    private int assignmentID;
    private int tourScheduleID;
    private int userID;
    private String roleInTour;

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
}
