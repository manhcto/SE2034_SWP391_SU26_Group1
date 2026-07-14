package vn.edu.fpt.DAO;

import org.junit.jupiter.api.Test;

import java.math.BigDecimal;

import static org.junit.jupiter.api.Assertions.assertEquals;

class RoomBookingDAOTest {

    @Test
    void calculatesVoucherDiscountWithoutAllowingNegativeTotals() {
        BigDecimal total = new BigDecimal("1000000");

        assertEquals(new BigDecimal("900000.00"),
                RoomBookingDAO.calculateDiscountedTotal(total, new BigDecimal("10"), null));
        assertEquals(new BigDecimal("850000.00"),
                RoomBookingDAO.calculateDiscountedTotal(total, null, new BigDecimal("150000")));
        assertEquals(new BigDecimal("0.00"),
                RoomBookingDAO.calculateDiscountedTotal(total, null, new BigDecimal("2000000")));
    }
}
