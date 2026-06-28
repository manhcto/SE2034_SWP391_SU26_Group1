package vn.edu.fpt.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.DAO.AccommodationDAO;
import vn.edu.fpt.DAO.BookingDAO;
import vn.edu.fpt.DAO.RoomDAO;
import vn.edu.fpt.DAO.VehicleDAO;
import vn.edu.fpt.model.Accommodation;
import vn.edu.fpt.model.Booking;
import vn.edu.fpt.model.Room;
import vn.edu.fpt.model.User;
import vn.edu.fpt.model.Vehicle;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "BookingController", urlPatterns = {"/booking"})
public class BookingController extends HttpServlet {

    private final BookingDAO bookingDAO = new BookingDAO();
    private final VehicleDAO vehicleDAO = new VehicleDAO();
    private final AccommodationDAO accommodationDAO = new AccommodationDAO();
    private final RoomDAO roomDAO = new RoomDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String type = getTrimValue(request, "type");

        if ("vehicle".equalsIgnoreCase(type) || parsePositiveIntValue(request.getParameter("vehicleID")) > 0) {
            showVehicleBookingPage(request, response);
            return;
        }

        if ("accommodation".equalsIgnoreCase(type)
                || parsePositiveIntValue(request.getParameter("accommodationID")) > 0
                || parsePositiveIntValue(request.getParameter("roomID")) > 0) {
            showAccommodationBookingPage(request, response);
            return;
        }

        showTourBookingPage(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String type = getTrimValue(request, "type");
        String bookingType = getTrimValue(request, "bookingType");

        if ("vehicle".equalsIgnoreCase(type) || "Vehicle".equalsIgnoreCase(bookingType)) {
            handleVehicleBooking(request, response);
            return;
        }

        if ("accommodation".equalsIgnoreCase(type) || "Accommodation".equalsIgnoreCase(bookingType)) {
            response.sendRedirect(request.getContextPath() + "/booking/accommodation");
            return;
        }

        handleTourBooking(request, response);
    }

    private void showTourBookingPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("bookingMode", "tour");
        fillCustomerInfoFromSession(request);

