package vn.edu.fpt.controller.customer;

import vn.edu.fpt.DAO.BookingDAO;
import vn.edu.fpt.model.Booking;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "BookingController", urlPatterns = {"/booking"})
public class BookingController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/customer/booking.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        List<String> errors = new ArrayList<>();

        try {
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String note = request.getParameter("note");
            String isBookedForOtherStr = request.getParameter("isBookedForOther");

            firstName = firstName == null ? "" : firstName.trim();
            lastName = lastName == null ? "" : lastName.trim();
            email = email == null ? "" : email.trim();
            phone = phone == null ? "" : phone.trim();
            address = address == null ? "" : address.trim();
            note = note == null ? "" : note.trim();

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

            if (address.length() > 255) {
                errors.add("Địa chỉ không được vượt quá 255 ký tự.");
            }

            if (note.length() > 1000) {
                errors.add("Ghi chú không được vượt quá 1000 ký tự.");
            }

            int numberAdult = 0;
            int numberChildren = 0;
            int tourScheduleID = 0;

            // Validate booking quantity and schedule ID
            try {
                numberAdult = Integer.parseInt(request.getParameter("numberAdult"));
                numberChildren = Integer.parseInt(request.getParameter("numberChildren"));
                tourScheduleID = Integer.parseInt(request.getParameter("tourScheduleID"));

                if (numberAdult < 1) {
                    errors.add("Số lượng người lớn tối thiểu phải là 1.");
                }

                if (numberChildren < 0) {
                    errors.add("Số lượng trẻ em không hợp lệ.");
                }

                if (tourScheduleID <= 0) {
                    errors.add("Mã lịch trình tour không hợp lệ.");
                }

            } catch (NumberFormatException e) {
                errors.add("Dữ liệu số hoặc ID tour bị sai định dạng.");
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
                request.setAttribute("address", address);
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
            booking.setAddress(address.isEmpty() ? null : address);
            booking.setNote(note.isEmpty() ? null : note);
            booking.setNumberAdult(numberAdult);
            booking.setNumberChildren(numberChildren);
            booking.setTotalPrice(totalPrice);
            booking.setBookedForOther(isBookedForOther);

            HttpSession session = request.getSession();

            if (session.getAttribute("userID") != null) {
                booking.setUserID((Integer) session.getAttribute("userID"));
            }

            // Save booking and redirect to summary
            int bookingID = dao.insertBookingTransactionReturnID(booking, tourScheduleID, unitPriceForDetail);

            if (bookingID > 0) {
                session.setAttribute("successMessage", "Đặt tour thành công! Mã đơn: " + bookingCode);
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
}