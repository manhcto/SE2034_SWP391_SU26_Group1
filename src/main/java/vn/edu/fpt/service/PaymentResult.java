package vn.edu.fpt.service;

public class PaymentResult {
    private final boolean success;
    private final String checkoutUrl;
    private final String message;

    private PaymentResult(boolean success, String checkoutUrl, String message) {
        this.success = success;
        this.checkoutUrl = checkoutUrl;
        this.message = message;
    }

    public static PaymentResult success(String checkoutUrl) {
        return new PaymentResult(true, checkoutUrl, null);
    }

    public static PaymentResult failed(String message) {
        return new PaymentResult(false, null, message);
    }

    public boolean isSuccess() {
        return success;
    }

    public String getCheckoutUrl() {
        return checkoutUrl;
    }

    public String getMessage() {
        return message;
    }
}
