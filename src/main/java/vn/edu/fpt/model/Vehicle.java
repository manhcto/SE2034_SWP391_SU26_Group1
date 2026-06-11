package vn.edu.fpt.model;

public class Vehicle {

    private int serviceID;
    private String vehicleBrand;
    private String licensePlate;
    private double pricePerDay;
    private String status;

    private Service serviceDetails;

    public Vehicle() {
    }

    public Vehicle(int serviceID, String vehicleBrand, String licensePlate,
                   double pricePerDay, String status, Service serviceDetails) {
        this.serviceID = serviceID;
        this.vehicleBrand = vehicleBrand;
        this.licensePlate = licensePlate;
        this.pricePerDay = pricePerDay;
        this.status = status;
        this.serviceDetails = serviceDetails;
    }

    public int getServiceID() {
        return serviceID;
    }

    public void setServiceID(int serviceID) {
        this.serviceID = serviceID;
    }

    public String getVehicleBrand() {
        return vehicleBrand;
    }

    public void setVehicleBrand(String vehicleBrand) {
        this.vehicleBrand = vehicleBrand;
    }

    public String getLicensePlate() {
        return licensePlate;
    }

    public void setLicensePlate(String licensePlate) {
        this.licensePlate = licensePlate;
    }

    public double getPricePerDay() {
        return pricePerDay;
    }

    public void setPricePerDay(double pricePerDay) {
        this.pricePerDay = pricePerDay;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Service getServiceDetails() {
        return serviceDetails;
    }

    public void setServiceDetails(Service serviceDetails) {
        this.serviceDetails = serviceDetails;
    }
}