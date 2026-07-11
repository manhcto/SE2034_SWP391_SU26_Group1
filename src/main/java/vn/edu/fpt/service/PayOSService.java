package vn.edu.fpt.service;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.math.BigDecimal;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.Locale;
import java.util.Map;
import java.util.TreeMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class PayOSService {
    private static final String PAYOS_API_URL = "https://api-merchant.payos.vn/v2/payment-requests";

    private final HttpClient httpClient = HttpClient.newBuilder()
            .connectTimeout(Duration.ofSeconds(10))
            .build();

    public boolean isConfigured() {
        return !isBlank(getConfig("PAYOS_CLIENT_ID"))
                && !isBlank(getConfig("PAYOS_API_KEY"))
                && !isBlank(getConfig("PAYOS_CHECKSUM_KEY"))
                && !isBlank(getConfig("APP_BASE_URL"));
    }

    public PaymentResult createPaymentLink(int bookingID, BigDecimal amount, String description) {
        if (!isConfigured()) {
            return PaymentResult.failed("Chua cau hinh PayOS. Can PAYOS_CLIENT_ID, PAYOS_API_KEY, PAYOS_CHECKSUM_KEY va APP_BASE_URL.");
        }

        try {
            long amountValue = amount.setScale(0, java.math.RoundingMode.HALF_UP).longValue();
            String baseUrl = trimTrailingSlash(getConfig("APP_BASE_URL"));
            String returnUrl = baseUrl + "/payment/return?bookingID=" + bookingID;
            String cancelUrl = baseUrl + "/payment/cancel?bookingID=" + bookingID;
            String safeDescription = normalizeDescription(description);

            Map<String, String> signatureData = new TreeMap<>();
            signatureData.put("amount", String.valueOf(amountValue));
            signatureData.put("cancelUrl", cancelUrl);
            signatureData.put("description", safeDescription);
            signatureData.put("orderCode", String.valueOf(bookingID));
            signatureData.put("returnUrl", returnUrl);

            String json = "{"
                    + "\"orderCode\":" + bookingID + ","
                    + "\"amount\":" + amountValue + ","
                    + "\"description\":\"" + escapeJson(safeDescription) + "\","
                    + "\"returnUrl\":\"" + escapeJson(returnUrl) + "\","
                    + "\"cancelUrl\":\"" + escapeJson(cancelUrl) + "\","
                    + "\"signature\":\"" + hmacSha256(toSignaturePayload(signatureData), getConfig("PAYOS_CHECKSUM_KEY")) + "\""
                    + "}";

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(PAYOS_API_URL))
                    .timeout(Duration.ofSeconds(20))
                    .header("Content-Type", "application/json")
                    .header("x-client-id", getConfig("PAYOS_CLIENT_ID"))
                    .header("x-api-key", getConfig("PAYOS_API_KEY"))
                    .POST(HttpRequest.BodyPublishers.ofString(json, StandardCharsets.UTF_8))
                    .build();

            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));
            if (response.statusCode() < 200 || response.statusCode() >= 300) {
                return PaymentResult.failed("PayOS tra ve HTTP " + response.statusCode() + ".");
            }

            String checkoutUrl = extractJsonString(response.body(), "checkoutUrl");
            if (isBlank(checkoutUrl)) {
                String desc = extractJsonString(response.body(), "desc");
                return PaymentResult.failed(isBlank(desc) ? "Khong lay duoc checkout URL tu PayOS." : desc);
            }

            return PaymentResult.success(checkoutUrl);
        } catch (Exception e) {
            return PaymentResult.failed("Khong the tao link PayOS: " + e.getMessage());
        }
    }

    public boolean isPaidWebhook(String body) {
        String success = extractJsonBooleanOrString(body, "success");
        String code = extractJsonString(body, "code");
        return "true".equalsIgnoreCase(success) && "00".equals(code);
    }

    public int extractOrderCode(String body) {
        String value = extractJsonNumberOrString(body, "orderCode");
        if (isBlank(value)) {
            return 0;
        }

        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    public long extractAmount(String body) {
        String value = extractJsonNumberOrString(body, "amount");
        if (isBlank(value)) {
            return 0;
        }

        try {
            return Long.parseLong(value);
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    private String getConfig(String key) {
        String value = System.getProperty(key);
        if (isBlank(value)) {
            value = System.getenv(key);
        }
        return value == null ? "" : value.trim();
    }

    private String toSignaturePayload(Map<String, String> data) {
        StringBuilder builder = new StringBuilder();
        for (Map.Entry<String, String> entry : data.entrySet()) {
            if (builder.length() > 0) {
                builder.append('&');
            }
            builder.append(entry.getKey()).append('=').append(entry.getValue());
        }
        return builder.toString();
    }

    private String hmacSha256(String data, String key) throws Exception {
        Mac mac = Mac.getInstance("HmacSHA256");
        mac.init(new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA256"));
        byte[] bytes = mac.doFinal(data.getBytes(StandardCharsets.UTF_8));

        StringBuilder result = new StringBuilder();
        for (byte item : bytes) {
            result.append(String.format(Locale.ROOT, "%02x", item));
        }
        return result.toString();
    }

    private String normalizeDescription(String description) {
        String value = description == null ? "Thanh toan WonderVN" : description.trim();
        return value.length() > 25 ? value.substring(0, 25) : value;
    }

    private String trimTrailingSlash(String value) {
        while (value.endsWith("/")) {
            value = value.substring(0, value.length() - 1);
        }
        return value;
    }

    private String escapeJson(String value) {
        return value == null ? "" : value
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }

    private String extractJsonString(String json, String key) {
        Pattern pattern = Pattern.compile("\"" + Pattern.quote(key) + "\"\\s*:\\s*\"([^\"]*)\"");
        Matcher matcher = pattern.matcher(json);
        return matcher.find() ? matcher.group(1) : "";
    }

    private String extractJsonNumberOrString(String json, String key) {
        String stringValue = extractJsonString(json, key);
        if (!isBlank(stringValue)) {
            return stringValue;
        }

        Pattern pattern = Pattern.compile("\"" + Pattern.quote(key) + "\"\\s*:\\s*([0-9]+)");
        Matcher matcher = pattern.matcher(json);
        return matcher.find() ? matcher.group(1) : "";
    }

    private String extractJsonBooleanOrString(String json, String key) {
        String stringValue = extractJsonString(json, key);
        if (!isBlank(stringValue)) {
            return stringValue;
        }

        Pattern pattern = Pattern.compile("\"" + Pattern.quote(key) + "\"\\s*:\\s*(true|false)", Pattern.CASE_INSENSITIVE);
        Matcher matcher = pattern.matcher(json);
        return matcher.find() ? matcher.group(1) : "";
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
