package vn.edu.fpt.controller.customer;

import vn.edu.fpt.DAO.BookingDAO;
import vn.edu.fpt.DAO.AdministrativeUnitDAO;
import vn.edu.fpt.DAO.TourDAO;
import vn.edu.fpt.model.AdministrativeUnit;
import vn.edu.fpt.model.Booking;
import vn.edu.fpt.model.Tour;
import vn.edu.fpt.model.TourSchedule;
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
import java.util.UUID;

@WebServlet(name = "BookingController", urlPatterns = {"/booking"})
public class BookingController extends HttpServlet {
    private final AdministrativeUnitDAO administrativeUnitDAO = new AdministrativeUnitDAO();

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
            request.setAttribute("administrativeUnitList", administrativeUnitDAO.getActiveUnits());
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

        List<String> errors = new ArrayList<>();

        try {
            String firstName = getTrimValue(request, "firstName");
            String lastName = getTrimValue(request, "lastName");
            String email = getTrimValue(request, "email");
            String phone = getTrimValue(request, "phone");

            String streetAddress = getTrimValue(request, "streetAddress");
            int administrativeUnitID = parsePositiveInt(request.getParameter("administrativeUnitID"));
            AdministrativeUnit administrativeUnit = administrativeUnitID > 0
                    ? administrativeUnitDAO.getActiveUnitByID(administrativeUnitID)
                    : null;

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

                request.setAttribute("streetAddress", streetAddress);
                request.setAttribute("selectedAdministrativeUnitID", administrativeUnitID);
                request.setAttribute("administrativeUnitList", administrativeUnitDAO.getActiveUnits());

                request.setAttribute("note", note);

                request.getRequestDispatcher("/views/customer/checkout.jsp").forward(request, response);
                return;
            }

            boolean isBookedForOther = isBookedForOtherStr != null && isBookedForOtherStr.equals("on");
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
}
