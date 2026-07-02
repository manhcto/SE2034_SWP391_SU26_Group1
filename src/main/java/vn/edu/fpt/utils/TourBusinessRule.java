package vn.edu.fpt.utils;

import java.time.LocalDate;
import java.time.YearMonth;

public final class TourBusinessRule {
    private TourBusinessRule() {}

    public static final String STATUS_DRAFT = "Draft";
    public static final String STATUS_REJECTED = "Rejected";
    public static final String STATUS_PENDING_APPROVAL = "PendingApproval";
    public static final String STATUS_SELLING = "Selling";
    public static final String STATUS_APPROVED_LEGACY = "Approved";
    public static final String STATUS_SOLD_OUT = "SoldOut";
    public static final String STATUS_CANCELLED = "Cancelled";
    public static final String STATUS_COMPLETED = "Completed";

    public static final String SCHEDULE_DRAFT = "Draft";
    public static final String SCHEDULE_PENDING_APPROVAL = "PendingApproval";
    public static final String SCHEDULE_OPEN = "Open";
    public static final String SCHEDULE_FULL = "Full";
    public static final String SCHEDULE_CLOSED = "Closed";
    public static final String SCHEDULE_DEPARTED = "Departed";
    public static final String SCHEDULE_COMPLETED = "Completed";
    public static final String SCHEDULE_CANCELLED = "Cancelled";

    public static final String TRANSPORT_CAR = "Ô tô";
    public static final String TRANSPORT_COACH = "Xe khách";
    public static final String TRANSPORT_SLEEPER_BUS = "Xe giường nằm";
    public static final String TRANSPORT_RAILWAY = "Đường sắt";

    public static final int DEFAULT_VAT_PERCENT = 8;
    public static final int MIN_ADULT_PRICE = 100_000;
    public static final int MAX_ADULT_PRICE = 100_000_000;
    public static final int MAX_SINGLE_ROOM_SURCHARGE = 50_000_000;

    public static boolean isValidTransport(String transport) {
        return TRANSPORT_CAR.equals(transport)
                || TRANSPORT_COACH.equals(transport)
                || TRANSPORT_SLEEPER_BUS.equals(transport)
                || TRANSPORT_RAILWAY.equals(transport);
    }

    public static boolean requiresDriver(String transport) {
        return TRANSPORT_CAR.equals(transport)
                || TRANSPORT_COACH.equals(transport)
                || TRANSPORT_SLEEPER_BUS.equals(transport);
    }

    public static boolean canEditTourBasic(String tourStatus) {
        return STATUS_DRAFT.equals(tourStatus) || STATUS_REJECTED.equals(tourStatus);
    }

    public static boolean canEditItinerary(String tourStatus) {
        return canEditTourBasic(tourStatus);
    }

    public static boolean canAddOrEditSchedule(String tourStatus) {
        return STATUS_DRAFT.equals(tourStatus)
                || STATUS_REJECTED.equals(tourStatus)
                || STATUS_SELLING.equals(tourStatus)
                || STATUS_APPROVED_LEGACY.equals(tourStatus);
    }

    public static boolean canSubmitForApproval(String tourStatus) {
        return STATUS_DRAFT.equals(tourStatus) || STATUS_REJECTED.equals(tourStatus);
    }

    public static boolean canApprove(String tourStatus) {
        return STATUS_PENDING_APPROVAL.equals(tourStatus);
    }

    public static boolean canMarkSoldOut(String tourStatus) {
        return STATUS_SELLING.equals(tourStatus) || STATUS_APPROVED_LEGACY.equals(tourStatus);
    }

    public static boolean canEditSchedule(String scheduleStatus, int bookedSeats, LocalDate departureDate) {
        if (SCHEDULE_FULL.equals(scheduleStatus)
                || SCHEDULE_CLOSED.equals(scheduleStatus)
                || SCHEDULE_DEPARTED.equals(scheduleStatus)
                || SCHEDULE_COMPLETED.equals(scheduleStatus)
                || SCHEDULE_CANCELLED.equals(scheduleStatus)) {
            return false;
        }

        if (departureDate != null) {
            boolean oldMonth = YearMonth.from(departureDate).isBefore(YearMonth.now());
            if (oldMonth && bookedSeats > 0) {
                return false;
            }
        }

        return SCHEDULE_DRAFT.equals(scheduleStatus) || SCHEDULE_OPEN.equals(scheduleStatus) || scheduleStatus == null;
    }

    public static int calculateDisplayPrice(int adultPrice, boolean hasVAT, int vatPercent) {
        if (!hasVAT) {
            return adultPrice;
        }
        return adultPrice + (adultPrice * vatPercent / 100);
    }
}
