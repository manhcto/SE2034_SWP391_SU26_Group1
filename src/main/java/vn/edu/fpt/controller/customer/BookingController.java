package vn.edu.fpt.controller.customer;

import vn.edu.fpt.DAO.BookingDAO;
import vn.edu.fpt.DAO.VehicleDAO;
import vn.edu.fpt.model.Booking;
import vn.edu.fpt.model.User;
import vn.edu.fpt.model.Vehicle;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "BookingController", urlPatterns = {"/booking"})
public class BookingController extends HttpServlet {

    private final BookingDAO bookingDAO = new BookingDAO();
    private final VehicleDAO vehicleDAO = new VehicleDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        if (isVehicleBookingRequest(request)) {
            showVehicleBookingPage(request, response);
            return;
        }

        request.getRequestDispatcher("/views/customer/booking.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        List<String> errors = new ArrayList<>();

        try {
            if (isVehiclePost(request)) {
                handleVehicleBooking(request, response);
                return;
            }

            String firstName = getTrimValue(request, "firstName");
            String lastName = getTrimValue(request, "lastName");
            String email = getTrimValue(request, "email");
            String phone = getTrimValue(request, "phone");

            String streetAddress = getTrimValue(request, "streetAddress");
            String district = getTrimValue(request, "district");
            String city = getTrimValue(request, "city");

            String note = getTrimValue(request, "note");
            String isBookedForOtherStr = request.getParameter("isBookedForOther");

            String numberAdultRaw = getTrimValue(request, "numberAdult");
            String numberChildrenRaw = getTrimValue(request, "numberChildren");
            String tourScheduleIDRaw = getTrimValue(request, "tourScheduleID");

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

            // Validate address parts
            if (streetAddress.isEmpty()) {
                errors.add("Số nhà, đường không được để trống.");
            } else if (streetAddress.length() > 120) {
                errors.add("Số nhà, đường không được vượt quá 120 ký tự.");
            } else if (!streetAddress.matches("^[\\p{L}0-9\\s,./-]+$")) {
                errors.add("Số nhà, đường chỉ được chứa chữ cái, số, khoảng trắng và các ký tự , . / -");
            }

            if (district.isEmpty()) {
                errors.add("Vui lòng chọn quận / huyện.");
            } else if (!isValidDistrict(district)) {
                errors.add("Quận / huyện không hợp lệ.");
            }

            if (city.isEmpty()) {
                errors.add("Vui lòng chọn tỉnh / thành phố.");
            } else if (!isValidCity(city)) {
                errors.add("Tỉnh / thành phố không hợp lệ.");
            }

            String address = "";

            if (!streetAddress.isEmpty() && !district.isEmpty() && !city.isEmpty()) {
                address = streetAddress + ", " + district + ", " + city;

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

                request.setAttribute("streetAddress", streetAddress);
                request.setAttribute("district", district);
                request.setAttribute("city", city);

                request.setAttribute("note", note);

                request.getRequestDispatcher("/views/customer/checkout.jsp").forward(request, response);
                return;
            }

            boolean isBookedForOther = isBookedForOtherStr != null && isBookedForOtherStr.equals("on");
            String bookingCode = "BK-" + System.currentTimeMillis() % 1000000;

            Booking booking = new Booking();
            booking.setBookingCode(bookingCode);
            booking.setBookingType("Tour");
            booking.setFirstName(firstName);
            booking.setLastName(lastName);
            booking.setEmail(email);
            booking.setPhone(phone);
            booking.setAddress(address);
            booking.setNote(note.isEmpty() ? null : note);
            booking.setNumberAdult(numberAdult);
            booking.setNumberChildren(numberChildren);
            booking.setTotalPrice(totalPrice);
            booking.setBookedForOther(isBookedForOther);

            HttpSession session = request.getSession(false);

            if (session != null && session.getAttribute("user") != null) {
                User currentUser = (User) session.getAttribute("user");
                booking.setUserID(currentUser.getUserID());
            }

            // Save booking and redirect to summary
            int bookingID = dao.insertBookingTransactionReturnID(booking, tourScheduleID, unitPriceForDetail);

            if (bookingID > 0) {
                HttpSession currentSession = request.getSession();
                currentSession.setAttribute("successMessage", "Đặt tour thành công! Mã đơn: " + bookingCode);
                response.sendRedirect(request.getContextPath() + "/booking-summary?bookingID=" + bookingID);
            } else {
                request.setAttribute("error", "Không thể lưu đơn hàng. Có thể số chỗ vừa được người khác đặt hết. Vui lòng thử lại!");
                request.getRequestDispatcher("/views/customer/checkout.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi hệ thống nghiêm trọng!");
            request.getRequestDispatcher("/views/customer/checkout.jsp").forward(request, response);
        }
    }

    private boolean isVehicleBookingRequest(HttpServletRequest request) {
        return "vehicle".equalsIgnoreCase(getTrimValue(request, "type"))
                || parsePositiveIntValue(request.getParameter("vehicleID")) > 0;
    }

    private boolean isVehiclePost(HttpServletRequest request) {
        return "Vehicle".equalsIgnoreCase(getTrimValue(request, "bookingType"))
                || "vehicle".equalsIgnoreCase(getTrimValue(request, "type"));
    }

    private void showVehicleBookingPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int vehicleID = parsePositiveIntValue(request.getParameter("vehicleID"));

        if (vehicleID <= 0) {
            vehicleID = parsePositiveIntValue(request.getParameter("id"));
        }

        if (vehicleID <= 0) {
            response.sendRedirect(request.getContextPath() + "/vehicle");
            return;
        }

        Vehicle vehicle = vehicleDAO.getVehicleByIdForCustomer(vehicleID);

        if (vehicle == null) {
            response.sendRedirect(request.getContextPath() + "/vehicle?status=notFound");
            return;
        }

        prepareVehicleBookingPage(request, vehicle);

        request.getRequestDispatcher("/views/customer/booking.jsp").forward(request, response);
    }

