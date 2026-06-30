package vn.edu.fpt.model;
import org.eclipse.tags.shaded.org.apache.xpath.objects.XString;

import java.sql.Date;

public class Voucher {
    private int voucherId;
    private String voucherCode;
    private String voucherName;
    private double percentDiscount;
    private Date startDate;
    private Date endDate;
    private int quantity;
    private String status;
    private String applyFor;
    private String image;
    private String description;

// Bạn tự Generate Getter và Setter cho 2 biến này nhé!

    // Bấm Alt + Insert (trên IntelliJ) để Generate toàn bộ Constructor, Getters và Setters nhé
    public Voucher() {
        this.voucherId = voucherId;
        this.voucherCode = voucherCode;
        this.voucherName = voucherName;
        this.percentDiscount = percentDiscount;
        this.startDate = startDate;
        this.endDate = endDate;
        this.quantity = quantity;
        this.status = status;
    }

    public int getVoucherId() {
        return voucherId;
    }

    public void setVoucherId(int voucherId) {
        this.voucherId = voucherId;
    }

    public String getVoucherCode() {
        return voucherCode;
    }

    public void setVoucherCode(String voucherCode) {
        this.voucherCode = voucherCode;
    }

    public String getVoucherName() {
        return voucherName;
    }

    public void setVoucherName(String voucherName) {
        this.voucherName = voucherName;
    }

    public double getPercentDiscount() {
        return percentDiscount;
    }

    public void setPercentDiscount(double percentDiscount) {
        this.percentDiscount = percentDiscount;
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


    public String getApplyFor() {
        return applyFor;
    }

    public void setApplyFor(String applyFor) {
        this.applyFor = applyFor;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
