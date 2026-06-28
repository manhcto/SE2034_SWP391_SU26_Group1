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
        String firstName = safeTrim(request.getParameter("firstName"));
        String lastName = safeTrim(request.getParameter("lastName"));
        String email = safeTrim(request.getParameter("email"));
        String phone = safeTrim(request.getParameter("phone"));
        String address = safeTrim(request.getParameter("address"));
        String identityNumber = safeTrim(request.getParameter("identityNumber"));
        String note = safeTrim(request.getParameter("note"));

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
            request.getSession().setAttribute("redirectAfterLogin", stripContextPath(detailUrl, request));
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (accommodationID <= 0 || roomID <= 0 || adults <= 0 || children < 0 || rooms <= 0
                || !hasValidDateRange(checkIn, checkOut)) {
            response.sendRedirect(detailUrl + "&status=invalidBooking");
            return;
        }

        if (firstName.isEmpty() || lastName.isEmpty() || email.isEmpty() || phone.isEmpty()
                || address.isEmpty() || !isValidIdentityNumber(identityNumber)) {
            response.sendRedirect(buildBookingFormUrl(request, accommodationID, roomID, checkIn, checkOut,
                    adults, children, rooms) + "&status=invalidCustomerInfo");
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
                firstName,
                lastName,
                email,
                phone,
                accommodationID,
                roomID,
                Date.valueOf(checkIn),
                Date.valueOf(checkOut),
                adults,
                children,
                rooms,
                unitPrice,
                totalPrice,
                address,
                buildBookingNote(identityNumber, note));

        if (bookingID <= 0) {
            response.sendRedirect(detailUrl + "&status=bookingFail");
            return;
        }

        session.setAttribute("successMessage", "Dat phong thanh cong. Ma don: #" + bookingID);
        response.sendRedirect(detailUrl + "&status=bookingSuccess");
    }

    private boolean isValidIdentityNumber(String identityNumber) {
        return identityNumber.matches("^[0-9]{9}$|^[0-9]{12}$");
    }

    private String buildBookingNote(String identityNumber, String note) {
        StringBuilder builder = new StringBuilder("CCCD/CMND: ").append(identityNumber);

        if (!note.isEmpty()) {
            builder.append(" | Ghi chú: ").append(note);
        }

        return builder.toString();
    }

    private String buildBookingFormUrl(HttpServletRequest request, int accommodationID, int roomID,
                                       String checkIn, String checkOut, int adults, int children, int rooms) {
        return request.getContextPath()
                + "/booking/accommodation/form?accommodationID=" + accommodationID
                + "&roomID=" + roomID
                + "&checkIn=" + checkIn
                + "&checkOut=" + checkOut
                + "&adults=" + adults
                + "&children=" + children
                + "&rooms=" + rooms
                + "&guests=" + (adults + children);
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

    private String stripContextPath(String url, HttpServletRequest request) {
        String contextPath = request.getContextPath();

        if (contextPath != null && !contextPath.isEmpty() && url.startsWith(contextPath)) {
            return url.substring(contextPath.length());
        }

        return url;
    }
}
