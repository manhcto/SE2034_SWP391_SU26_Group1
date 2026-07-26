package vn.edu.fpt.controller.customer;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.common.BitMatrix;
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

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.BufferedReader;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.nio.charset.StandardCharsets;
import java.util.Map;
import java.util.Set;

@WebServlet(name = "PaymentController", urlPatterns = {
        "/payment", "/payment/return", "/payment/cancel", "/payment/webhook", "/payment/qr", "/payment/status"
})
public class PaymentController extends HttpServlet {
    private static final String QR_SESSION_PREFIX = "payosQr:";
    private static final String CHECKOUT_SESSION_PREFIX = "payosCheckout:";
    private static final String BANK_NAME_SESSION_PREFIX = "payosBankName:";
    private static final String ACCOUNT_NUMBER_SESSION_PREFIX = "payosAccountNumber:";
    private static final String ACCOUNT_NAME_SESSION_PREFIX = "payosAccountName:";
    private static final String AMOUNT_SESSION_PREFIX = "payosAmount:";
    private static final String DESCRIPTION_SESSION_PREFIX = "payosDescription:";

    private final BookingDAO bookingDAO = new BookingDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final PayOSService payOSService = new PayOSService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding(StandardCharsets.UTF_8.name());
        response.setCharacterEncoding(StandardCharsets.UTF_8.name());

        String path = request.getServletPath();
        if ("/payment/qr".equals(path)) {
            renderQrCode(request, response);
            return;
        }

        if ("/payment/status".equals(path)) {
            handleStatusPolling(request, response);
            return;
        }

        if ("/payment/cancel".equals(path)) {
            handleCustomerCancel(request, response);
            return;
        }

