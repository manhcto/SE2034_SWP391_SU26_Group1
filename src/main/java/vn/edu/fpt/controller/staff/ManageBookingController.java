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
        "/staff/booking-edit",
        "/staff/booking-delete",
        "/staff/booking-cancel",
        "/staff/booking-complete"
})
public class ManageBookingController extends HttpServlet {

    private static final String STAFF_BOOKING_LIST_PAGE = "/views/staff/staff-booking-list.jsp";

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
                redirectToBookingList(request, response);
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
            case "/staff/booking-delete":
            case "/staff/booking-cancel":
                cancelBooking(request, response);
                break;

            case "/staff/booking-complete":
                completeBooking(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/staff/booking");
                break;
        }
    }

    private void showBookingList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String selectedBookingType = normalizeBookingType(request.getParameter("type"));

        BookingDAO bookingDAO = new BookingDAO();
        List<Booking> allBookings = bookingDAO.getAllBookings();
        List<Booking> bookingList = filterBookingsByType(allBookings, selectedBookingType);

        int activeBookingCount;
        int cancelledBookingCount;
        int completedBookingCount;

        if (selectedBookingType.isEmpty()) {
            activeBookingCount = bookingDAO.countBookingsByStatus("Confirmed");
            cancelledBookingCount = bookingDAO.countBookingsByStatus("Cancelled");
            completedBookingCount = bookingDAO.countBookingsByStatus("Completed");
        } else {
            activeBookingCount = bookingDAO.countBookingsByTypeAndStatus(selectedBookingType, "Confirmed");
            cancelledBookingCount = bookingDAO.countBookingsByTypeAndStatus(selectedBookingType, "Cancelled");
            completedBookingCount = bookingDAO.countBookingsByTypeAndStatus(selectedBookingType, "Completed");
        }

        request.setAttribute("bookingList", bookingList);
        request.setAttribute("selectedBookingType", selectedBookingType);
        request.setAttribute("bookingPageTitle", getBookingPageTitle(selectedBookingType));
        request.setAttribute("bookingPageSubtitle", getBookingPageSubtitle(selectedBookingType));

        request.setAttribute("activeBookingCount", activeBookingCount);
        request.setAttribute("cancelledBookingCount", cancelledBookingCount);
        request.setAttribute("completedBookingCount", completedBookingCount);

        request.getRequestDispatcher(STAFF_BOOKING_LIST_PAGE).forward(request, response);
    }

    private void cancelBooking(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        List<String> errors = new ArrayList<>();

        String selectedBookingType = normalizeBookingType(request.getParameter("type"));
        String bookingIDRaw = getTrimValue(request, "bookingID");

        int bookingID = parsePositiveInt(bookingIDRaw, "Booking ID", errors);

        if (!errors.isEmpty()) {
            response.sendRedirect(request.getContextPath()
                    + buildBookingListPathWithMessage(selectedBookingType, "error", "cancelFailed"));
            return;
        }

        BookingDAO bookingDAO = new BookingDAO();
        boolean cancelled = bookingDAO.cancelBookingByID(bookingID);

        if (cancelled) {
            response.sendRedirect(request.getContextPath()
                    + buildBookingListPathWithMessage(selectedBookingType, "success", "cancelled"));
        } else {
            response.sendRedirect(request.getContextPath()
                    + buildBookingListPathWithMessage(selectedBookingType, "error", "cancelFailed"));
        }
    }

    private void completeBooking(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        List<String> errors = new ArrayList<>();

        String selectedBookingType = normalizeBookingType(request.getParameter("type"));
        String bookingIDRaw = getTrimValue(request, "bookingID");

        int bookingID = parsePositiveInt(bookingIDRaw, "Booking ID", errors);

        if (!errors.isEmpty()) {
            response.sendRedirect(request.getContextPath()
                    + buildBookingListPathWithMessage(selectedBookingType, "error", "completeFailed"));
            return;
        }

        BookingDAO bookingDAO = new BookingDAO();
        boolean completed = bookingDAO.completeBookingByID(bookingID);

        if (completed) {
            response.sendRedirect(request.getContextPath()
                    + buildBookingListPathWithMessage(selectedBookingType, "success", "completed"));
        } else {
            response.sendRedirect(request.getContextPath()
                    + buildBookingListPathWithMessage(selectedBookingType, "error", "completeFailed"));
        }
    }

    private void redirectToBookingList(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String selectedBookingType = normalizeBookingType(request.getParameter("type"));
        response.sendRedirect(request.getContextPath() + buildBookingListPath(selectedBookingType));
    }

    private List<Booking> filterBookingsByType(List<Booking> allBookings, String bookingType) {
        if (bookingType == null || bookingType.trim().isEmpty()) {
            return allBookings;
        }

        List<Booking> filteredBookings = new ArrayList<>();

        for (Booking booking : allBookings) {
            if (booking.getBookingType() != null
                    && booking.getBookingType().equalsIgnoreCase(bookingType)) {
                filteredBookings.add(booking);
            }
        }

        return filteredBookings;
    }

    private String normalizeBookingType(String bookingType) {
        if (bookingType == null) {
            return "";
        }

        String value = bookingType.trim();

        if ("Tour".equalsIgnoreCase(value)) {
            return "Tour";
        }

        if ("Accommodation".equalsIgnoreCase(value)) {
            return "Accommodation";
        }

        if ("Vehicle".equalsIgnoreCase(value)) {
            return "Vehicle";
        }

        return "";
    }

    private String getBookingPageTitle(String bookingType) {
        if ("Tour".equalsIgnoreCase(bookingType)) {
            return "Quản lý đặt tour";
        }

        if ("Accommodation".equalsIgnoreCase(bookingType)) {
            return "Quản lý đặt phòng";
        }

        if ("Vehicle".equalsIgnoreCase(bookingType)) {
            return "Quản lý đặt xe";
        }

        return "Quản lý booking";
    }

    private String getBookingPageSubtitle(String bookingType) {
        if ("Tour".equalsIgnoreCase(bookingType)) {
            return "Theo dõi, xem chi tiết, hủy và hoàn thành các đơn đặt tour.";
        }

        if ("Accommodation".equalsIgnoreCase(bookingType)) {
            return "Theo dõi, xem chi tiết, hủy và hoàn thành các đơn đặt phòng / lưu trú.";
        }

        if ("Vehicle".equalsIgnoreCase(bookingType)) {
            return "Theo dõi, xem chi tiết, hủy và hoàn thành các đơn đặt xe.";
        }

        return "Theo dõi, xem chi tiết, hủy và hoàn thành các đơn booking trong hệ thống.";
    }

    private String buildBookingListPath(String bookingType) {
        if (bookingType == null || bookingType.trim().isEmpty()) {
            return "/staff/booking";
        }

        return "/staff/booking?type=" + bookingType;
    }

    private String buildBookingListPathWithMessage(String bookingType, String messageType, String messageValue) {
        String path = buildBookingListPath(bookingType);

        if (path.contains("?")) {
            return path + "&" + messageType + "=" + messageValue;
        }

        return path + "?" + messageType + "=" + messageValue;
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
}