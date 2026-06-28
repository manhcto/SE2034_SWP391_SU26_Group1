package vn.edu.fpt.model;

import java.util.Date;

public class Feedback {
    private int feedbackID;
    private double rate;
    private String content;
    private Date createDate;
    private String status;
    private String image;
    private int userID;
    private int bookingID;

    /*
     * Các field bên dưới không cần thêm cột vào database.
     * Chúng dùng để hiển thị dữ liệu sau khi JOIN bảng User, Booking,
     * Booking_Detail, Service, Accommodation, Vehicle.
     */
    private String customerName;
    private String customerEmail;
    private String bookingCode;
    private String bookingType;

    private Integer serviceID;
    private String serviceType;
    private String serviceName;
    private String serviceImage;

    private String statusText;
    private boolean owner;

    public Feedback() {
    }

    public Feedback(int feedbackID, double rate, String content, Date createDate,
                    String status, String image, int userID, int bookingID) {
        this.feedbackID = feedbackID;
        this.rate = rate;
        this.content = content;
        this.createDate = createDate;
        this.status = status;
        this.image = image;
        this.userID = userID;
        this.bookingID = bookingID;
    }

    public int getFeedbackID() {
        return feedbackID;
    }

    public void setFeedbackID(int feedbackID) {
        this.feedbackID = feedbackID;
    }

    public double getRate() {
        return rate;
    }

    public void setRate(double rate) {
        this.rate = rate;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
        this.statusText = convertStatusToVietnamese(status);
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public int getBookingID() {
        return bookingID;
    }

    public void setBookingID(int bookingID) {
        this.bookingID = bookingID;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getCustomerEmail() {
        return customerEmail;
    }

    public void setCustomerEmail(String customerEmail) {
        this.customerEmail = customerEmail;
    }

    public String getBookingCode() {
        return bookingCode;
    }

    public void setBookingCode(String bookingCode) {
        this.bookingCode = bookingCode;
    }

    public String getBookingType() {
        return bookingType;
    }

    public void setBookingType(String bookingType) {
        this.bookingType = bookingType;
    }

    public Integer getServiceID() {
        return serviceID;
    }

    public void setServiceID(Integer serviceID) {
        this.serviceID = serviceID;
    }

    public String getServiceType() {
        return serviceType;
    }

    public void setServiceType(String serviceType) {
        this.serviceType = serviceType;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public String getServiceImage() {
        return serviceImage;
    }

    public void setServiceImage(String serviceImage) {
        this.serviceImage = serviceImage;
    }

    public String getStatusText() {
        if (statusText == null || statusText.trim().isEmpty()) {
            return convertStatusToVietnamese(status);
        }

        return statusText;
    }

    public void setStatusText(String statusText) {
        this.statusText = statusText;
    }

    public boolean isOwner() {
        return owner;
    }

    public boolean getOwner() {
        return owner;
    }

    public void setOwner(boolean owner) {
        this.owner = owner;
    }

    public String getServiceTypeText() {
        if ("Accommodation".equalsIgnoreCase(serviceType)) {
            return "Khách sạn";
        }

        if ("Vehicle".equalsIgnoreCase(serviceType)) {
            return "Xe";
        }

        if ("Tour".equalsIgnoreCase(serviceType)) {
            return "Tour";
        }

        return "Dịch vụ";
    }

    private String convertStatusToVietnamese(String status) {
        if ("Visible".equalsIgnoreCase(status)) {
            return "Hiển thị";
        }

        if ("Hidden".equalsIgnoreCase(status)) {
            return "Đang ẩn";
        }

        return status;
    }

    @Override
    public String toString() {
        return "Feedback{" +
                "feedbackID=" + feedbackID +
                ", rate=" + rate +
                ", content='" + content + '\'' +
                ", createDate=" + createDate +
                ", status='" + status + '\'' +
                ", image='" + image + '\'' +
                ", userID=" + userID +
                ", bookingID=" + bookingID +
                ", customerName='" + customerName + '\'' +
                ", bookingCode='" + bookingCode + '\'' +
                ", serviceID=" + serviceID +
                ", serviceType='" + serviceType + '\'' +
                ", serviceName='" + serviceName + '\'' +
                '}';
    }
}