package vn.edu.fpt.model;

public class Facility {

    private int facilityID;
    private String facilityName;
    private String icon;
    private String facilityScope;
    private String status;

    public Facility() {
    }

    public Facility(int facilityID, String facilityName, String icon, String facilityScope, String status) {
        this.facilityID = facilityID;
        this.facilityName = facilityName;
        this.icon = icon;
        this.facilityScope = facilityScope;
        this.status = status;
    }

    public int getFacilityID() {
        return facilityID;
    }

    public void setFacilityID(int facilityID) {
        this.facilityID = facilityID;
    }

    public String getFacilityName() {
        return facilityName;
    }

    public void setFacilityName(String facilityName) {
        this.facilityName = safeTrim(facilityName);
    }

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = safeTrim(icon);
    }

    public String getFacilityScope() {
        return facilityScope;
    }

    public void setFacilityScope(String facilityScope) {
        this.facilityScope = safeTrim(facilityScope);
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = safeTrim(status);
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }
}