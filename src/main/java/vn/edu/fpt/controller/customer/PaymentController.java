package vn.edu.fpt.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.DAO.BookingDAO;
import vn.edu.fpt.DAO.PaymentDAO;
import vn.edu.fpt.model.Payment;
import vn.edu.fpt.model.User;
import vn.edu.fpt.service.PayOSService;
import vn.edu.fpt.service.PaymentResult;

import java.io.BufferedReader;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.nio.charset.StandardCharsets;
import java.util.Map;
import java.util.Set;

@WebServlet(name = "PaymentController", urlPatterns = {
        "/payment",
        "/payment/return",
        "/payment/cancel",
        "/payment/webhook"
})
public class PaymentController extends HttpServlet {
    private final BookingDAO bookingDAO = new BookingDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final PayOSService payOSService = new PayOSService();
    private static final String MOCK_PAYMENT_ENABLED = System.getenv().getOrDefault("MOCK_PAYMENT_ENABLED", "true");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding(StandardCharsets.UTF_8.name());
        response.setCharacterEncoding(StandardCharsets.UTF_8.name());

        String path = request.getServletPath();
        if ("/payment/return".equals(path)) {
            showPaymentPage(request, response,
                    "PayOS da chuyen huong ve he thong. Don se duoc cap nhat khi webhook thanh toan thanh cong.",
                    null);
            return;
        }

        if ("/payment/cancel".equals(path)) {
            int bookingID = parsePositiveInt(request.getParameter("bookingID"));
            cancelPendingPaymentFlow(bookingID, "cancel", "Nguoi dung da huy man hinh thanh toan PayOS.");
            showPaymentPage(request, response,
                    null,
                    "Ban da huy man hinh thanh toan PayOS. So luong giu cho da duoc tra lai.");
            return;
        }

        showPaymentPage(request, response, null, null);
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
        if (bookingID <= 0) {
            response.sendRedirect(request.getContextPath() + "/booking-list");
            return;
        }

        Map<String, Object> bookingSummary = bookingDAO.getBookingSummaryByID(bookingID);
        if (!canAccessBooking(request, bookingSummary, bookingID)) {
            response.sendRedirect(request.getContextPath() + "/booking-list");
            return;
        }

        BigDecimal amount = getAmount(bookingSummary);
        if (amount.compareTo(BigDecimal.ZERO) <= 0) {
            showPaymentPage(request, response, null, "So tien thanh toan khong hop le.");
            return;
        }

        if (!isPendingBooking(bookingSummary)) {
            showPaymentPage(request, response, null, "Booking khong con o trang thai cho thanh toan.");
            return;
        }

        Payment payment = paymentDAO.createPending(bookingID, amount);
        if (payment == null) {
            showPaymentPage(request, response, null, "Khong the tao ban ghi thanh toan.");
            return;
        }

        if (isExpiredPendingPayment(payment)) {
            cancelPendingPaymentFlow(bookingID, "expired", "Ma QR thanh toan da het han.");
            showPaymentPage(request, response, null, "Ma QR thanh toan da het han. So luong giu cho da duoc tra lai.");
            return;
        }

        if (payment.isPaid()) {
            showPaymentPage(request, response, "Booking nay da duoc thanh toan.", null);
            return;
        }

        String action = request.getParameter("action");
        if ("mockSuccess".equals(action)) {
            if (!isMockPaymentEnabled()) {
                showPaymentPage(request, response, null, "Mock payment dang bi tat.");
                return;
            }

            boolean paid = paymentDAO.markPaidByBookingID(bookingID, "MOCK-" + bookingID);
            boolean confirmed = bookingDAO.updateBookingStatus(bookingID, "Confirmed");

            if (paid && confirmed) {
                showPaymentPage(request, response, "Da gia lap thanh toan thanh cong cho booking nay.", null);
            } else {
                showPaymentPage(request, response, null, "Khong the cap nhat thanh toan gia lap.");
            }
            return;
        }

        PaymentResult result = payOSService.createPaymentLink(
                bookingID,
                amount,
                "WonderVN " + bookingID
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
                                 String error)
            throws ServletException, IOException {

        int bookingID = parsePositiveInt(request.getParameter("bookingID"));
        if (bookingID <= 0) {
            response.sendRedirect(request.getContextPath() + "/booking-list");
            return;
        }

        Map<String, Object> bookingSummary = bookingDAO.getBookingSummaryByID(bookingID);
        if (!canAccessBooking(request, bookingSummary, bookingID)) {
            response.sendRedirect(request.getContextPath() + "/booking-list");
            return;
        }

        BigDecimal amount = getAmount(bookingSummary);
        Payment payment = paymentDAO.findByBookingID(bookingID);

        if (payment == null && isPendingBooking(bookingSummary)) {
            payment = paymentDAO.createPending(bookingID, amount);
        }

        if (payment != null && isExpiredPendingPayment(payment)) {
            boolean released = cancelPendingPaymentFlow(
                    bookingID,
                    "expired",
                    "Ma QR thanh toan da het han."
            );

            if (released) {
                bookingSummary = bookingDAO.getBookingSummaryByID(bookingID);
                payment = paymentDAO.findByBookingID(bookingID);

                if (error == null || error.isBlank()) {
                    error = "Ma QR thanh toan da het han. So luong giu cho da duoc tra lai.";
                }
            }
        }

        request.setAttribute("bookingSummary", bookingSummary);
        request.setAttribute("payment", payment);
        request.setAttribute("payosConfigured", payOSService.isConfigured());
        request.setAttribute("mockPaymentEnabled", isMockPaymentEnabled());
        request.setAttribute("message", message);
        request.setAttribute("error", error);
        request.getRequestDispatcher("/views/customer/payment.jsp").forward(request, response);
    }

