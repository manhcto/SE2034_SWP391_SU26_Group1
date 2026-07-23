package vn.edu.fpt.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Payment {
    private int paymentID;
    private int bookingID;
    private Long payosOrderCode;
    private String paymentMethod;
    private BigDecimal totalAmount;
    private String status;
    private String paymentType;
    private String transactionCode;
    private String checkoutUrl;
    private Timestamp expiredAt;
    private Timestamp paymentDate;
    private String note;
    private Timestamp createdAt;

    public int getPaymentID() {
        return paymentID;
    }

    public void setPaymentID(int paymentID) {
        this.paymentID = paymentID;
    }

    public int getBookingID() {
        return bookingID;
    }

    public void setBookingID(int bookingID) {
        this.bookingID = bookingID;
    }

    public Long getPayosOrderCode() {
        return payosOrderCode;
    }

    public void setPayosOrderCode(Long payosOrderCode) {
        this.payosOrderCode = payosOrderCode;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getPaymentType() {
        return paymentType;
    }

    public void setPaymentType(String paymentType) {
        this.paymentType = paymentType;
    }

    public String getTransactionCode() {
        return transactionCode;
    }

    public void setTransactionCode(String transactionCode) {
        this.transactionCode = transactionCode;
    }

    public String getCheckoutUrl() {
        return checkoutUrl;
    }

    public void setCheckoutUrl(String checkoutUrl) {
        this.checkoutUrl = checkoutUrl;
    }

    public Timestamp getExpiredAt() {
        return expiredAt;
    }

    public void setExpiredAt(Timestamp expiredAt) {
        this.expiredAt = expiredAt;
    }

    public Timestamp getPaymentDate() {
        return paymentDate;
    }

    public void setPaymentDate(Timestamp paymentDate) {
        this.paymentDate = paymentDate;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public boolean isExpired() {
        return !isPaid() && expiredAt != null && expiredAt.getTime() <= System.currentTimeMillis();
    }

    public boolean isReservationReleased() {
        return note != null && note.startsWith("[SLOT_RELEASED]");
    }

    public boolean isPaid() {
        return "Đã thanh toán".equalsIgnoreCase(status) || "Paid".equalsIgnoreCase(status);
    }

    public String getDisplayStatus() {
        if ("Paid".equalsIgnoreCase(status) || "Đã thanh toán".equalsIgnoreCase(status)) {
            return "Đã thanh toán";
        }
        if ("Failed".equalsIgnoreCase(status) || "Thất bại".equalsIgnoreCase(status)) {
            return "Thất bại";
        }
        if ("Cancelled".equalsIgnoreCase(status) || "Đã hủy".equalsIgnoreCase(status)) {
            return "Đã hủy";
        }
        return "Chờ thanh toán";
    }
}
