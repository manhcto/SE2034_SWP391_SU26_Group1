package vn.edu.fpt.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import vn.payos.PayOS;
import vn.payos.model.v2.paymentRequests.CreatePaymentLinkRequest;
import vn.payos.model.webhooks.Webhook;
import vn.payos.model.webhooks.WebhookData;

import java.math.BigDecimal;

public class PayOSService {
    private final ObjectMapper objectMapper = new ObjectMapper();

    public boolean isConfigured() {
        return !isBlank(getConfig("PAYOS_CLIENT_ID"))
                && !isBlank(getConfig("PAYOS_API_KEY"))
                && !isBlank(getConfig("PAYOS_CHECKSUM_KEY"))
                && !isBlank(getConfig("APP_BASE_URL"));
    }

    public PaymentResult createPaymentLink(int bookingID, BigDecimal amount, String description) {
        if (!isConfigured()) {
            return PaymentResult.failed(
                    "Chưa cấu hình PayOS. Cần PAYOS_CLIENT_ID, PAYOS_API_KEY, "
                            + "PAYOS_CHECKSUM_KEY và APP_BASE_URL."
            );
        }

        PayOS payOS = createClient();
        try {
            String baseUrl = trimTrailingSlash(getConfig("APP_BASE_URL"));
            CreatePaymentLinkRequest paymentRequest = CreatePaymentLinkRequest.builder()
                    .orderCode((long) bookingID)
                    .amount(amount.setScale(0, java.math.RoundingMode.HALF_UP).longValueExact())
                    .description(normalizeDescription(description))
                    .cancelUrl(baseUrl + "/payment/cancel?bookingID=" + bookingID)
                    .returnUrl(baseUrl + "/payment/return?bookingID=" + bookingID)
                    .build();

            var response = payOS.paymentRequests().create(paymentRequest);
            return PaymentResult.success(response.getCheckoutUrl());
        } catch (Exception e) {
            return PaymentResult.failed("Không thể tạo liên kết PayOS: " + e.getMessage());
        } finally {
            payOS.close();
        }
    }

    public WebhookData verifyWebhook(String requestBody) throws Exception {
        if (!isConfigured()) {
            throw new IllegalStateException("PayOS chưa được cấu hình.");
        }

        Webhook webhook = objectMapper.readValue(requestBody, Webhook.class);
        PayOS payOS = createClient();
        try {
            return payOS.webhooks().verify(webhook);
        } finally {
            payOS.close();
        }
    }

    private PayOS createClient() {
        return new PayOS(
                getConfig("PAYOS_CLIENT_ID"),
                getConfig("PAYOS_API_KEY"),
                getConfig("PAYOS_CHECKSUM_KEY")
        );
    }

    private String getConfig(String key) {
        String value = System.getProperty(key);
        if (isBlank(value)) {
            value = System.getenv(key);
        }
        return value == null ? "" : value.trim();
    }

    private String normalizeDescription(String description) {
        String value = isBlank(description) ? "WonderVN booking" : description.trim();
        return value.length() > 25 ? value.substring(0, 25) : value;
    }

    private String trimTrailingSlash(String value) {
        String result = value;
        while (result.endsWith("/")) {
            result = result.substring(0, result.length() - 1);
        }
        return result;
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
