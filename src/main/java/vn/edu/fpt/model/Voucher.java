package vn.edu.fpt.model;

import java.math.BigDecimal;
import java.util.Date;

public class Voucher {
    private int voucherID;
    private String code;
    private String description;
    private BigDecimal percentDiscount;
    private BigDecimal amountDiscount;
    private BigDecimal minOrderAmount;
    private int quantity;
    private Date startDate;
    private Date endDate;
    private String status;
    private Date createdAt;
    private Date updatedAt;

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

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = safeTrim(status);
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getDiscountText() {
        if (percentDiscount != null && percentDiscount.compareTo(BigDecimal.ZERO) > 0) {
            return percentDiscount.stripTrailingZeros().toPlainString() + "%";
        }

        if (amountDiscount != null && amountDiscount.compareTo(BigDecimal.ZERO) > 0) {
            return amountDiscount.stripTrailingZeros().toPlainString() + " VND";
        }

        return "Ưu đãi";
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }
}
