package vn.edu.fpt.model;

public class Vehicle {

    private int serviceID;

    private int brandID;
    private String vehicleModel;

    private String licensePlate;
    private double pricePerDay;
    private String status;

    private String image;
    private int seatCount;
    private String vehicleType;
    private String transmission;
    private String fuelType;

    private String pickupProvince;
    private String pickupDistrict;
    private String pickupWard;
    private String pickupAddress;

    private String description;
    private String usageNotes;
    private double depositAmount;

    private Service serviceDetails;
    private VehicleBrand brandDetails;

    public Vehicle() {
    }

    public Vehicle(int serviceID, int brandID, String vehicleModel,
                   String licensePlate, double pricePerDay, String status,
                   String image, int seatCount, String vehicleType,
                   String transmission, String fuelType,
                   String pickupProvince, String pickupDistrict,
                   String pickupWard, String pickupAddress,
                   String description, String usageNotes,
                   double depositAmount, Service serviceDetails,
                   VehicleBrand brandDetails) {
        this.serviceID = serviceID;
        this.brandID = brandID;
        this.vehicleModel = vehicleModel;
        this.licensePlate = licensePlate;
        this.pricePerDay = pricePerDay;
        this.status = status;
        this.image = image;
        this.seatCount = seatCount;
        this.vehicleType = vehicleType;
        this.transmission = transmission;
        this.fuelType = fuelType;
        this.pickupProvince = pickupProvince;
        this.pickupDistrict = pickupDistrict;
        this.pickupWard = pickupWard;
        this.pickupAddress = pickupAddress;
        this.description = description;
        this.usageNotes = usageNotes;
        this.depositAmount = depositAmount;
        this.serviceDetails = serviceDetails;
        this.brandDetails = brandDetails;
    }

    public int getServiceID() {
        return serviceID;
    }

    public void setServiceID(int serviceID) {
        this.serviceID = serviceID;
    }

    public int getBrandID() {
        return brandID;
    }

    public void setBrandID(int brandID) {
        this.brandID = brandID;
    }

    public String getVehicleModel() {
        return vehicleModel;
    }

    public void setVehicleModel(String vehicleModel) {
        this.vehicleModel = vehicleModel;
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

    public String getPickupProvince() {
        return pickupProvince;
    }

    public void setPickupProvince(String pickupProvince) {
        this.pickupProvince = pickupProvince;
    }

    public String getPickupDistrict() {
        return pickupDistrict;
    }

    public void setPickupDistrict(String pickupDistrict) {
        this.pickupDistrict = pickupDistrict;
    }

    public String getPickupWard() {
        return pickupWard;
    }

    public void setPickupWard(String pickupWard) {
        this.pickupWard = pickupWard;
    }

    public String getPickupAddress() {
        return pickupAddress;
    }

    public void setPickupAddress(String pickupAddress) {
        this.pickupAddress = pickupAddress;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getUsageNotes() {
        return usageNotes;
    }

    public void setUsageNotes(String usageNotes) {
        this.usageNotes = usageNotes;
    }

    public double getDepositAmount() {
        return depositAmount;
    }

    public void setDepositAmount(double depositAmount) {
        this.depositAmount = depositAmount;
    }

    public Service getServiceDetails() {
        return serviceDetails;
    }

    public void setServiceDetails(Service serviceDetails) {
        this.serviceDetails = serviceDetails;
    }

    public VehicleBrand getBrandDetails() {
        return brandDetails;
    }

    public void setBrandDetails(VehicleBrand brandDetails) {
        this.brandDetails = brandDetails;
    }

    public String getDisplayName() {
        String brandName = "";

        if (brandDetails != null && brandDetails.getBrandName() != null) {
            brandName = brandDetails.getBrandName().trim();
        }

        String model = vehicleModel == null ? "" : vehicleModel.trim();

        if (!brandName.isEmpty() && !model.isEmpty()) {
            String lowerBrand = brandName.toLowerCase();
            String lowerModel = model.toLowerCase();

            if (lowerModel.startsWith(lowerBrand)) {
                return model;
            }

            return brandName + " " + model;
        }

        if (!model.isEmpty()) {
            return model;
        }

        return brandName;
    }

    public String getDisplayStatus() {
        if ("Available".equalsIgnoreCase(status)) {
            return "Còn trống";
        }

        if ("Rented".equalsIgnoreCase(status)) {
            return "Đã được thuê";
        }

        if ("Maintenance".equalsIgnoreCase(status)) {
            return "Bảo trì";
        }

        if ("Unavailable".equalsIgnoreCase(status)) {
            return "Tạm ngưng";
        }

        return status;
    }

    public String getFullPickupAddress() {
        if (pickupAddress != null && !pickupAddress.trim().isEmpty()) {
            return pickupAddress.trim();
        }

        StringBuilder result = new StringBuilder();

        appendAddressPart(result, pickupWard);
        appendAddressPart(result, pickupDistrict);
        appendAddressPart(result, pickupProvince);

        return result.toString();
    }

    private void appendAddressPart(StringBuilder result, String value) {
        if (value == null || value.trim().isEmpty()) {
            return;
        }

        if (result.length() > 0) {
            result.append(", ");
        }

        result.append(value.trim());
    }
}
