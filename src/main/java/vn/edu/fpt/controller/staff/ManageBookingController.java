package vn.edu.fpt.controller.staff;

import vn.edu.fpt.DAO.BookingDAO;
import vn.edu.fpt.model.Booking;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "ManageBookingController", urlPatterns = {
        "/staff/booking",
        "/staff/booking-edit",
        "/staff/booking-delete"
})
public class ManageBookingController extends HttpServlet {

    private static final String STAFF_BOOKING_LIST_PAGE = "/views/staff/staff-booking-list.jsp";
    private static final String STAFF_BOOKING_EDIT_PAGE = "/views/staff/staff-booking-edit.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String path = request.getServletPath();

        switch (path) {
            case "/staff/booking":
                showBookingList(request, response);
                break;

            case "/staff/booking-edit":
                showEditBookingForm(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/staff/booking");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String path = request.getServletPath();

        switch (path) {
            case "/staff/booking-edit":
                updateBooking(request, response);
                break;

            case "/staff/booking-delete":
                deleteBooking(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/staff/booking");
                break;
        }
    }

    private void showBookingList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        BookingDAO bookingDAO = new BookingDAO();
        List<Booking> bookingList = bookingDAO.getAllBookings();

        request.setAttribute("bookingList", bookingList);
        request.getRequestDispatcher(STAFF_BOOKING_LIST_PAGE).forward(request, response);
    }

    private void showEditBookingForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String bookingIDRaw = request.getParameter("bookingID");

        if (bookingIDRaw == null || bookingIDRaw.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/staff/booking");
            return;
        }

        try {
            int bookingID = Integer.parseInt(bookingIDRaw.trim());

            BookingDAO bookingDAO = new BookingDAO();
            Booking booking = bookingDAO.getBookingByID(bookingID);

            if (booking == null) {
                request.setAttribute("error", "Không tìm thấy booking cần sửa.");
                request.getRequestDispatcher(STAFF_BOOKING_EDIT_PAGE).forward(request, response);
                return;
            }

            request.setAttribute("booking", booking);
            request.getRequestDispatcher(STAFF_BOOKING_EDIT_PAGE).forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/staff/booking");
        }
    }

    private void updateBooking(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<String> errors = new ArrayList<>();

        String bookingIDRaw = getTrimValue(request, "bookingID");
        String status = getTrimValue(request, "status");

        int bookingID = parsePositiveInt(bookingIDRaw, "Booking ID", errors);

        if (!isValidStatus(status)) {
            errors.add("Trạng thái booking không hợp lệ.");
        }

        BookingDAO bookingDAO = new BookingDAO();
        Booking oldBooking = null;

        if (bookingID > 0) {
            oldBooking = bookingDAO.getBookingByID(bookingID);

            if (oldBooking == null) {
                errors.add("Booking không tồn tại trong hệ thống.");
            }
        }

        if (!errors.isEmpty()) {
            if (oldBooking != null) {
                oldBooking.setStatus(status);
            }

            request.setAttribute("errors", errors);
            request.setAttribute("booking", oldBooking);
            request.getRequestDispatcher(STAFF_BOOKING_EDIT_PAGE).forward(request, response);
            return;
        }

        boolean updated = bookingDAO.updateBookingStatus(bookingID, status);

        if (updated) {
            response.sendRedirect(request.getContextPath() + "/staff/booking?success=updated");
        } else {
            errors.add("Cập nhật booking thất bại. Vui lòng thử lại.");

            request.setAttribute("errors", errors);
            if (oldBooking != null) {
                oldBooking.setStatus(status);
            }
            request.setAttribute("booking", oldBooking);
            request.getRequestDispatcher(STAFF_BOOKING_EDIT_PAGE).forward(request, response);
        }
    }

    private void deleteBooking(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        List<String> errors = new ArrayList<>();
        String bookingIDRaw = getTrimValue(request, "bookingID");

        int bookingID = parsePositiveInt(bookingIDRaw, "Booking ID", errors);

        if (!errors.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/staff/booking?error=deleteFailed");
            return;
        }

        BookingDAO bookingDAO = new BookingDAO();
        boolean deleted = bookingDAO.deleteBookingByID(bookingID);

        if (deleted) {
            response.sendRedirect(request.getContextPath() + "/staff/booking?success=deleted");
        } else {
            response.sendRedirect(request.getContextPath() + "/staff/booking?error=deleteFailed");
        }
    }

    private String getTrimValue(HttpServletRequest request, String paramName) {
        String value = request.getParameter(paramName);
        return value == null ? "" : value.trim();
    }

    private int parsePositiveInt(String rawValue, String fieldName, List<String> errors) {
        if (rawValue == null || rawValue.trim().isEmpty()) {
            errors.add(fieldName + " không được để trống.");
            return -1;
        }

        String valueText = rawValue.trim();

        if (!valueText.matches("\\d+")) {
            errors.add(fieldName + " chỉ được nhập số, không được nhập chữ hoặc ký tự đặc biệt.");
            return -1;
        }

        try {
            int value = Integer.parseInt(valueText);

            if (value <= 0) {
                errors.add(fieldName + " phải lớn hơn 0.");
                return -1;
            }

            return value;

        } catch (NumberFormatException e) {
            errors.add(fieldName + " không hợp lệ.");
            return -1;
        }
    }

