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
import java.util.Map;

@WebServlet(name = "BookingSummaryController", urlPatterns = {"/booking-summary"})
public class BookingSummaryController extends HttpServlet {

    private static final String SUMMARY_PAGE = "/views/customer/booking-summary.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String bookingIDRaw = request.getParameter("bookingID");
        int bookingID = parsePositiveInt(bookingIDRaw);

        if (bookingID <= 0) {
            request.setAttribute("error", "Mã đơn đặt chỗ không hợp lệ.");
            request.getRequestDispatcher(SUMMARY_PAGE).forward(request, response);
            return;
        }

        User currentUser = getCurrentUser(request);

        if (currentUser == null) {
            request.getSession().setAttribute(
                    "redirectAfterLogin",
                    request.getContextPath() + "/booking-summary?bookingID=" + bookingID
            );
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        BookingDAO bookingDAO = new BookingDAO();
        Booking booking = bookingDAO.getBookingByID(bookingID);

        if (booking == null) {
            request.setAttribute("error", "Không tìm thấy đơn đặt chỗ.");
            request.getRequestDispatcher(SUMMARY_PAGE).forward(request, response);
            return;
        }

        if (!isStaffOrAdmin(currentUser) && !isOwner(booking, currentUser)) {
            request.setAttribute("error", "Bạn không có quyền xem đơn đặt chỗ này.");
            request.getRequestDispatcher(SUMMARY_PAGE).forward(request, response);
            return;
        }

        Map<String, Object> bookingSummary = bookingDAO.getBookingSummaryByID(bookingID);

        if (bookingSummary == null || bookingSummary.isEmpty()) {
            request.setAttribute("error", "Không tìm thấy thông tin chi tiết đơn đặt chỗ.");
            request.getRequestDispatcher(SUMMARY_PAGE).forward(request, response);
            return;
        }

        request.setAttribute("bookingSummary", bookingSummary);
        request.getRequestDispatcher(SUMMARY_PAGE).forward(request, response);
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

    private boolean isStaffOrAdmin(User currentUser) {
        if (currentUser == null) {
            return false;
        }

        int roleID = currentUser.getRoleID();

        return roleID == 1 || roleID == 2;
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

    private String safe(String value) {
        return value == null ? "" : value.trim();
    }
}