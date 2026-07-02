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

@WebServlet(name = "BookingEditController", urlPatterns = {"/booking-edit"})
public class BookingEditController extends HttpServlet {

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

        int bookingID = parsePositiveInt(request.getParameter("bookingID"));

        if (bookingID <= 0) {
            response.sendRedirect(request.getContextPath() + "/booking-list");
            return;
        }

        BookingDAO bookingDAO = new BookingDAO();
        Booking booking = bookingDAO.getBookingByID(bookingID);

        if (booking == null || !isOwner(booking, currentUser)) {
            response.sendRedirect(request.getContextPath() + "/booking-list");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/booking-summary?bookingID=" + bookingID);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        doGet(request, response);
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

    private boolean isOwner(Booking booking, User currentUser) {
        if (booking == null || currentUser == null) {
            return false;
        }

        Integer bookingUserID = booking.getUserID();
        Integer currentUserID = currentUser.getUserID();

        if (bookingUserID != null
                && currentUserID != null
                && bookingUserID > 0
                && currentUserID > 0
                && bookingUserID.equals(currentUserID)) {
            return true;
        }

        return (bookingUserID == null || bookingUserID <= 0)
                && !safe(currentUser.getEmail()).isEmpty()
                && safe(currentUser.getEmail()).equalsIgnoreCase(safe(booking.getEmail()));
    }

    private int parsePositiveInt(String rawValue) {
        if (rawValue == null || rawValue.trim().isEmpty()) {
            return 0;
        }

        try {
            int value = Integer.parseInt(rawValue.trim());
            return value > 0 ? value : 0;
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    private String safe(String value) {
        return value == null ? "" : value.trim();
    }
}