package vn.edu.fpt.model;

public class BookingTypeStat {
    private String bookingType;
    private int count;
    private double percentage;

    public BookingTypeStat() {
    }

    public BookingTypeStat(String bookingType, int count) {
        setBookingType(bookingType);
        this.count = count;
    }

    public String getBookingType() {
        return bookingType;
    }

    public void setBookingType(String bookingType) {
        this.bookingType = safeTrim(bookingType);
    }

    public int getCount() {
        return count;
    }

    public void setCount(int count) {
        this.count = count;
    }

    public String getDisplayType() {
        if ("Tour".equalsIgnoreCase(bookingType)) {
            return "Tour";
        }

        if ("Accommodation".equalsIgnoreCase(bookingType)) {
            return "Lưu trú";
        }

        return bookingType;
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
