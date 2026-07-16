package vn.edu.fpt.controller.staff;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.DAO.TourDAO;
import vn.edu.fpt.model.Tour;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "SubmitTourForApprovalController", urlPatterns = "/staff/tour/submit")
public class SubmitTourForApprovalController extends HttpServlet {

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
        Tour tour = tourDAO.getTourById(tourID);

        if (tour == null) {
            response.sendRedirect(request.getContextPath() + "/staff/tour?message=notFound");
            return;
        }

        if (!("Draft".equals(tour.getStatus()) || "Rejected".equals(tour.getStatus()))) {
            response.sendRedirect(request.getContextPath() + "/staff/tour/detail?id=" + tourID + "&message=submitInvalidStatus");
            return;
        }

        List<String> errors = tourDAO.getTourReadinessErrors(tourID);
        if (!errors.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/staff/tour/detail?id=" + tourID + "&message=submitNotReady");
            return;
        }

        boolean success = tourDAO.submitTourForApproval(tourID);
        response.sendRedirect(request.getContextPath() + "/staff/tour/detail?id=" + tourID
                + "&message=" + (success ? "submitted" : "submitFail"));
    }

    private int parseInt(String raw) {
        try {
            return Integer.parseInt(raw);
        } catch (Exception e) {
            return -1;
        }
    }
}
