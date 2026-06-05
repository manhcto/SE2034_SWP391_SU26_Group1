package vn.edu.fpt.controller.customer;

import vn.edu.fpt.DAO.BookingDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Map;

@WebServlet(name = "BookingSummaryController", urlPatterns = {"/booking-summary"})
public class BookingSummaryController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String bookingIDRaw = request.getParameter("bookingID");

        if (bookingIDRaw == null || bookingIDRaw.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/booking");
            return;
        }

        try {
            int bookingID = Integer.parseInt(bookingIDRaw);

            BookingDAO dao = new BookingDAO();
            Map<String, Object> bookingSummary = dao.getBookingSummaryByID(bookingID);

            if (bookingSummary == null) {
                request.setAttribute("error", "Không tìm thấy thông tin đặt tour.");
                request.getRequestDispatcher("/views/customer/booking-summary.jsp").forward(request, response);
                return;
            }

            request.setAttribute("bookingSummary", bookingSummary);
            request.getRequestDispatcher("/views/customer/booking-summary.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/booking");
        }
    }
}