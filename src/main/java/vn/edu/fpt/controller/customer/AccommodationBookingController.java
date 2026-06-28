package vn.edu.fpt.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.DAO.AccommodationDAO;
import vn.edu.fpt.DAO.RoomDAO;
import vn.edu.fpt.common.DBConnection;
import vn.edu.fpt.model.Accommodation;
import vn.edu.fpt.model.Booking;
import vn.edu.fpt.model.Room;
import vn.edu.fpt.model.User;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Date;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;

@WebServlet(name = "AccommodationBookingController", urlPatterns = {"/booking/accommodation"})
public class AccommodationBookingController extends HttpServlet {

    private final AccommodationDAO accommodationDAO = new AccommodationDAO();
    private final RoomDAO roomDAO = new RoomDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String accommodationID = getTrimValue(request, "accommodationID");
        String roomID = getTrimValue(request, "roomID");
        String checkIn = getTrimValue(request, "checkIn");
        String checkOut = getTrimValue(request, "checkOut");
        String adults = getTrimValue(request, "adults");
        String children = getTrimValue(request, "children");
        String rooms = getTrimValue(request, "rooms");
        String guests = getTrimValue(request, "guests");

        if (accommodationID.isEmpty() || roomID.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/accommodation");
            return;
        }

        String redirectUrl = request.getContextPath()
                + "/booking?type=accommodation"
                + "&accommodationID=" + accommodationID
                + "&roomID=" + roomID
                + "&checkIn=" + checkIn
                + "&checkOut=" + checkOut
                + "&adults=" + adults
                + "&children=" + children
                + "&rooms=" + rooms
                + "&guests=" + guests;

        response.sendRedirect(redirectUrl);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        int accommodationID = parsePositiveInt(request.getParameter("accommodationID"));
        int roomID = parsePositiveInt(request.getParameter("roomID"));

        String checkInRaw = getTrimValue(request, "checkIn");
        String checkOutRaw = getTrimValue(request, "checkOut");

        int adults = parsePositiveInt(request.getParameter("adults"));
        int children = parseNonNegativeInt(request.getParameter("children"));
        int rooms = parsePositiveInt(request.getParameter("rooms"));
        int guests = parsePositiveInt(request.getParameter("guests"));

        String firstName = getTrimValue(request, "firstName");
        String lastName = getTrimValue(request, "lastName");
        String email = getTrimValue(request, "email");
        String phone = getTrimValue(request, "phone");
        String identityNumber = getTrimValue(request, "identityNumber");
        String address = getTrimValue(request, "address");
        String note = getTrimValue(request, "note");
        boolean isBookedForOther = request.getParameter("isBookedForOther") != null;

        String bookingPageUrl = buildBookingPageUrl(
                request,
                accommodationID,
                roomID,
                checkInRaw,
                checkOutRaw,
                adults,
                children,
                rooms,
                guests
        );

        HttpSession session = request.getSession();

        if (session.getAttribute("user") == null) {
            session.setAttribute("redirectAfterLogin", bookingPageUrl);
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (!isValidCustomerInfo(firstName, lastName, email, phone, identityNumber, address, note)
                || accommodationID <= 0
                || roomID <= 0
                || adults <= 0
                || children < 0
                || rooms <= 0
                || guests <= 0
                || !isValidDateRange(checkInRaw, checkOutRaw)) {

            response.sendRedirect(bookingPageUrl + "&status=invalidCustomerInfo");
            return;
        }

        Accommodation accommodation = accommodationDAO.getAccommodationByIdForCustomer(accommodationID);

        if (accommodation == null) {
            response.sendRedirect(request.getContextPath() + "/accommodation?status=notFound");
            return;
        }

        List<Room> availableRooms = roomDAO.getAvailableRoomsByAccommodationAndDate(
                accommodationID,
                checkInRaw,
                checkOutRaw
        );

        Room selectedRoom = findSelectedRoom(availableRooms, roomID);

        if (selectedRoom == null) {
            response.sendRedirect(request.getContextPath()
                    + "/accommodation/detail?id=" + accommodationID
                    + "&checkIn=" + checkInRaw
                    + "&checkOut=" + checkOutRaw
                    + "&adults=" + adults
                    + "&children=" + children
                    + "&rooms=" + rooms
                    + "&guests=" + guests
                    + "&status=roomUnavailable");
            return;
        }

        if (selectedRoom.getRoomAvailability() < rooms) {
            response.sendRedirect(request.getContextPath()
                    + "/accommodation/room/detail?id=" + roomID
                    + "&accommodationId=" + accommodationID
                    + "&checkIn=" + checkInRaw
                    + "&checkOut=" + checkOutRaw
                    + "&adults=" + adults
                    + "&children=" + children
                    + "&rooms=" + rooms
                    + "&guests=" + guests
                    + "&status=roomUnavailable");
            return;
        }

        long nights = calculateNights(checkInRaw, checkOutRaw);
        BigDecimal unitPrice = selectedRoom.getPriceOfRoom() == null
                ? BigDecimal.ZERO
                : selectedRoom.getPriceOfRoom();

        BigDecimal totalPrice = unitPrice
                .multiply(BigDecimal.valueOf(rooms))
                .multiply(BigDecimal.valueOf(nights));

        if (totalPrice.compareTo(BigDecimal.ZERO) <= 0) {
            response.sendRedirect(bookingPageUrl + "&status=invalidBooking");
            return;
        }

        User currentUser = (User) session.getAttribute("user");

        Booking booking = new Booking();
        booking.setBookingCode("AC-" + System.currentTimeMillis() % 1000000);
        booking.setBookingType("Accommodation");
        booking.setFirstName(firstName);
        booking.setLastName(lastName);
        booking.setEmail(email);
        booking.setPhone(phone);
        booking.setAddress(address);
        booking.setNote(buildAccommodationNote(identityNumber, note));
        booking.setNumberAdult(adults);
        booking.setNumberChildren(children);
        booking.setTotalPrice(totalPrice.doubleValue());
        booking.setBookedForOther(isBookedForOther);

        if (currentUser != null) {
            booking.setUserID(currentUser.getUserID());
        }

        int bookingID = insertAccommodationBookingTransactionReturnID(
                booking,
                accommodationID,
                roomID,
                rooms,
                unitPrice,
                totalPrice,
                Date.valueOf(checkInRaw),
                Date.valueOf(checkOutRaw),
                nights
        );

        if (bookingID > 0) {
            session.setAttribute("successMessage", "Đặt phòng thành công! Mã đơn: " + booking.getBookingCode());
            response.sendRedirect(request.getContextPath() + "/booking-summary?bookingID=" + bookingID);
            return;
        }

        response.sendRedirect(request.getContextPath()
                + "/accommodation/room/detail?id=" + roomID
                + "&accommodationId=" + accommodationID
                + "&checkIn=" + checkInRaw
                + "&checkOut=" + checkOutRaw
                + "&adults=" + adults
                + "&children=" + children
                + "&rooms=" + rooms
                + "&guests=" + guests
                + "&status=bookingFailed");
    }

