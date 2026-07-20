package vn.edu.fpt.model;

import java.sql.Date;
import java.sql.Timestamp;

public class VatRate {
    private int vatRateID;
    private int vatPercent;
    private Date effectiveFrom;
    private Date effectiveTo;
    private String legalDocument;
    private String description;
    private String status;
    private Integer createdByUserID;
    private String createdByName;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public int getVatRateID() { return vatRateID; }
    public void setVatRateID(int vatRateID) { this.vatRateID = vatRateID; }

    public int getVatPercent() { return vatPercent; }
    public void setVatPercent(int vatPercent) { this.vatPercent = vatPercent; }

    public Date getEffectiveFrom() { return effectiveFrom; }
    public void setEffectiveFrom(Date effectiveFrom) { this.effectiveFrom = effectiveFrom; }

    public Date getEffectiveTo() { return effectiveTo; }
    public void setEffectiveTo(Date effectiveTo) { this.effectiveTo = effectiveTo; }

    public String getEffectiveFromIso() { return effectiveFrom == null ? "" : effectiveFrom.toString(); }
    public String getEffectiveToIso() { return effectiveTo == null ? "" : effectiveTo.toString(); }

    public String getLegalDocument() { return legalDocument; }
    public void setLegalDocument(String legalDocument) { this.legalDocument = safeTrim(legalDocument); }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = safeTrim(description); }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = safeTrim(status); }

    public Integer getCreatedByUserID() { return createdByUserID; }
    public void setCreatedByUserID(Integer createdByUserID) { this.createdByUserID = createdByUserID; }

    public String getCreatedByName() { return createdByName; }
    public void setCreatedByName(String createdByName) { this.createdByName = safeTrim(createdByName); }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public boolean isActive() {
        return "Active".equalsIgnoreCase(status);
    }

    public String getDisplayStatus() {
        if ("Inactive".equalsIgnoreCase(status)) return "Ngừng áp dụng";
        return "Đang áp dụng";
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }
}
