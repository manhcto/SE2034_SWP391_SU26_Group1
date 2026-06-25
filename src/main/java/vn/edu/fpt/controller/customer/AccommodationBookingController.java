package vn.edu.fpt.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.DAO.RoomBookingDAO;
import vn.edu.fpt.DAO.RoomDAO;
import vn.edu.fpt.model.Room;
import vn.edu.fpt.model.User;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;

@WebServlet(name = "AccommodationBookingController", urlPatterns = {"/booking/accommodation"})
public class AccommodationBookingController extends HttpServlet {

    private final RoomDAO roomDAO = new RoomDAO();
    private final RoomBookingDAO roomBookingDAO = new RoomBookingDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("user");

        int accommodationID = parsePositiveInt(request.getParameter("accommodationID"));
        int roomID = parsePositiveInt(request.getParameter("roomID"));
        int adults = parsePositiveInt(request.getParameter("adults"));
        int children = parseNonNegativeInt(request.getParameter("children"));
        int rooms = parsePositiveInt(request.getParameter("rooms"));
        String checkIn = safeTrim(request.getParameter("checkIn"));
        String checkOut = safeTrim(request.getParameter("checkOut"));

        String detailUrl = request.getContextPath()
                + "/accommodation/room/detail?id=" + roomID
                + "&accommodationId=" + accommodationID
                + "&checkIn=" + checkIn
                + "&checkOut=" + checkOut
                + "&adults=" + adults
                + "&children=" + children
                + "&rooms=" + rooms
                + "&guests=" + (adults + children);

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (accommodationID <= 0 || roomID <= 0 || adults <= 0 || children < 0 || rooms <= 0
                || !hasValidDateRange(checkIn, checkOut)) {
            response.sendRedirect(detailUrl + "&status=invalidBooking");
            return;
        }

        List<Room> availableRooms = roomDAO.getAvailableRoomsByAccommodationAndDate(accommodationID, checkIn, checkOut);
        Room selectedRoom = null;

        for (Room room : availableRooms) {
            if (room.getRoomID() == roomID) {
                selectedRoom = room;
                break;
            }
        }

        if (selectedRoom == null || selectedRoom.getRoomAvailability() < rooms) {
            response.sendRedirect(detailUrl + "&status=roomUnavailable");
            return;
        }

        long nights = ChronoUnit.DAYS.between(LocalDate.parse(checkIn), LocalDate.parse(checkOut));
        BigDecimal unitPrice = selectedRoom.getPriceOfRoom();
        BigDecimal totalPrice = unitPrice
                .multiply(BigDecimal.valueOf(rooms))
                .multiply(BigDecimal.valueOf(nights));

        int bookingID = roomBookingDAO.createAccommodationBooking(
                user.getUserID(),
                fallback(user.getFirstName(), "Guest"),
                fallback(user.getLastName(), "Customer"),
                fallback(user.getEmail(), "guest@example.com"),
                fallback(user.getPhone(), "0000000000"),
                accommodationID,
                roomID,
                Date.valueOf(checkIn),
                Date.valueOf(checkOut),
                adults,
                children,
                rooms,
                unitPrice,
                totalPrice);

        if (bookingID <= 0) {
            response.sendRedirect(detailUrl + "&status=bookingFail");
            return;
        }

        session.setAttribute("successMessage", "Dat phong thanh cong. Ma don: #" + bookingID);
        response.sendRedirect(detailUrl + "&status=bookingSuccess");
    }

    private boolean hasValidDateRange(String checkIn, String checkOut) {
        try {
            if (checkIn.isEmpty() || checkOut.isEmpty()) {
                return false;
            }

            LocalDate inDate = LocalDate.parse(checkIn);
            LocalDate outDate = LocalDate.parse(checkOut);
            return outDate.isAfter(inDate);
        } catch (Exception e) {
            return false;
        }
    }

    private int parsePositiveInt(String value) {
        try {
            int number = Integer.parseInt(safeTrim(value));
            return number > 0 ? number : 0;
        } catch (Exception e) {
            return 0;
        }
    }

    private int parseNonNegativeInt(String value) {
        try {
            int number = Integer.parseInt(safeTrim(value));
            return number >= 0 ? number : -1;
        } catch (Exception e) {
            return -1;
        }
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }

    private String fallback(String value, String fallbackValue) {
        return value == null || value.trim().isEmpty() ? fallbackValue : value.trim();
    }
}
