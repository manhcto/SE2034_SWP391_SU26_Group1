package vn.edu.fpt.model;

public class Room {

    private int roomID;
    private String roomType;
    private int numberOfRooms;
    private double priceOfRoom;
    private String status;
    private int serviceID;
    private int roomAvailability;

    public Room() {
    }

    public Room(int roomID, String roomType, int numberOfRooms,
                double priceOfRoom, String status, int serviceID,
                int roomAvailability) {
        this.roomID = roomID;
        this.roomType = roomType;
        this.numberOfRooms = numberOfRooms;
        this.priceOfRoom = priceOfRoom;
        this.status = status;
        this.serviceID = serviceID;
        this.roomAvailability = roomAvailability;
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
        this.roomType = roomType;
    }

    public int getNumberOfRooms() {
        return numberOfRooms;
    }

    public void setNumberOfRooms(int numberOfRooms) {
        this.numberOfRooms = numberOfRooms;
    }

    public double getPriceOfRoom() {
        return priceOfRoom;
    }

    public void setPriceOfRoom(double priceOfRoom) {
        this.priceOfRoom = priceOfRoom;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getServiceID() {
        return serviceID;
    }

    public void setServiceID(int serviceID) {
        this.serviceID = serviceID;
    }

    public int getRoomAvailability() {
        return roomAvailability;
    }

    public void setRoomAvailability(int roomAvailability) {
        this.roomAvailability = roomAvailability;
    }
}