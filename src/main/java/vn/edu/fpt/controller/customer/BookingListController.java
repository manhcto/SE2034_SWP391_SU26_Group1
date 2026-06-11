package vn.edu.fpt.controller.customer;

import vn.edu.fpt.DAO.BookingDAO;
import vn.edu.fpt.model.Booking;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "BookingListController", urlPatterns = {"/booking-list"})
public class BookingListController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        BookingDAO bookingDAO = new BookingDAO();
        List<Booking> bookingList = bookingDAO.getAllBookings();

        request.setAttribute("bookingList", bookingList);
        request.getRequestDispatcher("/views/customer/booking-list.jsp").forward(request, response);
    }
}