        String message = "/payment/return".equals(path)
                ? "PayOS da chuyen ve WonderVN. He thong dang doi chieu trang thai thanh toan."
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
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }

    private void handleCustomerCancel(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int bookingID = parsePositiveInt(request.getParameter("bookingID"));
        Map<String, Object> summary = bookingDAO.getBookingSummaryByID(bookingID);
        if (!canAccessBooking(request, summary, bookingID)) {
            response.sendRedirect(request.getContextPath() + "/booking-list");
            return;
        }

        boolean released = bookingDAO.releasePendingPaymentReservation(
                bookingID, false, "Khach hang da huy phien thanh toan PayOS."
        );
        clearPaymentSession(request.getSession(false), bookingID);
        showPaymentPage(request, response, null, released
                ? "Ban da huy thanh toan. Payment da sang Cancelled, booking da sang Cancelled va voucher duoc hoan lai neu co."
                : "Phien thanh toan khong con cho giu de hoan lai.");
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

        BigDecimal amount = getAmount(summary);
        Payment payment = ensurePaymentRecord(bookingID, summary, amount);

        if (expirePendingPaymentIfNeeded(bookingID, payment, request.getSession(false))) {
            error = "Ma thanh toan da qua han. Payment da sang Cancelled va booking da sang Cancelled.";
        }

        if (paymentDAO.synchronizeBookingState(bookingID)) {
            clearPaymentSession(request.getSession(false), bookingID);
        }

        summary = bookingDAO.getBookingSummaryByID(bookingID);
        payment = paymentDAO.findByBookingID(bookingID);

        if (payment != null && payment.isPaid()) {
            message = "Thanh toan PayOS thanh cong. Booking dang cho Staff kiem tra va xac nhan.";
        } else if (Booking.isCancelledStatus(summary == null ? null : String.valueOf(summary.get("status")))) {
            error = "Ma thanh toan da qua han hoac khong con hop le. Payment da sang Cancelled, booking da sang Cancelled, slot da duoc tra va voucher duoc hoan lai neu co.";
        }

        if (summary != null
                && isBookingPayable(summary)
                && !bookingDAO.hasPayableReservationForPayment(bookingID)
                && cancelBookingForInvalidReservation(bookingID, payment)) {
            clearPaymentSession(request.getSession(false), bookingID);
            error = "Hien khong con du slot/cho hop le de vao payment. Booking da chuyen sang Cancelled.";
        }

        summary = bookingDAO.getBookingSummaryByID(bookingID);
        payment = paymentDAO.findByBookingID(bookingID);

        HttpSession session = request.getSession();
        String qrCode = sessionString(session, QR_SESSION_PREFIX + bookingID);
        String checkoutUrl = sessionString(session, CHECKOUT_SESSION_PREFIX + bookingID);
        String bankName = sessionString(session, BANK_NAME_SESSION_PREFIX + bookingID);
        String accountNumber = sessionString(session, ACCOUNT_NUMBER_SESSION_PREFIX + bookingID);
        String accountName = sessionString(session, ACCOUNT_NAME_SESSION_PREFIX + bookingID);
        Long transferAmount = sessionLong(session, AMOUNT_SESSION_PREFIX + bookingID);
        String transferDescription = sessionString(session, DESCRIPTION_SESSION_PREFIX + bookingID);

        if (isBlank(checkoutUrl) && payment != null) {
            checkoutUrl = payment.getCheckoutUrl();
        }
        if (isBlank(qrCode) && !isBlank(checkoutUrl)) {
            qrCode = checkoutUrl;
            session.setAttribute(QR_SESSION_PREFIX + bookingID, qrCode);
            session.setAttribute(CHECKOUT_SESSION_PREFIX + bookingID, checkoutUrl);
        }

        boolean canCreateCheckout = payment != null
                && !payment.isPaid()
                && !payment.isReservationReleased()
                && isBookingPayable(summary)
                && bookingDAO.hasPayableReservationForPayment(bookingID);

        if (canCreateCheckout && payOSService.isConfigured()
                && isBlank(qrCode) && isBlank(checkoutUrl)) {
            Object bookingCodeValue = summary.get("bookingCode");
            String paymentDescription = bookingCodeValue == null
                    ? "BOOKING-" + bookingID
                    : bookingCodeValue.toString();
            PaymentResult result = payOSService.createPaymentLink(bookingID, amount, paymentDescription);
            if (result.isSuccess() && paymentDAO.prepareCheckout(bookingID, result.getCheckoutUrl())) {
                qrCode = result.getQrCode();
                checkoutUrl = result.getCheckoutUrl();
                session.setAttribute(QR_SESSION_PREFIX + bookingID, qrCode);
                session.setAttribute(CHECKOUT_SESSION_PREFIX + bookingID, checkoutUrl);
                session.setAttribute(BANK_NAME_SESSION_PREFIX + bookingID, result.getBankName());
                session.setAttribute(ACCOUNT_NUMBER_SESSION_PREFIX + bookingID, result.getAccountNumber());
                session.setAttribute(ACCOUNT_NAME_SESSION_PREFIX + bookingID, result.getAccountName());
                session.setAttribute(AMOUNT_SESSION_PREFIX + bookingID, result.getAmount());
                session.setAttribute(DESCRIPTION_SESSION_PREFIX + bookingID, result.getDescription());
                bankName = result.getBankName();
                accountNumber = result.getAccountNumber();
                accountName = result.getAccountName();
                transferAmount = result.getAmount();
                transferDescription = result.getDescription();
                payment = paymentDAO.findByBookingID(bookingID);
            } else if (error == null) {
                error = result.isSuccess()
                        ? "Khong the luu phien thanh toan PayOS."
                        : result.getMessage();
            }
        }

        if (payment != null && payment.isPaid()) {
            clearPaymentSession(session, bookingID);
            qrCode = null;
            checkoutUrl = null;
            bankName = null;
            accountNumber = null;
            accountName = null;
            transferAmount = null;
            transferDescription = null;
        }

        request.setAttribute("bookingSummary", summary);
        request.setAttribute("payment", payment);
        request.setAttribute("payosConfigured", payOSService.isConfigured());
        request.setAttribute("paymentQrAvailable", !isBlank(qrCode) || !isBlank(checkoutUrl));
        request.setAttribute("paymentCheckoutUrl", checkoutUrl);
        request.setAttribute("paymentBankName", bankName);
        request.setAttribute("paymentAccountNumber", accountNumber);
        request.setAttribute("paymentAccountName", accountName);
        request.setAttribute("paymentTransferAmount",
                transferAmount == null ? amount.setScale(0, RoundingMode.HALF_UP).longValue() : transferAmount);
        request.setAttribute("paymentTransferDescription", transferDescription);
        request.setAttribute("message", message);
        request.setAttribute("error", error);
        request.getRequestDispatcher("/views/customer/payment.jsp").forward(request, response);
    }

    private Payment ensurePaymentRecord(int bookingID, Map<String, Object> summary, BigDecimal amount) {
        Payment payment = paymentDAO.findByBookingID(bookingID);
        if (payment == null
                && isProcessingBooking(summary)
                && amount.signum() > 0
                && bookingDAO.hasPayableReservationForPayment(bookingID)) {
            payment = paymentDAO.createPending(bookingID, amount);
        }
        return payment;
    }

    private void handleStatusPolling(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding(StandardCharsets.UTF_8.name());

        int bookingID = parsePositiveInt(request.getParameter("bookingID"));
        Map<String, Object> summary = bookingDAO.getBookingSummaryByID(bookingID);
        if (!canAccessBooking(request, summary, bookingID)) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.getWriter().write("{\"success\":false,\"message\":\"forbidden\"}");
            return;
        }

        BigDecimal amount = getAmount(summary);
        Payment paymentBeforeSync = ensurePaymentRecord(bookingID, summary, amount);
        boolean expired = expirePendingPaymentIfNeeded(bookingID, paymentBeforeSync, request.getSession(false));
        boolean changed = paymentDAO.synchronizeBookingState(bookingID);
        if (changed || expired) {
            clearPaymentSession(request.getSession(false), bookingID);
        }

        summary = bookingDAO.getBookingSummaryByID(bookingID);
        Payment payment = paymentDAO.findByBookingID(bookingID);

        String bookingStatus = summary == null ? "" : String.valueOf(summary.get("status"));
        String paymentStatus = payment == null ? "" : payment.getStatus();
        String message = resolvePollingMessage(paymentBeforeSync, payment, bookingStatus);

        response.getWriter().write("{\"success\":true"
                + ",\"changed\":" + (changed || expired)
                + ",\"message\":\"" + escapeJson(message) + "\""
                + ",\"bookingStatus\":\"" + escapeJson(bookingStatus) + "\""
                + ",\"paymentStatus\":\"" + escapeJson(paymentStatus) + "\""
                + "}");
    }

    private void renderQrCode(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int bookingID = parsePositiveInt(request.getParameter("bookingID"));
        Map<String, Object> summary = bookingDAO.getBookingSummaryByID(bookingID);
        if (!canAccessBooking(request, summary, bookingID)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        HttpSession session = request.getSession(false);
        String qrCode = sessionString(session, QR_SESSION_PREFIX + bookingID);
        if (isBlank(qrCode)) {
            Payment payment = paymentDAO.findByBookingID(bookingID);
            if (payment != null && !isBlank(payment.getCheckoutUrl())) {
                qrCode = payment.getCheckoutUrl();
                if (session != null) {
                    session.setAttribute(QR_SESSION_PREFIX + bookingID, qrCode);
                    session.setAttribute(CHECKOUT_SESSION_PREFIX + bookingID, payment.getCheckoutUrl());
                }
            }
        }
        if (isBlank(qrCode)) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        try {
            BitMatrix matrix = new MultiFormatWriter().encode(
                    qrCode, BarcodeFormat.QR_CODE, 280, 280
            );
            BufferedImage image = new BufferedImage(280, 280, BufferedImage.TYPE_INT_RGB);
            for (int y = 0; y < 280; y++) {
                for (int x = 0; x < 280; x++) {
                    image.setRGB(x, y, matrix.get(x, y) ? 0x111827 : 0xFFFFFF);
                }
            }
            response.setContentType("image/png");
            response.setHeader("Cache-Control", "no-store");
            ImageIO.write(image, "PNG", response.getOutputStream());
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void handleWebhook(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding(StandardCharsets.UTF_8.name());

        try {
            WebhookData data = payOSService.verifyWebhook(readBody(request));
            int bookingID = data.getOrderCode() == null ? 0 : data.getOrderCode().intValue();
            Map<String, Object> summary = bookingDAO.getBookingSummaryByID(bookingID);

            if (summary == null) {
                writeJson(response, HttpServletResponse.SC_OK, "Webhook hop le");
                return;
            }
            if (!"00".equals(data.getCode()) || !isExpectedAmount(summary, data.getAmount())) {
                paymentDAO.markFailedByBookingID(
                        bookingID, "Webhook PayOS co trang thai hoac so tien khong khop."
                );
                writeJson(response, HttpServletResponse.SC_BAD_REQUEST, "Du lieu thanh toan khong khop");
                return;
            }

            String reference = data.getReference() == null
                    ? String.valueOf(bookingID)
                    : data.getReference();
            if (!paymentDAO.markPaidByBookingID(bookingID, reference)) {
                writeJson(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "Khong the cap nhat thanh toan");
                return;
            }
            bookingDAO.syncPendingBookingFromPaidPayment(bookingID);
            writeJson(response, HttpServletResponse.SC_OK, "Da xac nhan thanh toan");
        } catch (Exception e) {
            writeJson(response, HttpServletResponse.SC_BAD_REQUEST, "Webhook khong hop le");
        }
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

    private boolean isBookingPayable(Map<String, Object> summary) {
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

    private boolean expirePendingPaymentIfNeeded(int bookingID, Payment payment, HttpSession session) {
        boolean cancelled = paymentDAO.expirePendingPayment(bookingID);
        if (cancelled) {
            clearPaymentSession(session, bookingID);
        }
        return cancelled;
    }

    private boolean cancelBookingForInvalidReservation(int bookingID, Payment payment) {
        return payment != null && PaymentDAO.STATUS_PENDING.equalsIgnoreCase(payment.getStatus())
                ? bookingDAO.releasePendingPaymentReservation(
                bookingID,
                false,
                "Khong con du slot hop le de tiep tuc thanh toan."
        )
                : bookingDAO.updateBookingStatus(bookingID, Booking.STATUS_CANCELLED);
    }

    private String resolvePollingMessage(Payment paymentBeforeSync,
                                         Payment paymentAfterSync,
                                         String bookingStatus) {
        if (paymentAfterSync != null && paymentAfterSync.isPaid()) {
            return "paid";
        }

        boolean wasPending = paymentBeforeSync != null
                && PaymentDAO.STATUS_PENDING.equalsIgnoreCase(paymentBeforeSync.getStatus());
        boolean isCancelled = Booking.isCancelledStatus(bookingStatus)
                || (paymentAfterSync != null
                && PaymentDAO.STATUS_CANCELLED.equalsIgnoreCase(paymentAfterSync.getStatus()));
        return wasPending && isCancelled ? "expired" : "";
    }

    private void clearPaymentSession(HttpSession session, int bookingID) {
        if (session != null) {
            session.removeAttribute(QR_SESSION_PREFIX + bookingID);
            session.removeAttribute(CHECKOUT_SESSION_PREFIX + bookingID);
            session.removeAttribute(BANK_NAME_SESSION_PREFIX + bookingID);
            session.removeAttribute(ACCOUNT_NUMBER_SESSION_PREFIX + bookingID);
            session.removeAttribute(ACCOUNT_NAME_SESSION_PREFIX + bookingID);
            session.removeAttribute(AMOUNT_SESSION_PREFIX + bookingID);
            session.removeAttribute(DESCRIPTION_SESSION_PREFIX + bookingID);
        }
    }

    private String sessionString(HttpSession session, String key) {
        Object value = session == null ? null : session.getAttribute(key);
        return value instanceof String ? (String) value : null;
    }

    private Long sessionLong(HttpSession session, String key) {
        Object value = session == null ? null : session.getAttribute(key);
        return value instanceof Number ? ((Number) value).longValue() : null;
    }

    private boolean isBlank(String value) {
        return value == null || value.isBlank();
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
                + ",\"message\":\"" + escapeJson(message) + "\"}");
    }

    private String escapeJson(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("\\", "\\\\").replace("\"", "\\\"");
    }

    @SuppressWarnings("unchecked")
    private boolean isGuestBookingAllowed(HttpSession session, int bookingID) {
        Object guestBookings = session.getAttribute("guestBookingIDs");
        return guestBookings instanceof Set
                && ((Set<Integer>) guestBookings).contains(bookingID);
    }
}
