package vn.edu.fpt.model;

public class ServicePerformanceItem {
    private int serviceID;
    private String serviceName;
    private int bookingCount;
    private double percentage;

    public int getServiceID() {
        return serviceID;
    }

    public void setServiceID(int serviceID) {
        this.serviceID = serviceID;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = safeTrim(serviceName);
    }

    public int getBookingCount() {
        return bookingCount;
    }

    public void setBookingCount(int bookingCount) {
        this.bookingCount = bookingCount;
    }

    public double getPercentage() {
        return percentage;
    }

    public void setPercentage(double percentage) {
        this.percentage = percentage;
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }
}
