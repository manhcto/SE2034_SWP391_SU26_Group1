package vn.edu.fpt.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.DAO.AccommodationDAO;
import vn.edu.fpt.DAO.RoomDAO;
import vn.edu.fpt.model.Accommodation;
import vn.edu.fpt.model.Room;
import vn.edu.fpt.model.User;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;

@WebServlet(name = "AccommodationBookingFormController", urlPatterns = {"/booking/accommodation/form"})
public class AccommodationBookingFormController extends HttpServlet {

    private final AccommodationDAO accommodationDAO = new AccommodationDAO();
    private final RoomDAO roomDAO = new RoomDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("user");

        if (user == null) {
            request.getSession().setAttribute("redirectAfterLogin", currentPathWithQuery(request));
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int accommodationID = parsePositiveInt(request.getParameter("accommodationID"));
        int roomID = parsePositiveInt(request.getParameter("roomID"));
        int adults = parsePositiveInt(request.getParameter("adults"));
        int children = parseNonNegativeInt(request.getParameter("children"));
        int rooms = parsePositiveInt(request.getParameter("rooms"));
        String checkIn = safeTrim(request.getParameter("checkIn"));
        String checkOut = safeTrim(request.getParameter("checkOut"));

        String detailUrl = buildRoomDetailUrl(request, accommodationID, roomID, checkIn, checkOut, adults, children, rooms);

        if (accommodationID <= 0 || roomID <= 0 || adults <= 0 || children < 0 || rooms <= 0
                || !hasValidDateRange(checkIn, checkOut)) {
            response.sendRedirect(detailUrl + "&status=invalidBooking");
            return;
        }

        Accommodation accommodation = accommodationDAO.getAccommodationByIdForCustomer(accommodationID);
        Room selectedRoom = findSelectedAvailableRoom(accommodationID, roomID, checkIn, checkOut);

        if (accommodation == null || selectedRoom == null || selectedRoom.getRoomAvailability() < rooms) {
            response.sendRedirect(detailUrl + "&status=roomUnavailable");
            return;
        }

        long nights = ChronoUnit.DAYS.between(LocalDate.parse(checkIn), LocalDate.parse(checkOut));
        BigDecimal totalPrice = selectedRoom.getPriceOfRoom()
                .multiply(BigDecimal.valueOf(rooms))
                .multiply(BigDecimal.valueOf(nights));

        request.setAttribute("user", user);
        request.setAttribute("accommodation", accommodation);
        request.setAttribute("room", selectedRoom);
        request.setAttribute("checkIn", checkIn);
        request.setAttribute("checkOut", checkOut);
        request.setAttribute("adults", adults);
        request.setAttribute("children", children);
        request.setAttribute("rooms", rooms);
        request.setAttribute("guests", adults + children);
        request.setAttribute("nights", nights);
        request.setAttribute("totalPrice", totalPrice);
        request.setAttribute("detailUrl", detailUrl);

        request.getRequestDispatcher("/views/customer/accommodation-booking-form.jsp")
                .forward(request, response);
    }

    private Room findSelectedAvailableRoom(int accommodationID, int roomID, String checkIn, String checkOut) {
        List<Room> availableRooms = roomDAO.getAvailableRoomsByAccommodationAndDate(accommodationID, checkIn, checkOut);

        for (Room room : availableRooms) {
            if (room.getRoomID() == roomID) {
                return room;
            }
        }

        return null;
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

    private String buildRoomDetailUrl(HttpServletRequest request, int accommodationID, int roomID,
                                      String checkIn, String checkOut, int adults, int children, int rooms) {
        return request.getContextPath()
                + "/accommodation/room/detail?id=" + roomID
                + "&accommodationId=" + accommodationID
                + "&checkIn=" + checkIn
                + "&checkOut=" + checkOut
                + "&adults=" + adults
                + "&children=" + children
                + "&rooms=" + rooms
                + "&guests=" + (adults + children);
    }

    private String currentPathWithQuery(HttpServletRequest request) {
        String path = request.getServletPath();
        String query = request.getQueryString();
        return query == null || query.isBlank() ? path : path + "?" + query;
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
}
