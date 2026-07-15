package vn.edu.fpt.service;

public class PaymentResult {
    private final boolean success;
    private final String checkoutUrl;
    private final String qrCode;
    private final String bankName;
    private final String accountNumber;
    private final String accountName;
    private final Long amount;
    private final String description;
    private final String message;

    private PaymentResult(boolean success, String checkoutUrl, String qrCode,
                          String bankName, String accountNumber, String accountName,
                          Long amount, String description, String message) {
        this.success = success;
        this.checkoutUrl = checkoutUrl;
        this.qrCode = qrCode;
        this.bankName = bankName;
        this.accountNumber = accountNumber;
        this.accountName = accountName;
        this.amount = amount;
        this.description = description;
        this.message = message;
    }

    public static PaymentResult success(String checkoutUrl, String qrCode,
                                        String bankName, String accountNumber,
                                        String accountName, Long amount, String description) {
        return new PaymentResult(true, checkoutUrl, qrCode, bankName, accountNumber,
                accountName, amount, description, null);
    }

    public static PaymentResult failed(String message) {
        return new PaymentResult(false, null, null, null, null, null,
                null, null, message);
    }

    public boolean isSuccess() {
        return success;
    }

    public String getCheckoutUrl() {
        return checkoutUrl;
    }

    public String getQrCode() {
        return qrCode;
    }

    public String getBankName() {
        return bankName;
    }

    public String getAccountNumber() {
        return accountNumber;
    }

    public String getAccountName() {
        return accountName;
    }

    public Long getAmount() {
        return amount;
    }

    public String getDescription() {
        return description;
    }

    public String getMessage() {
        return message;
    }
}
