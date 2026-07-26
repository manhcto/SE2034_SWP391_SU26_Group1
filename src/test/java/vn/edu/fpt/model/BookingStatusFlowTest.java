package vn.edu.fpt.model;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class BookingStatusFlowTest {

    @Test
    void followsStaffConfirmationAndTourCompletionLifecycle() {
        assertEquals(Booking.DISPLAY_STATUS_PROCESSING, Booking.toDisplayStatus("Đang xử lý"));
        assertEquals(Booking.DISPLAY_STATUS_APPROVED, Booking.toDisplayStatus("Đã duyệt"));
        assertEquals(Booking.DISPLAY_STATUS_ENDED, Booking.toDisplayStatus("Tour kết thúc"));

        assertTrue(Booking.canTransitionStatus("Pending", "Đã xác nhận"));
        assertTrue(Booking.canTransitionStatus("Đã xác nhận", "Hoàn tất Tour"));
        assertTrue(Booking.canTransitionStatus("Chờ xử lý", "Đã hủy"));
        assertFalse(Booking.canTransitionStatus("Pending", "Hoàn tất Tour"));
        assertFalse(Booking.canTransitionStatus("Confirmed", "Pending"));
        assertFalse(Booking.canTransitionStatus("Cancelled", "Pending"));
        assertFalse(Booking.canTransitionStatus("End", "Confirmed"));
    }
}
