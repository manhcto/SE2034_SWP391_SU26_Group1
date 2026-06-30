package vn.edu.fpt.model;

import java.util.Date;

public class AssignmentView {

    private int assignmentID;
    private int bookingID;
    private String tourName;
    private String guideName;
    private String vehicleName;
    private Date departureDate;
    private String status;

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

    public int getBookingID() {
        return bookingID;
    }

    public void setBookingID(int bookingID) {
        this.bookingID = bookingID;
    }

    public String getTourName() {
        return tourName;
    }

    public void setTourName(String tourName) {
        this.tourName = tourName;
    }

    public String getGuideName() {
        return guideName;
    }

    public void setGuideName(String guideName) {
        this.guideName = guideName;
    }

    public String getVehicleName() {
        return vehicleName;
    }

    public void setVehicleName(String vehicleName) {
        this.vehicleName = vehicleName;
    }

    public Date getDepartureDate() {
        return departureDate;
    }

    public void setDepartureDate(Date departureDate) {
        this.departureDate = departureDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}