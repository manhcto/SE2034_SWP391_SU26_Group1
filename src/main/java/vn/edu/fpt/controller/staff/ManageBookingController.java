package vn.edu.fpt.controller.staff;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.DAO.BookingDAO;
import vn.edu.fpt.model.Booking;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;

@WebServlet(name = "ManageBookingController", urlPatterns = {
        "/staff/booking",
        "/staff/booking-detail",
        "/staff/booking-status"
})
public class ManageBookingController extends HttpServlet {

    private static final String LIST_PAGE = "/views/staff/staff-booking-list.jsp";
    private static final String DETAIL_PAGE = "/views/staff/staff-booking-detail.jsp";
    private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        if ("/staff/booking-detail".equals(request.getServletPath())) {
            showBookingDetail(request, response);
            return;
        }
        showBookingList(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        if (!"/staff/booking-status".equals(request.getServletPath())) {
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            return;
        }
        updateStatusFromList(request, response);
    }

    private void showBookingList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Booking> bookingList = bookingDAO.getAllBookings();
        String type = trim(request.getParameter("type"));
        if (!type.isEmpty()) {
            bookingList.removeIf(booking -> !type.equalsIgnoreCase(booking.getBookingType()));
        }

        request.setAttribute("bookingList", bookingList);
        request.getRequestDispatcher(LIST_PAGE).forward(request, response);
    }

    private void showBookingDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int bookingID = parsePositiveInt(request.getParameter("bookingID"));
        Map<String, Object> bookingDetail = bookingID > 0
                ? bookingDAO.getBookingSummaryByID(bookingID)
                : null;

        if (bookingDetail == null) {
            request.setAttribute("error", "Không tìm thấy booking.");
        } else {
            request.setAttribute("bookingDetail", bookingDetail);
        }
        request.getRequestDispatcher(DETAIL_PAGE).forward(request, response);
    }

    private void updateStatusFromList(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int bookingID = parsePositiveInt(request.getParameter("bookingID"));
        String status = trim(request.getParameter("status"));
        boolean updated = bookingID > 0
                && isValidStatus(status)
                && bookingDAO.updateBookingStatus(bookingID, status);

        String type = trim(request.getParameter("type"));
        String query = updated ? "success=updated" : "error=updateFailed";
        if (!type.isEmpty()) {
            query += "&type=" + URLEncoder.encode(type, StandardCharsets.UTF_8);
        }
        response.sendRedirect(request.getContextPath() + "/staff/booking?" + query);
    }

    private boolean isValidStatus(String status) {
        return Booking.isProcessingStatus(status)
                || Booking.isApprovedStatus(status)
                || Booking.isCancelledStatus(status)
                || Booking.isCompletedStatus(status);
    }

    private int parsePositiveInt(String value) {
        try {
            int number = Integer.parseInt(trim(value));
            return number > 0 ? number : 0;
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }
}
