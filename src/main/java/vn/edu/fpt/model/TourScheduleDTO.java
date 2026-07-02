package vn.edu.fpt.model;

import vn.edu.fpt.utils.TourBusinessRule;

import java.sql.Date;
import java.text.NumberFormat;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.Locale;

public class TourScheduleDTO {
    private int tourScheduleID;
    private Date departureDate;
    private Date returnDate;
    private Date bookingCloseDate;
    private int minParticipants;
    private int maxParticipants;
    private int bookedSeats;
    private String scheduleStatus;

    private int adultPrice;
    private int childPrice;
    private int infantPrice;
    private int singleRoomSurcharge;
    private int depositPercent;
    private boolean hasVAT;
    private int vatPercent;
    private int displayPrice;

    private Integer guideStaffID;
    private String guideCode;
    private String guideName;
    private Integer driverStaffID;
    private String driverCode;
    private String driverName;

    private boolean editable;
    private String lockedReason;

    public int getTourScheduleID() { return tourScheduleID; }
    public void setTourScheduleID(int tourScheduleID) { this.tourScheduleID = tourScheduleID; }
    public Date getDepartureDate() { return departureDate; }
    public void setDepartureDate(Date departureDate) { this.departureDate = departureDate; }
    public Date getReturnDate() { return returnDate; }
    public void setReturnDate(Date returnDate) { this.returnDate = returnDate; }
    public Date getBookingCloseDate() { return bookingCloseDate; }
    public void setBookingCloseDate(Date bookingCloseDate) { this.bookingCloseDate = bookingCloseDate; }
    public int getMinParticipants() { return minParticipants; }
    public void setMinParticipants(int minParticipants) { this.minParticipants = minParticipants; }
    public int getMaxParticipants() { return maxParticipants; }
    public void setMaxParticipants(int maxParticipants) { this.maxParticipants = maxParticipants; }
    public int getBookedSeats() { return bookedSeats; }
    public void setBookedSeats(int bookedSeats) { this.bookedSeats = bookedSeats; }
    public String getScheduleStatus() { return scheduleStatus; }
    public void setScheduleStatus(String scheduleStatus) { this.scheduleStatus = scheduleStatus; }
    public int getAdultPrice() { return adultPrice; }
    public void setAdultPrice(int adultPrice) { this.adultPrice = adultPrice; }
    public int getChildPrice() { return childPrice; }
    public void setChildPrice(int childPrice) { this.childPrice = childPrice; }
    public int getInfantPrice() { return infantPrice; }
    public void setInfantPrice(int infantPrice) { this.infantPrice = infantPrice; }
    public int getSingleRoomSurcharge() { return singleRoomSurcharge; }
    public void setSingleRoomSurcharge(int singleRoomSurcharge) { this.singleRoomSurcharge = singleRoomSurcharge; }
    public int getDepositPercent() { return depositPercent; }
    public void setDepositPercent(int depositPercent) { this.depositPercent = depositPercent; }
    public boolean isHasVAT() { return hasVAT; }
    public void setHasVAT(boolean hasVAT) { this.hasVAT = hasVAT; }
    public int getVatPercent() { return vatPercent; }
    public void setVatPercent(int vatPercent) { this.vatPercent = vatPercent; }
    public int getDisplayPrice() { return displayPrice; }
    public void setDisplayPrice(int displayPrice) { this.displayPrice = displayPrice; }

    public String getDisplayPriceText() { return formatMoney(displayPrice); }
    public String getAdultPriceText() { return formatMoney(adultPrice); }
    public String getChildPriceText() { return formatMoney(childPrice); }
    public String getInfantPriceText() { return formatMoney(infantPrice); }
    public String getSingleRoomSurchargeText() { return formatMoney(singleRoomSurcharge); }

    public String getPriceTooltip() {
        return "Người lớn: " + getAdultPriceText() + " VND\n"
                + "Trẻ em: " + getChildPriceText() + " VND\n"
                + "Em bé: " + getInfantPriceText() + " VND\n"
                + "Phụ thu phòng đơn: " + getSingleRoomSurchargeText() + " VND\n"
                + "Đặt cọc: " + depositPercent + "%\n"
                + "VAT: " + (hasVAT ? vatPercent + "%" : "Không áp dụng");
    }

    public Integer getGuideStaffID() { return guideStaffID; }
    public void setGuideStaffID(Integer guideStaffID) { this.guideStaffID = guideStaffID; }
    public String getGuideCode() { return guideCode; }
    public void setGuideCode(String guideCode) { this.guideCode = guideCode; }
    public String getGuideName() { return guideName; }
    public void setGuideName(String guideName) { this.guideName = guideName; }
    public String getGuideDisplay() {
        if (guideName == null || guideName.trim().isEmpty()) return "Chưa phân công";
        if (guideCode == null || guideCode.trim().isEmpty()) return guideName;
        return guideCode + " - " + guideName;
    }

