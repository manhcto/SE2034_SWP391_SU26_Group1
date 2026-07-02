package vn.edu.fpt.model;

import java.time.LocalDate;

public class TourScheduleRequest {
    private Integer tourScheduleID;
    private LocalDate departureDate;
    private LocalDate returnDate;
    private LocalDate bookingCloseDate;
    private int minParticipants;
    private int maxParticipants;
    private Integer guideStaffID;
    private Integer driverStaffID;

    private int adultPrice;
    private int childPrice;
    private int infantPrice;
    private int singleRoomSurcharge;
    private int depositPercent;
    private boolean hasVAT;
    private int vatPercent;
    private int displayPrice;

    public Integer getTourScheduleID() {
        return tourScheduleID;
    }

    public void setTourScheduleID(Integer tourScheduleID) {
        this.tourScheduleID = tourScheduleID;
    }

    public LocalDate getDepartureDate() {
        return departureDate;
    }

    public void setDepartureDate(LocalDate departureDate) {
        this.departureDate = departureDate;
    }

    public LocalDate getReturnDate() {
        return returnDate;
    }

    public void setReturnDate(LocalDate returnDate) {
        this.returnDate = returnDate;
    }

    public LocalDate getBookingCloseDate() {
        return bookingCloseDate;
    }

    public void setBookingCloseDate(LocalDate bookingCloseDate) {
        this.bookingCloseDate = bookingCloseDate;
    }

    public int getMinParticipants() {
        return minParticipants;
    }

    public void setMinParticipants(int minParticipants) {
        this.minParticipants = minParticipants;
    }

    public int getMaxParticipants() {
        return maxParticipants;
    }

    public void setMaxParticipants(int maxParticipants) {
        this.maxParticipants = maxParticipants;
    }

    public Integer getGuideStaffID() {
        return guideStaffID;
    }

    public void setGuideStaffID(Integer guideStaffID) {
        this.guideStaffID = guideStaffID;
    }

    public Integer getDriverStaffID() {
        return driverStaffID;
    }

    public void setDriverStaffID(Integer driverStaffID) {
        this.driverStaffID = driverStaffID;
    }

    public int getAdultPrice() {
        return adultPrice;
    }

    public void setAdultPrice(int adultPrice) {
        this.adultPrice = adultPrice;
    }

    public int getChildPrice() {
        return childPrice;
    }

    public void setChildPrice(int childPrice) {
        this.childPrice = childPrice;
    }

    public int getInfantPrice() {
        return infantPrice;
    }

    public void setInfantPrice(int infantPrice) {
        this.infantPrice = infantPrice;
    }

    public int getSingleRoomSurcharge() {
        return singleRoomSurcharge;
    }

    public void setSingleRoomSurcharge(int singleRoomSurcharge) {
        this.singleRoomSurcharge = singleRoomSurcharge;
    }

    public int getDepositPercent() {
        return depositPercent;
    }

    public void setDepositPercent(int depositPercent) {
        this.depositPercent = depositPercent;
    }

    public boolean isHasVAT() {
        return hasVAT;
    }

    public void setHasVAT(boolean hasVAT) {
        this.hasVAT = hasVAT;
    }

    public int getVatPercent() {
        return vatPercent;
    }

    public void setVatPercent(int vatPercent) {
        this.vatPercent = vatPercent;
    }

    public int getDisplayPrice() {
        return displayPrice;
    }

    public void setDisplayPrice(int displayPrice) {
        this.displayPrice = displayPrice;
    }
}
