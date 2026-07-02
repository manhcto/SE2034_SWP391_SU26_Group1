package vn.edu.fpt.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.DAO.BookingDAO;
import vn.edu.fpt.model.Booking;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AdminBookingController", urlPatterns = {
        "/admin/booking",
        "/admin/booking-detail"
})
public class AdminBookingController extends HttpServlet {

    private static final String ADMIN_BOOKING_LIST_PAGE = "/views/admin/admin-booking-list.jsp";
    private static final String ADMIN_BOOKING_DETAIL_PAGE = "/views/admin/admin-booking-detail.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String path = request.getServletPath();

        switch (path) {
            case "/admin/booking":
                showBookingList(request, response);
                break;

            case "/admin/booking-detail":
                showBookingDetail(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/admin/booking");
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

        request.getRequestDispatcher(ADMIN_BOOKING_LIST_PAGE).forward(request, response);
    }

    private void showBookingDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String selectedBookingType = normalizeBookingType(request.getParameter("type"));
        String bookingIDRaw = request.getParameter("bookingID");

        if (bookingIDRaw == null || bookingIDRaw.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + buildAdminBookingListPath(selectedBookingType));
            return;
        }

        try {
            int bookingID = Integer.parseInt(bookingIDRaw.trim());

            BookingDAO bookingDAO = new BookingDAO();
            Map<String, Object> bookingDetail = bookingDAO.getBookingSummaryByID(bookingID);

            if (bookingDetail == null || bookingDetail.isEmpty()) {
                request.setAttribute("error", "Không tìm thấy đơn đặt chỗ cần xem.");
                request.setAttribute("selectedBookingType", selectedBookingType);
                request.setAttribute("backToBookingListUrl", request.getContextPath() + buildAdminBookingListPath(selectedBookingType));
                request.getRequestDispatcher(ADMIN_BOOKING_DETAIL_PAGE).forward(request, response);
                return;
            }

            String bookingType = "";

            if (bookingDetail.get("bookingType") != null) {
                bookingType = normalizeBookingType(String.valueOf(bookingDetail.get("bookingType")));
            }

            if (selectedBookingType.isEmpty()) {
                selectedBookingType = bookingType;
            }

            String status = bookingDetail.get("status") == null
                    ? ""
                    : String.valueOf(bookingDetail.get("status"));

            bookingDetail.put("displayStatusVietnamese", getVietnameseStatus(status));
            bookingDetail.put("displayTypeVietnamese", getVietnameseBookingType(bookingType));

            request.setAttribute("bookingDetail", bookingDetail);
            request.setAttribute("selectedBookingType", selectedBookingType);
            request.setAttribute("backToBookingListUrl", request.getContextPath() + buildAdminBookingListPath(selectedBookingType));

            request.getRequestDispatcher(ADMIN_BOOKING_DETAIL_PAGE).forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + buildAdminBookingListPath(selectedBookingType));
        }
    }

    private List<Booking> filterBookingsByType(List<Booking> allBookings, String bookingType) {
        List<Booking> filteredBookings = new ArrayList<>();

        if (allBookings == null) {
            return filteredBookings;
        }

        if (bookingType == null || bookingType.trim().isEmpty()) {
            return allBookings;
        }

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
            return "Xem đơn đặt tour";
        }

        if ("Accommodation".equalsIgnoreCase(bookingType)) {
            return "Xem đơn đặt phòng";
        }

        if ("Vehicle".equalsIgnoreCase(bookingType)) {
            return "Xem đơn đặt xe";
        }

        return "Xem đơn đặt chỗ";
    }

    private String getBookingPageSubtitle(String bookingType) {
        if ("Tour".equalsIgnoreCase(bookingType)) {
            return "Quản trị viên chỉ xem danh sách các đơn đặt tour trong hệ thống.";
        }

        if ("Accommodation".equalsIgnoreCase(bookingType)) {
            return "Quản trị viên chỉ xem danh sách các đơn đặt phòng và lưu trú trong hệ thống.";
        }

        if ("Vehicle".equalsIgnoreCase(bookingType)) {
            return "Quản trị viên chỉ xem danh sách các đơn đặt xe trong hệ thống.";
        }

        return "Quản trị viên chỉ xem danh sách đơn đặt chỗ, không sửa hoặc xóa dữ liệu.";
    }

    private String getVietnameseStatus(String status) {
        if ("Confirmed".equalsIgnoreCase(status)) {
            return "Đang diễn ra";
        }

        if ("Cancelled".equalsIgnoreCase(status)) {
            return "Đã hủy";
        }

        if ("Completed".equalsIgnoreCase(status)) {
            return "Đã hoàn thành";
        }

        return "Đang diễn ra";
    }

    private String getVietnameseBookingType(String bookingType) {
        if ("Tour".equalsIgnoreCase(bookingType)) {
            return "Đặt tour";
        }

        if ("Accommodation".equalsIgnoreCase(bookingType)) {
            return "Đặt phòng";
        }

        if ("Vehicle".equalsIgnoreCase(bookingType)) {
            return "Đặt xe";
        }

        return "Đặt chỗ";
    }

    private String buildAdminBookingListPath(String bookingType) {
        if (bookingType == null || bookingType.trim().isEmpty()) {
            return "/admin/booking";
        }

        return "/admin/booking?type=" + bookingType;
    }
}