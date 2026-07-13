package vn.edu.fpt.controller.customer;

import vn.edu.fpt.DAO.BookingDAO;
import vn.edu.fpt.DAO.AdministrativeUnitDAO;
import vn.edu.fpt.model.AdministrativeUnit;
import vn.edu.fpt.model.Booking;
import vn.edu.fpt.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "BookingEditController", urlPatterns = {"/booking-edit"})
public class BookingEditController extends HttpServlet {

    private static final String EDIT_PAGE = "/views/customer/booking-edit.jsp";
    private final AdministrativeUnitDAO administrativeUnitDAO = new AdministrativeUnitDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        User user = getCurrentUser(request);
        if (user == null) {
            request.getSession().setAttribute("redirectAfterLogin", currentPathWithQuery(request));
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String bookingIDRaw = request.getParameter("bookingID");

        if (bookingIDRaw == null || bookingIDRaw.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/booking-list");
            return;
        }

        try {
            int bookingID = Integer.parseInt(bookingIDRaw);

            BookingDAO bookingDAO = new BookingDAO();
            Booking booking = bookingDAO.getBookingByID(bookingID);

            if (booking == null) {
                request.setAttribute("error", "Không tìm thấy booking cần sửa.");
                request.getRequestDispatcher(EDIT_PAGE).forward(request, response);
                return;
            }

            if (booking.getUserID() == null || !booking.getUserID().equals(user.getUserID())) {
                response.sendRedirect(request.getContextPath() + "/booking-list");
                return;
            }

            setAdministrativeAddressToRequest(request, booking.getAddress());
            request.setAttribute("administrativeUnitList", administrativeUnitDAO.getActiveUnits());

            request.setAttribute("booking", booking);
            request.getRequestDispatcher(EDIT_PAGE).forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/booking-list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        User user = getCurrentUser(request);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<String> errors = new ArrayList<>();

        String bookingIDRaw = request.getParameter("bookingID");
        String firstName = getTrimValue(request, "firstName");
        String lastName = getTrimValue(request, "lastName");
        String email = getTrimValue(request, "email");
        String phone = getTrimValue(request, "phone");

        String streetAddress = getTrimValue(request, "streetAddress");
        int administrativeUnitID = parsePositiveInt(request.getParameter("administrativeUnitID"));
        AdministrativeUnit administrativeUnit = administrativeUnitID > 0
                ? administrativeUnitDAO.getActiveUnitByID(administrativeUnitID)
                : null;
        String address = administrativeUnit == null ? ""
                : streetAddress + ", " + administrativeUnit.getWardName()
                + ", " + administrativeUnit.getProvinceName();

        String note = getTrimValue(request, "note");
        String numberAdultRaw = getTrimValue(request, "numberAdult");
        String numberChildrenRaw = getTrimValue(request, "numberChildren");
        String isBookedForOtherRaw = request.getParameter("isBookedForOther");

        int bookingID = parseBookingID(bookingIDRaw, errors);
        int numberAdult = parseNaturalNumber(numberAdultRaw, "Số người lớn", 1, errors);
        int numberChildren = parseNaturalNumber(numberChildrenRaw, "Số trẻ em", 0, errors);

        validateBookingForm(firstName, lastName, email, phone, streetAddress,
                administrativeUnit, address, note, errors);

        BookingDAO bookingDAO = new BookingDAO();
        Booking oldBooking = null;

        if (bookingID > 0) {
            oldBooking = bookingDAO.getBookingByID(bookingID);

            if (oldBooking == null) {
                errors.add("Booking không tồn tại trong hệ thống.");
            } else if (oldBooking.getUserID() == null || !oldBooking.getUserID().equals(user.getUserID())) {
                errors.add("Bạn không có quyền sửa booking này.");
        } else if (!Booking.isProcessingStatus(oldBooking.getStatus())) {
            errors.add("Chỉ có thể sửa booking khi trạng thái đang xử lý.");
            }
        }

        boolean isBookedForOther = "on".equalsIgnoreCase(isBookedForOtherRaw)
                || "true".equalsIgnoreCase(isBookedForOtherRaw);

        Booking booking = new Booking();
        booking.setBookingID(bookingID);
        booking.setFirstName(firstName);
        booking.setLastName(lastName);
        booking.setEmail(email);
        booking.setPhone(phone);
        booking.setAddress(address);
        booking.setNote(note);
        booking.setNumberAdult(numberAdult);
        booking.setNumberChildren(numberChildren);
        booking.setBookedForOther(isBookedForOther);

        if (oldBooking != null) {
            booking.setBookingCode(oldBooking.getBookingCode());
            booking.setBookingType(oldBooking.getBookingType());
            booking.setStatus(oldBooking.getStatus());
            booking.setBookDate(oldBooking.getBookDate());
            booking.setTotalPrice(oldBooking.getTotalPrice());
            booking.setUserID(oldBooking.getUserID());
            booking.setVoucherID(oldBooking.getVoucherID());
        }

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("booking", booking);
            request.setAttribute("streetAddress", streetAddress);
            request.setAttribute("selectedAdministrativeUnitID", administrativeUnitID);
            request.setAttribute("administrativeUnitList", administrativeUnitDAO.getActiveUnits());
            request.getRequestDispatcher(EDIT_PAGE).forward(request, response);
            return;
        }

        boolean updated = bookingDAO.updateCustomerBooking(booking);

        if (updated) {
            response.sendRedirect(request.getContextPath() + "/booking-summary?bookingID=" + bookingID);
        } else {
            errors.add("Cập nhật booking thất bại. Có thể số chỗ còn lại không đủ hoặc booking không còn ở trạng thái Pending.");

            request.setAttribute("errors", errors);
            request.setAttribute("booking", booking);
            request.setAttribute("streetAddress", streetAddress);
            request.setAttribute("selectedAdministrativeUnitID", administrativeUnitID);
            request.setAttribute("administrativeUnitList", administrativeUnitDAO.getActiveUnits());
            request.getRequestDispatcher(EDIT_PAGE).forward(request, response);
        }
    }

