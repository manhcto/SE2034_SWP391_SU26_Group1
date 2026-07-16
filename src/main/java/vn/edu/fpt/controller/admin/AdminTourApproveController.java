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
import java.util.List;

@WebServlet(name = "AdminTourApproveController", urlPatterns = "/admin/tour/approve")
public class AdminTourApproveController extends HttpServlet {

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

        List<String> errors = tourDAO.getTourReadinessErrors(tourID);
        if (!errors.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/tour/detail?id=" + tourID + "&message=notReady");
            return;
        }

        boolean openSchedules = "on".equalsIgnoreCase(request.getParameter("openSchedules"))
                || "true".equalsIgnoreCase(request.getParameter("openSchedules"));
        boolean success = tourDAO.approveTour(tourID, admin.getUserID(), openSchedules);
        response.sendRedirect(request.getContextPath() + "/admin/tour/detail?id=" + tourID
                + "&message=" + (success ? "approved" : "approveFail"));
    }

    private int parseInt(String raw) {
        try {
            return Integer.parseInt(raw);
        } catch (Exception e) {
            return -1;
        }
    }
}
