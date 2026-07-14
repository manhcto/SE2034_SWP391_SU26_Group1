package vn.edu.fpt.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class Room {

    private int roomID;
    private String roomType;
    private int numberOfRooms;
    private BigDecimal priceOfRoom;
    private String status;
    private int accommodationID;
    private int roomAvailability;
    private String image;
    private String description;
    private int bedCount;
    private String bedType;
    private int maxAdults;
    private int maxChildren;
    private BigDecimal roomSize;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    private List<Facility> facilityList;

    public Room() {
        this.priceOfRoom = BigDecimal.ZERO;
        this.facilityList = new ArrayList<>();
    }

    public int getRoomID() {
        return roomID;
    }

    public void setRoomID(int roomID) {
        this.roomID = roomID;
    }

    public String getRoomType() {
        return roomType;
    }

    public void setRoomType(String roomType) {
        this.roomType = safeTrim(roomType);
    }

    public int getNumberOfRooms() {
        return numberOfRooms;
    }

    public void setNumberOfRooms(int numberOfRooms) {
        this.numberOfRooms = numberOfRooms;
    }

    public BigDecimal getPriceOfRoom() {
        return priceOfRoom;
    }

    public void setPriceOfRoom(BigDecimal priceOfRoom) {
        this.priceOfRoom = priceOfRoom == null ? BigDecimal.ZERO : priceOfRoom;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = safeTrim(status);
    }

    public int getAccommodationID() {
        return accommodationID;
    }

    public void setAccommodationID(int accommodationID) {
        this.accommodationID = accommodationID;
    }

    public int getRoomAvailability() {
        return roomAvailability;
    }

    public void setRoomAvailability(int roomAvailability) {
        this.roomAvailability = roomAvailability;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = safeTrim(image);
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = safeTrim(description);
    }

    public int getBedCount() {
        return bedCount;
    }

    public void setBedCount(int bedCount) {
        this.bedCount = bedCount;
    }

    public String getBedType() {
        return bedType;
    }

    public void setBedType(String bedType) {
        this.bedType = safeTrim(bedType);
    }

    public int getMaxAdults() {
        return maxAdults;
    }

    public void setMaxAdults(int maxAdults) {
        this.maxAdults = maxAdults;
    }

    public int getMaxChildren() {
        return maxChildren;
    }

    public void setMaxChildren(int maxChildren) {
        this.maxChildren = maxChildren;
    }

    public BigDecimal getRoomSize() {
        return roomSize;
    }

    public void setRoomSize(BigDecimal roomSize) {
        this.roomSize = roomSize;
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

    public List<Facility> getFacilityList() {
        return facilityList;
    }

    public void setFacilityList(List<Facility> facilityList) {
        this.facilityList = facilityList == null ? new ArrayList<>() : facilityList;
    }

    // Dùng để tương thích code cũ đang gọi getFacilities()
    public List<Facility> getFacilities() {
        return facilityList;
    }

    // Dùng để tương thích code cũ đang gọi setFacilities(...)
    public void setFacilities(List<Facility> facilities) {
        this.facilityList = facilities == null ? new ArrayList<>() : facilities;
    }

    public String getDisplayStatus() {
        if ("Available".equalsIgnoreCase(status)) {
            return "Còn phòng";
        }

        if ("Unavailable".equalsIgnoreCase(status)) {
            return "Hết phòng";
        }

        if ("Maintenance".equalsIgnoreCase(status)) {
            return "Bảo trì";
        }

        return status;
    }

    public String getDisplayBedType() {
        if ("Single".equalsIgnoreCase(bedType)) {
            return "Giường đơn";
        }

        if ("Double".equalsIgnoreCase(bedType)) {
            return "Giường đôi";
        }

        if ("Queen".equalsIgnoreCase(bedType)) {
            return "Giường Queen";
        }

        if ("King".equalsIgnoreCase(bedType)) {
            return "Giường King";
        }

        return bedType;
    }

    public boolean isAvailable() {
        return "Available".equalsIgnoreCase(status) && roomAvailability > 0;
    }

    public boolean canAccommodate(int adults, int children, int requestedRooms) {
        return canAccommodate(adults, children, requestedRooms, adults + children);
    }

    public boolean canAccommodate(int adults, int children, int requestedRooms, int totalGuests) {
        if (adults < 1 || children < 0 || requestedRooms < 1) {
            return false;
        }

        if (totalGuests != adults + children) {
            return false;
        }

        return (long) adults <= (long) maxAdults * requestedRooms
                && (long) children <= (long) maxChildren * requestedRooms
                && (long) totalGuests <= (long) (maxAdults + maxChildren) * requestedRooms;
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }
}