        request.getRequestDispatcher("/views/customer/booking.jsp").forward(request, response);
    }

    private void handleTourBooking(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<String> errors = new ArrayList<>();

        try {
            String firstName = getTrimValue(request, "firstName");
            String lastName = getTrimValue(request, "lastName");
            String email = getTrimValue(request, "email");
            String phone = getTrimValue(request, "phone");

            String streetAddress = getTrimValue(request, "streetAddress");
            String district = getTrimValue(request, "district");
            String city = getTrimValue(request, "city");

            String note = getTrimValue(request, "note");
            String numberAdultRaw = getTrimValue(request, "numberAdult");
            String numberChildrenRaw = getTrimValue(request, "numberChildren");
            String tourScheduleIDRaw = getTrimValue(request, "tourScheduleID");
            String tourName = getTrimValue(request, "tourName");
            boolean isBookedForOther = request.getParameter("isBookedForOther") != null;

            validateName(firstName, "Họ và tên đệm", 2, errors);
            validateName(lastName, "Tên", 1, errors);
            validateEmail(email, errors);
            validatePhone(phone, errors);

            validateStreetAddress(streetAddress, errors);

            if (district.isEmpty()) {
                errors.add("Vui lòng chọn quận / huyện.");
            } else if (!isValidDistrict(district)) {
                errors.add("Quận / huyện không hợp lệ.");
            }

            if (city.isEmpty()) {
                errors.add("Vui lòng chọn tỉnh / thành phố.");
            } else if (!isValidCity(city)) {
                errors.add("Tỉnh / thành phố không hợp lệ.");
            }

            if (note.length() > 1000) {
                errors.add("Ghi chú không được vượt quá 1000 ký tự.");
            }

            int numberAdult = parseNumberWithMinValue(numberAdultRaw, "Số người lớn", 1, errors);
            int numberChildren = parseNumberWithMinValue(numberChildrenRaw, "Số trẻ em", 0, errors);
            int tourScheduleID = parseNumberWithMinValue(tourScheduleIDRaw, "Mã lịch trình tour", 1, errors);

            String address = "";

            if (!streetAddress.isEmpty() && !district.isEmpty() && !city.isEmpty()) {
                address = streetAddress + ", " + district + ", " + city;

                if (address.length() > 255) {
                    errors.add("Địa chỉ đầy đủ không được vượt quá 255 ký tự.");
                }
            }

            double adultPrice = 0;
            double childrenPrice = 0;
            double totalPrice = 0;
            double unitPriceForDetail = 0;

            if (errors.isEmpty()) {
                double[] prices = bookingDAO.getTourPricesBySchedule(tourScheduleID);

                if (prices == null) {
                    errors.add("Lịch trình tour không tồn tại. Vui lòng chọn lại tour.");
                } else {
                    adultPrice = prices[0];
                    childrenPrice = prices[1];

                    totalPrice = numberAdult * adultPrice + numberChildren * childrenPrice;

                    int totalQuantity = numberAdult + numberChildren;
                    unitPriceForDetail = totalQuantity > 0 ? totalPrice / totalQuantity : adultPrice;

                    if (totalPrice <= 0) {
                        errors.add("Tổng tiền không hợp lệ.");
                    }
                }
            }

            if (errors.isEmpty()) {
                int totalGuests = numberAdult + numberChildren;
                int remainingSeats = bookingDAO.getRemainingSeats(tourScheduleID);

                if (remainingSeats < 0) {
                    errors.add("Không thể kiểm tra số chỗ còn lại của tour.");
                } else if (totalGuests > remainingSeats) {
                    errors.add("Số khách đặt vượt quá số chỗ còn lại. Tour hiện chỉ còn " + remainingSeats + " chỗ.");
                }
            }

            if (!errors.isEmpty()) {
                request.setAttribute("bookingMode", "tour");
                request.setAttribute("errorList", errors);

                request.setAttribute("firstName", firstName);
                request.setAttribute("lastName", lastName);
                request.setAttribute("email", email);
                request.setAttribute("phone", phone);

                request.setAttribute("streetAddress", streetAddress);
                request.setAttribute("district", district);
                request.setAttribute("city", city);

                request.setAttribute("note", note);
                request.setAttribute("numberAdult", numberAdultRaw);
                request.setAttribute("numberChildren", numberChildrenRaw);
                request.setAttribute("tourScheduleID", tourScheduleIDRaw);
                request.setAttribute("tourName", tourName);
                request.setAttribute("isBookedForOther", isBookedForOther);

                request.getRequestDispatcher("/views/customer/booking.jsp").forward(request, response);
                return;
            }

            String bookingCode = "BK-" + System.currentTimeMillis() % 1000000;

            Booking booking = new Booking();
            booking.setBookingCode(bookingCode);
            booking.setBookingType("Tour");
            booking.setFirstName(firstName);
            booking.setLastName(lastName);
            booking.setEmail(email);
            booking.setPhone(phone);
            booking.setAddress(address);
            booking.setNote(note.isEmpty() ? null : note);
            booking.setNumberAdult(numberAdult);
            booking.setNumberChildren(numberChildren);
            booking.setTotalPrice(totalPrice);
            booking.setBookedForOther(isBookedForOther);

            HttpSession session = request.getSession(false);

            if (session != null && session.getAttribute("user") != null) {
                User currentUser = (User) session.getAttribute("user");
                booking.setUserID(currentUser.getUserID());
            }

            int bookingID = bookingDAO.insertBookingTransactionReturnID(
                    booking,
                    tourScheduleID,
                    unitPriceForDetail
            );

            if (bookingID > 0) {
                HttpSession currentSession = request.getSession();
                currentSession.setAttribute("successMessage", "Đặt tour thành công! Mã đơn: " + bookingCode);
                response.sendRedirect(request.getContextPath() + "/booking-summary?bookingID=" + bookingID);
                return;
            }

            request.setAttribute("bookingMode", "tour");
            request.setAttribute("error", "Không thể lưu đơn hàng. Có thể số chỗ vừa được người khác đặt hết. Vui lòng thử lại!");
            request.getRequestDispatcher("/views/customer/booking.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("bookingMode", "tour");
            request.setAttribute("error", "Đã xảy ra lỗi hệ thống nghiêm trọng!");
            request.getRequestDispatcher("/views/customer/booking.jsp").forward(request, response);
        }
    }

    private void showVehicleBookingPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int vehicleID = parsePositiveIntValue(request.getParameter("vehicleID"));

        if (vehicleID <= 0) {
            vehicleID = parsePositiveIntValue(request.getParameter("id"));
        }

        if (vehicleID <= 0) {
            response.sendRedirect(request.getContextPath() + "/vehicle");
            return;
        }

        Vehicle vehicle = vehicleDAO.getVehicleByIdForCustomer(vehicleID);

        if (vehicle == null) {
            response.sendRedirect(request.getContextPath() + "/vehicle?status=notFound");
            return;
        }

        prepareVehicleBookingPage(request, vehicle);
        fillCustomerInfoFromSession(request);

        request.getRequestDispatcher("/views/customer/booking.jsp").forward(request, response);
    }

    private void handleVehicleBooking(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<String> errors = new ArrayList<>();

        int vehicleID = parsePositiveIntValue(request.getParameter("vehicleID"));
        Vehicle vehicle = vehicleID > 0 ? vehicleDAO.getVehicleByIdForCustomer(vehicleID) : null;

        if (vehicle == null) {
            response.sendRedirect(request.getContextPath() + "/vehicle?status=notFound");
            return;
        }

        String firstName = getTrimValue(request, "firstName");
        String lastName = getTrimValue(request, "lastName");
        String email = getTrimValue(request, "email");
        String phone = getTrimValue(request, "phone");
        String address = getTrimValue(request, "address");
        String pickupDateRaw = getTrimValue(request, "pickupDate");
        String returnDateRaw = getTrimValue(request, "returnDate");
        String note = getTrimValue(request, "note");
        boolean isBookedForOther = request.getParameter("isBookedForOther") != null;

        validateName(firstName, "Họ và tên đệm", 2, errors);
        validateName(lastName, "Tên", 1, errors);
        validateEmail(email, errors);
        validatePhone(phone, errors);

        if (address.isEmpty()) {
            errors.add("Địa chỉ liên hệ không được để trống.");
        } else if (address.length() > 255) {
            errors.add("Địa chỉ liên hệ không được vượt quá 255 ký tự.");
        }

        if (note.length() > 1000) {
            errors.add("Ghi chú không được vượt quá 1000 ký tự.");
        }

        LocalDate pickupDate = null;
        LocalDate returnDate = null;
        int rentalDays = 0;

        if (pickupDateRaw.isEmpty()) {
            errors.add("Ngày nhận xe không được để trống.");
        } else {
            try {
                pickupDate = LocalDate.parse(pickupDateRaw);

                if (pickupDate.isBefore(LocalDate.now())) {
                    errors.add("Ngày nhận xe không được nhỏ hơn ngày hiện tại.");
                }

            } catch (Exception e) {
                errors.add("Ngày nhận xe không hợp lệ.");
            }
        }

        if (returnDateRaw.isEmpty()) {
            errors.add("Ngày trả xe không được để trống.");
        } else {
            try {
                returnDate = LocalDate.parse(returnDateRaw);
            } catch (Exception e) {
                errors.add("Ngày trả xe không hợp lệ.");
            }
        }

        if (pickupDate != null && returnDate != null) {
            if (!returnDate.isAfter(pickupDate)) {
                errors.add("Ngày trả xe phải sau ngày nhận xe.");
            } else {
                rentalDays = (int) ChronoUnit.DAYS.between(pickupDate, returnDate);
            }
        }

        if (!errors.isEmpty()) {
            prepareVehicleBookingPage(request, vehicle);
            keepVehicleBookingInput(request, firstName, lastName, email, phone, address,
                    pickupDateRaw, returnDateRaw, note, isBookedForOther);
            request.setAttribute("errorList", errors);
            request.getRequestDispatcher("/views/customer/booking.jsp").forward(request, response);
            return;
        }

        Booking booking = new Booking();
        booking.setBookingCode("VH-" + System.currentTimeMillis() % 1000000);
        booking.setBookingType("Vehicle");
        booking.setFirstName(firstName);
        booking.setLastName(lastName);
        booking.setEmail(email);
        booking.setPhone(phone);
        booking.setAddress(address);
        booking.setNote(note.isEmpty() ? null : note);
        booking.setNumberAdult(1);
        booking.setNumberChildren(0);
        booking.setBookedForOther(isBookedForOther);

        HttpSession session = request.getSession(false);

        if (session != null && session.getAttribute("user") != null) {
            User currentUser = (User) session.getAttribute("user");
            booking.setUserID(currentUser.getUserID());
        }

        int bookingID = bookingDAO.insertVehicleBookingTransactionReturnID(
                booking,
                vehicleID,
                Date.valueOf(pickupDate),
                Date.valueOf(returnDate),
                rentalDays
        );

        if (bookingID > 0) {
            HttpSession currentSession = request.getSession();
            currentSession.setAttribute("successMessage", "Đặt xe thành công! Mã đơn: " + booking.getBookingCode());
            response.sendRedirect(request.getContextPath() + "/booking-summary?bookingID=" + bookingID);
            return;
        }

        prepareVehicleBookingPage(request, vehicle);
        keepVehicleBookingInput(request, firstName, lastName, email, phone, address,
                pickupDateRaw, returnDateRaw, note, isBookedForOther);
        request.setAttribute("error", "Không thể đặt xe. Xe có thể vừa được khách khác đặt hoặc không còn khả dụng.");
        request.getRequestDispatcher("/views/customer/booking.jsp").forward(request, response);
    }

    private void showAccommodationBookingPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int accommodationID = parsePositiveIntValue(request.getParameter("accommodationID"));

        if (accommodationID <= 0) {
            accommodationID = parsePositiveIntValue(request.getParameter("accommodationId"));
        }

        int roomID = parsePositiveIntValue(request.getParameter("roomID"));

        if (roomID <= 0) {
            roomID = parsePositiveIntValue(request.getParameter("roomId"));
        }

        String checkIn = getTrimValue(request, "checkIn");
        String checkOut = getTrimValue(request, "checkOut");

        int adults = parsePositiveIntValue(request.getParameter("adults"));
        int children = parseNonNegativeIntValue(request.getParameter("children"));
        int rooms = parsePositiveIntValue(request.getParameter("rooms"));
        int guests = parsePositiveIntValue(request.getParameter("guests"));

        if (adults <= 0) {
            adults = 2;
        }

        if (children < 0) {
            children = 0;
        }

        if (rooms <= 0) {
            rooms = 1;
        }

        if (guests <= 0) {
            guests = adults + children;
        }

        if (accommodationID <= 0 || roomID <= 0) {
            response.sendRedirect(request.getContextPath() + "/accommodation");
            return;
        }

        if (checkIn.isEmpty() || checkOut.isEmpty()) {
            LocalDate today = LocalDate.now();
            checkIn = today.toString();
            checkOut = today.plusDays(1).toString();
        }

        Accommodation accommodation = accommodationDAO.getAccommodationByIdForCustomer(accommodationID);

        if (accommodation == null) {
            response.sendRedirect(request.getContextPath() + "/accommodation?status=notFound");
            return;
        }

        List<Room> roomList = roomDAO.getAvailableRoomsByAccommodationAndDate(accommodationID, checkIn, checkOut);
        Room selectedRoom = null;

        if (roomList != null) {
            for (Room room : roomList) {
                if (room.getRoomID() == roomID) {
                    selectedRoom = room;
                    break;
                }
            }
        }

        if (selectedRoom == null) {
            response.sendRedirect(request.getContextPath()
                    + "/accommodation/detail?id=" + accommodationID
                    + "&checkIn=" + checkIn
                    + "&checkOut=" + checkOut
                    + "&adults=" + adults
                    + "&children=" + children
                    + "&rooms=" + rooms
                    + "&guests=" + guests
                    + "&status=roomNotFound");
            return;
        }

        long nights = calculateNights(checkIn, checkOut);
        BigDecimal totalPrice = calculateTotalPrice(selectedRoom.getPriceOfRoom(), rooms, nights);

        request.setAttribute("bookingMode", "accommodation");

        request.setAttribute("accommodation", accommodation);
        request.setAttribute("room", selectedRoom);

        request.setAttribute("accommodationId", accommodationID);
        request.setAttribute("roomId", roomID);

        request.setAttribute("checkIn", checkIn);
        request.setAttribute("checkOut", checkOut);
        request.setAttribute("adults", adults);
        request.setAttribute("children", children);
        request.setAttribute("rooms", rooms);
        request.setAttribute("guests", guests);
        request.setAttribute("nights", nights);
        request.setAttribute("totalPrice", totalPrice);

        fillCustomerInfoFromSession(request);

        request.getRequestDispatcher("/views/customer/booking.jsp").forward(request, response);
    }

    private void prepareVehicleBookingPage(HttpServletRequest request, Vehicle vehicle) {
        LocalDate today = LocalDate.now();

        request.setAttribute("bookingMode", "vehicle");
        request.setAttribute("vehicle", vehicle);
        request.setAttribute("minPickupDate", today.toString());
        request.setAttribute("defaultPickupDate", today.toString());
        request.setAttribute("defaultReturnDate", today.plusDays(1).toString());
    }

    private void keepVehicleBookingInput(
            HttpServletRequest request,
            String firstName,
            String lastName,
            String email,
            String phone,
            String address,
            String pickupDate,
            String returnDate,
            String note,
            boolean isBookedForOther) {

        request.setAttribute("firstName", firstName);
        request.setAttribute("lastName", lastName);
        request.setAttribute("email", email);
        request.setAttribute("phone", phone);
        request.setAttribute("address", address);
        request.setAttribute("pickupDate", pickupDate);
        request.setAttribute("returnDate", returnDate);
        request.setAttribute("note", note);
        request.setAttribute("isBookedForOther", isBookedForOther);
    }

    private void fillCustomerInfoFromSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            return;
        }

        User user = (User) session.getAttribute("user");

        setAttributeIfNotBlank(request, "firstName", user.getFirstName());
        setAttributeIfNotBlank(request, "lastName", user.getLastName());
        setAttributeIfNotBlank(request, "email", user.getEmail());
        setAttributeIfNotBlank(request, "phone", user.getPhone());
        setAttributeIfNotBlank(request, "address", user.getAddress());
    }

    private void setAttributeIfNotBlank(HttpServletRequest request, String name, String value) {
        if (request.getAttribute(name) == null && value != null && !value.trim().isEmpty()) {
            request.setAttribute(name, value.trim());
        }
    }

    private int parsePositiveIntValue(String value) {
        try {
            int number = Integer.parseInt(value);
            return number > 0 ? number : 0;
        } catch (Exception e) {
            return 0;
        }
    }

    private int parseNonNegativeIntValue(String value) {
        try {
            int number = Integer.parseInt(value);
            return Math.max(number, 0);
        } catch (Exception e) {
            return 0;
        }
    }

    private int parseNumberWithMinValue(String rawValue, String fieldName, int minValue, List<String> errors) {
        if (rawValue == null || rawValue.trim().isEmpty()) {
            errors.add(fieldName + " không được để trống.");
            return 0;
        }

        String valueText = rawValue.trim();

        if (!valueText.matches("\\d+")) {
            errors.add(fieldName + " chỉ được nhập số tự nhiên.");
            return 0;
        }

        try {
            int value = Integer.parseInt(valueText);

            if (value < minValue) {
                errors.add(fieldName + " phải lớn hơn hoặc bằng " + minValue + ".");
                return 0;
            }

            return value;

        } catch (NumberFormatException e) {
            errors.add(fieldName + " không hợp lệ.");
            return 0;
        }
    }

    private String getTrimValue(HttpServletRequest request, String paramName) {
        String value = request.getParameter(paramName);
        return value == null ? "" : value.trim();
    }

    private void validateName(String value, String fieldName, int minLength, List<String> errors) {
        if (value.isEmpty()) {
            errors.add(fieldName + " không được để trống.");
            return;
        }

        if (value.length() < minLength) {
            errors.add(fieldName + " phải có ít nhất " + minLength + " ký tự.");
            return;
        }

        if (value.length() > 100) {
            errors.add(fieldName + " không được vượt quá 100 ký tự.");
            return;
        }

        if (!value.matches("^[\\p{L}\\s]+$")) {
            errors.add(fieldName + " chỉ được chứa chữ cái và khoảng trắng.");
        }
    }

    private void validateEmail(String email, List<String> errors) {
        if (email.isEmpty()) {
            errors.add("Email không được để trống.");
            return;
        }

        if (email.length() > 255) {
            errors.add("Email không được vượt quá 255 ký tự.");
            return;
        }

        if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
            errors.add("Email không đúng định dạng. Ví dụ: example@gmail.com.");
        }
    }

    private void validatePhone(String phone, List<String> errors) {
        if (phone.isEmpty()) {
            errors.add("Số điện thoại không được để trống.");
            return;
        }

        if (!phone.matches("^0\\d{9}$")) {
            errors.add("Số điện thoại phải có đúng 10 chữ số và bắt đầu bằng số 0.");
        }
    }

    private void validateStreetAddress(String streetAddress, List<String> errors) {
        if (streetAddress.isEmpty()) {
            errors.add("Số nhà, đường không được để trống.");
            return;
        }

        if (streetAddress.length() > 120) {
            errors.add("Số nhà, đường không được vượt quá 120 ký tự.");
            return;
        }

        if (!streetAddress.matches("^[\\p{L}0-9\\s,./-]+$")) {
            errors.add("Số nhà, đường chỉ được chứa chữ cái, số, khoảng trắng và các ký tự , . / -");
        }
    }

    private long calculateNights(String checkIn, String checkOut) {
        try {
            LocalDate start = LocalDate.parse(checkIn);
            LocalDate end = LocalDate.parse(checkOut);

            long nights = ChronoUnit.DAYS.between(start, end);
            return nights > 0 ? nights : 1;

        } catch (Exception e) {
            return 1;
        }
    }

    private BigDecimal calculateTotalPrice(BigDecimal roomPrice, int rooms, long nights) {
        if (roomPrice == null) {
            roomPrice = BigDecimal.ZERO;
        }

        if (rooms <= 0) {
            rooms = 1;
        }

        if (nights <= 0) {
            nights = 1;
        }

        return roomPrice
                .multiply(BigDecimal.valueOf(rooms))
                .multiply(BigDecimal.valueOf(nights));
    }

    private boolean isValidDistrict(String district) {
        return "Quận Ba Đình".equals(district)
                || "Quận Hoàn Kiếm".equals(district)
                || "Quận Tây Hồ".equals(district)
                || "Quận Long Biên".equals(district)
                || "Quận Cầu Giấy".equals(district)
                || "Quận Đống Đa".equals(district)
                || "Quận Hai Bà Trưng".equals(district)
                || "Quận Hoàng Mai".equals(district)
                || "Quận Thanh Xuân".equals(district)
                || "Quận Nam Từ Liêm".equals(district)
                || "Quận Bắc Từ Liêm".equals(district)
                || "Quận Hà Đông".equals(district)
                || "Huyện Thanh Trì".equals(district)
                || "Huyện Gia Lâm".equals(district)
                || "Huyện Đông Anh".equals(district)
                || "Huyện Sóc Sơn".equals(district);
    }

    private boolean isValidCity(String city) {
        return "Hà Nội".equals(city)
                || "Hồ Chí Minh".equals(city)
                || "Đà Nẵng".equals(city)
                || "Hải Phòng".equals(city)
                || "Cần Thơ".equals(city)
                || "Quảng Ninh".equals(city)
                || "Ninh Bình".equals(city)
                || "Huế".equals(city)
                || "Khánh Hòa".equals(city)
                || "Lâm Đồng".equals(city);
    }
}