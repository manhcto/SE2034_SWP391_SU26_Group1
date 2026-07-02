package vn.edu.fpt.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.DAO.BookingDAO;
import vn.edu.fpt.model.Booking;
import vn.edu.fpt.model.User;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "BookingListController", urlPatterns = {"/booking-list"})
public class BookingListController extends HttpServlet {

    private static final String BOOKING_LIST_PAGE = "/views/customer/booking-list.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        User currentUser = getCurrentUser(request);

        if (currentUser == null) {
            request.getSession().setAttribute("redirectAfterLogin", "/booking-list");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        BookingDAO bookingDAO = new BookingDAO();
        List<Booking> allBookings = bookingDAO.getAllBookings();
        List<Booking> myBookings = filterBookingsForCurrentUser(allBookings, currentUser);

        request.setAttribute("bookingList", myBookings);
        request.getRequestDispatcher(BOOKING_LIST_PAGE).forward(request, response);
    }

    private User getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);

        if (session == null) {
            return null;
        }

        Object userObject = session.getAttribute("user");

        if (userObject instanceof User) {
            return (User) userObject;
        }

        return null;
    }

    private List<Booking> filterBookingsForCurrentUser(List<Booking> allBookings, User currentUser) {
        List<Booking> myBookings = new ArrayList<>();

        if (allBookings == null || currentUser == null) {
            return myBookings;
        }

        Integer currentUserID = currentUser.getUserID();
        String currentEmail = safe(currentUser.getEmail());

        for (Booking booking : allBookings) {
            if (booking == null) {
                continue;
            }

            if (isOwner(booking, currentUserID, currentEmail)) {
                myBookings.add(booking);
            }
        }

        return myBookings;
    }

    private boolean isOwner(Booking booking, Integer currentUserID, String currentEmail) {
        if (booking.getUserID() != null
                && currentUserID != null
                && booking.getUserID().equals(currentUserID)) {
            return true;
        }

        return booking.getUserID() == null
                && !currentEmail.isEmpty()
                && currentEmail.equalsIgnoreCase(safe(booking.getEmail()));
    }

    private String safe(String value) {
        return value == null ? "" : value.trim();
    }
}