    private String getTrimValue(HttpServletRequest request, String paramName) {
        String value = request.getParameter(paramName);
        return value == null ? "" : value.trim();
    }

    private User getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session == null ? null : (User) session.getAttribute("user");
    }

    private String currentPathWithQuery(HttpServletRequest request) {
        String path = request.getServletPath();
        String query = request.getQueryString();
        return query == null || query.isBlank() ? path : path + "?" + query;
    }

    private int parseBookingID(String bookingIDRaw, List<String> errors) {
        if (bookingIDRaw == null || bookingIDRaw.trim().isEmpty()) {
            errors.add("Thiếu mã booking cần sửa.");
            return -1;
        }

        try {
            int bookingID = Integer.parseInt(bookingIDRaw.trim());

            if (bookingID <= 0) {
                errors.add("Mã booking không hợp lệ.");
                return -1;
            }

            return bookingID;

        } catch (NumberFormatException e) {
            errors.add("Mã booking phải là số.");
            return -1;
        }
    }

    private int parseNaturalNumber(String rawValue, String fieldName, int minValue, List<String> errors) {
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

    private void validateBookingForm(String firstName, String lastName, String email,
                                     String phone, String streetAddress,
                                     AdministrativeUnit administrativeUnit,
                                     String address, String note,
                                     List<String> errors) {

        if (firstName.isEmpty()) {
            errors.add("Vui lòng nhập họ.");
        } else if (firstName.length() > 100) {
            errors.add("Họ không được vượt quá 100 ký tự.");
        } else if (!firstName.matches("^[\\p{L}\\s]+$")) {
            errors.add("Họ chỉ được chứa chữ cái và khoảng trắng.");
        }

        if (lastName.isEmpty()) {
            errors.add("Vui lòng nhập tên.");
        } else if (lastName.length() > 100) {
            errors.add("Tên không được vượt quá 100 ký tự.");
        } else if (!lastName.matches("^[\\p{L}\\s]+$")) {
            errors.add("Tên chỉ được chứa chữ cái và khoảng trắng.");
        }

        if (email.isEmpty()) {
            errors.add("Vui lòng nhập email.");
        } else if (email.length() > 255) {
            errors.add("Email không được vượt quá 255 ký tự.");
        } else if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
            errors.add("Email không đúng định dạng. Ví dụ đúng: example@gmail.com.");
        }

        if (phone.isEmpty()) {
            errors.add("Vui lòng nhập số điện thoại.");
        } else if (!phone.matches("^0\\d{9}$")) {
            errors.add("Số điện thoại phải có 10 chữ số và bắt đầu bằng 0.");
        }

        if (streetAddress.isEmpty()) {
            errors.add("Số nhà, đường không được để trống.");
        } else if (streetAddress.length() > 120) {
            errors.add("Số nhà, đường không được vượt quá 120 ký tự.");
        } else if (!streetAddress.matches("^[\\p{L}0-9\\s,./-]+$")) {
            errors.add("Số nhà, đường chỉ được chứa chữ cái, số, khoảng trắng và các ký tự , . / -");
        }

        if (administrativeUnit == null) {
            errors.add("Vui lòng chọn tỉnh/thành phố và phường/xã hợp lệ.");
        }

        if (address.length() > 255) {
            errors.add("Địa chỉ đầy đủ không được vượt quá 255 ký tự.");
        }

        if (note.length() > 1000) {
            errors.add("Ghi chú không được vượt quá 1000 ký tự.");
        }
    }

    private int parsePositiveInt(String value) {
        try {
            int number = Integer.parseInt(value == null ? "" : value.trim());
            return number > 0 ? number : 0;
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    private void setAdministrativeAddressToRequest(HttpServletRequest request, String address) {
        AdministrativeUnit unit = administrativeUnitDAO.findActiveUnitInAddress(address);
        String streetAddress = address == null ? "" : address.trim();
        if (unit != null) {
            String suffix = unit.getWardName() + ", " + unit.getProvinceName();
            if (streetAddress.endsWith(", " + suffix)) {
                streetAddress = streetAddress.substring(0,
                        streetAddress.length() - suffix.length() - 2).trim();
            } else if (streetAddress.equals(suffix)) {
                streetAddress = "";
            }
            request.setAttribute("selectedAdministrativeUnitID", unit.getAdministrativeUnitID());
        }
        request.setAttribute("streetAddress", streetAddress);
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
