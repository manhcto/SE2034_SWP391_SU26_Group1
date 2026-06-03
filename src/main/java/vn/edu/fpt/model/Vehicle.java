package vn.edu.fpt.model;

public class Vehicle {

    private int serviceID;
    private String vehicleBrand;
    private String licensePlate;
    private double pricePerDay;
    private String status;

    private String image;
    private int seatCount;
    private String vehicleType;
    private String transmission;
    private String fuelType;

    private Service serviceDetails;

    public Vehicle() {
    }

    public Vehicle(int serviceID, String vehicleBrand, String licensePlate, double pricePerDay,
                   String status, String image, int seatCount, String vehicleType,
                   String transmission, String fuelType, Service serviceDetails) {
        this.serviceID = serviceID;
        this.vehicleBrand = vehicleBrand;
        this.licensePlate = licensePlate;
        this.pricePerDay = pricePerDay;
        this.status = status;
        this.image = image;
        this.seatCount = seatCount;
        this.vehicleType = vehicleType;
        this.transmission = transmission;
        this.fuelType = fuelType;
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

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public int getSeatCount() {
        return seatCount;
    }

    public void setSeatCount(int seatCount) {
        this.seatCount = seatCount;
    }

    public String getVehicleType() {
        return vehicleType;
    }

    public void setVehicleType(String vehicleType) {
        this.vehicleType = vehicleType;
    }

    public String getTransmission() {
        return transmission;
    }

    public void setTransmission(String transmission) {
        this.transmission = transmission;
    }

    public String getFuelType() {
        return fuelType;
    }

    public void setFuelType(String fuelType) {
        this.fuelType = fuelType;
    }

    public Service getServiceDetails() {
        return serviceDetails;
    }

    public void setServiceDetails(Service serviceDetails) {
        this.serviceDetails = serviceDetails;
    }
}