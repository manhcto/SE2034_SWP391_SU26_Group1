package vn.edu.fpt.model;

import java.math.BigDecimal;
import java.sql.Time;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class Accommodation {

    private int accommodationID;
    private String name;
    private String image;
    private String address;
    private String phone;
    private String description;
    private BigDecimal rate;
    private String type;
    private String status;
    private Time checkInTime;
    private Time checkOutTime;
    private String province;
    private String district;
    private String ward;
    private Integer createdByUserID;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    private List<Room> roomList;
    private List<Facility> facilityList;

    public Accommodation() {
        this.roomList = new ArrayList<>();
        this.facilityList = new ArrayList<>();
    }

    public int getAccommodationID() {
        return accommodationID;
    }

    public void setAccommodationID(int accommodationID) {
        this.accommodationID = accommodationID;
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

    public BigDecimal getRate() {
        return rate;
    }

    public void setRate(BigDecimal rate) {
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

    public Integer getCreatedByUserID() {
        return createdByUserID;
    }

    public void setCreatedByUserID(Integer createdByUserID) {
        this.createdByUserID = createdByUserID;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
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

    public BigDecimal getMinRoomPrice() {
        if (roomList == null || roomList.isEmpty()) {
            return BigDecimal.ZERO;
        }

        BigDecimal min = null;

        for (Room room : roomList) {
            BigDecimal price = room.getPriceOfRoom();
            if (price != null && price.signum() > 0
                    && (min == null || price.compareTo(min) < 0)) {
                min = price;
            }
        }

        return min == null ? BigDecimal.ZERO : min;
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
