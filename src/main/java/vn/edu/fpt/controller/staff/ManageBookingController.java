package vn.edu.fpt.controller.staff;

import vn.edu.fpt.DAO.BookingDAO;
import vn.edu.fpt.model.Booking;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "ManageBookingController", urlPatterns = {
        "/staff/booking",
        "/staff/booking-edit"
})
public class ManageBookingController extends HttpServlet {

    private static final String STAFF_BOOKING_LIST_PAGE = "/views/staff/staff-booking-list.jsp";
    private static final String STAFF_BOOKING_EDIT_PAGE = "/views/staff/staff-booking-edit.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String path = request.getServletPath();

        switch (path) {
            case "/staff/booking":
                showBookingList(request, response);
                break;

            case "/staff/booking-edit":
                showEditBookingForm(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/staff/booking");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String path = request.getServletPath();

        switch (path) {
            case "/staff/booking-edit":
                updateBooking(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/staff/booking");
                break;
        }
    }

    private void showBookingList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        BookingDAO bookingDAO = new BookingDAO();
        List<Booking> bookingList = bookingDAO.getAllBookings();

        request.setAttribute("bookingList", bookingList);
        request.getRequestDispatcher(STAFF_BOOKING_LIST_PAGE).forward(request, response);
    }

    private void showEditBookingForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String bookingIDRaw = request.getParameter("bookingID");

        if (bookingIDRaw == null || bookingIDRaw.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/staff/booking");
            return;
        }

        try {
            int bookingID = Integer.parseInt(bookingIDRaw.trim());

            BookingDAO bookingDAO = new BookingDAO();
            Booking booking = bookingDAO.getBookingByID(bookingID);

            if (booking == null) {
                request.setAttribute("error", "Không tìm thấy booking cần sửa.");
                request.getRequestDispatcher(STAFF_BOOKING_EDIT_PAGE).forward(request, response);
                return;
            }

            request.setAttribute("booking", booking);
            request.getRequestDispatcher(STAFF_BOOKING_EDIT_PAGE).forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/staff/booking");
        }
    }

    private void updateBooking(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<String> errors = new ArrayList<>();

        String bookingIDRaw = getTrimValue(request, "bookingID");
        String firstName = getTrimValue(request, "firstName");
        String lastName = getTrimValue(request, "lastName");
        String email = getTrimValue(request, "email");
        String phone = getTrimValue(request, "phone");
        String address = getTrimValue(request, "address");
        String note = getTrimValue(request, "note");
        String isBookedForOtherRaw = getTrimValue(request, "isBookedForOther");
        String status = getTrimValue(request, "status");

        int bookingID = parsePositiveInt(bookingIDRaw, "Booking ID", errors);

        validateRequired(firstName, "Tên", errors);
        validateRequired(lastName, "Họ", errors);
        validateRequired(email, "Email", errors);
        validateRequired(phone, "Số điện thoại", errors);
        validateRequired(address, "Địa chỉ", errors);

        validateLength(firstName, "Tên", 100, errors);
        validateLength(lastName, "Họ", 100, errors);
        validateLength(email, "Email", 150, errors);
        validateLength(phone, "Số điện thoại", 20, errors);
        validateLength(address, "Địa chỉ", 255, errors);
        validateLength(note, "Ghi chú", 1000, errors);

        if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {
            errors.add("Email không đúng định dạng.");
        }

        if (!phone.matches("\\d{9,11}")) {
            errors.add("Số điện thoại chỉ được nhập số và phải có từ 9 đến 11 chữ số.");
        }

        if (!isValidStatus(status)) {
            errors.add("Trạng thái booking không hợp lệ.");
        }

        BookingDAO bookingDAO = new BookingDAO();
        Booking oldBooking = null;

        if (bookingID > 0) {
            oldBooking = bookingDAO.getBookingByID(bookingID);

            if (oldBooking == null) {
                errors.add("Booking không tồn tại trong hệ thống.");
            }
        }

        Booking booking = new Booking();
        booking.setBookingID(bookingID);
        booking.setFirstName(firstName);
        booking.setLastName(lastName);
        booking.setEmail(email);
        booking.setPhone(phone);
        booking.setAddress(address);
        booking.setNote(note);
        booking.setBookedForOther("true".equals(isBookedForOtherRaw));
        booking.setStatus(status);

        if (oldBooking != null) {
            booking.setBookingCode(oldBooking.getBookingCode());
            booking.setBookingType(oldBooking.getBookingType());
            booking.setNumberAdult(oldBooking.getNumberAdult());
            booking.setNumberChildren(oldBooking.getNumberChildren());
            booking.setUserID(oldBooking.getUserID());
            booking.setBookDate(oldBooking.getBookDate());
            booking.setTotalPrice(oldBooking.getTotalPrice());
            booking.setVoucherID(oldBooking.getVoucherID());
        }

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("booking", booking);
            request.getRequestDispatcher(STAFF_BOOKING_EDIT_PAGE).forward(request, response);
            return;
        }

        boolean updated = bookingDAO.updateBooking(booking);

        if (updated) {
            response.sendRedirect(request.getContextPath() + "/staff/booking?success=updated");
        } else {
            errors.add("Cập nhật booking thất bại. Vui lòng thử lại.");

            request.setAttribute("errors", errors);
            request.setAttribute("booking", booking);
            request.getRequestDispatcher(STAFF_BOOKING_EDIT_PAGE).forward(request, response);
        }
    }

    private String getTrimValue(HttpServletRequest request, String paramName) {
        String value = request.getParameter(paramName);
        return value == null ? "" : value.trim();
    }

    private int parsePositiveInt(String rawValue, String fieldName, List<String> errors) {
        if (rawValue == null || rawValue.trim().isEmpty()) {
            errors.add(fieldName + " không được để trống.");
            return -1;
        }

        String valueText = rawValue.trim();

        if (!valueText.matches("\\d+")) {
            errors.add(fieldName + " chỉ được nhập số, không được nhập chữ hoặc ký tự đặc biệt.");
            return -1;
        }

        try {
            int value = Integer.parseInt(valueText);

            if (value <= 0) {
                errors.add(fieldName + " phải lớn hơn 0.");
                return -1;
            }

            return value;

        } catch (NumberFormatException e) {
            errors.add(fieldName + " không hợp lệ.");
            return -1;
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

    private boolean isValidStatus(String status) {
        return "Pending".equals(status)
                || "Confirmed".equals(status)
                || "Cancelled".equals(status)
                || "Completed".equals(status);
    }
}