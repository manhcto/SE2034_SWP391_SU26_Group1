package vn.edu.fpt.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.DAO.BookingDAO;
import vn.edu.fpt.model.Booking;
import vn.edu.fpt.model.User;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "BookingEditController", urlPatterns = {"/booking-edit"})
public class BookingEditController extends HttpServlet {

    private static final String EDIT_PAGE = "/views/customer/booking-edit.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        User currentUser = getCurrentUser(request);

        if (currentUser == null) {
            request.getSession().setAttribute(
                    "redirectAfterLogin",
                    request.getContextPath() + "/booking-list"
            );
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int bookingID = parsePositiveInt(request.getParameter("bookingID"));

        if (bookingID <= 0) {
            response.sendRedirect(request.getContextPath() + "/booking-list");
            return;
        }

        BookingDAO bookingDAO = new BookingDAO();
        Booking booking = bookingDAO.getBookingByID(bookingID);

        if (booking == null) {
            request.setAttribute("error", "Không tìm thấy đơn đặt chỗ cần sửa.");
            request.getRequestDispatcher(EDIT_PAGE).forward(request, response);
            return;
        }

        if (!isOwner(booking, currentUser)) {
            request.setAttribute("error", "Bạn không có quyền sửa đơn đặt chỗ này.");
            request.getRequestDispatcher(EDIT_PAGE).forward(request, response);
            return;
        }

        setAddressPartsToRequest(request, booking.getAddress());

        request.setAttribute("booking", booking);
        request.getRequestDispatcher(EDIT_PAGE).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        User currentUser = getCurrentUser(request);

        if (currentUser == null) {
            request.getSession().setAttribute(
                    "redirectAfterLogin",
                    request.getContextPath() + "/booking-list"
            );
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<String> errors = new ArrayList<>();

        int bookingID = parsePositiveInt(request.getParameter("bookingID"));

        BookingDAO bookingDAO = new BookingDAO();
        Booking oldBooking = null;

        if (bookingID <= 0) {
            errors.add("Mã đơn đặt chỗ không hợp lệ.");
        } else {
            oldBooking = bookingDAO.getBookingByID(bookingID);

            if (oldBooking == null) {
                errors.add("Đơn đặt chỗ không tồn tại trong hệ thống.");
            } else if (!isOwner(oldBooking, currentUser)) {
                errors.add("Bạn không có quyền sửa đơn đặt chỗ này.");
            }
        }

        String firstName = getTrimValue(request, "firstName");
        String lastName = getTrimValue(request, "lastName");
        String email = getTrimValue(request, "email");
        String phone = getTrimValue(request, "phone");

        String streetAddress = getTrimValue(request, "streetAddress");
        String district = getTrimValue(request, "district");
        String city = getTrimValue(request, "city");
        String addressParam = getTrimValue(request, "address");

        String note = getTrimValue(request, "note");
        String numberAdultRaw = getTrimValue(request, "numberAdult");
        String numberChildrenRaw = getTrimValue(request, "numberChildren");
        String isBookedForOtherRaw = getTrimValue(request, "isBookedForOther");

        int numberAdult = parseNumberWithMinValue(numberAdultRaw, "Số người lớn", 1, errors);
        int numberChildren = parseNumberWithMinValue(numberChildrenRaw, "Số trẻ em", 0, errors);

        String bookingType = oldBooking == null ? "" : safe(oldBooking.getBookingType());
        boolean isTourBooking = "Tour".equalsIgnoreCase(bookingType);

        String address;

        if (isTourBooking) {
            address = buildFullAddress(streetAddress, district, city);
            validateTourAddress(streetAddress, district, city, address, errors);
        } else {
            if (!addressParam.isEmpty()) {
                address = addressParam;
            } else if (!streetAddress.isEmpty() || !district.isEmpty() || !city.isEmpty()) {
                address = buildFullAddress(streetAddress, district, city);
            } else {
                address = oldBooking == null ? "" : safe(oldBooking.getAddress());
            }

            validateRequired(address, "Địa chỉ", errors);
            validateLength(address, "Địa chỉ", 255, errors);
        }

        validateCustomerInformation(firstName, lastName, email, phone, note, errors);

        boolean isBookedForOther = "true".equalsIgnoreCase(isBookedForOtherRaw)
                || "on".equalsIgnoreCase(isBookedForOtherRaw);

        Booking booking = new Booking();
        booking.setBookingID(bookingID);
        booking.setFirstName(firstName);
        booking.setLastName(lastName);
        booking.setEmail(email);
        booking.setPhone(phone);
        booking.setAddress(address);
        booking.setNote(note.isEmpty() ? null : note);
        booking.setNumberAdult(numberAdult);
        booking.setNumberChildren(numberChildren);
        booking.setBookedForOther(isBookedForOther);

        if (oldBooking != null) {
            booking.setBookingCode(oldBooking.getBookingCode());
            booking.setBookingType(oldBooking.getBookingType());
            booking.setUserID(oldBooking.getUserID());
            booking.setBookDate(oldBooking.getBookDate());
            booking.setStatus(oldBooking.getStatus());
            booking.setTotalPrice(oldBooking.getTotalPrice());
            booking.setVoucherID(oldBooking.getVoucherID());
        }

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("booking", booking);
            request.setAttribute("streetAddress", streetAddress);
            request.setAttribute("district", district);
            request.setAttribute("city", city);
            request.getRequestDispatcher(EDIT_PAGE).forward(request, response);
            return;
        }

        boolean updated;

        if (isTourBooking) {
            updated = bookingDAO.updateCustomerBooking(booking);
        } else {
            updated = bookingDAO.updateBooking(booking);
        }

        if (updated) {
            response.sendRedirect(request.getContextPath() + "/booking-summary?bookingID=" + bookingID);
        } else {
            errors.add("Cập nhật đơn đặt chỗ thất bại. Nếu đơn đã được xác nhận hoặc đã hoàn thành, vui lòng liên hệ nhân viên để được hỗ trợ.");

            request.setAttribute("errors", errors);
            request.setAttribute("booking", booking);
            request.setAttribute("streetAddress", streetAddress);
            request.setAttribute("district", district);
            request.setAttribute("city", city);
            request.getRequestDispatcher(EDIT_PAGE).forward(request, response);
        }
    }

