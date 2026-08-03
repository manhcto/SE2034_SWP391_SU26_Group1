package vn.edu.fpt.controller.staff;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.DAO.BookingDAO;
import vn.edu.fpt.DAO.PaymentDAO;
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
    private final PaymentDAO paymentDAO = new PaymentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // Cung mot controller xu ly 2 man GET:
        // /staff/booking -> danh sach booking, /staff/booking-detail -> chi tiet booking.
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

        // Chi endpoint /staff/booking-status moi duoc phep update trang thai booking bang POST.
        if (!"/staff/booking-status".equals(request.getServletPath())) {
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            return;
        }
        updateStatusFromList(request, response);
    }

    private void showBookingList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Dong bo trang thai thanh toan/booking truoc khi hien danh sach de Staff thay du lieu moi nhat.
        paymentDAO.synchronizeBookingStates();

        List<Booking> bookingList = bookingDAO.getAllBookings();
        setStatusCounts(request, bookingList);

        // Filter tren memory theo type/status lay tu query string.
        String type = trim(request.getParameter("type"));
        if (!type.isEmpty()) {
            bookingList.removeIf(booking ->
                    !type.equalsIgnoreCase(trim(booking.getBookingType())));
        }

        String status = trim(request.getParameter("status"));
        if (!status.isEmpty()) {
            bookingList.removeIf(booking ->
                    !status.equalsIgnoreCase(trim(booking.getDisplayStatus())));
        }

        request.setAttribute("bookingList", bookingList);
        request.getRequestDispatcher(LIST_PAGE).forward(request, response);
    }

    private void showBookingDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chi tiet booking lay theo bookingID tren URL.
        paymentDAO.synchronizeBookingStates();

        int bookingID = parsePositiveInt(request.getParameter("bookingID"));
        Map<String, Object> bookingDetail = bookingID > 0
                ? bookingDAO.getBookingSummaryByID(bookingID)
                : null;

        if (bookingDetail == null) {
            request.setAttribute("error", "Khong tim thay booking.");
        } else {
            request.setAttribute("bookingDetail", bookingDetail);
        }
        request.getRequestDispatcher(DETAIL_PAGE).forward(request, response);
    }

    private void updateStatusFromList(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        // Nut doi trang thai tren list gui bookingID + status ve day.
        int bookingID = parsePositiveInt(request.getParameter("bookingID"));
        String status = trim(request.getParameter("status"));
        boolean updated = bookingID > 0
                && isValidStatus(status)
                && bookingDAO.updateBookingStatus(bookingID, status);

        String query = updated ? "success=updated" : "error=updateFailed";

        String type = trim(request.getParameter("type"));
        if (!type.isEmpty()) {
            query += "&type=" + URLEncoder.encode(type, StandardCharsets.UTF_8);
        }

        String statusFilter = trim(request.getParameter("statusFilter"));
        if (!statusFilter.isEmpty()) {
            query += "&status=" + URLEncoder.encode(statusFilter, StandardCharsets.UTF_8);
        }

        response.sendRedirect(request.getContextPath() + "/staff/booking?" + query);
    }

    private boolean isValidStatus(String status) {
        // Staff chỉ được thực hiện hai thay đổi nghiệp vụ từ danh sách:
        // hủy đơn hoặc đánh dấu dịch vụ đã kết thúc. Pending/Completed
        // được đồng bộ tự động theo trạng thái thanh toán.
        return Booking.isCancelledStatus(status)
                || Booking.isEndedStatus(status);
    }

    private void setStatusCounts(HttpServletRequest request, List<Booking> bookingList) {
        int pendingCount = 0;
        int completedCount = 0;
        int cancelledCount = 0;
        int endedCount = 0;

        for (Booking booking : bookingList) {
            String bookingStatus = booking.getStatus();
            if (Booking.isProcessingStatus(bookingStatus)) {
                pendingCount++;
            } else if (Booking.isCancelledStatus(bookingStatus)) {
                cancelledCount++;
            } else if (Booking.isEndedStatus(bookingStatus)) {
                endedCount++;
            } else if (Booking.isCompletedStatus(bookingStatus)
                    || Booking.isApprovedStatus(bookingStatus)) {
                completedCount++;
            }
        }

        request.setAttribute("pendingCount", pendingCount);
        request.setAttribute("completedCount", completedCount);
        request.setAttribute("cancelledCount", cancelledCount);
        request.setAttribute("endedCount", endedCount);
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
