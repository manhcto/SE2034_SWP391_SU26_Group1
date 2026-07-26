package vn.edu.fpt.model;

public class BookingStatusStat {
    private String status;
    private int count;
    private double percentage;

    public BookingStatusStat() {
    }

    public BookingStatusStat(String status, int count) {
        setStatus(status);
        this.count = count;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = safeTrim(status);
    }

    public int getCount() {
        return count;
    }

    public void setCount(int count) {
        this.count = count;
    }

    public String getDisplayStatus() {
        return Booking.toDisplayStatus(status);
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
