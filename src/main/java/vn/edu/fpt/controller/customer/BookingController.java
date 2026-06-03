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
        response.sendRedirect(request.getContextPath() + "/home.jsp");
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

            if (firstName == null || firstName.trim().isEmpty()) {
                errors.add("Họ và tên đệm không được để trống.");
            }
            if (lastName == null || lastName.trim().isEmpty()) {
                errors.add("Tên không được để trống.");
            }
            if (email == null || !email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {
                errors.add("Email không hợp lệ (Ví dụ đúng: nguyenvena@gmail.com).");
            }
            if (phone == null || !phone.matches("^0\\d{9}$")) {
                errors.add("Số điện thoại phải bao gồm đúng 10 chữ số và bắt đầu bằng số 0.");
            }

            int numberAdult = 0, numberChildren = 0, tourScheduleID = 0;
            double totalPrice = 0, unitPrice = 0;

            try {
                numberAdult = Integer.parseInt(request.getParameter("numberAdult"));
                numberChildren = Integer.parseInt(request.getParameter("numberChildren"));
                totalPrice = Double.parseDouble(request.getParameter("totalPrice"));

                // Lấy 2 trường ẩn vừa thêm vào JSP
                tourScheduleID = Integer.parseInt(request.getParameter("tourScheduleID"));
                unitPrice = Double.parseDouble(request.getParameter("unitPrice"));

                if (numberAdult < 1) errors.add("Số lượng người lớn tối thiểu phải là 1.");
                if (numberChildren < 0) errors.add("Số lượng trẻ em không hợp lệ.");
            } catch (NumberFormatException e) {
                errors.add("Dữ liệu số (số lượng, ID tour hoặc tổng tiền) bị sai định dạng.");
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

            // Gán dữ liệu
            boolean isBookedForOther = (isBookedForOtherStr != null && isBookedForOtherStr.equals("on"));
            String bookingCode = "BK-" + System.currentTimeMillis() % 1000000;

            Booking booking = new Booking();
            booking.setBookingCode(bookingCode);
            booking.setBookingType("Tour");
            booking.setFirstName(firstName.trim());
            booking.setLastName(lastName.trim());
            booking.setEmail(email.trim());
            booking.setPhone(phone.trim());
            booking.setAddress(address.trim());
            booking.setNote(note);
            booking.setNumberAdult(numberAdult);
            booking.setNumberChildren(numberChildren);
            booking.setTotalPrice(totalPrice);
            booking.setBookedForOther(isBookedForOther);

            HttpSession session = request.getSession();
            if (session.getAttribute("userID") != null) {
                booking.setUserID((Integer) session.getAttribute("userID"));
            }

            // Gọi hàm lưu bằng Transaction
            BookingDAO dao = new BookingDAO();
            boolean isSuccess = dao.insertBookingTransaction(booking, tourScheduleID, unitPrice);

            if (isSuccess) {
                session.setAttribute("successMessage", "Đặt tour thành công! Mã đơn: " + bookingCode);
                response.sendRedirect(request.getContextPath() + "/home.jsp");
            } else {
                request.setAttribute("error", "Không thể lưu đơn hàng. Vui lòng thử lại!");
                request.getRequestDispatcher("/views/customer/checkout.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi hệ thống nghiêm trọng!");
            request.getRequestDispatcher("/views/customer/checkout.jsp").forward(request, response);
        }
    }
}