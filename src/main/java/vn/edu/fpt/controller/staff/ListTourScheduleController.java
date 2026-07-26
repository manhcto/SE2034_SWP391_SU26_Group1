package vn.edu.fpt.controller.staff;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.model.Tour;

import java.io.IOException;

@WebServlet(name = "ListTourScheduleController", urlPatterns = {"/staff/tour/schedule"})
public class ListTourScheduleController extends StaffTourScheduleSupport {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        Integer tourID = parsePositiveInt(request.getParameter("tourID"));

        if (tourID == null) {
            tourDAO.syncOpenSchedulesWithTourStatuses();
            request.setAttribute("tourList", tourDAO.getToursForStaff(null, null, null, null));
            request.setAttribute("scheduleList", tourDAO.getSchedulesForStaffOverview());
            request.setAttribute("messageCode", safeTrim(request.getParameter("message")));
            request.setAttribute("allSchedules", true);
            request.getRequestDispatcher("/views/staff/tour-schedule-list.jsp")
                    .forward(request, response);
            return;
        }

        Tour tour = getTourForSchedule(tourID);
        if (tour == null) {
            response.sendRedirect(request.getContextPath() + "/staff/tour?message=notFound");
            return;
        }

        request.setAttribute("tour", tour);
        request.setAttribute("scheduleList", tour.getScheduleList());
        request.setAttribute("readinessErrors", tourDAO.getTourReadinessErrors(tourID));
        request.setAttribute("readinessChecklist", tourDAO.getTourReadinessChecklist(tourID));
        request.setAttribute("duplicateStartDateMap", tourDAO.getDuplicateScheduleStartDateMap(tourID));
        request.setAttribute("schedulePriceWarningMap", tourDAO.getSchedulePriceWarningMap(tourID));
        request.setAttribute("messageCode", safeTrim(request.getParameter("message")));
        request.setAttribute("canManageSchedule", canManageScheduleForTour(tour));
        request.setAttribute("canEditSchedule", canEditScheduleForTour(tour));
        request.setAttribute("canOpenSchedule", canOpenScheduleForTour(tour));
        request.setAttribute("allSchedules", false);
        request.getRequestDispatcher("/views/staff/tour-schedule-list.jsp")
                .forward(request, response);
    }
}
