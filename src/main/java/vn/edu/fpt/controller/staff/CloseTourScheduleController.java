package vn.edu.fpt.controller.staff;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.model.Tour;
import vn.edu.fpt.model.TourSchedule;

import java.io.IOException;

@WebServlet(name = "CloseTourScheduleController", urlPatterns = {"/staff/tour/schedule/close"})
public class CloseTourScheduleController extends StaffTourScheduleSupport {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/staff/tour/schedule?message=invalidAction");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        // Dong lich chi nhan POST tu nut tren trang detail, khong cho dong bang GET.
        Integer scheduleID = parsePositiveInt(request.getParameter("id"));
        TourSchedule schedule = scheduleID == null ? null : scheduleDAO.getScheduleById(scheduleID);

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
        // Chi lich Open/Planned cua tour con duoc quan ly moi duoc dong ban.
        if (!canCloseSchedule(tour, schedule)) {
            response.sendRedirect(request.getContextPath()
                    + "/staff/tour/schedule/detail?id=" + scheduleID
                    + "&message=noScheduleClosePermission");
            return;
        }

        boolean success = scheduleDAO.closeTourSchedule(scheduleID);
        response.sendRedirect(request.getContextPath()
                + "/staff/tour/schedule/detail?id=" + scheduleID
                + "&message=" + (success ? "scheduleCloseSuccess" : "scheduleCloseFail"));
    }

    private boolean canCloseSchedule(Tour tour, TourSchedule schedule) {
        if (!canManageScheduleForTour(tour) || schedule == null) {
            return false;
        }
        String status = safeTrim(schedule.getScheduleStatus());
        return "Open".equals(status) || "Planned".equals(status);
    }
}
