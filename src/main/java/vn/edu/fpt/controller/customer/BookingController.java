package vn.edu.fpt.controller.customer;

import vn.edu.fpt.DAO.BookingDAO;
import vn.edu.fpt.DAO.AdministrativeUnitDAO;
import vn.edu.fpt.DAO.TourDAO;
import vn.edu.fpt.DAO.UserVoucherDAO;
import vn.edu.fpt.model.AdministrativeUnit;
import vn.edu.fpt.model.Booking;
import vn.edu.fpt.model.Tour;
import vn.edu.fpt.model.TourSchedule;
import vn.edu.fpt.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.UUID;

@WebServlet(name = "BookingController", urlPatterns = {"/booking"})
@MultipartConfig(
        maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 6 * 1024 * 1024
)
public class BookingController extends HttpServlet {
    private final AdministrativeUnitDAO administrativeUnitDAO = new AdministrativeUnitDAO();
    private final UserVoucherDAO userVoucherDAO = new UserVoucherDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String scheduleIDRaw = getTrimValue(request, "tourScheduleID");
        if (scheduleIDRaw.isEmpty() || !scheduleIDRaw.matches("\\d+")) {
            response.sendRedirect(request.getContextPath() + "/tour?message=selectSchedule");
            return;
        }

        int scheduleID;
        try {
            scheduleID = Integer.parseInt(scheduleIDRaw);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/tour?message=selectSchedule");
            return;
        }

        TourDAO tourDAO = new TourDAO();
        TourSchedule schedule = tourDAO.getScheduleById(scheduleID);
        if (schedule == null || !"Open".equalsIgnoreCase(schedule.getScheduleStatus()) || schedule.getRemainingSeats() <= 0) {
            response.sendRedirect(request.getContextPath() + "/tour?message=scheduleUnavailable");
            return;
        }

        Tour tour = tourDAO.getPublishedTourById(schedule.getTourID());
        if (tour == null) {
            response.sendRedirect(request.getContextPath() + "/tour?message=notFound");
            return;
        }

        request.setAttribute("selectedTour", tour);
        request.setAttribute("selectedSchedule", schedule);

