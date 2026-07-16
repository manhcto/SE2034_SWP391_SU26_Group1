package vn.edu.fpt.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.DAO.TourDAO;
import vn.edu.fpt.model.Tour;
import vn.edu.fpt.model.User;

import java.io.IOException;

@WebServlet(name = "AdminTourRejectController", urlPatterns = "/admin/tour/reject")
public class AdminTourRejectController extends HttpServlet {

    private TourDAO tourDAO;

    @Override
    public void init() {
        tourDAO = new TourDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        int tourID = parseInt(request.getParameter("tourID"));
        String reason = request.getParameter("rejectionReason") == null ? "" : request.getParameter("rejectionReason").trim();
        User admin = (User) request.getSession().getAttribute("user");

        Tour tour = tourDAO.getTourById(tourID);
        if (admin == null || tour == null) {
            response.sendRedirect(request.getContextPath() + "/admin/tour?message=notFound");
            return;
        }

        if (!"Pending".equals(tour.getStatus())) {
            response.sendRedirect(request.getContextPath() + "/admin/tour/detail?id=" + tourID + "&message=invalidStatus");
            return;
        }

        if (reason.length() < 10 || reason.length() > 500) {
            response.sendRedirect(request.getContextPath() + "/admin/tour/detail?id=" + tourID + "&message=rejectReasonInvalid");
            return;
        }

        boolean success = tourDAO.rejectTour(tourID, admin.getUserID(), reason);
        response.sendRedirect(request.getContextPath() + "/admin/tour/detail?id=" + tourID
                + "&message=" + (success ? "rejected" : "rejectFail"));
    }

    private int parseInt(String raw) {
        try {
            return Integer.parseInt(raw);
        } catch (Exception e) {
            return -1;
        }
    }
}
