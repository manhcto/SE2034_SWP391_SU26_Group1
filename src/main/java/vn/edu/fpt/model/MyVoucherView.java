package vn.edu.fpt.model;

import java.math.BigDecimal;
import java.util.Date;

public class MyVoucherView {
    private int userVoucherID;
    private int voucherID;
    private String code;
    private String description;
    private BigDecimal percentDiscount;
    private BigDecimal amountDiscount;
    private BigDecimal minOrderAmount;
    private String applicableType;
    private Date startDate;
    private Date endDate;
    private String userVoucherStatus;
    private Date savedAt;
    private Date usedAt;
    private String displayStatus;
    private String unavailableReason;

    public int getUserVoucherID() {
        return userVoucherID;
    }

    public void setUserVoucherID(int userVoucherID) {
        this.userVoucherID = userVoucherID;
    }

    public int getVoucherID() {
        return voucherID;
    }

    public void setVoucherID(int voucherID) {
        this.voucherID = voucherID;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = safeTrim(code);
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = safeTrim(description);
    }

    public BigDecimal getPercentDiscount() {
        return percentDiscount;
    }

    public void setPercentDiscount(BigDecimal percentDiscount) {
        this.percentDiscount = percentDiscount;
    }

    public BigDecimal getAmountDiscount() {
        return amountDiscount;
    }

    public void setAmountDiscount(BigDecimal amountDiscount) {
        this.amountDiscount = amountDiscount;
    }

    public BigDecimal getMinOrderAmount() {
        return minOrderAmount;
    }

    public void setMinOrderAmount(BigDecimal minOrderAmount) {
        this.minOrderAmount = minOrderAmount;
    }

    public String getApplicableType() {
        return applicableType;
    }

    public void setApplicableType(String applicableType) {
        this.applicableType = safeTrim(applicableType);
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public String getUserVoucherStatus() {
        return userVoucherStatus;
    }

    public void setUserVoucherStatus(String userVoucherStatus) {
        this.userVoucherStatus = safeTrim(userVoucherStatus);
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

    public String getDisplayStatus() {
        return displayStatus;
    }

    public void setDisplayStatus(String displayStatus) {
        this.displayStatus = safeTrim(displayStatus);
    }

    public String getUnavailableReason() {
        return unavailableReason;
    }

    public void setUnavailableReason(String unavailableReason) {
        this.unavailableReason = safeTrim(unavailableReason);
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }
}