    private int insertAccommodationBookingTransactionReturnID(
            Booking booking,
            int accommodationID,
            int roomID,
            int roomQuantity,
            BigDecimal unitPrice,
            BigDecimal totalPrice,
            Date checkIn,
            Date checkOut,
            long nights) {

        String sqlCheckRoom =
                "SELECT r.roomID, r.roomAvailability, r.priceOfRoom "
                        + "FROM [dbo].[Room] r "
                        + "JOIN [dbo].[Accommodation] a ON r.serviceID = a.serviceID "
                        + "JOIN [dbo].[Service] s ON a.serviceID = s.serviceID "
                        + "WHERE r.roomID = ? "
                        + "AND a.serviceID = ? "
                        + "AND s.[status] = N'Active' "
                        + "AND a.[status] = N'Available' "
                        + "AND r.[status] = N'Available'";

        String sqlBooking =
                "INSERT INTO [dbo].[Booking] "
                        + "(bookingCode, bookingType, firstName, lastName, email, phone, [address], note, "
                        + "numberAdult, numberChildren, totalPrice, isBookedForOther, userID, [status], bookDate) "
                        + "VALUES (?, N'Accommodation', ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, N'Confirmed', GETDATE())";

        String sqlDetail =
                "INSERT INTO [dbo].[Booking_Detail] "
                        + "(bookingID, serviceID, quantity, unitPrice, subTotal, startDate, endDate, note) "
                        + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = new DBConnection().getConnection()) {
            conn.setAutoCommit(false);

            try {
                try (PreparedStatement psCheckRoom = conn.prepareStatement(sqlCheckRoom)) {
                    psCheckRoom.setInt(1, roomID);
                    psCheckRoom.setInt(2, accommodationID);

                    try (ResultSet rs = psCheckRoom.executeQuery()) {
                        if (!rs.next()) {
                            conn.rollback();
                            return -1;
                        }

                        int currentAvailability = rs.getInt("roomAvailability");

                        if (currentAvailability < roomQuantity) {
                            conn.rollback();
                            return -1;
                        }
                    }
                }

                int generatedBookingID;

                try (PreparedStatement psBooking =
                             conn.prepareStatement(sqlBooking, Statement.RETURN_GENERATED_KEYS)) {

                    psBooking.setString(1, booking.getBookingCode());
                    psBooking.setString(2, booking.getFirstName());
                    psBooking.setString(3, booking.getLastName());
                    psBooking.setString(4, booking.getEmail());
                    psBooking.setString(5, booking.getPhone());
                    psBooking.setString(6, booking.getAddress());
                    psBooking.setString(7, booking.getNote());
                    psBooking.setInt(8, booking.getNumberAdult());
                    psBooking.setInt(9, booking.getNumberChildren());
                    psBooking.setDouble(10, totalPrice.doubleValue());
                    psBooking.setBoolean(11, booking.isBookedForOther());

                    if (booking.getUserID() != null) {
                        psBooking.setInt(12, booking.getUserID());
                    } else {
                        psBooking.setNull(12, java.sql.Types.INTEGER);
                    }

                    if (psBooking.executeUpdate() == 0) {
                        conn.rollback();
                        return -1;
                    }

                    try (ResultSet generatedKeys = psBooking.getGeneratedKeys()) {
                        if (!generatedKeys.next()) {
                            conn.rollback();
                            return -1;
                        }

                        generatedBookingID = generatedKeys.getInt(1);
                    }
                }

                String detailNote = "roomID=" + roomID + "; nights=" + nights;

                try (PreparedStatement psDetail = conn.prepareStatement(sqlDetail)) {
                    psDetail.setInt(1, generatedBookingID);
                    psDetail.setInt(2, accommodationID);
                    psDetail.setInt(3, roomQuantity);
                    psDetail.setDouble(4, unitPrice.doubleValue());
                    psDetail.setDouble(5, totalPrice.doubleValue());
                    psDetail.setDate(6, checkIn);
                    psDetail.setDate(7, checkOut);
                    psDetail.setString(8, detailNote);
                    psDetail.executeUpdate();
                }

                conn.commit();
                return generatedBookingID;

            } catch (Exception e) {
                conn.rollback();
                System.out.println("Lỗi transaction đặt phòng, đã rollback dữ liệu: " + e.getMessage());
                e.printStackTrace();
            } finally {
                conn.setAutoCommit(true);
            }

        } catch (Exception e) {
            System.out.println("Lỗi kết nối hoặc xử lý đặt phòng: " + e.getMessage());
            e.printStackTrace();
        }

