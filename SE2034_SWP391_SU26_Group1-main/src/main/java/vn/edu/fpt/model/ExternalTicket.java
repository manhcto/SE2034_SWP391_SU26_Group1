package vn.edu.fpt.model; // Bạn đổi lại tên package cho đúng với dự án của nhóm

import java.sql.Time;

public class ExternalTicket {
    private int serviceID;
    private String name;
    private String image;
    private String address;
    private String phone;
    private String description;
    private double rate;
    private int reviewCount;
    private String type;
    private String status;
    private Time timeOpen;
    private Time timeClose;
    private String dayOfWeekOpen;
    private double ticketPrice;

    // 1. Constructor không tham số
    public ExternalTicket() {
    }

    // 2. Constructor đầy đủ tham số
    public ExternalTicket(int serviceID, String name, String image, String address, String phone,
                          String description, double rate, int reviewCount, String type,
                          String status, Time timeOpen, Time timeClose, String dayOfWeekOpen, double ticketPrice) {
        this.serviceID = serviceID;
        this.name = name;
        this.image = image;
        this.address = address;
        this.phone = phone;
        this.description = description;
        this.rate = rate;
        this.reviewCount = reviewCount;
        this.type = type;
        this.status = status;
        this.timeOpen = timeOpen;
        this.timeClose = timeClose;
        this.dayOfWeekOpen = dayOfWeekOpen;
        this.ticketPrice = ticketPrice;
    }

    // 3. Toàn bộ các hàm Getter và Setter
    public int getServiceID() { return serviceID; }
    public void setServiceID(int serviceID) { this.serviceID = serviceID; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public double getRate() { return rate; }
    public void setRate(double rate) { this.rate = rate; }

    public int getReviewCount() { return reviewCount; }
    public void setReviewCount(int reviewCount) { this.reviewCount = reviewCount; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Time getTimeOpen() { return timeOpen; }
    public void setTimeOpen(Time timeOpen) { this.timeOpen = timeOpen; }

    public Time getTimeClose() { return timeClose; }
    public void setTimeClose(Time timeClose) { this.timeClose = timeClose; }

    public String getDayOfWeekOpen() { return dayOfWeekOpen; }
    public void setDayOfWeekOpen(String dayOfWeekOpen) { this.dayOfWeekOpen = dayOfWeekOpen; }

    public double getTicketPrice() { return ticketPrice; }
    public void setTicketPrice(double ticketPrice) { this.ticketPrice = ticketPrice; }
}