package vn.edu.fpt.controller.customer;

import vn.edu.fpt.DAO.BookingDAO;
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
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@WebServlet(name = "BookingController", urlPatterns = {"/booking"})
public class BookingController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        request.getRequestDispatcher("/views/customer/booking.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        List<String> errors = new ArrayList<>();

        try {
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
                rememberGuestBooking(currentSession, bookingID, booking.getUserID());
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

    private String getTrimValue(HttpServletRequest request, String paramName) {
        String value = request.getParameter(paramName);
        return value == null ? "" : value.trim();
    }

    private boolean isValidDistrict(String district) {
        return district != null && !district.trim().isEmpty();
    }

    private boolean isValidCity(String city) {
        return city != null && !city.trim().isEmpty();
    }

    @SuppressWarnings("unchecked")
    private void rememberGuestBooking(HttpSession session, int bookingID, Integer userID) {
        if (session == null || bookingID <= 0 || userID != null) {
            return;
        }

        Object existing = session.getAttribute("guestBookingIDs");
        Set<Integer> guestBookingIDs;

        if (existing instanceof Set) {
            guestBookingIDs = (Set<Integer>) existing;
        } else {
            guestBookingIDs = new HashSet<>();
        }

        guestBookingIDs.add(bookingID);
        session.setAttribute("guestBookingIDs", guestBookingIDs);
    }
}
