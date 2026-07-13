package vn.edu.fpt.model;

import java.math.BigDecimal;

public class DashboardSummary {
    private int totalBookings;
    private BigDecimal confirmedBookingValue = BigDecimal.ZERO;
    private int completedBookings;
    private int newCustomers;

    public int getTotalBookings() {
        return totalBookings;
    }

    public void setTotalBookings(int totalBookings) {
        this.totalBookings = totalBookings;
    }

    public BigDecimal getConfirmedBookingValue() {
        return confirmedBookingValue;
    }

    public void setConfirmedBookingValue(BigDecimal confirmedBookingValue) {
        this.confirmedBookingValue = confirmedBookingValue == null ? BigDecimal.ZERO : confirmedBookingValue;
    }

    public int getCompletedBookings() {
        return completedBookings;
    }

    public void setCompletedBookings(int completedBookings) {
        this.completedBookings = completedBookings;
    }

    public int getNewCustomers() {
        return newCustomers;
    }

    public void setNewCustomers(int newCustomers) {
        this.newCustomers = newCustomers;
    }
}
