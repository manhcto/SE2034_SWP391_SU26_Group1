package vn.edu.fpt.model;

import java.util.Date;

public class UserVoucher {
    private int userVoucherID;
    private int userID;
    private int voucherID;
    private String status;
    private Date savedAt;
    private Date usedAt;
    private Integer bookingID;

    public int getUserVoucherID() {
        return userVoucherID;
    }

    public void setUserVoucherID(int userVoucherID) {
        this.userVoucherID = userVoucherID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public int getVoucherID() {
        return voucherID;
    }

    public void setVoucherID(int voucherID) {
        this.voucherID = voucherID;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = safeTrim(status);
    }

    public Date getSavedAt() {
        return savedAt;
    }

    public void setSavedAt(Date savedAt) {
        this.savedAt = savedAt;
    }

    public Date getUsedAt() {
        return usedAt;
    }

    public void setUsedAt(Date usedAt) {
        this.usedAt = usedAt;
    }

    public Integer getBookingID() {
        return bookingID;
    }

    public void setBookingID(Integer bookingID) {
        this.bookingID = bookingID;
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }
}
