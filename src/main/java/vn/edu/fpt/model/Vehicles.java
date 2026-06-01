package vn.edu.fpt.model;

public class Vehicles {
    private int vehicleID;
    private int serviceID;
    private String vehicleBrand;
    private String licensePlate;
    private double pricePerDay;
    private String carAvailability;

    public Vehicles() {
    }

    public Vehicles(int vehicleID, int serviceID, String vehicleBrand, String licensePlate, double pricePerDay, String carAvailability) {
        this.vehicleID = vehicleID;
        this.serviceID = serviceID;
        this.vehicleBrand = vehicleBrand;
        this.licensePlate = licensePlate;
        this.pricePerDay = pricePerDay;
        this.carAvailability = carAvailability;
    }

    public int getVehicleID() {
        return vehicleID;
    }

    public void setVehicleID(int vehicleID) {
        this.vehicleID = vehicleID;
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

    public String getCarAvailability() {
        return carAvailability;
    }

    public void setCarAvailability(String carAvailability) {
        this.carAvailability = carAvailability;
    }

    @Override
    public String toString() {
        return "Vehicles{" +
                "vehicleID=" + vehicleID +
                ", serviceID=" + serviceID +
                ", vehicleBrand='" + vehicleBrand + '\'' +
                ", licensePlate='" + licensePlate + '\'' +
                ", pricePerDay=" + pricePerDay +
                ", carAvailability='" + carAvailability + '\'' +
                '}';
    }
}
