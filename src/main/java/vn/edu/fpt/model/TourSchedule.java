package vn.edu.fpt.model;

import java.math.BigDecimal;
import java.sql.Time;
import java.sql.Timestamp;

public class TourSchedule {
    private int tourScheduleID;
    private int tourID;
    private String scheduleTransportType;
    private Timestamp startDate;
    private Timestamp endDate;
    private Time departureTime;
    private Time expectedReturnTime;
    private Timestamp bookingDeadline;
    private int minParticipants;
    private int maxParticipants;
    private int quantity;
    private int bookedSeats;
    private int maxParticipantsPerBooking;
    private BigDecimal adultPrice;
    private BigDecimal childPrice;
    private BigDecimal infantPrice;
    private BigDecimal singleRoomSurcharge;
    private Integer depositPercent;
    private Integer vatPercent;
    private String cancellationPolicy;
    private String scheduleStatus;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private String tourName;
    private String tourCode;
    private String tourStatus;
    private String startPlace;
    private String endPlace;
    private String mainTransportType;

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

    public String getScheduleTransportType() {
        return scheduleTransportType;
    }

    public void setScheduleTransportType(String scheduleTransportType) {
        this.scheduleTransportType = safeTrim(scheduleTransportType);
    }

    public Timestamp getStartDate() {
        return startDate;
    }

    public void setStartDate(Timestamp startDate) {
        this.startDate = startDate;
    }

    public Timestamp getEndDate() {
        return endDate;
    }

    public void setEndDate(Timestamp endDate) {
        this.endDate = endDate;
    }

    public Time getDepartureTime() {
        return departureTime;
    }

    public void setDepartureTime(Time departureTime) {
        this.departureTime = departureTime;
    }

    public Time getExpectedReturnTime() {
        return expectedReturnTime;
    }

    public void setExpectedReturnTime(Time expectedReturnTime) {
        this.expectedReturnTime = expectedReturnTime;
    }

    public Timestamp getBookingDeadline() {
        return bookingDeadline;
    }

    public void setBookingDeadline(Timestamp bookingDeadline) {
        this.bookingDeadline = bookingDeadline;
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

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public int getBookedSeats() {
        return bookedSeats;
    }

    public void setBookedSeats(int bookedSeats) {
        this.bookedSeats = bookedSeats;
    }

    public int getMaxParticipantsPerBooking() {
        return maxParticipantsPerBooking;
    }

    public void setMaxParticipantsPerBooking(int maxParticipantsPerBooking) {
        this.maxParticipantsPerBooking = maxParticipantsPerBooking;
    }

    public BigDecimal getAdultPrice() {
        return adultPrice;
    }

    public void setAdultPrice(BigDecimal adultPrice) {
        this.adultPrice = adultPrice;
    }

    public BigDecimal getChildPrice() {
        return childPrice;
    }

    public void setChildPrice(BigDecimal childPrice) {
        this.childPrice = childPrice;
    }

    public BigDecimal getInfantPrice() {
        return infantPrice;
    }

    public void setInfantPrice(BigDecimal infantPrice) {
        this.infantPrice = infantPrice;
    }

    public BigDecimal getSingleRoomSurcharge() {
        return singleRoomSurcharge;
    }

    public void setSingleRoomSurcharge(BigDecimal singleRoomSurcharge) {
        this.singleRoomSurcharge = singleRoomSurcharge;
    }

    public Integer getDepositPercent() {
        return depositPercent;
    }

    public void setDepositPercent(Integer depositPercent) {
        this.depositPercent = depositPercent;
    }

    public Integer getVatPercent() {
        return vatPercent;
    }

    public void setVatPercent(Integer vatPercent) {
        this.vatPercent = vatPercent;
    }

    public String getCancellationPolicy() {
        return cancellationPolicy;
    }

    public void setCancellationPolicy(String cancellationPolicy) {
        this.cancellationPolicy = safeTrim(cancellationPolicy);
    }

    public String getScheduleStatus() {
        return scheduleStatus;
    }

    public void setScheduleStatus(String scheduleStatus) {
        this.scheduleStatus = safeTrim(scheduleStatus);
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

    public String getTourName() {
        return tourName;
    }

    public void setTourName(String tourName) {
        this.tourName = safeTrim(tourName);
    }

    public String getTourCode() {
        return tourCode;
    }

    public void setTourCode(String tourCode) {
        this.tourCode = safeTrim(tourCode);
    }

    public String getTourStatus() {
        return tourStatus;
    }

    public void setTourStatus(String tourStatus) {
        this.tourStatus = safeTrim(tourStatus);
    }

    public String getStartPlace() {
        return startPlace;
    }

    public void setStartPlace(String startPlace) {
        this.startPlace = safeTrim(startPlace);
    }

    public String getEndPlace() {
        return endPlace;
    }

    public void setEndPlace(String endPlace) {
        this.endPlace = safeTrim(endPlace);
    }

    public String getMainTransportType() {
        return mainTransportType;
    }

    public void setMainTransportType(String mainTransportType) {
        this.mainTransportType = safeTrim(mainTransportType);
    }

    public int getRemainingSeats() {
        return Math.max(0, maxParticipants - quantity);
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }
}