    private User getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);

        if (session == null) {
            return null;
        }

        Object userObject = session.getAttribute("user");

        if (userObject instanceof User) {
            return (User) userObject;
        }

        return null;
    }

    private boolean isOwner(Booking booking, User currentUser) {
        if (booking == null || currentUser == null) {
            return false;
        }

        int bookingUserID = booking.getUserID();
        int currentUserID = currentUser.getUserID();

        if (bookingUserID > 0 && currentUserID > 0 && bookingUserID == currentUserID) {
            return true;
        }

        return bookingUserID <= 0
                && !safe(currentUser.getEmail()).isEmpty()
                && safe(currentUser.getEmail()).equalsIgnoreCase(safe(booking.getEmail()));
    }

    private void validateCustomerInformation(
            String firstName,
            String lastName,
            String email,
            String phone,
            String note,
            List<String> errors) {

        validateRequired(firstName, "Họ và tên đệm", errors);
        validateRequired(lastName, "Tên", errors);
        validateRequired(email, "Email", errors);
        validateRequired(phone, "Số điện thoại", errors);

        validateLength(firstName, "Họ và tên đệm", 100, errors);
        validateLength(lastName, "Tên", 100, errors);
        validateLength(email, "Email", 255, errors);
        validateLength(phone, "Số điện thoại", 10, errors);
        validateLength(note, "Ghi chú", 1000, errors);

        if (!firstName.isEmpty() && !firstName.matches("^[\\p{L}\\s]+$")) {
            errors.add("Họ và tên đệm chỉ được chứa chữ cái và khoảng trắng.");
        }

        if (!lastName.isEmpty() && !lastName.matches("^[\\p{L}\\s]+$")) {
            errors.add("Tên chỉ được chứa chữ cái và khoảng trắng.");
        }

        if (!email.isEmpty()
                && !email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
            errors.add("Email không đúng định dạng. Ví dụ đúng: example@gmail.com.");
        }

        if (!phone.isEmpty() && !phone.matches("^0\\d{9}$")) {
            errors.add("Số điện thoại phải có đúng 10 chữ số và bắt đầu bằng số 0.");
        }
    }

    private void validateTourAddress(
            String streetAddress,
            String district,
            String city,
            String address,
            List<String> errors) {

        validateRequired(streetAddress, "Số nhà, đường", errors);
        validateRequired(district, "Quận / Huyện", errors);
        validateRequired(city, "Tỉnh / Thành phố", errors);

        validateLength(streetAddress, "Số nhà, đường", 120, errors);
        validateLength(address, "Địa chỉ đầy đủ", 255, errors);

        if (!streetAddress.isEmpty() && !streetAddress.matches("^[\\p{L}0-9\\s,./-]+$")) {
            errors.add("Số nhà, đường chỉ được chứa chữ cái, số, khoảng trắng và các ký tự , . / -");
        }
    }

    private void validateRequired(String value, String fieldName, List<String> errors) {
        if (value == null || value.trim().isEmpty()) {
            errors.add(fieldName + " không được để trống.");
        }
    }

    private void validateLength(String value, String fieldName, int maxLength, List<String> errors) {
        if (value != null && value.length() > maxLength) {
            errors.add(fieldName + " không được vượt quá " + maxLength + " ký tự.");
        }
    }

    private int parsePositiveInt(String rawValue) {
        if (rawValue == null || rawValue.trim().isEmpty()) {
            return -1;
        }

        try {
            int value = Integer.parseInt(rawValue.trim());
            return value > 0 ? value : -1;
        } catch (NumberFormatException e) {
            return -1;
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

    private void setAddressPartsToRequest(HttpServletRequest request, String fullAddress) {
        String streetAddress = "";
        String district = "";
        String city = "";

        if (fullAddress != null && !fullAddress.trim().isEmpty()) {
            String[] parts = fullAddress.split(",");

            if (parts.length >= 3) {
                city = parts[parts.length - 1].trim();
                district = parts[parts.length - 2].trim();

                StringBuilder streetBuilder = new StringBuilder();

                for (int i = 0; i < parts.length - 2; i++) {
                    if (streetBuilder.length() > 0) {
                        streetBuilder.append(", ");
                    }

                    streetBuilder.append(parts[i].trim());
                }

                streetAddress = streetBuilder.toString();
            } else {
                streetAddress = fullAddress.trim();
            }
        }

        request.setAttribute("streetAddress", streetAddress);
        request.setAttribute("district", district);
        request.setAttribute("city", city);
    }

    private String buildFullAddress(String streetAddress, String district, String city) {
        StringBuilder address = new StringBuilder();

        if (!streetAddress.isEmpty()) {
            address.append(streetAddress);
        }

        if (!district.isEmpty()) {
            if (address.length() > 0) {
                address.append(", ");
            }

            address.append(district);
        }

        if (!city.isEmpty()) {
            if (address.length() > 0) {
                address.append(", ");
            }

            address.append(city);
        }

        return address.toString();
    }

    private String getTrimValue(HttpServletRequest request, String paramName) {
        String value = request.getParameter(paramName);
        return value == null ? "" : value.trim();
    }

    private String safe(String value) {
        return value == null ? "" : value.trim();
    }
}