        if ("1".equals(request.getParameter("checkout"))) {
            HttpSession session = request.getSession(false);
            User user = session == null ? null : (User) session.getAttribute("user");

            if (user == null) {
                request.getSession().setAttribute("redirectAfterLogin",
                        request.getRequestURI() + (request.getQueryString() == null ? "" : "?" + request.getQueryString()));
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            // Prefill contact info from the user's profile (still editable on the form)
            request.setAttribute("firstName", user.getFirstName());
            request.setAttribute("lastName", user.getLastName());
            request.setAttribute("email", user.getEmail());
            request.setAttribute("phone", user.getPhone());

            prepareCheckoutAttributes(request, user, tour, schedule);
            request.getRequestDispatcher("/views/customer/checkout.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/views/customer/booking.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<String> errors = new ArrayList<>();

        try {
            String firstName = getTrimValue(request, "firstName");
            String lastName = getTrimValue(request, "lastName");
            String email = getTrimValue(request, "email");
            String phone = getTrimValue(request, "phone");

            String identityNumber = normalizeIdentityNumber(request.getParameter("identityNumber"));
            Part identityImagePart = request.getPart("identityImage");

            String streetAddress = getTrimValue(request, "streetAddress");
            int administrativeUnitID = parsePositiveInt(request.getParameter("administrativeUnitID"));
            AdministrativeUnit administrativeUnit = administrativeUnitID > 0
                    ? administrativeUnitDAO.getActiveUnitByID(administrativeUnitID)
                    : null;

            String note = getTrimValue(request, "note");

            String numberAdultRaw = getTrimValue(request, "numberAdult");
            String numberChildrenRaw = getTrimValue(request, "numberChildren");
            String tourScheduleIDRaw = getTrimValue(request, "tourScheduleID");

            Integer userVoucherID = parseNullablePositiveInt(request.getParameter("userVoucherID"));

            // Validate customer information
            if (firstName.isEmpty()) {
                errors.add("Họ và tên đệm không được để trống.");
            } else if (firstName.length() > 100) {
                errors.add("Họ và tên đệm không được vượt quá 100 ký tự.");
            } else if (!firstName.matches("^[\\p{L}\\s]+$")) {
                errors.add("Họ và tên đệm chỉ được chứa chữ cái và khoảng trắng.");
            }

            if (lastName.isEmpty()) {
                errors.add("Tên không được để trống.");
            } else if (lastName.length() > 100) {
                errors.add("Tên không được vượt quá 100 ký tự.");
            } else if (!lastName.matches("^[\\p{L}\\s]+$")) {
                errors.add("Tên chỉ được chứa chữ cái và khoảng trắng.");
            }

            if (email.isEmpty()) {
                errors.add("Email không được để trống.");
            } else if (email.length() > 255) {
                errors.add("Email không được vượt quá 255 ký tự.");
            } else if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
                errors.add("Email không hợp lệ. Ví dụ đúng: nguyenvana@gmail.com.");
            }

            if (phone.isEmpty()) {
                errors.add("Số điện thoại không được để trống.");
            } else if (!phone.matches("^0\\d{9}$")) {
                errors.add("Số điện thoại phải có đúng 10 chữ số và bắt đầu bằng số 0.");
            }

            // Validate identity (CCCD/CMND) - same rules as accommodation booking
            if (!isValidIdentityNumber(identityNumber)) {
                errors.add("CCCD/CMND phải gồm đúng 9 hoặc 12 chữ số.");
            }

            if (!isValidIdentityImage(identityImagePart)) {
                errors.add("Ảnh CCCD/CMND chưa hợp lệ. Vui lòng chọn ảnh JPG, JPEG, PNG hoặc WEBP, dung lượng tối đa 5MB.");
            }

            // Validate address parts
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

            String address = "";

            if (!streetAddress.isEmpty() && administrativeUnit != null) {
                address = streetAddress + ", " + administrativeUnit.getWardName()
                        + ", " + administrativeUnit.getProvinceName();

                if (address.length() > 255) {
                    errors.add("Địa chỉ đầy đủ không được vượt quá 255 ký tự.");
                }
            }

            if (note.length() > 1000) {
                errors.add("Ghi chú không được vượt quá 1000 ký tự.");
            }

            int numberAdult = 0;
            int numberChildren = 0;
            int tourScheduleID = 0;

            // Validate numberAdult
            if (numberAdultRaw.isEmpty()) {
                errors.add("Số người lớn không được để trống.");
            } else if (!numberAdultRaw.matches("\\d+")) {
                errors.add("Số người lớn chỉ được nhập số tự nhiên 1, 2, 3... Không nhập số thập phân hoặc ký tự khác.");
            } else {
                try {
                    numberAdult = Integer.parseInt(numberAdultRaw);

                    if (numberAdult < 1) {
                        errors.add("Số người lớn phải lớn hơn hoặc bằng 1.");
                    }

                } catch (NumberFormatException e) {
                    errors.add("Số người lớn không hợp lệ.");
                }
            }

            // Validate numberChildren
            if (numberChildrenRaw.isEmpty()) {
                errors.add("Số trẻ em không được để trống.");
            } else if (!numberChildrenRaw.matches("\\d+")) {
                errors.add("Số trẻ em chỉ được nhập số tự nhiên 0, 1, 2, 3... Không nhập số thập phân hoặc ký tự khác.");
            } else {
                try {
                    numberChildren = Integer.parseInt(numberChildrenRaw);

                    if (numberChildren < 0) {
                        errors.add("Số trẻ em không được nhỏ hơn 0.");
                    }

                } catch (NumberFormatException e) {
                    errors.add("Số trẻ em không hợp lệ.");
                }
            }

            // Validate tourScheduleID
            if (tourScheduleIDRaw.isEmpty()) {
                errors.add("Mã lịch trình tour không được để trống.");
            } else if (!tourScheduleIDRaw.matches("\\d+")) {
                errors.add("Mã lịch trình tour không hợp lệ.");
            } else {
                try {
                    tourScheduleID = Integer.parseInt(tourScheduleIDRaw);

                    if (tourScheduleID <= 0) {
                        errors.add("Mã lịch trình tour không hợp lệ.");
                    }

                } catch (NumberFormatException e) {
                    errors.add("Mã lịch trình tour không hợp lệ.");
                }
            }

            BookingDAO dao = new BookingDAO();

            double adultPrice = 0;
            double childrenPrice = 0;
            double totalPrice = 0;
            double unitPriceForDetail = 0;

            // Calculate price from database
            if (errors.isEmpty()) {
                double[] prices = dao.getTourPricesBySchedule(tourScheduleID);

                if (prices == null) {
                    errors.add("Lịch trình tour không tồn tại. Vui lòng chọn lại tour.");
                } else {
                    adultPrice = prices[0];
                    childrenPrice = prices[1];

                    totalPrice = numberAdult * adultPrice + numberChildren * childrenPrice;

                    int totalQuantity = numberAdult + numberChildren;
                    unitPriceForDetail = totalQuantity > 0 ? totalPrice / totalQuantity : adultPrice;

                    if (totalPrice <= 0) {
                        errors.add("Tổng tiền không hợp lệ.");
                    }
                }
            }

            // Check remaining seats
            if (errors.isEmpty()) {
                int totalGuests = numberAdult + numberChildren;
                int remainingSeats = dao.getRemainingSeats(tourScheduleID);

                if (remainingSeats < 0) {
                    errors.add("Không thể kiểm tra số chỗ còn lại của tour.");
                } else if (totalGuests > remainingSeats) {
                    errors.add("Số khách đặt vượt quá số chỗ còn lại. Tour hiện chỉ còn " + remainingSeats + " chỗ.");
                }
            }

            if (!errors.isEmpty()) {
                request.setAttribute("errorList", errors);

                request.setAttribute("firstName", firstName);
                request.setAttribute("lastName", lastName);
                request.setAttribute("email", email);
                request.setAttribute("phone", phone);
                request.setAttribute("identityNumber", identityNumber);

                request.setAttribute("streetAddress", streetAddress);
                request.setAttribute("selectedAdministrativeUnitID", administrativeUnitID);
                request.setAttribute("selectedUserVoucherID", userVoucherID);

                request.setAttribute("note", note);
                request.setAttribute("numberAdult", numberAdultRaw);
                request.setAttribute("numberChildren", numberChildrenRaw);

                forwardBackToCheckout(request, response, user, tourScheduleID);
                return;
            }

            // Save identity image (same storage as accommodation booking)
            String identityImageUrl = saveIdentityImage(request, identityImagePart, user.getUserID());

            if (identityImageUrl == null) {
                errors.add("Không thể lưu ảnh CCCD/CMND. Vui lòng thử lại.");
                request.setAttribute("errorList", errors);
                forwardBackToCheckout(request, response, user, tourScheduleID);
                return;
            }

            String bookingCode = "TR-" + UUID.randomUUID()
                    .toString().substring(0, 8).toUpperCase();

            Booking booking = new Booking();
            booking.setBookingCode(bookingCode);
            booking.setBookingType("Tour");
            booking.setFirstName(firstName);
            booking.setLastName(lastName);
            booking.setEmail(email);
            booking.setPhone(phone);
            booking.setAddress(address);
            booking.setNote(note.isEmpty() ? null : note);
            booking.setIdentityNumber(identityNumber);
            booking.setIdentityImageUrl(identityImageUrl);
            booking.setNumberAdult(numberAdult);
            booking.setNumberChildren(numberChildren);
            booking.setTotalPrice(totalPrice);
            booking.setBookedForOther(false);
            booking.setUserID(user.getUserID());

            // Save booking (voucher applied inside the transaction) and redirect to payment
            int bookingID = dao.insertTourBookingWithVoucherReturnID(
                    booking, tourScheduleID, unitPriceForDetail, userVoucherID, user.getUserID());

            if (bookingID == -2) {
                errors.add("Voucher không còn hợp lệ hoặc đã được sử dụng. Vui lòng chọn lại voucher.");
                request.setAttribute("errorList", errors);
                forwardBackToCheckout(request, response, user, tourScheduleID);
                return;
            }

            if (bookingID > 0) {
                response.sendRedirect(request.getContextPath() + "/payment?bookingID=" + bookingID);
            } else {
                request.setAttribute("error", "Không thể lưu đơn hàng. Có thể số chỗ vừa được người khác đặt hết. Vui lòng thử lại!");
                forwardBackToCheckout(request, response, user, tourScheduleID);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi hệ thống nghiêm trọng!");
            forwardBackToCheckout(request, response, user,
                    parsePositiveInt(request.getParameter("tourScheduleID")));
        }
    }

    // Reload tour/schedule/voucher/address data then forward back to checkout.jsp
    private void forwardBackToCheckout(HttpServletRequest request, HttpServletResponse response,
                                       User user, int tourScheduleID)
            throws ServletException, IOException {

        Tour tour = null;
        TourSchedule schedule = null;

        if (tourScheduleID > 0) {
            TourDAO tourDAO = new TourDAO();
            schedule = tourDAO.getScheduleById(tourScheduleID);

            if (schedule != null) {
                tour = tourDAO.getPublishedTourById(schedule.getTourID());
            }
        }

        if (schedule == null || tour == null) {
            response.sendRedirect(request.getContextPath() + "/tour?message=scheduleUnavailable");
            return;
        }

        request.setAttribute("selectedTour", tour);
        request.setAttribute("selectedSchedule", schedule);

        prepareCheckoutAttributes(request, user, tour, schedule);
        request.getRequestDispatcher("/views/customer/checkout.jsp").forward(request, response);
    }

    // Data shared by both GET render and POST error re-render
    private void prepareCheckoutAttributes(HttpServletRequest request, User user,
                                           Tour tour, TourSchedule schedule) {

        BigDecimal adultPrice = schedule.getAdultPrice() != null
                ? schedule.getAdultPrice()
                : (tour.getAdultPrice() != null ? tour.getAdultPrice() : BigDecimal.ZERO);

        BigDecimal childPrice = schedule.getChildPrice() != null
                ? schedule.getChildPrice()
                : (tour.getChildrenPrice() != null ? tour.getChildrenPrice() : BigDecimal.ZERO);

        // Load vouchers against the max possible order so the client script
        // can enable/disable them by minOrderAmount as guest counts change.
        BigDecimal maxPossibleTotal = adultPrice.multiply(
                BigDecimal.valueOf(Math.max(1, schedule.getRemainingSeats())));

        request.setAttribute("checkoutAdultPrice", adultPrice);
        request.setAttribute("checkoutChildPrice", childPrice);
        request.setAttribute("applicableVouchers",
                userVoucherDAO.getApplicableSavedVouchers(user.getUserID(), "Tour", maxPossibleTotal));
        request.setAttribute("administrativeUnitsJson",
                toAdministrativeUnitsJson(administrativeUnitDAO.getActiveUnits()));
    }

    private String getTrimValue(HttpServletRequest request, String paramName) {
        String value = request.getParameter(paramName);
        return value == null ? "" : value.trim();
    }

    private int parsePositiveInt(String value) {
        try {
            int number = Integer.parseInt(value == null ? "" : value.trim());
            return number > 0 ? number : 0;
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    private Integer parseNullablePositiveInt(String value) {
        int number = parsePositiveInt(value);
        return number > 0 ? number : null;
    }

    private String normalizeIdentityNumber(String value) {
        return value == null ? "" : value.replaceAll("\\D", "");
    }

    private boolean isValidIdentityNumber(String identityNumber) {
        String normalized = normalizeIdentityNumber(identityNumber);
        return normalized.length() == 9 || normalized.length() == 12;
    }

    private boolean isValidIdentityImage(Part part) {
        if (part == null || part.getSize() <= 0 || part.getSize() > 5 * 1024 * 1024) {
            return false;
        }

        String contentType = part.getContentType();
        String normalizedType = contentType == null ? "" : contentType.toLowerCase(Locale.ROOT);
        if ("image/jpeg".equals(normalizedType)
                || "image/jpg".equals(normalizedType)
                || "image/pjpeg".equals(normalizedType)
                || "image/png".equals(normalizedType)
                || "image/webp".equals(normalizedType)) {
            return true;
        }

        String fileName = part.getSubmittedFileName();
        String normalizedName = fileName == null ? "" : fileName.toLowerCase(Locale.ROOT);
        return normalizedName.endsWith(".jpg")
                || normalizedName.endsWith(".jpeg")
                || normalizedName.endsWith(".png")
                || normalizedName.endsWith(".webp");
    }

    private String saveIdentityImage(HttpServletRequest request, Part part, int userID) throws IOException {
        if (!isValidIdentityImage(part)) {
            return null;
        }

        String uploadRoot = getServletContext().getRealPath("/uploads/identity");
        if (uploadRoot == null) {
            return null;
        }

        Path uploadDir = Paths.get(uploadRoot);
        Files.createDirectories(uploadDir);

        String extension = getIdentityImageExtension(part);
        String fileName = "identity_" + userID + "_" + UUID.randomUUID() + extension;
        Path target = uploadDir.resolve(fileName).normalize();

        if (!target.startsWith(uploadDir)) {
            return null;
        }

        part.write(target.toString());
        return "uploads/identity/" + fileName;
    }

    private String getIdentityImageExtension(Part part) {
        String contentType = part == null ? "" : part.getContentType();
        String normalizedType = contentType == null ? "" : contentType.toLowerCase(Locale.ROOT);

        if ("image/png".equals(normalizedType)) {
            return ".png";
        }

        if ("image/webp".equals(normalizedType)) {
            return ".webp";
        }

        String fileName = part == null ? "" : part.getSubmittedFileName();
        String normalizedName = fileName == null ? "" : fileName.toLowerCase(Locale.ROOT);

        if (normalizedName.endsWith(".png")) {
            return ".png";
        }

        if (normalizedName.endsWith(".webp")) {
            return ".webp";
        }

        if (normalizedName.endsWith(".jpeg")) {
            return ".jpeg";
        }

        return ".jpg";
    }

    private String toAdministrativeUnitsJson(List<AdministrativeUnit> units) {
        StringBuilder json = new StringBuilder("[");

        if (units != null) {
            for (int i = 0; i < units.size(); i++) {
                AdministrativeUnit unit = units.get(i);

                if (i > 0) {
                    json.append(',');
                }

                json.append('{')
                        .append("\"administrativeUnitID\":").append(unit.getAdministrativeUnitID()).append(',')
                        .append("\"provinceCode\":\"").append(jsonEscape(unit.getProvinceCode())).append("\",")
                        .append("\"provinceName\":\"").append(jsonEscape(unit.getProvinceName())).append("\",")
                        .append("\"wardType\":\"").append(jsonEscape(unit.getWardType())).append("\",")
                        .append("\"wardName\":\"").append(jsonEscape(unit.getWardName())).append("\"")
                        .append('}');
            }
        }

        json.append(']');
        return json.toString();
    }

    private String jsonEscape(String value) {
        if (value == null) {
            return "";
        }

        StringBuilder escaped = new StringBuilder(value.length() + 16);

        for (int i = 0; i < value.length(); i++) {
            char c = value.charAt(i);

            switch (c) {
                case '"':
                    escaped.append("\\\"");
                    break;
                case '\\':
                    escaped.append("\\\\");
                    break;
                case '\b':
                    escaped.append("\\b");
                    break;
                case '\f':
                    escaped.append("\\f");
                    break;
                case '\n':
                    escaped.append("\\n");
                    break;
                case '\r':
                    escaped.append("\\r");
                    break;
                case '\t':
                    escaped.append("\\t");
                    break;
                case '<':
                    escaped.append("\\u003C");
                    break;
                case '>':
                    escaped.append("\\u003E");
                    break;
                case '&':
                    escaped.append("\\u0026");
                    break;
                default:
                    if (c < 0x20) {
                        escaped.append(String.format("\\u%04x", (int) c));
                    } else {
                        escaped.append(c);
                    }
                    break;
            }
        }

        return escaped.toString();
    }
}