        return -1;
    }

    private Room findSelectedRoom(List<Room> roomList, int roomID) {
        if (roomList == null) {
            return null;
        }

        for (Room room : roomList) {
            if (room.getRoomID() == roomID) {
                return room;
            }
        }

        return null;
    }

    private String buildBookingPageUrl(
            HttpServletRequest request,
            int accommodationID,
            int roomID,
            String checkIn,
            String checkOut,
            int adults,
            int children,
            int rooms,
            int guests) {

        return request.getContextPath()
                + "/booking?type=accommodation"
                + "&accommodationID=" + accommodationID
                + "&roomID=" + roomID
                + "&checkIn=" + checkIn
                + "&checkOut=" + checkOut
                + "&adults=" + adults
                + "&children=" + children
                + "&rooms=" + rooms
                + "&guests=" + guests;
    }

    private boolean isValidCustomerInfo(
            String firstName,
            String lastName,
            String email,
            String phone,
            String identityNumber,
            String address,
            String note) {

        if (firstName.isEmpty()
                || lastName.isEmpty()
                || email.isEmpty()
                || phone.isEmpty()
                || identityNumber.isEmpty()
                || address.isEmpty()) {
            return false;
        }

        if (firstName.length() < 2 || firstName.length() > 100) {
            return false;
        }

        if (lastName.length() < 1 || lastName.length() > 100) {
            return false;
        }

        if (!firstName.matches("^[\\p{L}\\s]+$")) {
            return false;
        }

        if (!lastName.matches("^[\\p{L}\\s]+$")) {
            return false;
        }

        if (email.length() > 255
                || !email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
            return false;
        }

        if (!phone.matches("^0\\d{9}$")) {
            return false;
        }

        if (!identityNumber.matches("^(\\d{9}|\\d{12})$")) {
            return false;
        }

        if (address.length() > 255) {
            return false;
        }

        return note.length() <= 1000;
    }

    private boolean isValidDateRange(String checkInRaw, String checkOutRaw) {
        if (checkInRaw.isEmpty() || checkOutRaw.isEmpty()) {
            return false;
        }

        try {
            LocalDate checkIn = LocalDate.parse(checkInRaw);
            LocalDate checkOut = LocalDate.parse(checkOutRaw);

            return !checkIn.isBefore(LocalDate.now()) && checkOut.isAfter(checkIn);

        } catch (Exception e) {
            return false;
        }
    }

    private long calculateNights(String checkInRaw, String checkOutRaw) {
        try {
            LocalDate checkIn = LocalDate.parse(checkInRaw);
            LocalDate checkOut = LocalDate.parse(checkOutRaw);

            long nights = ChronoUnit.DAYS.between(checkIn, checkOut);
            return nights > 0 ? nights : 1;

        } catch (Exception e) {
            return 1;
        }
    }

    private String buildAccommodationNote(String identityNumber, String note) {
        StringBuilder builder = new StringBuilder();

        builder.append("CCCD/CMND: ").append(identityNumber);

        if (note != null && !note.trim().isEmpty()) {
            builder.append("\nGhi chú: ").append(note.trim());
        }

        return builder.toString();
    }

    private int parsePositiveInt(String rawValue) {
        try {
            int value = Integer.parseInt(rawValue);
            return value > 0 ? value : 0;
        } catch (Exception e) {
            return 0;
        }
    }

    private int parseNonNegativeInt(String rawValue) {
        try {
            int value = Integer.parseInt(rawValue);
            return Math.max(value, 0);
        } catch (Exception e) {
            return 0;
        }
    }

    private String getTrimValue(HttpServletRequest request, String paramName) {
        String value = request.getParameter(paramName);
        return value == null ? "" : value.trim();
    }
}