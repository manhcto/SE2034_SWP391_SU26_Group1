package vn.edu.fpt.controller.admin;

import vn.edu.fpt.DAO.BookingDAO;
import vn.edu.fpt.model.Booking;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
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
        List<Booking> bookingList = bookingDAO.getAllBookings();

        String type = request.getParameter("type");
        String selectedType = (type == null) ? "" : type.trim();
        if (!selectedType.isEmpty()) {
            final String filterType = selectedType;
            bookingList.removeIf(booking -> {
                String bookingType = booking.getBookingType();
                return bookingType == null || !filterType.equalsIgnoreCase(bookingType.trim());
            });
        }

        String status = request.getParameter("status");
        String selectedStatus = (status == null) ? "" : status.trim();
        if (!selectedStatus.isEmpty()) {
            final String filterStatus = selectedStatus;
            bookingList.removeIf(booking -> {
                String displayStatus = booking.getDisplayStatus();
                return displayStatus == null || !filterStatus.equalsIgnoreCase(displayStatus.trim());
            });
        }

        request.setAttribute("selectedBookingType", selectedType.isEmpty() ? null : selectedType);
        request.setAttribute("bookingList", bookingList);
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
            request.getRequestDispatcher(BOOKING_DETAIL_PAGE).forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/booking");
        }
    }
}