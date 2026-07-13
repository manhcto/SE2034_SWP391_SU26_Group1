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
        if ("Pending".equalsIgnoreCase(status)) {
            return "Chờ xử lý";
        }

        if ("Confirmed".equalsIgnoreCase(status)) {
            return "Đã xác nhận";
        }

        if ("Cancelled".equalsIgnoreCase(status)) {
            return "Đã hủy";
        }

        if ("Completed".equalsIgnoreCase(status)) {
            return "Hoàn tất";
        }

        return status;
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
