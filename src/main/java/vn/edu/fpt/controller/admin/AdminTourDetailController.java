package vn.edu.fpt.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.DAO.TourDAO;
import vn.edu.fpt.model.Tour;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminTourDetailController", urlPatterns = "/admin/tour/detail")
public class AdminTourDetailController extends HttpServlet {

    private TourDAO tourDAO;

    @Override
    public void init() {
        tourDAO = new TourDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int tourID = parseInt(request.getParameter("id"));
        if (tourID <= 0) {
            response.sendRedirect(request.getContextPath() + "/admin/tour?message=notFound");
            return;
        }

        Tour tour = tourDAO.getTourById(tourID);
        if (tour == null) {
            response.sendRedirect(request.getContextPath() + "/admin/tour?message=notFound");
            return;
        }

        tour.setItineraryList(tourDAO.getItinerariesByTourId(tourID));
        tour.setScheduleList(tourDAO.getSchedulesByTourId(tourID));
        tourDAO.loadManagedImages(tour);
        List<String> readinessErrors = tourDAO.getTourReadinessErrors(tourID);

        request.setAttribute("tour", tour);
        request.setAttribute("readinessErrors", readinessErrors);
        request.setAttribute("message", normalize(request.getParameter("message")));
        request.getRequestDispatcher("/views/admin/admin-tour-detail.jsp").forward(request, response);
    }

    private int parseInt(String raw) {
        try {
            return Integer.parseInt(raw);
        } catch (Exception e) {
            return -1;
        }
    }

    private String normalize(String value) {
        return value == null ? "" : value.trim();
    }
}
