package vn.edu.fpt.controller.staff;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.model.Tour;
import vn.edu.fpt.model.TourSchedule;

import java.io.IOException;

@WebServlet(name = "DetailTourScheduleController", urlPatterns = {"/staff/tour/schedule/detail"})
public class DetailTourScheduleController extends StaffTourScheduleSupport {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        Integer scheduleID = parsePositiveInt(request.getParameter("id"));
        TourSchedule schedule = scheduleID == null ? null : tourDAO.getScheduleById(scheduleID);

        if (schedule == null) {
            response.sendRedirect(request.getContextPath() + "/staff/tour?message=notFound");
            return;
        }

        Tour tour = getTourForSchedule(schedule.getTourID());
        if (tour == null) {
            response.sendRedirect(request.getContextPath() + "/staff/tour?message=notFound");
            return;
        }

        alignScheduleStatusForTour(tour, schedule);

        request.setAttribute("tour", tour);
        request.setAttribute("schedule", schedule);
        request.setAttribute("messageCode", safeTrim(request.getParameter("message")));
        request.setAttribute("canEditSchedule", canEditScheduleForTour(tour) && !isFinalScheduleStatus(schedule.getScheduleStatus()));
        request.setAttribute("canCloseSchedule", canManageScheduleForTour(tour)
                && ("Open".equals(schedule.getScheduleStatus()) || "Planned".equals(schedule.getScheduleStatus())));
        request.getRequestDispatcher("/views/staff/tour-schedule-detail.jsp")
                .forward(request, response);
    }
}
