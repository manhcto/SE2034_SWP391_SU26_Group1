package vn.edu.fpt.model;

import java.util.Date;

public class BookingTraveler {
    private int travelerID;
    private int bookingID;
    private String bookingCode;
    private String fullName;
    private String gender;
    private Date dateOfBirth;
    private String travelerType;
    private String phone;
    private String identityNumber;
    private String travelerStatus;
    private String note;
    private boolean booker;

    public int getTravelerID() {
        return travelerID;
    }

    public void setTravelerID(int travelerID) {
        this.travelerID = travelerID;
    }

    public int getBookingID() {
        return bookingID;
    }

    public void setBookingID(int bookingID) {
        this.bookingID = bookingID;
    }

    public String getBookingCode() {
        return bookingCode;
    }

    public void setBookingCode(String bookingCode) {
        this.bookingCode = bookingCode;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public Date getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(Date dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public String getTravelerType() {
        return travelerType;
    }

    public void setTravelerType(String travelerType) {
        this.travelerType = travelerType;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public boolean isBooker() {
        return booker;
    }

    public void setBooker(boolean booker) {
        this.booker = booker;
    }

    public String getIdentityNumber() {
        return identityNumber;
    }

    public void setIdentityNumber(String identityNumber) {
        this.identityNumber = identityNumber;
    }

    public String getTravelerStatus() {
        return travelerStatus;
    }

    public String getTravelerStatusLabel() {
        if (travelerStatus == null || travelerStatus.trim().isEmpty()) {
            return "Chưa check-in";
        }

        return switch (travelerStatus.trim()) {
            case "Pending" -> "Chưa check-in";
            case "Checked-in" -> "Đã check-in";
            case "Absent" -> "Vắng mặt";
            case "Completed" -> "Hoàn thành";
            default -> travelerStatus.trim();
        };
    }

    public void setTravelerStatus(String travelerStatus) {
        this.travelerStatus = travelerStatus;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }
}
