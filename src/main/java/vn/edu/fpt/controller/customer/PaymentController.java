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
        "/payment", "/payment/return", "/payment/cancel", "/payment/webhook", "/payment/qr"
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

        if ("/payment/cancel".equals(path)) {
            int bookingID = parsePositiveInt(request.getParameter("bookingID"));
            Map<String, Object> summary = bookingDAO.getBookingSummaryByID(bookingID);
            if (!canAccessBooking(request, summary, bookingID)) {
                response.sendRedirect(request.getContextPath() + "/booking-list");
                return;
            }
            boolean released = bookingDAO.releasePendingPaymentReservation(
                    bookingID, false, "Khách hàng đã hủy phiên thanh toán PayOS."
            );
            clearPaymentSession(request.getSession(false), bookingID);
            showPaymentPage(request, response, null, released
                    ? "Bạn đã hủy thanh toán. Chỗ giữ đã được hoàn lại; payment vẫn ở trạng thái Chờ thanh toán."
                    : "Phiên thanh toán không còn chỗ giữ để hoàn lại.");
            return;
        }

        String message = "/payment/return".equals(path)
                ? "PayOS đã chuyển về WonderVN. Hệ thống đang đối chiếu trạng thái thanh toán."
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
        Payment payment = paymentDAO.findByBookingID(bookingID);
        if (payment == null && isProcessingBooking(summary) && amount.signum() > 0) {
            payment = paymentDAO.createPending(bookingID, amount);
        }

        if (payment != null
                && !payment.isPaid()
                && !payment.isReservationReleased()
                && !isBlank(payment.getCheckoutUrl())
                && payOSService.isPaymentPaid(bookingID, amount)) {
            if (paymentDAO.markPaidByBookingID(bookingID, "PAYOS-" + bookingID)) {
                clearPaymentSession(request.getSession(false), bookingID);
                payment = paymentDAO.findByBookingID(bookingID);
                message = "Thanh toán PayOS thành công. Booking vẫn đang được nhân viên xử lý.";
            }
        }

        if (payment != null && !payment.isPaid() && payment.isExpired()) {
            boolean released = bookingDAO.releasePendingPaymentReservation(
                    bookingID, true, "Hết thời gian giữ chỗ thanh toán 15 phút."
            );
            if (released) {
                clearPaymentSession(request.getSession(false), bookingID);
                payment = paymentDAO.findByBookingID(bookingID);
                error = "Mã thanh toán đã quá hạn. Chỗ giữ đã được hoàn lại; payment vẫn Chờ thanh toán.";
            }
        }

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
        boolean canCreateCheckout = payment != null
                && !payment.isPaid()
                && !payment.isReservationReleased()
                && isBookingPayable(summary);

        if (canCreateCheckout && payOSService.isConfigured()
                && isBlank(qrCode) && isBlank(checkoutUrl)) {
            PaymentResult result = payOSService.createPaymentLink(
                    bookingID, amount, "WonderVN " + bookingID
            );
            if (result.isSuccess()
                    && paymentDAO.prepareCheckout(bookingID, result.getCheckoutUrl())) {
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
                        ? "Không thể lưu phiên thanh toán PayOS."
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
        request.setAttribute("paymentQrAvailable", !isBlank(qrCode));
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
                writeJson(response, HttpServletResponse.SC_OK, "Webhook hợp lệ");
                return;
            }
            if (!"00".equals(data.getCode()) || !isExpectedAmount(summary, data.getAmount())) {
                paymentDAO.markFailedByBookingID(
                        bookingID, "Webhook PayOS có trạng thái hoặc số tiền không khớp."
                );
                writeJson(response, HttpServletResponse.SC_BAD_REQUEST,
                        "Dữ liệu thanh toán không khớp");
                return;
            }

            String reference = data.getReference() == null
                    ? String.valueOf(bookingID)
                    : data.getReference();
            if (!paymentDAO.markPaidByBookingID(bookingID, reference)) {
                writeJson(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "Không thể cập nhật thanh toán");
                return;
            }
            writeJson(response, HttpServletResponse.SC_OK, "Đã xác nhận thanh toán");
        } catch (Exception e) {
            writeJson(response, HttpServletResponse.SC_BAD_REQUEST, "Webhook không hợp lệ");
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
        return status instanceof String
                && !Booking.isCancelledStatus((String) status)
                && !Booking.isCompletedStatus((String) status);
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
                + ",\"message\":\"" + message.replace("\"", "'") + "\"}");
    }

    @SuppressWarnings("unchecked")
    private boolean isGuestBookingAllowed(HttpSession session, int bookingID) {
        Object guestBookings = session.getAttribute("guestBookingIDs");
        return guestBookings instanceof Set
                && ((Set<Integer>) guestBookings).contains(bookingID);
    }
}
