package vn.edu.fpt.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.DAO.BookingDAO;
import vn.edu.fpt.DAO.PaymentDAO;
import vn.edu.fpt.model.Booking;
import vn.edu.fpt.model.Payment;
import vn.edu.fpt.model.User;
import vn.edu.fpt.service.PayOSService;
import vn.edu.fpt.service.PaymentResult;
import vn.payos.model.webhooks.WebhookData;

import java.io.BufferedReader;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.nio.charset.StandardCharsets;
import java.util.Map;
import java.util.Set;

@WebServlet(name = "PaymentController", urlPatterns = {
        "/payment", "/payment/return", "/payment/cancel", "/payment/webhook"
})
public class PaymentController extends HttpServlet {
    private final BookingDAO bookingDAO = new BookingDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final PayOSService payOSService = new PayOSService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding(StandardCharsets.UTF_8.name());
        response.setCharacterEncoding(StandardCharsets.UTF_8.name());

        if ("/payment/cancel".equals(request.getServletPath())) {
            int bookingID = parsePositiveInt(request.getParameter("bookingID"));
            Map<String, Object> summary = bookingDAO.getBookingSummaryByID(bookingID);
            if (!canAccessBooking(request, summary, bookingID)) {
                response.sendRedirect(request.getContextPath() + "/booking-list");
                return;
            }
            cancelPayment(bookingID, "Khách hàng đã hủy thanh toán PayOS.");
            showPaymentPage(request, response, null,
                    "Bạn đã hủy thanh toán. Số phòng/chỗ đã được hoàn lại.");
            return;
        }

        String message = "/payment/return".equals(request.getServletPath())
                ? "PayOS đã chuyển về WonderVN. Hệ thống sẽ xác nhận khi nhận webhook hợp lệ."
                : null;
        showPaymentPage(request, response, message, null);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding(StandardCharsets.UTF_8.name());
        response.setCharacterEncoding(StandardCharsets.UTF_8.name());

        if ("/payment/webhook".equals(request.getServletPath())) {
            handleWebhook(request, response);
            return;
        }

        int bookingID = parsePositiveInt(request.getParameter("bookingID"));
        Map<String, Object> summary = bookingDAO.getBookingSummaryByID(bookingID);
        if (!canAccessBooking(request, summary, bookingID)) {
            response.sendRedirect(request.getContextPath() + "/booking-list");
            return;
        }

        if (!payOSService.isConfigured()) {
            showPaymentPage(request, response, null,
                    "PayOS chưa được cấu hình trên máy chủ.");
            return;
        }

        if (!isProcessingBooking(summary)) {
            showPaymentPage(request, response, null,
                    "Booking không còn ở trạng thái đang xử lý.");
            return;
        }

        BigDecimal amount = getAmount(summary);
        if (amount.signum() <= 0 || paymentDAO.createPending(bookingID, amount) == null) {
            showPaymentPage(request, response, null,
                    "Không thể khởi tạo giao dịch thanh toán.");
            return;
        }

        PaymentResult result = payOSService.createPaymentLink(
                bookingID, amount, "WonderVN " + bookingID
        );
        if (!result.isSuccess()) {
            showPaymentPage(request, response, null, result.getMessage());
            return;
        }