    private int parseNumberWithMinValue(String rawValue, String fieldName, int minValue, List<String> errors) {
        if (rawValue == null || rawValue.trim().isEmpty()) {
            errors.add(fieldName + " không được để trống.");
            return 0;
        }

        String valueText = rawValue.trim();

        if (!valueText.matches("\\d+")) {
            errors.add(fieldName + " chỉ được nhập số tự nhiên.");
            return 0;
        }

        try {
            int value = Integer.parseInt(valueText);

            if (value < minValue) {
                errors.add(fieldName + " phải lớn hơn hoặc bằng " + minValue + ".");
                return 0;
            }

            return value;

        } catch (NumberFormatException e) {
            errors.add(fieldName + " không hợp lệ.");
            return 0;
        }
    }

    private void validateRequired(String value, String fieldName, List<String> errors) {
        if (value == null || value.trim().isEmpty()) {
            errors.add(fieldName + " không được để trống.");
        }
    }

    private void validateLength(String value, String fieldName, int maxLength, List<String> errors) {
        if (value != null && value.length() > maxLength) {
            errors.add(fieldName + " không được vượt quá " + maxLength + " ký tự.");
        }
    }

    private boolean isValidBookedForOther(String value) {
        return "true".equals(value) || "false".equals(value);
    }

    private boolean isValidStatus(String status) {
        return "Pending".equals(status)
                || "Confirmed".equals(status)
                || "Cancelled".equals(status)
                || "Completed".equals(status);
    }

    private String buildFullAddress(String streetAddress, String district, String city) {
        if (streetAddress.isEmpty() || district.isEmpty() || city.isEmpty()) {
            return "";
        }

        return streetAddress + ", " + district + ", " + city;
    }

    private void setAddressPartsToRequest(HttpServletRequest request, String address) {
        String[] parts = splitAddress(address);

        request.setAttribute("streetAddress", parts[0]);
        request.setAttribute("district", parts[1]);
        request.setAttribute("city", parts[2]);
    }

    private String[] splitAddress(String address) {
        String streetAddress = address == null ? "" : address.trim();
        String district = "";
        String city = "";

        if (!streetAddress.isEmpty()) {
            String foundCity = findCityFromAddress(streetAddress);

            if (!foundCity.isEmpty()) {
                city = foundCity;
                streetAddress = removeLastAddressPart(streetAddress, foundCity);
            }

            String foundDistrict = findDistrictFromAddress(streetAddress);

            if (!foundDistrict.isEmpty()) {
                district = foundDistrict;
                streetAddress = removeLastAddressPart(streetAddress, foundDistrict);
            }
        }

        return new String[]{streetAddress.trim(), district, city};
    }

    private String findCityFromAddress(String address) {
        String[] cities = {
                "Hà Nội", "Hồ Chí Minh", "Đà Nẵng", "Hải Phòng", "Cần Thơ",
                "Quảng Ninh", "Ninh Bình", "Huế", "Khánh Hòa", "Lâm Đồng"
        };

        for (String city : cities) {
            if (address.endsWith(", " + city) || address.equals(city)) {
                return city;
            }
        }

        return "";
    }

    private String findDistrictFromAddress(String address) {
        String[] districts = {
                "Quận Ba Đình", "Quận Hoàn Kiếm", "Quận Tây Hồ", "Quận Long Biên",
                "Quận Cầu Giấy", "Quận Đống Đa", "Quận Hai Bà Trưng", "Quận Hoàng Mai",
                "Quận Thanh Xuân", "Quận Nam Từ Liêm", "Quận Bắc Từ Liêm", "Quận Hà Đông",
                "Huyện Thanh Trì", "Huyện Gia Lâm", "Huyện Đông Anh", "Huyện Sóc Sơn"
        };

        for (String district : districts) {
            if (address.endsWith(", " + district) || address.equals(district)) {
                return district;
            }
        }

        return "";
    }

    private String removeLastAddressPart(String address, String part) {
        if (address.endsWith(", " + part)) {
            return address.substring(0, address.length() - part.length() - 2).trim();
        }

        if (address.equals(part)) {
            return "";
        }

        return address;
    }

    private boolean isValidDistrict(String district) {
        return "Quận Ba Đình".equals(district)
                || "Quận Hoàn Kiếm".equals(district)
                || "Quận Tây Hồ".equals(district)
                || "Quận Long Biên".equals(district)
                || "Quận Cầu Giấy".equals(district)
                || "Quận Đống Đa".equals(district)
                || "Quận Hai Bà Trưng".equals(district)
                || "Quận Hoàng Mai".equals(district)
                || "Quận Thanh Xuân".equals(district)
                || "Quận Nam Từ Liêm".equals(district)
                || "Quận Bắc Từ Liêm".equals(district)
                || "Quận Hà Đông".equals(district)
                || "Huyện Thanh Trì".equals(district)
                || "Huyện Gia Lâm".equals(district)
                || "Huyện Đông Anh".equals(district)
                || "Huyện Sóc Sơn".equals(district);
    }

    private boolean isValidCity(String city) {
        return "Hà Nội".equals(city)
                || "Hồ Chí Minh".equals(city)
                || "Đà Nẵng".equals(city)
                || "Hải Phòng".equals(city)
                || "Cần Thơ".equals(city)
                || "Quảng Ninh".equals(city)
                || "Ninh Bình".equals(city)
                || "Huế".equals(city)
                || "Khánh Hòa".equals(city)
                || "Lâm Đồng".equals(city);
    }
}