    private void handleVehicleBooking(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<String> errors = new ArrayList<>();

        int vehicleID = parsePositiveIntValue(request.getParameter("vehicleID"));
        Vehicle vehicle = vehicleID > 0 ? vehicleDAO.getVehicleByIdForCustomer(vehicleID) : null;

        if (vehicle == null) {
            response.sendRedirect(request.getContextPath() + "/vehicle?status=notFound");
            return;
        }

        String firstName = getTrimValue(request, "firstName");
        String lastName = getTrimValue(request, "lastName");
        String email = getTrimValue(request, "email");
        String phone = getTrimValue(request, "phone");
        String address = getTrimValue(request, "address");
        String pickupDateRaw = getTrimValue(request, "pickupDate");
        String returnDateRaw = getTrimValue(request, "returnDate");
        String note = getTrimValue(request, "note");
        boolean isBookedForOther = request.getParameter("isBookedForOther") != null;

        if (firstName.isEmpty()) {
            errors.add("Ho va ten dem khong duoc de trong.");
        } else if (firstName.length() > 100 || !firstName.matches("^[\\p{L}\\s]+$")) {
            errors.add("Ho va ten dem khong hop le.");
        }

        if (lastName.isEmpty()) {
            errors.add("Ten khong duoc de trong.");
        } else if (lastName.length() > 100 || !lastName.matches("^[\\p{L}\\s]+$")) {
            errors.add("Ten khong hop le.");
        }

        if (email.isEmpty()) {
            errors.add("Email khong duoc de trong.");
        } else if (email.length() > 255
                || !email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
            errors.add("Email khong hop le.");
        }

        if (phone.isEmpty()) {
            errors.add("So dien thoai khong duoc de trong.");
        } else if (!phone.matches("^0\\d{9}$")) {
            errors.add("So dien thoai phai co 10 chu so va bat dau bang 0.");
        }

        if (address.isEmpty()) {
            errors.add("Dia chi lien he khong duoc de trong.");
        } else if (address.length() > 255) {
            errors.add("Dia chi lien he khong duoc vuot qua 255 ky tu.");
        }

        LocalDate pickupDate = null;
        LocalDate returnDate = null;
        int rentalDays = 0;

        try {
            pickupDate = LocalDate.parse(pickupDateRaw);
            returnDate = LocalDate.parse(returnDateRaw);

            LocalDate today = LocalDate.now();

            if (pickupDate.isBefore(today)) {
                errors.add("Ngay nhan xe khong duoc nho hon ngay hien tai.");
            }

            if (!returnDate.isAfter(pickupDate)) {
                errors.add("Ngay tra xe phai sau ngay nhan xe.");
            } else {
                long days = ChronoUnit.DAYS.between(pickupDate, returnDate);

                if (days > 30) {
                    errors.add("Thoi gian thue xe toi da la 30 ngay.");
                } else {
                    rentalDays = (int) days;
                }
            }

        } catch (Exception e) {
            errors.add("Ngay nhan xe hoac ngay tra xe khong hop le.");
        }

        if (note.length() > 1000) {
            errors.add("Ghi chu khong duoc vuot qua 1000 ky tu.");
        }

        if (!errors.isEmpty()) {
            prepareVehicleBookingPage(request, vehicle);
            keepVehicleBookingInput(request, firstName, lastName, email, phone, address,
                    pickupDateRaw, returnDateRaw, note, isBookedForOther);
            request.setAttribute("errorList", errors);
            request.getRequestDispatcher("/views/customer/booking.jsp").forward(request, response);
            return;
        }

        Booking booking = new Booking();
        booking.setBookingCode("VH-" + System.currentTimeMillis() % 1000000);
        booking.setBookingType("Vehicle");
        booking.setFirstName(firstName);
        booking.setLastName(lastName);
        booking.setEmail(email);
        booking.setPhone(phone);
        booking.setAddress(address);
        booking.setNote(note.isEmpty() ? null : note);
        booking.setNumberAdult(1);
        booking.setNumberChildren(0);
        booking.setBookedForOther(isBookedForOther);

        HttpSession session = request.getSession(false);

        if (session != null && session.getAttribute("user") != null) {
            User currentUser = (User) session.getAttribute("user");
            booking.setUserID(currentUser.getUserID());
        }

        int bookingID = bookingDAO.insertVehicleBookingTransactionReturnID(
                booking,
                vehicleID,
                Date.valueOf(pickupDate),
                Date.valueOf(returnDate),
                rentalDays);

        if (bookingID > 0) {
            HttpSession currentSession = request.getSession();
            currentSession.setAttribute("successMessage", "Dat xe thanh cong! Ma don: " + booking.getBookingCode());
            response.sendRedirect(request.getContextPath() + "/booking-summary?bookingID=" + bookingID);
            return;
        }

        prepareVehicleBookingPage(request, vehicle);
        keepVehicleBookingInput(request, firstName, lastName, email, phone, address,
                pickupDateRaw, returnDateRaw, note, isBookedForOther);
        request.setAttribute("error", "Khong the dat xe. Xe co the vua duoc khach khac dat hoac khong con kha dung.");
        request.getRequestDispatcher("/views/customer/booking.jsp").forward(request, response);
    }