        paymentDAO.prepareCheckout(bookingID);
        response.sendRedirect(result.getCheckoutUrl());
    }

    private void showPaymentPage(HttpServletRequest request,
                                 HttpServletResponse response,
                                 String message,
                                 String error) throws ServletException, IOException {
        int bookingID = parsePositiveInt(request.getParameter("bookingID"));
        Map<String, Object> summary = bookingDAO.getBookingSummaryByID(bookingID);
        if (!canAccessBooking(request, summary, bookingID)) {
            response.sendRedirect(request.getContextPath() + "/booking-list");
            return;
        }

        Payment payment = paymentDAO.findByBookingID(bookingID);
        if (payment == null && isProcessingBooking(summary)) {
            payment = paymentDAO.createPending(bookingID, getAmount(summary));
        }

        request.setAttribute("bookingSummary", summary);
        request.setAttribute("payment", payment);
        request.setAttribute("payosConfigured", payOSService.isConfigured());
        request.setAttribute("message", message);
        request.setAttribute("error", error);
        request.getRequestDispatcher("/views/customer/payment.jsp").forward(request, response);
    }

    private void handleWebhook(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding(StandardCharsets.UTF_8.name());

        try {
            WebhookData data = payOSService.verifyWebhook(readBody(request));
            int bookingID = data.getOrderCode() == null ? 0 : data.getOrderCode().intValue();
            Map<String, Object> summary = bookingDAO.getBookingSummaryByID(bookingID);

            // PayOS gửi một webhook mẫu khi đăng ký URL; xác nhận mẫu hợp lệ nhưng không ghi DB.
            if (summary == null) {
                writeJson(response, HttpServletResponse.SC_OK, "Webhook hợp lệ");
                return;
            }

            if (!"00".equals(data.getCode()) || !isExpectedAmount(summary, data.getAmount())) {
                paymentDAO.markFailedByBookingID(bookingID,
                        "Webhook PayOS có trạng thái hoặc số tiền không khớp.");
                writeJson(response, HttpServletResponse.SC_BAD_REQUEST,
                        "Dữ liệu thanh toán không khớp");
                return;
            }

            String reference = data.getReference() == null
                    ? String.valueOf(bookingID)
                    : data.getReference();
            boolean approved = bookingDAO.updateBookingStatus(bookingID, Booking.STATUS_APPROVED);
            boolean paid = approved && paymentDAO.markPaidByBookingID(bookingID, reference);

            if (!paid || !approved) {
                writeJson(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "Không thể cập nhật thanh toán");
                return;
            }

            writeJson(response, HttpServletResponse.SC_OK, "Đã xác nhận thanh toán");
        } catch (Exception e) {
            writeJson(response, HttpServletResponse.SC_BAD_REQUEST,
                    "Webhook không hợp lệ");
        }
    }

    private void cancelPayment(int bookingID, String note) {
        if (bookingID <= 0) {
            return;
        }
        paymentDAO.markCancelledByBookingID(bookingID, note);
        bookingDAO.cancelPendingBookingAndRelease(bookingID);
    }

    private boolean canAccessBooking(HttpServletRequest request,
                                     Map<String, Object> summary,
                                     int bookingID) {
        if (summary == null) {
            return false;
        }

        HttpSession session = request.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("user");
        Object owner = summary.get("userID");
        int ownerID = owner instanceof Number ? ((Number) owner).intValue() : 0;

        if (ownerID > 0) {
            return user != null && ownerID == user.getUserID();
        }
        return session != null && isGuestBookingAllowed(session, bookingID);
    }

    private boolean isProcessingBooking(Map<String, Object> summary) {
        Object status = summary == null ? null : summary.get("status");
        return status instanceof String && Booking.isProcessingStatus((String) status);
    }

    private BigDecimal getAmount(Map<String, Object> summary) {
        Object raw = summary == null ? null : summary.get("totalPrice");
        if (raw instanceof BigDecimal) {
            return (BigDecimal) raw;
        }
        return raw instanceof Number
                ? BigDecimal.valueOf(((Number) raw).doubleValue())
                : BigDecimal.ZERO;
    }

    private boolean isExpectedAmount(Map<String, Object> summary, Long paidAmount) {
        if (paidAmount == null) {
            return false;
        }
        long expected = getAmount(summary).setScale(0, RoundingMode.HALF_UP).longValue();
        return expected > 0 && expected == paidAmount;
    }

    private int parsePositiveInt(String value) {
        try {
            int number = Integer.parseInt(value == null ? "" : value.trim());
            return number > 0 ? number : 0;
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    private String readBody(HttpServletRequest request) throws IOException {
        StringBuilder body = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                body.append(line);
            }
        }
        return body.toString();
    }

    private void writeJson(HttpServletResponse response, int status, String message)
            throws IOException {
        response.setStatus(status);
        response.getWriter().write("{\"success\":" + (status < 300)
                + ",\"message\":\"" + message.replace("\"", "'") + "\"}");
    }

    @SuppressWarnings("unchecked")
    private boolean isGuestBookingAllowed(HttpSession session, int bookingID) {
        Object guestBookings = session.getAttribute("guestBookingIDs");
        return guestBookings instanceof Set
                && ((Set<Integer>) guestBookings).contains(bookingID);
    }
}
