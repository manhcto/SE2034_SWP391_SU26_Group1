package vn.edu.fpt.model;

public class Region {
    private int regionID;
    private String regionName;
    private String description;
    private String status;

    public int getRegionID() {
        return regionID;
    }

    public void setRegionID(int regionID) {
        this.regionID = regionID;
    }

    public String getRegionName() {
        return regionName;
    }

    public void setRegionName(String regionName) {
        this.regionName = safeTrim(regionName);
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = safeTrim(description);
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
