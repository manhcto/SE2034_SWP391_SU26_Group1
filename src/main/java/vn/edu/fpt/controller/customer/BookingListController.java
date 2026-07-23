package vn.edu.fpt.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.DAO.BookingDAO;
import vn.edu.fpt.DAO.PaymentDAO;
import vn.edu.fpt.model.Booking;
import vn.edu.fpt.model.User;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "BookingListController", urlPatterns = {"/booking-list"})
public class BookingListController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("user");

        if (user == null) {
            request.getSession().setAttribute("redirectAfterLogin", "/booking-list");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        PaymentDAO paymentDAO = new PaymentDAO();
        paymentDAO.synchronizeBookingStates();

        BookingDAO bookingDAO = new BookingDAO();
        List<Booking> bookingList = bookingDAO.getBookingsByUserID(user.getUserID());

        request.setAttribute("bookingList", bookingList);
        request.setAttribute("activeAccountTab", "bookings");
        request.getRequestDispatcher("/views/customer/booking-list.jsp").forward(request, response);
    }
}
