package vn.edu.fpt.DAO;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class RoomDAOTest {

    @Test
    void calculatesAvailabilityForAnOverlappingStay() {
        assertEquals(7, RoomDAO.calculateEffectiveAvailability(10, 3));
        assertEquals(0, RoomDAO.calculateEffectiveAvailability(2, 4));
        assertEquals(5, RoomDAO.calculateEffectiveAvailability(5, -1));
    }
}
