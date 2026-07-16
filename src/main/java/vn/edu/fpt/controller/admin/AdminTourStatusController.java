package vn.edu.fpt.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.DAO.TourDAO;
import vn.edu.fpt.model.User;

import java.io.IOException;

@WebServlet(name = "AdminTourStatusController", urlPatterns = "/admin/tour/status")
public class AdminTourStatusController extends HttpServlet {

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
        String action = request.getParameter("action") == null ? "" : request.getParameter("action").trim();
        User admin = (User) request.getSession().getAttribute("user");

        boolean success = false;
        if ("inactive".equals(action)) {
            success = tourDAO.setTourInactive(tourID);
        } else if ("reactivate".equals(action) && admin != null) {
            success = tourDAO.reactivateTour(tourID, admin.getUserID());
        }

        response.sendRedirect(request.getContextPath() + "/admin/tour/detail?id=" + tourID
                + "&message=" + (success ? "statusUpdated" : "statusFail"));
    }

    private int parseInt(String raw) {
        try {
            return Integer.parseInt(raw);
        } catch (Exception e) {
            return -1;
        }
    }
}
