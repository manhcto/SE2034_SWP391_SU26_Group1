package vn.edu.fpt.controller.staff;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.DAO.TourDAO;
import vn.edu.fpt.DAO.TourScheduleDAO;
import vn.edu.fpt.model.Tour;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "DetailTourController", urlPatterns = {"/staff/tour/detail"})
public class DetailTourController extends HttpServlet {

    private final TourDAO tourDAO = new TourDAO();
    private final TourScheduleDAO scheduleDAO = new TourScheduleDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // id tren URL la khoa chinh tourID: /staff/tour/detail?id=...
        Integer tourID = parsePositiveInt(request.getParameter("id"));

        if (tourID == null) {
            response.sendRedirect(request.getContextPath() + "/staff/tour?message=notFound");
            return;
        }

        Tour tour = tourDAO.getTourById(tourID);

        if (tour == null) {
            response.sendRedirect(request.getContextPath() + "/staff/tour?message=notFound");
            return;
        }

        // Trang detail can du 3 nhom du lieu: thong tin tour, lich trinh tung ngay, lich khoi hanh/gia.
        tour.setItineraryList(tourDAO.getItinerariesByTourId(tourID));
        tour.setScheduleList(scheduleDAO.getSchedulesByTourId(tourID));
        tourDAO.loadManagedImages(tour);

        // readinessErrors la checklist nghiep vu truoc khi Staff bam Gui duyet.
        List<String> readinessErrors = tourDAO.checkTourBeforeSubmitForApproval(tourID);
        request.setAttribute("tour", tour);
        request.setAttribute("readinessErrors", readinessErrors);
        request.setAttribute("duplicateStartDateMap", scheduleDAO.getDuplicateScheduleStartDateMap(tourID));
        request.setAttribute("messageCode", safeTrim(request.getParameter("message")));
        request.getRequestDispatcher("/views/staff/tour-detail.jsp")
                .forward(request, response);
    }

    private Integer parsePositiveInt(String value) {
        try {
            if (value == null || value.trim().isEmpty()) {
                return null;
            }

            int number = Integer.parseInt(value.trim());
            return number > 0 ? number : null;
        } catch (Exception e) {
            return null;
        }
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }
}
