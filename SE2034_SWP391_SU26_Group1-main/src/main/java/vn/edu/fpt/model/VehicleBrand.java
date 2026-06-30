package vn.edu.fpt.model;

public class VehicleBrand {

    private int brandID;
    private String brandName;
    private String status;

    public VehicleBrand() {
    }

    public VehicleBrand(int brandID, String brandName, String status) {
        this.brandID = brandID;
        this.brandName = brandName;
        this.status = status;
    }

    public int getBrandID() {
        return brandID;
    }

    public void setBrandID(int brandID) {
        this.brandID = brandID;
    }

    public String getBrandName() {
        return brandName;
    }

    public void setBrandName(String brandName) {
        this.brandName = brandName;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}