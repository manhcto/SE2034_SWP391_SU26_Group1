package vn.edu.fpt.utils;

import java.time.LocalDate;
import java.time.LocalTime;

public final class ParseUtils {
    private ParseUtils() {
    }

    public static String trim(String value) {
        return value == null ? null : value.trim();
    }

    public static int parseInt(String value, int defaultValue) {
        try {
            if (value == null || value.trim().isEmpty()) {
                return defaultValue;
            }
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException ex) {
            return defaultValue;
        }
    }

    public static Integer parseNullableInt(String value) {
        try {
            if (value == null || value.trim().isEmpty()) {
                return null;
            }
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException ex) {
            return null;
        }
    }

    public static int parseMoney(String value) {
        if (value == null || value.trim().isEmpty()) {
            return 0;
        }

        String normalized = value.replace(".", "")
                .replace(",", "")
                .replace("VND", "")
                .replace("₫", "")
                .trim();

        return parseInt(normalized, 0);
    }

    public static LocalDate parseDate(String value) {
        try {
            if (value == null || value.trim().isEmpty()) {
                return null;
            }
            return LocalDate.parse(value.trim());
        } catch (Exception ex) {
            return null;
        }
    }

    public static LocalTime parseTime(String value) {
        try {
            if (value == null || value.trim().isEmpty()) {
                return null;
            }
            return LocalTime.parse(value.trim());
        } catch (Exception ex) {
            return null;
        }
    }
}
