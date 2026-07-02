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
                    buildCurrentSummaryUrl(request)
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

        String bookingStatus = safe((String) bookingSummary.get("status"));
        String bookingType = safe((String) bookingSummary.get("bookingType"));

        bookingSummary.put("displayStatusVietnamese", getVietnameseStatus(bookingStatus));
        bookingSummary.put("displayTypeVietnamese", getVietnameseBookingType(bookingType));

        request.setAttribute("bookingSummary", bookingSummary);
        request.setAttribute("backUrl", buildBackUrl(request, currentUser));
        request.setAttribute("backLabel", buildBackLabel(request, currentUser));

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

        Integer bookingUserID = booking.getUserID();
        int currentUserID = currentUser.getUserID();

        if (bookingUserID != null && bookingUserID > 0 && currentUserID > 0 && bookingUserID == currentUserID) {
            return true;
        }

        return (bookingUserID == null || bookingUserID <= 0)
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

    private String buildCurrentSummaryUrl(HttpServletRequest request) {
        String queryString = request.getQueryString();

        if (queryString == null || queryString.trim().isEmpty()) {
            return request.getContextPath() + "/booking-summary";
        }

        return request.getContextPath() + "/booking-summary?" + queryString;
    }

    private String buildBackUrl(HttpServletRequest request, User currentUser) {
        String back = safe(request.getParameter("back"));
        String type = normalizeBookingType(request.getParameter("type"));

        if ("staff".equalsIgnoreCase(back) && isStaffOrAdmin(currentUser)) {
            return request.getContextPath() + buildStaffBookingPath(type);
        }

        if ("admin".equalsIgnoreCase(back) && isStaffOrAdmin(currentUser)) {
            return request.getContextPath() + buildAdminBookingPath(type);
        }

        return request.getContextPath() + "/";
    }

    private String buildBackLabel(HttpServletRequest request, User currentUser) {
        String back = safe(request.getParameter("back"));

        if ("staff".equalsIgnoreCase(back) && isStaffOrAdmin(currentUser)) {
            return "Quay lại quản lý đặt chỗ";
        }

        if ("admin".equalsIgnoreCase(back) && isStaffOrAdmin(currentUser)) {
            return "Quay lại danh sách đơn đặt chỗ";
        }

        return "Về trang chủ";
    }

    private String buildStaffBookingPath(String bookingType) {
        if (bookingType == null || bookingType.trim().isEmpty()) {
            return "/staff/booking";
        }

        return "/staff/booking?type=" + bookingType;
    }

    private String buildAdminBookingPath(String bookingType) {
        if (bookingType == null || bookingType.trim().isEmpty()) {
            return "/admin/booking";
        }

        return "/admin/booking?type=" + bookingType;
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

    private String safe(String value) {
        return value == null ? "" : value.trim();
    }
}