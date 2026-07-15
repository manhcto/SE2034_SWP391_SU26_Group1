package vn.edu.fpt.model;

import org.junit.jupiter.api.Test;

import java.sql.Timestamp;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class PaymentTest {

    @Test
    void detectsExpiryAndReleasedReservationWithoutChangingPaymentStatus() {
        Payment payment = new Payment();
        payment.setStatus("Pending");
        payment.setExpiredAt(new Timestamp(System.currentTimeMillis() - 1_000));

        assertTrue(payment.isExpired());

        payment.setNote("[SLOT_RELEASED] Hết thời gian giữ chỗ.");
        assertTrue(payment.isReservationReleased());
        assertFalse(payment.isPaid());

        payment.setStatus("Paid");
        assertFalse(payment.isExpired());
        assertTrue(payment.isPaid());
    }
}
