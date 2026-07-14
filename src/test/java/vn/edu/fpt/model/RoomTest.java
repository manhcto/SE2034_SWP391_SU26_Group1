package vn.edu.fpt.model;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class RoomTest {

    @Test
    void validatesGuestCapacityForRequestedRoomQuantity() {
        Room room = new Room();
        room.setMaxAdults(2);
        room.setMaxChildren(1);

        assertTrue(room.canAccommodate(2, 1, 1));
        assertFalse(room.canAccommodate(3, 1, 1));
        assertFalse(room.canAccommodate(2, 2, 1));
        assertTrue(room.canAccommodate(4, 2, 2));
        assertFalse(room.canAccommodate(2, 0, 1, 12));
        assertFalse(room.canAccommodate(2, 0, 1, 1));
        assertTrue(room.canAccommodate(2, 1, 1, 3));
    }
}