    private void prepareVehicleBookingPage(HttpServletRequest request, Vehicle vehicle) {
        LocalDate today = LocalDate.now();

        request.setAttribute("bookingMode", "vehicle");
        request.setAttribute("vehicle", vehicle);
        request.setAttribute("minPickupDate", today.toString());
        request.setAttribute("defaultPickupDate", today.toString());
        request.setAttribute("defaultReturnDate", today.plusDays(1).toString());
    }

    private void keepVehicleBookingInput(
            HttpServletRequest request,
            String firstName,
            String lastName,
            String email,
            String phone,
            String address,
            String pickupDate,
            String returnDate,
            String note,
            boolean isBookedForOther) {

        request.setAttribute("firstName", firstName);
        request.setAttribute("lastName", lastName);
        request.setAttribute("email", email);
        request.setAttribute("phone", phone);
        request.setAttribute("address", address);
        request.setAttribute("pickupDate", pickupDate);
        request.setAttribute("returnDate", returnDate);
        request.setAttribute("note", note);
        request.setAttribute("isBookedForOther", isBookedForOther);
    }

    private int parsePositiveIntValue(String value) {
        try {
            int number = Integer.parseInt(value);
            return number > 0 ? number : 0;
        } catch (Exception e) {
            return 0;
        }
    }

    private String getTrimValue(HttpServletRequest request, String paramName) {
        String value = request.getParameter(paramName);
        return value == null ? "" : value.trim();
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
