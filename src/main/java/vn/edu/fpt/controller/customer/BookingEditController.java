package vn.edu.fpt.controller.customer;

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

@WebServlet(name = "BookingEditController", urlPatterns = {"/booking-edit"})
public class BookingEditController extends HttpServlet {

    private static final String EDIT_PAGE = "/views/customer/booking-edit.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String bookingIDRaw = request.getParameter("bookingID");

        if (bookingIDRaw == null || bookingIDRaw.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/booking-list");
            return;
        }

        try {
            int bookingID = Integer.parseInt(bookingIDRaw);

            BookingDAO bookingDAO = new BookingDAO();
            Booking booking = bookingDAO.getBookingByID(bookingID);

            if (booking == null) {
                request.setAttribute("error", "Không tìm thấy booking cần sửa.");
                request.getRequestDispatcher(EDIT_PAGE).forward(request, response);
                return;
            }

            request.setAttribute("booking", booking);
            request.getRequestDispatcher(EDIT_PAGE).forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/booking-list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        List<String> errors = new ArrayList<>();

        String bookingIDRaw = request.getParameter("bookingID");
        String firstName = getTrimValue(request, "firstName");
        String lastName = getTrimValue(request, "lastName");
        String email = getTrimValue(request, "email");
        String phone = getTrimValue(request, "phone");
        String address = getTrimValue(request, "address");
        String note = getTrimValue(request, "note");
        String isBookedForOtherRaw = request.getParameter("isBookedForOther");
        String status = getTrimValue(request, "status");

        int bookingID = parseBookingID(bookingIDRaw, errors);

        validateBookingForm(firstName, lastName, email, phone, address, note, status, errors);

        BookingDAO bookingDAO = new BookingDAO();
        Booking oldBooking = null;

        if (bookingID > 0) {
            oldBooking = bookingDAO.getBookingByID(bookingID);

            if (oldBooking == null) {
                errors.add("Booking không tồn tại trong hệ thống.");
            }
        }

        boolean isBookedForOther = "on".equalsIgnoreCase(isBookedForOtherRaw)
                || "true".equalsIgnoreCase(isBookedForOtherRaw);

        Booking booking = new Booking();
        booking.setBookingID(bookingID);
        booking.setFirstName(firstName);
        booking.setLastName(lastName);
        booking.setEmail(email);
        booking.setPhone(phone);
        booking.setAddress(address);
        booking.setNote(note);
        booking.setBookedForOther(isBookedForOther);
        booking.setStatus(status);

        if (!errors.isEmpty()) {
            if (oldBooking != null) {
                booking.setBookingCode(oldBooking.getBookingCode());
                booking.setBookingType(oldBooking.getBookingType());
                booking.setNumberAdult(oldBooking.getNumberAdult());
                booking.setNumberChildren(oldBooking.getNumberChildren());
                booking.setBookDate(oldBooking.getBookDate());
                booking.setTotalPrice(oldBooking.getTotalPrice());
            }

            request.setAttribute("errors", errors);
            request.setAttribute("booking", booking);
            request.getRequestDispatcher(EDIT_PAGE).forward(request, response);
            return;
        }

        boolean updated = bookingDAO.updateBooking(booking);

        if (updated) {
            response.sendRedirect(request.getContextPath() + "/booking-summary?bookingID=" + bookingID);
        } else {
            errors.add("Cập nhật booking thất bại. Vui lòng thử lại.");

            request.setAttribute("errors", errors);
            request.setAttribute("booking", booking);
            request.getRequestDispatcher(EDIT_PAGE).forward(request, response);
        }
    }

    private String getTrimValue(HttpServletRequest request, String paramName) {
        String value = request.getParameter(paramName);
        return value == null ? "" : value.trim();
    }

    private int parseBookingID(String bookingIDRaw, List<String> errors) {
        if (bookingIDRaw == null || bookingIDRaw.trim().isEmpty()) {
            errors.add("Thiếu mã booking cần sửa.");
            return -1;
        }

        try {
            int bookingID = Integer.parseInt(bookingIDRaw.trim());

            if (bookingID <= 0) {
                errors.add("Mã booking không hợp lệ.");
                return -1;
            }

            return bookingID;

        } catch (NumberFormatException e) {
            errors.add("Mã booking phải là số.");
            return -1;
        }
    }

    private void validateBookingForm(String firstName, String lastName, String email,
                                     String phone, String address, String note,
                                     String status, List<String> errors) {

        if (firstName.isEmpty()) {
            errors.add("Vui lòng nhập họ.");
        } else if (firstName.length() > 100) {
            errors.add("Họ không được vượt quá 100 ký tự.");
        }

        if (lastName.isEmpty()) {
            errors.add("Vui lòng nhập tên.");
        } else if (lastName.length() > 100) {
            errors.add("Tên không được vượt quá 100 ký tự.");
        }

        if (email.isEmpty()) {
            errors.add("Vui lòng nhập email.");
        } else if (email.length() > 255) {
            errors.add("Email không được vượt quá 255 ký tự.");
        } else if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {
            errors.add("Email không đúng định dạng.");
        }

        if (phone.isEmpty()) {
            errors.add("Vui lòng nhập số điện thoại.");
        } else if (!phone.matches("^0\\d{9}$")) {
            errors.add("Số điện thoại phải có 10 chữ số và bắt đầu bằng 0.");
        }

        if (address.length() > 255) {
            errors.add("Địa chỉ không được vượt quá 255 ký tự.");
        }

        if (note.length() > 1000) {
            errors.add("Ghi chú không được vượt quá 1000 ký tự.");
        }

        if (!isValidStatus(status)) {
            errors.add("Trạng thái booking không hợp lệ.");
        }
    }

    private boolean isValidStatus(String status) {
        return "Pending".equals(status)
                || "Confirmed".equals(status)
                || "Cancelled".equals(status)
                || "Completed".equals(status);
    }
}