    public Integer getDriverStaffID() { return driverStaffID; }
    public void setDriverStaffID(Integer driverStaffID) { this.driverStaffID = driverStaffID; }
    public String getDriverCode() { return driverCode; }
    public void setDriverCode(String driverCode) { this.driverCode = driverCode; }
    public String getDriverName() { return driverName; }
    public void setDriverName(String driverName) { this.driverName = driverName; }
    public String getDriverDisplay() {
        if (driverName == null || driverName.trim().isEmpty()) return "Không cần / chưa phân công";
        if (driverCode == null || driverCode.trim().isEmpty()) return driverName;
        return driverCode + " - " + driverName;
    }

    public boolean isEditable() { return editable; }
    public void setEditable(boolean editable) { this.editable = editable; }
    public String getLockedReason() { return lockedReason; }
    public void setLockedReason(String lockedReason) { this.lockedReason = lockedReason; }

    public String getCapacityText() {
        return bookedSeats + "/" + maxParticipants + " khách";
    }

    public String getMinimumStatusText() {
        if (bookedSeats >= minParticipants) return "Đã đủ tối thiểu";
        return "Còn thiếu " + (minParticipants - bookedSeats) + " khách tối thiểu";
    }

    public String getMinimumStatusCssClass() {
        return bookedSeats >= minParticipants ? "ok" : "warn";
    }

    public String getSaleDeadlineText() {
        if (bookingCloseDate == null) return "Chưa có hạn chót bán";
        LocalDate closeDate = bookingCloseDate.toLocalDate();
        long days = ChronoUnit.DAYS.between(LocalDate.now(), closeDate);
        if (days > 0) return "Bán đến " + bookingCloseDate + " - còn " + days + " ngày";
        if (days == 0) return "Hôm nay là hạn chót bán";
        return "Đã quá hạn bán " + Math.abs(days) + " ngày";
    }

    public boolean isCloseDatePassedAndNotEnoughMin() {
        return bookingCloseDate != null
                && bookingCloseDate.toLocalDate().isBefore(LocalDate.now())
                && bookedSeats < minParticipants;
    }

    public String getSaleWarning() {
        if (isCloseDatePassedAndNotEnoughMin()) {
            return "Đã hết hạn bán nhưng chưa đủ số khách tối thiểu. Staff cần báo lại với khách.";
        }
        return null;
    }

    public String getScheduleStatusText() {
        if (TourBusinessRule.SCHEDULE_DRAFT.equals(scheduleStatus)) return "Chưa mở bán";
        if (TourBusinessRule.SCHEDULE_PENDING_APPROVAL.equals(scheduleStatus)) return "Chờ duyệt";
        if (TourBusinessRule.SCHEDULE_OPEN.equals(scheduleStatus)) return "Đang mở bán";
        if (TourBusinessRule.SCHEDULE_FULL.equals(scheduleStatus)) return "Đã đủ khách";
        if (TourBusinessRule.SCHEDULE_CLOSED.equals(scheduleStatus)) return "Đã đóng bán";
        if (TourBusinessRule.SCHEDULE_DEPARTED.equals(scheduleStatus)) return "Đã khởi hành";
        if (TourBusinessRule.SCHEDULE_COMPLETED.equals(scheduleStatus)) return "Hoàn thành";
        if (TourBusinessRule.SCHEDULE_CANCELLED.equals(scheduleStatus)) return "Đã hủy";
        return scheduleStatus == null ? "Chưa có trạng thái" : scheduleStatus;
    }

    public String getScheduleStatusCssClass() {
        if (TourBusinessRule.SCHEDULE_PENDING_APPROVAL.equals(scheduleStatus)) return "status-pending";
        if (TourBusinessRule.SCHEDULE_OPEN.equals(scheduleStatus)) return "status-approved";
        if (TourBusinessRule.SCHEDULE_FULL.equals(scheduleStatus)) return "status-completed";
        if (TourBusinessRule.SCHEDULE_CLOSED.equals(scheduleStatus)) return "status-cancelled";
        if (TourBusinessRule.SCHEDULE_COMPLETED.equals(scheduleStatus)) return "status-completed";
        if (TourBusinessRule.SCHEDULE_CANCELLED.equals(scheduleStatus)) return "status-rejected";
        return "status-draft";
    }

    private String formatMoney(int value) {
        return NumberFormat.getNumberInstance(new Locale("vi", "VN")).format(value);
    }
}
