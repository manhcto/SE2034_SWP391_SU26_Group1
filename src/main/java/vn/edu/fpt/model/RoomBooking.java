package vn.edu.fpt.model;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

public class RoomBooking {
    private int roomBookingID;
    private int bookingID;
    private Integer bookingDetailID;
    private int roomID;
    private String roomType;
    private String bookingCode;
    private Date checkInDate;
    private Date checkOutDate;
    private int quantity;
    private String status;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private BigDecimal totalPrice;

    public int getRoomBookingID() {
        return roomBookingID;
    }

    public void setRoomBookingID(int roomBookingID) {
        this.roomBookingID = roomBookingID;
    }

    public int getBookingID() {
        return bookingID;
    }

    public void setBookingID(int bookingID) {
        this.bookingID = bookingID;
    }

    public Integer getBookingDetailID() {
        return bookingDetailID;
    }

    public void setBookingDetailID(Integer bookingDetailID) {
        this.bookingDetailID = bookingDetailID;
    }

    public int getRoomID() {
        return roomID;
    }

    public void setRoomID(int roomID) {
        this.roomID = roomID;
    }

    public String getRoomType() {
        return roomType;
    }

    public void setRoomType(String roomType) {
        this.roomType = roomType;
    }

    public String getBookingCode() {
        return bookingCode;
    }

    public void setBookingCode(String bookingCode) {
        this.bookingCode = bookingCode;
    }

    public Date getCheckInDate() {
        return checkInDate;
    }

    public void setCheckInDate(Date checkInDate) {
        this.checkInDate = checkInDate;
    }

    public Date getCheckOutDate() {
        return checkOutDate;
    }

    public void setCheckOutDate(Date checkOutDate) {
        this.checkOutDate = checkOutDate;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
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

    public BigDecimal getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(BigDecimal totalPrice) {
        this.totalPrice = totalPrice;
    }

    public String getDisplayStatus() {
        if ("Pending".equalsIgnoreCase(status)) {
            return "Chờ xác nhận";
        }

        if ("Confirmed".equalsIgnoreCase(status)) {
            return "Đã thuê";
        }

        if ("CheckedIn".equalsIgnoreCase(status)) {
            return "Đang được thuê";
        }

        if ("CheckedOut".equalsIgnoreCase(status)) {
            return "Đã trả phòng";
        }

        if ("Cancelled".equalsIgnoreCase(status)) {
            return "Đã hủy";
        }

        return status;
    }
}
