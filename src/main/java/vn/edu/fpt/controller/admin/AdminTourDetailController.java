package vn.edu.fpt.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.DAO.TourDAO;
import vn.edu.fpt.DAO.TourScheduleDAO;
import vn.edu.fpt.model.Tour;
import vn.edu.fpt.model.TourSchedule;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "AdminTourDetailController", urlPatterns = "/admin/tour/detail")
public class AdminTourDetailController extends HttpServlet {

    private TourDAO tourDAO;
    private TourScheduleDAO scheduleDAO;

    @Override
    public void init() {
        tourDAO = new TourDAO();
        scheduleDAO = new TourScheduleDAO();
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
        tour.setScheduleList(scheduleDAO.getSchedulesByTourId(tourID));
        tourDAO.loadManagedImages(tour);
        List<String> readinessErrors = tourDAO.getTourReadinessErrors(tourID);
        BigDecimal approvalDisplayPrice = resolveDisplayAdultPrice(tour);

        request.setAttribute("tour", tour);
        request.setAttribute("readinessErrors", readinessErrors);
        request.setAttribute("approvalDisplayPrice", approvalDisplayPrice);
        request.setAttribute("hasApprovalDisplayPrice", approvalDisplayPrice.compareTo(BigDecimal.ZERO) > 0);
        request.setAttribute("message", normalize(request.getParameter("message")));
        request.getRequestDispatcher("/views/admin/admin-tour-detail.jsp").forward(request, response);
    }

    private BigDecimal resolveDisplayAdultPrice(Tour tour) {
        if (tour != null && tour.getScheduleList() != null) {
            BigDecimal lowestSchedulePrice = null;
            for (TourSchedule schedule : tour.getScheduleList()) {
                BigDecimal adultPrice = schedule == null ? null : schedule.getAdultPrice();
                if (adultPrice == null || adultPrice.compareTo(BigDecimal.ZERO) <= 0) {
                    continue;
                }
                if (lowestSchedulePrice == null || adultPrice.compareTo(lowestSchedulePrice) < 0) {
                    lowestSchedulePrice = adultPrice;
                }
            }
            if (lowestSchedulePrice != null) {
                return lowestSchedulePrice;
            }
        }
        return tour == null || tour.getAdultPrice() == null ? BigDecimal.ZERO : tour.getAdultPrice();
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
