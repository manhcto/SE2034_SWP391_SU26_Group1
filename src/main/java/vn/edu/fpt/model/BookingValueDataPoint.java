package vn.edu.fpt.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

public class BookingValueDataPoint {
    private static final DateTimeFormatter DISPLAY_FORMAT = DateTimeFormatter.ofPattern("dd/MM");

    private LocalDate date;
    private BigDecimal totalValue = BigDecimal.ZERO;
    private double barPercent;

    public BookingValueDataPoint() {
    }

    public BookingValueDataPoint(LocalDate date, BigDecimal totalValue) {
        this.date = date;
        setTotalValue(totalValue);
    }

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    public BigDecimal getTotalValue() {
        return totalValue;
    }

    public void setTotalValue(BigDecimal totalValue) {
        this.totalValue = totalValue == null ? BigDecimal.ZERO : totalValue;
    }

    public String getDisplayDate() {
        return date == null ? "" : date.format(DISPLAY_FORMAT);
    }

    public double getBarPercent() {
        return barPercent;
    }

    public void setBarPercent(double barPercent) {
        this.barPercent = barPercent;
    }
}
