package vn.edu.fpt.controller.admin;

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
import java.util.Map;

@WebServlet(name = "AdminBookingController", urlPatterns = {
        "/admin/booking",
        "/admin/booking-detail"
})
public class AdminBookingController extends HttpServlet {

    private static final String BOOKING_LIST_PAGE = "/views/admin/admin-booking-list.jsp";
    private static final String BOOKING_DETAIL_PAGE = "/views/admin/admin-booking-detail.jsp";

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

        BookingDAO bookingDAO = new BookingDAO();
        List<Booking> allBookings = bookingDAO.getAllBookings();
        String selectedBookingType = normalizeBookingType(request.getParameter("type"));
        List<Booking> bookingList = filterBookingsByType(allBookings, selectedBookingType);

        request.setAttribute("bookingList", bookingList);
        request.setAttribute("selectedBookingType", selectedBookingType);
        request.setAttribute("bookingPageTitle", "Đơn đặt chỗ");
        request.setAttribute("bookingPageSubtitle", buildBookingPageSubtitle(selectedBookingType));
        request.setAttribute("activeBookingCount", countBookingsByStatus(bookingList, "Pending", "Confirmed"));
        request.setAttribute("cancelledBookingCount", countBookingsByStatus(bookingList, "Cancelled"));
        request.setAttribute("completedBookingCount", countBookingsByStatus(bookingList, "Completed"));
        request.getRequestDispatcher(BOOKING_LIST_PAGE).forward(request, response);
    }

    private void showBookingDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String bookingIDRaw = request.getParameter("bookingID");

        if (bookingIDRaw == null || bookingIDRaw.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/booking");
            return;
        }

        try {
            int bookingID = Integer.parseInt(bookingIDRaw.trim());

            BookingDAO bookingDAO = new BookingDAO();
            Map<String, Object> bookingDetail = bookingDAO.getBookingSummaryByID(bookingID);

            if (bookingDetail == null) {
                request.setAttribute("error", "Không tìm thấy booking.");
                request.getRequestDispatcher(BOOKING_DETAIL_PAGE).forward(request, response);
                return;
            }

            request.setAttribute("bookingDetail", bookingDetail);
            request.setAttribute("selectedBookingType", normalizeBookingType(request.getParameter("type")));
            request.getRequestDispatcher(BOOKING_DETAIL_PAGE).forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/booking");
        }
    }

    private List<Booking> filterBookingsByType(List<Booking> allBookings, String selectedBookingType) {
        if (selectedBookingType == null || selectedBookingType.isEmpty()) {
            return allBookings;
        }

        List<Booking> filteredBookings = new ArrayList<>();

        for (Booking booking : allBookings) {
            if (selectedBookingType.equalsIgnoreCase(booking.getBookingType())) {
                filteredBookings.add(booking);
            }
        }

        return filteredBookings;
    }

    private int countBookingsByStatus(List<Booking> bookingList, String... statuses) {
        int count = 0;

        for (Booking booking : bookingList) {
            for (String status : statuses) {
                if (status.equalsIgnoreCase(booking.getStatus())) {
                    count++;
                    break;
                }
            }
        }

        return count;
    }

    private String normalizeBookingType(String type) {
        if (type == null || type.trim().isEmpty()) {
            return "";
        }

        String value = type.trim();

        if ("Tour".equalsIgnoreCase(value)) {
            return "Tour";
        }

        if ("Accommodation".equalsIgnoreCase(value)) {
            return "Accommodation";
        }

        return "";
    }

    private String buildBookingPageSubtitle(String selectedBookingType) {
        if ("Tour".equals(selectedBookingType)) {
            return "Theo dõi các đơn đặt tour được tạo từ giao diện khách hàng.";
        }

        if ("Accommodation".equals(selectedBookingType)) {
            return "Theo dõi các đơn đặt phòng được tạo từ giao diện khách hàng.";
        }

        return "Theo dõi toàn bộ đơn đặt tour và đặt phòng được tạo từ giao diện khách hàng.";
    }
}