    private void handleWebhook(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String body = readBody(request);
        int bookingID = payOSService.extractOrderCode(body);

        if (bookingID <= 0) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\":false,\"message\":\"Invalid orderCode\"}");
            return;
        }

        Map<String, Object> bookingSummary = bookingDAO.getBookingSummaryByID(bookingID);
        long paidAmount = payOSService.extractAmount(body);

        if (payOSService.isPaidWebhook(body)) {
            if (!isExpectedAmount(bookingSummary, paidAmount)) {
                cancelPendingPaymentFlow(bookingID, "failed", "So tien thanh toan khong khop voi booking.");
                response.setContentType("application/json");
                response.getWriter().write("{\"success\":true,\"message\":\"Amount mismatch\"}");
                return;
            }

            paymentDAO.markPaidByOrderCode(bookingID, String.valueOf(bookingID));
            bookingDAO.updateBookingStatus(bookingID, "Confirmed");
            response.setContentType("application/json");
            response.getWriter().write("{\"success\":true}");
            return;
        }

        cancelPendingPaymentFlow(bookingID, "failed", "Thanh toan PayOS khong thanh cong.");
        response.setContentType("application/json");
        response.getWriter().write("{\"success\":true,\"message\":\"Payment failed\"}");
    }

    private boolean canAccessBooking(HttpServletRequest request,
                                     Map<String, Object> bookingSummary,
                                     int bookingID) {
        if (bookingSummary == null) {
            return false;
        }

        HttpSession session = request.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("user");

        Object ownerID = bookingSummary.get("userID");
        int ownerUserID = ownerID instanceof Number ? ((Number) ownerID).intValue() : 0;

        if (ownerUserID > 0) {
            return user != null && ownerUserID == user.getUserID();
        }

        if (session == null) {
            return false;
        }

        return isGuestBookingAllowed(session, bookingID);
    }

    private BigDecimal getAmount(Map<String, Object> bookingSummary) {
        Object rawAmount = bookingSummary == null ? null : bookingSummary.get("totalPrice");
        if (rawAmount instanceof BigDecimal) {
            return (BigDecimal) rawAmount;
        }
        if (rawAmount instanceof Number) {
            return BigDecimal.valueOf(((Number) rawAmount).doubleValue());
        }
        return BigDecimal.ZERO;
    }

    private boolean isPendingBooking(Map<String, Object> bookingSummary) {
        Object status = bookingSummary == null ? null : bookingSummary.get("status");
        return status instanceof String && "Pending".equalsIgnoreCase((String) status);
    }

    private boolean isExpiredPendingPayment(Payment payment) {
        return payment != null
                && !payment.isPaid()
                && "Pending".equalsIgnoreCase(payment.getStatus())
                && payment.getExpiredAt() != null
                && payment.getExpiredAt().getTime() <= System.currentTimeMillis();
    }

    private boolean isExpectedAmount(Map<String, Object> bookingSummary, long paidAmount) {
        BigDecimal expectedAmount = getAmount(bookingSummary);
        long expectedValue = expectedAmount.setScale(0, RoundingMode.HALF_UP).longValue();
        return expectedValue > 0 && expectedValue == paidAmount;
    }

    private boolean isMockPaymentEnabled() {
        return "true".equalsIgnoreCase(MOCK_PAYMENT_ENABLED);
    }

    private int parsePositiveInt(String value) {
        if (value == null || value.trim().isEmpty()) {
            return 0;
        }

        try {
            int result = Integer.parseInt(value.trim());
            return result > 0 ? result : 0;
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    private String readBody(HttpServletRequest request) throws IOException {
        StringBuilder builder = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                builder.append(line);
            }
        }
        return builder.toString();
    }

    private boolean cancelPendingPaymentFlow(int bookingID, String paymentState, String note) {
        if (bookingID <= 0) {
            return false;
        }

        boolean paymentUpdated;

        if ("cancel".equals(paymentState)) {
            paymentUpdated = paymentDAO.markCancelledByBookingID(bookingID, note);
        } else if ("expired".equals(paymentState)) {
            paymentUpdated = paymentDAO.markExpiredByBookingID(bookingID, note);
        } else {
            paymentUpdated = paymentDAO.markFailedByBookingID(bookingID, note);
        }

        boolean bookingReleased = bookingDAO.cancelPendingBookingAndRelease(bookingID);
        return paymentUpdated || bookingReleased;
    }

    @SuppressWarnings("unchecked")
    private boolean isGuestBookingAllowed(HttpSession session, int bookingID) {
        Object guestBookings = session.getAttribute("guestBookingIDs");
        return guestBookings instanceof Set && ((Set<Integer>) guestBookings).contains(bookingID);
    }
}
