package vn.edu.fpt.exception;

import java.util.Map;

public class FieldValidationException extends Exception {
    private final Map<String, String> fieldErrors;

    public FieldValidationException(Map<String, String> fieldErrors) {
        super("Dữ liệu không hợp lệ.");
        this.fieldErrors = fieldErrors;
    }

    public Map<String, String> getFieldErrors() {
        return fieldErrors;
    }
}
