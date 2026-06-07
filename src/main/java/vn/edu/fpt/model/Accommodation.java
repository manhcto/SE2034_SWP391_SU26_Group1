package vn.edu.fpt.model;

import java.sql.Time;
import java.util.ArrayList;
import java.util.List;

public class Accommodation {

    private int serviceID;
    private String name;
    private String image;
    private String address;
    private String phone;
    private String description;
    private double rate;
    private String type;
    private String status;
    private Time checkInTime;
    private Time checkOutTime;
    private String province;
    private String district;
    private String ward;

    private Service serviceDetails;
    private List<Room> roomList;
    private List<Facility> facilityList;

    public Accommodation() {
        this.roomList = new ArrayList<>();
        this.facilityList = new ArrayList<>();
    }

    public int getServiceID() {
        return serviceID;
    }

    public void setServiceID(int serviceID) {
        this.serviceID = serviceID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = safeTrim(name);
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = safeTrim(image);
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = safeTrim(address);
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = safeTrim(phone);
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = safeTrim(description);
    }

    public double getRate() {
        return rate;
    }

    public void setRate(double rate) {
        this.rate = rate;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = safeTrim(type);
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = safeTrim(status);
    }

    public Time getCheckInTime() {
        return checkInTime;
    }

    public void setCheckInTime(Time checkInTime) {
        this.checkInTime = checkInTime;
    }

    public Time getCheckOutTime() {
        return checkOutTime;
    }

    public void setCheckOutTime(Time checkOutTime) {
        this.checkOutTime = checkOutTime;
    }

    public String getProvince() {
        return province;
    }

    public void setProvince(String province) {
        this.province = safeTrim(province);
    }

    public String getDistrict() {
        return district;
    }

    public void setDistrict(String district) {
        this.district = safeTrim(district);
    }

    public String getWard() {
        return ward;
    }

    public void setWard(String ward) {
        this.ward = safeTrim(ward);
    }

    public Service getServiceDetails() {
        return serviceDetails;
    }

    public void setServiceDetails(Service serviceDetails) {
        this.serviceDetails = serviceDetails;
    }

    public List<Room> getRoomList() {
        return roomList;
    }

    public void setRoomList(List<Room> roomList) {
        this.roomList = roomList == null ? new ArrayList<>() : roomList;
    }

    public List<Facility> getFacilityList() {
        return facilityList;
    }

    public void setFacilityList(List<Facility> facilityList) {
        this.facilityList = facilityList == null ? new ArrayList<>() : facilityList;
    }

    public String getDisplayType() {
        if ("Hotel".equalsIgnoreCase(type) || "Khách sạn".equalsIgnoreCase(type)) {
            return "Khách sạn";
        }

        if ("Homestay".equalsIgnoreCase(type)) {
            return "Homestay";
        }

        if ("Resort".equalsIgnoreCase(type)) {
            return "Resort";
        }

        if ("Apartment".equalsIgnoreCase(type) || "Căn hộ".equalsIgnoreCase(type)) {
            return "Căn hộ";
        }

        if ("Villa".equalsIgnoreCase(type)) {
            return "Villa";
        }

        return type;
    }

    public String getDisplayStatus() {
        if ("Available".equalsIgnoreCase(status) || "Active".equalsIgnoreCase(status)) {
            return "Đang hoạt động";
        }

        if ("Unavailable".equalsIgnoreCase(status) || "Inactive".equalsIgnoreCase(status)) {
            return "Tạm ngưng";
        }

        if ("Maintenance".equalsIgnoreCase(status)) {
            return "Bảo trì";
        }

        return status;
    }

    public String getCheckInText() {
        return checkInTime == null ? "" : checkInTime.toString().substring(0, 5);
    }

    public String getCheckOutText() {
        return checkOutTime == null ? "" : checkOutTime.toString().substring(0, 5);
    }

    public String getFullAddress() {
        StringBuilder sb = new StringBuilder();

        if (!isBlank(address)) {
            sb.append(address);
        }

        if (!isBlank(ward)) {
            appendComma(sb);
            sb.append(ward);
        }

        if (!isBlank(district)) {
            appendComma(sb);
            sb.append(district);
        }

        if (!isBlank(province)) {
            appendComma(sb);
            sb.append(province);
        }

        return sb.toString();
    }

    public double getMinRoomPrice() {
        if (roomList == null || roomList.isEmpty()) {
            return 0;
        }

        double min = Double.MAX_VALUE;

        for (Room room : roomList) {
            if (room.getPriceOfRoom() != null) {
                double price = room.getPriceOfRoom().doubleValue();

                if (price > 0 && price < min) {
                    min = price;
                }
            }
        }

        return min == Double.MAX_VALUE ? 0 : min;
    }

    public int getTotalAvailableRooms() {
        if (roomList == null || roomList.isEmpty()) {
            return 0;
        }

        int total = 0;

        for (Room room : roomList) {
            total += room.getRoomAvailability();
        }

        return total;
    }

    private void appendComma(StringBuilder sb) {
        if (sb.length() > 0) {
            sb.append(", ");
        }
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }
}